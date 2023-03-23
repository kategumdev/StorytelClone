//
//  BookViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class BookViewController: UIViewController {
    
    var book: Book?
    
//    private let scrollView = UIScrollView()
    
//    private let bookDetailsView = BookDetailsView()
    
    private lazy var bookDetailsView = BookDetailsView(forBook: book!) // book will always be set
    
    init(book: Book?) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        title = book?.title
//        view.addSubview(scrollView)
        view.addSubview(bookDetailsView)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("bookDetailsView size: \(bookDetailsView.bounds.size)")
//        bookDetailsView.frame = bookDetailsView.stackView.frame
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("viewDidDisappear")
//        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
//    }
    
    private func applyConstraints() {
        
        #warning("Set top constraints with padding from view.safeAreaLayoutGuide.topAnchor")
        
        bookDetailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookDetailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookDetailsView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            bookDetailsView.bottomAnchor.constraint(equalTo: bookDetailsView.roundButtonsStackContainer.bottomAnchor)
        ])
        
        
//        let contentG = scrollView.contentLayoutGuide
//        let frameG = scrollView.frameLayoutGuide
//
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
////            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//            scrollView.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>)
//        ])
        
    }

}
