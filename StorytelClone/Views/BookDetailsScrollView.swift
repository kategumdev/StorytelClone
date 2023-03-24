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
//        button.titleLabel?.font = Utils.navBarTitleFont
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString(text)
        buttonConfig.attributedTitle?.font = Utils.navBarTitleFont
                
        if let symbolImageName = symbolImageName {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
            buttonConfig.image = image
            buttonConfig.imagePlacement = .leading
            buttonConfig.imagePadding = 4
        }
        
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        button.configuration = buttonConfig
        
//        button.backgroundColor = .green
        button.sizeToFit()
        return button
    }
    
    static func createVertBarView() -> UIView {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        return view
    }
    
//    static func createButtonWith(text: String, symbolImageName: String?) -> UIButton {
//        let button = UIButton()
//        button.setTitle(text, for: .normal)
//        button.titleLabel?.font = Utils.navBarTitleFont
//
//        if let symbolImageName = symbolImageName {
//            var buttonConfig = UIButton.Configuration.plain()
//            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
//            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)?.withRenderingMode(.alwaysOriginal)
//            buttonConfig.image = image
//            buttonConfig.imagePlacement = .leading
//            button.configuration = buttonConfig
//        }
//
//        button.sizeToFit()
//        return button
//    }
    
//    static func createButtonWith(text: String, symbolImageName: String?) -> UIButton {
//        let button = UIButton()
//        button.setTitle(text, for: .normal)
//        button.titleLabel?.font = Utils.navBarTitleFont
//
//        if let symbolImageName = symbolImageName {
//            let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
//            let image = UIImage(systemName: symbolImageName, withConfiguration: config)?.withRenderingMode(.alwaysOriginal)
//            button.setImage(image, for: .normal)
//        }
//
//        button.sizeToFit()
//        return button
//    }
    
    static func createVertStackWith(label: UILabel, button: UIButton) -> UIStackView {
        let stack = UIStackView()
//        stack.backgroundColor = .magenta
        stack.axis = .vertical
//        stack.alignment = .center
        stack.alignment = .leading
        stack.spacing = 3
        [label, button].forEach { stack.addArrangedSubview($0)}
        
        stack.translatesAutoresizingMaskIntoConstraints = false
//        let width = max(label.bounds.width, button.bounds.width) + Constants.cvPadding * 2
        let width = max(label.bounds.width, button.bounds.width) + Constants.cvPadding
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant: width),
            stack.topAnchor.constraint(equalTo: label.topAnchor),
            stack.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        
        return stack
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
    
    
//    private let categoryButton = createButtonWith(text: "Teens & Young Adult", symbolImageName: "chevron.forward")
    
//    private let ratingsLabel: UILabel = {
//        let label = UILabel()
//        label.font = Utils.sectionSubtitleFont
//        label.text = "80 ratings"
//        label.sizeToFit()
//        return label
//    }()
    
//    private let ratingButton: UIButton = {
//        let button = UIButton()
////        button.isUserInteractionEnabled = false
//        button.setTitle("4,3", for: .normal)
//        button.titleLabel?.font = Utils.navBarTitleFont
//        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
//        let image = UIImage(systemName: "star.fill", withConfiguration: config)?.withRenderingMode(.alwaysOriginal)
//        button.setImage(image, for: .normal)
//        button.sizeToFit()
//        return button
//    }()
    
//    private lazy var ratingStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.alignment = .center
//        stack.spacing = 16
//        [ratingsLabel, ratingButton].forEach { stack.addArrangedSubview($0)}
//        return stack
//    }()
    
//    private let durationLabel = createLabelWith(text: "Duration")
//    private let durationButton = createButtonWith(text: "21h 24m", symbolImageName: "clock")
//    private lazy var durationStack =
    
//    private let durationButton: UIButton = {
//        let button = UIButton()
////        button.isUserInteractionEnabled = false
//        button.setTitle("21h 24m", for: .normal)
//        button.titleLabel?.font = Utils.navBarTitleFont
//        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
//        let image = UIImage(systemName: "star.fill", withConfiguration: config)?.withRenderingMode(.alwaysOriginal)
//        button.setImage(image, for: .normal)
//        button.sizeToFit()
//        return button
//    }()
    

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 3
        
        
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.heightAnchor.constraint(equalToConstant: SearchResultsButtonsView.heightForStackWithButtons).isActive = true
        
        return stack
    }()
    

    
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
    
    private func configureMainStack() {
        let bookKind = book.titleKind
        mainStackView.addArrangedSubview(ratingStack)
        
        if bookKind == .audioBookAndEbook || bookKind == .audiobook {
            mainStackView.addArrangedSubview(durationStack)
        }
        
        mainStackView.addArrangedSubview(languageStack)
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
        let extraPaddings: CGFloat = 32
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: extraPaddings / 2.0),
            mainStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 23),
            mainStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -23),
            mainStackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -extraPaddings / 2.0),
            mainStackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -extraPaddings)
        ])
        
        
        
    }
    
    



}
