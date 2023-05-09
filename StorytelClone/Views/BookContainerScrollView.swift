//
//  BookContainerScrollView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 9/5/23.
//

import UIKit

class BookContainerScrollView: UIScrollView {
    
    // MARK: - Instance properties
    private let book: Book
    private let superviewWidth: CGFloat

    lazy var bookDetailsStackView = BookDetailsStackView(forBook: book)
    private let bookDetailsStackViewTopPadding: CGFloat = 12
    
    lazy var bookDetailsScrollView = BookDetailsScrollView(book: book)
//    private lazy var overviewStackView = BookOverviewStackView(book: book)
    private lazy var overviewStackView: BookOverviewStackView = {
        let view = BookOverviewStackView(book: book)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOverviewTapGesture))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        return view
    }()

//    private let seeMoreOverviewButton = SeeMoreButton(buttonKind: .seeMoreOverview)
    private lazy var seeMoreOverviewButton: SeeMoreButton = {
        let button = SeeMoreButton(buttonKind: .seeMoreOverview)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleSeeMoreOverviewButtonTapped()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var seeMoreOverviewButtonTopAnchorFullSizeAppearance = seeMoreOverviewButton.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: -seeMoreOverviewButton.seeMoreOverviewButtonHeight / 2)
    private lazy var seeMoreOverviewButtonTopAnchorCompressedAppearance = seeMoreOverviewButton.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: overviewStackView.visiblePartInSeeMoreAppearance)
    
    private lazy var hasAudio = book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook ? true : false
    private lazy var playSampleButtonContainer = PlaySampleButtonContainer()
    
    private lazy var hasTags = !book.tags.isEmpty ? true : false
    private lazy var tagsView = TagsView(tags: book.tags, superviewWidth: superviewWidth)
    #warning("Maybe redo somehow without passing superviewWidth")
