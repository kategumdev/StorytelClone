//
//  BottomSheetViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/4/23.
//

import UIKit

protocol BottomSheetViewControllerDelegate: AnyObject {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book)
}

class BottomSheetViewController: UIViewController {
    enum BottomSheetKind: Equatable {
        case bookDetails
        case storytellers(storytellers: [Storyteller])
    }
    
    // MARK: Instance properties
    private var kind: BottomSheetKind
    private var book: Book
    private let dataPersistenceManager: any DataPersistenceManager
    private var isSwiping = false
    
    weak var delegate: BottomSheetViewControllerDelegate?
    
    private lazy var bookDetailsBottomSheetCells: [BookDetailsBottomSheetCellKind] = {
        var cells = BookDetailsBottomSheetCellKind.allCases
        
        if book.series == nil {
            cells = cells.filter { $0 != .viewSeries }
        }
        
        if book.narrators.isEmpty {
            cells = cells.filter { $0 != .viewNarrators }
        }
        return cells
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor(named: "bottomSheetBackground")
        tableView.clipsToBounds = true
        tableView.separatorColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.register(
            BottomSheetTableViewCell.self,
            forCellReuseIdentifier: BottomSheetTableViewCell.identifier)
        tableView.estimatedRowHeight = tableRowHeight
        tableView.rowHeight = tableRowHeight
        tableView.tableHeaderView = tableHeaderView
        
        // These two lines avoid constraints' conflict of header when vc's view just loaded
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView?.fillSuperview()
        return tableView
    }()
    
    private let tableRowHeight: CGFloat = 48
    
    private let tableHeightWithoutCells: CGFloat = 28
    private var currentTableViewHeight: CGFloat = 0
    private lazy var tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
    
    private lazy var fullTableViewHeight: CGFloat = {
        var multiplier: Int
        switch kind {
        case .bookDetails: multiplier = bookDetailsBottomSheetCells.count
        case let .storytellers(storytellers: storytellers):
            multiplier = storytellers.count
        }
        let height = tableHeightWithoutCells + tableHeaderHeight + tableRowHeight * CGFloat(multiplier)
        currentTableViewHeight = height
        return height
    }()
    
    private lazy var tableHeaderView: BottomSheetTableHeaderView = {
        let addSeparatorView = kind == .bookDetails ? false : true
        let headerView = BottomSheetTableHeaderView(
            titleText: tableHeaderTitleText,
            withSeparatorView: addSeparatorView)
        headerView.closeButtonDidTapCallback = { [weak self] in
            self?.dismissWithCustomAnimation()
        }
        return headerView
    }()
    
    private lazy var tableHeaderHeight: CGFloat = {
        let height: CGFloat = kind == .bookDetails ? 42 : 48
        return height
    }()
    
    private lazy var tableHeaderTitleText: String = {
        switch kind {
        case .bookDetails: return book.title
        case let .storytellers(storytellers: storytellers):
            let text = storytellers.first?.titleKind == .author ? "Authors" : "Narrators"
            return text
        }
    }()
    
    private let maxAlphaForDimmedEffect: CGFloat = 0.35
    
    private var panGesture: UIPanGestureRecognizer?
    private var swipeGesture: UISwipeGestureRecognizer?
    
