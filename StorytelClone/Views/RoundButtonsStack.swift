//
//  RoundButtonsStackContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 22/3/23.
//

import UIKit

class RoundButtonsStack: UIStackView {
    // MARK: - Static properties and methods
    static let roundWidth = UIScreen.main.bounds.width * 0.12
    
    private static func createVertStack(view1: UIView, view2: UILabel) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(view1)
        stack.addArrangedSubview(view2)
        return stack
    }
    
    // MARK: - Instance properties
    private let book: Book
    private lazy var bookKind = book.titleKind

    private lazy var hasListenButton = bookKind == .audiobook || bookKind == .audioBookAndEbook ? true : false
    private lazy var listenVertStack = RoundButtonsStack.createVertStack(view1: listenButton, view2: listenLabel)
    private lazy var listenLabel: UILabel = createLabel(withText: "Listen")

    private lazy var listenButton: UIButton = {
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
    
    private lazy var hasReadButton = bookKind == .ebook || bookKind == .audioBookAndEbook ? true : false
    private lazy var readVertStack = RoundButtonsStack.createVertStack(view1: readButton, view2: readLabel)
    private lazy var readLabel: UILabel = createLabel(withText: "Read")
    
    private lazy var readButton: UIButton = {
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
    
    private lazy var saveVertStack = RoundButtonsStack.createVertStack(view1: viewWithSaveButton, view2: saveLabel)
    private let saveBookButton = SaveBookButton()
        
    private lazy var viewWithSaveButton: UIView = {
        let view = UIView()
        view.addSubview(saveBookButton)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.label.cgColor
        return view
    }()

    private var isBookAddedToBookshelf = false
    var saveBookButtonDidTapCallback: SaveBookButtonDidTapCallback = {_ in}

    private lazy var saveLabel: UILabel = createLabel(withText: "Save")

    private lazy var allLabels: [UILabel] = {
        var labels = [saveLabel]
        if hasReadButton {
            labels.append(readLabel)
        }
        
        if hasListenButton {
            labels.append(listenLabel)
        }
        return labels
    }()
    
    private lazy var allVertStacks: [UIStackView] = {
        var stacks = [saveVertStack]
        if hasReadButton {
            stacks.append(readVertStack)
        }
        
        if hasListenButton {
            stacks.append(listenVertStack)
        }
        return stacks
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
        
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            for label in allLabels {
                label.font = getScaledFontForLabel()
            }
        }
    }
    
    // MARK: - Instance methods
    func updateSaveButtonAppearance() {
        self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
        self.saveBookButton.toggleImage(isBookAdded: self.isBookAddedToBookshelf)
        self.toggleSaveLabelText()
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        axis = .horizontal
        distribution = .fillProportionally
        spacing = RoundButtonsStack.roundWidth - 10
        
        isBookAddedToBookshelf = book.isAddedToBookshelf
        
        toggleSaveLabelText()
        saveBookButton.toggleImage(isBookAdded: isBookAddedToBookshelf)
        addSaveButtonAction()
        [viewWithSaveButton, saveBookButton].forEach {
            $0.layer.cornerRadius = RoundButtonsStack.roundWidth / 2
        }
                
        if hasListenButton {
            addArrangedSubview(listenVertStack)
        }
        
        if hasReadButton {
            addArrangedSubview(readVertStack)
        }
        
        addArrangedSubview(saveVertStack)
     }

    private func addSaveButtonAction() {
        saveBookButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.saveBookButton.isUserInteractionEnabled = false
            Utils.playHaptics()
            self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
            self.handleSaveButtonTapped()
        }), for: .touchUpInside)
    }

    private func handleSaveButtonTapped() {
        self.saveBookButtonDidTapCallback(self.isBookAddedToBookshelf)
        if self.isBookAddedToBookshelf {
            self.saveBookButton.toggleImage(isBookAdded: self.isBookAddedToBookshelf)
            self.toggleSaveLabelText()
            self.book.update(isAddedToBookshelf: self.isBookAddedToBookshelf)
            self.saveBookButton.animateImageView(withCompletion: { [weak self] _ in
                self?.saveBookButton.isUserInteractionEnabled = true
            })
        } else {
            self.saveBookButton.animateImageView(withCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.saveBookButton.toggleImage(isBookAdded: self.isBookAddedToBookshelf)
                self.toggleSaveLabelText()
                self.book.update(isAddedToBookshelf: self.isBookAddedToBookshelf)
                self.saveBookButton.isUserInteractionEnabled = true
            })
        }
    }
    
    private func toggleSaveLabelText() {
        saveLabel.text = isBookAddedToBookshelf ? "Saved" : "Save"
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = getScaledFontForLabel()
        label.textAlignment = .center
        return label
    }
    
    private func getScaledFontForLabel() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: Utils.sectionSubtitleFont, maximumPointSize: 17)
    }

    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        saveBookButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveBookButton.widthAnchor.constraint(equalTo: viewWithSaveButton.widthAnchor),
            saveBookButton.heightAnchor.constraint(equalTo: viewWithSaveButton.heightAnchor),
            saveBookButton.centerXAnchor.constraint(equalTo: viewWithSaveButton.centerXAnchor, constant: 1),
            saveBookButton.centerYAnchor.constraint(equalTo: viewWithSaveButton.centerYAnchor, constant: 0.5)
        ])
        
        for vertStack in allVertStacks {
            guard let firstView = vertStack.arrangedSubviews.first, let secondView = vertStack.arrangedSubviews.last else { return }
            let labelPadding: CGFloat = 15
            
            firstView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                firstView.heightAnchor.constraint(equalToConstant: RoundButtonsStack.roundWidth),
                firstView.widthAnchor.constraint(equalToConstant: RoundButtonsStack.roundWidth),
                firstView.bottomAnchor.constraint(equalTo: secondView.topAnchor, constant: -labelPadding)
            ])
            
            vertStack.translatesAutoresizingMaskIntoConstraints = false
            vertStack.widthAnchor.constraint(equalToConstant: RoundButtonsStack.roundWidth).isActive = true
        }
    }
    
}

