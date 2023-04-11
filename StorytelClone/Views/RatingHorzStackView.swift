//
//  RatingHorzStackView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/4/23.
//

import UIKit

class RatingHorzStackView: UIStackView {
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

    // MARK: - Instance properties
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
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2).isActive = true
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
        
    private let saveButton = UIButton()
    
    private var book: Book?
    private var isBookAddedToBookshelf = false
//    var saveButtonTappedCallback: (Bool) -> () = {_ in}
    var popupButtonCallback: PopupButtonCallback = {_ in}
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let image = UIImage(systemName: "ellipsis", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        return button
    }()
        
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        alignment = .center
        spacing = 0
        [starView, ratingLabel, vertBarLabel, categoryLabel, UIView(), saveButton, menuButton].forEach { addArrangedSubview($0) }
        setCustomSpacing(4, after: starView)
        setCustomSpacing(6, after: ratingLabel)
        setCustomSpacing(6, after: vertBarLabel)
        setCustomSpacing(6, after: categoryLabel)
        setCustomSpacing(15, after: saveButton)
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func configureForAllTitleCellWith(book: Book, popupButtonCallback: @escaping PopupButtonCallback ) {
        self.book = book
        self.popupButtonCallback = popupButtonCallback
        
        ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
        categoryLabel.text = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
        isBookAddedToBookshelf = book.isAddedToBookshelf
        toggleButtonImage()
        
        addSaveButtonAction()
    }
    
//    func configureForAllTitleCellWith(book: Book,  saveButtonTappedCallback: @escaping (Bool) -> () ) {
//        self.book = book
//        self.saveButtonTappedCallback = saveButtonTappedCallback
//
//        ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
//        categoryLabel.text = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
//        isBookAddedToBookshelf = book.isAddedToBookshelf
//        toggleButtonImage()
//
//        addSaveButtonAction()
//    }
    
    

    
//    private func addSaveButtonAction() {
//        saveButton.addAction(UIAction(handler: { [weak self] _ in
//            guard let self = self else { return }
//            print("saveButton tapped")
//            self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
//            self.toggleButtonImage()
//            self.updateBook()
//
//            self.saveButtonTappedCallback(self.isBookAddedToBookshelf)
//
//        }), for: .touchUpInside)
//    }
    
    private func addSaveButtonAction() {
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            print("saveButton tapped")
            self.isBookAddedToBookshelf = !self.isBookAddedToBookshelf
            self.toggleButtonImage()
//            self.updateBook()
            
//            UIView.animate(withDuration: 0.6, delay: 0) {
//                UIView.animate(withDuration: 0.1, delay: 0, animations: {
//                    self.toggleButtonImage()
//                })
//                self.saveButtonTappedCallback(self.isBookAddedToBookshelf)
//
//            }

//            self.saveButtonTappedCallback(self.isBookAddedToBookshelf)
            self.popupButtonCallback(self.isBookAddedToBookshelf)
            
            self.updateBook()
            
        }), for: .touchUpInside)
    }
    
    private func toggleButtonImage() {
        self.saveButton.tintColor = isBookAddedToBookshelf ? Utils.tintColor : .label
        let newImageName = isBookAddedToBookshelf ? "heart.fill" : "heart"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let newImage = UIImage(systemName: newImageName, withConfiguration: symbolConfig)
        self.saveButton.setImage(newImage, for: .normal)
    }
    
    private func updateBook() {
        guard let book = book else { return }

        if self.isBookAddedToBookshelf {
            // Add book only if it's not already in the array
            if !toReadBooks.contains(where: { $0.title == book.title }) {
                toReadBooks.append(book)
                // With real data, update book object here
            }
        } else {
            if let bookIndex = toReadBooks.firstIndex(where: { $0.title == book.title }) {
                toReadBooks.remove(at: bookIndex)
                // With real data, update book object here
            }
        }
    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: categoryLabel.heightAnchor).isActive = true
    }
    
}
