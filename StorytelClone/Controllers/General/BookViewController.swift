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
    
    private let seeMoreOverviewButton = SeeMoreButton(forOverview: true)
    private lazy var seeMoreOverviewButtonTopAnchorFullSizeAppearance = seeMoreOverviewButton.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: -SeeMoreButton.buttonHeight / 2)
    private lazy var seeMoreOverviewButtonTopAnchorCompressedAppearance = seeMoreOverviewButton.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: overviewStackView.visiblePartInSeeMoreAppearance)
    
    private lazy var playSampleButtonContainer = PlaySampleButtonContainer()
    
    private lazy var tagsView = TagsView(tags: book.tags, superviewWidth: view.bounds.width)
    private lazy var showAllTagsButton = SeeMoreButton(forOverview: false)
    private lazy var showAllTagsButtonTopAnchorCompressedAppearance = showAllTagsButton.topAnchor.constraint(equalTo: tagsView.topAnchor, constant: tagsView.compressedViewHeight)
    private lazy var showAllTagsButtonTopAnchorFullSizeAppearance = showAllTagsButton.topAnchor.constraint(equalTo: tagsView.bottomAnchor)

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
        configureMainScrollView()
        view.addSubview(hideView)
//        hideView.layer.zPosition = -1
        applyConstraints()
        
        navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
        extendedLayoutIncludesOpaqueBars = true
    }
    
    // MARK: - Helper methods
    private func configureMainScrollView() {
        mainScrollView.showsVerticalScrollIndicator = false
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(bookDetailsStackView)
        mainScrollView.addSubview(bookDetailsScrollView)
        mainScrollView.addSubview(overviewStackView)
        setupTapGesture()
        
        mainScrollView.delegate = self
        
        mainScrollView.addSubview(seeMoreOverviewButton)
        addSeeMoreButtonAction()

        if hasAudio {
            mainScrollView.addSubview(playSampleButtonContainer)
        }
        
        if !book.tags.isEmpty {
            mainScrollView.addSubview(tagsView)
            if tagsView.needsShowAllButton {
                mainScrollView.addSubview(showAllTagsButton)
                addShowAllTagsButtonAction()
            }
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
        tapGesture.cancelsTouchesInView = false
        overviewStackView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesure() {
        handleSeeMoreOverviewButtonTapped()
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
        seeMoreOverviewButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleSeeMoreOverviewButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func addShowAllTagsButtonAction() {
        showAllTagsButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleShowAllTagsButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func handleSeeMoreOverviewButtonTapped() {
        if seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive {
            seeMoreOverviewButton.rotateImage()
            seeMoreOverviewButton.gradientLayer.isHidden = true
//            hideView.isHidden = true
            seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive = false
            seeMoreOverviewButtonTopAnchorFullSizeAppearance.isActive = true
            seeMoreOverviewButton.setButtonTextTo(text: "See less")
        } else {
            seeMoreOverviewButton.gradientLayer.isHidden = false
            // Avoid blinking of overviewStackView's text beneath seeMorebutton ensuring that gradientLayer of seeMoreButton is fully drawn before other adjustements are done
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.seeMoreOverviewButton.rotateImage()
//                self?.hideView.isHidden = false
                self?.seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive = true
                self?.seeMoreOverviewButtonTopAnchorFullSizeAppearance.isActive = false
                self?.seeMoreOverviewButton.setButtonTextTo(text: "See more")
            }
        }
    }
    
    private func handleShowAllTagsButtonTapped() {
        if showAllTagsButtonTopAnchorCompressedAppearance.isActive {
            showAllTagsButton.rotateImage()
            showAllTagsButtonTopAnchorCompressedAppearance.isActive = false
            showAllTagsButtonTopAnchorFullSizeAppearance.isActive = true
            showAllTagsButton.setButtonTextTo(text: "See less")
        } else {
            showAllTagsButton.rotateImage()
            showAllTagsButtonTopAnchorCompressedAppearance.isActive = true
            showAllTagsButtonTopAnchorFullSizeAppearance.isActive = false
            showAllTagsButton.setButtonTextTo(text: "Show all tags")
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
        ])
        
        seeMoreOverviewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeMoreOverviewButton.heightAnchor.constraint(equalToConstant: SeeMoreButton.buttonHeight),
            seeMoreOverviewButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            seeMoreOverviewButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive = true
        
        if hasAudio {
            playSampleButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playSampleButtonContainer.heightAnchor.constraint(equalToConstant: PlaySampleButtonContainer.buttonHeight + 32),

                playSampleButtonContainer.widthAnchor.constraint(equalTo: contentG.widthAnchor),
                playSampleButtonContainer.topAnchor.constraint(equalTo: seeMoreOverviewButton.bottomAnchor),
                playSampleButtonContainer.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            ])
        }

        hideView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            hideView.heightAnchor.constraint(equalTo: overviewStackView.heightAnchor),
            // 1000 ensures that hidden part of tagsView (if present) is fully covered but hideView (especially when there are many tags)
            hideView.heightAnchor.constraint(equalToConstant: 1000.0),
            hideView.widthAnchor.constraint(equalTo: view.widthAnchor),
            hideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        if !book.tags.isEmpty {
//            tagsView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tagsView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
                tagsView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
//                tagsView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor)
            ])
            
            if !hasAudio {
                tagsView.topAnchor.constraint(equalTo: seeMoreOverviewButton.bottomAnchor).isActive = true
            } else {
                tagsView.topAnchor.constraint(equalTo: playSampleButtonContainer.bottomAnchor).isActive = true
            }
                        
            if tagsView.needsShowAllButton {
                showAllTagsButton.translatesAutoresizingMaskIntoConstraints = false
                showAllTagsButton.heightAnchor.constraint(equalToConstant: SeeMoreButton.buttonHeight / 2).isActive = true
                showAllTagsButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
                showAllTagsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true

                showAllTagsButtonTopAnchorCompressedAppearance.isActive = true

                showAllTagsButton.bottomAnchor.constraint(equalTo: contentG.bottomAnchor).isActive = true

                hideView.topAnchor.constraint(equalTo: showAllTagsButton.bottomAnchor).isActive = true
            } else {
                hideView.topAnchor.constraint(equalTo: tagsView.bottomAnchor).isActive = true
                tagsView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor).isActive = true
            }
            
//            hideView.topAnchor.constraint(equalTo: tagsView.bottomAnchor).isActive = true
        } else if hasAudio {
            playSampleButtonContainer.bottomAnchor.constraint(equalTo: contentG.bottomAnchor).isActive = true
            hideView.topAnchor.constraint(equalTo: playSampleButtonContainer.bottomAnchor).isActive = true
        } else {
            seeMoreOverviewButton.bottomAnchor.constraint(equalTo: contentG.bottomAnchor).isActive = true
            hideView.topAnchor.constraint(equalTo: seeMoreOverviewButton.bottomAnchor).isActive = true
        }
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
