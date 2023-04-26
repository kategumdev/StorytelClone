//
//  CustomBottomSheetViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/4/23.
//

import UIKit

protocol BottomSheetViewControllerDelegate: AnyObject {
    
    // For .bookDetails BottomSheetKind of BottomSheetViewController
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book)
    
    func bookDetailsBottomSheetViewControllerDidSelectViewSeriesCell(withSeries series: String)
    
    func bookDetailsBottomSheetViewControllerDidSelectViewAuthorsOrNarratorsCell(
        withStorytellers storytellers: [Title], andBook book: Book)
    
    func bookDetailsbottomSheetViewControllerDidSelectShowMoreTitlesLikeThisCell(withCategory category: Category)
    
    // For .authors or .narrators BottomSheetKind of BottomSheetViewController
    func storytellersBottomSheetViewControllerDidSelect(storyteller: Title)
    
}

enum BookDetailsBottomSheetCell: String, CaseIterable {
    case saveBook = "heart"
    case markAsFinished = "checkmark"
    case download = "arrow.down.circle"
    case viewSeries = "rectangle.stack"
    case viewAuthors = "pencil"
    case viewNarrators = "mic"
    case showMoreTitlesLikeThis = "square.grid.3x2"
    case share = "paperplane"
}

enum BottomSheetKind {
    case bookDetails
    case authors
    case narrators
}

class BottomSheetViewController: UIViewController {
    
    // MARK: - Static methods
//    private func showVcWithStorytellerOrBottomSheet(withStorytellers storytellers: [Title]) {
//        if storytellers.count == 1 {
//            let controller = AllTitlesViewController(tableSection: TableSection.generalForAllTitlesVC, titleModel: storytellers.first)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//
//        if storytellers.count > 1 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//                guard let self = self else { return }
//                let bottomSheetKind: BottomSheetKind = storytellers.first as? Author != nil ? .authors : .narrators
//                let storytellersBottomSheetController = BottomSheetViewController(book: self.book, kind: bottomSheetKind)
//                storytellersBottomSheetController.delegate = self
//                storytellersBottomSheetController.modalPresentationStyle = .overFullScreen
//                self.present(storytellersBottomSheetController, animated: false)
//            }
//        }
//    }

    // MARK: Instance properties
    private var book: Book
    private var kind: BottomSheetKind = .bookDetails
    private var isSwiping = false
    
    weak var delegate: BottomSheetViewControllerDelegate?

    private lazy var bookDetailsBottomSheetCells: [BookDetailsBottomSheetCell] = {
        var cells = BookDetailsBottomSheetCell.allCases
        
        if book.series == nil {
            cells = cells.filter { $0 != .viewSeries }
        }
        
        if book.narrators.isEmpty {
            cells = cells.filter { $0 != .viewNarrators }
        }
        return cells
    }()
    
    private let maxAlphaForDimmedEffect: CGFloat = 0.35
    
    private lazy var tableHeaderView: BottomSheetTableHeaderView = {
        let addSeparatorView = kind == .bookDetails ? false : true
        let headerView = BottomSheetTableHeaderView(titleText: tableHeaderTitleText, withSeparatorView: addSeparatorView)
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
        
        tableView.register(BottomSheetTableViewCell.self, forCellReuseIdentifier: BottomSheetTableViewCell.identifier)
        
        tableView.estimatedRowHeight = tableRowHeight
        tableView.rowHeight = tableRowHeight
        
        tableView.tableHeaderView = tableHeaderView
        
        // These two lines avoid constraints' conflict of header when vc's view just loaded
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView?.fillSuperview()
        return tableView
    }()
    
    private let tableRowHeight: CGFloat = 48
    private let tableViewHeightWithoutCells: CGFloat = 28
    private var currentTableViewHeight: CGFloat = 0
    
