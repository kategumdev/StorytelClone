//
//  WideImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/2/23.
//

import UIKit

class WideButtonTableViewCell: UITableViewCell {

    static let identifier = "WideImageTableViewCell"
        
    // MARK: - Instance properties
    private var timeLayoutSubviewsIsBeingCalled = 0

    private lazy var dimmedAnimationButton: DimmedAnimationButton = {
        let button = DimmedAnimationButton()
        button.backgroundColor = UIColor(red: 200/255, green: 217/255, blue: 228/255, alpha: 1)
        return button
    }()
    
    let customLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        let font = Utils.wideButtonLabelFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 24)
        label.font = scaledFont
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6// Increase opacity for a stronger shadow effect
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(dimmedAnimationButton)
        contentView.addSubview(customLabel)
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timeLayoutSubviewsIsBeingCalled += 1
        if timeLayoutSubviewsIsBeingCalled == 2 {
            addGradient()
        }
    }
    
    // MARK: - Instance methods
    func configureFor(sectionKind: SectionKind, withCallback callback: @escaping DimmedAnimationButtonDidTapCallback) {
        dimmedAnimationButton.sectionKind = sectionKind
        dimmedAnimationButton.didTapCallback = callback
        if sectionKind == .seriesCategoryButton {
            customLabel.text = "Series"
        } else {
            customLabel.text = "Todas las categorías"
        }
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        let buttonWidth = UIScreen.main.bounds.width - Constants.commonHorzPadding * 2
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedAnimationButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            dimmedAnimationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
            dimmedAnimationButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            dimmedAnimationButton.heightAnchor.constraint(equalToConstant: Utils.calculatedSquareCoverSize.width)
        ])
        
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: dimmedAnimationButton.leadingAnchor, constant: Constants.commonHorzPadding),
            customLabel.bottomAnchor.constraint(equalTo: dimmedAnimationButton.bottomAnchor, constant: -Constants.commonHorzPadding),
        ])

    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.45).cgColor
        ]
        gradientLayer.locations = [0.4, 1]
        gradientLayer.frame = dimmedAnimationButton.bounds
        dimmedAnimationButton.layer.addSublayer(gradientLayer)
    }
    
}
