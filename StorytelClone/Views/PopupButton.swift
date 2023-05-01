//
//  PopupView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/4/23.
//

import UIKit

class PopupButton: UIButton {
    
    static let buttonHeight: CGFloat = 46
    static let bottomAnchorConstantForVisibleState: CGFloat = PopupButton.buttonHeight + 11

    
    // MARK: - Instance properties
    private let leadingPadding: CGFloat = Constants.commonHorzPadding
    private let trailingPadding: CGFloat = Constants.commonHorzPadding - 2
    private let labelImagePadding: CGFloat = 8
    private let imageWidthHeight: CGFloat = 20

    private let customLabel = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .medium, size: 16), maximumPointSize: nil, withScaledFont: false, textColor: Utils.customBackgroundColor!, text: "")

    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Utils.customBackgroundColor
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
        imageView.image = image
        return imageView
    }()

    private var bottomAnchorConstraint: NSLayoutConstraint?

    private lazy var showPopupWorkItem = DispatchWorkItem { [weak self] in
        self?.showPopupButton()
    }

    private lazy var hidePopupWorkItem = DispatchWorkItem { [weak self] in
        self?.hidePopupButton()
    }

    lazy var reconfigureAndAnimateSelf: SaveBookButtonDidTapCallback = { [weak self]
        userAddedBookToBookshelf in
        guard let self = self else { return }
        self.cancelAndReassignWorkItems()

        // If it's already visible, hide it to make animation in showPopupWorkItem noticeable
        if let bottomAnchorConstraint = self.bottomAnchorConstraint, bottomAnchorConstraint.constant < PopupButton.bottomAnchorConstantForVisibleState {
            bottomAnchorConstraint.constant = 0
            self.alpha = 0
            self.superview?.layoutIfNeeded()
        }

        self.changeLabelTextWhen(bookIsAdded: userAddedBookToBookshelf)
        DispatchQueue.main.async(execute: self.showPopupWorkItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
    }

    private var constraintsApplied = false

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "popupBackground")
        layer.cornerRadius = Constants.bookCoverCornerRadius
        tintColor = UIColor.label.withAlphaComponent(0.7)
        alpha = 0
        addSubview(customLabel)
        addSubview(customImageView)
        addButtonAction()
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
    private func addButtonAction() {
        addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            // Cancel the work item to prevent it from executing with the delay
            self.hidePopupWorkItem.cancel()

            // Execute hidePopupButton() immediately
            self.hidePopupButton()

            // Reassign workItem to replace the cancelled one
            self.hidePopupWorkItem = DispatchWorkItem { [weak self] in
                self?.hidePopupButton()
            }
        }), for: .touchUpInside)
    }

    private func showPopupButton() {
        print("\nSHOW popupButton for button")
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.bottomAnchorConstraint?.constant = -PopupButton.bottomAnchorConstantForVisibleState
            self.superview?.layoutIfNeeded()
            self.alpha = 1
        })
    }

    private func hidePopupButton() {
        print("HIDE popupButton")
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.bottomAnchorConstraint?.constant = 0
            self.superview?.layoutIfNeeded()
            self.alpha = 0
        })
    }

    private func changeLabelTextWhen(bookIsAdded: Bool) {
        customLabel.text = bookIsAdded ? "Added to Bookshelf" : "Removed from Bookshelf"
    }

    private func cancelAndReassignWorkItems() {
        showPopupWorkItem.cancel()
        hidePopupWorkItem.cancel()

        showPopupWorkItem = DispatchWorkItem { [weak self] in
            self?.showPopupButton()
        }
        hidePopupWorkItem = DispatchWorkItem { [weak self] in
            self?.hidePopupButton()
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
            customImageView.leadingAnchor.constraint(equalTo: customLabel.trailingAnchor, constant: labelImagePadding)
        ])

        guard let superview = superview else { return }
        // Configure popupButton constraints
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: Constants.commonHorzPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -Constants.commonHorzPadding),
            heightAnchor.constraint(equalToConstant: PopupButton.buttonHeight)

        ])
        bottomAnchorConstraint = bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        bottomAnchorConstraint?.isActive = true
    }

}
