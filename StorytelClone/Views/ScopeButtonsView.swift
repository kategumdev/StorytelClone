//
//  SearchResultsButtonsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 8/3/23.
//

import UIKit

enum ScopeButtonKind: String, CaseIterable {
    case top = "Top"
    case books = "Books"
    case authors = "Authors"
    case narrators = "Narrators"
    case series = "Series"
    case tags = "Tags"
    case toRead = "To read"
    case started = "Started"
    case finished = "Finished"
    case downloaded = "Downloaded"
    
    static let kindsForSearchResults: [ScopeButtonKind] = [.top, .books, .authors, .narrators, .series, .tags]
    
    static let kindsForBookshelf: [ScopeButtonKind] = [.toRead, .started, .finished, .downloaded]
    
    static func getSectionHeaderTitleFor(kind: ScopeButtonKind) -> String {
        switch kind {
        case .top: return "Trending searches"
        case .books: return "Trending books"
        case .authors: return "Trending authors"
        case .narrators: return "Trending narrators"
        case .series: return "Trending series"
        case .tags: return "Trending tags"
        case .toRead: return "Past 7 days"
        case .started: return ""
        case .finished: return ""
        case .downloaded: return ""
        }
    }
}

class ScopeButtonsView: UIView {
    // MARK: - Static properties
    private static let slidingLineHeight: CGFloat = 3
    private static let heightForStackWithButtons: CGFloat = 44 // Button height is less, extra points here are added for top and bottom paddings
    static let viewHeight = heightForStackWithButtons + slidingLineHeight / 2


    // MARK: - Instance properties
//    let buttonKinds: [ScopeButtonKind] = ScopeButtonKind.allCases
    var buttonKinds = [ScopeButtonKind]()
    
    lazy var partOfUnvisiblePartOfScrollView: CGFloat = {
        let scrollViewContentWidth = scrollView.contentSize.width
        let unvisiblePartOfScrollView: CGFloat = scrollViewContentWidth - scrollView.bounds.size.width
        
        // Every time button is tapped, contentOffset.x of scroll view should change to this button's index mupltiplied by this partOfUnvisiblePart, so that if last button is tapped, scroll view's contentOffset.x is the maximum one and fully shows the last button
        let partOfUnvisiblePart: CGFloat = unvisiblePartOfScrollView / CGFloat((scopeButtons.count - 1))
        print("partOfUnvisiblePart: \(partOfUnvisiblePart)")
        return partOfUnvisiblePart > 0 ? partOfUnvisiblePart : 0 // If partOfUnvisiblePart == 0 or is less than 0, that means that scrollViewContentWidth is less than scrollView width and no adjustments of scrollView's contentOffset.x is needed
    }()
    
//    lazy var partOfUnvisiblePartOfScrollView: CGFloat = {
//        let scrollViewContentWidth = scrollView.contentSize.width
//        let unvisiblePartOfScrollView: CGFloat = scrollViewContentWidth - scrollView.bounds.size.width
//
//        // Every time button is tapped, contentOffset.x of scroll view should change to this button's index mupltiplied by this partOfUnvisiblePart, so that if last button is tapped, scroll view's contentOffset.x is the maximum one and fully shows the last button
//        let partOfUnvisiblePart: CGFloat = unvisiblePartOfScrollView / CGFloat((scopeButtons.count - 1))
//        print("partOfUnvisiblePart: \(partOfUnvisiblePart)")
//        return partOfUnvisiblePart
//    }()
    
    private var firstTime = true
    
    var scopeButtonDidTapCallback: (_ buttonIndex: Int) -> () = {_ in}
    
    lazy var scopeButtons: [UIButton] = {
       var buttons = [UIButton]()
        for kind in buttonKinds {
            let button = UIButton()
            var config = UIButton.Configuration.plain()

            // Top inset makes visual x-position of button text in scrollView as if it's centered
//            config.contentInsets = NSDirectionalEdgeInsets(top: ScopeButtonsView.slidingLineHeight, leading: Constants.commonHorzPadding, bottom: 0, trailing: Constants.commonHorzPadding)
            config.contentInsets = NSDirectionalEdgeInsets(top: ScopeButtonsView.slidingLineHeight, leading: Constants.commonHorzPadding + 1, bottom: 0, trailing: Constants.commonHorzPadding + 1)

            config.attributedTitle = AttributedString(kind.rawValue)
            config.attributedTitle?.font = UIFont.preferredCustomFontWith(weight: .medium, size: 16)
            button.configuration = config
                    
            buttons.append(button)
        }
        return buttons
    }()
    
