//
//  BookDetailsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/3/23.
//

import UIKit

typealias ShowSeriesButtonDidTapCallback = () -> ()

class BookDetailsStackView: UIStackView {
    // MARK: - Static properties
    static let imageHeight: CGFloat = ceil(UIScreen.main.bounds.width * 0.75)
    
    // MARK: - Instance properties
    private let book: Book
    
    
    var showSeriesButtonDidTapCallback: ShowSeriesButtonDidTapCallback = {} {
        didSet {
            showSeriesButtonContainer.showSeriesButtonDidTapCallback = showSeriesButtonDidTapCallback
        }
    }
    
    var saveButtonDidTapCallback: SaveButtonDidTapCallback = {_ in} {
        didSet {
            roundButtonsStackContainer.saveButtonDidTapCallback = saveButtonDidTapCallback
        }
    }
    
    typealias AuthorsButtonDidTapCallback = () -> ()
    var authorsButtonDidTapCallback: AuthorsButtonDidTapCallback = {}
    
    private let coverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.bookCoverCornerRadius
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.layer.borderWidth = 0.6
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image1")
        return imageView
    }()
    
    private lazy var coverImageWidthAnchor = coverImageView.widthAnchor.constraint(equalToConstant: BookDetailsStackView.imageHeight)
    
    let spacingAfterCoverImageView: CGFloat = 24.0

    private let bookTitleLabel: UILabel = {
        let label = UILabel.createLabel(withFont: Utils.wideButtonLabelFont, maximumPointSize: 45, numberOfLines: 2, withScaledFont: true)
        label.textAlignment = .center
        return label
    }()
    
    lazy var bookTitleLabelHeight = bookTitleLabel.bounds.height
    
    private let authorsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }()
    
    private lazy var authorsButtonHeightConstraint = authorsButton.heightAnchor.constraint(equalToConstant: authorsButton.bounds.height) // Random value, it will be reset later
    
    private func configureAuthorsButton() {
        let authorNames = book.authors.map { $0.name }
        let authorNamesString = authorNames.joined(separator: ", ")
        
        let attributedString = NSMutableAttributedString(string: "By: \(authorNamesString)")
        let font1 = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
        let scaledFont1 = UIFontMetrics.default.scaledFont(for: font1, maximumPointSize: 45)
        let byAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont1, .foregroundColor: UIColor.label]
        
        let font2 = Utils.navBarTitleFont
        let scaledFont2 = UIFontMetrics.default.scaledFont(for: font2, maximumPointSize: 45)
        let authorNameAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont2, .foregroundColor: Utils.tintColor]

        attributedString.addAttributes(byAttributes, range: NSRange(location: 0, length: 3))
        attributedString.addAttributes(authorNameAttributes, range: NSRange(location: 3, length: attributedString.length - 3))

        authorsButton.setAttributedTitle(attributedString, for: .normal)
        
        print("authorsButton height BEFORE: \(authorsButton.bounds.height)")
        // Avoid top and bottom content insets
        authorsButton.titleLabel?.sizeToFit()
        guard let buttonTitleLabel = authorsButton.titleLabel else { return }
        authorsButtonHeightConstraint.constant = buttonTitleLabel.bounds.height
        print("titleLabel height: \(buttonTitleLabel.bounds.size.height)")
    }
        
    private let narratorsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }()
    
    private lazy var narratorsButtonHeightConstraint = narratorsButton.heightAnchor.constraint(equalToConstant: 50) // Random value, it will be reset later
    
    private var hasNarratorsButton = true
    
    private func configureNarratorsLabel() {
        guard let narrators = book.narrators else { return }
        let narratorNames = narrators.map { $0.name }
        let narratorNamesString = narratorNames.joined(separator: ", ")
        
        let attributedString = NSMutableAttributedString(string: "With: \(narratorNamesString)")
        let font1 = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
        let scaledFont1 = UIFontMetrics.default.scaledFont(for: font1, maximumPointSize: 45)
        let byAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont1, .foregroundColor: UIColor.label]
        
        let font2 = Utils.navBarTitleFont
        let scaledFont2 = UIFontMetrics.default.scaledFont(for: font2, maximumPointSize: 45)
        let authorNameAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont2, .foregroundColor: Utils.tintColor]

        attributedString.addAttributes(byAttributes, range: NSRange(location: 0, length: 5))
        attributedString.addAttributes(authorNameAttributes, range: NSRange(location: 5, length: attributedString.length - 5))
        
        narratorsButton.setAttributedTitle(attributedString, for: .normal)

        // Avoid top and bottom content insets
        narratorsButton.titleLabel?.sizeToFit()
        guard let buttonTitleLabel = narratorsButton.titleLabel else { return }
        narratorsButtonHeightConstraint.constant = buttonTitleLabel.bounds.height
    }
    
    private lazy var showSeriesButtonContainer = ShowSeriesButtonContainer()
    private var hasShowSeriesButtonContainer = true
    
    lazy var roundButtonsStackContainer = RoundButtonsStackContainer(forBook: book)
    
    private lazy var leadingViewWithGradient: UIView = {
        let view = UIView()
        view.layer.addSublayer(leadingGradientLayer)
        return view
    }()
    
    private lazy var trailingViewWithGradient: UIView = {
        let view = UIView()
        view.layer.addSublayer(trailingGradientLayer)
        return view
    }()
    
    private lazy var trailingGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }()
    
    private lazy var leadingGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        return gradientLayer
    }()
    
    private var gradientIsAdded = false

    private var gradientColors: [CGColor] {
        let colors = [Utils.customBackgroundColor!.withAlphaComponent(0).cgColor,      Utils.customBackgroundColor!.withAlphaComponent(1).cgColor]
        return colors
    }
    
    // MARK: - Initializers
    init(forBook book: Book) {
        self.book = book
        super.init(frame: .zero)
        configureSelf()
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasShowSeriesButtonContainer {
            leadingGradientLayer.frame = leadingViewWithGradient.bounds
            trailingGradientLayer.frame = trailingViewWithGradient.bounds
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            coverImageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
            
            guard hasShowSeriesButtonContainer else { return }
            leadingGradientLayer.colors = gradientColors
            trailingGradientLayer.colors = gradientColors
        }
        
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            // Reconfigure authorsButton and narratorsButton to adjust their height after font size change
            configureAuthorsButton()
            if hasNarratorsButton {
                configureNarratorsLabel()
            }
        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        axis = .vertical
        alignment = .center
                
        if let image = book.coverImage {
            let resizedImage = image.resizeFor(targetHeight: BookDetailsStackView.imageHeight)
            coverImageView.image = resizedImage
            coverImageWidthAnchor.constant = resizedImage.size.width
        }
        addArrangedSubview(coverImageView)
        setCustomSpacing(spacingAfterCoverImageView, after: coverImageView)

        bookTitleLabel.text = book.title
        addArrangedSubview(bookTitleLabel)
        setCustomSpacing(16.0, after: bookTitleLabel)
        
        configureAuthorsButton()
        addArrangedSubview(authorsButton)
        setCustomSpacing(8.0, after: authorsButton)
                
        if book.narrators != nil {
           configureNarratorsLabel()
            addArrangedSubview(narratorsButton)
            setCustomSpacing(23.0, after: narratorsButton)
        } else {
            hasNarratorsButton = false
            setCustomSpacing(33.0, after: authorsButton)
        }
                    
        if let seriesTitle = book.series, let seriesPart = book.seriesPart {
            showSeriesButtonContainer.configureFor(seriesTitle: seriesTitle, seriesPart: seriesPart)
            addArrangedSubview(showSeriesButtonContainer)
            setCustomSpacing(33.0, after: showSeriesButtonContainer)
            
            // Add gradient views
            addSubview(leadingViewWithGradient)
            addSubview(trailingViewWithGradient)
        } else {
            hasShowSeriesButtonContainer = false
        }

        addArrangedSubview(roundButtonsStackContainer)
    }
    
    private func applyConstraints() {
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.heightAnchor.constraint(equalToConstant: BookDetailsStackView.imageHeight).isActive = true
        coverImageWidthAnchor.isActive = true
        
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bookTitleLabel.widthAnchor.constraint(equalToConstant: BookDetailsStackView.imageHeight).isActive = true
        
        authorsButton.translatesAutoresizingMaskIntoConstraints = false
        authorsButton.widthAnchor.constraint(equalToConstant: BookDetailsStackView.imageHeight).isActive = true
        authorsButtonHeightConstraint.isActive = true
        
        if hasNarratorsButton {
            narratorsButton.translatesAutoresizingMaskIntoConstraints = false
            narratorsButton.widthAnchor.constraint(equalToConstant: BookDetailsStackView.imageHeight).isActive = true
            narratorsButtonHeightConstraint.isActive = true
        }
        
        if hasShowSeriesButtonContainer {
            showSeriesButtonContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            // Apply constraints of gradient views
            let heightConstant: CGFloat = 10
            leadingViewWithGradient.translatesAutoresizingMaskIntoConstraints = false
            leadingViewWithGradient.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            leadingViewWithGradient.trailingAnchor.constraint(equalTo: coverImageView.leadingAnchor).isActive = true
            leadingViewWithGradient.heightAnchor.constraint(equalTo: showSeriesButtonContainer.heightAnchor, constant: heightConstant).isActive = true
            leadingViewWithGradient.centerYAnchor.constraint(equalTo: showSeriesButtonContainer.centerYAnchor).isActive = true
            
            trailingViewWithGradient.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                trailingViewWithGradient.trailingAnchor.constraint(equalTo: trailingAnchor),
                trailingViewWithGradient.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
                trailingViewWithGradient.heightAnchor.constraint(equalTo: showSeriesButtonContainer.heightAnchor, constant: heightConstant),
                trailingViewWithGradient.centerYAnchor.constraint(equalTo: showSeriesButtonContainer.centerYAnchor)
            ])
        }
    }
    
}
