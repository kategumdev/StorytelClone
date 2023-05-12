//
//  BookDetailsScrollView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 23/3/23.
//

import UIKit

class BookDetailsScrollView: UIScrollView {
    // MARK: - Static methods
    static func getScaledFontForLabel() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: Utils.sectionSubtitleFont, maximumPointSize: 42)
    }
    
    static func getScaledFontForButton() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: Utils.navBarTitleFont, maximumPointSize: 45)
    }
    
    static func createLabelWith(text: String) -> UILabel {
        let label = UILabel()
//        label.font = Utils.sectionSubtitleFont
        label.font = getScaledFontForLabel()
        label.textColor = .label.withAlphaComponent(0.9)
        label.text = text
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }
    
    static func createButtonWith(symbolImageName: String?) -> UIButton {
        let button = UIButton()
        button.tintColor = .label.withAlphaComponent(0.8)
        
        var buttonConfig = UIButton.Configuration.plain()
//        buttonConfig.attributedTitle = AttributedString(text)
//        buttonConfig.attributedTitle?.font = Utils.navBarTitleFont
//        buttonConfig.attributedTitle?.font = getScaledFontForButton()
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
        if let symbolImageName = symbolImageName {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
            buttonConfig.image = image
            buttonConfig.imagePlacement = .leading
            buttonConfig.imagePadding = 4
        }
        
        button.configuration = buttonConfig
        return button
    }
    
//    static func createButtonWith(text: String, symbolImageName: String?) -> UIButton {
//        let button = UIButton()
//        button.tintColor = .label.withAlphaComponent(0.8)
//
//        var buttonConfig = UIButton.Configuration.plain()
////        buttonConfig.attributedTitle = AttributedString(text)
////        buttonConfig.attributedTitle?.font = Utils.navBarTitleFont
////        buttonConfig.attributedTitle?.font = getScaledFontForButton()
//        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//
//        if let symbolImageName = symbolImageName {
//            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
//            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
//            buttonConfig.image = image
//            buttonConfig.imagePlacement = .leading
//            buttonConfig.imagePadding = 4
//        }
//
//        button.configuration = buttonConfig
//        return button
//    }
    
    static func createVertStackWith(label: UILabel, button: UIButton) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 3
        [label, button].forEach { stack.addArrangedSubview($0)}
        return stack
    }
    
    static func createVertBarView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }
    
    // MARK: - Instance properties
    private let book: Book
    
    private let ratingsLabel = createLabelWith(text: "80 Ratings")
//    private let ratingButton = createButtonWith(text: "4,3", symbolImageName: "star.fill")
    private let ratingButton = createButtonWith(symbolImageName: "star.fill")

    private lazy var ratingVertStack = BookDetailsScrollView.createVertStackWith(label: ratingsLabel, button: ratingButton)
    
    private lazy var hasAudio = book.titleKind == .audioBookAndEbook || book.titleKind == .audiobook
    
    private let durationLabel = createLabelWith(text: "Duration")
//    private let durationButton = createButtonWith(text: "21h 24m", symbolImageName: "clock")
    private let durationButton = createButtonWith(symbolImageName: "clock")

    private lazy var durationVertStack = BookDetailsScrollView.createVertStackWith(label: durationLabel, button: durationButton)
    
    private let languageLabel = createLabelWith(text: "Language")
    private let languageButton = createButtonWith(symbolImageName: nil)

//    private let languageButton = createButtonWith(text: "Spanish", symbolImageName: nil)
    private lazy var languageVertStack = BookDetailsScrollView.createVertStackWith(label: languageLabel, button: languageButton)
    
    private let categoryLabel = createLabelWith(text: "Category")
    
    private let categoryButton: UIButton = {
//        let button = createButtonWith(text: "Teens & Young Adult", symbolImageName: "chevron.forward")
        let button = createButtonWith(symbolImageName: "chevron.forward")
        button.configuration?.imagePlacement = .trailing
        return button
    }()
    
    private lazy var categoryVertStack = BookDetailsScrollView.createVertStackWith(label: categoryLabel, button: categoryButton)
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
//        stack.distribution = .fillProportionally
        stack.spacing = Constants.commonHorzPadding
        return stack
    }()
    
