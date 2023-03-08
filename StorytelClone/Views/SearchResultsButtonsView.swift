//
//  SearchResultsButtonsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 8/3/23.
//

import UIKit

class SearchResultsButtonsView: UIView {

    private static let buttonKinds: [ButtonKind] = [.top, .books, .authors, .narrators, .series, .tags]
    
    private static let spacingBetweenButtons: CGFloat = 32
    
    enum ButtonKind: String {
        case top = "Top"
        case books = "Books"
        case authors = "Authors"
        case narrators = "Narrators"
        case series = "Series"
        case tags = "Tags"
    }
    
    private var firstTime = true
    
    private var currentButton: UIButton?
    
    private let scopeButtons: [UIButton] = {
       var buttons = [UIButton]()
       
        for kind in buttonKinds {
            let button = UIButton()
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.cvPadding, bottom: 0, trailing: Constants.cvPadding)
            config.attributedTitle = AttributedString(kind.rawValue)
            config.attributedTitle?.font = UIFont.preferredCustomFontWith(weight: .medium, size: 16)
            if kind == .top {
                config.attributedTitle?.foregroundColor = Utils.tintColor
            } else {
                config.attributedTitle?.foregroundColor = UIColor.label
            }
            button.configuration = config
            
//            button.addAction(UIAction(handler: {_ in
//
//                print("Button \(kind.rawValue) tapped")
//
//            }), for: .touchUpInside)
            
            buttons.append(button)
        }
        return buttons
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        scopeButtons.forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.contentInset = UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
        scrollView.addSubview(stackView)
        return scrollView
    }()
    
    let slidingLine: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.tintColor
        return view
    }()
    
    lazy var slidingLineLeadingAnchor = slidingLine.leadingAnchor.constraint(equalTo: leadingAnchor)
    lazy var slidingLineWidthAnchor = slidingLine.widthAnchor.constraint(equalToConstant: 15)
//    lazy var slidingLineTrailingAnchor = slidingLine.trailingAnchor.constraint(equalTo: leadingAnchor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        
        addSubview(slidingLine)
//        scrollView.addSubview(slidingLine)
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 0.25
        currentButton = scopeButtons[0]
        addButtonActions()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard firstTime == false else {
            firstTime = false
            return
        }
        
        adjustSlidingLinePosition()
        
//        if let currentButton = currentButton {
//            let leadingConstant: CGFloat = currentButton.frame.origin.x
//            let trailingConstant: CGFloat = leadingConstant + currentButton.bounds.size.width
//
//            slidingLineLeadingAnchor.constant = leadingConstant
//            slidingLineTrailingAnchor.constant = trailingConstant
//        }
        
        print("in view buttonsView size: \(bounds.size)")
        print("in view scrollView size: \(scrollView.bounds.size)")
        print("in view stackView size: \(stackView.bounds.size)")
        print("in view button size: \(scopeButtons[0].bounds.size)")
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.label.cgColor
        }
    }
    
    private func addButtonActions() {
        
        for button in scopeButtons {
            button.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                
                self.currentButton = button
                
                UIView.animate(withDuration: 0.2) {
                    self.setScrollViewOffsetX()
                    
                    self.adjustSlidingLinePosition()

                    // It won't animate without this line
                    self.layoutIfNeeded()
                }
                
                print("Button \(String(describing: button.titleLabel?.text)) tapped")

            }), for: .touchUpInside)
        }
    }
    
    private func adjustSlidingLinePosition() {
        if let currentButton = currentButton {
            let leadingConstant: CGFloat = currentButton.frame.origin.x
            let width: CGFloat = currentButton.bounds.size.width
//            let trailingConstant: CGFloat = leadingConstant + currentButton.bounds.size.width

            slidingLineLeadingAnchor.constant = leadingConstant
            slidingLineWidthAnchor.constant = width
            
//            slidingLineTrailingAnchor.constant = trailingConstant
        }
    }
    
    private func setScrollViewOffsetX() {
        
//        guard let scrollViewContentWidth = scrollView.contentSize.width, let currentButton = currentButton else { return }
        let scrollViewContentWidth = scrollView.contentSize.width
        let unvisiblePartOfScrollView: CGFloat = scrollViewContentWidth - scrollView.bounds.size.width
        print("unvisible part: \(unvisiblePartOfScrollView)")
        
        let oneButtonOffsetX: CGFloat = unvisiblePartOfScrollView / CGFloat((scopeButtons.count - 1))
        
        guard let currentButton = currentButton, let currentButtonIndex = scopeButtons.firstIndex(of: currentButton) else { return }
        
        let currentButtonPositionNumber: CGFloat = CGFloat(currentButtonIndex + 0)
        
//        let currentButtonIndex = scopeButtons.firstIndex(of: currentButton) + 1
        if currentButtonIndex != 0 {
            let currentOffsetX = scrollView.contentOffset.x
            let newOffsetX = currentOffsetX + (oneButtonOffsetX * currentButtonPositionNumber)
            scrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
            print("setContentOffset")
        }
        
    }
    
    private func applyConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
//            stackView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
//
//            stackView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        slidingLine.translatesAutoresizingMaskIntoConstraints = false
        slidingLineLeadingAnchor.isActive = true
        
        slidingLineWidthAnchor.isActive = true

//        slidingLineTrailingAnchor.isActive = true
        slidingLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        slidingLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // To force layoutSubviews() apply correct slidingLine anchors' constants
        layoutIfNeeded()
    }
}
