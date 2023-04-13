//
//  SectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/2/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Static properties and methods
    static let identifier = "SectionHeaderView"
    
//    static func calculateEstimatedHeightFor(section: TableSection, superviewWidth: CGFloat) -> CGFloat {
//        let sectionKind = section.sectionKind
//
//        var seeAllButtonWidth: CGFloat
//        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
//            seeAllButtonWidth = 0
//        } else {
//            let button = createSeeAllButton()
//            button.sizeToFit()
//            seeAllButtonWidth = button.bounds.width
//        }
//
//        let availableWidthForLabels = superviewWidth - (seeAllButtonWidth + paddingBetweenLabelAndButton + Constants.cvPadding * 2)
//
//        var subtitleHeight: CGFloat
//        if section.sectionSubtitle.isEmpty {
//            subtitleHeight = 0
//        } else {
//            let subtitleLabel = createSectionSubtitleLabel()
//            subtitleLabel.text = section.sectionSubtitle
//            subtitleHeight = subtitleLabel.sizeThatFits(CGSize(width: availableWidthForLabels, height: CGFloat.greatestFiniteMagnitude)).height
//        }
//
//        let subtitleHeightPlusSpacing = subtitleHeight + paddingBetweenLabels
//
//        let titleLabel = createSectionTitleLabel()
//        titleLabel.text = section.sectionTitle
//        let titleLabelHeight = titleLabel.sizeThatFits(CGSize(width: availableWidthForLabels, height: CGFloat.greatestFiniteMagnitude)).height
//
//        let estimatedHeight = titleLabelHeight + subtitleHeightPlusSpacing + Constants.generalTopPaddingSectionHeader
//
//        return estimatedHeight
//    }
    
    static func calculateEstimatedHeightFor(section: TableSection, superviewWidth: CGFloat) -> CGFloat {
        let headerContainer = SectionHeaderSubviewsContainer()
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true
        
        headerContainer.configureFor(section: section)
        let height = headerContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//
//        let height = headerContainer.sizeThatFits(CGSize(width: superviewWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
//        print("CALCULATED HEIGHT IS: \(height)")
        return height
    }

    // MARK: - Instance properties
    private let containerWithSubviews = SectionHeaderSubviewsContainer()
    
    var seeAllButtonDidTapCallback: SeeAllButtonDidTapCallback = {} {
        didSet {
            containerWithSubviews.callback = seeAllButtonDidTapCallback
        }
    }
    
    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerWithSubviews)
        containerWithSubviews.translatesAutoresizingMaskIntoConstraints = false
        containerWithSubviews.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(section: TableSection) {
        containerWithSubviews.configureFor(section: section)
    }
    
}
















