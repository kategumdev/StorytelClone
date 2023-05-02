//
//  ScopeCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/3/23.
//

import UIKit

protocol ScopeCollectionViewCellDelegate: AnyObject {
    func scopeCollectionViewCell(withButtonKind buttonKind: ScopeButtonKind, hasOffset offset: CGPoint)
}

let tableDidRequestKeyboardDismiss = Notification.Name(
    rawValue: "tableDidRequestKeyboardDismiss")

typealias TableViewInScopeCollectionViewCellDidSelectRowCallback = (_ selectedTitle: Title) -> ()

enum ScopeCollectionViewCellKind {
    case forSearchResults
    case forBookshelf
}

class ScopeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ScopeCollectionViewCell"
    
    // MARK: - Instance properties
    weak var delegate: ScopeCollectionViewCellDelegate?
    
    var tableViewDidSelectRowCallback: TableViewInScopeCollectionViewCellDidSelectRowCallback = {_ in}
    var ellipsisButtonDidTapCallback: EllipsisButtonInScopeBookTableViewCellDidTapCallback = {_ in}
    
    var rememberedOffset: CGPoint = CGPoint(x: 0, y: 0)
    var buttonKind: ScopeButtonKind?
    var model = [Title]()
    var hasSectionHeader = true
    
    var kind: ScopeCollectionViewCellKind = .forSearchResults
    
    let resultsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = Utils.customBackgroundColor
        table.separatorColor = UIColor.clear
        
        table.register(ScopeBookTableViewCell.self, forCellReuseIdentifier: ScopeBookTableViewCell.identifier)
        table.register(ScopeNoImageTableViewCell.self, forCellReuseIdentifier: ScopeNoImageTableViewCell.identifier)
        table.register(ScopeSeriesTableViewCell.self, forCellReuseIdentifier: ScopeSeriesTableViewCell.identifier)
        table.register(SearchResultsTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchResultsTableSectionHeaderView.identifier)
        table.register(BookshelfTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: BookshelfTableSectionHeaderView.identifier)
        
        table.rowHeight = UITableView.automaticDimension
        
        // Avoid gap above custom section header
        table.sectionHeaderTopPadding = 0
        return table
    }()
    
    lazy var noBooksBackgroundView = NoBooksScopeCollectionViewBackgroundView()
    
    var backgroundViewNeedsToBeHidden = false
    
    private var isBackgroundViewAdded = false
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(resultsTable)
        resultsTable.dataSource = self
        resultsTable.delegate = self
        applyConstraints()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        // Offset is already set in cellForRowAt, but it may be set wrong. This check ensures setting correct offset
        if resultsTable.contentOffset != rememberedOffset {
            resultsTable.contentOffset = rememberedOffset
        }
        
        guard kind == .forBookshelf else { return }
        
        if !isBackgroundViewAdded {
            contentView.addSubview(noBooksBackgroundView)
//            noBooksBackgroundView.configureFor(buttonKind: buttonKind)
            noBooksBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            noBooksBackgroundView.fillSuperview()
            isBackgroundViewAdded = true
            noBooksBackgroundView.isHidden = model.count > 0
            
            if backgroundViewNeedsToBeHidden {
                noBooksBackgroundView.isHidden = true
            } else {
                noBooksBackgroundView.configureFor(buttonKind: buttonKind)
            }
            
        } else {
            print("noBooksBackgroundView.isHidden set in layoutSubviews")
            noBooksBackgroundView.isHidden = model.count > 0
            
            if backgroundViewNeedsToBeHidden {
                noBooksBackgroundView.isHidden = true
            } else {
                noBooksBackgroundView.configureFor(buttonKind: buttonKind)
            }
            
//            noBooksBackgroundView.configureFor(buttonKind: buttonKind)
        }
        
//        if !isBackgroundViewAdded {
//            contentView.addSubview(noBooksBackgroundView)
//            noBooksBackgroundView.configureFor(buttonKind: buttonKind)
//            noBooksBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//            noBooksBackgroundView.fillSuperview()
//            isBackgroundViewAdded = true
//            noBooksBackgroundView.isHidden = model.count > 0
//        } else {
//            print("noBooksBackgroundView.isHidden set in layoutSubviews")
//            noBooksBackgroundView.isHidden = model.count > 0
//            noBooksBackgroundView.configureFor(buttonKind: buttonKind)
//        }
        
    }
    
    // MARK: - Helper methods
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
        tapGesture.cancelsTouchesInView = false
        resultsTable.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesure() {
        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
    }
    
    private func applyConstraints() {
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        resultsTable.fillSuperview()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ScopeCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("MODEL.COUNT = \(model.count)")
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
//        let book = title as? Book
//        let series = title as? Series
        
        if title is Book {
            return ScopeBookTableViewCell.getEstimatedHeightForRow()
        } else if title is Series {
            return ScopeSeriesTableViewCell.getEstimatedHeightForRow()
        } else {
            return ScopeNoImageTableViewCell.getEstimatedHeightForRow()
        }

    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        let title = model[indexPath.row]
//        let book = title as? Book
//        let series = title as? Series
//
//        if book != nil {
//            return SearchResultsBookTableViewCell.getEstimatedHeightForRow()
//        } else if series != nil {
//            return SearchResultsSeriesTableViewCell.getEstimatedHeightForRow()
//        } else {
//            return SearchResultsNoImageTableViewCell.getEstimatedHeightForRow()
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt \(indexPath.row)")
        let selectedRowTitle = model[indexPath.row]
        tableViewDidSelectRowCallback(selectedRowTitle)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard hasSectionHeader, let buttonKind = buttonKind else { return UIView() }
//        guard let buttonKind = buttonKind else { return UIView() }
        
        switch kind {
        case .forSearchResults:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultsTableSectionHeaderView.identifier) as? SearchResultsTableSectionHeaderView else { return UIView() }
            header.configurefor(buttonKind: buttonKind)
//            print("returning header forSearchResults")
            return header
        case .forBookshelf:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookshelfTableSectionHeaderView.identifier) as? BookshelfTableSectionHeaderView else { return UIView() }
            header.configurefor(buttonKind: buttonKind)
//            print("returning header forBookshelf")
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return hasSectionHeader ? UITableView.automaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard hasSectionHeader else { return 0 }
        
        switch kind {
        case .forSearchResults:
            return SearchResultsTableSectionHeaderView.calculateEstimatedHeaderHeight()
        case .forBookshelf:
            return BookshelfTableSectionHeaderView.calculateEstimatedHeaderHeight()
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension ScopeCollectionViewCell {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isDecelerating {
            guard let buttonKind = buttonKind else { return }
            delegate?.scopeCollectionViewCell(withButtonKind: buttonKind, hasOffset: scrollView.contentOffset)
        }
    }
    
}


