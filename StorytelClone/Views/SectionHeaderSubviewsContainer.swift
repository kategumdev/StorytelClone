//
//  SectionHeaderSubviewsContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/3/23.
//

import UIKit

// Create it as a separate class to make calculation of estimated section header height (and smooth scrolling experience, especially after dynamic font size change) possible

typealias SeeAllButtonDidTapCallback = () -> ()

class SectionHeaderSubviewsContainer: UIView {
    
    private static let paddingBetweenLabelAndButton: CGFloat = 20
    private static let seeAllButtonTitle = "See all"
    private static let paddingBetweenLabels: CGFloat = 1
    
    // MARK: - Instance properties
    var tableSection: TableSection?
    private var withButton = true

    let sectionTitleLabel: UILabel = {
        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    let sectionSubtitleLabel: UILabel = {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
        
//    let sectionTitleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
//    let sectionSubtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle(SectionHeaderSubviewsContainer.seeAllButtonTitle, for: .normal)
//        button.titleLabel?.lineBreakMode = .byTruncatingTail
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
        button.titleLabel?.font = scaledFont
        button.contentHorizontalAlignment = .right
        button.setTitleColor(Utils.seeAllButtonColor, for: .normal)
//        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
//        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var seeAllButtonWidthAnchorConstraint = seeAllButton.widthAnchor.constraint(equalToConstant: 0)
    
    private lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = SectionHeaderSubviewsContainer.paddingBetweenLabels
        stack.addArrangedSubview(sectionTitleLabel)
        stack.addArrangedSubview(sectionSubtitleLabel)
        return stack
    }()
    
    private lazy var vertStackWithButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(seeAllButton)
//        seeAllButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return stack
    }()
    
    private lazy var horzStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton
        stack.addArrangedSubview(vertStackWithLabels)
        stack.addArrangedSubview(vertStackWithButton)
        return stack
    }()
    
//    typealias SeeAllButtonDidTapCallback = () -> ()
    
//    var seeAllButtonDidTapCallback: SeeAllButtonDidTapCallback = {}
//    var seeAllButtonDidTapCallback: () -> () = {}
    var callback: SeeAllButtonDidTapCallback = {}

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(horzStackView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configureFor(section: TableSection, passCallback callback: @escaping SeeAllButtonDidTapCallback) {
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
//            horzStackView.spacing = SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton
//        }
//
//        self.callback = callback
//        configureButtonWithAction()
//    }
    
    func configureFor(section: TableSection) {
        sectionTitleLabel.text = section.sectionTitle
        sectionTitleLabel.sizeToFit()
        
        // Show or hide sectionSubtitleLabel
        if section.sectionSubtitle.isEmpty {
            sectionSubtitleLabel.isHidden = true
        } else {
            sectionSubtitleLabel.isHidden = false
        }
        sectionSubtitleLabel.text = section.sectionSubtitle
        sectionTitleLabel.sizeToFit()
        
        // Show or hide seeAllButton
        let sectionKind = section.sectionKind
        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv || sectionKind == .searchVc {
            seeAllButtonWidthAnchorConstraint.isActive = true // Set button width to 0
            horzStackView.spacing = 0
        } else {
            seeAllButtonWidthAnchorConstraint.isActive = false // Reset button to have its intrinsic width
            horzStackView.spacing = SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton
        }
        
//        self.callback = callback
        configureButtonWithAction()
    }
    
    private func configureButtonWithAction() {
        seeAllButton.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            self.callback()
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        vertStackWithButton.translatesAutoresizingMaskIntoConstraints = false
        vertStackWithButton.widthAnchor.constraint(equalTo: seeAllButton.widthAnchor).isActive = true

        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.bottomAnchor.constraint(equalTo: vertStackWithLabels.bottomAnchor).isActive = true
        
        horzStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horzStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
            horzStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cvPadding),
            horzStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.generalTopPaddingSectionHeader),
            horzStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}



//// Create it as a separate class to make calculation of estimated section header height (and smooth scrolling experience, especially after dynamic font size change) possible
//class SectionHeaderSubviewsContainer: UIView {
//
//    // MARK: Static properties and methods
//    private static let paddingBetweenLabelAndButton: CGFloat = 20
//    private static let seeAllButtonTitle = "See all"
//    private static let paddingBetweenLabels: CGFloat = 1
//
//    private static func createSeeAllButton() -> UIButton {
//        let button = UIButton()
//        button.setTitle(seeAllButtonTitle, for: .normal)
//        button.titleLabel?.lineBreakMode = .byTruncatingTail
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
//        button.titleLabel?.font = scaledFont
//        button.contentHorizontalAlignment = .right
//        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
//        button.titleLabel?.adjustsFontForContentSizeCategory = true
//        return button
//    }
//
//    private static func calculateSeeAllButtonWidth() -> CGFloat {
//        let button = createSeeAllButton()
//        button.sizeToFit()
//        return button.bounds.size.width
//    }
//
//    // MARK: - Instance properties
//    private var withButton = true
//    private lazy var seeAllButton = SectionHeaderSubviewsContainer.createSeeAllButton()
//
//    var tableSection: TableSection?
//    let sectionTitleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2)
//    let sectionSubtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, numberOfLines: 2)
//
//    // Closure to tell owning controller to push new vc
//    typealias SeeAllButtonCallbackClosure = (_ tableSection: TableSection) -> ()
//    var callback: SeeAllButtonCallbackClosure = {_ in}
//
//    // MARK: - Initializers
//    init(withButton button: Bool = true) {
//        super.init(frame: .zero)
//        self.withButton = button
//        addSubview(sectionTitleLabel)
//        addSubview(sectionSubtitleLabel)
//
//        if withButton {
//            addSubview(seeAllButton)
//            configureButtonWithAction()
//        }
//        applyConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Helper methods
//    private func configureButtonWithAction() {
//        seeAllButton.addAction(UIAction(handler: { [weak self] action in
//            guard let self = self, let tableSection = self.tableSection else { return }
//            // Notify owning vc that the button was tapped
//            self.callback(tableSection)
//        }), for: .touchUpInside)
//    }
//
//    private func applyConstraints() {
//        translatesAutoresizingMaskIntoConstraints = false
//        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//
//        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        if !withButton {
//            sectionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55).isActive = true
//        }
//
//        NSLayoutConstraint.activate([
//            sectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
//            sectionTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.generalTopPaddingSectionHeader),
//            sectionTitleLabel.bottomAnchor.constraint(equalTo: sectionSubtitleLabel.topAnchor, constant: -5)
//        ])
//
//        sectionSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            sectionSubtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
//            sectionSubtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
//            sectionSubtitleLabel.trailingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor)
//        ])
//
//        guard withButton else { return }
//        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cvPadding),
//            seeAllButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//            seeAllButton.widthAnchor.constraint(equalToConstant: SectionHeaderSubviewsContainer.calculateSeeAllButtonWidth()),
//            seeAllButton.leadingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor, constant: SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton)
//        ])
//    }
//
//}

