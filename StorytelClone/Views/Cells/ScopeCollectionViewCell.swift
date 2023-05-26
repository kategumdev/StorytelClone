//
//  ScopeCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/3/23.
//

import UIKit

//protocol ScopeCollectionViewCellDelegate: AnyObject {
//    func scopeCollectionViewCell(withButtonKind buttonKind: ScopeButtonKind, hasOffset offset: CGPoint)
//}

//let tableDidRequestKeyboardDismiss = Notification.Name(
//    rawValue: "tableDidRequestKeyboardDismiss")
//
//typealias TableViewInScopeCollectionViewCellDidSelectRowCallback = (_ selectedTitle: Title) -> ()

class ScopeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ScopeCollectionViewCell"
    
    // MARK: - Instance properties
//    weak var delegate: ScopeCollectionViewCellDelegate?
    
//    var tableViewDidSelectRowCallback: TableViewInScopeCollectionViewCellDidSelectRowCallback = {_ in}
//    var ellipsisButtonDidTapCallback: EllipsisButtonInScopeBookTableViewCellDidTapCallback = {_ in}
//
//    var rememberedOffset: CGPoint = CGPoint(x: 0, y: 0)
//    var buttonKind: ScopeButtonKind?
//    var model = [Title]()
//    var hasSectionHeader = true
//    var scopeButtonsViewKind: ScopeButtonsViewKind = .forSearchResultsVc // placeholder value
    
//    let resultsTable: UITableView = {
//        let table = UITableView(frame: .zero, style: .plain)
//        table.backgroundColor = UIColor.customBackgroundColor
//        table.separatorColor = UIColor.clear
//
//        table.register(ScopeBookTableViewCell.self, forCellReuseIdentifier: ScopeBookTableViewCell.identifier)
//        table.register(ScopeNoImageTableViewCell.self, forCellReuseIdentifier: ScopeNoImageTableViewCell.identifier)
//        table.register(ScopeSeriesTableViewCell.self, forCellReuseIdentifier: ScopeSeriesTableViewCell.identifier)
//        table.register(ScopeTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ScopeTableSectionHeaderView.identifier)
//
//        table.rowHeight = UITableView.automaticDimension
//
//        // Avoid gap above custom section header
//        table.sectionHeaderTopPadding = 0
//
//        table.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
//        return table
//    }()
    
//    private lazy var filterTableHeader = BookshelfTableHeaderView()
//    private var isFilterTableHeaderAdded = false
        
//    private lazy var noBooksBackgroundView = NoBooksScopeCollectionViewBackgroundView()
//    private var isBackgroundViewAdded = false
//    var backgroundViewNeedsToBeHidden = false
    
//    var scopeTableView: ScopeTableView?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.customBackgroundColor
        
//        guard let scopeTableView = scopeTableView else { return }
//        contentView.addSubview(scopeTableView)
//        scopeTableView.translatesAutoresizingMaskIntoConstraints = false
//        scopeTableView.fillSuperview()
        
//        resultsTable.dataSource = self
//        resultsTable.delegate = self
//        applyConstraints()
//        setupTapGesture()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = UIColor.customBackgroundColor
//        contentView.addSubview(resultsTable)
//        resultsTable.dataSource = self
//        resultsTable.delegate = self
//        applyConstraints()
//        setupTapGesture()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        // Offset is already set in cellForRowAt, but it may be set wrong. This check ensures setting correct offset
//        if resultsTable.contentOffset != rememberedOffset {
//            resultsTable.contentOffset = rememberedOffset
//        }
        
//        guard scopeButtonsViewKind == .forBookshelfVc else { return }
//        configureTableHeaderAndBackgroundView()
    }
    
    // MARK: - Helper methods
