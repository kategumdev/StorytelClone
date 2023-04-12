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
    
//    static func calculateHeaderHeightFor(section: TableSection) -> CGFloat {
//        let titleLabel = createSectionTitleLabel()
//        titleLabel.text = section.sectionTitle
//
//        let subtitleLabel = createSectionSubtitleLabel()
//
//        let stack = createVertStackWithLabels()
//        stack.addArrangedSubview(titleLabel)
//        stack.addArrangedSubview(subtitleLabel)
//
//
//        let header = SectionHeaderSubviewsContainer()
//        header.sectionTitleLabel.text = section.sectionTitle
//        header.sectionSubtitleLabel.text = section.sectionSubtitle
//        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        return height
//    }
    
    private static func createSectionTitleLabel() -> UILabel {
//        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
        label.backgroundColor = .yellow
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

//        label.sizeToFit()
        return label
    }
    
    private static func createSectionSubtitleLabel() -> UILabel {
//        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)


//        label.sizeToFit()
        return label
    }
    
//    private static func createVertStackWithLabels() -> UIStackView {
//        let titleLabel = createSectionTitleLabel()
//
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.alignment = .leading
//        stack.spacing = SectionHeaderView.paddingBetweenLabels
////        stack.addArrangedSubview(sectionTitleLabel)
////        stack.addArrangedSubview(sectionSubtitleLabel)
//        return stack
//    }
    
    private static let paddingBetweenLabelAndButton: CGFloat = 20
    private static let seeAllButtonTitle = "See all"
    private static let paddingBetweenLabels: CGFloat = 1
    
    private static func createSeeAllButton() -> UIButton {
        let button = UIButton()
        button.setTitle(seeAllButtonTitle, for: .normal)
//        button.titleLabel?.lineBreakMode = .byTruncatingTail
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
        button.titleLabel?.font = scaledFont
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
//        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .brown

//        var config = UIButton.Configuration.plain()
//        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: paddingBetweenLabelAndButton, bottom: 0, trailing: 0)
//        button.configuration = config
        return button
    }
    
//    private static func createSeeAllButton() -> UIButton {
//        let button = UIButton()
////        button.setTitle(seeAllButtonTitle, for: .normal)
////        button.titleLabel?.lineBreakMode = .byTruncatingTail
////        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
////        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
////        button.titleLabel?.font = scaledFont
////        button.contentHorizontalAlignment = .right
////        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
////        button.titleLabel?.adjustsFontForContentSizeCategory = true
//        button.backgroundColor = .brown
//
//        var config = UIButton.Configuration.plain()
//        config.attributedTitle = AttributedString(seeAllButtonTitle)
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
//        config.attributedTitle?.font = scaledFont
//        config.attributedTitle?.foregroundColor = Utils.seeAllButtonColor
//        config.titleAlignment = .trailing
//
//        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: paddingBetweenLabelAndButton, bottom: 0, trailing: 0)
//
//        button.configuration = config
//
//        button.sizeToFit()
//        return button
//    }

    private static func calculateSeeAllButtonWidth() -> CGFloat {
        let button = createSeeAllButton()
        button.sizeToFit()
        return button.bounds.size.width
    }
    
    // MARK: - Instance properties
    var tableSection: TableSection?
    private var withButton = true

//    let sectionTitleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
//    let sectionSubtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
    
    let sectionTitleLabel = createSectionTitleLabel()
    let sectionSubtitleLabel = createSectionSubtitleLabel()
    
    private lazy var seeAllButton = SectionHeaderView.createSeeAllButton()
    
//    private var stackWithButtonWidth =
    
    private lazy var seeAllButtonWidthAnchorConstraint = seeAllButton.widthAnchor.constraint(equalToConstant: 0)

    private lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = SectionHeaderView.paddingBetweenLabels
        stack.addArrangedSubview(sectionTitleLabel)
        stack.addArrangedSubview(sectionSubtitleLabel)
        
//        stack.setCustomSpacing(SectionHeaderView.paddingBetweenLabels, after: sectionTitleLabel)
        stack.backgroundColor = .green
//        stack.sizeToFit()
        return stack
    }()
    
    private lazy var vertStackWithButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(seeAllButton)
        seeAllButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        stack.backgroundColor = .cyan
