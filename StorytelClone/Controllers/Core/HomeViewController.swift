//
//  ViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

enum Sections: Int {
    case SoloParaTi = 0
    case CrecimientoPersonalRecomendados = 1
    case CrecimientoPersonalPopulares = 2
    case PorqueTeInteresa = 3
    case NovelaRecomendados = 4
    case SeriesImageButton = 5
    case TodasLasCategoriasImageButton = 6
}


class HomeViewController: BaseTableViewController {
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVc()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tableHeader = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        tableHeader.updateGreetingsLabel()
    }
    
    override func viewDidLayoutSubviews() {
//        print("viewDidLayoutSubviews")
        bookTable.frame = view.bounds
        guard let tableHeader = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        tableHeader.updateGreetingsLabel()
        layoutHeaderView()
    }
    
    // MARK: - Helper Methods
    private func configureVc() {
        sectionTitles = ["Solo para ti", "Crecimiento personal: Recomendados para ti", "Crecimiento personal: Los más populares", "Porque te interesa", "Novela: Recomendados para ti", "", ""]
        sectionSubtitles = ["", "", "", "Alice's Adventures in Wonderland", "", "", ""]
        
        bookTable.register(WideButtonTableViewCell.self, forCellReuseIdentifier: WideButtonTableViewCell.identifier)
    }
    
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
        if indexPath.section == 5 || indexPath.section == 6 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: WideButtonTableViewCell.identifier, for: indexPath) as? WideButtonTableViewCell else { return UITableViewCell()}
            // Using hardcoded data
            if indexPath.section == 5 {
                cell.wideButtonLabel.text = "Series"
                cell.buttonKind = .series
            } else {
                cell.wideButtonLabel.text = "Todas las categorías"
                cell.buttonKind = .allCategories
            }

            cell.delegate = self
            return cell
        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == tableView.numberOfSections - 1 || indexPath.section == tableView.numberOfSections - 2 {
            return WideButtonTableViewCell.heightForRow
        }
        return Utils.heightForRowWithSquareCoversCv
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != tableView.numberOfSections - 1, section != tableView.numberOfSections - 2 else { return UIView() }
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UITableViewHeaderFooterView() }

        sectionHeaderView.sectionTitleLabel.text = sectionTitles[section]
        sectionHeaderView.sectionSubtitleLabel.text = sectionSubtitles[section]
        return sectionHeaderView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 2 {
            return Constants.gapBetweenSectionsOfTablesWithSquareCovers
        } else if section == bookTable.numberOfSections - 1 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isInitialOffsetYSet else {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
            print("initialOffsetY is SET")
            return
        }

        // Toggle navbar from transparent to visible as it does by default, but add another blur
        let currentOffsetY = scrollView.contentOffset.y
        if currentOffsetY > tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != visibleAppearance {
            navigationController?.navigationBar.standardAppearance = visibleAppearance
            print("to visible")
        }
        
        if currentOffsetY <= tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != transparentAppearance {
            navigationController?.navigationBar.standardAppearance = transparentAppearance
            print("to transparent")
        }
    }

}

extension HomeViewController: WideButtonTableViewCellDelegate {
    func wideButtonTableViewCellDidTapButton(_ cell: WideButtonTableViewCell, withButtonKind buttonKind: WideButtonTableViewCell.ButtonKind) {
        if buttonKind == .series {
            let controller = SeriesViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = AllCategoriesViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}