    // Ranges of buttons' bounds (excluding maxX, otherwise maxX of previous button and minX of next buttons will be the same and it doesn't let to correctly determine currentButton)
    lazy var rangesOfButtons: [Range<CGFloat>] = {
        var ranges = [Range<CGFloat>]()
        for button in scopeButtons {
            let range = button.frame.minX..<button.frame.maxX
            ranges.append(range)
        }
        return ranges
    }()
    
    private let slidingLine: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.tintColor
        view.isOpaque = true
        return view
    }()
    
    private var lastSlidingLineCompressedWidth: CGFloat = 0
    private var previousSlidingLineLeadingConstant: CGFloat = 0
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        scopeButtons.forEach { stack.addArrangedSubview($0) }
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: ScopeButtonsView.heightForStackWithButtons).isActive = true
        return stack
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = Utils.customBackgroundColor
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.addSubview(stackView)
        scrollView.addSubview(slidingLine)
        return scrollView
    }()

    lazy var slidingLineLeadingAnchor = slidingLine.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
    lazy var slidingLineWidthAnchor = slidingLine.widthAnchor.constraint(equalToConstant: 15)
    
    // MARK: - Initializers
    init(withButtonKinds buttonKinds: [ScopeButtonKind]) {
        self.buttonKinds = buttonKinds
        super.init(frame: .zero)
        addSubview(scrollView)
        addButtonActions()
        applyConstraints()
        // Set initial color of buttons' text
        toggleButtonsColors(currentButton: scopeButtons[0])
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(scrollView)
//        addButtonActions()
//        applyConstraints()
//        // Set initial color of buttons' text
//        toggleButtonsColors(currentButton: scopeButtons[0])
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstTime == false else {
            firstTime = false
            return
        }
        // Set initial position and size of slidingLine
        adjustSlidingLinePosition(currentButton: scopeButtons[0])  
    }
    
    // MARK: - Instance methods
    func getCurrentButtonIndex() -> Int {
        let slidingLineConstant = slidingLineLeadingAnchor.constant
        var currentButtonIndex: Int = 0
        for (index, range) in rangesOfButtons.enumerated() {
            if range.contains(slidingLineConstant)  {
                currentButtonIndex = index
//                print("slidingLineLeadingConstant is in range \(index)")
                break
            }
        }
        return currentButtonIndex
    }
    
    // Use it in SearchResultsViewController in didScroll
    func adjustScrollViewOffsetX(currentOffsetXOfCollectionView: CGFloat, withPageWidth pageWidth: CGFloat) {
        let scrollViewWidthToMove = partOfUnvisiblePartOfScrollView
        let newOffset = currentOffsetXOfCollectionView / pageWidth * scrollViewWidthToMove
        scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
    }
    
    // Use it in SearchResultsViewController in didScroll
    func adjustSlidingLineWidthWhen(currentScrollDirectionOfCv: ScrollDirection, currentButtonIndex: Int, slidingLineXProportionalPart: CGFloat, currentOffsetXOfCvInRangeOfOnePageWidth: CGFloat, pageWidthOfCv pageWidth: CGFloat) {

        let currentButton = scopeButtons[currentButtonIndex]
        let currentButtonWidth = currentButton.bounds.size.width
        
    // Logic for adjusting sliding line width when current button is the last one
        if currentScrollDirectionOfCv == .forward && currentButtonIndex == scopeButtons.count - 1 {
            // Width should decrease for number of points the sliding line leading anchor constant is changing
            let widthConstant = currentButtonWidth - abs(slidingLineXProportionalPart)
            slidingLineWidthAnchor.constant = widthConstant

            // Use these two values later for calculations when scroll direction is .back and current button is the last one
            lastSlidingLineCompressedWidth = widthConstant
            previousSlidingLineLeadingConstant = slidingLineLeadingAnchor.constant
            return
        }
        
        // Save lastSlidingLineCompressedWidth and previousSlidingLineLeadingConstant, because there are cases when previous if-block doesn't do this
        if currentButtonIndex == scopeButtons.count - 2 {
            let upperBoundOfCurrentButton = rangesOfButtons[currentButtonIndex].upperBound
            if slidingLineLeadingAnchor.constant == upperBoundOfCurrentButton {
                let widthConstant = currentButtonWidth - abs(slidingLineXProportionalPart)
                // Use these two values later for calculations when scroll direction is .back and current button is the last one
                lastSlidingLineCompressedWidth = widthConstant
                previousSlidingLineLeadingConstant = slidingLineLeadingAnchor.constant
            }
        }
        
        if currentScrollDirectionOfCv == .back && currentButtonIndex == scopeButtons.count - 1 {
            let pointsToAdd = previousSlidingLineLeadingConstant - slidingLineLeadingAnchor.constant
            let widthConstant = lastSlidingLineCompressedWidth + abs(pointsToAdd)
            slidingLineWidthAnchor.constant = widthConstant
            return
        }
        
        // slidingLine width needs no adjustments in this case
        if slidingLineLeadingAnchor.constant < 0 {
            return
        }
        
    // Logic for adjusting sliding line width for other cases
        
        // Determine width the sliding line should gradually change to
        var previousWidth: CGFloat
        var nextWidth: CGFloat
        if currentScrollDirectionOfCv == .forward {
            previousWidth = currentButtonWidth
            nextWidth = scopeButtons[currentButtonIndex + 1].bounds.size.width
        } else {
            previousWidth = scopeButtons[currentButtonIndex + 1].bounds.width
            nextWidth = currentButtonWidth
        }

        // Determine for how many points previous sliding line width should change to obtain the next width
        let widthToAddOrSubstract = previousWidth - nextWidth

        var widthProportionalPart: CGFloat
        if currentScrollDirectionOfCv == .forward {
            widthProportionalPart = abs(currentOffsetXOfCvInRangeOfOnePageWidth / pageWidth * widthToAddOrSubstract)
        } else {
            let difference = pageWidth - currentOffsetXOfCvInRangeOfOnePageWidth
            widthProportionalPart = abs(difference / pageWidth * widthToAddOrSubstract)
        }
        
        let widthConstant = nextWidth > previousWidth ? previousWidth + widthProportionalPart : previousWidth - widthProportionalPart

        slidingLineWidthAnchor.constant = widthConstant
    }
    
    func toggleButtonsColors(currentButton: UIButton) {
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
    
    // MARK: - Helper methods
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
                    self.scopeButtonDidTapCallback(buttonIndexInt)
                    self.layoutIfNeeded() // It won't animate without this line
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
//        let scrollViewContentWidth = scrollView.contentSize.width
//        let unvisiblePartOfScrollView: CGFloat = scrollViewContentWidth - scrollView.bounds.size.width
//
//        // Every time button is tapped, contentOffset.x of scroll view should change to this button's index mupltiplied by this partOfUnvisiblePart, so that if last button is tapped, scroll view's contentOffset.x is the maximum one and fully shows the last button
//        let partOfUnvisiblePart: CGFloat = unvisiblePartOfScrollView / CGFloat((scopeButtons.count - 1))

        guard let currentButtonIndex = scopeButtons.firstIndex(of: currentButton) else { return }
        let currentButtonIndexConvertedIntoFloat: CGFloat = CGFloat(currentButtonIndex + 0)
        
        // E.g. If button with index 3 is tapped, then contentOffsetX has to be (3 * partOfUnvisiblePart)
//        let newOffsetX = currentButtonIndexConvertedIntoFloat * partOfUnvisiblePart
        let newOffsetX = currentButtonIndexConvertedIntoFloat * partOfUnvisiblePartOfScrollView
        scrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
    }
    
