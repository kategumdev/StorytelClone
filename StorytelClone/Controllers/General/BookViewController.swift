//
//  BookViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class BookViewController: UIViewController {
    
    var book: Book
    
//    private let scrollView = UIScrollView()
    
    private lazy var bookDetailsView = BookDetailsView(forBook: book)
    
    private lazy var bookDetailsScrollView = BookDetailsScrollView(book: book)
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        title = book.title
//        view.addSubview(scrollView)
        view.addSubview(bookDetailsView)
        view.addSubview(bookDetailsScrollView)
        applyConstraints()
        
        
        navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
//        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
        extendedLayoutIncludesOpaqueBars = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
////        print("viewWillDisappear")
////        navigationController?.navigationBar.isTranslucent = false
//
////        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
//    }
    
    
    private func applyConstraints() {
        
        #warning("Set top constraint with padding from view.safeAreaLayoutGuide.topAnchor")
        
        bookDetailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookDetailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookDetailsView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            bookDetailsView.bottomAnchor.constraint(equalTo: bookDetailsView.roundButtonsStackContainer.bottomAnchor)
        ])

        // Leading and trailing constants are used to hide border on those sides
        bookDetailsScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookDetailsScrollView.topAnchor.constraint(equalTo: bookDetailsView.bottomAnchor, constant: 33),
            bookDetailsScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -1),
            bookDetailsScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 1),
//            bookDetailsScrollView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
    }

}
