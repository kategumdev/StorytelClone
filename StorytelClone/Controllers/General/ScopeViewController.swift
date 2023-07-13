//
//  ScopeViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/5/23.
//

import UIKit

class ScopeViewController: UIViewController {
    // MARK: - Instance properties
    private let dataPersistenceManager: any DataPersistenceManager
    private let scopeButtonsViewKind: ScopeButtonsViewKind
    lazy var scopeButtonsView = ScopeButtonsView(kind: scopeButtonsViewKind)
    
    var didSelectRowCallback: ScopeTableViewDidSelectRowCallback = {_ in}
    var ellipsisButtonDidTapCallback: EllipsisButtonInScopeBookTableViewCellDidTapCallback = {_ in}
    
    private let cellIdentifier = "cellIdentifier"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.customBackgroundColor
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    lazy var collectionViewBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UITabBar.tabBarHeight)
    
    private lazy var separatorWidth: CGFloat = {
        let scale = UIScreen.main.scale
        // Ensure separator is visible on devices with different scales
        let width = scale == 2.0 ? 0.25 : 0.35
        return width
    }()
        
    private lazy var separatorLineView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = separatorWidth
        return view
    }()
    
    private var previousOffsetX: CGFloat = 0
    private var isButtonTriggeredScroll = false
    
    private var cellsToHideContent = [Int]()
    private var indexPathsToUnhide = [IndexPath]()
    
    var modelForSearchQuery: [ScopeButtonKind : [Title]]? {
        didSet {
            setInitialOffsetsOfTablesInCells()
            collectionView.reloadData()
        }
    }

    /// Table views for each collection view cell
    var scopeTableViews = [ScopeTableView]()
            
    // MARK: - Initializers
    init(withScopeButtonsViewKind scopeButtonsViewKind: ScopeButtonsViewKind, dataPersistenceManager: some DataPersistenceManager = CoreDataManager.shared) {
        self.scopeButtonsViewKind = scopeButtonsViewKind
        self.dataPersistenceManager = dataPersistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBackgroundColor
        view.addSubview(separatorLineView)
        view.addSubview(scopeButtonsView)
        configureScopeButtonsView()
        createScopeTableViews()
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        applyConstraints()
    }
    
    // MARK: -
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            separatorLineView.layer.borderColor = UIColor.label.cgColor
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ScopeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ScopeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scopeButtonsView.buttonsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

        if isButtonTriggeredScroll && cellsToHideContent.contains(indexPath.row) {
            cell.isHidden = true
            return cell
        }
        
        cell.isHidden = false

        let scopeTableViewForCell = scopeTableViews[indexPath.row]
        let buttonKind = scopeTableViewForCell.buttonKind

        if let collectionModel = modelForSearchQuery, let tableViewModel = collectionModel[buttonKind] {
            scopeTableViewForCell.model = tableViewModel
            scopeTableViewForCell.hasSectionHeader = false
        } else {
            print("scopeTable is getting initial model")
            scopeTableViewForCell.model = getModelFor(buttonKind: buttonKind)
            scopeTableViewForCell.hasSectionHeader = true
        }

        scopeTableViewForCell.tableViewDidSelectRowCallback = didSelectRowCallback
        scopeTableViewForCell.ellipsisButtonDidTapCallback = ellipsisButtonDidTapCallback
        
        cell.addSubview(scopeTableViewForCell)
        scopeTableViewForCell.frame = cell.bounds
        scopeTableViewForCell.reloadData()
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ScopeViewController {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        toggleIsButtonTriggeredScrollAndUnhideCells()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toggleIsButtonTriggeredScrollAndUnhideCells()
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isButtonTriggeredScroll else { return }
        let cvPageWidth = collectionView.bounds.size.width
        let currentOffsetX = scrollView.contentOffset.x
        scopeButtonsView.respondToScrollInCvWith(
            pageWidth: cvPageWidth,
            currentOffsetX: currentOffsetX,
            previousOffsetX: previousOffsetX)
        
        previousOffsetX = currentOffsetX
    }
}

extension ScopeViewController {
    // MARK: - Instance methods
    func setInitialOffsetsOfTablesInCells() {
        scopeTableViews.forEach { $0.contentOffset = CGPoint(x: 0.0, y: 0.0) }
    }
    
