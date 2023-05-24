//
//  RatingHorzStackView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/4/23.
//

import UIKit

class StarHorzStackView: UIStackView {
    // MARK: - Static methods
    static func createCategoryLabel() -> UILabel {
        let font = UIFont.createScaledFontWith(textStyle: .caption2, weight: .medium, maxPointSize: 16)
        let label = UILabel.createLabelWith(font: font, textColor: Utils.seeAllButtonColor, text: "Lorem ipsum")
        label.sizeToFit()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }
    
    static func getHeight() -> CGFloat {
        let label = createCategoryLabel()
        let height = label.bounds.height
        return height
    }

    // MARK: - Instance properties
    private var book: Book?
    private var isBookAddedToBookshelf = false
    
    private lazy var starView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 18).isActive = true
        view.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Utils.seeAllButtonColor
       
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2)
        ])
        
        return view
    }()
    
    private lazy var ratingLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .footnote, weight: .semibold, maxPointSize: 16)
        let label = UILabel.createLabelWith(font: scaledFont, textColor: Utils.seeAllButtonColor)
        label.sizeToFit()
        return label
    }()
    
    private lazy var vertBarLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 19, weight: .ultraLight)
        label.textAlignment = .center
        let text = "|"
        let attributedString = NSAttributedString(string: text).withLineHeightMultiple(0.8)
        label.attributedText = attributedString
        label.font = font
        label.textColor = .secondaryLabel
        label.sizeToFit()
        return label
    }()
    
    private let categoryLabel = createCategoryLabel()
        
    private lazy var saveButton = SaveBookButton()
    
    private lazy var ellipsisButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let image = UIImage(systemName: "ellipsis", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private var hasSaveAndEllipsisButtons: Bool
    var saveBookButtonDidTapCallback: SaveBookButtonDidTapCallback = {_ in}
    var ellipsisButtonDidTapCallback: () -> () = {}
        
    // MARK: - Initializers
    init(withSaveAndEllipsisButtons: Bool) {
        self.hasSaveAndEllipsisButtons = withSaveAndEllipsisButtons
        super.init(frame: .zero)
        axis = .horizontal
        alignment = .center
        spacing = 0
        [starView, ratingLabel, vertBarLabel, categoryLabel, UIView()].forEach { addArrangedSubview($0) }
        setCustomSpacing(4, after: starView)
        setCustomSpacing(6, after: ratingLabel)
        setCustomSpacing(6, after: vertBarLabel)
        applyConstraints()
        
        if hasSaveAndEllipsisButtons {
            addSaveButtonAction()
            addEllipsisButtonAction()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureWith(book: Book) {
        self.book = book
        
        let ratingRelatedViews = [starView, ratingLabel, vertBarLabel]
        if book.rating < 1 {
            ratingRelatedViews.forEach { $0.isHidden = true }
        } else {
            ratingRelatedViews.forEach { $0.isHidden = false }
            ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
        }
        
        categoryLabel.text = book.buttonCategory.rawValue.replacingOccurrences(of: "\n", with: " ")
        
        guard hasSaveAndEllipsisButtons else { return }
        isBookAddedToBookshelf = book.isAddedToBookshelf
        addArrangedSubview(saveButton)
        addArrangedSubview(ellipsisButton)
        setCustomSpacing(6, after: categoryLabel)
        setCustomSpacing(15, after: saveButton)
        toggleSaveButtonImage()
    }

    // MARK: - Helper methods
    private func addSaveButtonAction() {
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            Utils.playHaptics(withStyle: .soft, andIntensity: 0.7)
            self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
            self.toggleSaveButtonImage()
            self.saveBookButtonDidTapCallback(self.isBookAddedToBookshelf)
            self.book?.update(isAddedToBookshelf: self.isBookAddedToBookshelf)
        }), for: .touchUpInside)
    }
    
    private func addEllipsisButtonAction() {
        ellipsisButton.addAction(UIAction(handler: { [weak self] _ in
            self?.ellipsisButtonDidTapCallback()
        }), for: .touchUpInside)
    }
    
    private func toggleSaveButtonImage() {
        saveButton.tintColor = self.isBookAddedToBookshelf ? Utils.tintColor : .label
        saveButton.toggleImage(isBookAdded: self.isBookAddedToBookshelf)
    }

    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: categoryLabel.heightAnchor).isActive = true
    }
    
}