//class SectionHeaderView: UITableViewHeaderFooterView {
//
//    // MARK: - Static properties and methods
//    static let identifier = "SectionHeaderView"
//
////    static func calculateEstimatedHeightFor(section: TableSection, superviewWidth: CGFloat) -> CGFloat {
////        let sectionKind = section.sectionKind
////
////        var seeAllButtonWidth: CGFloat
////        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
////            seeAllButtonWidth = 0
////        } else {
////            let button = createSeeAllButton()
////            button.sizeToFit()
////            seeAllButtonWidth = button.bounds.width
////        }
////
////        let availableWidthForLabels = superviewWidth - (seeAllButtonWidth + paddingBetweenLabelAndButton + Constants.cvPadding * 2)
////
////        var subtitleHeight: CGFloat
////        if section.sectionSubtitle.isEmpty {
////            subtitleHeight = 0
////        } else {
////            let subtitleLabel = createSectionSubtitleLabel()
////            subtitleLabel.text = section.sectionSubtitle
////            subtitleHeight = subtitleLabel.sizeThatFits(CGSize(width: availableWidthForLabels, height: CGFloat.greatestFiniteMagnitude)).height
////        }
////
////        let subtitleHeightPlusSpacing = subtitleHeight + paddingBetweenLabels
////
////        let titleLabel = createSectionTitleLabel()
////        titleLabel.text = section.sectionTitle
////        let titleLabelHeight = titleLabel.sizeThatFits(CGSize(width: availableWidthForLabels, height: CGFloat.greatestFiniteMagnitude)).height
////
////        let estimatedHeight = titleLabelHeight + subtitleHeightPlusSpacing + Constants.generalTopPaddingSectionHeader
////
////        return estimatedHeight
////    }
//
//
//
//
//
////    static func calculateEstimatedHeightFor(section: TableSection, superviewWidth: CGFloat) -> CGFloat {
////        // Create view that will act as contentView of SectionHeaderView
////        let view = UIView()
////        view.translatesAutoresizingMaskIntoConstraints = false
////        view.widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true
////
////        let titleLabel = createSectionTitleLabel()
////        let subtitleLabel = createSectionSubtitleLabel()
////
////        let vertStackWithLabels = createVertStackForLabels()
////        vertStackWithLabels.addArrangedSubview(titleLabel)
////        vertStackWithLabels.addArrangedSubview(subtitleLabel)
////
////        let seeAllButton = createSeeAllButton()
////        let vertStackWithButton = createVertStackForButton()
////        vertStackWithButton.addArrangedSubview(seeAllButton)
////
////        let horzStack = createHorzStack()
////        horzStack.addArrangedSubview(vertStackWithLabels)
////        horzStack.addArrangedSubview(vertStackWithButton)
////
////        let container = UIView()
////        container.addSubview(horzStack)
////
////
////
////    }
//
//    static func calculateEstimatedHeightFor(section: TableSection, superviewWidth: CGFloat) -> CGFloat {
//        let headerView = SectionHeaderView()
//        headerView.configureFor(section: section)
//
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true
//        view.addSubview(headerView.container)
//        let height = view.bounds.height
//
////        print("superviewWidth: \(superviewWidth)")
////        print("container size: \(headerView.container.bounds.size)")
////        let height = headerView.container.sizeThatFits(CGSize(width: superviewWidth, height: CGFloat.greatestFiniteMagnitude)).height
////
//////        let height = headerView.sizeThatFits(CGSize(width: superviewWidth, height: CGFloat.greatestFiniteMagnitude)).height
//        print("CALCULATED HEIGHT IS: \(height)")
//        return height
//    }
//
//    private static func createSectionTitleLabel() -> UILabel {
//        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
//        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        return label
//    }
//
//    private static func createSectionSubtitleLabel() -> UILabel {
//        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
//        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        return label
//    }
//
////    private static func createVertStackWithLabels() -> UIStackView {
////        let titleLabel = createSectionTitleLabel()
////
////        let stack = UIStackView()
////        stack.axis = .vertical
////        stack.alignment = .leading
////        stack.spacing = SectionHeaderView.paddingBetweenLabels
//////        stack.addArrangedSubview(sectionTitleLabel)
//////        stack.addArrangedSubview(sectionSubtitleLabel)
////        return stack
////    }
//
//    private static let paddingBetweenLabelAndButton: CGFloat = 20
//    private static let seeAllButtonTitle = "See all"
//    private static let paddingBetweenLabels: CGFloat = 1
//
//    private static func createSeeAllButton() -> UIButton {
//        let button = UIButton()
//        button.setTitle(seeAllButtonTitle, for: .normal)
////        button.titleLabel?.lineBreakMode = .byTruncatingTail
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
//        button.titleLabel?.font = scaledFont
//        button.contentHorizontalAlignment = .right
//        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
////        button.titleLabel?.adjustsFontForContentSizeCategory = true
//        return button
//    }
//
//    private static func createVertStackForLabels() -> UIStackView {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.alignment = .leading
//        stack.spacing = paddingBetweenLabels
//        return stack
//    }
//
//    private static func createVertStackForButton() -> UIStackView {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.alignment = .trailing
//        return stack
//    }
//
//    private static func createHorzStack() -> UIStackView {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.alignment = .center
//        stack.spacing = paddingBetweenLabelAndButton
//        return stack
//    }
//
//
////    private static func calculateSeeAllButtonWidth() -> CGFloat {
////        let button = createSeeAllButton()
////        button.sizeToFit()
////        return button.bounds.size.width
////    }
//
//    // MARK: - Instance properties
////    var tableSection: TableSection?
////    private var withButton = true
////
////    let sectionTitleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
////    let sectionSubtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
//
//    let sectionTitleLabel = createSectionTitleLabel()
//    let sectionSubtitleLabel = createSectionSubtitleLabel()
//
//    private lazy var seeAllButton = SectionHeaderView.createSeeAllButton()
//
//    private lazy var seeAllButtonWidthAnchorConstraint = seeAllButton.widthAnchor.constraint(equalToConstant: 0)
//
//    private lazy var vertStackWithLabels: UIStackView = {
//        let stack = SectionHeaderView.createVertStackForLabels()
//        stack.addArrangedSubview(sectionTitleLabel)
//        stack.addArrangedSubview(sectionSubtitleLabel)
//        return stack
//    }()
//
//    private lazy var vertStackWithButton: UIStackView = {
//        let stack = SectionHeaderView.createVertStackForButton()
//        stack.addArrangedSubview(UIView())
//        stack.addArrangedSubview(seeAllButton)
//        seeAllButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        return stack
//    }()
//
//    private lazy var horzStackView: UIStackView = {
//        let stack = SectionHeaderView.createHorzStack()
//        stack.addArrangedSubview(vertStackWithLabels)
//        stack.addArrangedSubview(vertStackWithButton)
//        return stack
//    }()
//
////    private lazy var vertStackWithLabels: UIStackView = {
////        let stack = UIStackView()
////        stack.axis = .vertical
////        stack.alignment = .leading
////        stack.spacing = SectionHeaderView.paddingBetweenLabels
////        stack.addArrangedSubview(sectionTitleLabel)
////        stack.addArrangedSubview(sectionSubtitleLabel)
////        return stack
////    }()
////
////    private lazy var vertStackWithButton: UIStackView = {
////        let stack = UIStackView()
////        stack.axis = .vertical
////        stack.alignment = .trailing
////        stack.addArrangedSubview(UIView())
////        stack.addArrangedSubview(seeAllButton)
////        seeAllButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
////        return stack
////    }()
////
////    private lazy var horzStackView: UIStackView = {
////        let stack = UIStackView()
////        stack.axis = .horizontal
////        stack.alignment = .center
////        stack.spacing = SectionHeaderView.paddingBetweenLabelAndButton
////        stack.addArrangedSubview(vertStackWithLabels)
////        stack.addArrangedSubview(vertStackWithButton)
////        return stack
////    }()
//
//    private lazy var container: UIView = {
//        let view = UIView()
//        view.addSubview(horzStackView)
//        return view
//    }()
//
//    // Closure to tell owning controller to push new vc
////    typealias SeeAllButtonCallbackClosure = (_ tableSection: TableSection) -> ()
////    var callback: SeeAllButtonCallbackClosure = {_ in}
//    var seeAllButtonDidTapCallback: () -> () = {}
//
//    // MARK: - Initializers
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
////        contentView.addSubview(horzStackView)
//        contentView.addSubview(container)
//        configureButtonWithAction()
//        applyConstraints()
//    }
//
//    // Convenience initializer
//    convenience init() {
//        print("convenience initializer called")
//        // Call the designated initializer with a default reuseIdentifier
//        self.init(reuseIdentifier: SectionHeaderView.identifier)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
////    init(frame: CGRect) {
////        super.init(frame: frame)
////    }
//
//    // MARK: - Instance methods
//    func configureFor(section: TableSection) {
//        sectionTitleLabel.text = section.sectionTitle
//        sectionTitleLabel.sizeToFit()
//
//        // Show or hide sectionSubtitleLabel
//        if section.sectionSubtitle.isEmpty {
//            sectionSubtitleLabel.isHidden = true
//        } else {
//            sectionSubtitleLabel.isHidden = false
//        }
//        sectionSubtitleLabel.text = section.sectionSubtitle
//        sectionTitleLabel.sizeToFit()
//
//        // Show or hide seeAllButton
//        let sectionKind = section.sectionKind
//        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
//            seeAllButtonWidthAnchorConstraint.isActive = true // Set button width to 0
//            horzStackView.spacing = 0
//        } else {
//            seeAllButtonWidthAnchorConstraint.isActive = false // Reset button to have its intrinsic width
//            horzStackView.spacing = SectionHeaderView.paddingBetweenLabelAndButton
//        }
//    }
//
//    private func configureButtonWithAction() {
//        seeAllButton.addAction(UIAction(handler: { [weak self] action in
//            guard let self = self else { return }
//            self.seeAllButtonDidTapCallback()
//        }), for: .touchUpInside)
//    }
//
//    private func applyConstraints() {
//        vertStackWithButton.translatesAutoresizingMaskIntoConstraints = false
//        vertStackWithButton.widthAnchor.constraint(equalTo: seeAllButton.widthAnchor).isActive = true
//
//        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
//        seeAllButton.bottomAnchor.constraint(equalTo: vertStackWithLabels.bottomAnchor).isActive = true
//
////        horzStackView.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            horzStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
////            horzStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
////            horzStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.generalTopPaddingSectionHeader),
////            horzStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
////        ])
//
//        horzStackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            horzStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.cvPadding),
//            horzStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.cvPadding),
//            horzStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.generalTopPaddingSectionHeader),
//            horzStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
//        ])
//
//        container.translatesAutoresizingMaskIntoConstraints = false
//        container.fillSuperview()
//    }
//
//}











