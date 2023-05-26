//
//  ScopeCollectionViewWithTableView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import UIKit

let tableDidRequestKeyboardDismiss = Notification.Name(
    rawValue: "tableDidRequestKeyboardDismiss")

typealias TableViewInScopeCollectionViewCellDidSelectRowCallback = (_ selectedTitle: Title) -> ()

class ScopeTableView: UITableView {
    
    var tableViewDidSelectRowCallback: TableViewInScopeCollectionViewCellDidSelectRowCallback = {_ in}
    var ellipsisButtonDidTapCallback: EllipsisButtonInScopeBookTableViewCellDidTapCallback = {_ in}
    
//    var rememberedOffset: CGPoint = CGPoint(x: 0, y: 0)
//    var buttonKind: ScopeButtonKind?
    let buttonKind: ScopeButtonKind
    var model = [Title]()
    var hasSectionHeader = true
    let scopeButtonsViewKind: ScopeButtonsViewKind
//    var scopeButtonsViewKind: ScopeButtonsViewKind = .forSearchResultsVc // placeholder value
    
    private lazy var filterTableHeader = BookshelfTableHeaderView()
    private var isFilterTableHeaderAdded = false
        
    private lazy var noBooksBackgroundView = NoBooksScopeCollectionViewBackgroundView()
    private var isBackgroundViewAdded = false
//    var backgroundViewNeedsToBeHidden = false // When button in scopeButtonsView is tapped, collectionView scrolls and
    
    // MARK: - Initializers
    init(buttonKind: ScopeButtonKind, scopeButtonsViewKind: ScopeButtonsViewKind) {
        self.buttonKind = buttonKind
        self.scopeButtonsViewKind = scopeButtonsViewKind
        super.init(frame: .zero, style: .plain)
        configureSelf()
        dataSource = self
        delegate = self
        setupTapGesture()
    }
    
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: .zero, style: .plain)
//        dataSource = self
//        delegate = self
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
        
        guard scopeButtonsViewKind == .forBookshelfVc else { return }
        configureTableHeaderAndBackgroundView()
    }
    
    // MARK: - Helper methods
