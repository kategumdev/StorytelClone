//
//  BookDetailsScrollView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 23/3/23.
//

import UIKit

class BookDetailsScrollView: UIScrollView {

    static func createLabelWith(text: String) -> UILabel {
        let label = UILabel()
        label.font = Utils.sectionSubtitleFont
        label.text = text
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }
    
    static func createButtonWith(text: String, symbolImageName: String?) -> UIButton {
        let button = UIButton()
        button.tintColor = UIColor.label
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString(text)
        buttonConfig.attributedTitle?.font = Utils.navBarTitleFont
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
        if let symbolImageName = symbolImageName {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
            buttonConfig.image = image
            buttonConfig.imagePlacement = .leading
            buttonConfig.imagePadding = 4
        }
        
        button.configuration = buttonConfig
        button.sizeToFit()
        return button
    }
    
    static func createVertStackWith(label: UILabel, button: UIButton) -> UIStackView {
        let stack = UIStackView()
//        stack.backgroundColor = .magenta
        stack.axis = .vertical
//        stack.alignment = .center
        stack.alignment = .leading
        stack.spacing = 3
        [label, button].forEach { stack.addArrangedSubview($0)}
        
//        stack.translatesAutoresizingMaskIntoConstraints = false
////        let width = max(label.bounds.width, button.bounds.width) + Constants.cvPadding * 2
////        let width = max(label.bounds.width, button.bounds.width) + Constants.cvPadding
//        let width = max(label.bounds.width, button.bounds.width)
//        NSLayoutConstraint.activate([
//            stack.widthAnchor.constraint(equalToConstant: width),
//            stack.topAnchor.constraint(equalTo: label.topAnchor),
//            stack.bottomAnchor.constraint(equalTo: button.bottomAnchor)
//        ])
        
        return stack
    }
    
    static func createVertBarView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }
    
    private let book: Book
    
    private let ratingsLabel = createLabelWith(text: "80 Ratings")
    private let ratingButton = createButtonWith(text: "4,3", symbolImageName: "star.fill")
    private lazy var ratingStack = BookDetailsScrollView.createVertStackWith(label: ratingsLabel, button: ratingButton)
    
    private let durationLabel = createLabelWith(text: "Duration")
    private let durationButton = createButtonWith(text: "21h 24m", symbolImageName: "clock")
    private lazy var durationStack = BookDetailsScrollView.createVertStackWith(label: durationLabel, button: durationButton)
    
    private let languageLabel = createLabelWith(text: "Language")
    private let languageButton = createButtonWith(text: "Spanish", symbolImageName: nil)
    private lazy var languageStack = BookDetailsScrollView.createVertStackWith(label: languageLabel, button: languageButton)
    
    private let categoryLabel = createLabelWith(text: "Category")
    
    private let categoryButton: UIButton = {
        let button = createButtonWith(text: "Teens & Young Adult", symbolImageName: "chevron.forward")
        button.configuration?.imagePlacement = .trailing
        return button
    }()
    
    private lazy var categoryStack = BookDetailsScrollView.createVertStackWith(label: categoryLabel, button: categoryButton)

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = Constants.cvPadding
        return stack
    }()
    
    private var vertBarViews = [UIView]()
    
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)
        layer.borderColor = UIColor.tertiaryLabel.cgColor
        layer.borderWidth = 0.5
        showsHorizontalScrollIndicator = false
        
        
        
        configureMainStack()
        addSubview(mainStackView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(button: UIButton, withText text: String) {
        button.configuration?.attributedTitle = AttributedString("\(text)")
        button.configuration?.attributedTitle?.font = Utils.navBarTitleFont
    }
    
    private func configureMainStack() {
        let bookKind = book.titleKind
        
        // Configure labels and buttons with text
        ratingsLabel.text = "\(book.reviewsNumber) Ratings"
        configure(button: ratingButton, withText: "\(book.rating)")

        
//        ratingButton.configuration?.attributedTitle = AttributedString("\(book.rating)")
//        ratingButton.configuration?.attributedTitle?.font = Utils.navBarTitleFont
        
        if bookKind == .audioBookAndEbook || bookKind == .audiobook {
//            durationButton.configuration?.attributedTitle = AttributedString("\(book.duration)")
            configure(button: durationButton, withText: "\(book.duration)")

        }
        
//        languageButton.configuration?.attributedTitle = AttributedString("\(book.language.rawValue)")
        configure(button: languageButton, withText: "\(book.language.rawValue)")

        
//        categoryButton.configuration?.attributedTitle = AttributedString("\(book.category.rawValue)")
        configure(button: categoryButton, withText: "\(book.category.rawValue)")

        
        // Add arrangedSubviews
        mainStackView.addArrangedSubview(ratingStack)
        let vertBar1 = BookDetailsScrollView.createVertBarView()
        vertBarViews.append(vertBar1)
        mainStackView.addArrangedSubview(vertBar1)
        
        if bookKind == .audioBookAndEbook || bookKind == .audiobook {
            mainStackView.addArrangedSubview(durationStack)
            let vertBar2 = BookDetailsScrollView.createVertBarView()
            vertBarViews.append(vertBar2)
            mainStackView.addArrangedSubview(vertBar2)
        }
        
        mainStackView.addArrangedSubview(languageStack)
        let vertBar3 = BookDetailsScrollView.createVertBarView()
        vertBarViews.append(vertBar3)
        mainStackView.addArrangedSubview(vertBar3)
        
        mainStackView.addArrangedSubview(categoryStack)
    }
    
    private func applyConstraints() {
        let contentG = contentLayoutGuide
        let frameG = frameLayoutGuide
        
//        mainStackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            mainStackView.centerYAnchor.constraint(equalTo: contentG.centerYAnchor),
//            mainStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 8),
//            mainStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -8),
////            mainStackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -16),
//            mainStackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -32)
//        ])


        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        let extraPaddingsY: CGFloat = 36
        let extraPaddingsX: CGFloat = 50
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: extraPaddingsY / 2.0),
            mainStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: extraPaddingsX / 2.0),
            mainStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -extraPaddingsX / 2),
            mainStackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -extraPaddingsY / 2.0),
            mainStackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -extraPaddingsY)
        ])
        
