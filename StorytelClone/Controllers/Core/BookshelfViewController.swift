//
//  BookshelfViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

var toReadBooks = [Book]()

class BookshelfViewController: PagingCvViewController {
    
    // MARK: - Initializers
    init() {
        super.init(withScopeButtonsKinds: ScopeButtonKind.kindsForBookshelf, pagingCollectionViewCellKind: PagingCollectionViewCellKind.forBookshelf)
    }
//    override init(withScopeButtonsKinds scopeButtonKinds: [ScopeButtonKind] = ScopeButtonKind.kindsForBookshelf) {
//        super.init(withScopeButtonsKinds: scopeButtonKinds, pagingCollectionViewCellKind: <#PagingCollectionViewCellKind#>)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        configureNavBar()
        collectionViewBottomAnchor.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.makeNavbarAppearance(transparent: false)
        collectionView.reloadData()
        if !toReadBooks.isEmpty {
            let bookTitles = toReadBooks.map { $0.title }
            let bookTitlesString = bookTitles.joined(separator: ", ")
            print("\nTBR: \(bookTitlesString)")
        }
    }
    
    // MARK: - Configuration
    private func configureNavBar() {
        navigationItem.title = "My bookshelf"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.makeNavbarAppearance(transparent: false)
        navigationController?.navigationBar.barTintColor = Utils.tintColor
    }
    
}


//var toReadBooks = [Book]()
//
//class BookshelfViewController: UIViewController {
//
//    private let scopeButtonsView = ScopeButtonsView(withButtonKinds: ScopeButtonKind.kindsForBookshelf)
//
//    var searchResultsDidSelectRowCallback: SearchResultsDidSelectRowCallback = {_ in}
//    var ellipsisButtonDidTapCallback: EllipsisButtonInSearchResultsDidTapCallback = {_ in}
//
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.backgroundColor = Utils.customBackgroundColor
//        collectionView.isPagingEnabled = true
//        return collectionView
//    }()
//
//    private lazy var separatorWidth: CGFloat = {
//        let scale = UIScreen.main.scale
//        if scale == 2.0 {
//            return 0.25
//        } else {
//            return 0.35
//        }
//    }()
//
//    private lazy var separatorLineView: UIView = {
//        let view = UIView()
//        view.layer.borderColor = UIColor.label.cgColor
//        view.layer.borderWidth = separatorWidth
//        return view
//    }()
//
//    private var rememberedOffsetsOfTablesInCells = [ScopeButtonKind : CGPoint]()
//    private var tappedButtonIndex: Int? = nil
//    private var previousOffsetX: CGFloat = 0
//    private var isButtonTriggeredScroll = false
//
//    private var cellsToHideContent = [Int]()
//    private var indexPathsToUnhide = [IndexPath]()
//
//    // MARK: - View life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = Utils.customBackgroundColor
//        configureNavBar()
//        view.addSubview(scopeButtonsView)
////        configureScopeButtonsView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.makeNavbarAppearance(transparent: false)
//
//        if !toReadBooks.isEmpty {
//            let bookTitles = toReadBooks.map { $0.title }
//            let bookTitlesString = bookTitles.joined(separator: ", ")
//            print("\nTBR: \(bookTitlesString)")
//        }
//    }
//
//    // MARK: - Configuration
//    private func configureNavBar() {
//        navigationItem.title = "My bookshelf"
//        navigationController?.navigationBar.tintColor = .label
//        navigationItem.backButtonTitle = ""
//        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationController?.makeNavbarAppearance(transparent: false)
//        navigationController?.navigationBar.barTintColor = Utils.tintColor
//    }
//
////    private func configureScopeButtonsView() {
////        // Respond to button actions in buttonsView
////        scopeButtonsView.scopeButtonDidTapCallback = { [weak self] buttonIndex in
////            guard let self = self else { return }
////            // To avoid logic in didScroll to perform if scroll is triggered by button tap
////            self.isButtonTriggeredScroll = true
////
////            self.scrollToCell(buttonIndex)
////        }
////    }
//
//}
