//
//  CategoryViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class CategoryViewController: BaseViewController {
    // VC obtains this book when showMoreTitlesLikeThis BookDetailsBottomSheetCell is selected
    private let referenceBook: Book?
    private lazy var subCategories = createSubCategories()
    
    init(category: Category, referenceBook: Book? = nil) {
        self.referenceBook = referenceBook
        super.init(category: category)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height -= UITabBar.tabBarHeight
        bookTable.frame = frame
    }

    // MARK: - Superclass overrides
    override func numberOfSections(in tableView: UITableView) -> Int {
        return subCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCellWithCollection.identifier,
            for: indexPath
        ) as? TableViewCellWithCollection else { return UITableViewCell() }
        
        let subCategoryIndex = indexPath.section
        if let books = booksDict[subCategoryIndex] {
            cell.configureFor(books: books, callback: dimmedAnimationBtnCallback)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let subCategoryKind = subCategories[section].kind
        guard subCategoryKind != .seriesCategoryButton, subCategoryKind != .allCategoriesButton else { return UIView() }
        
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SectionHeaderView.identifier
        ) as? SectionHeaderView else { return UIView() }
        
        let subCategory = subCategories[section]
        let forCategoryVcWithReferenceBook = referenceBook == nil ? false : true
        
        sectionHeader.configureFor(
            subCategory: subCategory,
            sectionNumber: section,
            category: category,
            forCategoryVcWithReferenceBook: forCategoryVcWithReferenceBook
        ) { [weak self] in
            guard let self = self else { return }
            if let categoryToShow = subCategory.categoryToShow {
                let vc = CategoryViewController(category: categoryToShow)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if let authorToShow = subCategory.titleModelToShow as? Storyteller {
                let vc = AllTitlesViewController(subCategory: SubCategory.generalForAllTitlesVC, titleModel: authorToShow)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let subCategoryIndex = section
                if let books = self.booksDict[subCategoryIndex] {
                    let vc = AllTitlesViewController(subCategory: subCategory, books: books)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if !subCategories.isEmpty {
            let subCategory = subCategories[section]
            return SectionHeaderView.calculateEstimatedHeightFor(
                subCategory: subCategory,
                superviewWidth: view.bounds.width)
        } else {
            return 0
        }
    }
    
    override func configureNavBar() {
        super.configureNavBar()
        guard let category = category else { return }
        var text = category.title
        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text
    }
    
    override func adjustNavBarAppearanceTo(currentOffsetY: CGFloat) {
        var offsetYToCompareTo: CGFloat = tableViewInitialOffsetY
        if referenceBook == nil {
            if let tableHeaderHeight = bookTable.tableHeaderView?.bounds.size.height {
                offsetYToCompareTo = tableViewInitialOffsetY + tableHeaderHeight + 10
                changeHeaderDimViewAlphaWith(currentOffsetY: currentOffsetY)
            }
        }
        
        let visibleTitleWhenTransparent = referenceBook != nil
        navigationController?.adjustAppearanceTo(
            currentOffsetY: currentOffsetY,
            offsetYToCompareTo: offsetYToCompareTo,
            withVisibleTitleWhenTransparent: visibleTitleWhenTransparent)
    }
    
    override func fetchBooks() {
        for (index, subCategory) in subCategories.enumerated() {
            let subCategoryKind = subCategory.kind
            
            let query = subCategory.searchQuery
            networkManager.fetchBooks(
                withQuery: query,
                bookKindsToFetch: subCategory.bookKinds
            ) { [weak self] result in
                self?.handleFetchResult(result, forSubCategoryIndex: index, andSubCategoryKind: subCategoryKind)
            }
        }
    }
}

// MARK: - Helper methods
extension CategoryViewController {
    private func configureSelf() {
        extendedLayoutIncludesOpaqueBars = true
        
        /* Replace tableHeaderView with new one if vc is created when
         showMoreTitlesLikeThis BookDetailsBottomSheetCell is selected */
        if let bookToShowMoreTitlesLikeIt = referenceBook {
            let headerView = SimilarBooksTableHeaderView()
            headerView.configureFor(book: bookToShowMoreTitlesLikeIt)
            bookTable.tableHeaderView = headerView
            navigationController?.makeAppearance(transparent: true, withVisibleTitle: true)
            return
        }
        
        // Configure existing table header with dim view for all other cases
        guard let category = category else { return }
        let headerView = bookTable.tableHeaderView as? TableHeaderView
        headerView?.configureWithDimView(andText: category.title)
        navigationController?.makeAppearance(transparent: true)
    }
    
    private func createSubCategories() -> [SubCategory] {
        var subCategories = [SubCategory]()
        
        if let book = referenceBook {
            // Create subcategories based on book info
            var librosSimilaresSubCategory = SubCategory.librosSimilares
            librosSimilaresSubCategory.titleModelToShow = book
            subCategories.append(librosSimilaresSubCategory)
            
            for author in book.authors {
                let authorSubCategory = SubCategory(
                    title: "Títulos populares de este autor",
                    subtitle: author.name,
                    searchQuery: "\(author.name)",
                    titleModelToShow: author)
                subCategories.append(authorSubCategory)
            }
            
            if let series = book.series {
                // Hardcoded model for now
                let seriesTitleModel = Series.series1
                let seriesSubCategory = SubCategory(
                    title: "Más de estas series",
                    subtitle: series,
                    searchQuery: "\(series)",
                    titleModelToShow: seriesTitleModel)
                subCategories.append(seriesSubCategory)
            }
            
            let subtitle = book.category.title.replacingOccurrences(of: "\n", with: " ")
            let categoryToShow = book.category
            // searchQuery is hardcoded for now
            let subCategory = SubCategory(
                title: "Más de esta categoría",
                subtitle: subtitle,
                searchQuery: "ice",
                categoryToShow: categoryToShow)
            subCategories.append(subCategory)
            
        } else if let category = category {
            subCategories = category.subCategories
        }
        return subCategories
    }
}
