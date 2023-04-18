//
//  RatingHorzStackView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/4/23.
//

import UIKit

class StarHorzStackView: UIStackView {
    
    // MARK: - Static method
    static func createCategoryLabel() -> UILabel {
        let font = UIFont.preferredCustomFontWith(weight: .medium, size: 11)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 45)
        label.text = "Lorem ipsum"
        label.textColor = Utils.seeAllButtonColor
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
    var saveButtonDidTapCallback: SaveButtonDidTapCallback = {_ in}
    
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
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 12)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 40)
        label.textColor = Utils.seeAllButtonColor
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
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let image = UIImage(systemName: "ellipsis", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        return button
    }()
        
    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        axis = .horizontal
//        alignment = .center
//        spacing = 0
//        [starView, ratingLabel, vertBarLabel, categoryLabel, UIView()].forEach { addArrangedSubview($0) }
//        setCustomSpacing(4, after: starView)
//        setCustomSpacing(6, after: ratingLabel)
//        setCustomSpacing(6, after: vertBarLabel)
//        applyConstraints()
//        addSaveButtonAction()
//    }
    
    init(withSaveButton: Bool) {
        super.init(frame: .zero)
        axis = .horizontal
        alignment = .center
        spacing = 0
        [starView, ratingLabel, vertBarLabel, categoryLabel, UIView()].forEach { addArrangedSubview($0) }
        setCustomSpacing(4, after: starView)
        setCustomSpacing(6, after: ratingLabel)
        setCustomSpacing(6, after: vertBarLabel)
        applyConstraints()
        
        if withSaveButton {
            addSaveButtonAction()
        }
//        addSaveButtonAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureForAllTitleCellWith(book: Book, saveButtonDidTapCallback: @escaping SaveButtonDidTapCallback ) {
        self.book = book
        isBookAddedToBookshelf = book.isAddedToBookshelf
        self.saveButtonDidTapCallback = saveButtonDidTapCallback
        
        addArrangedSubview(saveButton)
        addArrangedSubview(menuButton)
        setCustomSpacing(6, after: categoryLabel)
        setCustomSpacing(15, after: saveButton)

        toggleSaveButtonImage()
//        addSaveButtonAction()
        
        ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
        categoryLabel.text = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
    }
    
    func configureForOverviewCellSubviewsContainerWith(book: Book) {
        self.book = book
        ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
        categoryLabel.text = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
    }
    
    // MARK: - Helper methods
    private func addSaveButtonAction() {
        print("starHorzStackView adds saveButton action\n")
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
            self.toggleSaveButtonImage()
            self.saveButtonDidTapCallback(self.isBookAddedToBookshelf)
            self.book?.update(isAddedToBookshelf: self.isBookAddedToBookshelf)
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
