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
        textView.font = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
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
        textView.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        textView.isScrollEnabled = false
        textView.textColor = .label.withAlphaComponent(0.8)
        textView.textAlignment = .left
//        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainerInset = .zero
        // Ensure that the text is aligned with the left edge of the text view.
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }
    
    // MARK: - Instance properties
    private let book: Book

//    private let mainTextView: UITextView = {
//        let textView = UITextView()
//        textView.isEditable = false
//        textView.backgroundColor = .clear
//        textView.font = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
//        textView.isScrollEnabled = false
//        textView.textColor = .label
//        textView.textAlignment = .left
//        textView.textContainerInset = .zero
//        // Ensure that the text is aligned with the left edge of the text view.
//        textView.textContainer.lineFragmentPadding = 0
//        return textView
//    }()
    private let mainTextView = BookOverviewStackView.createMainTextView()
    
    private lazy var mainTextViewHeightAnchor = mainTextView.heightAnchor.constraint(equalToConstant: 100)
    
    private lazy var audiobookTextView = BookOverviewStackView.createSecondaryTextView()
    private lazy var audiobookTextViewHeightAnchor = audiobookTextView.heightAnchor.constraint(equalToConstant: 100)
    
    private lazy var ebookTextView = BookOverviewStackView.createSecondaryTextView()
    private lazy var ebookTextViewHeightAnchor = ebookTextView.heightAnchor.constraint(equalToConstant: 100)
    
    private lazy var translatorsTextView = BookOverviewStackView.createSecondaryTextView()
    private lazy var translatorsTextViewHeightAnchor  = translatorsTextView.heightAnchor.constraint(equalToConstant: 100)
    
    private var isFirstTime = true

    private var textViews = [UITextView]()
    private var textViewsHeightAnchors = [NSLayoutConstraint]()
    
    lazy var visiblePartForSeeMoreAppearance: CGFloat = {
        var textView = BookOverviewStackView.createMainTextView()
        textView.text = book.overview
        textView.textContainer.maximumNumberOfLines = 8
        
        let width = bounds.width - Constants.cvPadding * 2
        let size = textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        let height = size.height
        return height
    }()
    
    // MARK: - View life cycle
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)
        axis = .vertical
        alignment = .center
        spacing = 16
        configureTextViews()
        textViews.forEach { addArrangedSubview($0) }
        applyConstraints()
        
        
//        backgroundColor = .blue
//        mainTextView.backgroundColor = .green
//        audiobookTextView.backgroundColor = .yellow
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isFirstTime {
            setHeightOfTextViews()
        } else {
            isFirstTime = false
        }
    }
    
    // MARK: - Helper methods
    private func configureTextViews() {
        textViews.append(mainTextView)
        mainTextView.text = book.overview
        textViewsHeightAnchors.append(mainTextViewHeightAnchor)
        
        let bookKind = book.titleKind
        
        if bookKind == .audioBookAndEbook {
            textViews.append(audiobookTextView)
            audiobookTextView.text = "Audiobook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            textViewsHeightAnchors.append(audiobookTextViewHeightAnchor)
            
            textViews.append(ebookTextView)
            ebookTextView.text = "Ebook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            textViewsHeightAnchors.append(ebookTextViewHeightAnchor)
        } else if bookKind == .audiobook {
            textViews.append(audiobookTextView)
            audiobookTextView.text = "Audiobook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            textViewsHeightAnchors.append(audiobookTextViewHeightAnchor)
        } else {
            textViews.append(ebookTextView)
            ebookTextView.text = "Ebook\nRelease: \(book.releaseDate)\nPublisher: \(book.publisher)"
            textViewsHeightAnchors.append(ebookTextViewHeightAnchor)
        }
        
        if let translators = book.translators {
            let isPlural = translators.count > 1
            let title = isPlural ? "Translators" : "Translator"
            let translatorsString = translators.joined(separator: ", ")
            
            textViews.append(translatorsTextView)
            translatorsTextView.text = "\(title)\n\(translatorsString)"
            textViewsHeightAnchors.append(translatorsTextViewHeightAnchor)
        }

    }
    
    private func setHeightOfTextViews() {
        for (index, textView) in textViews.enumerated() {
            let width = bounds.width - Constants.cvPadding * 2
            let size = textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            let height = size.height
            
            let heightAnchorOfTextView = textViewsHeightAnchors[index]
            heightAnchorOfTextView.constant = height
        }
        
    }

    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        for textView in textViews {
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.cvPadding * 2).isActive = true
        }
        
        for anchor in textViewsHeightAnchors {
            anchor.isActive = true
        }
        
        // Set stack view height
        let lastTextView = textViews.last!
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: topAnchor),
            lastTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
//        lastTextView.backgroundColor = .green
        // Ensure that last text view doesn't have even a tiny bottom padding
        lastTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: -4, right: 0)

        
        // Force layoutSubviews() ro run second time to get correct bounds.width for setting height of text views
        layoutIfNeeded()
    }

}
