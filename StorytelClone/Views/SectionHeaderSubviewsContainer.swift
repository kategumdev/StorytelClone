//
//  SectionHeaderSubviewsContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/3/23.
//

import UIKit

// Create it as a separate class to make calculation of estimated section header height (and smooth scrolling experience, especially after dynamic font size change) possible
class SectionHeaderSubviewsContainer: UIView {
    
    // MARK: Static properties and methods
    private static let paddingBetweenLabelAndButton: CGFloat = 20
    private static let seeAllButtonTitle = "See all"
    private static let paddingBetweenLabels: CGFloat = 1
    
    private static func createSeeAllButton() -> UIButton {
        let button = UIButton()
        button.setTitle(seeAllButtonTitle, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
        button.titleLabel?.font = scaledFont
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }

    private static func calculateSeeAllButtonWidth() -> CGFloat {
        let button = createSeeAllButton()
        button.sizeToFit()
        return button.bounds.size.width
    }
    
    // MARK: - Instance properties
    private var withButton = true
    private lazy var seeAllButton = SectionHeaderSubviewsContainer.createSeeAllButton()
    
    var tableSection: TableSection?
    let sectionTitleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
    let sectionSubtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
    
    // Closure to tell owning controller to push new vc
    typealias SeeAllButtonCallbackClosure = (_ tableSection: TableSection) -> ()
    var callback: SeeAllButtonCallbackClosure = {_ in}
    
    // MARK: - Initializers
    init(withButton button: Bool = true) {
        super.init(frame: .zero)
        self.withButton = button
        addSubview(sectionTitleLabel)
        addSubview(sectionSubtitleLabel)

        if withButton {
            addSubview(seeAllButton)
            configureButtonWithAction()
        }
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func configureButtonWithAction() {
        seeAllButton.addAction(UIAction(handler: { [weak self] action in
            guard let self = self, let tableSection = self.tableSection else { return }
            // Notify owning vc that the button was tapped
            self.callback(tableSection)
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if !withButton {
            sectionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55).isActive = true
        }
        
        NSLayoutConstraint.activate([
            sectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
            sectionTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.generalTopPaddingSectionHeader),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: sectionSubtitleLabel.topAnchor, constant: -5)
        ])
        
        sectionSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionSubtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionSubtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
            sectionSubtitleLabel.trailingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor)
        ])
        
        guard withButton else { return }
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cvPadding),
            seeAllButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            seeAllButton.widthAnchor.constraint(equalToConstant: SectionHeaderSubviewsContainer.calculateSeeAllButtonWidth()),
            seeAllButton.leadingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor, constant: SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton)
        ])
    }

}