//class SectionHeaderView: UITableViewHeaderFooterView {
//
//    // MARK: - Static properties and methods
//    static let identifier = "SectionHeaderView"
//
//    static func calculateHeaderHeightFor(section: TableSection, superviewWidth: CGFloat) -> CGFloat {
//        let sectionKind = section.sectionKind
//
//        var seeAllButtonWidth: CGFloat
//        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
//            seeAllButtonWidth = 0
//        } else {
//            let button = createSeeAllButton()
//            button.sizeToFit()
//            seeAllButtonWidth = button.bounds.width
//        }
//
//        let availableWidthForLabels = superviewWidth - (seeAllButtonWidth + paddingBetweenLabelAndButton + Constants.cvPadding * 2)
//
//        var subtitleHeight: CGFloat
//        if section.sectionSubtitle.isEmpty {
//            subtitleHeight = 0
//        } else {
//            let subtitleLabel = createSectionSubtitleLabel()
//            subtitleLabel.text = section.sectionSubtitle
//            subtitleHeight = subtitleLabel.sizeThatFits(CGSize(width: availableWidthForLabels, height: CGFloat.greatestFiniteMagnitude)).height
//        }
//
//        let subtitleHeightPlusSpacing = subtitleHeight + paddingBetweenLabels
//
//        let titleLabel = createSectionTitleLabel()
//        titleLabel.text = section.sectionTitle
//        let titleLabelHeight = titleLabel.sizeThatFits(CGSize(width: availableWidthForLabels, height: CGFloat.greatestFiniteMagnitude)).height
//
//        let estimatedHeight = titleLabelHeight + subtitleHeightPlusSpacing + Constants.generalTopPaddingSectionHeader
//
//        return estimatedHeight
//    }
//
////    static func calculateHeaderHeightFor(section: TableSection) -> CGFloat {
////        let titleLabel = createSectionTitleLabel()
////        titleLabel.text = section.sectionTitle
////
////        let subtitleLabel = createSectionSubtitleLabel()
////
////        let stack = createVertStackWithLabels()
////        stack.addArrangedSubview(titleLabel)
////        stack.addArrangedSubview(subtitleLabel)
////
////
////        let header = SectionHeaderSubviewsContainer()
////        header.sectionTitleLabel.text = section.sectionTitle
////        header.sectionSubtitleLabel.text = section.sectionSubtitle
////        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
////        return height
////    }
//
//    private static func createSectionTitleLabel() -> UILabel {
//        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
//        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        return label
//    }
//
//    private static func createSectionSubtitleLabel() -> UILabel {
//        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
//        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        return label
//    }
//
////    private static func createVertStackWithLabels() -> UIStackView {
////        let titleLabel = createSectionTitleLabel()
////
////        let stack = UIStackView()
////        stack.axis = .vertical
////        stack.alignment = .leading
////        stack.spacing = SectionHeaderView.paddingBetweenLabels
//////        stack.addArrangedSubview(sectionTitleLabel)
//////        stack.addArrangedSubview(sectionSubtitleLabel)
////        return stack
////    }
//
//    private static let paddingBetweenLabelAndButton: CGFloat = 20
//    private static let seeAllButtonTitle = "See all"
//    private static let paddingBetweenLabels: CGFloat = 1
//
//    private static func createSeeAllButton() -> UIButton {
//        let button = UIButton()
//        button.setTitle(seeAllButtonTitle, for: .normal)
////        button.titleLabel?.lineBreakMode = .byTruncatingTail
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
//        button.titleLabel?.font = scaledFont
//        button.contentHorizontalAlignment = .right
//        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
////        button.titleLabel?.adjustsFontForContentSizeCategory = true
//        return button
//    }
//
////    private static func calculateSeeAllButtonWidth() -> CGFloat {
////        let button = createSeeAllButton()
////        button.sizeToFit()
////        return button.bounds.size.width
////    }
//
//    // MARK: - Instance properties
//    var tableSection: TableSection?
//    private var withButton = true
//
////    let sectionTitleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
////    let sectionSubtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
//
//    let sectionTitleLabel = createSectionTitleLabel()
//    let sectionSubtitleLabel = createSectionSubtitleLabel()
//
//    private lazy var seeAllButton = SectionHeaderView.createSeeAllButton()
//
//    private lazy var seeAllButtonWidthAnchorConstraint = seeAllButton.widthAnchor.constraint(equalToConstant: 0)
//
//    private lazy var vertStackWithLabels: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.alignment = .leading
//        stack.spacing = SectionHeaderView.paddingBetweenLabels
//        stack.addArrangedSubview(sectionTitleLabel)
//        stack.addArrangedSubview(sectionSubtitleLabel)
//        return stack
//    }()
//
//    private lazy var vertStackWithButton: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.alignment = .trailing
//        stack.addArrangedSubview(UIView())
//        stack.addArrangedSubview(seeAllButton)
//        seeAllButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        return stack
//    }()
//
//    private lazy var horzStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.alignment = .center
//        stack.spacing = SectionHeaderView.paddingBetweenLabelAndButton
//        stack.addArrangedSubview(vertStackWithLabels)
//        stack.addArrangedSubview(vertStackWithButton)
//        return stack
//    }()
//
//    // Closure to tell owning controller to push new vc
////    typealias SeeAllButtonCallbackClosure = (_ tableSection: TableSection) -> ()
////    var callback: SeeAllButtonCallbackClosure = {_ in}
//    var seeAllButtonDidTapCallback: () -> () = {}
//
//    // MARK: - Initializers
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(horzStackView)
//        configureButtonWithAction()
//        applyConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
////    init(frame: CGRect) {
////        super.init(frame: frame)
////    }
//
//    // MARK: - Instance methods
//    func configureFor(section: TableSection) {
//        sectionTitleLabel.text = section.sectionTitle
//        sectionTitleLabel.sizeToFit()
//
//        // Show or hide sectionSubtitleLabel
//        if section.sectionSubtitle.isEmpty {
//            sectionSubtitleLabel.isHidden = true
//        } else {
//            sectionSubtitleLabel.isHidden = false
//        }
//        sectionSubtitleLabel.text = section.sectionSubtitle
//        sectionTitleLabel.sizeToFit()
//
//        // Show or hide seeAllButton
//        let sectionKind = section.sectionKind
//        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
//            seeAllButtonWidthAnchorConstraint.isActive = true // Set button width to 0
//            horzStackView.spacing = 0
//        } else {
//            seeAllButtonWidthAnchorConstraint.isActive = false // Reset button to have its intrinsic width
//            horzStackView.spacing = SectionHeaderView.paddingBetweenLabelAndButton
//        }
//    }
//
//    private func configureButtonWithAction() {
//        seeAllButton.addAction(UIAction(handler: { [weak self] action in
//            guard let self = self else { return }
//            self.seeAllButtonDidTapCallback()
//        }), for: .touchUpInside)
//    }
//
//    private func applyConstraints() {
//        vertStackWithButton.translatesAutoresizingMaskIntoConstraints = false
//        vertStackWithButton.widthAnchor.constraint(equalTo: seeAllButton.widthAnchor).isActive = true
//
//        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
//        seeAllButton.bottomAnchor.constraint(equalTo: vertStackWithLabels.bottomAnchor).isActive = true
//
//        horzStackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            horzStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
//            horzStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
//            horzStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.generalTopPaddingSectionHeader),
//            horzStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//    }
//
//}









//class SectionHeaderView: UITableViewHeaderFooterView {
//
//    // MARK: - Static properties and methods
//    static let identifier = "SectionHeaderView"
//
//    static func calculateHeaderHeightFor(section: TableSection) -> CGFloat {
//        let header = SectionHeaderSubviewsContainer()
//        header.sectionTitleLabel.text = section.sectionTitle
//        header.sectionSubtitleLabel.text = section.sectionSubtitle
//        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        return height
//    }
//
//    let containerWithSubviews = SectionHeaderSubviewsContainer()
//
//    // MARK: - Initializers
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(containerWithSubviews)
//        containerWithSubviews.fillSuperview()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Instance methods
//    func configureFor(section: TableSection) {
//        containerWithSubviews.tableSection = section
//        containerWithSubviews.sectionTitleLabel.text = section.sectionTitle
//        containerWithSubviews.sectionSubtitleLabel.text = section.sectionSubtitle
//    }
//
//}
