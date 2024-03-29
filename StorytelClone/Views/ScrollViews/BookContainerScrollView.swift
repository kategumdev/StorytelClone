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
    
    lazy var maxYOfBookTitleLabel: CGFloat = bookDetailsStackViewTopPadding +
    BookDetailsStackView.imageHeight +
    bookDetailsStack.spacingAfterCoverImageView +
    bookDetailsStack.bookTitleLabelHeight

    lazy var bookDetailsStack = BookDetailsStackView(forBook: book)
    private let bookDetailsStackViewTopPadding: CGFloat = 12
    
    lazy var bookDetailsScrollView = BookDetailsHorzScrollView(book: book)
    
    private lazy var overviewStackView: BookOverviewStackView = {
        let view = BookOverviewStackView(book: book)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleOverviewTapGesture))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var seeOverviewButton: SeeMoreButton = {
        let button = SeeMoreButton(buttonKind: .forOverview)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleSeeMoreOverviewButtonTapped()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var seeOverviewButtonConstraintForFullSizeOverview =
    seeOverviewButton.topAnchor.constraint(
        equalTo: overviewStackView.bottomAnchor,
        constant: -seeOverviewButton.heightConstant / 2)
    
    private lazy var seeOverviewButtonConstraintToCompressOverview =
    seeOverviewButton.topAnchor.constraint(
        equalTo: overviewStackView.topAnchor,
        constant: overviewStackView.defaultVisiblePartWhenCompressed)
    
    private lazy var hasAudio =
    book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook ? true : false
    lazy var playSampleButtonContainer = PlaySampleButtonContainer(
        audioUrlString: book.audioUrlString)
    
    lazy var hasTags = !book.tags.isEmpty ? true : false
    lazy var tagsView = TagsView(tags: book.tags, superviewWidth: superviewWidth)
    
    private lazy var seeTagsButton: SeeMoreButton = {
        let button = SeeMoreButton(buttonKind: .forTags)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleShowAllTagsButtonTapped()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var seeTagsButtonConstraintToCompressTagsView =
    seeTagsButton.topAnchor.constraint(
        equalTo: tagsView.topAnchor,
        constant: tagsView.calculateCurrentCompressedViewHeight())

    private lazy var seeTagsButtonConstraintForFullSizeTagsView =
    seeTagsButton.topAnchor.constraint(equalTo: tagsView.bottomAnchor)
    
    let bookTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = UIColor.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        table.isScrollEnabled = false
        table.rowHeight = TableViewCellWithCollection.rowHeight
        table.sectionHeaderHeight = UITableView.automaticDimension
        
        table.register(
            TableViewCellWithCollection.self,
            forCellReuseIdentifier: TableViewCellWithCollection.identifier)
        table.register(
            SectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        return table
    }()
    
    private lazy var bookTableHeight = calculateBookTableHeight() {
        didSet {
            bookTableHeightConstraint.constant = bookTableHeight
        }
    }

    private lazy var bookTableHeightConstraint =
    bookTable.heightAnchor.constraint(equalToConstant: bookTableHeight)
    
    private var viewNeedsLayout = false
    
    // MARK: - Initializers
    init(book: Book, superviewWidth: CGFloat) {
        self.book = book
        self.superviewWidth = superviewWidth
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustLayout()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            let calculatedHeight = SectionHeaderView.calculateEstimatedHeightFor(
                subCategory: SubCategory.similarTitles,
                superviewWidth: superviewWidth)
            bookTableHeight = calculatedHeight + TableViewCellWithCollection.rowHeight
        }
    }
}

// MARK: - Instance method
extension BookContainerScrollView {
    /// It must be called within a class that adds BookContainerScrollView as its subview
    func applyConstraints() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
            widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -UITabBar.tabBarHeight)
        ])
        
        let contentG = contentLayoutGuide
        let frameG = frameLayoutGuide
        
        bookDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookDetailsStack.topAnchor.constraint(
                equalTo: contentG.topAnchor,
                constant: bookDetailsStackViewTopPadding),
            bookDetailsStack.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
            bookDetailsStack.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
            bookDetailsStack.widthAnchor.constraint(equalTo: frameG.widthAnchor)
        ])
        
        // Width is 2 points wider to hide border on leading and trailing edges
        bookDetailsScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookDetailsScrollView.topAnchor.constraint(equalTo: bookDetailsStack.bottomAnchor, constant: 33),
            bookDetailsScrollView.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: 2),
            bookDetailsScrollView.centerXAnchor.constraint(equalTo: frameG.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overviewStackView.topAnchor.constraint(equalTo: bookDetailsScrollView.bottomAnchor, constant: 18),
            overviewStackView.widthAnchor.constraint(equalTo: contentG.widthAnchor),
            overviewStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
        ])
        
        seeOverviewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeOverviewButton.heightAnchor.constraint(equalToConstant: seeOverviewButton.heightConstant),
            seeOverviewButton.widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor),
            seeOverviewButton.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
        ])
        seeOverviewButtonConstraintToCompressOverview.isActive = true
        
        // Configure playSampleButtonContainer constraints
        if hasAudio {
            playSampleButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playSampleButtonContainer.widthAnchor.constraint(equalTo: contentG.widthAnchor),
                playSampleButtonContainer.topAnchor.constraint(equalTo: seeOverviewButton.bottomAnchor),
                playSampleButtonContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
            
            if hasTags {
                playSampleButtonContainer.heightAnchor.constraint(
                    equalToConstant: PlaySampleButtonContainer.buttonHeight + 32).isActive = true
            } else {
                playSampleButtonContainer.heightAnchor.constraint(
                    equalToConstant: PlaySampleButtonContainer.buttonHeight).isActive = true
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
                NSLayoutConstraint.activate([
                    seeTagsButton.heightAnchor.constraint(equalToConstant: seeTagsButton.heightConstant),
                    seeTagsButton.widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor),
                    seeTagsButton.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor)
                ])
                seeTagsButtonConstraintToCompressTagsView.isActive = true
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
        
        NSLayoutConstraint.activate([
            bookTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            bookTable.widthAnchor.constraint(equalTo: widthAnchor),
            bookTable.bottomAnchor.constraint(
                equalTo: contentG.bottomAnchor,
                constant: -Constants.commonHorzPadding)
        ])
        bookTableHeightConstraint.isActive = true
    }
}

