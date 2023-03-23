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
    
    private let bookDetailsView = BookDetailsView()
    
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
        
        
//        navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        navigationController?.navigationBar.isTranslucent = false

//        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
    }
    
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
        
//        bookDetailsView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            bookDetailsView.topAnchor.constraint(equalTo: contentG.topAnchor),
//            bookDetailsView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
//            bookDetailsView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
//            bookDetailsView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor),
//            bookDetailsView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -SearchResultsButtonsView.slidingLineHeight / 2)
//        ])
        
        bookDetailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            bookDetailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookDetailsView.heightAnchor.constraint(equalTo: bookDetailsView.stackView.heightAnchor),
//            bookDetailsView.widthAnchor.constraint(equalTo: bookDetailsView.stackView.widthAnchor),
            bookDetailsView.widthAnchor.constraint(equalTo: view.widthAnchor),

            bookDetailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            bookDetailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            
//            bookDetailsView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor),
//            bookDetailsView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -SearchResultsButtonsView.slidingLineHeight / 2)
        ])
        
        
        
//
        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: contentG.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -SearchResultsButtonsView.slidingLineHeight / 2),
//            stackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -SearchResultsButtonsView.slidingLineHeight / 2)
//        ])
    }

}
