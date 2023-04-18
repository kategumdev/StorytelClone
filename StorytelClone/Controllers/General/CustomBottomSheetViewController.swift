//
//  CustomBottomSheetViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/4/23.
//

import UIKit

class CustomBottomSheetViewController: UIViewController {
    
//    // To deferentiate between 3 different variants of this vc
//    enum TriggeredBy {
//        case addButton
//        case burgerMenu
//        case accountNameButton
//    }
    
    // To deferentiate between 2 different variants of this vc
    enum TriggeredBy {
        case ellipsisButton
        case authorsButton
        case narratorsButton
    }
    
    // MARK: Instance properties
//    var titleModel: Title?
    let book: Book
    var isTriggeredBy: TriggeredBy? = .narratorsButton
    var isSwiping = false
    var currentTableViewHeight: CGFloat = 0
    var tableRowHeight: CGFloat = 45
    
    lazy var windowDimmedView: UIView? = {
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
    
    lazy var tableViewSectionHeaderHeight: CGFloat = {
//        print("tableViewHeaderHeight calculated lazily")
//        if titleModel?.titleKind == .author || titleModel?.titleKind == .narrator {
//            return 40
//        } else {
//            return 32
//        }
        
        if isTriggeredBy == .authorsButton || isTriggeredBy == .narratorsButton{
            return 2
        } else {
            return 44
        }
    }()
    
    let maxDimmedViewAlpha: CGFloat = 0.35
    
//    lazy var maxDimmedViewAlpha: CGFloat = {
////        print("maxDimmedViewAlpha calculated lazily")
//        if isTriggeredBy == .storytellerButton {
//            return 0.7
//        } else {
//            // For accountNameButton: a bit less than for addButton and burgerMenu, because this bottom sheet variant is presented as a formSheet which itself dims view a bit
//            return 0.66
//        }
//
//    }()
    
    lazy var tableViewHeightWithoutCells: CGFloat = tableRowHeight
    
//    lazy var tableViewHeightWithoutCells: CGFloat = {
////        print("tableViewHeightWithoutCells calculated lazily")
//        if isTriggeredBy == .accountNameButton {
//            return 59
//        } else if isTriggeredBy == .addButton {
//            return 172
//        } else {
//            // For burgerMenu button
//            return 138
//        }
//    }()
    
    lazy var defaultTableViewHeight: CGFloat = {
//        print("defaultTableViewHeight calculated lazily")
//        var height: CGFloat
//        if titleModel?.titleKind == .author || titleModel?.titleKind == .narrator {
//            height = tableViewHeightWithoutCells + (60 * 3)
//        } else {
//            height = tableViewHeightWithoutCells + (70 * 3)
//        }
        
        var multiplier: Int
        if isTriggeredBy == .authorsButton {
            multiplier = book.authors.count
        } else if isTriggeredBy == .narratorsButton, let narrators = book.narrators {
            multiplier = narrators.count
        } else {
            multiplier = 7
        }
        
        let height = tableViewHeightWithoutCells + tableRowHeight * CGFloat(multiplier)
        
//        if isTriggeredBy == .authorsButton || isTriggeredBy == .narratorsButton {
//            height = tableViewHeightWithoutCells + (tableRowHeight * 3)
//        } else {
//            height = tableViewHeightWithoutCells + (70 * 3)
//        }
        
        
        
        
//        if isTriggeredBy == .burgerMenu {
//            height = tableViewHeightWithoutCells + Cell.cellHeight * CGFloat(BurgerMenuTableViewContent.texts.count)
//        } else if isTriggeredBy == .addButton {
//            height = tableViewHeightWithoutCells + Cell.cellHeight * CGFloat(AddButtonTableViewContent.texts.count)
//        } else {
//            height = tableViewHeightWithoutCells + ChangeAccountCell.cellHeight * CGFloat(AccountNameButtonTableViewContent.accountNames.count)
//        }
        
        // Set currentTableViewHeight for proper tracking of pan gesture and changing of tableView height
        currentTableViewHeight = height
        
        return height
    }()
    
    
    
    
    
//
//    lazy var cellIdentifier: String = {
////        print("cellIdentifier calculated lazily")
////        if titleModel?.titleKind == .author || titleModel?.titleKind == .narrator {
////            return StorytellerBottomSheetTableViewCell.identifier
////        } else {
////            return ""
////        }
//
//        if isTriggeredBy == .authorsButton || isTriggeredBy == .narratorsButton {
//            return StorytellerBottomSheetTableViewCell.identifier
////            return "\(ChangeAccountCell.self)"
//        } else {
//            return ""
////            return "\(Cell.self)"
//        }
//    }()
    
    
    
    
//    lazy var addButtonBurgerMenuImages: [UIImage] = {
////        print("addButtonBurgerMenuImages calculated lazily")
//        var images = [UIImage]()
//        if isTriggeredBy == .addButton {
//            images = AddButtonTableViewContent.images
//        } else {
//            images = BurgerMenuTableViewContent.images
//        }
//        return images
//    }()
    
//    lazy var addButtonBurgerMenuTexts: [String] = {
////        print("addButtonBurgerMenuTexts calculated lazily")
//        var texts = [String]()
//        if isTriggeredBy == .addButton {
//            texts = AddButtonTableViewContent.texts
//        } else {
//            texts = BurgerMenuTableViewContent.texts
//        }
//        return texts
//    }()
    
//    lazy var accountNameButtonImages: [UIImage] = {
////        print("accountNameButtonImages calculated lazily")
//        return AccountNameButtonTableViewContent.images
//    }()
//
//    lazy var accountNameButtonAccountNames: [String] = {
////        print("accountNameButtonAccountNames calculated lazily")
//        return AccountNameButtonTableViewContent.accountNames
//    }()
//
//    lazy var accountNameButtonNotificationsTexts: [String] = {
////        print("accountNameButtonNotificationsTexts calculated lazily")
//        return AccountNameButtonTableViewContent.notificationsTexts
//    }()
    
    let cellIdentifier = "CellIdentifier"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.backgroundColor = Utils.customBackgroundColor
        tableView.backgroundColor = .magenta
        tableView.clipsToBounds = true
        tableView.separatorColor = .clear
        tableView.layer.cornerRadius = 10
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.estimatedRowHeight = tableRowHeight
        tableView.rowHeight = tableRowHeight
        
//        table.tableHeaderView =
        return tableView
    }()
    
