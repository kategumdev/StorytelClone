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

class HomeViewController: BaseViewController {
    
    private let posterBook: Book
    private let popupButton = PopupButton()

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
        bookTable.register(TableViewCellWithHorzCvLargeCovers.self, forCellReuseIdentifier: TableViewCellWithHorzCvLargeCovers.identifier)
        bookTable.register(BookWithOverviewTableViewCell.self, forCellReuseIdentifier: BookWithOverviewTableViewCell.identifier)
        
        // Bottom inset is needed to avoid little table view scroll when user is at the very bottom of table view and popButton shows
        bookTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: PopupButton.buttonHeight, right: 0)
        
        view.addSubview(popupButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustNavBarAppearanceTo(currentOffsetY: bookTable.contentOffset.y)
        
        if let tableHeader = bookTable.tableHeaderView as? TableHeaderView {
            tableHeader.updateGreetingsLabel()
        }
    }
    
    override func viewDidLayoutSubviews() {
        bookTable.frame = view.bounds
        guard let tableHeader = bookTable.tableHeaderView as? TableHeaderView else { return }
        tableHeader.stackTopAnchorConstraint.constant = 15
        tableHeader.stackBottomAnchorConstraint.constant = 0
        tableHeader.updateGreetingsLabel()
        Utils.layoutTableHeaderView(tableHeader, inTableView: bookTable)
//        layoutHeaderView()
    }
    
    // MARK: - Superclass overrides
    override func configureNavBar() {
        super.configureNavBar()
        let pointSize = UIFont.navBarTitle.fontDescriptor.pointSize
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .semibold, scale: .large)
        let image = UIImage(systemName: "bell", withConfiguration: symbolConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        title = "Home"
        extendedLayoutIncludesOpaqueBars = true
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("section \(indexPath.row)")
        guard let category = category else { return UITableViewCell() }
        let sectionKind = category.tableSections[indexPath.section].sectionKind

        switch sectionKind {
        case .horizontalCv: return cellWithHorizontalCv(in: tableView, for: indexPath)
        case .verticalCv: return UITableViewCell()
        case .oneBookWithOverview: return bookWithOverviewCell(in: tableView, for: indexPath)
        case .poster: return posterCell(in: tableView, for: indexPath)
        case .largeCoversHorizontalCv: return cellWithLargeCoversHorizontalCv(in: tableView, for: indexPath)
        case .seriesCategoryButton: return wideButtonCell(in: tableView, for: indexPath)
        case .allCategoriesButton: return wideButtonCell(in: tableView, for: indexPath)
        case .searchVc: return UITableViewCell()
        }
        #warning("cells for verticalCv and searchVc not needed, refactor them somewhere else")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let category = category else { return 0 }
        let sectionKind = category.tableSections[indexPath.section].sectionKind
        
        switch sectionKind {
        case .horizontalCv: return Utils.heightForRowWithHorizontalCv
        case .verticalCv: return 0
        case .oneBookWithOverview:
            let book = category.tableSections[indexPath.section].books[0]
            return BookWithOverviewTableViewCell.calculateHeightForRow(withBook: book)
            
        case .poster: return PosterTableViewCell.calculatedHeightForRow
        case .largeCoversHorizontalCv: return Utils.heightForRowWithHorzCvLargeCovers
        case .seriesCategoryButton: return Utils.heightForRowWithWideButton
        case .allCategoriesButton: return Utils.heightForRowWithWideButton
        case .searchVc: return 0
        }
        #warning("cases verticalCv and searchVc not needed here, refactor them somewhere else")
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let category = category else { return 0 }
        let sectionKind = category.tableSections[section].sectionKind
        
        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            return Constants.sectionHeaderViewTopPadding
        } else {
            return UITableView.automaticDimension
        }
    }

}

// MARK: - Helper methods
extension HomeViewController {
    private func wideButtonCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WideButtonTableViewCell.identifier, for: indexPath) as? WideButtonTableViewCell else { return UITableViewCell()}
        if let category = category {
            cell.configureFor(sectionKind: category.tableSections[indexPath.section].sectionKind, withCallback: dimmedAnimationButtonDidTapCallback)
        }
        return cell
    }
    
    private func posterCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.identifier, for: indexPath) as? PosterTableViewCell else { return UITableViewCell()}
        cell.configureFor(book: posterBook, withCallback: dimmedAnimationButtonDidTapCallback)
         return cell
    }
    
    private func cellWithHorizontalCv(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection, let category = category else { return UITableViewCell() }
        let books = category.tableSections[indexPath.section].books
        cell.configureWith(books: books, callback: dimmedAnimationButtonDidTapCallback)
        return cell
    }
    
    private func cellWithLargeCoversHorizontalCv(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithHorzCvLargeCovers.identifier, for: indexPath) as? TableViewCellWithHorzCvLargeCovers, let category = category else { return UITableViewCell()}
        let books = category.tableSections[indexPath.section].books
        cell.configureWith(books: books, callback: dimmedAnimationButtonDidTapCallback)
        return cell
    }
    
    private func bookWithOverviewCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookWithOverviewTableViewCell.identifier, for: indexPath) as? BookWithOverviewTableViewCell, let category = category else { return UITableViewCell() }
        let book = category.tableSections[indexPath.section].books[0]
        
        cell.configureFor(book: book, withCallbackForDimmedAnimationButton: dimmedAnimationButtonDidTapCallback, withCallbackForSaveButton: popupButton.reconfigureAndAnimateSelf)
         return cell
    }

}