//        stack.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return stack
    }()
    
    private lazy var horzStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = SectionHeaderView.paddingBetweenLabelAndButton
        stack.addArrangedSubview(vertStackWithLabels)
        stack.addArrangedSubview(vertStackWithButton)
        stack.backgroundColor = .purple
        return stack
    }()
    
//    private lazy var horzStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.alignment = .center
//        stack.spacing = SectionHeaderView.paddingBetweenLabelAndButton
//        stack.addArrangedSubview(vertStackWithLabels)
//        stack.addArrangedSubview(seeAllButton)
//        stack.backgroundColor = .purple
//        return stack
//    }()
    
    // Closure to tell owning controller to push new vc
    typealias SeeAllButtonCallbackClosure = (_ tableSection: TableSection) -> ()
    var callback: SeeAllButtonCallbackClosure = {_ in}

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(vertStackWithLabels)
//        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(horzStackView)
        contentView.backgroundColor = .blue
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("sectionTitleLabel height = \(sectionTitleLabel.bounds.height)")
//        print("sectionSubtitleLabel height = \(sectionSubtitleLabel.bounds.height)")
//        print("vertStack height = \(vertStackWithLabels.bounds.height)")
    }
    
    // MARK: - Instance methods
//    func configureFor(section: TableSection) {
//        let sectionKind = section.sectionKind
//        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
//            withButton = false
//        }
//
//    }
    
    func configureFor(section: TableSection) {
//        print("Configuring label with text: \(section.sectionTitle)")
        sectionTitleLabel.text = section.sectionTitle
        sectionTitleLabel.sizeToFit()
//        print("label height in configureFor: \(sectionTitleLabel.bounds.height)")
        
        // Show or hide sectionSubtitleLabel
        if section.sectionSubtitle.isEmpty {
            sectionSubtitleLabel.isHidden = true
        } else {
            sectionSubtitleLabel.isHidden = false
        }
        sectionSubtitleLabel.text = section.sectionSubtitle
        sectionTitleLabel.sizeToFit()
        
        // Show or hide seeAllButton
//        let sectionKind = section.sectionKind
//        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
//            seeAllButton.isHidden = true
//        } else {
//            seeAllButton.isHidden = false
//        }
        
        let sectionKind = section.sectionKind
        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
//            seeAllButton.setTitle("", for: .normal)
//            seeAllButton.translatesAutoresizingMaskIntoConstraints = false
//            seeAllButton.widthAnchor.constraint(equalToConstant: 0).isActive = true
            seeAllButtonWidthAnchorConstraint.isActive = true
            horzStackView.spacing = 0
        } else {
//            seeAllButton.setTitle(SectionHeaderView.seeAllButtonTitle, for: .normal)
//            seeAllButton.translatesAutoresizingMaskIntoConstraints = true
//            seeAllButton.sizeToFit()
            seeAllButtonWidthAnchorConstraint.isActive = false
            horzStackView.spacing = SectionHeaderView.paddingBetweenLabelAndButton
        }
        
//        setNeedsLayout()
//        layoutIfNeeded()
        
    }
    
    private func configureButtonWithAction() {
        seeAllButton.addAction(UIAction(handler: { [weak self] action in
            guard let self = self, let tableSection = self.tableSection else { return }
            // Notify owning vc that the button was tapped
            self.callback(tableSection)
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
//        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
//            sectionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
//            sectionTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
//        ])
        
        vertStackWithButton.translatesAutoresizingMaskIntoConstraints = false
        vertStackWithButton.widthAnchor.constraint(equalTo: seeAllButton.widthAnchor).isActive = true
        
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.bottomAnchor.constraint(equalTo: vertStackWithLabels.bottomAnchor).isActive = true
        
        horzStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horzStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            horzStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
            horzStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.generalTopPaddingSectionHeader),
//            vertStackWithLabels.heightAnchor.constraint(equalToConstant: 60),
            horzStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
//
        
        
//        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            vertStackWithLabels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
//            vertStackWithLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
//            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.generalTopPaddingSectionHeader),
////            vertStackWithLabels.heightAnchor.constraint(equalToConstant: 60),
//            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])

    }
}



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
