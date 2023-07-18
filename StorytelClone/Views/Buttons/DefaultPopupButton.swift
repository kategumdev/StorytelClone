//
//  DefaultPopupButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/4/23.
//

import UIKit

class DefaultPopupButton: UIButton, PopupButton {
    // MARK: - Instance properties
    let buttonHeight: CGFloat = 46
    private let leadingPadding: CGFloat = Constants.commonHorzPadding
    private let trailingPadding: CGFloat = Constants.commonHorzPadding - 2
    private let labelImagePadding: CGFloat = 8
    private let imageWidthHeight: CGFloat = 20
    
    private lazy var bottomAnchorConstantForVisibleState: CGFloat = {
        buttonHeight + 11
    }()
    
    private let customLabel: UILabel = {
        let font = UIFont.createStaticFontWith(weight: .medium, size: 16)
        let label = UILabel.createLabelWith(font: font)
        
        if let customBackgroundColor = UIColor.customBackgroundColor {
            label.textColor = customBackgroundColor
        }
        return label
    }()
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.customBackgroundColor
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
        imageView.image = image
        return imageView
    }()
    
    private var bottomAnchorConstraint: NSLayoutConstraint?
    
    private lazy var showWorkItem = DispatchWorkItem { [weak self] in
        self?.show()
    }
    
    private lazy var hideWorkItem = DispatchWorkItem { [weak self] in
        self?.hide()
    }
    
    lazy var animate: SaveBookButtonDidTapCallback = { [weak self] isBookBeingAdded in
        guard let self = self else { return }
        self.cancelAndReassignWorkItems()
        
        // If it's already visible, hide it to make animation in showPopupWorkItem noticeable
        if let bottomAnchorConstraint = self.bottomAnchorConstraint,
           bottomAnchorConstraint.constant < self.bottomAnchorConstantForVisibleState
        {
            bottomAnchorConstraint.constant = 0
            self.alpha = 0
            self.superview?.layoutIfNeeded()
        }
        
        self.changeLabelTextWhen(isBookBeingAdded: isBookBeingAdded)
        DispatchQueue.main.async(execute: self.showWorkItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hideWorkItem)
    }
    
    private var constraintsApplied = false
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        if superview != nil && constraintsApplied == false {
            applyConstraints()
            constraintsApplied = true
        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        setupUI()
        addButtonAction()
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "popupBackground")
        layer.cornerRadius = Constants.commonBookCoverCornerRadius
        tintColor = UIColor.label.withAlphaComponent(0.7)
        alpha = 0
        addSubview(customLabel)
        addSubview(customImageView)
    }
    
    private func addButtonAction() {
        addAction(UIAction(handler: { [weak self] _ in
            // Cancel the work item to prevent it from executing with the delay
            self?.hideWorkItem.cancel()
            
            // Execute hidePopupButton() immediately
            self?.hide()
            
            // Reassign workItem to replace the cancelled one
            self?.hideWorkItem = DispatchWorkItem { [weak self] in
                self?.hide()
            }
        }), for: .touchUpInside)
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.bottomAnchorConstraint?.constant = 0
            self?.superview?.layoutIfNeeded()
            self?.alpha = 0
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.bottomAnchorConstraint?.constant = -self.bottomAnchorConstantForVisibleState
            self.superview?.layoutIfNeeded()
            self.alpha = 1
        }
    }
    
    private func changeLabelTextWhen(isBookBeingAdded: Bool) {
        customLabel.text = isBookBeingAdded ? "Added to Bookshelf" : "Removed from Bookshelf"
    }
    
    private func cancelAndReassignWorkItems() {
        showWorkItem.cancel()
        hideWorkItem.cancel()
        
        showWorkItem = DispatchWorkItem { [weak self] in
            self?.show()
        }
        hideWorkItem = DispatchWorkItem { [weak self] in
            self?.hide()
        }
    }
    
    private func applyConstraints() {
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstant = leadingPadding + trailingPadding + labelImagePadding + imageWidthHeight
        NSLayoutConstraint.activate([
            customLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
            customLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            customLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPadding)
        ])
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.widthAnchor.constraint(equalToConstant: imageWidthHeight),
            customImageView.heightAnchor.constraint(equalToConstant: imageWidthHeight),
            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customImageView.leadingAnchor.constraint(
                equalTo: customLabel.trailingAnchor,
                constant: labelImagePadding)
        ])
        
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(
                equalTo: superview.leadingAnchor,
                constant: Constants.commonHorzPadding),
            trailingAnchor.constraint(
                equalTo: superview.trailingAnchor,
                constant: -Constants.commonHorzPadding),
            heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        bottomAnchorConstraint = bottomAnchor.constraint(
            equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        bottomAnchorConstraint?.isActive = true
    }
}
