//
//  RoundButtonsStack.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 22/3/23.
//

import UIKit

class RoundButtonsStack: UIStackView {
    // MARK: - Static property
    static let roundWidth = UIScreen.main.bounds.width * 0.12
    
    // MARK: - Instance properties
    private let book: Book
    private let dataPersistenceManager: any DataPersistenceManager
    private lazy var bookKind = book.titleKind
    
    private lazy var allVertStacks: [UIStackView] = {
        var stacks = [UIStackView]()
        if hasListenButton {
            stacks.append(listenVertStack)
        }
        
        if hasReadButton {
            stacks.append(readVertStack)
        }
        
        stacks.append(saveVertStack)
        return stacks
    }()
    
    private lazy var hasListenButton = bookKind == .audiobook || bookKind == .audioBookAndEbook
    private lazy var listenVertStack = createVertStack(view1: listenButton, view2: listenLabel)
    private lazy var listenLabel: UILabel = createLabel(withText: "Listen")

    private lazy var listenButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.customTintColor
        var config = UIButton.Configuration.filled()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        let image = UIImage(
            systemName: "headphones",
            withConfiguration: symbolConfig)?.withTintColor(UIColor.customBackgroundLight)
        config.image = image
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 9.5,
            bottom: 10,
            trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private lazy var hasReadButton = bookKind == .ebook || bookKind == .audioBookAndEbook
    private lazy var readVertStack = createVertStack(view1: readButton, view2: readLabel)
    private lazy var readLabel: UILabel = createLabel(withText: "Read")
    
    private lazy var readButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.customTintColor
        var config = UIButton.Configuration.filled()
        let image = UIImage(named: "glasses")?.withTintColor(UIColor.customBackgroundLight)
        
        // Resize image
        if let image = image {
            let resizedImage = image.resizeFor(targetHeight: 25)
            config.image = resizedImage
        }
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 8.5,
            leading: 9.5,
            bottom: 9.5,
            trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private lazy var saveVertStack = createVertStack(view1: viewWithSaveButton, view2: saveLabel)
        
    private lazy var viewWithSaveButton: UIView = {
        let view = UIView()
        view.addSubview(saveBookButton)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.label.cgColor
        return view
    }()
    
    private let saveBookButton = SaveBookButton()

    var saveBookButtonDidTapCallback: SaveBookButtonDidTapCallback = {_ in}

    private lazy var saveLabel: UILabel = createLabel(withText: "Save")
        
    // MARK: - Initializers
    init(
        forBook book: Book,
        dataPersistenceManager: some DataPersistenceManager = CoreDataManager.shared
    ) {
        self.book = book
        self.dataPersistenceManager = dataPersistenceManager
        super.init(frame: .zero)
        configureSelf()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            viewWithSaveButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    // MARK: - Instance methods
    func updateSaveButtonAppearance() {
        let isBookBeingAdded = book.isOnBookshelf()
        saveBookButton.updateImage(isBookBeingAdded: isBookBeingAdded)
        updateSaveLabelText(isBookBeingAdded: isBookBeingAdded)
    }
}

// MARK: - Helper methods
extension RoundButtonsStack {
    private func configureSelf() {
        setupUI()
        addSaveButtonAction()
     }
    
    private func setupUI() {
        axis = .horizontal
        distribution = .fillProportionally
        spacing = RoundButtonsStack.roundWidth - 10
                
        updateSaveButtonAppearance()
        [viewWithSaveButton, saveBookButton].forEach {
            $0.layer.cornerRadius = RoundButtonsStack.roundWidth / 2
        }
        
        for stack in allVertStacks {
            addArrangedSubview(stack)
        }
        
        applyConstraints()
    }
    
    private func createVertStack(view1: UIView, view2: UILabel) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.addArrangedSubview(view1)
        stack.addArrangedSubview(view2)
        return stack
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .footnote,
            weight: .regular,
            maxPointSize: 17)
        let label = UILabel.createLabelWith(font: scaledFont, text: text)
        label.textAlignment = .center
        return label
    }
    
    private func addSaveButtonAction() {
        saveBookButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.saveBookButton.isUserInteractionEnabled = false
            Utils.playHaptics()
            self.handleSaveButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func handleSaveButtonTapped() {
        dataPersistenceManager.addOrDeletePersistedBookFrom(book: book) { [weak self] result in
            switch result {
            case .success(let bookState):
                let isBookBeingAdded = bookState == .added ? true : false
                self?.handleAddingOrRemoving(isBookBeingAdded: isBookBeingAdded)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleAddingOrRemoving(isBookBeingAdded: Bool) {
        saveBookButtonDidTapCallback(isBookBeingAdded)

        if isBookBeingAdded {
            saveBookButton.animateImageView(withCompletion: { [weak self] _ in
                self?.saveBookButton.updateImage(isBookBeingAdded: true)
                self?.updateSaveLabelText(isBookBeingAdded: true)
                self?.saveBookButton.isUserInteractionEnabled = true
            })
        } else {
            saveBookButton.updateImage(isBookBeingAdded: false)
            updateSaveLabelText(isBookBeingAdded: false)
            saveBookButton.animateImageView(withCompletion: { [weak self] _ in
                self?.saveBookButton.isUserInteractionEnabled = true
            })
        }
    }
    
    private func updateSaveLabelText(isBookBeingAdded: Bool) {
        saveLabel.text = isBookBeingAdded ? "Saved" : "Save"
    }

    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        saveBookButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveBookButton.widthAnchor.constraint(equalTo: viewWithSaveButton.widthAnchor),
            saveBookButton.heightAnchor.constraint(equalTo: viewWithSaveButton.heightAnchor),
            saveBookButton.centerXAnchor.constraint(
                equalTo: viewWithSaveButton.centerXAnchor,
                constant: 1),
            saveBookButton.centerYAnchor.constraint(
                equalTo: viewWithSaveButton.centerYAnchor,
                constant: 0.5)
        ])
        
        for vertStack in allVertStacks {
            guard let firstView = vertStack.arrangedSubviews.first else { return }
            firstView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                firstView.heightAnchor.constraint(equalToConstant: RoundButtonsStack.roundWidth),
                firstView.widthAnchor.constraint(equalToConstant: RoundButtonsStack.roundWidth),
            ])
            
            vertStack.translatesAutoresizingMaskIntoConstraints = false
            vertStack.widthAnchor.constraint(
                equalToConstant: RoundButtonsStack.roundWidth).isActive = true
        }
    }
}
