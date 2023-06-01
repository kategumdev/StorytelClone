//
//  BookDetailsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/3/23.
//

import UIKit

class BookDetailsStackView: UIStackView {
    // MARK: - Static properties
    static let imageHeight: CGFloat = ceil(UIScreen.main.bounds.width * 0.75)
    
    // MARK: - Instance properties
    private let book: Book

    var showSeriesButtonDidTapCallback: () -> () = {} {
        didSet {
            showSeriesButtonContainer.showSeriesButtonDidTapCallback = showSeriesButtonDidTapCallback
        }
    }
    
    var saveBookButtonDidTapCallback: SaveBookButtonDidTapCallback = {_ in} {
        didSet {
            roundButtonsStackContainer.saveBookButtonDidTapCallback = saveBookButtonDidTapCallback
        }
    }

    var storytellerButtonDidTapCallback: ([Storyteller]) -> () = {_ in}
    
    private let coverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.commonBookCoverCornerRadius
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.layer.borderWidth = 0.6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var coverImageWidthConstraint = coverImageView.widthAnchor.constraint(equalToConstant: BookDetailsStackView.imageHeight)
    
    let spacingAfterCoverImageView: CGFloat = 24.0

    private let bookTitleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .title3, weight: .bold, basePointSize: 19)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 2)
        label.textAlignment = .center
        return label
    }()
    
    lazy var bookTitleLabelHeight = bookTitleLabel.bounds.height
    
    private let authorsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }()
    
    private lazy var authorsButtonHeightConstraint = authorsButton.heightAnchor.constraint(equalToConstant: 50) // 50 is placeholder value
    
    private lazy var hasNarratorsButton = !book.narrators.isEmpty

    private lazy var narratorsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }()
    
    private lazy var narratorsButtonHeightConstraint = narratorsButton.heightAnchor.constraint(equalToConstant: 50) // 50 is placeholder value

    private lazy var showSeriesButtonContainer = ShowSeriesButtonContainer()
    private var hasShowSeriesButtonContainer = true
    
    lazy var roundButtonsStackContainer = RoundButtonsStack(forBook: book)
    
    private lazy var leadingViewWithGradient: UIView = {
        let view = UIView()
        view.layer.addSublayer(leadingGradientLayer)
        return view
    }()
    
    private lazy var leadingGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        return gradientLayer
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

    private var gradientColors: [CGColor] {
        let colors = [UIColor.customBackgroundColor!.withAlphaComponent(0).cgColor,      UIColor.customBackgroundColor!.withAlphaComponent(1).cgColor]
        return colors
    }
    
    private var gradientIsAdded = false
            
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
                configureNarratorsButton()
            }
        }
    }
    
    // MARK: - Instance methods
    func updateSaveButtonAppearance() {
        roundButtonsStackContainer.updateSaveButtonAppearance()
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        axis = .vertical
        alignment = .center
        
        coverImageView.setImageForBook(book, defaultImageViewHeight: BookDetailsStackView.imageHeight, imageViewWidthConstraint: coverImageWidthConstraint)
        
        addArrangedSubview(coverImageView)
        setCustomSpacing(spacingAfterCoverImageView, after: coverImageView)

        bookTitleLabel.text = book.title
        addArrangedSubview(bookTitleLabel)
        setCustomSpacing(16.0, after: bookTitleLabel)
        
        configureAuthorsButton()
        addArrangedSubview(authorsButton)
        setCustomSpacing(8.0, after: authorsButton)
        
        let authors = self.book.authors
        addActionTo(button: authorsButton, toShowStorytellers: authors)
        
        if hasNarratorsButton {
            configureNarratorsButton()
             addArrangedSubview(narratorsButton)
             setCustomSpacing(23.0, after: narratorsButton)
            let narrators = self.book.narrators
            addActionTo(button: narratorsButton, toShowStorytellers: narrators)
        } else {
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
                
    private func addActionTo(button: UIButton, toShowStorytellers storytellers: [Storyteller]) {
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            Utils.playHaptics()
            self.storytellerButtonDidTapCallback(storytellers)
        }), for: .touchUpInside)
    }

    private func configureAuthorsButton() {
        let authorNames = book.authors.map { $0.name }
        configure(button: authorsButton, withStaticString: "By:", andNames: authorNames)
        
        // Avoid top and bottom content insets
        authorsButton.titleLabel?.sizeToFit()
        guard let buttonTitleLabel = authorsButton.titleLabel else { return }
        authorsButtonHeightConstraint.constant = buttonTitleLabel.bounds.height
    }
    
    private func configureNarratorsButton() {
        let narratorNames = book.narrators.map { $0.name }
        configure(button: narratorsButton, withStaticString: "With:", andNames: narratorNames)
        
        // Avoid top and bottom content insets
        narratorsButton.titleLabel?.sizeToFit()
        guard let buttonTitleLabel = narratorsButton.titleLabel else { return }
        narratorsButtonHeightConstraint.constant = buttonTitleLabel.bounds.height
    }
    
    private func configure(button: UIButton, withStaticString staticString: String, andNames names: [String]) {
        let namesString = names.joined(separator: ", ")

        let attributedString = NSMutableAttributedString(string: "\(staticString) \(namesString)")
        let staticStringScaledFont1 = UIFont.createScaledFontWith(textStyle: .callout, weight: .regular)
        let staticStringAttributes: [NSAttributedString.Key: Any] = [.font: staticStringScaledFont1, .foregroundColor: UIColor.label]

        let nameScaledFont = UIFont.createScaledFontWith(textStyle: .callout, weight: .semibold)
        let nameAttributes: [NSAttributedString.Key: Any] = [.font: nameScaledFont, .foregroundColor: UIColor.customTintColor]

        let staticStringCount = staticString.count
        attributedString.addAttributes(staticStringAttributes, range: NSRange(location: 0, length: staticStringCount))
        attributedString.addAttributes(nameAttributes, range: NSRange(location: staticStringCount, length: attributedString.length - staticStringCount))

        button.setAttributedTitle(attributedString, for: .normal)
    }
        
    private func applyConstraints() {
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.heightAnchor.constraint(equalToConstant: BookDetailsStackView.imageHeight).isActive = true
        coverImageWidthConstraint.isActive = true
        
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
