//
//  ScopeButtonsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 8/3/23.
//

import UIKit

enum ScopeButtonsViewKind {
    case forSearchResultsVc
    case forBookshelfVc
    
    var buttonKinds: [ScopeButtonKind] {
        switch self {
        case .forSearchResultsVc: return ScopeButtonKind.kindsForSearchResults
        case .forBookshelfVc: return ScopeButtonKind.kindsForBookshelf
        }
    }
}

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
    
    static let kindsForSearchResults: [ScopeButtonKind] = [
        .top,
        .books,
        .authors,
        .narrators,
        .series,
        .tags
    ]
    
    static let kindsForBookshelf: [ScopeButtonKind] = [.toRead, .started, .finished, .downloaded]
    
    var sectionHeaderTitle: String {
        switch self {
        case .top: return "Trending searches"
        case .books: return "Trending books"
        case .authors: return "Trending authors"
        case .narrators: return "Trending narrators"
        case .series: return "Trending series"
        case .tags: return "Trending tags"
            
        case .toRead: return "Past 7 days"
        case .started, .finished, .downloaded: return ""
        }
    }
    
    var sectionHeaderPaddingY: CGFloat {
        if ScopeButtonKind.kindsForSearchResults.contains(self) {
            return 30
        }
        return 12
    }
}

class ScopeButtonsView: UIView {
    // MARK: - Instance properties
    lazy var viewHeight = heightForStackWithButtons + slidingLineHeight / 2
    private let heightForStackWithButtons: CGFloat = 44
    private let slidingLineHeight: CGFloat = 3
    
    private let kind: ScopeButtonsViewKind
    let buttonKinds: [ScopeButtonKind]
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.customBackgroundColor
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        [stackView, slidingLine].forEach { scrollView.addSubview($0)}
        return scrollView
    }()
    
    lazy var partOfUnvisiblePartOfScrollView = getPartOfUnvisiblePartOfScrollView()
        
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        buttons.forEach { stack.addArrangedSubview($0) }
        stack.translatesAutoresizingMaskIntoConstraints = false
        let heightConstant = heightForStackWithButtons
        stack.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        return stack
    }()
        
    private lazy var buttons = createButtons()
    var btnDidTapCallback: (_ buttonIndex: Int) -> () = {_ in}
    lazy var buttonsCount = buttons.count
    lazy var rangesOfButtonsXPositions = getRangesOfButtonsXPositions()
    
    private let slidingLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customTintColor
        view.isOpaque = true
        return view
    }()
    
    private var previousSlidingLineCompressedWidth: CGFloat = 0
    private var previousSlidingLineLeadingConstant: CGFloat = 0
    
    lazy var slidingLineLeadingAnchor = slidingLine.leadingAnchor.constraint(
        equalTo: scrollView.contentLayoutGuide.leadingAnchor)
    lazy var slidingLineWidthAnchor = slidingLine.widthAnchor.constraint(equalToConstant: 15)
        
    private var timeLayoutSubviewsIsTriggered = 0
    
    // MARK: - Initializers
    init(kind: ScopeButtonsViewKind) {
        self.kind = kind
        self.buttonKinds = kind.buttonKinds
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLayoutSubviewsIsTriggered += 1
        if timeLayoutSubviewsIsTriggered == 2 {
            // Set initial position and size of sliding line
            adjustSlidingLineXPositionWhenBtnDidTap(currentBtn: buttons[0])
        }
    }
    
    // MARK: - Instance methods
    func respondToScrollInCvWith(pageWidth: CGFloat, currentOffsetX: CGFloat, previousOffsetX: CGFloat) {
        let currentBtnIndex = getCurrentBtnIndex()
        let currentBtn = buttons[currentBtnIndex]
        
        let ranges = rangesOfButtonsXPositions
        let previousBtnUpperBound = currentBtnIndex != 0 ? ranges[currentBtnIndex - 1].upperBound : 0.0
        
        var currentOffsetXInPageWidthRange: CGFloat
        if currentBtnIndex == 0 {
            currentOffsetXInPageWidthRange = currentOffsetX
        } else {
            currentOffsetXInPageWidthRange = currentOffsetX - (CGFloat(currentBtnIndex) * pageWidth)
        }
        
        let currentBtnWidth = currentBtn.bounds.size.width
        let slidingLineXProportionalPart = currentOffsetXInPageWidthRange / pageWidth * currentBtnWidth
        
        let leadingConstant = previousBtnUpperBound + slidingLineXProportionalPart
        
        // Adjust sliding line x position
        slidingLineLeadingAnchor.constant = leadingConstant
        
        adjustScrollViewXPositionWhenCvDidScroll(cvCurrentOffsetX: currentOffsetX, cvPageWidth: pageWidth)
        
        let currentScrollDirection: ScrollDirection = currentOffsetX > previousOffsetX ? .forward : .back
        
        // Toggle buttons' colors
        if currentScrollDirection == .back {
            toggleButtonsColors(currentBtn: currentBtn)
        } else {
            /* Determine current button, because the way of determining currentButton with
             getCurrentBtnIndex() uses half-open range and it doesn't work for this particular case */
            let currentButtonIndex = Int(currentOffsetX / pageWidth)
            let currentButton = buttons[currentButtonIndex]
            toggleButtonsColors(currentBtn: currentButton)
        }
        
        // Adjust sliding line width
        adjustSlidingLineWidth(
            cvCurrentScrollDirection: currentScrollDirection,
            currentBtnIndex: currentBtnIndex,
            slidingLineXProportionalPart: slidingLineXProportionalPart,
            cvCurrentOffsetXInPageWidthRange: currentOffsetXInPageWidthRange,
            cvPageWidth: pageWidth)
    }
    
    func revertToInitialAppearance() {
        let firstButton = buttons[0]
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.toggleButtonsColors(currentBtn: firstButton)
        self.adjustSlidingLineXPositionWhenBtnDidTap(currentBtn: firstButton)
    }
}