    func toggleIsButtonTriggeredScrollAndUnhideCells() {
        // When button on buttonsView is tapped, this property is set to true. It's needed for use in guard in didScroll to avoid executing logic for adjusting buttonsView. Toggling it to false lets that logic to execute when didScroll is triggered by user's swiping
        if isButtonTriggeredScroll == true {
            isButtonTriggeredScroll = false
            
            // Unhide those cells that are hidden and ready to become visible
            collectionView.reloadItems(at: indexPathsToUnhide)
        }
    }
    
    // For SearchResultsController, this function should fetch needed initial objects when user haven't perform any search yet. For BookshelfViewController: fetch the needed objects
    func getModelFor(buttonKind: ScopeButtonKind) -> [Title] {
        switch buttonKind {
        case .top:
            return [Storyteller.tolkien, Book.book3, Series.series1, Book.book21,
                            Book.book15, Storyteller.author3, Storyteller.neilGaiman, Book.book18, Book.book20,
                            Storyteller.author9, Storyteller.author5]
            
        case .books:
//            var book23 = Book.book23
//            book23.coverImage = nil
            return [Book.book1, Book.book23, Book.senorDeLosAnillos1, Book.book2, Book.book22, Book.book5, Book.book20,
                    Book.book7, Book.book8, Book.book21, Book.book9, Book.book18, Book.book17,
                    Book.book15, Book.book4, Book.book6, Book.book19]
            
        case .authors: return Storyteller.authors
        case .narrators: return Storyteller.narrators
        case .series:
            return [Series.series1, Series.series3, Series.series3, Series.series1, Series.series1,
                    Series.series3, Series.series2, Series.series1, Series.series2, Series.series2,
                    Series.series3, Series.series3, Series.series1, Series.series1, Series.series1]
        case .tags:
            return Tag.tags
        case .toRead:
            var fetchedBooks = [Book]()
            dataPersistenceManager.fetchPersistedBooks { result in
                switch result {
                case .success(let books):
                    fetchedBooks = books
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return fetchedBooks
            
        case .started:
            return [Book]()
        case .finished:
            return [Book]()
        case .downloaded:
            return [Book]()
        }
        
    }
    
    // MARK: - Helper methods
    private func configureScopeButtonsView() {
        // Respond to button actions in buttonsView
        scopeButtonsView.btnDidTapCallback = { [weak self] buttonIndex in
            guard let self = self else { return }
            // To avoid logic in didScroll to perform if scroll is triggered by button tap
            self.isButtonTriggeredScroll = true
            self.scrollToCell(buttonIndex)
        }
    }
    
    private func createScopeTableViews() {
        for buttonKind in scopeButtonsViewKind.buttonKinds {
            let table = ScopeTableView(buttonKind: buttonKind, scopeButtonsViewKind: scopeButtonsViewKind)
            scopeTableViews.append(table)
        }
    }
    
    private func scrollToCell(_ cellIndex: Int) {
        let tappedButtonIndex = cellIndex
        let currentButtonIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // Handle case when same button is tapped two times in a row
        guard tappedButtonIndex != currentButtonIndex else {
            // To avoid behavior when it is set to true, because code below in this method won't be triggered and therefore no cells need to be hidden
            isButtonTriggeredScroll = false
            return
        }

        // Get array of indices of buttons between current and tapped one (excl current and tapped)
        let range: Range<Int> = currentButtonIndex < tappedButtonIndex ? currentButtonIndex + 1..<tappedButtonIndex : tappedButtonIndex + 1..<currentButtonIndex
        
        var buttonsIndicesBetween = [Int]()
        range.forEach { buttonsIndicesBetween.append($0) }
        
        // Save to hide content when cells in between will be reused while scrollToItem performs to imitate UIPageViewController behavior
        cellsToHideContent = buttonsIndicesBetween
        
        // Reload cells in between that are already reused and ready to become visible
        var indexPaths = [IndexPath]()
        for index in buttonsIndicesBetween {
            let indexPath = IndexPath(item: index, section: 0)
            indexPaths.append(indexPath)
        }
        
        collectionView.reloadItems(at: indexPaths)
        indexPathsToUnhide = indexPaths
    
        let indexPath = IndexPath(item: tappedButtonIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func applyConstraints() {
        scopeButtonsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scopeButtonsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scopeButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scopeButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scopeButtonsView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: scopeButtonsView.viewHeight)
        ])
        
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        // Constants added to hide borders of buttonsView on leading and trailing sides
        NSLayoutConstraint.activate([
            separatorLineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            separatorLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorLineView.heightAnchor.constraint(equalTo: scopeButtonsView.heightAnchor, constant: separatorWidth)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        collectionViewBottomAnchor.isActive = true
    }
    
}
