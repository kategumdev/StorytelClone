//
//  AllTitlesSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 31/3/23.
//

import UIKit

class AllTitlesSectionHeaderView: UITableViewHeaderFooterView {
    // MARK: - Static properties and methods
    static let identifier = "AllTitlesSectionHeaderView"
    static let topAndBottomPadding: CGFloat = 23
    
    static func createLabel() -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45)
        return label
    }
    
    static func calculateEstimatedHeaderHeight() -> CGFloat {
        let label = createLabel()
        label.text = "Placeholder"
        label.sizeToFit()
        
        let height = label.bounds.height + (topAndBottomPadding * 2)
        return height
    }
    
    // MARK: - Instance properties
    private let stackViewHeight: CGFloat = 26
    
    private let titleLabel = createLabel()
    private lazy var shareButton = createButtonWithImageWith(symbolName: "paperplane")
    private lazy var filterButton = createButtonWithImageWith(symbolName: "arrow.up.arrow.down")

    private lazy var vertBarView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemGray3
        view.backgroundColor = .tertiaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private lazy var stackShareFilter: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
//        [shareButton, vertBarView, filterButton].forEach { stack.addArrangedSubview($0)}
        return stack
    }()
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
        
    // MARK: - View life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func configureWith(title: String) {
        titleLabel.text = title
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackShareFilter)
    }
    
    func showOnlyFilterButton() {
        [spacerView, filterButton].forEach { stackShareFilter.addArrangedSubview($0)}
    }
    
    func showOnlyShareButton() {
        [spacerView, shareButton].forEach { stackShareFilter.addArrangedSubview($0)}
    }
    
    func showShareAndFilterButtons() {
        [shareButton, vertBarView, filterButton].forEach { stackShareFilter.addArrangedSubview($0)}
    }
    
    private func createButtonWithImageWith(symbolName: String) -> UIButton {
        let button = UIButton()
        button.tintColor = .label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        return button
    }
    
    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsSectionHeaderView.topAndBottomPadding),
            titleLabel.trailingAnchor.constraint(equalTo: stackShareFilter.leadingAnchor, constant: -Constants.cvPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsSectionHeaderView.topAndBottomPadding)
        ])
        
        stackShareFilter.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackShareFilter.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            stackShareFilter.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackShareFilter.widthAnchor.constraint(equalToConstant: 96),
            stackShareFilter.heightAnchor.constraint(equalToConstant: stackViewHeight)
        ])
    }

}
