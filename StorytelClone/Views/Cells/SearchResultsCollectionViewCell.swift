//
//  SearchResultsCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/3/23.
//

import UIKit

protocol SearchResultsCollectionViewCellDelegate: AnyObject {
    func searchResultsCollectionViewCell(_ searchResultsCollectionViewCell: SearchResultsCollectionViewCell, withButtonKind buttonKind: ScopeButtonKind, hasOffset offset: CGPoint)
}

let tableDidRequestKeyboardDismiss = Notification.Name(
    rawValue: "tableDidRequestKeyboardDismiss")

typealias SearchResultsDidSelectRowCallback = (_ selectedSearchResultTitle: Title) -> ()

enum PagingCollectionViewCellKind {
    case forSearchResults
    case forBookshelf
}

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultsCollectionViewCell"
    
    // MARK: - Instance properties
    weak var delegate: SearchResultsCollectionViewCellDelegate?
    
    var searchResultsDidSelectRowCallback: SearchResultsDidSelectRowCallback = {_ in}
    var ellipsisButtonDidTapCallback: EllipsisButtonInSearchResultsDidTapCallback = {_ in}
    
    var rememberedOffset: CGPoint = CGPoint(x: 0, y: 0)
    var buttonKind: ScopeButtonKind?
    var model = [Title]()
    var withSectionHeader = true
    
    var kind: PagingCollectionViewCellKind = .forSearchResults
//    var sectionHeaderTopAndBottomPadding: CGFloat = 0
    
    let resultsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = Utils.customBackgroundColor
        table.separatorColor = UIColor.clear
        
        table.register(SearchResultsBookTableViewCell.self, forCellReuseIdentifier: SearchResultsBookTableViewCell.identifier)
        table.register(SearchResultsNoImageTableViewCell.self, forCellReuseIdentifier: SearchResultsNoImageTableViewCell.identifier)
        table.register(SearchResultsSeriesTableViewCell.self, forCellReuseIdentifier: SearchResultsSeriesTableViewCell.identifier)
        table.register(SearchResultsSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchResultsSectionHeaderView.identifier)
        table.register(BookshelfTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: BookshelfTableSectionHeaderView.identifier)
        
        table.rowHeight = UITableView.automaticDimension
        
        // Avoid gap above custom section header
        table.sectionHeaderTopPadding = 0
        return table
    }()
    
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
extension SearchResultsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsBookTableViewCell.identifier, for: indexPath) as? SearchResultsBookTableViewCell else { return UITableViewCell() }
            
            cell.configureFor(book: book)
            cell.ellipsisButtonDidTapCallback = self.ellipsisButtonDidTapCallback
            return cell
        }
        
        if let series = title as? Series {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSeriesTableViewCell.identifier, for: indexPath) as? SearchResultsSeriesTableViewCell else { return UITableViewCell() }
            
            cell.configureFor(series: series)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsNoImageTableViewCell.identifier, for: indexPath) as? SearchResultsNoImageTableViewCell else { return UITableViewCell() }
        
        cell.configureFor(title: title)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = model[indexPath.row]
        
        let book = title as? Book
        let series = title as? Series
        
        if book != nil {
            return SearchResultsBookTableViewCell.getEstimatedHeightForRow()
        } else if series != nil {
            return SearchResultsSeriesTableViewCell.getEstimatedHeightForRow()
        } else {
            return SearchResultsNoImageTableViewCell.getEstimatedHeightForRow()

        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt \(indexPath.row)")
        let selectedRowTitle = model[indexPath.row]
        searchResultsDidSelectRowCallback(selectedRowTitle)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard withSectionHeader, let buttonKind = buttonKind else { return UIView() }
//        guard let buttonKind = buttonKind else { return UIView() }
        
        switch kind {
        case .forSearchResults:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultsSectionHeaderView.identifier) as? SearchResultsSectionHeaderView else { return UIView() }
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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard withSectionHeader else { return UIView() }
//
//        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultsSectionHeaderView.identifier) as? SearchResultsSectionHeaderView else { return UIView() }
//
//        if let buttonKind = buttonKind {
//            header.configure(buttonKind: buttonKind)
////            header.configureWith(topAndBottomPadding: sectionHeaderTopAndBottomPadding, forButtonKind: buttonKind)
//        }
//        return header
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if withSectionHeader {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard withSectionHeader else { return 0 }
        
        switch kind {
        case .forSearchResults:
            return SearchResultsSectionHeaderView.calculateEstimatedHeaderHeight()
        case .forBookshelf:
            return BookshelfTableSectionHeaderView.calculateEstimatedHeaderHeight()
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        if withSectionHeader {
////            return SearchResultsSectionHeaderView.calculateEstimatedHeighWith()
//            return SearchResultsSectionHeaderView.calculateEstimatedHeighWith(topAndBottomPadding: sectionHeaderTopAndBottomPadding)
//        } else {
//            return 0
//        }
//    }

}

// MARK: - UIScrollViewDelegate
extension SearchResultsCollectionViewCell {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isDecelerating {
            guard let buttonKind = buttonKind else { return }
            delegate?.searchResultsCollectionViewCell(self, withButtonKind: buttonKind, hasOffset: scrollView.contentOffset)
        }
    }
    
}