//    private func setupTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
//        tapGesture.cancelsTouchesInView = false
//        resultsTable.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func handleTapGesure() {
//        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
//    }
//
//    private func configureTableHeaderAndBackgroundView() {
//        if !isFilterTableHeaderAdded {
////            print("header is ADDED")
//            resultsTable.tableHeaderView = filterTableHeader
//            isFilterTableHeaderAdded = true
//            Utils.layoutTableHeaderView(filterTableHeader, inTableView: resultsTable)
//        } else {
//            Utils.layoutTableHeaderView(filterTableHeader, inTableView: resultsTable)
//        }
//
//        if !isBackgroundViewAdded {
//            contentView.addSubview(noBooksBackgroundView)
//            noBooksBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//            noBooksBackgroundView.fillSuperview()
//            isBackgroundViewAdded = true
//            noBooksBackgroundView.isHidden = model.count > 0
//            filterTableHeader.isHidden = model.count == 0
////            resultsTable.isHidden = model.count == 0
//
//            if backgroundViewNeedsToBeHidden {
//                noBooksBackgroundView.isHidden = true
//            } else {
//                noBooksBackgroundView.configureFor(buttonKind: buttonKind)
//            }
//        } else {
//            noBooksBackgroundView.isHidden = model.count > 0
//            filterTableHeader.isHidden = model.count == 0
////            resultsTable.isHidden = model.count == 0
//
//            if backgroundViewNeedsToBeHidden {
//                noBooksBackgroundView.isHidden = true
//            } else {
//                noBooksBackgroundView.configureFor(buttonKind: buttonKind)
//            }
//        }
//    }
    
//    private func applyConstraints() {
//        resultsTable.translatesAutoresizingMaskIntoConstraints = false
//        resultsTable.fillSuperview()
//    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
//extension ScopeCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        print("MODEL.COUNT = \(model.count)")
//        return model.count
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        guard model.count > 0 else { return }
//        let title = model[indexPath.row]
//
//        if let book = title as? Book {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScopeBookTableViewCell.identifier, for: indexPath) as? ScopeBookTableViewCell else { return UITableViewCell() }
//
//            cell.configureFor(book: book)
//            cell.ellipsisButtonDidTapCallback = self.ellipsisButtonDidTapCallback
//            return cell
//        }
//
//        if let series = title as? Series {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScopeSeriesTableViewCell.identifier, for: indexPath) as? ScopeSeriesTableViewCell else { return UITableViewCell() }
//
//            cell.configureFor(series: series)
//            return cell
//        }
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScopeNoImageTableViewCell.identifier, for: indexPath) as? ScopeNoImageTableViewCell else { return UITableViewCell() }
//
//        cell.configureFor(title: title)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        let title = model[indexPath.row]
//
//        if title is Book {
//            return ScopeBookTableViewCell.getEstimatedHeightForRow()
//        } else if title is Series {
//            return ScopeSeriesTableViewCell.getEstimatedHeightForRow()
//        } else {
//            return ScopeNoImageTableViewCell.getEstimatedHeightForRow()
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        print("didSelectRowAt \(indexPath.row)")
//        let selectedRowTitle = model[indexPath.row]
//        tableViewDidSelectRowCallback(selectedRowTitle)
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard hasSectionHeader, let buttonKind = buttonKind,
//              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ScopeTableSectionHeaderView.identifier) as? ScopeTableSectionHeaderView else {
//            return UIView()
//        }
//        header.configureFor(buttonKind: buttonKind)
//        return header
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        guard hasSectionHeader, let buttonKind = buttonKind else { return 0 }
//        return ScopeTableSectionHeaderView.calculateEstimatedHeaderHeight(buttonKind: buttonKind)
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return hasSectionHeader ? UITableView.automaticDimension : 0
//    }
//
//}

// MARK: - UIScrollViewDelegate
//extension ScopeCollectionViewCell {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.isDragging || scrollView.isDecelerating {
//            guard let buttonKind = buttonKind else { return }
//            delegate?.scopeCollectionViewCell(withButtonKind: buttonKind, hasOffset: scrollView.contentOffset)
//        }
//    }
//    
//}


