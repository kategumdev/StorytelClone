//
//  BookViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class BookViewController: UIViewController {
    
    var book: Book
    
    private let mainScrollView = UIScrollView()
    private var scrollViewInitialOffsetY: CGFloat = 0.0
    private var isInitialOffsetYSet = false
        
    private lazy var bookDetailsStackView = BookDetailsStackView(forBook: book)
    private let bookDetailsStackViewTopPadding: CGFloat = 12
    
    private lazy var bookDetailsScrollView = BookDetailsScrollView(book: book)
    private lazy var overviewStackView = BookOverviewStackView(book: book)
//    private lazy var overviewStackView = BookOverviewStackView(book: book, isFullSize: false)
    
    private let seeMoreButton = SeeMoreButton()
    private lazy var seeMoreAppearanceTopAnchor = seeMoreButton.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: -seeMoreButton.buttonHeight / 2)
    private lazy var seeLessAppearanceTopAnchor = seeMoreButton.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: overviewStackView.visiblePartForSeeMoreAppearance - seeMoreButton.buttonHeight / 2)
//    private lazy var seeLessAppearanceTopAnchor = seeMoreButton.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: 120)
    
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
            
        mainScrollView.showsVerticalScrollIndicator = false
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(bookDetailsStackView)
        mainScrollView.addSubview(bookDetailsScrollView)
        mainScrollView.addSubview(overviewStackView)
        mainScrollView.delegate = self
        
        mainScrollView.addSubview(seeMoreButton)
        addSeeMoreButtonAction()
        

        applyConstraints()
        
        navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
//        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
        extendedLayoutIncludesOpaqueBars = true
    }

    
    // MARK: - Helper methods
    
    private func adjustNavBarAppearanceFor(currentOffsetY: CGFloat) {
        let maxYOfBookTitleLabel: CGFloat = bookDetailsStackViewTopPadding + BookDetailsStackView.imageHeight + bookDetailsStackView.spacingAfterCoverImageView + bookDetailsStackView.bookTitleLabelHeight
        
        if currentOffsetY > scrollViewInitialOffsetY + maxYOfBookTitleLabel && navigationController?.navigationBar.standardAppearance != Utils.visibleNavBarAppearance {
            navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
//            print("to visible")
        }

        if currentOffsetY <= scrollViewInitialOffsetY + maxYOfBookTitleLabel && navigationController?.navigationBar.standardAppearance != Utils.transparentNavBarAppearance {
            navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
//            print("to transparent")
        }
    }
    
    private func addSeeMoreButtonAction() {
        seeMoreButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            
            
            self.toggleSeeMoreButton()
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()

        }), for: .touchUpInside)
    }
    
//    private func toggleSeeMoreButton() {
////        seeMoreButton.toggleButtonText()
//
//        if overviewStackView.isFullSize {
//            print("make smaller")
//
//            seeMoreButton.configuration?.attributedTitle = AttributedString("See more")
//            seeMoreButton.configuration?.attributedTitle?.font = seeMoreButton.font
//
////            overviewStackView = BookOverviewStackView(book: book, isFullSize: false)
//
//
//        } else {
//            print("make full size")
//
//            seeMoreButton.configuration?.attributedTitle = AttributedString("See less")
//            seeMoreButton.configuration?.attributedTitle?.font = seeMoreButton.font
//
////            overviewStackView = BookOverviewStackView(book: book, isFullSize: true)
//
//        }
//
//        let subviews = mainScrollView.subviews
//        for view in subviews {
//            if view is BookOverviewStackView {
//                view.removeFromSuperview()
//                mainScrollView.addSubview(overviewStackView)
//                break
//            }
//        }
//
//        overviewStackView.setNeedsLayout()
//        overviewStackView.layoutIfNeeded()
//
//        mainScrollView.setNeedsLayout()
//        mainScrollView.layoutIfNeeded()
//
//    }
    
    private func toggleSeeMoreButton() {
        if seeMoreAppearanceTopAnchor.isActive {
            seeMoreAppearanceTopAnchor.isActive = false
            seeLessAppearanceTopAnchor.isActive = true
            print("make larger")
            seeMoreButton.configuration?.attributedTitle = AttributedString("See more")
            seeMoreButton.configuration?.attributedTitle?.font = seeMoreButton.font
            seeMoreButton.addGradient()
        } else {
            seeMoreAppearanceTopAnchor.isActive = true
            seeLessAppearanceTopAnchor.isActive = false
            print("make smaller")
            seeMoreButton.configuration?.attributedTitle = AttributedString("See less")
            seeMoreButton.configuration?.attributedTitle?.font = seeMoreButton.font
            seeMoreButton.removeGradient()
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func applyConstraints() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utils.tabBarHeight)
        ])
        
        let contentG = mainScrollView.contentLayoutGuide
        let frameG = mainScrollView.frameLayoutGuide
        
        bookDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookDetailsStackView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: bookDetailsStackViewTopPadding),
            bookDetailsStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
            bookDetailsStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
            bookDetailsStackView.widthAnchor.constraint(equalTo: frameG.widthAnchor)
        ])
        
        // Leading and trailing constants are used to hide border on those sides
        bookDetailsScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookDetailsScrollView.topAnchor.constraint(equalTo: bookDetailsStackView.bottomAnchor, constant: 33),
            bookDetailsScrollView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: -1),
            bookDetailsScrollView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 1),
        ])
        
        NSLayoutConstraint.activate([
            overviewStackView.topAnchor.constraint(equalTo: bookDetailsScrollView.bottomAnchor, constant: 18),
            overviewStackView.widthAnchor.constraint(equalTo: contentG.widthAnchor),
            overviewStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
//            overviewStackView.bottomAnchor.constraint(equalTo: seeMoreView.topAnchor)
        ])
        
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeMoreButton.heightAnchor.constraint(equalToConstant: seeMoreButton.buttonHeight),
            seeMoreButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            seeMoreButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: contentG.bottomAnchor)
        ])
//        seeMoreAppearanceTopAnchor.isActive = true
        seeLessAppearanceTopAnchor.isActive = true
        
    }

}

extension BookViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y

        guard isInitialOffsetYSet else {
            scrollViewInitialOffsetY = currentOffsetY
            isInitialOffsetYSet = true
            return
        }
        
        // Toggle navbar from transparent to visible (and vice versa)
        adjustNavBarAppearanceFor(currentOffsetY: currentOffsetY)
    }
}
