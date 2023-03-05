//
//  ViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

//enum Sections: Int {
//    case SoloParaTi = 0
//    case CrecimientoPersonalRecomendados = 1
//    case CrecimientoPersonalPopulares = 2
//    case PorqueTeInteresa = 3
//    case NovelaRecomendados = 4
//    case SeriesImageButton = 5
//    case TodasLasCategoriasImageButton = 6
//}

class HomeViewController: BaseTableViewController {
    
    private let posterBook: Book
    
    init(categoryModel: Category, posterBook: Book) {
        self.posterBook = posterBook
        super.init(categoryModel: categoryModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTable.register(WideButtonTableViewCell.self, forCellReuseIdentifier: WideButtonTableViewCell.identifier)
        bookTable.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tableHeader = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        tableHeader.updateGreetingsLabel()
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        bookTable.frame = view.bounds
        guard let tableHeader = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        tableHeader.updateGreetingsLabel()
        layoutHeaderView()
    }
    
    // MARK: - Helper Methods
    override func configureNavBar() {
        super.configureNavBar()
        title = "Home"
//        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(pointSize: Utils.navBarTitleFont.pointSize, weight: .semibold, scale: .large)
        
        let image = UIImage(systemName: "bell", withConfiguration: configuration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.backButtonTitle = ""
    }
    
    private func wideButtonCell(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WideButtonTableViewCell.identifier, for: indexPath) as? WideButtonTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        cell.configureFor(sectionKind: category.tableSections[indexPath.section].sectionKind)
        return cell
    }
    
    private func posterCell(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.identifier, for: indexPath) as? PosterTableViewCell else { return UITableViewCell()}
        
        // For respond to button tap in PosterTableViewCell
        let callbackClosure: BookButtonCallbackClosure = { [weak self] book in
            let controller = BookViewController(book: self?.posterBook)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        cell.configureFor(book: posterBook, withCallbackForButton: callbackClosure)
 
        return cell
    }
    
    private func cellWithHorizontalCv(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        
        // Dependency injection
        cell.books = category.tableSections[indexPath.row].books
        
        // Respond to button tap in BookCollectionViewCell
        cell.callbackClosure = { [weak self] book in
            guard let self = self else { return }
            let controller = BookViewController(book: book)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionKind = category.tableSections[indexPath.section].sectionKind
        
        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            return wideButtonCell(from: tableView, for: indexPath)
        } else if sectionKind == .poster {
            return posterCell(from: tableView, for: indexPath)
        } else {
            return cellWithHorizontalCv(from: tableView, for: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionKind = category.tableSections[indexPath.section].sectionKind
        
        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            return WideButtonTableViewCell.heightForRow
        } else if sectionKind == .poster {
            return PosterTableViewCell.calculatedHeightForRow
        } else {
            return Utils.heightForRowWithHorizontalCv
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionKind = category.tableSections[section].sectionKind
        
        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            return Constants.gapBetweenSectionsOfCategoryTable
        } else {
            return UITableView.automaticDimension
        }
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let sectionKind = category.tableSections[section].sectionKind

        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            return Constants.gapBetweenSectionsOfCategoryTable
        } else if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {

            // Get height for headers with no button
            let calculatedHeight = NoButtonSectionHeaderView.calculateHeaderHeightFor(section: category.tableSections[section])
//            print("calculated height for section \(section): \(height)")
            return calculatedHeight

        } else {
            // Get height for headers with button
            let calculatedHeight = SectionHeaderView.calculateHeaderHeightFor(section: category.tableSections[section])
            return calculatedHeight
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isInitialOffsetYSet else {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
//            print("initialOffsetY is SET")
            return
        }

        // Toggle navbar from transparent to visible as it does by default, but add another blur
        let currentOffsetY = scrollView.contentOffset.y
        if currentOffsetY > tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != Utils.visibleNavBarAppearance {
            navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
//            print("to visible")
        }
        
        if currentOffsetY <= tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != Utils.transparentNavBarAppearance {
            navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
//            print("to transparent")
        }
    }

}

extension HomeViewController: WideButtonTableViewCellDelegate {

    func wideButtonTableViewCellDidTapButton(_ cell: WideButtonTableViewCell, forSectionKind sectionKind: SectionKind) {
        if sectionKind == .seriesCategoryButton {
            let controller = CategoryViewController(categoryModel: Category.series)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = AllCategoriesViewController(categoryModel: Category.todasLasCategorias, categoryButtons: CategoryButton.categoriesForAllCategories)
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}
