//
//  BookViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

typealias BookVcCallback = () -> ()

class BookViewController: UIViewController {
    // MARK: - Static properties
    // For borders in ShowSeriesButtonContainer and BookDetailsScrollView
    static let lightBordersColor = UIColor.quaternaryLabel.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)).cgColor
    static let lightBordersWidth = 0.7
    
    // MARK: - Instance properties
    var book: Book
    private let tableSection = TableSection(sectionTitle: "Similar titles", forSimilarBooks: true, canBeShared: false)
    
    private let mainScrollView = UIScrollView()
    private var scrollViewInitialOffsetY: CGFloat = 0.0
    private var isInitialOffsetYSet = false
        
    private lazy var bookDetailsStackView = BookDetailsStackView(forBook: book)
    private let bookDetailsStackViewTopPadding: CGFloat = 12
    
    private lazy var bookDetailsScrollView = BookDetailsScrollView(book: book)
    private lazy var overviewStackView = BookOverviewStackView(book: book)
    
    private let seeMoreOverviewButton = SeeMoreButton(forOverview: true)
    private lazy var seeMoreOverviewButtonTopAnchorFullSizeAppearance = seeMoreOverviewButton.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: -seeMoreOverviewButton.seeMoreOverviewButtonHeight / 2)
    private lazy var seeMoreOverviewButtonTopAnchorCompressedAppearance = seeMoreOverviewButton.topAnchor.constraint(equalTo: overviewStackView.topAnchor, constant: overviewStackView.visiblePartInSeeMoreAppearance)
    
    private lazy var playSampleButtonContainer = PlaySampleButtonContainer()
    private lazy var hasAudio = book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook ? true : false
    
    private lazy var hasTags = !book.tags.isEmpty ? true : false
    private lazy var tagsView = TagsView(tags: book.tags, superviewWidth: view.bounds.width)
    private lazy var showAllTagsButton = SeeMoreButton(forOverview: false)
    private lazy var showAllTagsButtonTopAnchorCompressedAppearance = showAllTagsButton.topAnchor.constraint(equalTo: tagsView.topAnchor, constant: tagsView.compressedViewHeight)
    private lazy var showAllTagsButtonTopAnchorFullSizeAppearance = showAllTagsButton.topAnchor.constraint(equalTo: tagsView.bottomAnchor)
    
    let bookTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = Utils.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        table.isScrollEnabled = false
        
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        return table
    }()
    
    private let hideView: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
    
    private let popupButton = PopupButton()
    
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
        addAndConfigureMainScrollView()
        view.addSubview(hideView)
        addAndConfigurePopupButton()
        applyConstraints()
        
        navigationController?.makeNavbarAppearance(transparent: true)
//        navigationController?.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearance
        extendedLayoutIncludesOpaqueBars = true
//        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - Helper methods
    private func addAndConfigureMainScrollView() {
        mainScrollView.delegate = self
        mainScrollView.showsVerticalScrollIndicator = false
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(bookDetailsStackView)
        if let series = book.series {
            bookDetailsStackView.bookVcCallback = { [weak self] in
                let tableSection = TableSection(sectionTitle: series)
                let controller = AllTitlesViewController(tableSection: tableSection, categoryOfParentVC: Category.series, titleModel: Series.series1)
                #warning("titleModel IS HARDCODED HERE, it has to be determined at runtime. categoryOfParentVC is also hardcoded, it is not needed at all. tableSection is also hardcoded, not needed. Refactor AllTitlesViewController to work in cases whe there is no tableSection. Refactor BaseTableViewController to work in cases when here is no category")
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        mainScrollView.addSubview(bookDetailsScrollView)
        bookDetailsScrollView.bookVcCallback = { [weak self] in
            guard let self = self else { return }
            let category = ButtonCategory.createModelFor(categoryButton: self.book.category)
            let controller = CategoryViewController(categoryModel: category)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        mainScrollView.addSubview(overviewStackView)
        setupTapGesture()
        
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
        
        mainScrollView.addSubview(bookTable)
        bookTable.dataSource = self
        bookTable.delegate = self
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
        
        let offsetYToCompareTo = scrollViewInitialOffsetY + maxYOfBookTitleLabel
        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: offsetYToCompareTo)
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
    
    private func addAndConfigurePopupButton() {
        view.addSubview(popupButton)
        // Pass popupButton callback to saveButton
        bookDetailsStackView.popupButtonCallback = popupButton.reconfigureAndAnimateSelf
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
            seeMoreOverviewButton.heightAnchor.constraint(equalToConstant: seeMoreOverviewButton.seeMoreOverviewButtonHeight),
            seeMoreOverviewButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            seeMoreOverviewButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        seeMoreOverviewButtonTopAnchorCompressedAppearance.isActive = true
        
        // Configure playSampleButtonContainer constraints
        if hasAudio {
            playSampleButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playSampleButtonContainer.widthAnchor.constraint(equalTo: contentG.widthAnchor),
                playSampleButtonContainer.topAnchor.constraint(equalTo: seeMoreOverviewButton.bottomAnchor),
                playSampleButtonContainer.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
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
                tagsView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
                tagsView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            ])
            
            if hasAudio {
                tagsView.topAnchor.constraint(equalTo: playSampleButtonContainer.bottomAnchor).isActive = true
            } else {
                tagsView.topAnchor.constraint(equalTo: seeMoreOverviewButton.bottomAnchor).isActive = true
            }
            
            if tagsView.needsShowAllButton {
                showAllTagsButton.translatesAutoresizingMaskIntoConstraints = false
                showAllTagsButton.heightAnchor.constraint(equalToConstant: showAllTagsButton.showAllTagsButtonHeight).isActive = true

                showAllTagsButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
                showAllTagsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true

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
        bookTable.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true
        bookTable.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        bookTable.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -Constants.cvPadding).isActive = true
        let bookTableHeight = SectionHeaderView.calculateHeaderHeightFor(section: tableSection) + Utils.heightForRowWithHorizontalCv
        bookTable.heightAnchor.constraint(equalToConstant: bookTableHeight).isActive = true
        
        // Configure hideView constraints
        hideView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 1000 ensures that hidden parts of overviewStackView and tagsView (if present) are fully covered by hideView
            hideView.heightAnchor.constraint(equalToConstant: 1000.0),
            hideView.widthAnchor.constraint(equalTo: view.widthAnchor),
            hideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hideView.topAnchor.constraint(equalTo: bookTable.bottomAnchor)
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        
        let books = Book.books
        // To respond to button tap in BookCollectionViewCell of TableViewCellWithCollection
        let callbackClosure: ButtonCallback = { [weak self] book in
            let book = book as! Book
            let controller = BookViewController(book: book)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        cell.configureWith(books: books, callbackForButtons: callbackClosure)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Utils.heightForRowWithHorizontalCv
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UIView() }

        sectionHeader.configureFor(section: self.tableSection)

        // Respond to seeAllButton in section header
        sectionHeader.containerWithSubviews.callback = { [weak self] tableSection in
            guard let self = self else { return }
            let category = ButtonCategory.createModelFor(categoryButton: self.book.category)
            let controller = AllTitlesViewController(tableSection: tableSection, categoryOfParentVC: category, titleModel: self.book)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let calculatedHeight = SectionHeaderView.calculateHeaderHeightFor(section: tableSection)
        return calculatedHeight
    }
    
}
