//
//  ShowSeriesButtonContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 23/3/23.
//

import UIKit

class ShowSeriesButtonContainer: UIView {
    // MARK: - Instance properties
    private var borderColor: CGColor? {
        return UIColor.quaternaryLabel.cgColor
    }
    
    private lazy var showSeriesButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        var config = UIButton.Configuration.plain()
        button.setTitle("Part 1 in Cazadores de sombras. Las últimas horas", for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.font = UIFont.customFootnoteSemibold
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addSubview(seriesButtonLeadingImage)
        button.addSubview(seriesButtonTrailingImage)
        return button
    }()
    
    private let seriesButtonLeadingImage: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
        let image = UIImage(systemName: "rectangle.stack", withConfiguration: config)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let seriesButtonTrailingImage: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: config)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var showSeriesButtonDidTapCallback: () -> () = {}
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = borderColor
        }
    }
    
    // MARK: - Instance methods
    func configureFor(seriesTitle: String, seriesPart: Int) {
        let text = "Part \(seriesPart) in \(seriesTitle)"
        showSeriesButton.setTitle(text, for: .normal)
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        layer.borderColor = borderColor
        layer.borderWidth = 1
        addSubview(showSeriesButton)
        applyConstraints()
        addButtonAction()
    }
    
    private func addButtonAction() {
        showSeriesButton.addAction(UIAction(handler: { [weak self] _ in
            Utils.playHaptics()
            self?.showSeriesButtonDidTapCallback()
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: showSeriesButton.topAnchor, constant: -5),
            bottomAnchor.constraint(equalTo: showSeriesButton.bottomAnchor, constant: 5)
        ])
        
        showSeriesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showSeriesButton.widthAnchor.constraint(
                equalToConstant: BookDetailsStackView.imageHeight * 0.90),
            showSeriesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            showSeriesButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        seriesButtonLeadingImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seriesButtonLeadingImage.centerYAnchor.constraint(
                equalTo: showSeriesButton.centerYAnchor),
            seriesButtonLeadingImage.leadingAnchor.constraint(
                greaterThanOrEqualTo: showSeriesButton.leadingAnchor)
        ])
        
        seriesButtonTrailingImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seriesButtonTrailingImage.centerYAnchor.constraint(
                equalTo: showSeriesButton.centerYAnchor),
            seriesButtonTrailingImage.trailingAnchor.constraint(
                lessThanOrEqualTo: showSeriesButton.trailingAnchor)
        ])
        
        if let titleLabel = showSeriesButton.titleLabel {
            NSLayoutConstraint.activate([
                seriesButtonLeadingImage.trailingAnchor.constraint(
                    equalTo: titleLabel.leadingAnchor,
                    constant: -6),
                seriesButtonTrailingImage.leadingAnchor.constraint(
                    equalTo: titleLabel.trailingAnchor,
                    constant: 6)
            ])
        }
    }
}
