//
//  SearchResultsButtonsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 8/3/23.
//

import UIKit

class SearchResultsButtonsView: UIView {
    
    lazy var partOfUnvisiblePart: CGFloat = {
        let scrollViewContentWidth = scrollView.contentSize.width
        let unvisiblePartOfScrollView: CGFloat = scrollViewContentWidth - scrollView.bounds.size.width
        
        // Every time button is tapped, contentOffset.x of scroll view should change to this button's index mupltiplied by this partOfUnvisiblePart, so that if last button is tapped, scroll view's contentOffset.x is the maximum one and fully shows the last button
        let partOfUnvisiblePart: CGFloat = unvisiblePartOfScrollView / CGFloat((scopeButtons.count - 1))
        return partOfUnvisiblePart
    }()
    
    static let viewHeight: CGFloat = 46
    
    private static let buttonKinds: [ButtonKind] = [.top, .books, .authors, .narrators, .series, .tags]
    private static let slidingLineHeight: CGFloat = 2
    
    enum ButtonKind: String {
        case top = "Top"
        case books = "Books"
        case authors = "Authors"
        case narrators = "Narrators"
        case series = "Series"
        case tags = "Tags"
    }
    
    private var firstTime = true
    
    typealias SearchResultsButtonCallback = (_ buttonIndex: Int) -> ()
    var callBack: SearchResultsButtonCallback = {_ in}
    
    let scopeButtons: [UIButton] = {
       var buttons = [UIButton]()
       
        for kind in buttonKinds {
            let button = UIButton()
            var config = UIButton.Configuration.plain()
            
            // Top inset makes visual x-position of button text in stackView as if it's centered
            config.contentInsets = NSDirectionalEdgeInsets(top: SearchResultsButtonsView.slidingLineHeight, leading: Constants.cvPadding, bottom: 0, trailing: Constants.cvPadding)
            config.attributedTitle = AttributedString(kind.rawValue)
            config.attributedTitle?.font = UIFont.preferredCustomFontWith(weight: .medium, size: 16)
            button.configuration = config
            buttons.append(button)
        }
        return buttons
    }()
    
//    lazy var numberOfButtons: Int = {
//        let number = scopeButtons.count
//        return number
//    }()
    
    private let slidingLine: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.tintColor
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let horzStackButtons = UIStackView()
        horzStackButtons.axis = .horizontal
        horzStackButtons.alignment = .center
        horzStackButtons.distribution = .fillProportionally
        scopeButtons.forEach { horzStackButtons.addArrangedSubview($0) }
        
        let horzStackSlidingLine = UIStackView()
        horzStackSlidingLine.axis = .horizontal
        horzStackSlidingLine.alignment = .center
        [UIView(), slidingLine, UIView()].forEach { horzStackSlidingLine.addArrangedSubview($0)}
        
        let vertStack = UIStackView()
        vertStack.axis = .vertical
        vertStack.alignment = .center
        [horzStackButtons, horzStackSlidingLine].forEach { vertStack.addArrangedSubview($0)}
                
