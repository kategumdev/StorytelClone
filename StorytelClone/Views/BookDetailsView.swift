//
//  BookDetailsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/3/23.
//

import UIKit

class BookDetailsView: UIView {
    
    static let imageHeight: CGFloat = ceil(UIScreen.main.bounds.width * 0.75)
//    static let imageHeight: CGFloat = 250
    
    private let coverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.bookCoverCornerRadius
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
//        imageView.layer.borderWidth = 0.26
        imageView.layer.borderWidth = 0.6
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image1")
        return imageView
    }()
    
    private lazy var coverImageWidthAnchor = coverImageView.widthAnchor.constraint(equalToConstant: BookDetailsView.imageHeight)
    
//    private let bookTitleLabel: UILabel = UILabel.createLabel(withFont: Utils.wideButtonLabelFont, maximumPointSize: 45, numberOfLines: 2, withScaledFont: true)
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel.createLabel(withFont: Utils.wideButtonLabelFont, maximumPointSize: 45, numberOfLines: 2, withScaledFont: true)
        label.textAlignment = .center
        return label
    }()
    
//    private let authorLabel = UILabel()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private func configureAuthorLabel(withName name: String) {
        let attributedString = NSMutableAttributedString(string: "By: \(name)")
        let font1 = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
        let scaledFont1 = UIFontMetrics.default.scaledFont(for: font1, maximumPointSize: 45)
        let byAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont1, .foregroundColor: UIColor.label]
        
        let font2 = Utils.navBarTitleFont
        let scaledFont2 = UIFontMetrics.default.scaledFont(for: font2, maximumPointSize: 45)
        let authorNameAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont2, .foregroundColor: Utils.tintColor]

        attributedString.addAttributes(byAttributes, range: NSRange(location: 0, length: 3))
        attributedString.addAttributes(authorNameAttributes, range: NSRange(location: 3, length: attributedString.length - 3))
        
        authorLabel.attributedText = attributedString
    }
    
//    private let narratorLabel = UILabel()
    
    private let narratorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private func configureNarratorLabel(withName name: String) {
        let attributedString = NSMutableAttributedString(string: "With: \(name)")
        let font1 = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
        let scaledFont1 = UIFontMetrics.default.scaledFont(for: font1, maximumPointSize: 45)
        let byAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont1, .foregroundColor: UIColor.label]
        
        let font2 = Utils.navBarTitleFont
        let scaledFont2 = UIFontMetrics.default.scaledFont(for: font2, maximumPointSize: 45)
        let authorNameAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont2, .foregroundColor: Utils.tintColor]

        attributedString.addAttributes(byAttributes, range: NSRange(location: 0, length: 5))
        attributedString.addAttributes(authorNameAttributes, range: NSRange(location: 5, length: attributedString.length - 5))
        
        narratorLabel.attributedText = attributedString
    }
    
    private lazy var viewWithShowSeriesButton: UIView = {
       let view = UIView()
        view.layer.borderColor = UIColor.tertiaryLabel.cgColor
        view.layer.borderWidth = 0.5
        view.addSubview(showSeriesButton)
        return view
    }()
    
    private lazy var showSeriesButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .yellow
        button.tintColor = UIColor.label
        var config = UIButton.Configuration.plain()
//        config.
        
//        button.setTitle("Part 1", for: .normal)
        button.setTitle("Part 1 in Cazadores de sombras. Las últimas horas", for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
//        button.titleLabel?.font = scaledFont
        button.titleLabel?.font = font
        button.titleLabel?.textAlignment = .center
//        button.contentHorizontalAlignment = .center
//        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
        button.setTitleColor(.label, for: .normal)

        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        // Set leading image
//        let leadingSymbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
//        let leadingImage = UIImage(systemName: "rectangle.stack", withConfiguration: leadingSymbolConfig)
//        button.setImage(leadingImage, for: .normal)
//        button.contentHorizontalAlignment = .trailing
        
        button.addSubview(seriesButtonLeadingImage)
        button.addSubview(seriesButtonTrailingImage)
        return button
    }()
    
    private let seriesButtonTrailingImage: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: config)
//        imageView.image?.withRenderingMode(.alwaysOriginal)
        imageView.image = image?.withRenderingMode(.alwaysOriginal)
        imageView.image?.withTintColor(.label)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
//        imageView.backgroundColor = .green
        return imageView
    }()
    
    private let seriesButtonLeadingImage: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "rectangle.stack", withConfiguration: config)
//        imageView.image?.withRenderingMode(.alwaysOriginal)
        imageView.image = image?.withRenderingMode(.alwaysOriginal)
        imageView.image?.withTintColor(.label)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
//        imageView.backgroundColor = .green
        return imageView
    }()
    
    
    private let roundButtonsStackContainer = RoundButtonsStackContainer()
    

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
//        stack.backgroundColor = .green
        stack.axis = .vertical
        stack.alignment = .center