//        var stacks = [UIStackView]()
//        if book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook {
//            stacks = [ratingStack, durationStack, languageStack, categoryStack]
//        } else {
//            stacks = [ratingStack, languageStack, categoryStack]
//        }
//
//
//
//        for stack in stacks {
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            let width = max(label.bounds.width, button.bounds.width)
//            NSLayoutConstraint.activate([
//                stack.widthAnchor.constraint(equalToConstant: width),
//                stack.topAnchor.constraint(equalTo: label.topAnchor),
//                stack.bottomAnchor.constraint(equalTo: button.bottomAnchor)
//            ])
//        }
        
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        let ratingStackWidth = max(ratingsLabel.bounds.width, ratingButton.bounds.width)
        NSLayoutConstraint.activate([
            ratingStack.widthAnchor.constraint(equalToConstant: ratingStackWidth),
            ratingStack.topAnchor.constraint(equalTo: ratingsLabel.topAnchor),
            ratingStack.bottomAnchor.constraint(equalTo: ratingButton.bottomAnchor)
        ])
        
        if book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook {
            durationStack.translatesAutoresizingMaskIntoConstraints = false
            let durationStackWidth = max(durationLabel.bounds.width, durationButton.bounds.width)
            NSLayoutConstraint.activate([
                durationStack.widthAnchor.constraint(equalToConstant: durationStackWidth),
                durationStack.topAnchor.constraint(equalTo: durationLabel.topAnchor),
                durationStack.bottomAnchor.constraint(equalTo: durationButton.bottomAnchor)
            ])
        }
        
        languageStack.translatesAutoresizingMaskIntoConstraints = false
        let languageStackWidth = max(languageLabel.bounds.width, languageButton.bounds.width)
        NSLayoutConstraint.activate([
            languageStack.widthAnchor.constraint(equalToConstant: languageStackWidth),
            languageStack.topAnchor.constraint(equalTo: languageLabel.topAnchor),
            languageStack.bottomAnchor.constraint(equalTo: languageButton.bottomAnchor)
        ])
        
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        let categoryStackWidth = max(categoryLabel.bounds.width, categoryButton.bounds.width)
        NSLayoutConstraint.activate([
            categoryStack.widthAnchor.constraint(equalToConstant: categoryStackWidth),
            categoryStack.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
            categoryStack.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor)
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
