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
        label.adjustsFontForContentSizeCategory = true
//        label.textAlignment = .left
        
//        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.backgroundColor = .yellow
//        label.sizeToFit()
        return label
    }

    // WORKING
//    static func createButtonWith(symbolImageName: String?) -> UIButton {
//        let button = UIButton()
//        button.backgroundColor = .orange
//        button.tintColor = .label.withAlphaComponent(0.8)
//        button.titleLabel?.adjustsFontForContentSizeCategory = true
//
//        var buttonConfig = UIButton.Configuration.plain()
//        buttonConfig.contentInsets = .zero
//        buttonConfig.titleAlignment = .leading
//
//
//        if let symbolImageName = symbolImageName {
//            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
//            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
//            buttonConfig.image = image
//            buttonConfig.imagePlacement = .leading
//            buttonConfig.imagePadding = 4
//        }
//
//        buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//            var outgoing = incoming
//            outgoing.font = getScaledFontForButton()
//            return outgoing
//        }
//        buttonConfig.title = "Science fiction"
////        button.titleLabel?.textAlignment = .left
//
//        button.configuration = buttonConfig
//
//        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        button.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
//
////        button.setTitle("Title", for: .normal)
//
////        print("button width: \(button.bounds.width)")
//        return button
//    }
    
    static func createButtonWith(symbolImageName: String?, imagePlacement: NSDirectionalRectEdge = .leading) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .orange
        button.tintColor = .label.withAlphaComponent(0.8)
        button.titleLabel?.adjustsFontForContentSizeCategory = false
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.lineBreakMode = .byTruncatingTail
//        button.titleLabel?.preferredMaxLayoutWidth = CGFloat.greatestFiniteMagnitude
//        button.titleLabel?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        button.titleLabel?.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        button.titleLabel?.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        button.titleLabel?.setContentHuggingPriority(.defaultLow, for: .horizontal)

        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.contentInsets = .zero
        buttonConfig.titleAlignment = .leading

        if let symbolImageName = symbolImageName {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
            let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
            buttonConfig.image = image
//            buttonConfig.imagePlacement = .leading
            buttonConfig.imagePlacement = imagePlacement
            buttonConfig.imagePadding = 4
        }
//        buttonConfig.attributedTitle?.font = getScaledFontForButton()

        buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = getScaledFontForButton()
            return outgoing
        }
//        buttonConfig.title = "Science fiction"
//        button.titleLabel?.textAlignment = .left

        button.configuration = buttonConfig

//        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
//        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        button.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        button.setContentHuggingPriority(.defaultLow, for: .horizontal)

//        button.setTitle("Title", for: .normal)

//        print("button width: \(button.bounds.width)")
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
        private let categoryButton = createButtonWith(symbolImageName: "chevron.forward", imagePlacement: .trailing)
    private lazy var categoryVertStack = createVertStackWith(label: categoryLabel, button: categoryButton)

    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
//        stack.distribution = .fillProportionally
//        stack.distribution = .fill
        stack.spacing = Constants.commonHorzPadding
//        stack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
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

    private lazy var allVertStacks: [UIStackView] = {
        var stacks = [ratingVertStack, languageVertStack, categoryVertStack]
        if hasAudio {
            stacks.append(durationVertStack)
        }
        return stacks
    }()
    
    private var vertStackWidthConstraints = [NSLayoutConstraint]()
//    private var vertStackHeightConstraints = [NSLayoutConstraint]()
    
    var categoryButtonDidTapCallback: () -> () = {}
    private lazy var previousContentSizeCategory = traitCollection.preferredContentSizeCategory
    
//    private var layoutSubviewsIsTriggeredFirstTime = true
    private var needsLayout = false
    
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
        
//        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()

        print("\n\n")
        for (index, stack) in allVertStacks.enumerated() {
            if let label = stack.arrangedSubviews.first, let button = stack.arrangedSubviews.last as? UIButton {
                label.sizeToFit()
//                print("label width \(label.bounds.width), button width \(button.bounds.width)")
//                print("button intrinsic size: \(button.intrinsicContentSize)")
                let width = max(label.bounds.width, button.bounds.width)
//                let width = max(label.bounds.width, button.intrinsicContentSize.width)

                let constraint = vertStackWidthConstraints[index]
                if constraint.constant != width {
                    constraint.constant = width
                    print("new constant set to \(width)")
//                    print("stack width \(stack.bounds.width)")
//                    stack.setNeedsLayout()
//                    stack.layoutIfNeeded()
                    needsLayout = true
//                    setNeedsLayout()
//                    layoutIfNeeded()
                }
                
//                stack.sizeToFit()
//                let firstStackHeight = allVertStacks[0].bounds.size.height
//                for constraint in vertStackHeightConstraints {
//                    if constraint.constant != firstStackHeight{
//                        constraint.constant = firstStackHeight
//                        needsLayout = true
//                    }
//                }

            }
        }

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
            
