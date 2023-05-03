//
//  BookshelfTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/5/23.
//

import UIKit

class BookshelfTableHeaderView: UIView {
    // MARK: - Instance properties
    private let label: UILabel = {
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 34)
        label.text = "Sorted by: Latest changed"
//        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
//        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var horzStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
//        let spacerView = UIView()
//        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        spacerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        [label, spacerView, filterButton].forEach { stack.addArrangedSubview($0) }

        [label, UIView(), filterButton].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(15, after: label)
        return stack
    }()
    
//    private lazy var horzStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 20
//        stack.distribution = .fillProportionally
//        stack.addArrangedSubview(label)
//        stack.addArrangedSubview(filterButton)
//        return stack
//    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("BookshelfTableHeaderView INITIALIZED")
        addSubview(horzStackView)
//        applyConstraints()
        horzStackView.translatesAutoresizingMaskIntoConstraints = false
        horzStackView.fillSuperview(withConstant: Constants.commonHorzPadding)
//        backgroundColor = .green
//        horzStackView.backgroundColor = .blue
//        filterButton.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func applyConstraints() {
//        horzStackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            horzStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.commonHorzPadding * 2),
//            horzStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
////            horzStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
//            horzStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.commonHorzPadding),
//            horzStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.commonHorzPadding)
//        ])
//    }

}