    lazy var tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
    lazy var tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Initializers
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
//        configureInitialView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("BottomSheetVC viewDidAppear")
//        adjustHeaderSeparatorLine()
        animatePresentingTableView()
        setupPanGesture()
        setupTapGesture()
    }
    
    deinit {
//        print("BottomSheetVC deinit")
        self.windowDimmedView?.removeFromSuperview()
        self.windowDimmedView = nil
//        print("nil out dimmedView: \(String(describing: self.windowDimmedView))")
    }
}

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
    
//    func configureInitialView() {
////        print("BottomSheetVC configureInitialView()")
//        view.backgroundColor = .clear
//
//        let cellNib = UINib(nibName: "\(Cell.self)", bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: "\(Cell.self)")
//        let accountCellNib = UINib(nibName: "\(ChangeAccountCell.self)", bundle: nil)
//        tableView.register(accountCellNib, forCellReuseIdentifier: "\(ChangeAccountCell.self)")
//
//        // Register the custom header view
//        tableView.register(BottomSheetTableHeader.self, forHeaderFooterViewReuseIdentifier: "addButton")
//        tableView.register(BottomSheetTableHeader.self, forHeaderFooterViewReuseIdentifier: "burgerMenuAndAccountNameButton")
//
//        // to remove gap between header and first cell. This line for some reason causes removal of separator line under the first cell
//        // tableView.sectionHeaderTopPadding = 0
//
//        // Change tableView's row height for bottom sheet triggered by accountNameButton's action
//        if isTriggeredBy == .accountNameButton {
//            tableView.estimatedRowHeight = 81
//            tableView.rowHeight = 81
//        }
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.layer.cornerRadius = 16
//        tableView.backgroundColor = .white
//        tableView.clipsToBounds = true
//
//        // Place table view out of visible bounds of the screen
//        tableViewBottomConstraint.constant = defaultTableViewHeight
//
//        // Every new instance gets different initial default table view height
//        tableViewHeightConstraint.constant = defaultTableViewHeight
//
//        windowDimmedView?.alpha = 0
//    }
    
    // Default separator line between header and first cell has left inset. To avoid this inset I redo its auto layout constraints. Call this in viewWillAppear, because I can get reference to this view only after all the views of the table view has been laid out.
