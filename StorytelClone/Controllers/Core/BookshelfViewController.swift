//
//  BookshelfViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

class BookshelfViewController: ScopeViewController {
    init() {
        super.init(withScopeButtonsViewKind: .forBookshelfVc)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.makeAppearance(transparent: false)
        collectionView.reloadData()
    }
}

// MARK: - BottomSheetViewControllerDelegate
extension BookshelfViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        guard let savedBooksTableView = scopeTableViews.first,
              let booksInTable = savedBooksTableView.model as? [Book]
        else { return }
        
        var bookIndex: Int = 0
        var indexPathOfRowWithRemovedBook = IndexPath(row: 0, section: 0)
        for (index, arrayBook) in booksInTable.enumerated() {
            if arrayBook.title == book.title {
                indexPathOfRowWithRemovedBook.row = index
                bookIndex = index
                break
            }
        }
        
        savedBooksTableView.model = getModelFor(buttonKind: savedBooksTableView.buttonKind)
        let rowToDelete = IndexPath(row: bookIndex, section: 0)
        savedBooksTableView.deleteRows(at: [rowToDelete], with: .automatic)

        if savedBooksTableView.model.isEmpty {
            savedBooksTableView.reloadData()
        }
    }
}

// MARK: - Helper methods
extension BookshelfViewController {
    private func configureSelf() {
        setupUI()
        passCallbacks()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.customBackgroundColor
        configureNavBar()
        collectionViewBottomAnchor.constant = 0
    }
    
    private func configureNavBar() {
        navigationItem.title = "My bookshelf"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.makeAppearance(transparent: false)
        navigationController?.navigationBar.barTintColor = UIColor.customTintColor
    }
    
    private func passCallbacks() {
        didSelectRowCallback = { [weak self] selectedTitle in
            if let book = selectedTitle as? Book {
                let vc = BookViewController(book: book)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        ellipsisBtnDidTapCallback = { [weak self] book in
            let bookDetailsBottomSheetVC = BottomSheetViewController(book: book, kind: .bookDetails)
            bookDetailsBottomSheetVC.delegate = self
            bookDetailsBottomSheetVC.modalPresentationStyle = .overFullScreen
            self?.present(bookDetailsBottomSheetVC, animated: false)
        }
    }
}