//    private func setScrollViewOffsetX(currentButton: UIButton) {
//        let scrollViewContentWidth = scrollView.contentSize.width
//        let unvisiblePartOfScrollView: CGFloat = scrollViewContentWidth - scrollView.bounds.size.width
//
//        // Every time button is tapped, contentOffset.x of scroll view should change to this button's index mupltiplied by this partOfUnvisiblePart, so that if last button is tapped, scroll view's contentOffset.x is the maximum one and fully shows the last button
//        let partOfUnvisiblePart: CGFloat = unvisiblePartOfScrollView / CGFloat((scopeButtons.count - 1))
//
//        guard let currentButtonIndex = scopeButtons.firstIndex(of: currentButton) else { return }
//        let currentButtonIndexConvertedIntoFloat: CGFloat = CGFloat(currentButtonIndex + 0)
//
//        // E.g. If button with index 3 is tapped, then contentOffsetX has to be (3 * partOfUnvisiblePart)
//        let newOffsetX = currentButtonIndexConvertedIntoFloat * partOfUnvisiblePart
//        scrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
//    }
    
    private func applyConstraints() {
        let contentG = scrollView.contentLayoutGuide
        let frameG = scrollView.frameLayoutGuide
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: ScopeButtonsView.viewHeight)
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentG.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -ScopeButtonsView.slidingLineHeight / 2),
            stackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -ScopeButtonsView.slidingLineHeight / 2)
        ])

        slidingLine.translatesAutoresizingMaskIntoConstraints = false
        slidingLineLeadingAnchor.isActive = true
        slidingLineWidthAnchor.isActive = true
        slidingLine.heightAnchor.constraint(equalToConstant: ScopeButtonsView.slidingLineHeight).isActive = true
        slidingLine.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: ScopeButtonsView.slidingLineHeight / 2).isActive = true
        
        // To force layoutSubviews() to apply correct slidingLine anchors' constants
        layoutIfNeeded()
    }
    
}