//            print("\n\n")
//            for (index, stack) in allVertStacks.enumerated() {
//                if let label = stack.arrangedSubviews.first, let button = stack.arrangedSubviews.last as? UIButton {
//                    label.sizeToFit()
//                    print("label width \(label.bounds.width), button width \(button.bounds.width)")
//                    print("button intrinsic size: \(button.intrinsicContentSize.width)")
//                    let width = max(label.bounds.width, button.bounds.width)
//    //                let width = max(label.bounds.width, button.intrinsicContentSize.width)
//
//                    let constraint = vertStackWidthConstraints[index]
//                    if constraint.constant != width {
//                        constraint.constant = width
//                        print("new constant set to \(width)")
//                        print("stack width \(stack.bounds.width)")
//    //                    stack.setNeedsLayout()
//    //                    stack.layoutIfNeeded()
//                        needsLayout = true
//    //                    setNeedsLayout()
//    //                    layoutIfNeeded()
//                    }
//
//                }
//            }
            

        }
        
        if needsLayout {
            needsLayout = false
//            mainStackView.setNeedsLayout()
//            mainStackView.layoutIfNeeded()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.quaternaryLabel.cgColor
        }
        
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
//            for (index, stack) in allVertStacks.enumerated() {
//                if let label = stack.arrangedSubviews.first, let button = stack.arrangedSubviews.last as? UIButton {
//                    label.sizeToFit()
//                    button.sizeToFit()
////                    let buttonWidth = button.titleLabel!.bounds.width
//                    let width = max(label.bounds.width, button.bounds.width)
////                    let width = max(label.bounds.width, buttonWidth)
//
//                    print("max width = \(width)")
//                    if vertStackWidthConstraints[index].constant != width {
//                        vertStackWidthConstraints[index].constant = width
//                        setNeedsLayout()
//                        layoutIfNeeded()
//                    }
//                }
//            }
        }
    }
    
    // MARK: - Helper methods

    private func configure(button: UIButton, withText text: String) {

        var config = button.configuration
        config?.title = text
        button.configuration = config

//        button.configuration?.title = text
//        button.configuration?.attributedTitle = AttributedString("\(text)")
//        button.configuration?.attributedTitle?.font = BookDetailsScrollView.getScaledFontForButton()
//        button.sizeToFit()
//        print("button width: \(button.bounds.width)")
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
        
//        for label in allLabels {
//            label.sizeToFit()
//        }
//
//        for button in allButtons {
//            button.sizeToFit()
//        }
//
//        for stack in allVertStacks {
//            stack.sizeToFit()
//        }
//        mainStackView.sizeToFit()
    }
    
    private func createVertStackWith(label: UILabel, button: UIButton) -> UIStackView {
        label.sizeToFit()
        button.sizeToFit()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
//        stack.distribution = .fill
//        stack.alignment = .center
        #warning("maybe this causes bug")
        stack.spacing = 3
//        stack.addArrangedSubview(button)

        [label, button].forEach { stack.addArrangedSubview($0) }
        
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        stack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
//        stack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        stack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//
//        stack.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        stack.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        stack.sizeToFit()
        stack.backgroundColor = .green
        return stack
    }
    
    private func createVertBarView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
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
        
        for vertBarView in vertBarViews {
            vertBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vertBarView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, constant: -6),
                vertBarView.widthAnchor.constraint(equalToConstant: 1)
            ])
        }
        
//        for stack in allVertStacks {
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            if let label = stack.arrangedSubviews.first as? UILabel, let button = stack.arrangedSubviews.last as? UIButton {
//                label.sizeToFit()
//                button.sizeToFit()
////                print("label \(label.bounds.width), button \(button.bounds.width)")
//                let width = max(label.bounds.width, button.bounds.width)
//
////                let widerView = label.bounds.width > button.bounds.width ? label : button
//
//                let widthConstraint = stack.widthAnchor.constraint(equalToConstant: width)
////                let widthConstraint = stack.widthAnchor.constraint(equalTo: widerView.widthAnchor)
//
////                let height: CGFloat = label.bounds.height + button.bounds.height + 3
////                let heightConstraint = stack.heightAnchor.constraint(equalToConstant: height)
//
//                widthConstraint.isActive = true
//                vertStackWidthConstraints.append(widthConstraint)
//
////                heightConstraint.isActive = true
////                vertStackHeightConstraints.append(heightConstraint)
//            }
//        }
        
//        var stackHeight: CGFloat = 0
        for stack in allVertStacks {
            stack.translatesAutoresizingMaskIntoConstraints = false
            if let label = stack.arrangedSubviews.first as? UILabel, let button = stack.arrangedSubviews.last as? UIButton {
                label.sizeToFit()
                button.sizeToFit()
//                print("label \(label.bounds.width), button \(button.bounds.width)")
                let width = max(label.bounds.width, button.bounds.width)
                let widthConstraint = stack.widthAnchor.constraint(equalToConstant: width)
                widthConstraint.isActive = true
                vertStackWidthConstraints.append(widthConstraint)
                
//                let firstStack = allVertStacks[0]
//                let firstStackHeight = firstStack.bounds.size.height
//                if stack !== firstStack {
//                    let heightConstraint = stack.heightAnchor.constraint(equalToConstant: firstStackHeight)
//                    heightConstraint.isActive = true
//                    vertStackHeightConstraints.append(heightConstraint)
//                }
                
            }
            
        }
    }

}

