//
//  TagsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit

class TagsView: UIView {
    // MARK: - Instance properties
    private let tags: [Tag]
    private var tagButtons = [UIButton]()
    private lazy var titleLabel = createTitleLabel()
    private let superviewWidth: CGFloat
    
    private var fullViewHeight: CGFloat = 0

    private lazy var compressedViewHeight: CGFloat = {
        let height = calculateViewHeightFor(numberOfRows: 3)
        return height
    }()
    
    lazy var needsShowAllButton = fullViewHeight > compressedViewHeight ? true : false

    private let firstButtonTopConstant: CGFloat = 18
    private let spacingBetweenButtons: CGFloat = 7
    private let spacingBetweenRows: CGFloat = 11
    
    var tagButtonDidTapCallback: (Tag) -> () = {_ in}
        
    // MARK: - Initializers
    init(tags: [Tag], superviewWidth: CGFloat) {
        self.tags = tags
        self.superviewWidth = superviewWidth
        super.init(frame: .zero)
        backgroundColor = UIColor.customBackgroundColor
        addSubview(titleLabel)
        createTagButtons()
        tagButtons.forEach { addSubview($0) }
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        for button in tagButtons {
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            for button in tagButtons {
                button.layer.borderColor = UIColor.secondaryLabel.cgColor
            }
        }
    }
    
    // MARK: - Instance methods
    func calculateCurrentCompressedViewHeight() -> CGFloat {
        return calculateViewHeightFor(numberOfRows: 3)
    }
    
    // MARK: - Helper methods
    private func createTagButtons() {
        for tag in tags {
            let button = createButtonWith(text: tag.tagTitle)
            button.layer.cornerRadius = button.frame.height / 2
            
            button.addAction(UIAction(handler: { [weak self] _ in
                self?.tagButtonDidTapCallback(tag)
            }), for: .touchUpInside)
            
            tagButtons.append(button)
        }
    }
    
    private func createButtonWith(text: String) -> UIButton {
        let button = UIButton()
        button.tintColor = UIColor.label
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString(text)
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .footnote,
            weight: .medium,
            maxPointSize: 36)
        buttonConfig.attributedTitle?.font = scaledFont
        buttonConfig.titleAlignment = .center
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 7,
            leading: Constants.commonHorzPadding,
            bottom: 7,
            trailing: Constants.commonHorzPadding)
        
        button.configuration = buttonConfig
        button.sizeToFit()
        return button
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel.createLabelWith(font: UIFont.customCalloutSemibold, text: "Tags")
        label.sizeToFit()
        return label
    }

    private func calculateViewHeightFor(numberOfRows: CGFloat) -> CGFloat {
        let spacings = firstButtonTopConstant + CGFloat(spacingBetweenRows) * (numberOfRows - 1)
        
        // Create buttonTag and titleLabel to account for current content size category
        let button = createButtonWith(text: "Lorem ipsum")
        let buttonHeight = button.bounds.height

        let titleLabel = createTitleLabel()
        let titleLabelHeight = titleLabel.bounds.height
        
        let viewHeight = titleLabelHeight + numberOfRows * buttonHeight + spacings
        return viewHeight
    }

    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(
                equalTo: widthAnchor,
                constant: -Constants.commonHorzPadding * 2),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        let containerWidth = superviewWidth - Constants.commonHorzPadding * 2
        // Position the buttons
        var currentLeadingConstant: CGFloat = Constants.commonHorzPadding
        var numberOfRows: Int = 1
        
        for (index, button) in tagButtons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(
                        equalTo: leadingAnchor,
                        constant: currentLeadingConstant),
                    button.topAnchor.constraint(
                        equalTo: titleLabel.bottomAnchor,
                        constant: firstButtonTopConstant)
                ])
            } else {
                let previousButton = tagButtons[index - 1]
                
                if currentLeadingConstant + button.frame.width > containerWidth {
                    // Move to the next row
                    currentLeadingConstant = Constants.commonHorzPadding
                    NSLayoutConstraint.activate([
                        button.leadingAnchor.constraint(
                            equalTo: leadingAnchor,
                            constant: currentLeadingConstant),
                        button.topAnchor.constraint(
                            equalTo: previousButton.bottomAnchor,
                            constant: spacingBetweenRows)
                    ])
                    numberOfRows += 1
                } else {
                    NSLayoutConstraint.activate([
                        button.leadingAnchor.constraint(
                            equalTo: previousButton.trailingAnchor,
                            constant: spacingBetweenButtons),
                        button.topAnchor.constraint(equalTo: previousButton.topAnchor)
                    ])
                }
            }
            currentLeadingConstant += button.frame.width + spacingBetweenButtons
        }
        
        // Enable top-to-bottom auto layout for the view
        let lastButton = tagButtons.last!
        translatesAutoresizingMaskIntoConstraints = false
        lastButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let fullViewHeight = calculateViewHeightFor(numberOfRows: CGFloat(numberOfRows))
        self.fullViewHeight = fullViewHeight
    }
}
