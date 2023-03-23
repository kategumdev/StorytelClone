//
//  BookDetailsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/3/23.
//

import UIKit

class BookDetailsView: UIStackView {
    
    static let imageHeight: CGFloat = ceil(UIScreen.main.bounds.width * 0.75)
//    static let imageHeight: CGFloat = 250
    
    private var book: Book?
    
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
        button.tintColor = UIColor.label
        var config = UIButton.Configuration.plain()
//        button.setTitle("Part 1", for: .normal)
        button.setTitle("Part 1 in Cazadores de sombras. Las últimas horas", for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        button.titleLabel?.font = font
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addSubview(seriesButtonLeadingImage)
        button.addSubview(seriesButtonTrailingImage)
        return button
    }()
    
    private let seriesButtonTrailingImage: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: config)
        imageView.image = image?.withRenderingMode(.alwaysOriginal)
        imageView.image?.withTintColor(.label)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let seriesButtonLeadingImage: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "rectangle.stack", withConfiguration: config)
        imageView.image = image?.withRenderingMode(.alwaysOriginal)
        imageView.image?.withTintColor(.label)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
//    let roundButtonsStackContainer = RoundButtonsStackContainer()
    
//    private lazy var roundButtonsStackContainer = RoundButtonsStackContainer(forBook: book!) // book will always be set
    
    private lazy var roundButtonsStackContainer = RoundButtonsStackContainer(forBookKind: book!.titleKind) // book will always be set
    
    private var hasSeriesButtonView: Bool = true


//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureAuthorLabel(withName: "Neil Gaiman")
//        configureNarratorLabel(withName: "Nancy Butler")
//        bookTitleLabel.text = "La cadena de oro"
//
//        configureSelf()
////        axis = .vertical
////        alignment = .center
////        [coverImageView, bookTitleLabel, authorLabel, narratorLabel, viewWithShowSeriesButton, roundButtonsStackContainer].forEach { addArrangedSubview($0)}
////        setCustomSpacing(24.0, after: coverImageView)
////        setCustomSpacing(16.0, after: bookTitleLabel)
////        setCustomSpacing(8.0, after: authorLabel)
////        setCustomSpacing(23.0, after: narratorLabel)
////        setCustomSpacing(33.0, after: viewWithShowSeriesButton)
////
//        applyConstraints()
//    }
    
    init(forBook book: Book) {
        super.init(frame: .zero)
        self.book = book
        
        configureAuthorLabel(withName: "Neil Gaiman")
        configureNarratorLabel(withName: "Nancy Butler")
        bookTitleLabel.text = "La cadena de oro"
        
        configureSelf()
        
        applyConstraints()

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            coverImageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }
    
    private func configureSelf() {
        axis = .vertical
        alignment = .center
        
        guard let book = book else { return }
        
        bookTitleLabel.text = book.title
        
        coverImageView.image = book.coverImage
        
        #warning("Resize image and set coverImageWidthAnchor accordingly")
        
        let authorNames = book.authors.map { $0.name }
        let authorNamesString = authorNames.joined(separator: ", ")
        configureAuthorLabel(withName: authorNamesString)
        
        #warning("Configure narratorLabel if book.narrators != nil")
            
        if let series = book.series, let seriesPart = book.seriesPart {
            let text = "Part \(seriesPart) in \(series)"
            showSeriesButton.setTitle(text, for: .normal)
            
            [coverImageView, bookTitleLabel, authorLabel, narratorLabel, viewWithShowSeriesButton, roundButtonsStackContainer].forEach { addArrangedSubview($0)}
            setCustomSpacing(24.0, after: coverImageView)
            setCustomSpacing(16.0, after: bookTitleLabel)
            setCustomSpacing(8.0, after: authorLabel)
            setCustomSpacing(23.0, after: narratorLabel)
            setCustomSpacing(33.0, after: viewWithShowSeriesButton)
        } else {
            hasSeriesButtonView = false
            [coverImageView, bookTitleLabel, authorLabel, narratorLabel, roundButtonsStackContainer].forEach { addArrangedSubview($0)}
            setCustomSpacing(24.0, after: coverImageView)
            setCustomSpacing(16.0, after: bookTitleLabel)
            setCustomSpacing(8.0, after: authorLabel)
            setCustomSpacing(32.0, after: narratorLabel)
        }
        
//        [coverImageView, bookTitleLabel, authorLabel, narratorLabel, viewWithShowSeriesButton, roundButtonsStackContainer].forEach { addArrangedSubview($0)}
//        setCustomSpacing(24.0, after: coverImageView)
//        setCustomSpacing(16.0, after: bookTitleLabel)
//        setCustomSpacing(8.0, after: authorLabel)
//        setCustomSpacing(23.0, after: narratorLabel)
//        setCustomSpacing(33.0, after: viewWithShowSeriesButton)
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
        
        
        guard hasSeriesButtonView else { return }
        
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
    }
    
}
