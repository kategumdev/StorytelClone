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
        return button
    }
    
    // MARK: - Instance properties
    private let tags: [Tag]
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = Utils.sectionTitleFont
        label.text = "Tags"
        label.textAlignment = .left
        return label
    }()
    
    private var tagButtons = [UIButton]()
    
    // MARK: - View life cycle
    init(tags: [Tag]) {
        self.tags = tags
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
//            tagsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            tagsLabel.topAnchor.constraint(equalTo: topAnchor),
            tagsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        for (index, button) in tagButtons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: TagsView.buttonHeight).isActive = true
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding).isActive = true
            
            if index == 0 {
                button.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 18).isActive = true
            } else {
                let previousButton = tagButtons[index - 1]
                button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 10).isActive = true
            }
            
            if index == tagButtons.count - 1 {
                button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
        }
        
        
    }
}
