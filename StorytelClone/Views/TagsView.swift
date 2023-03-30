//
//  TagsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit

class TagsView: UIView {
    
//    static let buttonHeight: CGFloat = 30

    static func createButtonWith(text: String) -> UIButton {
        let button = UIButton()
        button.tintColor = UIColor.label
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
//        button.layer.cornerRadius = TagsView.buttonHeight / 2
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString(text)
        buttonConfig.attributedTitle?.font = UIFont.preferredCustomFontWith(weight: .regular, size: 13)
        buttonConfig.titleAlignment = .center
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: Constants.cvPadding, bottom: 7, trailing: Constants.cvPadding)
        
        button.configuration = buttonConfig
        button.sizeToFit()
        return button
    }
    
    // MARK: - Instance properties
    private let tags: [Tag]
    private let superviewWidth: CGFloat
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = Utils.sectionTitleFont
        label.text = "Tags"
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private var tagButtons = [UIButton]()
    
    lazy var compressedViewHeight: CGFloat = {
        let height = calculateViewHeightFor(numberOfRows: 3)
        return height
    }()
    
    private lazy var buttonHeight: CGFloat = {
        let height = tagButtons.first!.frame.height
        return height
    }()
    
    var fullViewHeight: CGFloat = 0
    lazy var needsShowAllButton = fullViewHeight > compressedViewHeight ? true : false

    private let firstButtonTopConstant: CGFloat = 18
    private let spacingBetweenButtons: CGFloat = 7
    private let spacingBetweenRows: CGFloat = 11
    
    // MARK: - View life cycle
    init(tags: [Tag], superviewWidth: CGFloat) {
        self.tags = tags
        self.superviewWidth = superviewWidth
        super.init(frame: .zero)
        backgroundColor = Utils.customBackgroundColor
        addSubview(tagsLabel)
        createTagButtons()
        tagButtons.forEach { addSubview($0) }
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            for button in tagButtons {
                button.layer.borderColor = UIColor.secondaryLabel.cgColor
            }
        }
    }
    
    // MARK: - Helper methods
    private func createTagButtons() {
        let tagTitles = tags.map { $0.tagTitle }
        for title in tagTitles {
            let button = TagsView.createButtonWith(text: title)
            button.layer.cornerRadius = button.frame.height / 2
            tagButtons.append(button)
        }
    }
    
    private func calculateViewHeightFor(numberOfRows: CGFloat) -> CGFloat {
        let spacings = firstButtonTopConstant + CGFloat(spacingBetweenRows) * (numberOfRows - 1)
        let viewHeight = tagsLabel.frame.height + numberOfRows * buttonHeight + spacings
        return viewHeight
    }
    
    private func applyConstraints() {
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagsLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.cvPadding * 2),
            tagsLabel.topAnchor.constraint(equalTo: topAnchor),
            tagsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        let containerWidth = superviewWidth - Constants.cvPadding * 2
        // Position the buttons
        var currentLeadingConstant: CGFloat = Constants.cvPadding
        var numberOfRows: CGFloat = 1
        
        for (index, button) in tagButtons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: currentLeadingConstant).isActive = true
                button.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: firstButtonTopConstant).isActive = true
            } else {
                let previousButton = tagButtons[index - 1]
                
                if currentLeadingConstant + button.frame.width > containerWidth {
                    // Move to the next row
                    currentLeadingConstant = Constants.cvPadding
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
        
        let fullViewHeight = calculateViewHeightFor(numberOfRows: numberOfRows)
        self.fullViewHeight = fullViewHeight
    }
    
}
