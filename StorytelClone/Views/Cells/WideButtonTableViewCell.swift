//
//  WideImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/2/23.
//

import UIKit

class WideButtonTableViewCell: UITableViewCell {

    static let identifier = "WideImageTableViewCell"
        
    private var timeLayoutSubviewsIsBeingCalled = 0

    private lazy var wideButton: DimViewCellButton = {
        let button = DimViewCellButton()
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
        contentView.addSubview(wideButton)
        contentView.addSubview(customLabel)
        wideButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
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
    func configureFor(sectionKind: SectionKind, withCallbackForButton callback: @escaping ButtonCallback) {
        wideButton.sectionKind = sectionKind
        wideButton.callback = callback
        if sectionKind == .seriesCategoryButton {
            customLabel.text = "Series"
        } else {
            customLabel.text = "Todas las categorías"
        }
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        let buttonWidth = UIScreen.main.bounds.width - Constants.cvPadding * 2
        wideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wideButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            wideButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            wideButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            wideButton.heightAnchor.constraint(equalToConstant: Utils.calculatedSquareCoverSize.width)
        ])
        
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: wideButton.leadingAnchor, constant: Constants.cvPadding),
            customLabel.bottomAnchor.constraint(equalTo: wideButton.bottomAnchor, constant: -Constants.cvPadding),
        ])

    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.45).cgColor
        ]
        gradientLayer.locations = [0.4, 1]
        gradientLayer.frame = wideButton.bounds
        wideButton.layer.addSublayer(gradientLayer)
    }
    
}