//    private lazy var showAllTagsButton = SeeMoreButton(buttonKind: .seeMoreTags)
    private lazy var showAllTagsButton: SeeMoreButton = {
        let button = SeeMoreButton(buttonKind: .seeMoreTags)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleShowAllTagsButtonTapped()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var showAllTagsButtonTopAnchorCompressedAppearance = showAllTagsButton.topAnchor.constraint(equalTo: tagsView.topAnchor, constant: tagsView.compressedViewHeight)
    private lazy var showAllTagsButtonTopAnchorFullSizeAppearance = showAllTagsButton.topAnchor.constraint(equalTo: tagsView.bottomAnchor)
    
    lazy var maxYOfBookTitleLabel: CGFloat = bookDetailsStackViewTopPadding + BookDetailsStackView.imageHeight + bookDetailsStackView.spacingAfterCoverImageView + bookDetailsStackView.bookTitleLabelHeight
    
    let bookTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = Utils.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        table.isScrollEnabled = false
        table.rowHeight = Utils.heightForRowWithHorizontalCv
        table.sectionHeaderHeight = UITableView.automaticDimension
        
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        return table
    }()
    
    private lazy var bookTableHeight = calculateBookTableHeight() {
        didSet {
            bookTableHeightConstraint.constant = bookTableHeight
        }
    }
    
    private lazy var bookTableHeightConstraint = bookTable.heightAnchor.constraint(equalToConstant: bookTableHeight)
    
    // MARK: - Initializers
    init(book: Book, superviewWidth: CGFloat) {
        self.book = book
        self.superviewWidth = superviewWidth
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
//            print("bookTableHeight UPDATED")
            bookTableHeight = SectionHeaderView.calculateEstimatedHeightFor(tableSection: TableSection.similarTitles, superviewWidth: superviewWidth) + Utils.heightForRowWithHorizontalCv
        }
    }
    
    // MARK: - Instance methods
    func hideSeeMoreOverviewButtonAsNeeded() {
        let overviewStackViewHeight = overviewStackView.bounds.height
        if  overviewStackViewHeight < overviewStackView.visiblePartInSeeMoreAppearance {
            seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive = false
            seeMoreOverviewButtonTopAnchorFullSizeAppearance.isActive = true
            seeMoreOverviewButtonTopAnchorFullSizeAppearance.constant -= seeMoreOverviewButton.bounds.height / 4
            seeMoreOverviewButton.isHidden = true
        }
    }
    
    func showSeeMoreOverviewButtonAsNeeded() {
        let overviewStackViewHeight = overviewStackView.bounds.height
        if overviewStackViewHeight >= overviewStackView.visiblePartInSeeMoreAppearance && seeMoreOverviewButton.isHidden {
            seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive = true
            seeMoreOverviewButtonTopAnchorFullSizeAppearance.constant = -seeMoreOverviewButton.seeMoreOverviewButtonHeight / 2
            seeMoreOverviewButtonTopAnchorFullSizeAppearance.isActive = false
            seeMoreOverviewButton.isHidden = false
        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        showsVerticalScrollIndicator = false
        addSubview(bookDetailsStackView)
        addSubview(bookDetailsScrollView)
        addSubview(overviewStackView)
        addSubview(seeMoreOverviewButton)
        
        if hasAudio {
            addSubview(playSampleButtonContainer)
        }
        
        if hasTags {
            addSubview(tagsView)
            if tagsView.needsShowAllButton {
                addSubview(showAllTagsButton)
            }
        }
        
        addSubview(bookTable)
    }
    
    @objc func handleOverviewTapGesture() {
        guard !seeMoreOverviewButton.isHidden else { return }
        handleSeeMoreOverviewButtonTapped()
    }

    private func handleSeeMoreOverviewButtonTapped() {
        if seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive {
            seeMoreOverviewButton.rotateImage()
            seeMoreOverviewButton.gradientLayer.isHidden = true
            seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive = false
            seeMoreOverviewButtonTopAnchorFullSizeAppearance.isActive = true
            seeMoreOverviewButton.setButtonTextTo(text: "See less")
        } else {
            seeMoreOverviewButton.gradientLayer.isHidden = false
            // Avoid blinking of overviewStackView's text beneath seeMorebutton ensuring that gradientLayer of seeMoreButton is fully drawn before other adjustements are done
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.seeMoreOverviewButton.rotateImage()
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
    
    private func calculateBookTableHeight() -> CGFloat {
        let height = SectionHeaderView.calculateEstimatedHeightFor(tableSection: TableSection.similarTitles, superviewWidth: superviewWidth) + Utils.heightForRowWithHorizontalCv
        return height
    }

    func applyConstraints() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
            widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -Utils.tabBarHeight)
        ])
        
        let contentG = contentLayoutGuide
        let frameG = frameLayoutGuide
        
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
            seeMoreOverviewButton.heightAnchor.constraint(equalToConstant: seeMoreOverviewButton.seeMoreOverviewButtonHeight),
            seeMoreOverviewButton.widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor),
            seeMoreOverviewButton.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
        ])
        seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive = true
        
        // Configure playSampleButtonContainer constraints
        if hasAudio {
            playSampleButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playSampleButtonContainer.widthAnchor.constraint(equalTo: contentG.widthAnchor),
                playSampleButtonContainer.topAnchor.constraint(equalTo: seeMoreOverviewButton.bottomAnchor),
                playSampleButtonContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
            
            if hasTags {
                playSampleButtonContainer.heightAnchor.constraint(equalToConstant: PlaySampleButtonContainer.buttonHeight + 32).isActive = true
            } else {
                playSampleButtonContainer.heightAnchor.constraint(equalToConstant: PlaySampleButtonContainer.buttonHeight).isActive = true
            }
        }
        
        // Configure tagsView constraints
        if hasTags {
            NSLayoutConstraint.activate([
                tagsView.widthAnchor.constraint(equalTo: widthAnchor),
                tagsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ])
            
            if hasAudio {
                tagsView.topAnchor.constraint(equalTo: playSampleButtonContainer.bottomAnchor).isActive = true
            } else {
                tagsView.topAnchor.constraint(equalTo: seeMoreOverviewButton.bottomAnchor).isActive = true
            }
            
            if tagsView.needsShowAllButton {
                showAllTagsButton.translatesAutoresizingMaskIntoConstraints = false
                showAllTagsButton.heightAnchor.constraint(equalToConstant: showAllTagsButton.showAllTagsButtonHeight).isActive = true

                showAllTagsButton.widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor).isActive = true
                showAllTagsButton.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor).isActive = true

                showAllTagsButtonTopAnchorCompressedAppearance.isActive = true
            }
        }
                        
        // Configure bookTable constraints
        bookTable.translatesAutoresizingMaskIntoConstraints = false
        if !book.tags.isEmpty {
            if tagsView.needsShowAllButton {
                bookTable.topAnchor.constraint(equalTo: showAllTagsButton.bottomAnchor).isActive = true
            } else {
                bookTable.topAnchor.constraint(equalTo: tagsView.bottomAnchor).isActive = true
            }
        } else if hasAudio {
            bookTable.topAnchor.constraint(equalTo: playSampleButtonContainer.bottomAnchor).isActive = true
        } else {
            bookTable.topAnchor.constraint(equalTo: seeMoreOverviewButton.bottomAnchor).isActive = true
        }
        bookTable.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bookTable.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bookTable.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -Constants.commonHorzPadding).isActive = true
        bookTableHeightConstraint.isActive = true
    }
    
}
