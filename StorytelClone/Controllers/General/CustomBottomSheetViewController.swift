//
//  CustomBottomSheetViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/4/23.
//

import UIKit

enum EllipsisBottomSheetCell: String, CaseIterable {
    case addRemoveToBookshelf = "heart"
    case markAsFinished = "checkmark"
    case download = "arrow.down.circle"
    case viewSeries = "rectangle.stack"
    case viewAuthors = "pencil"
    case viewNarrators = "mic"
    case showMoreTitlesLikeThis = "square.grid.3x2"
    case share = "paperplane"
}

enum BottomSheetKind {
    case ellipsis
    case authors
    case narrators
}

class CustomBottomSheetViewController: UIViewController {

    // MARK: Instance properties
    private var book: Book
    private var kind: BottomSheetKind = .ellipsis
    private var isSwiping = false

    private lazy var ellipsisBottomSheetCells: [EllipsisBottomSheetCell] = {
        var cells = EllipsisBottomSheetCell.allCases
        
        if book.series == nil {
            cells = cells.filter { $0 != .viewSeries }
        }
        
        if book.narrators.isEmpty {
            cells = cells.filter { $0 != .viewNarrators }
        }
        return cells
    }()
    
    private lazy var windowDimmedView: UIView? = {
//        print("windowDimmedView created and added to view")
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .black

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        view.frame = window!.frame
        window!.addSubview(view)
        return view
    }()
    
    private let maxDimmedViewAlpha: CGFloat = 0.35
    
    private lazy var tableHeaderView: BottomSheetTableHeaderView = {
        let addSeparatorView = kind == .ellipsis ? false : true
        let headerView = BottomSheetTableHeaderView(titleText: tableHeaderTitleText, withSeparatorView: addSeparatorView)
        headerView.closeButtonDidTapCallback = { [weak self] in
            self?.dismissWithCustomAnimation()
        }
        return headerView
    }()
    
    private lazy var tableHeaderHeight: CGFloat = {
        let height: CGFloat = kind == .ellipsis ? 42 : 48
        return height
    }()
    
    private lazy var tableHeaderTitleText: String = {
        switch kind {
        case .ellipsis: return book.title
        case .authors: return "Authors"
        case .narrators: return "Narrators"
        }
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor(named: "bottomSheetBackground")
        tableView.clipsToBounds = true
        tableView.separatorColor = .clear
        tableView.layer.cornerRadius = 10
        
        tableView.register(StorytellerBottomSheetTableViewCell.self, forCellReuseIdentifier: StorytellerBottomSheetTableViewCell.identifier)
        
        tableView.estimatedRowHeight = tableRowHeight
        tableView.rowHeight = tableRowHeight
        
        tableView.tableHeaderView = tableHeaderView
        
        // These two lines avoid constraints' conflict of header when view just loaded
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView?.fillSuperview()
        return tableView
    }()
    
    private let tableRowHeight: CGFloat = 48
    private let tableViewHeightWithoutCells: CGFloat = 28
    private var currentTableViewHeight: CGFloat = 0
    
    private lazy var defaultTableViewHeight: CGFloat = {
        var multiplier: Int
        switch kind {
        case .ellipsis: multiplier = ellipsisBottomSheetCells.count
        case .authors: multiplier = book.authors.count
        case .narrators: multiplier = book.narrators.count
        }
        let height = tableViewHeightWithoutCells + tableHeaderHeight + tableRowHeight * CGFloat(multiplier)
        currentTableViewHeight = height
        return height
    }()
    
    private lazy var tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
    var addRemoveToBookshelfDidTapCallback: () -> () = {}
    var viewAuthorsDidTapCallback: ([Title]) -> () = {_ in}
    var tableViewDidSelectTitleCallback: (Title) -> () = {_ in}
    
    // MARK: - Initializers
    init(book: Book, kind: BottomSheetKind) {
        print("\n\nbottom sheet for \(kind) CREATED")
        self.book = book
        self.kind = kind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("BottomSheetVC \(kind) DEINIT")
        self.windowDimmedView?.removeFromSuperview()
        self.windowDimmedView = nil
//        print("nil out dimmedView: \(String(describing: self.windowDimmedView))")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        applyConstraints()
        
        // Place table view out of visible bounds of the screen
        tableViewBottomConstraint.constant = defaultTableViewHeight
        
        // Every new instance gets different initial default table view height
        tableViewHeightConstraint.constant = defaultTableViewHeight
        
        windowDimmedView?.alpha = 0
        
//        setupPanGesture()
//        setupTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = true
        tableHeaderView.frame.size = CGSize(width: tableView.bounds.width, height: tableHeaderHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentingTableView()
        setupPanGesture()
        setupTapGesture()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CustomBottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch kind {
        case .ellipsis: return ellipsisBottomSheetCells.count
        case .authors: return book.authors.count
        case .narrators: return book.narrators.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StorytellerBottomSheetTableViewCell.identifier, for: indexPath) as? StorytellerBottomSheetTableViewCell else { return UITableViewCell() }
        
        switch kind {
        case .ellipsis:
            cell.configureFor(book: book, ellipsisButtonCell: ellipsisBottomSheetCells[indexPath.row])
        case .authors:
            cell.configureWith(storyteller: book.authors[indexPath.row])
        case .narrators:
            cell.configureWith(storyteller: book.narrators[indexPath.row])
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch kind {
        case .ellipsis:
            let ellipsisButtonCell = ellipsisBottomSheetCells[indexPath.row]
            handleSelection(ellipsisButtonCell: ellipsisButtonCell, withIndexPath: indexPath)
        case .authors:
            let selectedTitle = book.authors[indexPath.row]
            tableViewDidSelectTitleCallback(selectedTitle)
        case .narrators:
            let selectedTitle = book.narrators[indexPath.row]
            tableViewDidSelectTitleCallback(selectedTitle)
        }
    }
    
}

extension CustomBottomSheetViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("BottomSheetVC UIGestureRecognizerDelegate for tapGesture")
         if touch.view?.isDescendant(of: tableView) == true {
            return false
         }
         return true
    }
}



