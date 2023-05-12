//
//  BookOverviewStackView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 24/3/23.
//

import UIKit

class BookOverviewStackView: UIStackView {
    
    // MARK: - Static methods
    static func createMainTextView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = getScaledFontForMainTextView()
        textView.isScrollEnabled = false
        textView.textColor = .label
        textView.textAlignment = .left
        textView.textContainerInset = .zero
        // Ensure that the text is aligned with the left edge of the text view.
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }
    
    static func createSecondaryTextView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = getScaledFontForSecondaryTextView()
        textView.isScrollEnabled = false
        textView.textColor = .label.withAlphaComponent(0.8)
        textView.textAlignment = .left
        textView.textContainerInset = .zero
        // Ensure that the text is aligned with the left edge of the text view.
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }
    
    static func getScaledFontForMainTextView() -> UIFont {
        let font = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
        return scaledFont
    }
    
    static func getScaledFontForSecondaryTextView() -> UIFont {
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 40)
        return scaledFont
    }
    
    // MARK: - Instance properties
    private let book: Book
    let defaultVisiblePartWhenCompressed: CGFloat = 120
    private let mainTextView = BookOverviewStackView.createMainTextView()
    private let audiobookTextView = BookOverviewStackView.createSecondaryTextView()
    private let ebookTextView = BookOverviewStackView.createSecondaryTextView()
    private let translatorsTextView = BookOverviewStackView.createSecondaryTextView()
    private var textViews = [UITextView]()
        
    // MARK: - Initializers
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)
        axis = .vertical
        alignment = .center
        spacing = 16
        configureTextViews()
        textViews.forEach { addArrangedSubview($0) }
        applyConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            
            mainTextView.font = BookOverviewStackView.getScaledFontForMainTextView()
            for view in textViews {
                if view !== mainTextView {
                    view.font = BookOverviewStackView.getScaledFontForSecondaryTextView()
                }
            }
        }
    }
    
    // MARK: - Helper methods
    private func configureTextViews() {
        textViews.append(mainTextView)
        mainTextView.text = book.overview
        
        let bookKind = book.titleKind
        
        if bookKind == .audioBookAndEbook {
            textViews.append(audiobookTextView)
            audiobookTextView.text = "Audiobook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            
            textViews.append(ebookTextView)
            ebookTextView.text = "Ebook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
        } else if bookKind == .audiobook {
            textViews.append(audiobookTextView)
            audiobookTextView.text = "Audiobook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
        } else {
            textViews.append(ebookTextView)
            ebookTextView.text = "Ebook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
        }
        
        if let translators = book.translators {
            let isPlural = translators.count > 1
            let title = isPlural ? "Translators" : "Translator"
            let translatorsString = translators.joined(separator: ", ")
            
            textViews.append(translatorsTextView)
            translatorsTextView.text = "\(title)\n\(translatorsString)"
        }

    }

    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        for textView in textViews {
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.commonHorzPadding * 2).isActive = true
        }
        
        // Set stack view height
        let lastTextView = textViews.last!
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: topAnchor),
            lastTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Ensure that last text view doesn't have even a tiny bottom padding
        lastTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: -4, right: 0)
    }

}
