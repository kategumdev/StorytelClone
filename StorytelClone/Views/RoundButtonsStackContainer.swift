//
//  RoundButtonsStackContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 22/3/23.
//

import UIKit

class RoundButtonsStackContainer: UIStackView {
    
    // MARK: - Static properties and methods
    static let buttonWidthAndHeight = UIScreen.main.bounds.width * 0.12
    
    static func createLabel() -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: nil, withScaledFont: false, textColor: .label, text: "")
        label.textAlignment = .center
        return label
    }
    
    // MARK: - Instance properties
    private let book: Book
    var showPopupCallback: () -> () = {}
    var hidePopupCallback: () -> () = {}
    var togglePopupButtonTextCallback: (Bool) -> () = {_ in}
    
    lazy var hidePopupWorkItem = DispatchWorkItem { [weak self] in
        self?.hidePopupCallback()
    }
    
    private lazy var showPopupWorkItem = DispatchWorkItem { [weak self] in
        self?.showPopupCallback()
    }

    private lazy var viewWithListenButton: UIView = {
        let view = UIView()
        view.addSubview(listenButton)
        view.addSubview(listenLabel)
        return view
    }()
    
    private let listenButton: UIButton = {
        let button = UIButton()
        button.tintColor = Utils.tintColor
        var config = UIButton.Configuration.filled()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        let image = UIImage(systemName: "headphones", withConfiguration: symbolConfig)?.withTintColor(Utils.customBackgroundLight)
        config.image = image
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 9.5, bottom: 10, trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private let listenLabel: UILabel = {
        let label = RoundButtonsStackContainer.createLabel()
        label.text = "Listen"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var viewWithReadButton: UIView = {
       let view = UIView()
        view.addSubview(readButton)
        view.addSubview(readLabel)
        return view
    }()
    
    private let readButton: UIButton = {
        let button = UIButton()
        button.tintColor = Utils.tintColor
        var config = UIButton.Configuration.filled()
        let image = UIImage(named: "glasses")?.withTintColor(Utils.customBackgroundLight)
        
        // Resize image
        if let image = image {
            let resizedImage = image.resizeFor(targetHeight: 25)
            config.image = resizedImage
        }
 
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8.5, leading: 9.5, bottom: 9.5, trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private let readLabel: UILabel = {
        let label = RoundButtonsStackContainer.createLabel()
        label.text = "Read"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var viewWithSaveButton: UIView = {
        let view = UIView()
        view.addSubview(saveButton)
        view.addSubview(saveLabel)
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = RoundButtonsStackContainer.buttonWidthAndHeight / 2
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 9.5, leading: 9.5, bottom: 8.5, trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private var isBookAddedToBookshelf = false
    var saveButtonTappedCallback: (Bool) -> () = {_ in}
//    var saveButtonTappedCallback: (Bool, @escaping () -> () ) -> () = {_,_  in}
    
//    private lazy var animateWhenBookIsAdded: () -> () = {
//        self.animateSaveButtonImageView(withCompletion: { [weak self] (_) in
//            guard let self = self else { return }
//
//            self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
//            self.saveOrRemoveBookAndToggleImage()
//
//        })
//    }
//
//    private lazy var animateWhenBookIsRemoved: () -> () = {
//        self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
//        self.saveOrRemoveBookAndToggleImage()
//        self.animateSaveButtonImageView(withCompletion: { _ in })
//    }
    
    
    private let saveLabel: UILabel = {
        let label = RoundButtonsStackContainer.createLabel()
        label.text = "Save"
        label.textAlignment = .center
        return label
    }()
    
    private var hasListenButton = true
    private var hasReadButton = true
    
    // MARK: - View life cycle
    init(forBook book: Book) {
        self.book = book
        super.init(frame: .zero)
        isBookAddedToBookshelf = book.isAddedToBookshelf
//        saveOrRemoveBookAndToggleImage()
        toggleButtonImage()
        
        configureSelf()
        applyConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            saveButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        axis = .horizontal
        distribution = .fillProportionally
        spacing = RoundButtonsStackContainer.buttonWidthAndHeight - 10
        
        let bookKind = book.titleKind
        
        if bookKind == .audioBookAndEbook {
            addArrangedSubview(viewWithListenButton)
            addArrangedSubview(viewWithReadButton)
            addArrangedSubview(viewWithSaveButton)
        } else if bookKind == .audiobook {
            hasReadButton = false
            addArrangedSubview(viewWithListenButton)
            addArrangedSubview(viewWithSaveButton)
        } else {
            hasListenButton = false
            addArrangedSubview(viewWithReadButton)
            addArrangedSubview(viewWithSaveButton)
        }
        
        addSaveButtonAction()
    }
    
    private func addSaveButtonAction() {
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }

            self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
//
//            self.saveButtonTappedCallback(self.isBookAddedToBookshelf)
//
//            if !self.isBookAddedToBookshelf {
//                self.animateSaveButtonImageView(withCompletion: { [weak self] (_) in
//                    guard let self = self else { return }
//
////                    self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
//                    self.saveOrRemoveBookAndToggleImage()
//
//                })
//            } else {
////                self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
//                self.saveOrRemoveBookAndToggleImage()
//                self.animateSaveButtonImageView(withCompletion: { _ in })
//            }

            
            self.handleSaveButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func handleSaveButtonTapped() {
//        self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf

        self.saveButtonTappedCallback(self.isBookAddedToBookshelf)
        
//        if !self.isBookAddedToBookshelf {
//            self.animateSaveButtonImageView(withCompletion: { [weak self] (_) in
//                guard let self = self else { return }
//                self.saveOrRemoveBookAndToggleImage()
//            })
//        } else {
//            self.saveOrRemoveBookAndToggleImage()
//            self.animateSaveButtonImageView(withCompletion: { _ in })
//        }
        
        if self.isBookAddedToBookshelf {
//            self.saveOrRemoveBookAndToggleImage()
            self.toggleButtonImage()
            self.updateBook()
            self.animateSaveButtonImageView(withCompletion: { _ in })
        } else {
            self.animateSaveButtonImageView(withCompletion: { [weak self] (_) in
                guard let self = self else { return }
//                self.saveOrRemoveBookAndToggleImage()
                self.toggleButtonImage()
                self.updateBook()
            })
        }
    }
    
    private func animateSaveButtonImageView(withCompletion completion: ((Bool) -> Void)?) {
        let imageView = saveButton.imageView!
        // Set the initial transform of the view
        imageView.transform = CGAffineTransform.identity
        
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [.calculationModeCubic, .beginFromCurrentState], animations: {

            let duration1 = 0.15 // shorter duration for 1st keyframe
            let duration2 = 0.4 // longer duration for 2nd and 3rd keyframes
            let duration4 = 0.15 // shorter duration for 4th keyframe

            // First keyframe: animate to 30% of initial size
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration1) {
                imageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            }

            // Second keyframe: animate back to 100% of initial size with longer duration
            UIView.addKeyframe(withRelativeStartTime: duration1, relativeDuration: duration2) {
                imageView.transform = CGAffineTransform.identity
            }

            // Third keyframe: animate to 50% of initial size with the same duration as 2nd keyframe
            UIView.addKeyframe(withRelativeStartTime: duration1 + duration2, relativeDuration: duration2) {
                imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }

            // Fourth keyframe: animate back to 100% of initial size with spring animation
            UIView.addKeyframe(withRelativeStartTime: duration1 + duration2 + duration2, relativeDuration: duration4) {
                imageView.transform = CGAffineTransform.identity
            }
            
            UIView.animate(withDuration: duration4, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
                imageView.transform = CGAffineTransform.identity
            }, completion: nil )

        }, completion: completion)
    }
    
//    private func saveOrRemoveBookAndToggleImage() {
//        let newImageName = isBookAddedToBookshelf ? "heart.fill" : "heart"
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
//        let newImage = UIImage(systemName: newImageName, withConfiguration: symbolConfig)
//        self.saveButton.setImage(newImage, for: .normal)
//
//        self.saveLabel.text = isBookAddedToBookshelf ? "Saved" : "Save"
//
////        if self.isBookAddedToBookshelf {
////            // Add book only if it's not already in the array
////            if !toReadBooks.contains(where: { $0.title == book.title }) {
////                toReadBooks.append(book)
////            }
////        } else {
////            if let bookIndex = toReadBooks.firstIndex(where: { $0.title == book.title }) {
////                toReadBooks.remove(at: bookIndex)
////            }
//////            toReadBooks.removeAll { $0.title == self.book.title }
////        }
//
//    }
    
    private func toggleButtonImage() {
        let newImageName = isBookAddedToBookshelf ? "heart.fill" : "heart"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let newImage = UIImage(systemName: newImageName, withConfiguration: symbolConfig)
        self.saveButton.setImage(newImage, for: .normal)

        self.saveLabel.text = isBookAddedToBookshelf ? "Saved" : "Save"
    }
    
    private func updateBook() {
        if self.isBookAddedToBookshelf {
            // Add book only if it's not already in the array
            if !toReadBooks.contains(where: { $0.title == book.title }) {
                toReadBooks.append(book)
            }
        } else {
            if let bookIndex = toReadBooks.firstIndex(where: { $0.title == book.title }) {
                toReadBooks.remove(at: bookIndex)
            }
//            toReadBooks.removeAll { $0.title == self.book.title }
        }

    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        let buttonLabelPadding: CGFloat = 15

        // Save button
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            saveButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            saveButton.topAnchor.constraint(equalTo: viewWithSaveButton.topAnchor),
            saveButton.leadingAnchor.constraint(equalTo: viewWithSaveButton.leadingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: saveLabel.topAnchor, constant: -buttonLabelPadding)
        ])

        saveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            saveLabel.centerXAnchor.constraint(equalTo: viewWithSaveButton.centerXAnchor),
            saveLabel.bottomAnchor.constraint(equalTo: viewWithSaveButton.bottomAnchor)

        ])

        viewWithSaveButton.translatesAutoresizingMaskIntoConstraints = false
        viewWithSaveButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor).isActive = true

        if hasListenButton {
            // Listen button
            listenButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                listenButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                listenButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                listenButton.topAnchor.constraint(equalTo: viewWithListenButton.topAnchor),
                listenButton.leadingAnchor.constraint(equalTo: viewWithListenButton.leadingAnchor),
                listenButton.bottomAnchor.constraint(equalTo: listenLabel.topAnchor, constant: -buttonLabelPadding)
            ])

            listenLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                listenLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                listenLabel.centerXAnchor.constraint(equalTo: viewWithListenButton.centerXAnchor),
                listenLabel.bottomAnchor.constraint(equalTo: viewWithListenButton.bottomAnchor)
            ])

            viewWithListenButton.translatesAutoresizingMaskIntoConstraints = false
            viewWithListenButton.widthAnchor.constraint(equalTo: listenButton.widthAnchor).isActive = true
        }

        if hasReadButton {
            // Read button
            readButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                readButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                readButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                readButton.topAnchor.constraint(equalTo: viewWithReadButton.topAnchor),
                readButton.leadingAnchor.constraint(equalTo: viewWithReadButton.leadingAnchor),
                readButton.bottomAnchor.constraint(equalTo: readLabel.topAnchor, constant: -buttonLabelPadding)
            ])

            readLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                readLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                readLabel.centerXAnchor.constraint(equalTo: viewWithReadButton.centerXAnchor),
                readLabel.bottomAnchor.constraint(equalTo: viewWithReadButton.bottomAnchor)
            ])

            viewWithReadButton.translatesAutoresizingMaskIntoConstraints = false
            viewWithReadButton.widthAnchor.constraint(equalTo: readButton.widthAnchor).isActive = true
        }
    }
    
}
