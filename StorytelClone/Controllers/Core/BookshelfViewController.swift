//
//  BookshelfViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

//var toReadBooks = [Book]()

class BookshelfViewController: ScopeViewController {
    
    // MARK: - Initializers
    init() {
        super.init(withScopeButtonsViewKind: .forBookshelfVc)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBackgroundColor
        configureNavBar()
        collectionViewBottomAnchor.constant = 0
        
        didSelectRowCallback = { [weak self] selectedTitle in
            if let book = selectedTitle as? Book {
                print("BookshelfViewController handles selected book \(book.title)")
                let controller = BookViewController(book: book)
                self?.navigationController?.pushViewController(controller, animated: true)
            } 
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
        navigationController?.makeAppearance(transparent: false)
        collectionView.reloadData()
    }
    
    // MARK: - Configuration
    private func configureNavBar() {
        navigationItem.title = "My bookshelf"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.makeAppearance(transparent: false)
        navigationController?.navigationBar.barTintColor = UIColor.customTintColor
    }
    
}

extension BookshelfViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        guard let tableViewWithSavedBooks = scopeTablesForCvCells.first, let booksInTable = tableViewWithSavedBooks.model as? [Book] else { return }
        
        var bookIndex: Int = 0
        var indexPathOfRowWithRemovedBook = IndexPath(row: 0, section: 0)
        for (index, arrayBook) in booksInTable.enumerated() {
            if arrayBook.title == book.title {
                indexPathOfRowWithRemovedBook.row = index
                bookIndex = index
                break
            }
        }
        
        tableViewWithSavedBooks.model = getModelFor(buttonKind: tableViewWithSavedBooks.buttonKind)
        tableViewWithSavedBooks.deleteRows(at: [IndexPath(row: bookIndex, section: 0)], with: .automatic)

        if tableViewWithSavedBooks.model.isEmpty {
            tableViewWithSavedBooks.reloadData()
        }
    }
}