// MARK: - Helper methods
extension BookContainerScrollView {
    private func setupUI() {
        showsVerticalScrollIndicator = false
        addSubview(bookDetailsStack)
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
    
    private func adjustLayout() {
        hideOrShowSeeMoreOverviewButton()
        
        if hasTags &&
            seeTagsButtonConstraintToCompressTagsView.constant != tagsView.calculateCurrentCompressedViewHeight() {
            seeTagsButtonConstraintToCompressTagsView.constant = tagsView.calculateCurrentCompressedViewHeight()
            viewNeedsLayout = true
        }
        
        if viewNeedsLayout {
            viewNeedsLayout = false
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    private func hideOrShowSeeMoreOverviewButton() {
        let overviewStackViewHeight = overviewStackView.bounds.height
        
        if overviewStackViewHeight < overviewStackView.defaultVisiblePartWhenCompressed &&
            !seeOverviewButton.isHidden {
            // Hide
            seeOverviewButtonConstraintToCompressOverview.isActive = false
            seeOverviewButtonConstraintForFullSizeOverview.isActive = true
            seeOverviewButtonConstraintForFullSizeOverview.constant -= seeOverviewButton.bounds.height / 4
            seeOverviewButton.isHidden = true
            viewNeedsLayout = true
        } else if overviewStackViewHeight >= overviewStackView.defaultVisiblePartWhenCompressed &&
                    seeOverviewButton.isHidden {
            // Show
            seeOverviewButtonConstraintForFullSizeOverview.constant = -seeOverviewButton.heightConstant / 2
            seeOverviewButtonConstraintForFullSizeOverview.isActive = false
            seeOverviewButtonConstraintToCompressOverview.isActive = true
            seeOverviewButton.isHidden = false
        }
    }
    
    @objc func handleOverviewTapGesture() {
        guard !seeOverviewButton.isHidden else { return }
        handleSeeMoreOverviewButtonTapped()
    }

    private func handleSeeMoreOverviewButtonTapped() {
        if seeOverviewButtonConstraintToCompressOverview.isActive {
            seeOverviewButton.rotateImage()
            seeOverviewButton.gradientLayer.isHidden = true
            seeOverviewButtonConstraintToCompressOverview.isActive = false
            seeOverviewButtonConstraintForFullSizeOverview.isActive = true
            seeOverviewButton.updateButtonTextWith(newText: "See less")
        } else {
            seeOverviewButton.gradientLayer.isHidden = false
            /* Avoid blinking of overviewStackView's text beneath seeMorebutton ensuring that
            gradientLayer of seeMoreButton is fully drawn before other adjustements are done */
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.seeOverviewButton.rotateImage()
                self?.seeOverviewButtonConstraintToCompressOverview.isActive = true
                self?.seeOverviewButtonConstraintForFullSizeOverview.isActive = false
                self?.seeOverviewButton.updateButtonTextWith(newText: "See more")
            }
        }
    }
  
    private func handleShowAllTagsButtonTapped() {
        if seeTagsButtonConstraintToCompressTagsView.isActive {
            seeTagsButton.rotateImage()
            seeTagsButtonConstraintToCompressTagsView.isActive = false
            seeTagsButtonConstraintForFullSizeTagsView.isActive = true
            seeTagsButton.updateButtonTextWith(newText: "See less")
        } else {
            seeTagsButton.rotateImage()
            seeTagsButtonConstraintForFullSizeTagsView.isActive = false
            seeTagsButtonConstraintToCompressTagsView.isActive = true
            seeTagsButton.updateButtonTextWith(newText: "Show all tags")
        }
    }
    
    private func calculateBookTableHeight() -> CGFloat {
        let height = SectionHeaderView.calculateEstimatedHeightFor(subCategory: SubCategory.similarTitles, superviewWidth: superviewWidth) + TableViewCellWithCollection.rowHeight
        return height
    }
}