    // MARK: - Initializers
    init(
        book: Book,
        kind: BottomSheetKind,
        dataPersistenceManager: some DataPersistenceManager = CoreDataManager.shared
    ) {
        self.book = book
        self.kind = kind
        self.dataPersistenceManager = dataPersistenceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = true
        tableHeaderView.frame.size = CGSize(width: tableView.bounds.width, height: tableHeaderHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToFullTableViewHeight()
        setupPanGesture()
        setupTapGesture()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch kind {
        case .bookDetails: return bookDetailsBottomSheetCells.count
        case let .storytellers(storytellers: storytellers): return storytellers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BottomSheetTableViewCell.identifier,
            for: indexPath) as? BottomSheetTableViewCell else { return UITableViewCell() }
        
        switch kind {
        case .bookDetails:
            cell.configureFor(
                book: book,
                bookDetailsBottomSheetCellKind: bookDetailsBottomSheetCells[indexPath.row])
        case let .storytellers(storytellers: storytellers):
            cell.configureWith(storyteller: storytellers[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch kind {
        case .bookDetails:
            let ellipsisButtonCell = bookDetailsBottomSheetCells[indexPath.row]
            handleSelection(bookDetailsBottomSheetCell: ellipsisButtonCell, withIndexPath: indexPath)
        case let .storytellers(storytellers: storytellers):
            let selectedStoryteller = storytellers[indexPath.row]
            self.dismiss(animated: false) { [weak self] in
                guard let self = self, let delegate = self.delegate as? UIViewController else { return}
                let controller = AllTitlesViewController(
                    subCategory: SubCategory.generalForAllTitlesVC,
                    titleModel: selectedStoryteller)
                delegate.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // To make tapGesture to be handled only if tap is outside the tableView
        if touch.view?.isDescendant(of: tableView) == true {
            return false
        }
        return true
    }
}

// MARK: - Helper methods
extension BottomSheetViewController {
    private func setupUI() {
        setViewBackgroundColorAlphaTo(value: 0)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        applyConstraints()
        
        // Hide tableView
        tableHeightConstraint.constant = 0
    }
    
    private func animateToFullTableViewHeight() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                // Show tableView
                self.tableHeightConstraint.constant = self.fullTableViewHeight
                self.view.layoutIfNeeded()
                self.setViewBackgroundColorAlphaTo(value: self.maxAlphaForDimmedEffect)
            },
            completion: nil)
    }
    
    private func setViewBackgroundColorAlphaTo(value: CGFloat) {
        view.backgroundColor = .black.withAlphaComponent(value)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesure() {
        dismissWithCustomAnimation()
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.handlePanGesture(gesture:)))
        
        // Change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        tableView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // If value is < 0, user is dragging up
        let isDraggingDown = translation.y > 0
        
        let newTableViewHeight = currentTableViewHeight - translation.y
        
        // Calculations for smooth proportional change of alpha value of the dimmed view
        let percentageFromFullTableViewHeight = (newTableViewHeight * 100) / fullTableViewHeight
        let newAlphaForDimmedEffect = (percentageFromFullTableViewHeight * maxAlphaForDimmedEffect) / 100
        
        switch gesture.state {
        case .changed:
            if isDraggingDown {
                setViewBackgroundColorAlphaTo(value: newAlphaForDimmedEffect)
                tableHeightConstraint.constant = newTableViewHeight
                
                // If velocity of panGesture is less than 1500, it's a swipe
                isSwiping = gesture.velocity(in: tableView).y < 1500 ? false : true
            }
        case .ended:
            if isSwiping == true || translation.y >= fullTableViewHeight / 2 {
                dismissWithCustomAnimation()
                break
            }
            animateToFullTableViewHeight()
        default:
            break
        }
    }
    
    private func handleSelection(
        bookDetailsBottomSheetCell: BookDetailsBottomSheetCellKind,
        withIndexPath indexPath: IndexPath
    ) {
        switch bookDetailsBottomSheetCell {
        case .saveBook:
            dataPersistenceManager.fetchPersistedBookWith(id: book.id) { [weak self] result in
                switch result {
                case .success(let persistedBook):
                    if persistedBook == nil {
                        self?.handleAddingBookWith(indexPath: indexPath)
                    } else {
                        self?.handleRemoving(persistedBook: persistedBook, indexPath: indexPath)
                    }
                case .failure(let error):
                    print("Error fetching book" + error.localizedDescription)
                }
            }
        case .markAsFinished:
            print("markAsFinished tap not implemented")
        case .download:
            print("download tap not implemented")
        case .viewSeries:
            self.dismiss(animated: false)
            guard let series = book.series,
                  let delegate = self.delegate as? UIViewController else { return }
            let subCategory = SubCategory(title: series, searchQuery: "\(series)")
            let controller = AllTitlesViewController(subCategory: subCategory, titleModel: Series.series1)
            delegate.navigationController?.pushViewController(controller, animated: true)
        case .viewAuthors:
            let authors = book.authors
            handleViewAuthorsOrNarrators(storytellers: authors)
        case .viewNarrators:
            let narrators = book.narrators
            handleViewAuthorsOrNarrators(storytellers: narrators)
        case .showMoreTitlesLikeThis:
            handleShowMoreTitlesLikeThis()
        case .share:
            print("share tap not implemented")
        }
    }
    
    private func handleAddingBookWith(indexPath: IndexPath) {
        dataPersistenceManager.addPersistedBookOf(book: book) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.tableView.reloadRows(at: [indexPath], with: .none)
                // Update cell with this book in AllTitlesViewController
                self.delegate?.bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook: self.book)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleRemoving(persistedBook: PersistedBook?, indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Remove from bookshelf",
            message: "Do you want to remove \(book.title) from your bookshelf? " +
            "Downloaded content for this title will also be removed from your device.",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        
        cancelAction.setValue(UIColor.label, forKey: "titleTextColor")
        
        let removeAction = UIAlertAction(
            title: "Remove",
            style: .destructive,
            handler: { [weak self] _ in
                guard let self = self, let persistedBookToDelete = persistedBook else { return }
                self.dataPersistenceManager.delete(persistedBook: persistedBookToDelete) { result in
                    switch result {
                    case .success():
                        // Update cell with this book in AllTitlesViewController (parent vc, visible beneath)
                        self.delegate?.bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook: self.book)
                        
                        // Dismiss this bottom sheet
                        self.dismissWithCustomAnimation()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
        
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func handleViewAuthorsOrNarrators(storytellers: [Storyteller]) {
        if storytellers.count == 1 {
            self.dismiss(animated: false, completion: { [weak self] in
                guard let self = self, let delegate = self.delegate as? UIViewController else { return }
                let vc = AllTitlesViewController(
                    subCategory: SubCategory.generalForAllTitlesVC,
                    titleModel: storytellers.first)
                delegate.navigationController?.pushViewController(vc, animated: true)
            })
            return
        }
        
        // For cases when storytellers.count > 1
        self.dismissWithCustomAnimation(completion: { [weak self] in
            guard let self = self, let delegate = self.delegate as? UIViewController else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let storytellersBottomSheetController = BottomSheetViewController(
                    book: self.book,
                    kind: .storytellers(storytellers: storytellers))
                storytellersBottomSheetController.delegate = delegate as? BottomSheetViewControllerDelegate
                storytellersBottomSheetController.modalPresentationStyle = .overFullScreen
                delegate.present(storytellersBottomSheetController, animated: false)
            }
        })
    }
    
    private func dismissWithCustomAnimation(completion: (() -> ())? = nil) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                self.tableHeightConstraint.constant = 0 // Hide tableView
                self.view.layoutIfNeeded()
                self.setViewBackgroundColorAlphaTo(value: 0)
            }, completion: { _ in
                self.dismiss(animated: false, completion: {
                    completion?()
                })
            })
    }
    
    private func handleShowMoreTitlesLikeThis() {
        self.dismiss(animated: false)
        let vc = CategoryViewController(category: Category.librosSimilares, referenceBook: book)
        (delegate as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func applyConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableHeightConstraint.isActive = true
    }
}
