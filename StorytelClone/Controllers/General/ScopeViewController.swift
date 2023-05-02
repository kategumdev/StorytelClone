//
//  ScopeViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/5/23.
//

import UIKit

typealias PagingCvViewControllerDidSelectRowCallback = (_ selectedTitle: Title) -> ()
typealias EllipsisButtonInPagingCvViewControllerDidTapCallback = (Book) -> ()

class ScopeViewController: UIViewController {
    // MARK: - Instance properties
//    private let scopeButtonsView = SearchResultsScopeButtonsView()
//    private let scopeButtonKinds: [ScopeButtonKind]
    private let scopeButtonKinds: [ScopeButtonKind]
//    private lazy var scopeButtonsView = ScopeButtonsView(withButtonKinds: scopeButtonKinds)
    lazy var scopeButtonsView = ScopeButtonsView(withButtonKinds: scopeButtonKinds)
    
//    private let sectionHeaderTopAndBottomPadding: SectionHeaderTopAndBottomPadding
    private let pagingCollectionViewCellKind: PagingCollectionViewCellKind

//    private lazy var scopeButtonsView = ScopeButtonsView(withButtonKinds: ScopeButtonKind.kindsForSearchResults)

//    private let scopeButtonsView = ScopeButtonsView(withButtonKinds: ScopeButtonKind.kindsForSearchResults)

    var didSelectRowCallback: PagingCvViewControllerDidSelectRowCallback = {_ in}
    var ellipsisButtonDidTapCallback: EllipsisButtonInPagingCvViewControllerDidTapCallback = {_ in}
//    var ellipsisButtonDidTapCallback: EllipsisButtonInSearchResultsDidTapCallback = {_ in}
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Utils.customBackgroundColor
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    lazy var collectionViewBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utils.tabBarHeight)
    
    private lazy var separatorWidth: CGFloat = {
        let scale = UIScreen.main.scale
        if scale == 2.0 {
            return 0.25
        } else {
            return 0.35
        }
    }()
        
    private lazy var separatorLineView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = separatorWidth
        return view
    }()
    
    private var rememberedOffsetsOfTablesInCells = [ScopeButtonKind : CGPoint]()
    private var tappedButtonIndex: Int? = nil
    private var previousOffsetX: CGFloat = 0
    private var isButtonTriggeredScroll = false
    
    private var cellsToHideContent = [Int]()
    private var indexPathsToUnhide = [IndexPath]()
    
    var modelForSearchQuery: [ScopeButtonKind : [Title]]?
            
    // MARK: - Initializers
    init(withScopeButtonsKinds scopeButtonKinds: [ScopeButtonKind], pagingCollectionViewCellKind: PagingCollectionViewCellKind) {
        self.scopeButtonKinds = scopeButtonKinds
        self.pagingCollectionViewCellKind = pagingCollectionViewCellKind
        super.init(nibName: nil, bundle: nil)
    }
    
