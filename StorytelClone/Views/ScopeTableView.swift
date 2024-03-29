//
//  ScopeTableView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import UIKit

let scopeTableViewDidRequestKeyboardDismiss = Notification.Name(
    rawValue: "scopeTableViewDidRequestKeyboardDismiss")

typealias ScopeTableViewDidSelectRowCallback = (_ selectedTitle: Title) -> ()

class ScopeTableView: UITableView {
    var model = [Title]()
    let buttonKind: ScopeButtonKind
    var networkManagerError: NetworkManagerError?
    var hasSectionHeader = true
    let scopeButtonsViewKind: ScopeButtonsViewKind
    
    private lazy var customTableHeader = BookshelfTableHeaderView()
    private var isCustomTableHeaderAdded = false
    
    var tableViewDidSelectRowCallback: ScopeTableViewDidSelectRowCallback = {_ in}
    var ellipsisBtnDidTapCallback: EllipsisBtnInScopeBookTableViewCellDidTapCallback = {_ in}
    
    // MARK: - Initializers
    init(buttonKind: ScopeButtonKind, scopeButtonsViewKind: ScopeButtonsViewKind) {
        self.buttonKind = buttonKind
        self.scopeButtonsViewKind = scopeButtonsViewKind
        super.init(frame: .zero, style: .plain)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        configureNoBooksBackgroundView()

        if scopeButtonsViewKind == .forBookshelfVc {
            configureTableHeader()
        }
    }
    
    // MARK: - Helper methods
    private func setupUI() {
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.customBackgroundColor
        separatorColor = UIColor.clear
        rowHeight = UITableView.automaticDimension
        tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderTopPadding = 0 // Avoid gap above custom section header
        
        register(
            ScopeBookTableViewCell.self,
            forCellReuseIdentifier: ScopeBookTableViewCell.identifier)
        register(
            ScopeNoImageTableViewCell.self,
            forCellReuseIdentifier: ScopeNoImageTableViewCell.identifier)
        register(
            ScopeSeriesTableViewCell.self,
            forCellReuseIdentifier: ScopeSeriesTableViewCell.identifier)
        register(
            ScopeTableSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: ScopeTableSectionHeaderView.identifier)
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesure))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesure() {
        NotificationCenter.default.post(
            name: scopeTableViewDidRequestKeyboardDismiss,
            object: nil)
    }
    
    private func configureNoBooksBackgroundView() {
        if !model.isEmpty {
            backgroundView = nil
            return
        }
        
        // Handle case when model.isEmpty
        var noBooksView: NoDataBackgroundView
        if let networkingError = networkManagerError {
            noBooksView = NoDataBackgroundView(kind: .networkingError(error: networkingError))
        } else {
            noBooksView = NoDataBackgroundView(kind: .forBookshelfVc(scopeButtonKind: buttonKind))
        }
        backgroundView = noBooksView
    }
    
    private func configureTableHeader() {
        if !isCustomTableHeaderAdded {
            tableHeaderView = customTableHeader
            isCustomTableHeaderAdded = true
        }
        Utils.layoutTableHeaderView(customTableHeader, inTableView: self)
        customTableHeader.isHidden = model.count == 0
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ScopeTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = model[indexPath.row]
        
        if let book = title as? Book {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ScopeBookTableViewCell.identifier,
                for: indexPath) as? ScopeBookTableViewCell
            else { return UITableViewCell() }

            cell.configureFor(book: book)
            cell.ellipsisButtonDidTapCallback = self.ellipsisBtnDidTapCallback
            return cell
        }
        
        if let series = title as? Series {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ScopeSeriesTableViewCell.identifier,
                for: indexPath) as? ScopeSeriesTableViewCell
            else { return UITableViewCell() }
            
            cell.configureFor(series: series)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScopeNoImageTableViewCell.identifier,
            for: indexPath) as? ScopeNoImageTableViewCell
        else { return UITableViewCell() }
        
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
        let selectedRowTitle = model[indexPath.row]
        tableViewDidSelectRowCallback(selectedRowTitle)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard hasSectionHeader,
              let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: ScopeTableSectionHeaderView.identifier) as? ScopeTableSectionHeaderView
        else { return UIView() }
        
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
        NotificationCenter.default.post(
            name: scopeTableViewDidRequestKeyboardDismiss,
            object: nil)
    }
}