    private lazy var fullTableViewHeight: CGFloat = {
        var multiplier: Int
        switch kind {
        case .bookDetails: multiplier = bookDetailsBottomSheetCells.count
        case .authors: multiplier = book.authors.count
        case .narrators: multiplier = book.narrators.count
        }
        let height = tableViewHeightWithoutCells + tableHeaderHeight + tableRowHeight * CGFloat(multiplier)
        currentTableViewHeight = height
        return height
    }()
    
    private lazy var tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
    
//    var tableViewDidSelectSaveBookCellCallback: () -> () = {}
//    var viewStorytellersDidTapCallback: ([Title]) -> () = {_ in}
//    var tableViewDidSelectStorytellerCallback: (Title) -> () = {_ in}
//    var tableViewDidSelectViewSeriesCellCallback: () -> () = {}
//    var tableViewDidSelectShowMoreTitlesLikeThisCellCallback: (Category) -> () = {_ in}
    
    private var panGesture: UIPanGestureRecognizer?
    private var swipeGesture: UISwipeGestureRecognizer?
    
    // MARK: - Initializers
    init(book: Book, kind: BottomSheetKind) {
        print("\n\n\(kind) bottom sheet CREATED")
        self.book = book
        self.kind = kind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(kind) BottomSheetVC DEINIT")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBackgroundColorAlphaTo(value: 0)

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        applyConstraints()
        
        // Hide tableView
        tableViewHeightConstraint.constant = 0
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
    
    // MARK: - Instance methods
    func dismissWithCustomAnimation(completion: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.tableViewHeightConstraint.constant = 0 // Hide tableView
            self.view.layoutIfNeeded()
            self.setViewBackgroundColorAlphaTo(value: 0)
        }, completion: { _ in
            self.dismiss(animated: false, completion: {
                completion?()
            })
        })
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch kind {
        case .bookDetails: return bookDetailsBottomSheetCells.count
        case .authors: return book.authors.count
        case .narrators: return book.narrators.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomSheetTableViewCell.identifier, for: indexPath) as? BottomSheetTableViewCell else { return UITableViewCell() }
        
        switch kind {
        case .bookDetails:
            cell.configureFor(book: book, ellipsisButtonCell: bookDetailsBottomSheetCells[indexPath.row])
        case .authors:
            cell.configureWith(storyteller: book.authors[indexPath.row])
        case .narrators:
            cell.configureWith(storyteller: book.narrators[indexPath.row])
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch kind {
        case .bookDetails:
            let ellipsisButtonCell = bookDetailsBottomSheetCells[indexPath.row]
            handleSelection(ellipsisButtonCell: ellipsisButtonCell, withIndexPath: indexPath)
        case .authors:
            let selectedAuthor = book.authors[indexPath.row]
            self.dismiss(animated: false) { [weak self] in
                guard let self = self else { return}
                self.delegate?.storytellersBottomSheetViewControllerDidSelect(storyteller: selectedAuthor)
            }
        case .narrators:
            let selectedNarrator = book.narrators[indexPath.row]
            self.dismiss(animated: false) { [weak self] in
                guard let self = self else { return }
                self.delegate?.storytellersBottomSheetViewControllerDidSelect(storyteller: selectedNarrator)
            }
        }
    }
    
}

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
    
    private func handleSelection(ellipsisButtonCell: BookDetailsBottomSheetCell, withIndexPath indexPath: IndexPath) {
        
        switch ellipsisButtonCell {
        case .saveBook:
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
//            self.dismiss(animated: false)
//            tableViewDidSelectViewSeriesCellCallback()
            self.dismiss(animated: false)
            guard let series = book.series else { return }
            self.delegate?.bookDetailsBottomSheetViewControllerDidSelectViewSeriesCell(withSeries: series)
            
        case .viewAuthors:
            let authors = book.authors
            handleViewAuthorsOrNarrators(storytellers: authors)
            
        case .viewNarrators:
            let narrators = book.narrators
            handleViewAuthorsOrNarrators(storytellers: narrators)
            
        case .showMoreTitlesLikeThis:
            handleShowMoreTitlesLikeThis()
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
        self.delegate?.bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook: book)
//        tableViewDidSelectSaveBookCellCallback()
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
                self.delegate?.bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook: self.book)