//    private lazy var spacerView: UIView = {
//        let width = (bounds.width - contentSize.width) + 1
//        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 1)))
//        return view
//    }()
    
//    private let xPaddings: CGFloat = 50
    
    private lazy var extraSpacerView: UIView = {
        let view = UIView()
        let width = (bounds.width - contentSize.width) + 1
        view.backgroundColor = .blue

        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 1)))
        return view
    }()
    
//    private lazy var leadingSpacerView: UIView = {
//        let view = UIView()
//        let width = xPaddings / 2
//        view.backgroundColor = .blue
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalToConstant: width).isActive = true
//        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        return view
//    }()
    
//    private lazy var trailingSpacerView: UIView = {
//        let view = UIView()
//        let width = (bounds.width - contentSize.width) + 1
//        view.backgroundColor = .blue
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalToConstant: width).isActive = true
//        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
////        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 1)))
//        return view
//    }()
    
    private lazy var extraSpacerViewIsAdded = false
    
    private var vertBarViews = [UIView]()
    
    private lazy var categoryStackWidthAnchor =         categoryVertStack.widthAnchor.constraint(equalToConstant: categoryButton.bounds.width)
        
    var categoryButtonDidTapCallback: () -> () = {}
    
    private lazy var previousContentSizeCategory = traitCollection.preferredContentSizeCategory
    
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
        
        ratingVertStack.backgroundColor = .orange
        if hasAudio {
            durationVertStack.backgroundColor = .orange
        }
        languageVertStack.backgroundColor = .orange
        categoryVertStack.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("scrollView contentOffset.x \(contentOffset.x)")
        
        print("contentSize.width \(contentSize.width), bounds.width \(bounds.width )")
        if contentSize.width < bounds.width && !extraSpacerViewIsAdded {
            print("adding spacer view")
            // Make scroll view contentSize 1 point wider than scroll view width to ensure that it will be always scrollable
            
//            guard let lastViewInStack = mainStackView.arrangedSubviews.last else { return }
            mainStackView.addArrangedSubview(extraSpacerView)
//            mainStackView.setCustomSpacing(0, after: lastViewInStack)
            extraSpacerViewIsAdded = true

            
//            let difference = (bounds.width - contentSize.width) + 1
//            categoryStackWidthAnchor.constant += difference
//            categoryStackWidthAnchor.isActive = true
        }
        
