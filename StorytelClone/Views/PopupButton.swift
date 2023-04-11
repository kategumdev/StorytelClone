//
//  PopupView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/4/23.
//

import UIKit

class PopupButton: UIButton {
    // MARK: - Instance properties
    private let leadingPadding: CGFloat = Constants.cvPadding
    private let trailingPadding: CGFloat = Constants.cvPadding - 2
    let bottomAnchorConstant = Utils.tabBarHeight + 7

    private let customLabel = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .medium, size: 16), maximumPointSize: nil, withScaledFont: false, textColor: Utils.customBackgroundColor!, text: "")
    
    private let textForAddingBook = "Added to Bookshelf"
    private let textForRemovingBook = "Removed from Bookshelf"
    
    private let labelImagePadding: CGFloat = 8
    private let imageWidthHeight: CGFloat = 20
    
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
    
    private lazy var showPopupCallback = { [weak self] in
        print("showPopupCallback is executing")
        guard let self = self else { return }
        UIView.animate(withDuration: 0.4, animations: {
            self.bottomAnchorConstraint?.constant = -self.bottomAnchorConstant
//            self.view.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
            self.alpha = 1
        })
    }
    
    private lazy var hidePopupCallback = { [weak self] in
        guard let self = self else { return }
        print("hidePopupCallback is executing")
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomAnchorConstraint?.constant = self.bottomAnchorConstant
//            self.view.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
            self.alpha = 0
        })
    }
    
    lazy var hidePopupWorkItem = DispatchWorkItem { [weak self] in
        self?.hidePopupCallback()
    }
    
    private lazy var showPopupWorkItem = DispatchWorkItem { [weak self] in
        self?.showPopupCallback()
    }
    
    private lazy var togglePopupButtonTextCallback = { [weak self] userAddedBookToBookshelf in
        guard let self = self else { return }
        self.changeLabelTextWhen(bookIsAdded: userAddedBookToBookshelf)
    }
    
    // Not for use in BookViewController
    lazy var saveButtonTappedCallback: (Bool) -> () = { [weak self]
        userAddedBookToBookshelf in
        guard let self = self else { return }
        self.cancelAndReassignWorkItems()
        
        // If popupView is already visible, hide it to enable animation in showPopupWorkItem
        guard let bottomAnchorConstraint = self.bottomAnchorConstraint else { return}
        
        if bottomAnchorConstraint.constant < self.bottomAnchorConstant {
            bottomAnchorConstraint.constant = self.bottomAnchorConstant
            self.alpha = 0
//            self.view.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
        }
        
//        UIView.animate(withDuration: 0.4, animations: { [weak self] in
//            guard let self = self else { return }
//            self.togglePopupButtonTextCallback(userAddedBookToBookshelf)
//
////            self.showPopupCallback()
//            DispatchQueue.main.async(execute: self.showPopupWorkItem)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
//        })
        
        self.togglePopupButtonTextCallback(userAddedBookToBookshelf)
        
        DispatchQueue.main.async(execute: self.showPopupWorkItem)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
    }
    
    lazy var bookVcSaveButtonTappedCallback: (Bool, @escaping () -> () ) -> () = { [weak self]
        userAddedBookToBookshelf, animateSaveButtonImageViewClosure in
        guard let self = self else { return }
        self.cancelAndReassignWorkItems()
        self.togglePopupButtonTextCallback(!userAddedBookToBookshelf)
        print("this is executing")
        DispatchQueue.main.async(execute: self.showPopupWorkItem)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
        
        animateSaveButtonImageViewClosure()

        
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let self = self else { return }
//            self.togglePopupButtonTextCallback(!userAddedBookToBookshelf)
//            DispatchQueue.main.async(execute: self.showPopupWorkItem)
            
//            animateSaveButtonImageViewClosure()
            
//            if self.isBookAddedToBookshelf {
//                self.animateSaveButtonImageView(withCompletion: { [weak self] (_) in
//                    guard let self = self else { return }
//
//                    self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
//                    self.saveOrRemoveBookAndToggleImage()
//
////                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
//                })
//            } else {
//                self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
//                self.saveOrRemoveBookAndToggleImage()
//
//                self.animateSaveButtonImageView(withCompletion: { [weak self] _ in
//                    guard let self = self else { return }
////                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
//                })
//            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
    }
    
//    lazy var bookVcSaveButtonTappedCallback: (Bool, @escaping () -> () ) -> () = { [weak self]
//        userAddedBookToBookshelf, animateSaveButtonImageViewClosure in
//        guard let self = self else { return }
//        self.cancelAndReassignWorkItems()
//
//        UIView.animate(withDuration: 0.6) { [weak self] in
//            guard let self = self else { return }
//            self.togglePopupButtonTextCallback(!userAddedBookToBookshelf)
//            DispatchQueue.main.async(execute: self.showPopupWorkItem)
//
//            animateSaveButtonImageViewClosure()
//
////            if self.isBookAddedToBookshelf {
////                self.animateSaveButtonImageView(withCompletion: { [weak self] (_) in
////                    guard let self = self else { return }
////
////                    self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
////                    self.saveOrRemoveBookAndToggleImage()
////
//////                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
////                })
////            } else {
////                self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
////                self.saveOrRemoveBookAndToggleImage()
////
////                self.animateSaveButtonImageView(withCompletion: { [weak self] _ in
////                    guard let self = self else { return }
//////                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
////                })
////            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
//        }
//    }
        
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "popupBackground")
        layer.cornerRadius = Constants.bookCoverCornerRadius
        tintColor = UIColor.label.withAlphaComponent(0.7)
        alpha = 0
        
        addSubview(customLabel)
//        customLabel.text = "Added to Bookshelf"
        addSubview(customImageView)
//        applyConstraints()
        addButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func changeLabelTextWhen(bookIsAdded: Bool) {
        customLabel.text = bookIsAdded ? textForAddingBook : textForRemovingBook
    }
    
    private func addButtonAction() {
        addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            // Cancel the work item to prevent it from executing with the delay
            self.hidePopupWorkItem.cancel()

            // Execute the callback immediately
            self.hidePopupCallback()

            // Reassign workItem to replace the cancelled one
            self.hidePopupWorkItem = DispatchWorkItem { [weak self] in
                self?.hidePopupCallback()
            }
        }), for: .touchUpInside)
    }
    
    private func cancelAndReassignWorkItems() {
        showPopupWorkItem.cancel()
        hidePopupWorkItem.cancel()
        
        showPopupWorkItem = DispatchWorkItem { [weak self] in
            self?.showPopupCallback()
        }
        
        hidePopupWorkItem = DispatchWorkItem { [weak self] in
            self?.hidePopupCallback()
        }
    }
    
    func applyConstraints() {
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
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: Constants.cvPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -Constants.cvPadding),
            heightAnchor.constraint(equalToConstant: 46)
        ])

        bottomAnchorConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomAnchorConstant)
        bottomAnchorConstraint?.isActive = true
    }
    
//    func applyButtonConstraints() {
//        guard let superview = superview else { return }
//        print("superview: \(superview)")
//        // Configure popupButton constraints
//        translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: Constants.cvPadding),
//            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -Constants.cvPadding),
//            heightAnchor.constraint(equalToConstant: 46)
//        ])
//
//        bottomAnchorConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomAnchorConstant)
//        bottomAnchorConstraint?.isActive = true
//    }
    
}