//    func adjustHeaderSeparatorLine() {
////        print("BottomSheetVC adjustHeaderSeparatorLine()")
//        let firstCell = tableView.visibleCells[0]
//
//        let separatorLine = firstCell.subviews.last
//        if isTriggeredBy == .addButton {
//
//            separatorLine?.translatesAutoresizingMaskIntoConstraints = false
//
//            separatorLine?.leadingAnchor.constraint(equalTo: firstCell.leadingAnchor).isActive = true
//            separatorLine?.topAnchor.constraint(equalTo: firstCell.topAnchor).isActive = true
//            separatorLine?.trailingAnchor.constraint(equalTo: firstCell.trailingAnchor).isActive = true
//            separatorLine?.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//
//            view.layoutIfNeeded()
//        } else {
//            separatorLine?.removeFromSuperview()
//        }
////        print("cell subviews after: \(tableView.visibleCells[0].subviews)")
//    }
    
    // MARK: - Animations
    func animatePresentingTableView() {
//        print("BottomSheetVC animatePresentingTableView()")
        // Update bottom constraint in animation block and animate dimmed view alpha
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.tableViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.windowDimmedView?.alpha = self.maxDimmedViewAlpha
        }, completion: nil)
    }
    
    func animateDismissView() {
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
    
    func animateTableViewHeight(_ height: CGFloat) {
//        print("BottomSheetVC animateTableViewHeight")
        
        UIView.animate(withDuration: 0.3, delay: 0) { [self] in
            windowDimmedView?.alpha = maxDimmedViewAlpha
            tableViewHeightConstraint.constant = height
            view.layoutIfNeeded()
        }
        // Save current height
        currentTableViewHeight = height
    }
    
    // MARK: - Gesture Recognizers
    func setupTapGesture() {
//        print("BottomSheetVC setupTapGesture()")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesure() {
//        print("BottomSheetVC handleTapGesure()")
        animateDismissView()
    }
    
    func setupPanGesture() {
//        print("BottomSheetVC setupPanGesture()")
        // add pan gesture recognizer to the tableView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        tableView.addGestureRecognizer(panGesture)
    }
    
//    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
////        print("BottomSheetVC handlePanGesture")
//        let translation = gesture.translation(in: view)
//        // drag to top will be minus value and vice versa
////        print("Pan gesture y offset: \(translation.y)")
//
//        // get drag direction
//        let isDraggingDown = translation.y > 0
////        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
//
//        // New height is based on value of dragging plus current container height
//        let newHeightForDraggingUp = currentTableViewHeight - (translation.y / 7)
////        print("newHeightForDraggingUp: \(newHeightForDraggingUp)")
//        let newHeightForDraggingDown = currentTableViewHeight - translation.y
////        print("newHeightForDraggingDown: \(newHeightForDraggingDown)")
//
//        // calculations for smooth proportional change of alpha value of the dimmed view
//        let percentageOfTableViewHeight = (newHeightForDraggingDown * 100) / defaultTableViewHeight
//        var newDimmedViewAlpha = (percentageOfTableViewHeight * maxDimmedViewAlpha) / 100
//        if newDimmedViewAlpha > maxDimmedViewAlpha {
//            newDimmedViewAlpha = maxDimmedViewAlpha
//        }
//
//        // Handle based on gesture state
//        switch gesture.state {
//        case .changed:
//            // This state will occur when user is dragging
//            if isDraggingDown {
//
//                self.windowDimmedView?.alpha = newDimmedViewAlpha
//                tableViewHeightConstraint.constant = newHeightForDraggingDown
////                tableView.layoutIfNeeded()
//
//                guard gesture.velocity(in: tableView).y < 1500 else {
////                    print("velocity y is \(gesture.velocity(in: tableView).y)")
//                    // to prevent from calling animateTableViewHeight in case .ended
//                    isSwiping = true
//                    break
//                }
//
//                // to let animateTableViewHeight be called in case .ended
//                isSwiping = false
//            }
//
//            if !isDraggingDown {
//                // to let animateTableViewHeight be called in case .ended
//                isSwiping = false
//
//                self.windowDimmedView?.alpha = newDimmedViewAlpha
//                tableViewHeightConstraint.constant = newHeightForDraggingUp
////                tableView.layoutIfNeeded()
//            }
//
//
//        case .ended:
//            // This happens when user stop drag, so we will get the last height of container
//            guard isSwiping != true else {
//                animateDismissView()
//                break
//            }
//            animateTableViewHeight(defaultTableViewHeight)
//        default:
//            break
//        }
//    }
    
    
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
            
//            if !isDraggingDown {
//                // to let animateTableViewHeight be called in case .ended
//                isSwiping = false
//
//                self.windowDimmedView?.alpha = newDimmedViewAlpha
//                tableViewHeightConstraint.constant = newHeightForDraggingUp
////                tableView.layoutIfNeeded()
//            }
            
            
        case .ended:
            // This happens when user stop drag, so we will get the last height of container
            guard isSwiping != true else {
                animateDismissView()
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
//        let cellIdentifier = "CellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if isTriggeredBy == .authorsButton {
            cell.textLabel?.text = book.authors[indexPath.row].name
        } else if isTriggeredBy == .narratorsButton, let narrators = book.narrators {
            cell.textLabel?.text = narrators[indexPath.row].name
            cell.imageView?.image = UIImage(systemName: "person.circle.fill")
        } else {
            cell.textLabel?.text = "Lorem ipsum"
        }
        
        return cell
        
//        // Configure cells for bottom sheet triggered by accounNameButton action
//        if isTriggeredBy == .accountNameButton {
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChangeAccountCell
//
//            // Configure first cell
//            if indexPath.row == 0 {
//                cell.checkmarkImageView.image = UIImage(named: "checkIcon")?.thumbnailOfSize(cell.checkmarkImageView.bounds.size)
//                cell.accountNameLabel.textColor = UIColor(red: 4/255, green: 147/255, blue: 247/255, alpha: 1)
//            }
//
//            // Layout cell for having a single label with account name if there is no text for notificationsLabel
//            if accountNameButtonNotificationsTexts[indexPath.row].isEmpty {
//                cell.layoutForSingleLabel()
//            } else {
//                cell.notificationsLabel?.text = accountNameButtonNotificationsTexts[indexPath.row]
//            }
//
//            cell.accountImageView.image = accountNameButtonImages[indexPath.row]
//            cell.accountNameLabel.text = accountNameButtonAccountNames[indexPath.row]
//
//            // Hide separator line after the last cell
//            if indexPath.row == accountNameButtonAccountNames.count - 1 {
//                cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width / 2, bottom: 0, right: cell.bounds.width / 2)
//            }
//
//            return cell
//        } else {
//
//            // configure cells for bottom sheet triggered by addButton's or burgerMenu's action
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell
//
//            cell.iconImageView.image = addButtonBurgerMenuImages[indexPath.row]
//            cell.label.text = addButtonBurgerMenuTexts[indexPath.row]
//
//            return cell
//        }
    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        print("BottomSheetVC tableViewDelegate calculating table view header height")
//        return tableViewSectionHeaderHeight
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        print("BottomSheetVC tableViewDelegate providing custom view for header")
//
//        if isTriggeredBy == .addButton {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "addButton") as! BottomSheetTableHeader
//            return headerView
//        } else {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "burgerMenuAndAccountNameButton") as! BottomSheetTableHeader
//            return headerView
//        }
//    }
}

//extension CustomBottomSheetViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        print("BottomSheetVC tableViewDelegate calculating table view header height")
//        return tableViewSectionHeaderHeight
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        print("BottomSheetVC tableViewDelegate providing custom view for header")
//
//        if isTriggeredBy == .addButton {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "addButton") as! BottomSheetTableHeader
//            return headerView
//        } else {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "burgerMenuAndAccountNameButton") as! BottomSheetTableHeader
//            return headerView
//        }
//    }
//}

extension CustomBottomSheetViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("BottomSheetVC UIGestureRecognizerDelegate for tapGesture")
         if touch.view?.isDescendant(of: tableView) == true {
            return false
         }
         return true
    }
}