//                self.tableViewDidSelectSaveBookCellCallback()
                
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
                guard let self = self else { return }
                self.delegate?.bookDetailsBottomSheetViewControllerDidSelectViewAuthorsOrNarratorsCell(withStorytellers: storytellers, andBook: self.book)
//                self?.viewStorytellersDidTapCallback(storytellers)
            })
        } else {
            self.dismissWithCustomAnimation(completion: { [weak self] in
                guard let self = self else { return }
                self.delegate?.bookDetailsBottomSheetViewControllerDidSelectViewAuthorsOrNarratorsCell(withStorytellers: storytellers, andBook: self.book)
//                self?.viewStorytellersDidTapCallback(storytellers)
            })
        }
    }
    
    private func handleShowMoreTitlesLikeThis() {
        
        self.dismiss(animated: false)
        
        // Create table sections
        var librosSimilaresTableSection = TableSection.librosSimilares
        librosSimilaresTableSection.toShowTitleModel = book
        var tableSections = [
            librosSimilaresTableSection
        ]
        
        for author in book.authors {
            let authorTableSection = TableSection(sectionTitle: "Títulos populares de este autor", sectionSubtitle: author.name, toShowTitleModel: author)
            tableSections.append(authorTableSection)
        }
        
        for narrator in book.narrators {
            let narratorTableSection = TableSection(sectionTitle: "Títulos populares de este narrador", sectionSubtitle: narrator.name, toShowTitleModel: narrator)
            tableSections.append(narratorTableSection)
        }
        
        if let series = book.series {
            #warning("Instead of hardcoded series model object Series.series1, create series model obejct this book is from and pass it as titleModel as argument when creating seriesTableSection")
            let seriesTitleModel = Series.series1
            let seriesTableSection = TableSection(sectionTitle: "Más de estas series", sectionSubtitle: series, toShowTitleModel: seriesTitleModel)
            tableSections.append(seriesTableSection)
        }
        
        let categoryName = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
        let categoryForTableSection = ButtonCategory.createModelFor(categoryButton: book.category)
        let categoryTableSection = TableSection(sectionTitle: "Más de esta categoría", sectionSubtitle: categoryName, toShowCategory: categoryForTableSection)
        tableSections.append(categoryTableSection)
        
        // Create category with created tableSections and pass it to callback
        let category = Category(title: "Libros similares", tableSections: tableSections, bookToShowMoreTitlesLikeIt: book)
        self.delegate?.bookDetailsbottomSheetViewControllerDidSelectShowMoreTitlesLikeThisCell(withCategory: category)
//        tableViewDidSelectShowMoreTitlesLikeThisCellCallback(category)
    }
    
    private func applyConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableViewHeightConstraint.isActive = true
    }
    
    private func animateToFullTableViewHeight() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tableViewHeightConstraint.constant = self.fullTableViewHeight // Show tableView
            self.view.layoutIfNeeded()
            self.setViewBackgroundColorAlphaTo(value: self.maxAlphaForDimmedEffect)
        }, completion: nil)
    }
    
//    func dismissWithCustomAnimation(completion: (() -> ())? = nil) {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//            self.tableViewHeightConstraint.constant = 0 // Hide tableView
//            self.view.layoutIfNeeded()
//            self.setViewBackgroundColorAlphaTo(value: 0)
//        }, completion: { _ in
//            self.dismiss(animated: false, completion: {
//                completion?()
//            })
//        })
//    }
    
    private func animateTableViewHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.setViewBackgroundColorAlphaTo(value: self.maxAlphaForDimmedEffect)
            self.tableViewHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
        currentTableViewHeight = height // Save current height
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
                tableViewHeightConstraint.constant = newTableViewHeight
                
                // If velocity of panGesture is less than 1500, it is a swipe
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
    
    private func setViewBackgroundColorAlphaTo(value: CGFloat) {
        view.backgroundColor = .black.withAlphaComponent(value)
    }
}






