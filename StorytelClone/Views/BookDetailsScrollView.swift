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
        label.font = getScaledFontForLabel()
        label.textColor = .label.withAlphaComponent(0.9)
        label.text = text
        label.textAlignment = .left
//        label.sizeToFit()
        return label
    }
    
    static func createButtonWith(symbolImageName: String?) -> UIButton {
        let button = UIButton()
        button.tintColor = .label.withAlphaComponent(0.8)
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
        if let symbolImageName = symbolImageName {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
            buttonConfig.image = image
            buttonConfig.imagePlacement = .leading
            buttonConfig.imagePadding = 4
        }
        
        button.configuration = buttonConfig
//        button.sizeToFit()
        return button
    }
    
    // MARK: - Instance properties
    private let book: Book
    
    private let ratingsLabel = createLabelWith(text: "80 Ratings")
    private let ratingButton = createButtonWith(symbolImageName: "star.fill")
    private lazy var ratingVertStack = createVertStackWith(label: ratingsLabel, button: ratingButton)
    
    private lazy var hasAudio = book.titleKind == .audioBookAndEbook || book.titleKind == .audiobook
    private let durationLabel = createLabelWith(text: "Duration")
    private let durationButton = createButtonWith(symbolImageName: "clock")
    private lazy var durationVertStack = createVertStackWith(label: durationLabel, button: durationButton)
    
    private let languageLabel = createLabelWith(text: "Language")
    private let languageButton = createButtonWith(symbolImageName: nil)
    private lazy var languageVertStack = createVertStackWith(label: languageLabel, button: languageButton)
    
    private let categoryLabel = createLabelWith(text: "Category")
    
    private let categoryButton: UIButton = {
        let button = createButtonWith(symbolImageName: "chevron.forward")
        button.configuration?.imagePlacement = .trailing
        return button
    }()
    
    private lazy var categoryVertStack = createVertStackWith(label: categoryLabel, button: categoryButton)
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Constants.commonHorzPadding
//        stack.sizeToFit()
        return stack
    }()
    
    private lazy var extraSpacerView: UIView = {
        let view = UIView()
        let width = (bounds.width - contentSize.width) + 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var extraSpacerViewIsAdded = false
    
    private var vertBarViews = [UIView]()
    private lazy var allButtons: [UIButton] = {
        var buttons = [ratingButton, languageButton, categoryButton]
        if hasAudio {
            buttons.append(durationButton)
        }
        return buttons
    }()
    
    private lazy var allLabels: [UILabel] = {
        var labels = [ratingsLabel, languageLabel, categoryLabel]
        if hasAudio {
            labels.append(durationLabel)
        }
        return labels
    }()
    
    private lazy var allVertStacks: [UIStackView] = {
        var stacks = [ratingVertStack, languageVertStack, categoryVertStack]
        if hasAudio {
            stacks.append(durationVertStack)
        }
        return stacks
    }()
    
    var categoryButtonDidTapCallback: () -> () = {}
    private lazy var previousContentSizeCategory = traitCollection.preferredContentSizeCategory
    
    private var layoutSubviewsIsTriggeredFirstTime = true
    
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
    override func layoutSubviews() {
        super.layoutSubviews()
        if layoutSubviewsIsTriggeredFirstTime {
            layoutSubviewsIsTriggeredFirstTime = false
            mainStackView.setNeedsLayout()
            mainStackView.layoutIfNeeded()
        }
         
        for (index, stack) in allVertStacks.enumerated() {
//            stack.sizeToFit()
            print("stack \(index + 1) has width \(stack.bounds.width)")
        }
        print("contentSize.width \(contentSize.width), bounds.width \(bounds.width)")
        
        if contentSize.width < bounds.width && !extraSpacerViewIsAdded {
            print("adding spacer view")
            // Add extraSpacerView to make scroll view contentSize 1 point wider than scroll view width and enable scrolling
            extraSpacerViewIsAdded = true
            mainStackView.addArrangedSubview(extraSpacerView)
        }

        if previousContentSizeCategory != traitCollection.preferredContentSizeCategory {
            previousContentSizeCategory = traitCollection.preferredContentSizeCategory
            
            if contentSize.width > bounds.width && extraSpacerViewIsAdded {
                print("removing spacer view")
                extraSpacerViewIsAdded = false
                extraSpacerView.removeFromSuperview()
            }
//            mainStackView.setNeedsLayout()
//            mainStackView.layoutIfNeeded()
//            setNeedsLayout()
//            layoutIfNeeded()
        }
    }
    
    private func createVertStackWith(label: UILabel, button: UIButton) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        #warning("maybe this causes bug")
        stack.spacing = 3
        [label, button].forEach { stack.addArrangedSubview($0) }
//        stack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stack.sizeToFit()
        return stack
    }
    
    private func createVertBarView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.quaternaryLabel.cgColor
        }
        
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            for label in allLabels {
                label.font = BookDetailsScrollView.getScaledFontForLabel()
            }
            
            for button in allButtons {
                button.configuration?.attributedTitle?.font = BookDetailsScrollView.getScaledFontForButton()
            }
        }
    }
    
    // MARK: - Helper methods
    private func configure(button: UIButton, withText text: String) {
        button.configuration?.attributedTitle = AttributedString("\(text)")
        button.configuration?.attributedTitle?.font = BookDetailsScrollView.getScaledFontForButton()
        button.sizeToFit()
    }
    
    private func configureMainStack() {
        // Configure labels and buttons with text
        ratingsLabel.text = "\(book.reviewsNumber) Ratings"
        configure(button: ratingButton, withText: "\(book.rating)")
 
        if hasAudio {
            configure(button: durationButton, withText: "\(book.duration)")
        }
        
        configure(button: languageButton, withText: "\(book.language.rawValue)")

        let categoryText = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
        configure(button: categoryButton, withText: categoryText)
        addCategoryButtonAction()
        
        // Add arrangedSubviews
        let leadingSpacerViewForPadding = createSpacerViewForPadding()
        mainStackView.addArrangedSubview(leadingSpacerViewForPadding)
        mainStackView.setCustomSpacing(0, after: leadingSpacerViewForPadding)
        
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
        mainStackView.setCustomSpacing(0, after: categoryVertStack)
        
        let trailingSpacerViewForPadding = createSpacerViewForPadding()
        mainStackView.addArrangedSubview(trailingSpacerViewForPadding)
        // Add this to avoid padding between trailingSpacerViewForPadding and extraSpacerView if it's added
        mainStackView.setCustomSpacing(0, after: trailingSpacerViewForPadding)
    }
    
    private func createSpacerViewForPadding() -> UIView {
        let view = UIView()
        view.backgroundColor = .magenta
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
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

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: topPadding),
            mainStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -bottomPadding),
            mainStackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -(topPadding + bottomPadding))
        ])
        
        for stack in allVertStacks {
            stack.backgroundColor = .orange
//            stack.translatesAutoresizingMaskIntoConstraints = false

        }
        
//        for vertStack in allVertStacks {
//            vertStack.backgroundColor = .orange
//            vertStack.translatesAutoresizingMaskIntoConstraints = false
//
//            if let label = vertStack.arrangedSubviews.first as? UILabel, let button = vertStack.arrangedSubviews.last as? UIButton {
//                vertStack.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
//                vertStack.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
//            }
//        }
        
        for vertBarView in vertBarViews {
            vertBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vertBarView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, constant: -6),
                vertBarView.widthAnchor.constraint(equalToConstant: 1)
            ])
        }
        
    }

}