//    private func configureWith(model: [Title], )
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
//        resultsTable.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesure() {
        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
    }
    
    private func configureSelf() {
        backgroundColor = UIColor.customBackgroundColor
        separatorColor = UIColor.clear
        
        register(ScopeBookTableViewCell.self, forCellReuseIdentifier: ScopeBookTableViewCell.identifier)
        register(ScopeNoImageTableViewCell.self, forCellReuseIdentifier: ScopeNoImageTableViewCell.identifier)
        register(ScopeSeriesTableViewCell.self, forCellReuseIdentifier: ScopeSeriesTableViewCell.identifier)
        register(ScopeTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ScopeTableSectionHeaderView.identifier)
        
        rowHeight = UITableView.automaticDimension
        
        // Avoid gap above custom section header
        sectionHeaderTopPadding = 0
        
        tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTableHeaderAndBackgroundView() {
        if !isFilterTableHeaderAdded {
            tableHeaderView = filterTableHeader
            isFilterTableHeaderAdded = true
        }
        Utils.layoutTableHeaderView(filterTableHeader, inTableView: self)
        filterTableHeader.isHidden = model.count == 0

        if !isBackgroundViewAdded && model.isEmpty {
            addSubview(noBooksBackgroundView)
            noBooksBackgroundView.frame = bounds
            isBackgroundViewAdded = true
            noBooksBackgroundView.configureFor(buttonKind: buttonKind)
        }
                
        if isBackgroundViewAdded {
            noBooksBackgroundView.isHidden = model.count > 0
                    
            // Avoid bouncing only when backgroundView is onscreen
            alwaysBounceVertical = noBooksBackgroundView.isHidden
        }
        
//        filterTableHeader.isHidden = model.count == 0
        
        
        
        
//        noBooksBackgroundView.isHidden = model.count > 0
//
//        // Avoid bouncing only when backgroundView is onscreen
//        alwaysBounceVertical = noBooksBackgroundView.isHidden
    }
    
//    private func configureTableHeaderAndBackgroundView() {
//        if !isFilterTableHeaderAdded {
//            tableHeaderView = filterTableHeader
//            isFilterTableHeaderAdded = true
//            Utils.layoutTableHeaderView(filterTableHeader, inTableView: self)
//        } else {
//            Utils.layoutTableHeaderView(filterTableHeader, inTableView: self)
//        }
//
//        if !isBackgroundViewAdded {
//            addSubview(noBooksBackgroundView)
//            noBooksBackgroundView.frame = bounds
//            isBackgroundViewAdded = true
//            noBooksBackgroundView.isHidden = model.count > 0
//            filterTableHeader.isHidden = model.count == 0
//            noBooksBackgroundView.configureFor(buttonKind: buttonKind)
//        } else {
//            noBooksBackgroundView.isHidden = model.count > 0
//            filterTableHeader.isHidden = model.count == 0
////            noBooksBackgroundView.configureFor(buttonKind: buttonKind)
//        }
//
//        // Avoid bouncing only when backgroundView is onscreen
//        alwaysBounceVertical = noBooksBackgroundView.isHidden
//    }
    
//    private func configureTableHeaderAndBackgroundView() {
//        if !isFilterTableHeaderAdded {
////            print("header is ADDED")
//            tableHeaderView = filterTableHeader
//            isFilterTableHeaderAdded = true
//            Utils.layoutTableHeaderView(filterTableHeader, inTableView: self)
//        } else {
//            Utils.layoutTableHeaderView(filterTableHeader, inTableView: self)
//        }
//
//        if !isBackgroundViewAdded {
////            contentView.addSubview(noBooksBackgroundView)
//            addSubview(noBooksBackgroundView)
//            noBooksBackgroundView.frame = bounds
////            noBooksBackgroundView.translatesAutoresizingMaskIntoConstraints = false
////            noBooksBackgroundView.fillSuperview()
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
//
//        // Avoid bouncing only when backgroundView is onscreen
//        alwaysBounceVertical = noBooksBackgroundView.isHidden
//    }
    
//    private func applyConstraints() {
//        resultsTable.translatesAutoresizingMaskIntoConstraints = false
//        resultsTable.fillSuperview()
//    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ScopeTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("MODEL.COUNT = \(model.count)")
        return model.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard model.count > 0 else { return }
        let title = model[indexPath.row]
        
        if let book = title as? Book {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScopeBookTableViewCell.identifier, for: indexPath) as? ScopeBookTableViewCell else { return UITableViewCell() }
            
            cell.configureFor(book: book)
            cell.ellipsisButtonDidTapCallback = self.ellipsisButtonDidTapCallback
            return cell
        }
        
        if let series = title as? Series {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScopeSeriesTableViewCell.identifier, for: indexPath) as? ScopeSeriesTableViewCell else { return UITableViewCell() }
            
            cell.configureFor(series: series)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScopeNoImageTableViewCell.identifier, for: indexPath) as? ScopeNoImageTableViewCell else { return UITableViewCell() }
        
        cell.configureFor(title: title)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = model[indexPath.row]
        
        if title is Book {
            return ScopeBookTableViewCell.getEstimatedHeightForRow()
        } else if title is Series {
            return ScopeSeriesTableViewCell.getEstimatedHeightForRow()
        } else {
            return ScopeNoImageTableViewCell.getEstimatedHeightForRow()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt \(indexPath.row)")
        let selectedRowTitle = model[indexPath.row]
        tableViewDidSelectRowCallback(selectedRowTitle)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard hasSectionHeader,
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ScopeTableSectionHeaderView.identifier) as? ScopeTableSectionHeaderView else {
            return UIView()
        }
        header.configureFor(buttonKind: buttonKind)
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard hasSectionHeader else { return 0 }
        return ScopeTableSectionHeaderView.calculateEstimatedHeaderHeight(buttonKind: buttonKind)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return hasSectionHeader ? UITableView.automaticDimension : 0
    }
    
}

// MARK: - UIScrollViewDelegate
extension ScopeTableView {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isDecelerating {
//            guard let buttonKind = buttonKind else { return }
//            delegate?.scopeCollectionViewCell(withButtonKind: buttonKind, hasOffset: scrollView.contentOffset)
        }
    }
    
}
