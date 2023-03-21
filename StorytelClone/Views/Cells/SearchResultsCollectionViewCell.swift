//
//  SearchResultsCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/3/23.
//

import UIKit

protocol SearchResultsCollectionViewCellDelegate: AnyObject {
    
    func searchResultsCollectionViewCell(_ searchResultsCollectionViewCell: SearchResultsCollectionViewCell, withButtonKind buttonKind: ButtonKind, hasOffset offset: CGPoint)
}

let tableDidRequestKeyboardDismiss = Notification.Name(
    rawValue: "tableDidRequestKeyboardDismiss")

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultsCollectionViewCell"
    
    weak var delegate: SearchResultsCollectionViewCellDelegate?
    
    var selectedTitleCallback: SelectedTitleCallback = {_ in}
    var rememberedOffset: CGPoint = CGPoint(x: 0, y: 0)
    var buttonKind: ButtonKind?
    var model = [Title]()
    var withSectionHeader = true
    
    let resultsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)

        table.backgroundColor = Utils.customBackgroundColor
        table.separatorColor = UIColor.clear
        
        table.register(SearchResultsBookTableViewCell.self, forCellReuseIdentifier: SearchResultsBookTableViewCell.identifier)
        table.register(SearchResultsNoImageTableViewCell.self, forCellReuseIdentifier: SearchResultsNoImageTableViewCell.identifier)
        table.register(SearchResultsSeriesTableViewCell.self, forCellReuseIdentifier: SearchResultsSeriesTableViewCell.identifier)
        table.register(SearchResultsSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchResultsSectionHeaderView.identifier)
        
        table.rowHeight = UITableView.automaticDimension
//        table.sectionHeaderHeight = UITableView.automaticDimension
        // Avoid gap above custom section header
        table.sectionHeaderTopPadding = 0
        return table
    }()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Offset is already set in cellForRowAt, but it may be set wrong. This check ensures setting correct offset
        if resultsTable.contentOffset != rememberedOffset {
            resultsTable.contentOffset = rememberedOffset
        }
        
    }
    
    private func applyConstraints() {
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        resultsTable.fillSuperview()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
////        print("prepareForReuse")
////        isBeingReused = true
//    }
    
    // MARK: - Helper methods
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
        tapGesture.cancelsTouchesInView = false
        resultsTable.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesure() {
        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchResultsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = model[indexPath.row]
        
        if let book = title as? Book {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsBookTableViewCell.identifier, for: indexPath) as? SearchResultsBookTableViewCell else { return UITableViewCell() }
            
            cell.configureFor(book: book)
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
        print("didSelectRowAt \(indexPath.row)")
        
        let selectedTitle = model[indexPath.row]
        selectedTitleCallback(selectedTitle)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard withSectionHeader else { return UIView() }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultsSectionHeaderView.identifier) as? SearchResultsSectionHeaderView else { return UIView() }

        if let buttonKind = buttonKind {
            header.configureFor(buttonKind: buttonKind)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if withSectionHeader {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if withSectionHeader {
            return SearchResultsSectionHeaderView.calculateEstimatedHeaderHeight()
        } else {
            return 0
        }
    }

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