//    init(withScopeButtonsKinds scopeButtonKinds: [ScopeButtonKind], sectionHeaderPadding: SectionHeaderTopAndBottomPadding) {
//        self.scopeButtonKinds = scopeButtonKinds
//        self.sectionHeaderTopAndBottomPadding = sectionHeaderPadding
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    init(withScopeButtonsKinds scopeButtonKinds: [ScopeButtonKind]) {
//        self.scopeButtonKinds = scopeButtonKinds
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        view.addSubview(separatorLineView)
        view.addSubview(scopeButtonsView)
        configureScopeButtonsView()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        applyConstraints()
        setInitialOffsetsOfTablesInCells()
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            separatorLineView.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    // MARK: - Instance methods
    func setInitialOffsetsOfTablesInCells() {
        let buttonKinds = scopeButtonsView.buttonKinds
        buttonKinds.forEach { rememberedOffsetsOfTablesInCells[$0] = CGPoint(x: 0.0, y: 0.0) }
    }
    
//    func revertToInitialAppearance() {
//        scopeButtonsView.revertToInitialAppearance()
//
//        // For rare cases if user taps on button and immediately taps Cancel button, isButtonTriggeredScroll won't be set to false and and cell will remain hidden when user taps into search bar again and search controller becomes visible
//        toggleIsButtonTriggeredScrollAndUnhideCells()
//
//        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
//        setInitialOffsetsOfTablesInCells()
//        collectionView.reloadData()
//
//        let firstButton = scopeButtonsView.scopeButtons[0]
//        scopeButtonsView.toggleButtonsColors(currentButton: firstButton)
//    }
    
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
        return scopeButtonsView.scopeButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as? SearchResultsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.kind = pagingCollectionViewCellKind
//        cell.sectionHeaderTopAndBottomPadding = sectionHeaderTopAndBottomPadding.rawValue
        
        let buttonKind = scopeButtonsView.buttonKinds[indexPath.row]
        print("cell \(buttonKind) is configured")
        cell.buttonKind = buttonKind
        
//        switch pagingCollectionViewCellKind {
//        case .forSearchResults:
//            if let model = modelForSearchQuery, let cellModel = model[buttonKind] {
//                cell.model = cellModel
//                cell.withSectionHeader = false
//            } else {
//                cell.model = getInitialModelFor(buttonKind: buttonKind)
//                cell.withSectionHeader = true
//            }
//        case .forBookshelf:
//            cell.model = getInitialModelFor(buttonKind: buttonKind)
//            cell.withSectionHeader = true
//        }
        
        if let model = modelForSearchQuery, let cellModel = model[buttonKind] {
            cell.model = cellModel
            cell.withSectionHeader = false
        } else {
            cell.model = getInitialModelFor(buttonKind: buttonKind)
            cell.withSectionHeader = true
        }
        
//        cell.searchResultsDidSelectRowCallback = searchResultsDidSelectRowCallback
        cell.searchResultsDidSelectRowCallback = didSelectRowCallback
        cell.ellipsisButtonDidTapCallback = ellipsisButtonDidTapCallback
        cell.delegate = self
        
        if let offset = rememberedOffsetsOfTablesInCells[buttonKind] {
            cell.rememberedOffset = offset
        }
        
        if isButtonTriggeredScroll && cellsToHideContent.contains(indexPath.row) {
            cell.resultsTable.isHidden = true
            return cell
        }
        
        cell.resultsTable.isHidden = false
        cell.resultsTable.reloadData()
        
        
       // To ensure that it will be called only after the reloadData() method has finished its previous layout pass and updated the UI on the main thread
        DispatchQueue.main.async {
//            print("offset set in async block")
            cell.resultsTable.contentOffset = cell.rememberedOffset
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as? SearchResultsCollectionViewCell else { return UICollectionViewCell() }
//
//        cell.kind = pagingCollectionViewCellKind
////        cell.sectionHeaderTopAndBottomPadding = sectionHeaderTopAndBottomPadding.rawValue
//
//        let buttonKind = scopeButtonsView.buttonKinds[indexPath.row]
//        print("cell \(buttonKind) is configured")
//        cell.buttonKind = buttonKind
//
//        if let model = modelForSearchQuery, let cellModel = model[buttonKind] {
//            cell.model = cellModel
//            cell.withSectionHeader = false
//        } else {
//            cell.model = getInitialModelFor(buttonKind: buttonKind)
//            cell.withSectionHeader = true
//        }
//
////        cell.searchResultsDidSelectRowCallback = searchResultsDidSelectRowCallback
//        cell.searchResultsDidSelectRowCallback = didSelectRowCallback
//        cell.ellipsisButtonDidTapCallback = ellipsisButtonDidTapCallback
//        cell.delegate = self
//
//        if let offset = rememberedOffsetsOfTablesInCells[buttonKind] {
//            cell.rememberedOffset = offset
//        }
//
//        if isButtonTriggeredScroll && cellsToHideContent.contains(indexPath.row) {
//            cell.resultsTable.isHidden = true
//            return cell
//        }
//
//        cell.resultsTable.isHidden = false
//        cell.resultsTable.reloadData()
//
//
//       // To ensure that it will be called only after the reloadData() method has finished its previous layout pass and updated the UI on the main thread
//        DispatchQueue.main.async {
////            print("offset set in async block")
//            cell.resultsTable.contentOffset = cell.rememberedOffset
//        }
//
//        return cell
//    }
    
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
//        print("current contentOffset.x: \(scrollView.contentOffset.x)")
        let currentOffsetX = scrollView.contentOffset.x
        let pageWidth = collectionView.bounds.size.width
        let currentButtonIndex = scopeButtonsView.getCurrentButtonIndex()
        let currentButton = scopeButtonsView.scopeButtons[currentButtonIndex]
        
        // Adjust sliding line leading anchor constant
        let ranges = scopeButtonsView.rangesOfButtons
        let previousButtonUpperBound = currentButtonIndex != 0 ? ranges[currentButtonIndex - 1].upperBound : 0.0
        
        let currentOffsetXInRangeOfPageWidth = currentButtonIndex == 0 ? currentOffsetX : currentOffsetX - (CGFloat(currentButtonIndex) * pageWidth)
        
        let currentButtonWidth = currentButton.bounds.size.width
        let slidingLineXProportionalPart = currentOffsetXInRangeOfPageWidth / pageWidth * currentButtonWidth
        
        let leadingConstant = previousButtonUpperBound + slidingLineXProportionalPart
        
        scopeButtonsView.slidingLineLeadingAnchor.constant = leadingConstant
                
        // Adjust contentOffset.x of scroll of buttonsView
        scopeButtonsView.adjustScrollViewOffsetX(currentOffsetXOfCollectionView: currentOffsetX, withPageWidth: pageWidth)
        
        let currentScrollDirection: ScrollDirection = currentOffsetX > previousOffsetX ? .forward : .back
        previousOffsetX = currentOffsetX
        
        // Toggle buttons' colors
        if currentScrollDirection == .back {
            scopeButtonsView.toggleButtonsColors(currentButton: currentButton)
        } else {
            // Determine current button, because the way of determining currentButton above uses half-open range and it doesn't work for this particular case
            let currentButtonIndex = Int(currentOffsetX / pageWidth)
            let currentButton = scopeButtonsView.scopeButtons[currentButtonIndex]
            scopeButtonsView.toggleButtonsColors(currentButton: currentButton)
        }

        // Adjust sliding line width
        scopeButtonsView.adjustSlidingLineWidthWhen(currentScrollDirectionOfCv: currentScrollDirection, currentButtonIndex: currentButtonIndex, slidingLineXProportionalPart: slidingLineXProportionalPart, currentOffsetXOfCvInRangeOfOnePageWidth: currentOffsetXInRangeOfPageWidth, pageWidthOfCv: pageWidth)
    }

}

