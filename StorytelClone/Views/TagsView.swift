//
//  TagsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit

class TagsView: UIView {
    
    static let buttonHeight: CGFloat = 30

    static func createButtonWith(text: String) -> UIButton {
        let button = UIButton()
        button.tintColor = UIColor.label
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.cornerRadius = TagsView.buttonHeight / 2
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString(text)
        buttonConfig.attributedTitle?.font = UIFont.preferredCustomFontWith(weight: .regular, size: 13)
        buttonConfig.titleAlignment = .center
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.cvPadding, bottom: 0, trailing: Constants.cvPadding)
        
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
            tagButtons.append(button)
        }
    }
    
    private func applyConstraints() {
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagsLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.cvPadding * 2),
            tagsLabel.topAnchor.constraint(equalTo: topAnchor),
            tagsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

//        let containerWidth = UIScreen.main.bounds.width - Constants.cvPadding * 2
        let containerWidth = superviewWidth - Constants.cvPadding * 2
        // Position the buttons
        let spacingBetweenButtons: CGFloat = 7
        let spacingBetweenRows: CGFloat = 11
        var currentLeadingConstant: CGFloat = Constants.cvPadding
        var currentTopConstant: CGFloat = 18
        var numberOfRows: CGFloat = 1
        
        for button in tagButtons {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: TagsView.buttonHeight).isActive = true
            
            if currentLeadingConstant + button.frame.width > containerWidth {
                // Move to the next row
                currentLeadingConstant = Constants.cvPadding
                currentTopConstant += TagsView.buttonHeight + spacingBetweenRows
                numberOfRows += 1
            }

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: currentLeadingConstant).isActive = true
            button.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: currentTopConstant).isActive = true

            currentLeadingConstant += button.frame.width + spacingBetweenButtons

        }
        
        // Set view's height
        translatesAutoresizingMaskIntoConstraints = false
        let spacings = CGFloat(spacingBetweenRows) * (numberOfRows - 1) + 18
        let viewHeight = numberOfRows * TagsView.buttonHeight + spacings + tagsLabel.frame.height
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
    }
    
}
