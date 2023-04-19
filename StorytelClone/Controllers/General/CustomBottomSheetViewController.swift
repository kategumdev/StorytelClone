//
//  CustomBottomSheetViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/4/23.
//

import UIKit

class CustomBottomSheetViewController: UIViewController {

//    static let storytellerTableSection = TableSection(sectionTitle: "")
    
    enum TriggeredBy {
        case ellipsisButton
        case authorsButton
        case narratorsButton
    }
    
    // MARK: Instance properties
    private let book: Book
    private var isTriggeredBy: TriggeredBy? = .ellipsisButton
    private var isSwiping = false
    private var currentTableViewHeight: CGFloat = 0
//    private var tableRowHeight: CGFloat = 45
    
    private lazy var tableRowHeight: CGFloat = {
        if isTriggeredBy == .ellipsisButton {
            return 40
        } else {
            return 45
        }
    }()
    
    private lazy var tableHeaderHeight: CGFloat = {
        if isTriggeredBy == .ellipsisButton {
            return 40
        } else {
            return 48
        }
    }()
    
    private lazy var tableHeaderTitleText: String = {
        if isTriggeredBy == .authorsButton {
            return "Authors"
        } else if isTriggeredBy == .narratorsButton {
            return "Narrators"
        } else {
            return book.title
        }
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
    
//    private lazy var tableViewSectionHeaderHeight: CGFloat = {
//        if isTriggeredBy == .authorsButton || isTriggeredBy == .narratorsButton{
//            return 2
//        } else {
//            return 44
//        }
//    }()
    
    private let maxDimmedViewAlpha: CGFloat = 0.35

    private lazy var tableViewHeightWithoutCells: CGFloat = tableRowHeight
    
    private lazy var defaultTableViewHeight: CGFloat = {
        var multiplier: Int
        var rowHeight: CGFloat = StorytellerBottomSheetTableViewCell.rowHeight
        if isTriggeredBy == .authorsButton {
            multiplier = book.authors.count
        } else if isTriggeredBy == .narratorsButton, let narrators = book.narrators {
            multiplier = narrators.count
        } else {
            multiplier = 7
            rowHeight = tableRowHeight
        }
        
        let height = tableViewHeightWithoutCells + tableHeaderHeight + rowHeight * CGFloat(multiplier)
        currentTableViewHeight = height
        return height
    }()
    
    let cellIdentifier = "CellIdentifier"
    
    private lazy var tableHeaderView: BottomSheetTableHeaderView = {
        let headerView = BottomSheetTableHeaderView(titleText: tableHeaderTitleText, withSeparatorView: true)
        headerView.closeButtonDidTapCallback = { [weak self] in
            self?.dismissWithCustomAnimation()
        }
        return headerView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor(named: "bottomSheetBackground")
        tableView.clipsToBounds = true
        tableView.separatorColor = .clear
        tableView.layer.cornerRadius = 10
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(StorytellerBottomSheetTableViewCell.self, forCellReuseIdentifier: StorytellerBottomSheetTableViewCell.identifier)
        
        tableView.estimatedRowHeight = tableRowHeight
        tableView.rowHeight = tableRowHeight
        
        tableView.tableHeaderView = tableHeaderView
        
        // These two lines avoid constraints' conflict of header when view just loaded
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView?.fillSuperview()
        return tableView
    }()
    
    private lazy var tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
    var tableViewDidSelectTitleCallback: (Title) -> () = {_ in}
    
    // MARK: - Initializers
//    init(book: Book) {
//        self.book = book
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init(book: Book, isTriggeredBy: TriggeredBy) {
        self.book = book
        self.isTriggeredBy = isTriggeredBy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
//        print("BottomSheetVC deinit")
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
        
        setupPanGesture()
        setupTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = true
        tableHeaderView.frame.size = CGSize(width: tableView.bounds.width, height: tableHeaderHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentingTableView()
//        setupPanGesture()
//        setupTapGesture()
    }

}


// MARK: - Helper methods
extension CustomBottomSheetViewController {
    
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
    
    private func dismissWithCustomAnimation() {
//        print("BottomSheetVC animateDismissView()")
        // hide table view by updating bottom constraint
        UIView.animate(withDuration: 0.2) {
            self.tableViewBottomConstraint.constant = self.defaultTableViewHeight
            self.view.layoutIfNeeded()
        }

        // hide dimmed view
        UIView.animate(withDuration: 0.2) {
            self.windowDimmedView?.alpha = 0
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
    
    private func animateTableViewHeight(_ height: CGFloat) {
//        print("BottomSheetVC animateTableViewHeight")
        UIView.animate(withDuration: 0.3, delay: 0) { [self] in
            windowDimmedView?.alpha = maxDimmedViewAlpha
            tableViewHeightConstraint.constant = height
            view.layoutIfNeeded()
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
//        print("BottomSheetVC handlePanGesture")
        let translation = gesture.translation(in: view)
        // drag to top will be minus value and vice versa
//        print("Pan gesture y offset: \(translation.y)")

        // get drag direction
        let isDraggingDown = translation.y > 0
//        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
//        let newHeightForDraggingUp = currentTableViewHeight - (translation.y / 7)
//        print("newHeightForDraggingUp: \(newHeightForDraggingUp)")
        
        
        let newHeightForDraggingDown = currentTableViewHeight - translation.y
//        print("newHeightForDraggingDown: \(newHeightForDraggingDown)")
        
        // calculations for smooth proportional change of alpha value of the dimmed view
        let percentageOfTableViewHeight = (newHeightForDraggingDown * 100) / defaultTableViewHeight
        var newDimmedViewAlpha = (percentageOfTableViewHeight * maxDimmedViewAlpha) / 100
        if newDimmedViewAlpha > maxDimmedViewAlpha {
            newDimmedViewAlpha = maxDimmedViewAlpha
        }
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if isDraggingDown {
                
                self.windowDimmedView?.alpha = newDimmedViewAlpha
                tableViewHeightConstraint.constant = newHeightForDraggingDown
//                tableView.layoutIfNeeded()
                
                guard gesture.velocity(in: tableView).y < 1500 else {
//                    print("velocity y is \(gesture.velocity(in: tableView).y)")
                    // to prevent from calling animateTableViewHeight in case .ended
                    isSwiping = true
                    break
                }
                
                // to let animateTableViewHeight be called in case .ended
                isSwiping = false
            }
            
        case .ended:
            // This happens when user stop drag, so we will get the last height of container
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


// MARK: - UITableViewDataSource, UITableViewDelegate
extension CustomBottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isTriggeredBy == .authorsButton {
            return book.authors.count
        } else if isTriggeredBy == .narratorsButton, let narrators = book.narrators {
            return narrators.count
        } else {
            return 7
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print("BottomSheetVC dataSource providing cells")
        guard isTriggeredBy != .ellipsisButton else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel?.text = "Lorem ipsum"
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StorytellerBottomSheetTableViewCell.identifier, for: indexPath) as? StorytellerBottomSheetTableViewCell else { return UITableViewCell() }
        
        if isTriggeredBy == .authorsButton {
            cell.configureWith(storyteller: book.authors[indexPath.row])
        } else if let narrators = book.narrators {
            cell.configureWith(storyteller: narrators[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isTriggeredBy == .ellipsisButton {
            print("Row \(indexPath.row) in ellipsisButton bottom sheet selected")
        } else if isTriggeredBy == .authorsButton {
            let selectedTitle = book.authors[indexPath.row]
            tableViewDidSelectTitleCallback(selectedTitle)
        } else if let narrators = book.narrators {
            let selectedTitle = narrators[indexPath.row]
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
