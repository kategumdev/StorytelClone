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
        let scaledFont = UIFont.createScaledFontWith(textStyle: .footnote, weight: .semibold, maxPointSize: 34)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 2, text: "Sorted by: Latest changed")
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var horzStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        [label, UIView(), filterButton].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(15, after: label)
        return stack
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("BookshelfTableHeaderView INITIALIZED")
        addSubview(horzStackView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper methods
    private func applyConstraints() {
        horzStackView.translatesAutoresizingMaskIntoConstraints = false
        horzStackView.fillSuperview(withConstant: Constants.commonHorzPadding)
        
        translatesAutoresizingMaskIntoConstraints = false
        // Avoid constraint's conflict when header is added to table view
        for constraint in constraints {
            constraint.priority = UILayoutPriority(750)
        }
    }
}