// MARK: - Helper methods
extension CustomBottomSheetViewController {
    
    private func handleSelection(ellipsisButtonCell: EllipsisBottomSheetCell, withIndexPath indexPath: IndexPath) {
        
        switch ellipsisButtonCell {
        case .addRemoveToBookshelf:
            if book.isAddedToBookshelf {
                handleRemovingBookWith(indexPath: indexPath)
            } else {
                handleAddingBookWith(indexPath: indexPath)
            }
            
        case .markAsFinished:
            print("markAsFinished tapped")
        case .download:
            print("download tapped")
        case .viewSeries:
            print("viewSeries tapped")
        case .viewAuthors:
            let authors = book.authors
            handleViewAuthorsOrNarrators(storytellers: authors)
            
        case .viewNarrators:
            let narrators = book.narrators
            handleViewAuthorsOrNarrators(storytellers: narrators)
            
        case .showMoreTitlesLikeThis:
            print("showMoreTitlesLikeThis tapped")
        case .share:
            print("share tapped")
        }
    }
    
    private func handleAddingBookWith(indexPath: IndexPath) {
        // Update book of this instance
        book.isAddedToBookshelf = !book.isAddedToBookshelf
        
        // Update book in data model
        book.update(isAddedToBookshelf: book.isAddedToBookshelf)
        
        // Reload row
        tableView.reloadRows(at: [indexPath], with: .none)
        
        // Update cell with this book in AllTitlesViewController
        addRemoveToBookshelfDidTapCallback()
    }
    
    private func handleRemovingBookWith(indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Remove from bookshelf",
            message: "Do you want to remove \(book.title) from your bookshelf? Downloaded content for this title will also be removed from your device.",
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
                guard let self = self else { return }
                // Update book of this instance
                self.book.isAddedToBookshelf = !self.book.isAddedToBookshelf
                
                // Update book in data model
                self.book.update(isAddedToBookshelf: self.book.isAddedToBookshelf)
                
                // Update cell with this book in AllTitlesViewController
                self.addRemoveToBookshelfDidTapCallback()
                
                // Dismiss this bottom sheet
                self.dismissWithCustomAnimation()
            })
        
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func handleViewAuthorsOrNarrators(storytellers: [Title]) {
        if storytellers.count == 1 {
            self.dismiss(animated: false, completion: { [weak self] in
                self?.viewAuthorsDidTapCallback(storytellers)
            })
        } else {
            self.dismissWithCustomAnimation(completion: { [weak self] in
                self?.viewAuthorsDidTapCallback(storytellers)
            })
        }
    }
    
    private func applyConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableViewHeightConstraint.isActive = true
        tableViewBottomConstraint.isActive = true
    }
    
    private func animatePresentingTableView() {
//        print("BottomSheetVC animatePresentingTableView()")
        // Update bottom constraint in animation block and animate dimmed view alpha
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.tableViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.windowDimmedView?.alpha = self.maxDimmedViewAlpha
        }, completion: nil)
    }
    
    func dismissWithCustomAnimation(completion: (() -> ())? = nil) {
        // Hide table view and windowDimmedView
        UIView.animate(withDuration: 0.2) {
            self.tableViewBottomConstraint.constant = self.defaultTableViewHeight
            self.windowDimmedView?.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: {
                completion?()
            })
        }
    }
    
    private func animateTableViewHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.windowDimmedView?.alpha = self.maxDimmedViewAlpha
            self.tableViewHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentTableViewHeight = height
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
        // add pan gesture recognizer to the tableView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        tableView.addGestureRecognizer(panGesture)
    }

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
//        print("Pan gesture y offset: \(translation.y)")

        // If value is < 0, user is dragging up
        let isDraggingDown = translation.y > 0
        
        let newHeightForDraggingDown = currentTableViewHeight - translation.y
        
        // Calculations for smooth proportional change of alpha value of the dimmed view
        let percentageOfTableViewHeight = (newHeightForDraggingDown * 100) / defaultTableViewHeight
        var newDimmedViewAlpha = (percentageOfTableViewHeight * maxDimmedViewAlpha) / 100
        if newDimmedViewAlpha > maxDimmedViewAlpha {
            newDimmedViewAlpha = maxDimmedViewAlpha
        }
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            if isDraggingDown {
                
                self.windowDimmedView?.alpha = newDimmedViewAlpha
                tableViewHeightConstraint.constant = newHeightForDraggingDown
//                tableView.layoutIfNeeded()
                
                guard gesture.velocity(in: tableView).y < 1500 else {
//                    print("velocity y is \(gesture.velocity(in: tableView).y)")
                    // Prevent from calling animateTableViewHeight in case .ended
                    isSwiping = true
                    break
                }
                // Let animateTableViewHeight be called in case .ended
                isSwiping = false
            }
            
        case .ended:
            guard isSwiping != true else {
                dismissWithCustomAnimation()
                break
            }
            animateTableViewHeight(defaultTableViewHeight)
        default:
            break
        }
    }
}






