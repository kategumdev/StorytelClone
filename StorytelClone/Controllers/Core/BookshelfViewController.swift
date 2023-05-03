//
//  BookshelfViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

var toReadBooks = [Book]()

class BookshelfViewController: ScopeViewController {
    
    // MARK: - Initializers
    init() {
        super.init(withScopeButtonsKinds: ScopeButtonKind.kindsForBookshelf, scopeCollectionViewCellKind: ScopeCollectionViewCellKind.forBookshelf)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        configureNavBar()
        collectionViewBottomAnchor.constant = 0
        
        didSelectRowCallback = { [weak self] selectedTitle in
            if let book = selectedTitle as? Book {
                print("BookshelfViewController handles selected book \(book.title)")
                let controller = BookViewController(book: book)
                self?.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = AllTitlesViewController(tableSection: TableSection.generalForAllTitlesVC, titleModel: selectedTitle)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            #warning("In BookshelfViewController are only books. Maybe pushing AllTitlesViewController is not needed at all here")
        }

        ellipsisButtonDidTapCallback = { [weak self] book in
            let bookDetailsBottomSheetController = BottomSheetViewController(book: book, kind: .bookDetails)
            bookDetailsBottomSheetController.delegate = self
            bookDetailsBottomSheetController.modalPresentationStyle = .overFullScreen
            self?.present(bookDetailsBottomSheetController, animated: false)
        }
        
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

extension BookshelfViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        guard let currentCell = collectionView.visibleCells.first as? ScopeCollectionViewCell, let books = currentCell.model as? [Book], let buttonKind = currentCell.buttonKind else { return }
        
        var bookIndex: Int = 0
        var indexPathOfRowWithRemovedBook = IndexPath(row: 0, section: 0)
        for (index, arrayBook) in books.enumerated() {
            if arrayBook.title == book.title {
                indexPathOfRowWithRemovedBook.row = index
                bookIndex = index
                break
            }
        }
        
        currentCell.model = getModelFor(buttonKind: buttonKind)
        currentCell.resultsTable.deleteRows(at: [IndexPath(row: bookIndex, section: 0)], with: .automatic)
    }
}