//        else if contentSize.width > bounds.width && spacerViewIsAdded {
//            print("removing spacer view")
//            spacerView.removeFromSuperview()
//            spacerViewIsAdded = false
//        }
        
        if previousContentSizeCategory != traitCollection.preferredContentSizeCategory {
            previousContentSizeCategory = traitCollection.preferredContentSizeCategory
            
            if contentSize.width > bounds.width && extraSpacerViewIsAdded {
                print("removing spacer view")
                extraSpacerView.removeFromSuperview()
                extraSpacerViewIsAdded = false
            }
//            ratingButton.sizeToFit()
            mainStackView.setNeedsLayout()
            mainStackView.layoutIfNeeded()
            #warning("check if it works without these two lines")
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if contentSize.width < bounds.width {
//            // Make scroll view contentSize 1 point wider than scroll view width to ensure that it will be always scrollable
//            let spacerViewWidth = (bounds.width - contentSize.width) + 1
//            let spacerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: spacerViewWidth, height: 1)))
//            mainStackView.addArrangedSubview(spacerView)
//            spacerView.backgroundColor = .blue
//
////            let difference = (bounds.width - contentSize.width) + 1
////            categoryStackWidthAnchor.constant += difference
////            categoryStackWidthAnchor.isActive = true
//        }
//
//        if previousContentSizeCategory != traitCollection.preferredContentSizeCategory {
//            previousContentSizeCategory = traitCollection.preferredContentSizeCategory
//            setNeedsLayout()
//            layoutIfNeeded()
//        }
//    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.quaternaryLabel.cgColor
        }
        
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            ratingsLabel.font = BookDetailsScrollView.getScaledFontForLabel()
            languageLabel.font = BookDetailsScrollView.getScaledFontForLabel()
            categoryLabel.font = BookDetailsScrollView.getScaledFontForLabel()

            if hasAudio {
                durationLabel.font = BookDetailsScrollView.getScaledFontForLabel()
            }
            
            ratingButton.configuration?.attributedTitle?.font = BookDetailsScrollView.getScaledFontForButton()
            languageButton.configuration?.attributedTitle?.font = BookDetailsScrollView.getScaledFontForButton()
            categoryButton.configuration?.attributedTitle?.font = BookDetailsScrollView.getScaledFontForButton()
            
            if hasAudio {
                durationButton.configuration?.attributedTitle?.font = BookDetailsScrollView.getScaledFontForButton()
            }
        }
    }
    
    // MARK: - Helper methods
    private func configure(button: UIButton, withText text: String) {
        button.configuration?.attributedTitle = AttributedString("\(text)")
        button.configuration?.attributedTitle?.font = BookDetailsScrollView.getScaledFontForButton()
//        button.configuration?.attributedTitle?.font = Utils.navBarTitleFont
//        button.sizeToFit()
    }
    
    private func configureMainStack() {
//        let bookKind = book.titleKind
        
//        let leadingSpacerView = createSpacerView()
//        mainStackView.addArrangedSubview(leadingSpacerView)
//        mainStackView.setCustomSpacing(0, after: leadingSpacerView)
        
        // Configure labels and buttons with text
        ratingsLabel.text = "\(book.reviewsNumber) Ratings"
        ratingsLabel.sizeToFit()
        configure(button: ratingButton, withText: "\(book.rating)")
        
//        if bookKind == .audioBookAndEbook || bookKind == .audiobook {
//            configure(button: durationButton, withText: "\(book.duration)")
//        }
        
        if hasAudio {
            configure(button: durationButton, withText: "\(book.duration)")
        }
        
        configure(button: languageButton, withText: "\(book.language.rawValue)")

        let categoryText = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
        configure(button: categoryButton, withText: categoryText)
        addCategoryButtonAction()
        
        // Add arrangedSubviews
        mainStackView.addArrangedSubview(ratingVertStack)
        let vertBar1 = BookDetailsScrollView.createVertBarView()
        vertBarViews.append(vertBar1)
        mainStackView.addArrangedSubview(vertBar1)
        
        if hasAudio {
            mainStackView.addArrangedSubview(durationVertStack)
            let vertBar2 = BookDetailsScrollView.createVertBarView()
            vertBarViews.append(vertBar2)
            mainStackView.addArrangedSubview(vertBar2)
        }
        
//        if bookKind == .audioBookAndEbook || bookKind == .audiobook {
//            mainStackView.addArrangedSubview(durationStack)
//            let vertBar2 = BookDetailsScrollView.createVertBarView()
//            vertBarViews.append(vertBar2)
//            mainStackView.addArrangedSubview(vertBar2)
//        }
        
        mainStackView.addArrangedSubview(languageVertStack)
        let vertBar3 = BookDetailsScrollView.createVertBarView()
        vertBarViews.append(vertBar3)
        mainStackView.addArrangedSubview(vertBar3)
        
        mainStackView.addArrangedSubview(categoryVertStack)
        mainStackView.setCustomSpacing(0, after: categoryVertStack)
        
//        let trailingSpacerView = createSpacerView()
//        mainStackView.addArrangedSubview(trailingSpacerView)
//        mainStackView.setCustomSpacing(0, after: trailingSpacerView)
    }
    