        vertStack.backgroundColor = Utils.customBackgroundColor
        return vertStack
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        return scrollView
    }()

    lazy var slidingLineLeadingAnchor = slidingLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
    lazy var slidingLineWidthAnchor = slidingLine.widthAnchor.constraint(equalToConstant: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 0.25
        addButtonActions()
        applyConstraints()
        // Set initial color of buttons' text
        toggleButtonsColors(currentButton: scopeButtons[0])
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
        // Set initial position and size of slidingLine
        adjustSlidingLinePosition(currentButton: scopeButtons[0])  
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
                
                let buttonIndex = self.scopeButtons.firstIndex(of: button)
                guard let buttonIndex = buttonIndex else { return }
                let buttonIndexInt = buttonIndex + 0

                UIView.animate(withDuration: 0.2) {
                    self.toggleButtonsColors(currentButton: button)
                    self.setScrollViewOffsetX(currentButton: button)
                    self.adjustSlidingLinePosition(currentButton: button)

                    self.callBack(buttonIndexInt)
                    
                    // It won't animate without this line
                    self.layoutIfNeeded()
                }
            }), for: .touchUpInside)
        }
    }
    
    private func adjustSlidingLinePosition(currentButton: UIButton) {
        let leadingConstant: CGFloat = currentButton.frame.origin.x
        let width: CGFloat = currentButton.bounds.size.width

        slidingLineLeadingAnchor.constant = leadingConstant
        slidingLineWidthAnchor.constant = width
    }
    
    private func setScrollViewOffsetX(currentButton: UIButton) {
        let scrollViewContentWidth = scrollView.contentSize.width
        let unvisiblePartOfScrollView: CGFloat = scrollViewContentWidth - scrollView.bounds.size.width
        
        // Every time button is tapped, contentOffset.x of scroll view should change to this button's index mupltiplied by this partOfUnvisiblePart, so that if last button is tapped, scroll view's contentOffset.x is the maximum one and fully shows the last button
        let partOfUnvisiblePart: CGFloat = unvisiblePartOfScrollView / CGFloat((scopeButtons.count - 1))

        guard let currentButtonIndex = scopeButtons.firstIndex(of: currentButton) else { return }
        let currentButtonIndexConvertedIntoFloat: CGFloat = CGFloat(currentButtonIndex + 0)
        
        // E.g. If button with index 3 is tapped, then contentOffsetX has to be (3 * partOfUnvisiblePart)
        let newOffsetX = currentButtonIndexConvertedIntoFloat * partOfUnvisiblePart
        scrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
    }
    
    private func toggleButtonsColors(currentButton: UIButton) {
        for button in scopeButtons {
            button.configuration?.attributedTitle?.foregroundColor = UIColor.label
        }
        currentButton.configuration?.attributedTitle?.foregroundColor = Utils.tintColor
    }
    
    func revertToInitialAppearance() {
        let firstButton = scopeButtons[0]
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.toggleButtonsColors(currentButton: firstButton)
        self.adjustSlidingLinePosition(currentButton: firstButton)
    }
    
    func getCurrentButtonIndex() -> Int {
        
        var ranges = [Range<CGFloat>]()

        for button in scopeButtons {
            let range = button.frame.minX..<button.frame.maxX
            ranges.append(range)
        }
        
//        print("ranges: \(ranges)")

        let slidingLineConstant = slidingLineLeadingAnchor.constant
//        let slidingLineConstant = ceil(slidingLineLeadingAnchor.constant)
//        print("slidingLineLeadingConstant: \(slidingLineConstant)")

        var currentButtonIndex: Int = 0
        for (index, range) in ranges.enumerated() {
            if range.contains(slidingLineConstant)  {
                currentButtonIndex = index
                print("slidingLineLeadingConstant is in range \(index)")
            } else {

//                print("slidingLineLeadingConstant out of all ranges")
            }
        }

//        print("     CURRENT BUTTON INDEX: \(currentButtonIndex)")
        return currentButtonIndex
    }
    
//    func getCurrentButtonIndex() -> Int {
//
//        var buttonsPositionsRanges = [Range<CGFloat>]()
//
//        for (index, button) in scopeButtons.enumerated() {
//            var range: Range<CGFloat>
//            if index == 0 {
//                range = 0..<button.bounds.size.width
//            } else if index == scopeButtons.count - 1 {
//                range = bounds.size.width - button.bounds.size.width..<bounds.size.width
//            } else {
//                range = button.frame.origin.x..<(button.frame.origin.x + button.bounds.size.width)
//            }
//
//            buttonsPositionsRanges.append(range)
//        }
//
////        print("ranges: \(buttonsPositionsRanges)")
//
//        let slidingLineConstant = ceil(slidingLineLeadingAnchor.constant)
////        print("slidingLineLeadingConstant: \(slidingLineConstant)")
//
//        var currentButtonIndex: Int = 0
//        for (index, range) in buttonsPositionsRanges.enumerated() {
//            if range.contains(slidingLineConstant)  {
//                currentButtonIndex = index
//                print("slidingLineLeadingConstant is in range \(index)")
//            } else {
////                print("slidingLineLeadingConstant out of all ranges")
//            }
//        }
//
////        print("     CURRENT BUTTON INDEX: \(currentButtonIndex)")
//        return currentButtonIndex
//    }
//
//    func getOriginXOfAllButtons() -> [CGFloat] {
//        var array = [CGFloat]()
//
//        for button in scopeButtons {
//            let originX = button.frame.origin.x
//            array.append(originX)
//        }
//
//        return array
//    }
    
    func getRangesForButtons() -> [Range<CGFloat>] {
        var buttonsPositionsRanges = [Range<CGFloat>]()

        for (index, button) in scopeButtons.enumerated() {
            var range: Range<CGFloat>
            range = button.frame.minX..<button.frame.maxX
            buttonsPositionsRanges.append(range)
        }
        
//        print("ranges: \(buttonsPositionsRanges)")
        return buttonsPositionsRanges
    }
    
        
    private func applyConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor),
            scrollView.frameLayoutGuide.heightAnchor.constraint(equalTo: stackView.heightAnchor)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: SearchResultsButtonsView.viewHeight)
        ])
        
        slidingLine.translatesAutoresizingMaskIntoConstraints = false
        slidingLineLeadingAnchor.isActive = true
        slidingLineWidthAnchor.isActive = true
        slidingLine.heightAnchor.constraint(equalToConstant: SearchResultsButtonsView.slidingLineHeight).isActive = true
        // To force layoutSubviews() apply correct slidingLine anchors' constants
        layoutIfNeeded()
    }
}