//        stack.distribution = .equalCentering
//        stack.distribution = .fillProportionally
        stack.distribution = .equalSpacing
        stack.spacing = 8

        [coverImageView, bookTitleLabel, authorLabel, narratorLabel, viewWithShowSeriesButton, roundButtonsStackContainer].forEach { stack.addArrangedSubview($0)}
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .magenta
        configureAuthorLabel(withName: "Neil Gaiman")
        configureNarratorLabel(withName: "Nancy Butler")
        bookTitleLabel.text = "La cadena de oro"
        addSubview(stackView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            coverImageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }
    
    private func applyConstraints() {
        
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.heightAnchor.constraint(equalToConstant: BookDetailsView.imageHeight).isActive = true
        coverImageWidthAnchor.isActive = true
        
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstant = BookDetailsView.imageHeight * 0.75
        bookTitleLabel.widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        
        let authorAndNarratorLabelWidth = BookDetailsView.imageHeight
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.widthAnchor.constraint(equalToConstant: authorAndNarratorLabelWidth).isActive = true
        
        narratorLabel.translatesAutoresizingMaskIntoConstraints = false
        narratorLabel.widthAnchor.constraint(equalToConstant: authorAndNarratorLabelWidth).isActive = true
        
        viewWithShowSeriesButton.translatesAutoresizingMaskIntoConstraints = false
//        viewWithShowSeriesButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        viewWithShowSeriesButton.topAnchor.constraint(equalTo: showSeriesButton.topAnchor, constant: -5).isActive = true
        viewWithShowSeriesButton.bottomAnchor.constraint(equalTo: showSeriesButton.bottomAnchor, constant: 5).isActive = true
        viewWithShowSeriesButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        showSeriesButton.translatesAutoresizingMaskIntoConstraints = false
        showSeriesButton.widthAnchor.constraint(equalToConstant: BookDetailsView.imageHeight * 0.90).isActive = true
        showSeriesButton.centerXAnchor.constraint(equalTo: viewWithShowSeriesButton.centerXAnchor).isActive = true
        showSeriesButton.centerYAnchor.constraint(equalTo: viewWithShowSeriesButton.centerYAnchor).isActive = true
        
        seriesButtonLeadingImage.translatesAutoresizingMaskIntoConstraints = false
        seriesButtonLeadingImage.centerYAnchor.constraint(equalTo: showSeriesButton.centerYAnchor).isActive = true
        seriesButtonLeadingImage.leadingAnchor.constraint(greaterThanOrEqualTo: showSeriesButton.leadingAnchor).isActive = true
//        seriesButtonLeadingImage.leadingAnchor.constraint(equalTo: showSeriesButton.leadingAnchor).isActive = true
        
        
        seriesButtonTrailingImage.translatesAutoresizingMaskIntoConstraints = false
        seriesButtonTrailingImage.centerYAnchor.constraint(equalTo: showSeriesButton.centerYAnchor).isActive = true
        seriesButtonTrailingImage.trailingAnchor.constraint(lessThanOrEqualTo: showSeriesButton.trailingAnchor).isActive = true
//        seriesButtonTrailingImage.trailingAnchor.constraint(equalTo: showSeriesButton.trailingAnchor).isActive = true
        
        if let titleLabel = showSeriesButton.titleLabel {
            seriesButtonLeadingImage.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -6).isActive = true
            seriesButtonTrailingImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 6).isActive = true
        }
        
        // Set height of BookDetailsView
        coverImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roundButtonsStackContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: coverImageView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: roundButtonsStackContainer.bottomAnchor).isActive = true
                
//        roundButtonsStackContainer.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            roundButtonsStackContainer.
//        ])
        
//        viewWithListenButton.translatesAutoresizingMaskIntoConstraints = false
//        viewWithListenButton.topAnchor.constraint(equalTo: listenButton.topAnchor).isActive = true
//        viewWithListenButton.bottomAnchor.constraint(equalTo: listenLabel.bottomAnchor).isActive = true
//        
//        
//        let widthHeightRoundButton = UIScreen.main.bounds.width * 0.12
//        listenButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            listenButton.heightAnchor.constraint(equalToConstant: widthHeightRoundButton),
//            listenButton.widthAnchor.constraint(equalToConstant: widthHeightRoundButton),
//            listenButton.topAnchor.constraint(equalTo: viewWithListenButton.topAnchor),
//            listenButton.bottomAnchor.constraint(equalTo: listenLabel.topAnchor, constant: -40)
//        ])
//        
//        listenLabel.translatesAutoresizingMaskIntoConstraints = false
//        listenLabel.widthAnchor.constraint(equalToConstant: widthHeightRoundButton).isActive = true
//        
//        
//        
//        
//        
//        
//
//        let extraPaddings: CGFloat = 120
//        stackWithRoundButtons.translatesAutoresizingMaskIntoConstraints = false
//        stackWithRoundButtons.heightAnchor.constraint(equalTo: viewWithListenButton.heightAnchor, constant: extraPaddings).isActive = true
//        // use viewWithSaveButton instead of viewWithListenButton here
        

    }
    
    
    
}
