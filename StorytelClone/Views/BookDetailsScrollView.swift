//
//  BookDetailsScrollView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 23/3/23.
//

import UIKit

class BookDetailsScrollView: UIScrollView {
    // MARK: - Static methods
    static func createLabelWith(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.sectionSubtitle
        label.textColor = .label.withAlphaComponent(0.9)
        label.text = text
        label.adjustsFontForContentSizeCategory = true
        return label
    }
    
    static func createButtonWith(symbolImageName: String?, imagePlacement: NSDirectionalRectEdge = .leading, enableInteraction: Bool = false) -> UIButton {
        let button = UIButton()
        button.tintColor = .label.withAlphaComponent(0.8)
        button.isUserInteractionEnabled = enableInteraction
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.contentInsets = .zero
        buttonConfig.titleAlignment = .leading

        if let symbolImageName = symbolImageName {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
            buttonConfig.image = image
            buttonConfig.imagePlacement = imagePlacement
            buttonConfig.imagePadding = 4
        }
        button.configuration = buttonConfig
        return button
    }
    
    // MARK: - Instance properties
    private let book: Book
    
    private let ratingsLabel = createLabelWith(text: "80 Ratings")
    private let ratingButton = createButtonWith(symbolImageName: "star.fill")
    private lazy var ratingVertStack = createVertStackWith(label: ratingsLabel, button: ratingButton)
    
    private lazy var hasAudio = book.titleKind == .audioBookAndEbook || book.titleKind == .audiobook
    private lazy var durationLabel = BookDetailsScrollView.createLabelWith(text: "Duration")
    private let durationButton = createButtonWith(symbolImageName: "clock")
    private lazy var durationVertStack = createVertStackWith(label: durationLabel, button: durationButton)
    
    private let languageLabel = createLabelWith(text: "Language")
    private let languageButton = createButtonWith(symbolImageName: nil)
    private lazy var languageVertStack = createVertStackWith(label: languageLabel, button: languageButton)

    private let categoryLabel = createLabelWith(text: "Category")
        private let categoryButton = createButtonWith(symbolImageName: "chevron.forward", imagePlacement: .trailing, enableInteraction: true)
    var categoryButtonDidTapCallback: () -> () = {}
    private lazy var categoryVertStack = createVertStackWith(label: categoryLabel, button: categoryButton)

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = Constants.commonHorzPadding
        return stack
    }()
    
    private var vertBarViews = [UIView]()
    private var allButtons = [UIButton]()
    
    // MARK: - Initializers
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)
        layer.borderColor = UIColor.quaternaryLabel.cgColor
        layer.borderWidth = 1
        showsHorizontalScrollIndicator = false
        configureMainStack()
        addSubview(mainStackView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.quaternaryLabel.cgColor
        }
        
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            print("\n")
            for button in allButtons {
                button.configuration?.attributedTitle?.font = UIFont.navBarTitleLargeMaxSize
            }
        }
    }
    
    // MARK: - Helper methods
    private func configure(button: UIButton, withText text: String) {
        button.configuration?.attributedTitle = AttributedString(text)
        button.configuration?.attributedTitle?.font = UIFont.navBarTitleLargeMaxSize
    }
    
    private func configureMainStack() {
        // Configure labels and buttons with text
        ratingsLabel.text = "\(book.reviewsNumber) Ratings"
        configure(button: ratingButton, withText: "\(book.rating)")
        allButtons.append(ratingButton)
 
        if hasAudio {
            configure(button: durationButton, withText: "\(book.duration)")
            allButtons.append(durationButton)
        }
        
        configure(button: languageButton, withText: "\(book.language.rawValue)")
        allButtons.append(languageButton)

        let categoryText = book.buttonCategory.rawValue.replacingOccurrences(of: "\n", with: " ")
        configure(button: categoryButton, withText: categoryText)
        allButtons.append(categoryButton)
        addCategoryButtonAction()
        
        // Add arrangedSubviews
        mainStackView.addArrangedSubview(ratingVertStack)
        
        let vertBar1 = createVertBarView()
        vertBarViews.append(vertBar1)
        mainStackView.addArrangedSubview(vertBar1)
        
        if hasAudio {
            mainStackView.addArrangedSubview(durationVertStack)
            
            let vertBar2 = createVertBarView()
            vertBarViews.append(vertBar2)
            mainStackView.addArrangedSubview(vertBar2)
        }
        
        mainStackView.addArrangedSubview(languageVertStack)
        
        let vertBar3 = createVertBarView()
        vertBarViews.append(vertBar3)
        mainStackView.addArrangedSubview(vertBar3)
        
        mainStackView.addArrangedSubview(categoryVertStack)
    }
    
    private func createVertStackWith(label: UILabel, button: UIButton) -> UIStackView {
        label.sizeToFit()
        button.sizeToFit()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 3
        [label, button].forEach { stack.addArrangedSubview($0) }
        return stack
    }
    
    private func createVertBarView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }
    
    private func addCategoryButtonAction() {
        categoryButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.categoryButtonDidTapCallback()
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        let contentG = contentLayoutGuide
        let frameG = frameLayoutGuide
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        let topPadding: CGFloat = 20
        let bottomPadding: CGFloat = 14
        let leadingTrailingPadding: CGFloat = 25
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: topPadding),
            mainStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: leadingTrailingPadding),
            mainStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -leadingTrailingPadding),
            mainStackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -bottomPadding),
            mainStackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -(topPadding + bottomPadding))
        ])
        
        for vertBarView in vertBarViews {
            vertBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vertBarView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, constant: -6),
                vertBarView.widthAnchor.constraint(equalToConstant: 1)
            ])
        }
    }

}