//    private func createSpacerView() -> UIView {
//        let view = UIView()
//        let width: CGFloat = 25
//        view.backgroundColor = .green
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalToConstant: width).isActive = true
//        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        return view
//    }
    
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
        let extraTopPadding: CGFloat = 20
        let extraBottomPadding: CGFloat = 14
        let extraPaddingsX: CGFloat = 50
//        let extraPaddingsX: CGFloat = 0
        
//        NSLayoutConstraint.activate([
//            mainStackView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: extraTopPadding),
//            mainStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
//            mainStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
//            mainStackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -extraBottomPadding),
//            mainStackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -(extraTopPadding + extraBottomPadding))
//        ])

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: extraTopPadding),
            mainStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: extraPaddingsX / 2.0),
            mainStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -extraPaddingsX / 2),
            mainStackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -extraBottomPadding),
            mainStackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -(extraTopPadding + extraBottomPadding))
        ])
        
        ratingVertStack.translatesAutoresizingMaskIntoConstraints = false
//        let ratingStackWidth = max(ratingsLabel.bounds.width, ratingButton.bounds.width)
        NSLayoutConstraint.activate([
//            ratingVertStack.widthAnchor.constraint(equalToConstant: ratingStackWidth),
            ratingVertStack.topAnchor.constraint(equalTo: ratingsLabel.topAnchor),
            ratingVertStack.bottomAnchor.constraint(equalTo: ratingButton.bottomAnchor)
        ])
        
        if hasAudio {
            durationVertStack.translatesAutoresizingMaskIntoConstraints = false
//            let durationStackWidth = max(durationLabel.bounds.width, durationButton.bounds.width)
            NSLayoutConstraint.activate([
//                durationVertStack.widthAnchor.constraint(equalToConstant: durationStackWidth),
                durationVertStack.topAnchor.constraint(equalTo: durationLabel.topAnchor),
                durationVertStack.bottomAnchor.constraint(equalTo: durationButton.bottomAnchor)
            ])
        }
        
//        if book.titleKind == .audiobook || book.titleKind == .audioBookAndEbook {
//            durationVertStack.translatesAutoresizingMaskIntoConstraints = false
////            let durationStackWidth = max(durationLabel.bounds.width, durationButton.bounds.width)
//            NSLayoutConstraint.activate([
////                durationVertStack.widthAnchor.constraint(equalToConstant: durationStackWidth),
//                durationVertStack.topAnchor.constraint(equalTo: durationLabel.topAnchor),
//                durationVertStack.bottomAnchor.constraint(equalTo: durationButton.bottomAnchor)
//            ])
//        }
        
        languageVertStack.translatesAutoresizingMaskIntoConstraints = false
//        let languageStackWidth = max(languageLabel.bounds.width, languageButton.bounds.width)
        NSLayoutConstraint.activate([
//            languageVertStack.widthAnchor.constraint(equalToConstant: languageStackWidth),
            languageVertStack.topAnchor.constraint(equalTo: languageLabel.topAnchor),
            languageVertStack.bottomAnchor.constraint(equalTo: languageButton.bottomAnchor)
        ])
        
        categoryVertStack.translatesAutoresizingMaskIntoConstraints = false
//        let categoryStackWidth = max(categoryLabel.bounds.width, categoryButton.bounds.width)
        NSLayoutConstraint.activate([
            categoryVertStack.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
            categoryVertStack.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor)
        ])
//        categoryStackWidthAnchor.constant = categoryStackWidth
//        categoryStackWidthAnchor.isActive = true
        
        for vertBarView in vertBarViews {
            vertBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vertBarView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, constant: -6),
                vertBarView.widthAnchor.constraint(equalToConstant: 1)
            ])
        }
    }

}
