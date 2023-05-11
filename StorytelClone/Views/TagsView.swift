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
    private let superviewWidth: CGFloat
    
//    private let font = UIFont.preferredCustomFontWith(weight: .medium, size: 13)
//    private let tagButtonFont = UIFontMetrics.default.scaledFont(for: Utils.sectionTitleFont, maximumPointSize: 40)
//    private let tagButtonFont = UIFontMetrics.default.scaledFont(for: UIFont.preferredCustomFontWith(weight: .medium, size: 13), maximumPointSize: 36)

    
    // Needed to prevent buttons from getting higher right after content size category change (because it causes strange layout)
//    private lazy var buttonHeight: CGFloat = {
//        let button = createButtonWith(text: "Lorem ipsum")
//        button.sizeToFit()
//        return button.bounds.height
//    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        let font = Utils.sectionTitleFont
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 40)
//        let scaledFont = UIFontMetrics.default.scaledFont(for:  Utils.sectionTitleFont, maximumPointSize: 40)
//        label.font = scaledFont
        
        label.font = getTitleLabelScaledFont()
//        label.font = Utils.sectionTitleFont
        label.text = "Tags"
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private var tagButtons = [UIButton]()
    
    private lazy var compressedViewHeight: CGFloat = {
        let height = calculateViewHeightFor(numberOfRows: 3)
        return height
    }()
    
    private var fullViewHeight: CGFloat = 0
    lazy var needsShowAllButton = fullViewHeight > compressedViewHeight ? true : false

    private let firstButtonTopConstant: CGFloat = 18
    private let spacingBetweenButtons: CGFloat = 7
    private let spacingBetweenRows: CGFloat = 11
    private lazy var previousContentSizeCategory = traitCollection.preferredContentSizeCategory
        
    // MARK: - Initializers
    init(tags: [Tag], superviewWidth: CGFloat) {
        self.tags = tags
        self.superviewWidth = superviewWidth
        super.init(frame: .zero)
        backgroundColor = Utils.customBackgroundColor
        addSubview(titleLabel)
        createTagButtons()
        tagButtons.forEach { addSubview($0) }
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard previousContentSizeCategory != traitCollection.preferredContentSizeCategory else { return }
        previousContentSizeCategory = traitCollection.preferredContentSizeCategory
        for button in tagButtons {
            button.layer.cornerRadius = button.bounds.height / 2
            titleLabel.font = getTitleLabelScaledFont()
        }
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            for button in tagButtons {
                button.layer.borderColor = UIColor.secondaryLabel.cgColor
            }
        }
    }
    
    // MARK: - Instance methods
    // Update compressedViewHeight accounting to correspond to current content size category
//    func updateCompressedViewHeight() {
//        compressedViewHeight = calculateViewHeightFor(numberOfRows: 3)
//    }
    
    // MARK: - Helper methods
    private func createTagButtons() {
        let tagTitles = tags.map { $0.tagTitle }
        for title in tagTitles {
//            let button = TagsView.createButtonWith(text: title)
            let button = createButtonWith(text: title)
            button.layer.cornerRadius = button.frame.height / 2
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
        let font = UIFont.preferredCustomFontWith(weight: .medium, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 36)
        buttonConfig.attributedTitle?.font = scaledFont
//        buttonConfig.attributedTitle?.font = tagButtonFont
        buttonConfig.titleAlignment = .center
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: Constants.commonHorzPadding, bottom: 7, trailing: Constants.commonHorzPadding)
        
        button.configuration = buttonConfig
        button.sizeToFit()
        return button
    }
    
    private func getTitleLabelScaledFont() -> UIFont {
        return UIFontMetrics.default.scaledFont(for:  Utils.sectionTitleFont, maximumPointSize: 40)
    }
//    private func calculateViewHeightFor(numberOfRows: CGFloat) -> CGFloat {
//        let spacings = firstButtonTopConstant + CGFloat(spacingBetweenRows) * (numberOfRows - 1)
//        let tagButton = createButtonWith(text: "Lorem ipsum")
//        tagButton.configuration?.attributedTitle?.font = UIFont.preferredCustomFontWith(weight: .medium, size: 13)
//        tagButton.sizeToFit()
//        let heightOfButtonWithNotScaledFont = tagButton.bounds.height
//        let viewHeight = tagsLabel.frame.height + numberOfRows * heightOfButtonWithNotScaledFont + spacings
//
////        let viewHeight = tagsLabel.frame.height + numberOfRows * buttonHeight + spacings
//        return viewHeight
//    }
    
    func calculateCompressedViewHeight() -> CGFloat {
        return calculateViewHeightFor(numberOfRows: 3)
    }
    
    private func calculateViewHeightFor(numberOfRows: CGFloat) -> CGFloat {
        let spacings = firstButtonTopConstant + CGFloat(spacingBetweenRows) * (numberOfRows - 1)
//        let viewHeight = tagsLabel.frame.height + numberOfRows * buttonHeight + spacings
//         guard let buttonHeight = tagButtons.first?.bounds.height else { return 0 }
        let button = createButtonWith(text: "Lorem ipsum")
        button.sizeToFit()
        let buttonHeight = button.bounds.height

        let titleLabel = UILabel()
        titleLabel.font = getTitleLabelScaledFont()
        titleLabel.text = "Tags"
        titleLabel.sizeToFit()
//         let viewHeight = titleLabel.frame.height + numberOfRows * buttonHeight + spacings
        let viewHeight = titleLabel.bounds.height + numberOfRows * buttonHeight + spacings
//         let viewHeight = 50 + numberOfRows * buttonHeight + spacings

        return viewHeight
    }
    
//    private func calculateViewHeightFor(numberOfRows: CGFloat) -> CGFloat {
//        let spacings = firstButtonTopConstant + CGFloat(spacingBetweenRows) * (numberOfRows - 1)
////        let viewHeight = tagsLabel.frame.height + numberOfRows * buttonHeight + spacings
//         guard let buttonHeight = tagButtons.first?.bounds.height else { return 0 }
////         let button = createButtonWith(text: "Lorem ipsum")
////         button.sizeToFit()
////         let buttonHeight = button.bounds.height
//
////         let viewHeight = titleLabel.frame.height + numberOfRows * buttonHeight + spacings
//        let viewHeight = titleLabel.bounds.height + numberOfRows * buttonHeight + spacings
////         let viewHeight = 50 + numberOfRows * buttonHeight + spacings
//
//        return viewHeight
//    }

    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.commonHorzPadding * 2),
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
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: currentLeadingConstant).isActive = true
                button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: firstButtonTopConstant).isActive = true
            } else {
                let previousButton = tagButtons[index - 1]
                
                if currentLeadingConstant + button.frame.width > containerWidth {
                    // Move to the next row
                    currentLeadingConstant = Constants.commonHorzPadding
                    button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: currentLeadingConstant).isActive = true
                    button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: spacingBetweenRows).isActive = true
                    numberOfRows += 1
                } else {
                    button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: spacingBetweenButtons).isActive = true
                    button.topAnchor.constraint(equalTo: previousButton.topAnchor).isActive = true
                }
            }
            currentLeadingConstant += button.frame.width + spacingBetweenButtons

        }
        
        // Enable top-to-bottom auto layout approach for the view
        let lastButton = tagButtons.last!
        translatesAutoresizingMaskIntoConstraints = false
        lastButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let fullViewHeight = calculateViewHeightFor(numberOfRows: CGFloat(numberOfRows))
        self.fullViewHeight = fullViewHeight
    }
    
}