// MARK: - Helper methods
extension ScopeButtonsView {
    private func createButtons() -> [UIButton] {
        var buttons = [UIButton]()
        for buttonKind in buttonKinds {
            let button = UIButton()
            var config = UIButton.Configuration.plain()
            // Top inset makes x-position of button text in scrollView visually centered
            config.contentInsets = NSDirectionalEdgeInsets(
                top: slidingLineHeight,
                leading: Constants.commonHorzPadding + 1,
                bottom: 0,
                trailing: Constants.commonHorzPadding + 1)
            
            config.attributedTitle = AttributedString(buttonKind.rawValue)
            let font = UIFont.createStaticFontWith(weight: .medium, size: 16)
            config.attributedTitle?.font = font
            button.configuration = config
            buttons.append(button)
        }
        return buttons
    }
    
    private func configureSelf() {
        addSubview(scrollView)
        addButtonActions()
        applyConstraints()
        // Set initial color of buttons' text
        toggleButtonsColors(currentBtn: buttons[0])
    }
    
    private func addButtonActions() {
        buttons.forEach { btn in
            btn.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                let buttonIndex = self.buttons.firstIndex(of: btn)
                guard let buttonIndex = buttonIndex else { return }
                let buttonIndexInt = buttonIndex + 0
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    self.toggleButtonsColors(currentBtn: btn)
                    self.adjustScrollViewXPositionWhenBtnDidTap(currentBtn: btn)
                    self.adjustSlidingLineXPositionWhenBtnDidTap(currentBtn: btn)
                    self.btnDidTapCallback(buttonIndexInt)
                    self.layoutIfNeeded() // It won't animate without this line
                }
            }), for: .touchUpInside)
        }
    }
    
    private func applyConstraints() {
        let contentG = scrollView.contentLayoutGuide
        let frameG = scrollView.frameLayoutGuide
        let halfSlidingLineHeight = slidingLineHeight / 2
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentG.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -halfSlidingLineHeight),
            stackView.heightAnchor.constraint(equalTo: frameG.heightAnchor, constant: -halfSlidingLineHeight)
        ])
        
        slidingLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slidingLineLeadingAnchor,
            slidingLineWidthAnchor,
            slidingLine.heightAnchor.constraint(equalToConstant: slidingLineHeight),
            slidingLine.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: halfSlidingLineHeight)
        ])
        
        // Force layoutSubviews() to apply correct slidingLine anchors' constants
        layoutIfNeeded()
    }
    
    private func toggleButtonsColors(currentBtn: UIButton) {
        for btn in buttons {
            btn.configuration?.attributedTitle?.foregroundColor = UIColor.label
        }
        currentBtn.configuration?.attributedTitle?.foregroundColor = UIColor.customTintColor
    }
    
    private func adjustScrollViewXPositionWhenBtnDidTap(currentBtn: UIButton) {
        guard let currentBtnIndex = buttons.firstIndex(of: currentBtn) else { return }
        let currentBtnIndexAsFloat: CGFloat = CGFloat(currentBtnIndex + 0)
        
        // E.g. If button with index 3 is tapped, then contentOffsetX has to be (3 * partOfUnvisiblePart)
        let newOffsetX = currentBtnIndexAsFloat * partOfUnvisiblePartOfScrollView
        scrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
    }
    
    private func adjustSlidingLineXPositionWhenBtnDidTap(currentBtn: UIButton) {
        let leadingConstant: CGFloat = currentBtn.frame.origin.x
        let width: CGFloat = currentBtn.bounds.size.width
        slidingLineLeadingAnchor.constant = leadingConstant
        slidingLineWidthAnchor.constant = width
    }
    
    private func getCurrentBtnIndex() -> Int {
        let slidingLineConstant = slidingLineLeadingAnchor.constant
        var currentBtnIndex: Int = 0
        for (index, range) in rangesOfButtonsXPositions.enumerated() {
            if range.contains(slidingLineConstant)  {
                currentBtnIndex = index
                break
            }
        }
        return currentBtnIndex
    }
    
    private func getRangesOfButtonsXPositions() -> [Range<CGFloat>] {
        var ranges = [Range<CGFloat>]()
        for button in buttons {
            /* Excluding maxX, otherwise maxX of the previous button and minX of
             the next buttons will be the same and it won't let determine
             current button using this range later) */
            let range = button.frame.minX..<button.frame.maxX
            ranges.append(range)
        }
        return ranges
    }
    
    private func getPartOfUnvisiblePartOfScrollView() -> CGFloat {
        let scrollViewContentWidth = scrollView.contentSize.width
        let unvisiblePartOfScrollView: CGFloat = scrollViewContentWidth - scrollView.bounds.size.width
        
        /* Every time button is tapped, contentOffset.x of scroll view should change
         to this button's index mupltiplied by this partOfUnvisiblePart, so that
         if last button is tapped, scroll view's contentOffset.x is the maximum one
         and fully shows the last button */
        let partOfUnvisiblePart: CGFloat = unvisiblePartOfScrollView / CGFloat((buttonsCount - 1))
        
        /* If partOfUnvisiblePart == 0 or is less than 0, that means that scrollViewContentWidth is
         less than scrollView width and no adjustments of scrollView's contentOffset.x is needed */
        return partOfUnvisiblePart > 0 ? partOfUnvisiblePart : 0
    }
    
    private func adjustScrollViewXPositionWhenCvDidScroll(
        cvCurrentOffsetX: CGFloat,
        cvPageWidth pageWidth: CGFloat
    ) {
        let scrollViewWidthToMove = partOfUnvisiblePartOfScrollView
        let newOffset = cvCurrentOffsetX / pageWidth * scrollViewWidthToMove
        scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
    }
    
    private func adjustSlidingLineWidth(
        cvCurrentScrollDirection: ScrollDirection,
        currentBtnIndex: Int,
        slidingLineXProportionalPart: CGFloat,
        cvCurrentOffsetXInPageWidthRange: CGFloat,
        cvPageWidth: CGFloat
    ) {
        let currentBtn = buttons[currentBtnIndex]
        let currentBtnWidth = currentBtn.bounds.size.width
        
        // Adjust sliding line width on cv scroll forward when current button is the last one
        if cvCurrentScrollDirection == .forward && currentBtnIndex == buttonsCount - 1 {
            /* Width should decrease for number of points
             the sliding line leading anchor constant is changing */
            let widthConstant = currentBtnWidth - abs(slidingLineXProportionalPart)
            slidingLineWidthAnchor.constant = widthConstant
            
            /* These two values are used later for calculations if scroll direction is .back
             and current button is the last one */
            previousSlidingLineCompressedWidth = widthConstant
            previousSlidingLineLeadingConstant = slidingLineLeadingAnchor.constant
            return
        }
        
        /* Save lastSlidingLineCompressedWidth and previousSlidingLineLeadingConstant in cases
         when previous if-block doesn't do this */
        if currentBtnIndex == buttonsCount - 2 {
            let upperBoundOfCurrentBtn = rangesOfButtonsXPositions[currentBtnIndex].upperBound
            if slidingLineLeadingAnchor.constant == upperBoundOfCurrentBtn {
                let widthConstant = currentBtnWidth - abs(slidingLineXProportionalPart)
                /* Use these two values later for calculations if scroll direction is .back
                 and current button is the last one */
                previousSlidingLineCompressedWidth = widthConstant
                previousSlidingLineLeadingConstant = slidingLineLeadingAnchor.constant
            }
        }
        
        // Adjust sliding line width on cv scroll back when current button is the last one
        if cvCurrentScrollDirection == .back && currentBtnIndex == buttonsCount - 1 {
            let pointsToAdd = previousSlidingLineLeadingConstant - slidingLineLeadingAnchor.constant
            let widthConstant = previousSlidingLineCompressedWidth + abs(pointsToAdd)
            slidingLineWidthAnchor.constant = widthConstant
            return
        }
        
        // Sliding line width needs no adjustments in this case
        if slidingLineLeadingAnchor.constant < 0 { return }
        
        // Adjust sliding line width for other cases
        var previousWidth: CGFloat
        var nextWidth: CGFloat
        if cvCurrentScrollDirection == .forward {
            previousWidth = currentBtnWidth
            nextWidth = buttons[currentBtnIndex + 1].bounds.size.width
        } else {
            previousWidth = buttons[currentBtnIndex + 1].bounds.width
            nextWidth = currentBtnWidth
        }
        
        /* Number of points to add/substract to/from previousWidth to obtain the next width */
        let widthToAddOrSubstract = previousWidth - nextWidth
        
        var widthProportionalPart: CGFloat
        if cvCurrentScrollDirection == .forward {
            widthProportionalPart = abs(cvCurrentOffsetXInPageWidthRange / cvPageWidth * widthToAddOrSubstract)
        } else {
            let difference = cvPageWidth - cvCurrentOffsetXInPageWidthRange
            widthProportionalPart = abs(difference / cvPageWidth * widthToAddOrSubstract)
        }
        
        var widthConstant: CGFloat
        if nextWidth > previousWidth {
            widthConstant = previousWidth + widthProportionalPart
        } else {
            widthConstant = previousWidth - widthProportionalPart
        }
        
        slidingLineWidthAnchor.constant = widthConstant
    }
}
