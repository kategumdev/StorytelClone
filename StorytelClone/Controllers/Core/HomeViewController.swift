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
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTable.register(WideButtonTableViewCell.self, forCellReuseIdentifier: WideButtonTableViewCell.identifier)
//        configureNavBar()
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
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "bell", withConfiguration: configuration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionKind = vcCategory.tableSections[indexPath.section].sectionKind
        
        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WideButtonTableViewCell.identifier, for: indexPath) as? WideButtonTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.configureFor(sectionKind: vcCategory.tableSections[indexPath.section].sectionKind)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionKind = vcCategory.tableSections[indexPath.section].sectionKind
        
        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            return WideButtonTableViewCell.heightForRow
        } else {
            return Utils.heightForRowWithHorizontalCv
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionKind = vcCategory.tableSections[section].sectionKind
        
        guard sectionKind != .seriesCategoryButton, sectionKind != .allCategoriesButton else { return UIView()}
        
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UIView() }
        
        sectionHeader.configureFor(section: vcCategory.tableSections[section])
        return sectionHeader
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionKind = vcCategory.tableSections[section].sectionKind
        
        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            return Constants.gapBetweenSectionsOfCategoryTable
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let sectionKind = vcCategory.tableSections[section].sectionKind
        
        if sectionKind == .seriesCategoryButton || sectionKind == .allCategoriesButton {
            return Constants.gapBetweenSectionsOfCategoryTable
        } else {
            let calculatedHeight = SectionHeaderSubviewsContainer.calculateHeaderHeightFor(section: vcCategory.tableSections[section])
            print("calculated height for section \(section): \(calculatedHeight)")
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
        if currentOffsetY > tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != visibleAppearance {
            navigationController?.navigationBar.standardAppearance = visibleAppearance
//            print("to visible")
        }
        
        if currentOffsetY <= tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != transparentAppearance {
            navigationController?.navigationBar.standardAppearance = transparentAppearance
//            print("to transparent")
        }
    }

}

extension HomeViewController: WideButtonTableViewCellDelegate {

    func wideButtonTableViewCellDidTapButton(_ cell: WideButtonTableViewCell, forSectionKind sectionKind: SectionKind) {
        if sectionKind == .seriesCategoryButton {
            let controller = SeriesViewController(model: Category.series)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = AllCategoriesViewController(categories: Category.allCategories)
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}
