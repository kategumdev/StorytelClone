//
//  BookOverviewStackView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 24/3/23.
//

import UIKit

class BookOverviewStackView: UIStackView {
    private let book: Book
    let defaultVisiblePartWhenCompressed: CGFloat = 120
    
    private var textViews = [UITextView]()
    
    private let mainTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        let scaledFont = UIFont.createScaledFontWith(textStyle: .callout, weight: .regular)
        textView.font = scaledFont
        textView.adjustsFontForContentSizeCategory = true
        textView.isScrollEnabled = false
        textView.textColor = .label
        textView.textAlignment = .left
        textView.textContainerInset = .zero
        // Ensure that the text is aligned with the left edge of the text view.
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    private lazy var audiobookTextView = createSecondaryTextView()
    private lazy var ebookTextView = createSecondaryTextView()
    private lazy var translatorsTextView = createSecondaryTextView()
        
    // MARK: - Initializers
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func setupUI() {
        axis = .vertical
        alignment = .center
        spacing = 16
        configureTextViews()
        textViews.forEach { addArrangedSubview($0) }
        applyConstraints()
    }
    
    private func configureTextViews() {
        mainTextView.text = book.overview
        textViews.append(mainTextView)
        
        let bookKind = book.titleKind
        
        if bookKind == .audioBookAndEbook {
            audiobookTextView.text = "Audiobook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            textViews.append(audiobookTextView)
            
            ebookTextView.text = "Ebook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            textViews.append(ebookTextView)
        } else if bookKind == .audiobook {
            audiobookTextView.text = "Audiobook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            textViews.append(audiobookTextView)
        } else {
            ebookTextView.text = "Ebook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            textViews.append(ebookTextView)
        }
        
        if let translators = book.translators {
            let isPlural = translators.count > 1
            let title = isPlural ? "Translators" : "Translator"
            let translatorsString = translators.joined(separator: ", ")
            
            translatorsTextView.text = "\(title)\n\(translatorsString)"
            textViews.append(translatorsTextView)
        }
    }
    
    private func createSecondaryTextView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = UIFont.customFootnoteSemibold
        textView.adjustsFontForContentSizeCategory = true
        textView.isScrollEnabled = false
        textView.textColor = .label.withAlphaComponent(0.8)
        textView.textAlignment = .left
        textView.textContainerInset = .zero
        // Ensure that the text is aligned with the left edge of the text view.
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }

    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        for textView in textViews {
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.widthAnchor.constraint(
                equalTo: widthAnchor,
                constant: -Constants.commonHorzPadding * 2).isActive = true
        }
        
        // Set stack view height
        let lastTextView = textViews.last!
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: topAnchor),
            lastTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