// MARK: - Helper methods
extension ScopeViewController {
    func toggleIsButtonTriggeredScrollAndUnhideCells() {
        // When button on buttonsView is tapped, this property is set to true. It's needed for use in guard in didScroll to avoid executing logic for adjusting buttonsView. Toggling it to false lets that logic to execute when didScroll is triggered by user's swiping
        if isButtonTriggeredScroll == true {
            isButtonTriggeredScroll = false
            
            // Unhide those cells that are hidden and ready to become visible
            collectionView.reloadItems(at: indexPathsToUnhide)
        }
    }
    
    // This function should fetch needed initial objects when user haven't perform any search yet
    private func getInitialModelFor(buttonKind: ScopeButtonKind) -> [Title] {
        switch buttonKind {
        case .top:
            return [Storyteller.tolkien, Book.book3, Series.series1, Book.book21,
                            Book.book15, Storyteller.author3, Storyteller.neilGaiman, Book.book18, Book.book20,
                            Storyteller.author9, Storyteller.author5]
            
        case .books:
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
//                return allTitlesBooks
            return toReadBooks
        case .started:
            return [Book]()
        case .finished:
            return [Book]()
        case .downloaded:
            return [Book]()
        }
        #warning("started, finished and dowloaded cases have to return values")
    }
    
//    private func getInitialModelFor(buttonKind: ScopeButtonKind) -> [Title] {
//        switch buttonKind {
//        case .top:
//            return [Storyteller.tolkien, Book.book3, Series.series1, Book.book21,
//                    Book.book15, Storyteller.author3, Storyteller.neilGaiman, Book.book18, Book.book20,
//                    Storyteller.author9, Storyteller.author5]
//        case .books:
//            return [Book.book1, Book.book23, Book.senorDeLosAnillos1, Book.book2, Book.book22, Book.book5, Book.book20,
//                    Book.book7, Book.book8, Book.book21, Book.book9, Book.book18, Book.book17,
//                    Book.book15, Book.book4, Book.book6, Book.book19]
//        case .authors: return Storyteller.authors
//        case .narrators: return Storyteller.narrators
//        case .series:
//            return [Series.series1, Series.series3, Series.series3, Series.series1, Series.series1,
//                    Series.series3, Series.series2, Series.series1, Series.series2, Series.series2,
//                    Series.series3, Series.series3, Series.series1, Series.series1, Series.series1,]
//        case .tags: return Tag.tags
//        }
//    }

    private func configureScopeButtonsView() {
        // Respond to button actions in buttonsView
        scopeButtonsView.scopeButtonDidTapCallback = { [weak self] buttonIndex in
            guard let self = self else { return }
            // To avoid logic in didScroll to perform if scroll is triggered by button tap
            self.isButtonTriggeredScroll = true
            self.scrollToCell(buttonIndex)
        }
    }
    
    private func scrollToCell(_ cellIndex: Int) {
        let tappedButtonIndex = cellIndex
        let currentButtonIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        guard tappedButtonIndex != currentButtonIndex else {
//            print("same indices, same cell is tapped two times in a row")
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
            scopeButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ScopeButtonsView.viewHeight)
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
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utils.tabBarHeight)
        ])
        collectionViewBottomAnchor.isActive = true
    }
    
}

// MARK: - SearchResultsCollectionViewCellDelegate
extension ScopeViewController: SearchResultsCollectionViewCellDelegate {
    func searchResultsCollectionViewCell(_ searchResultsCollectionViewCell: SearchResultsCollectionViewCell, withButtonKind buttonKind: ScopeButtonKind, hasOffset offset: CGPoint) {
        rememberedOffsetsOfTablesInCells[buttonKind] = offset
    }
}

