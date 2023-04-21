//
//  RoundButtonsStackContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 22/3/23.
//

import UIKit

class RoundButtonsStackContainer: UIStackView {
    // MARK: - Static properties and methods
    static let roundWidth = UIScreen.main.bounds.width * 0.12
    
    static func createLabel(withText text: String) -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: nil, withScaledFont: false, textColor: .label, text: text)
        label.textAlignment = .center
        return label
    }
    
    // MARK: - Instance properties
    private let book: Book

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
    
    private let listenLabel: UILabel = RoundButtonsStackContainer.createLabel(withText: "Listen")
    
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
    
    private let readLabel: UILabel = RoundButtonsStackContainer.createLabel(withText: "Read")
    
    private lazy var saveView: UIView = {
        let view = UIView()
        view.addSubview(viewWithSaveButton)
        view.addSubview(saveLabel)
        return view
    }()
    
    private lazy var viewWithSaveButton: UIView = {
        let view = UIView()
        view.addSubview(saveButton)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.cornerRadius = RoundButtonsStackContainer.roundWidth / 2
        return view
    }()
        
    private let saveButton: SaveBookButton = {
        let button = SaveBookButton()
        button.layer.cornerRadius = RoundButtonsStackContainer.roundWidth / 2
        return button
    }()
    
    private var isBookAddedToBookshelf = false
    var saveButtonDidTapCallback: SaveButtonDidTapCallback = {_ in}

    private let saveLabel: UILabel = RoundButtonsStackContainer.createLabel(withText: "Save")
    
    private lazy var hasListenButton: Bool = {
        var hasButton = false
        let bookKind = book.titleKind
        if bookKind == .audiobook || bookKind == .audioBookAndEbook {
            hasButton = true
        }
        return hasButton
    }()
    
    private lazy var hasReadButton: Bool = {
        var hasButton = false
        let bookKind = book.titleKind
        if bookKind == .ebook || bookKind == .audioBookAndEbook {
            hasButton = true
        }
        return hasButton
    }()
    
    // MARK: - Initializers
    init(forBook book: Book) {
        self.book = book
        super.init(frame: .zero)
        configureSelf()
        applyConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            viewWithSaveButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        axis = .horizontal
        distribution = .fillProportionally
        spacing = RoundButtonsStackContainer.roundWidth - 10
        
        isBookAddedToBookshelf = book.isAddedToBookshelf
        
        toggleSaveLabelText()
        saveButton.toggleImage(isBookAdded: isBookAddedToBookshelf)
        addSaveButtonAction()
                
        if hasListenButton {
            addArrangedSubview(viewWithListenButton)
        }
        
        if hasReadButton {
            addArrangedSubview(viewWithReadButton)
        }
        
        addArrangedSubview(saveView)
    }

    private func addSaveButtonAction() {
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.saveButton.isUserInteractionEnabled = false
            
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackGenerator.impactOccurred()
            
            self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
            self.handleSaveButtonTapped()
        }), for: .touchUpInside)
    }

    private func handleSaveButtonTapped() {
        self.saveButtonDidTapCallback(self.isBookAddedToBookshelf)

        if self.isBookAddedToBookshelf {
            self.saveButton.toggleImage(isBookAdded: self.isBookAddedToBookshelf)
            self.toggleSaveLabelText()
            self.book.update(isAddedToBookshelf: self.isBookAddedToBookshelf)
            self.saveButton.animateImageView(withCompletion: { [weak self] _ in
                self?.saveButton.isUserInteractionEnabled = true
            })
        } else {
            self.saveButton.animateImageView(withCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.saveButton.toggleImage(isBookAdded: self.isBookAddedToBookshelf)
                self.toggleSaveLabelText()
                self.book.update(isAddedToBookshelf: self.isBookAddedToBookshelf)
                self.saveButton.isUserInteractionEnabled = true
            })
        }
    }
    
    private func toggleSaveLabelText() {
        saveLabel.text = isBookAddedToBookshelf ? "Saved" : "Save"
    }

    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        let labelPadding: CGFloat = 15

        // Save button
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalTo: viewWithSaveButton.widthAnchor),
            saveButton.heightAnchor.constraint(equalTo: viewWithSaveButton.heightAnchor),
            saveButton.centerXAnchor.constraint(equalTo: viewWithSaveButton.centerXAnchor, constant: 1),
            saveButton.centerYAnchor.constraint(equalTo: viewWithSaveButton.centerYAnchor, constant: 0.5)
        ])

        viewWithSaveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewWithSaveButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
            viewWithSaveButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
            viewWithSaveButton.topAnchor.constraint(equalTo: saveView.topAnchor),
            viewWithSaveButton.leadingAnchor.constraint(equalTo: saveView.leadingAnchor),
            viewWithSaveButton.bottomAnchor.constraint(equalTo: saveLabel.topAnchor, constant: -labelPadding)
        ])

        saveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
            saveLabel.centerXAnchor.constraint(equalTo: saveView.centerXAnchor),
            saveLabel.bottomAnchor.constraint(equalTo: saveView.bottomAnchor)

        ])

        saveView.translatesAutoresizingMaskIntoConstraints = false
        saveView.widthAnchor.constraint(equalTo: viewWithSaveButton.widthAnchor).isActive = true

        if hasListenButton {
            // Listen button
            listenButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                listenButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
                listenButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
                listenButton.topAnchor.constraint(equalTo: viewWithListenButton.topAnchor),
                listenButton.leadingAnchor.constraint(equalTo: viewWithListenButton.leadingAnchor),
                listenButton.bottomAnchor.constraint(equalTo: listenLabel.topAnchor, constant: -labelPadding)
            ])

            listenLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                listenLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
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
                readButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
                readButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
                readButton.topAnchor.constraint(equalTo: viewWithReadButton.topAnchor),
                readButton.leadingAnchor.constraint(equalTo: viewWithReadButton.leadingAnchor),
                readButton.bottomAnchor.constraint(equalTo: readLabel.topAnchor, constant: -labelPadding)
            ])

            readLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                readLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.roundWidth),
                readLabel.centerXAnchor.constraint(equalTo: viewWithReadButton.centerXAnchor),
                readLabel.bottomAnchor.constraint(equalTo: viewWithReadButton.bottomAnchor)
            ])

            viewWithReadButton.translatesAutoresizingMaskIntoConstraints = false
            viewWithReadButton.widthAnchor.constraint(equalTo: readButton.widthAnchor).isActive = true
        }
    }
    
}
