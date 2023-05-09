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
    private lazy var seeOverviewButton: SeeMoreButton = {
        let button = SeeMoreButton(buttonKind: .forOverview)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleSeeMoreOverviewButtonTapped()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var seeOverviewButtonAnchorForFullSizeOverview = seeOverviewButton.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: -seeOverviewButton.heightConstant / 2)
    private lazy var seeOverviewButtonAnchorToCompressOverview = seeOverviewButton.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: overviewStackView.defaultVisiblePartWhenCompressed)
    
    private lazy var hasAudio = book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook ? true : false
    private lazy var playSampleButtonContainer = PlaySampleButtonContainer()
    
    private lazy var hasTags = !book.tags.isEmpty ? true : false
    private lazy var tagsView = TagsView(tags: book.tags, superviewWidth: superviewWidth)
    #warning("Maybe redo somehow without passing superviewWidth")
//    private lazy var showAllTagsButton = SeeMoreButton(buttonKind: .seeMoreTags)
    private lazy var seeTagsButton: SeeMoreButton = {
        let button = SeeMoreButton(buttonKind: .forTags)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleShowAllTagsButtonTapped()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var seeTagsButtonAnchorToCompressTagsView = seeTagsButton.topAnchor.constraint(equalTo: tagsView.topAnchor, constant: tagsView.compressedViewHeight)
    private lazy var seeTagsButtonAnchorForFullSizeTagsView = seeTagsButton.topAnchor.constraint(equalTo: tagsView.bottomAnchor)
    
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
    override func layoutSubviews() {
        super.layoutSubviews()
        // In case when user opens BookVC with one content size category, then changes it to another one, tags view height also changes and seeTagsButton anchor for 'compressed' appearance of tagsView has to be updated. This avoids unnecessary gaps between views and strange layout
        if tagsView.bounds.height != tagsView.fullViewHeight {
//            tagsView.compressedViewHeight = tagsView.calculateViewHeightFor(numberOfRows: 3)
            tagsView.updateCompressedViewHeight()
            seeTagsButtonAnchorToCompressTagsView.constant = tagsView.compressedViewHeight
            layoutIfNeeded()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
//            print("bookTableHeight UPDATED")
            bookTableHeight = SectionHeaderView.calculateEstimatedHeightFor(tableSection: TableSection.similarTitles, superviewWidth: superviewWidth) + Utils.heightForRowWithHorizontalCv
        }
    }
    
    // MARK: - Instance methods
    func hideSeeMoreOverviewButtonAsNeeded() {
        let overviewStackViewHeight = overviewStackView.bounds.height
        if  overviewStackViewHeight < overviewStackView.defaultVisiblePartWhenCompressed {
            seeOverviewButtonAnchorToCompressOverview.isActive = false
            seeOverviewButtonAnchorForFullSizeOverview.isActive = true
            seeOverviewButtonAnchorForFullSizeOverview.constant -= seeOverviewButton.bounds.height / 4
            seeOverviewButton.isHidden = true
        }
    }
    
    func showSeeMoreOverviewButtonAsNeeded() {
        let overviewStackViewHeight = overviewStackView.bounds.height
        if overviewStackViewHeight >= overviewStackView.defaultVisiblePartWhenCompressed && seeOverviewButton.isHidden {
            seeOverviewButtonAnchorToCompressOverview.isActive = true
//            seeOverviewButtonAnchorForFullSizeOverview.constant = -seeOverviewButton.seeOverviewButtonHeight / 2
            seeOverviewButtonAnchorForFullSizeOverview.constant = -seeOverviewButton.heightConstant / 2
            seeOverviewButtonAnchorForFullSizeOverview.isActive = false
            seeOverviewButton.isHidden = false
        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        showsVerticalScrollIndicator = false
        addSubview(bookDetailsStackView)
        addSubview(bookDetailsScrollView)
        addSubview(overviewStackView)
        addSubview(seeOverviewButton)
        
        if hasAudio {
            addSubview(playSampleButtonContainer)
        }
        
        if hasTags {
            addSubview(tagsView)
            if tagsView.needsShowAllButton {
                addSubview(seeTagsButton)
            }
        }
        
        addSubview(bookTable)
    }
    
    @objc func handleOverviewTapGesture() {
        guard !seeOverviewButton.isHidden else { return }
        handleSeeMoreOverviewButtonTapped()
    }

    private func handleSeeMoreOverviewButtonTapped() {
        if seeOverviewButtonAnchorToCompressOverview.isActive {
            seeOverviewButton.rotateImage()
            seeOverviewButton.gradientLayer.isHidden = true
            seeOverviewButtonAnchorToCompressOverview.isActive = false
            seeOverviewButtonAnchorForFullSizeOverview.isActive = true
            seeOverviewButton.setButtonTextTo(text: "See less")
        } else {
            seeOverviewButton.gradientLayer.isHidden = false
            // Avoid blinking of overviewStackView's text beneath seeMorebutton ensuring that gradientLayer of seeMoreButton is fully drawn before other adjustements are done
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.seeOverviewButton.rotateImage()
                self?.seeOverviewButtonAnchorToCompressOverview.isActive = true
                self?.seeOverviewButtonAnchorForFullSizeOverview.isActive = false
                self?.seeOverviewButton.setButtonTextTo(text: "See more")
            }
        }
    }
  
    private func handleShowAllTagsButtonTapped() {
        if seeTagsButtonAnchorToCompressTagsView.isActive {
            seeTagsButton.rotateImage()
            seeTagsButtonAnchorToCompressTagsView.isActive = false
            seeTagsButtonAnchorForFullSizeTagsView.isActive = true
            seeTagsButton.setButtonTextTo(text: "See less")
        } else {
            seeTagsButton.rotateImage()
            seeTagsButtonAnchorToCompressTagsView.isActive = true
            seeTagsButtonAnchorForFullSizeTagsView.isActive = false
            seeTagsButton.setButtonTextTo(text: "Show all tags")
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
        
        seeOverviewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            seeOverviewButton.heightAnchor.constraint(equalToConstant: seeOverviewButton.seeOverviewButtonHeight),
            seeOverviewButton.heightAnchor.constraint(equalToConstant: seeOverviewButton.heightConstant),
            seeOverviewButton.widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor),
            seeOverviewButton.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
        ])
        seeOverviewButtonAnchorToCompressOverview.isActive = true
        
        // Configure playSampleButtonContainer constraints
        if hasAudio {
            playSampleButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playSampleButtonContainer.widthAnchor.constraint(equalTo: contentG.widthAnchor),
                playSampleButtonContainer.topAnchor.constraint(equalTo: seeOverviewButton.bottomAnchor),
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
                tagsView.topAnchor.constraint(equalTo: seeOverviewButton.bottomAnchor).isActive = true
            }
            
            if tagsView.needsShowAllButton {
                seeTagsButton.translatesAutoresizingMaskIntoConstraints = false
//                seeTagsButton.heightAnchor.constraint(equalToConstant: seeTagsButton.showAllTagsButtonHeight).isActive = true
                seeTagsButton.heightAnchor.constraint(equalToConstant: seeTagsButton.heightConstant).isActive = true
                seeTagsButton.widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor).isActive = true
                seeTagsButton.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor).isActive = true

                seeTagsButtonAnchorToCompressTagsView.isActive = true
            }
        }
                        
        // Configure bookTable constraints
        bookTable.translatesAutoresizingMaskIntoConstraints = false
        if !book.tags.isEmpty {
            if tagsView.needsShowAllButton {
                bookTable.topAnchor.constraint(equalTo: seeTagsButton.bottomAnchor).isActive = true
            } else {
                bookTable.topAnchor.constraint(equalTo: tagsView.bottomAnchor).isActive = true
            }
        } else if hasAudio {
            bookTable.topAnchor.constraint(equalTo: playSampleButtonContainer.bottomAnchor).isActive = true
        } else {
            bookTable.topAnchor.constraint(equalTo: seeOverviewButton.bottomAnchor).isActive = true
        }
        bookTable.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bookTable.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bookTable.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -Constants.commonHorzPadding).isActive = true
        bookTableHeightConstraint.isActive = true
    }
    
}
