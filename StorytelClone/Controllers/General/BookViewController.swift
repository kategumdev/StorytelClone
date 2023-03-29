//
//  BookViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class BookViewController: UIViewController {
    
    // MARK: - Static properties
    // For ShowSeriesButtonContainer and BookDetailsScrollView
    static let lightBordersColor = UIColor.quaternaryLabel.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)).cgColor
    static let lightBordersWidth = 0.7
    
    // MARK: - Instance properties
    var book: Book
    
    private let mainScrollView = UIScrollView()
    private var scrollViewInitialOffsetY: CGFloat = 0.0
    private var isInitialOffsetYSet = false
        
    private lazy var bookDetailsStackView = BookDetailsStackView(forBook: book)
    private let bookDetailsStackViewTopPadding: CGFloat = 12
    
    private lazy var bookDetailsScrollView = BookDetailsScrollView(book: book)
    private lazy var overviewStackView = BookOverviewStackView(book: book)
    
    private let seeMoreButton = SeeMoreButton()
    private lazy var seeLessAppearanceTopAnchor = seeMoreButton.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: -SeeMoreButton.buttonHeight / 2)
//    private lazy var seeLessAppearanceTopAnchor = seeMoreButton.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: overviewStackView.visiblePartForSeeMoreAppearance - seeMoreButton.buttonHeight / 2)
    private lazy var seeMoreAppearanceTopAnchor = seeMoreButton.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: overviewStackView.visiblePartInSeeMoreAppearance)
    
    private lazy var playSampleButton = PlaySampleButton()
    
    private lazy var hasAudio = book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook ? true : false
    
    private let hideView: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
        
    // MARK: - View life cycle
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
        setupTapGesture()
        
        mainScrollView.delegate = self
        
        view.addSubview(hideView)
//        hideView.layer.zPosition = -1

        mainScrollView.addSubview(seeMoreButton)
        addSeeMoreButtonAction()
        
        if hasAudio {
            mainScrollView.addSubview(playSampleButton)
        }
//        if book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook {
//        }
        
        applyConstraints()
        
        navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
        extendedLayoutIncludesOpaqueBars = true
    }
    
    // MARK: - Helper methods
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
        tapGesture.cancelsTouchesInView = false
        overviewStackView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesure() {
        adjustForSeeMoreSeeLessAppearance()
    }
    
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
//            self.seeMoreButton.rotateImage()
            self.adjustForSeeMoreSeeLessAppearance()
        }), for: .touchUpInside)
    }
    
    private func adjustForSeeMoreSeeLessAppearance() {
        seeMoreButton.rotateImage()
        
        if seeMoreAppearanceTopAnchor.isActive {
            seeMoreButton.gradientLayer.isHidden = true
            hideView.isHidden = true
            seeMoreAppearanceTopAnchor.isActive = false
            seeLessAppearanceTopAnchor.isActive = true
            seeMoreButton.setButtonTextTo(text: "See less")
        } else {
            seeMoreAppearanceTopAnchor.isActive = true
            seeLessAppearanceTopAnchor.isActive = false
            seeMoreButton.setButtonTextTo(text: "See more")
            hideView.isHidden = false
            seeMoreButton.gradientLayer.isHidden = false
        }
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
        
        hideView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = overviewStackView.visiblePartInSeeMoreAppearance + SeeMoreButton.buttonHeight
        NSLayoutConstraint.activate([
            hideView.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: topConstant),
            hideView.heightAnchor.constraint(equalTo: overviewStackView.heightAnchor),
            hideView.widthAnchor.constraint(equalTo: view.widthAnchor),
            hideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeMoreButton.heightAnchor.constraint(equalToConstant: SeeMoreButton.buttonHeight),
            seeMoreButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            seeMoreButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            seeMoreButton.bottomAnchor.constraint(equalTo: contentG.bottomAnchor)
        ])
        seeMoreAppearanceTopAnchor.isActive = true
//        seeLessAppearanceTopAnchor.isActive = true
        
        guard hasAudio else {
            seeMoreButton.bottomAnchor.constraint(equalTo: contentG.bottomAnchor).isActive = true
            return
        }
        
        playSampleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playSampleButton.heightAnchor.constraint(equalToConstant: PlaySampleButton.buttonHeight),
            playSampleButton.widthAnchor.constraint(equalTo: contentG.widthAnchor, constant: -Constants.cvPadding * 2),
            playSampleButton.topAnchor.constraint(equalTo: seeMoreButton.bottomAnchor),
            playSampleButton.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            playSampleButton.bottomAnchor.constraint(equalTo: contentG.bottomAnchor)
        ])
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
