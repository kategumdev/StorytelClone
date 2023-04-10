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
    private var book: Book?
    var showPopupCallback: () -> () = {}
    var hidePopupCallback: () -> () = {}
    var togglePopupButtonTextCallback: (Bool) -> () = {_ in}
    
    lazy var hidePopupWorkItem = DispatchWorkItem { [weak self] in
        self?.hidePopupCallback()
    }
    
    private lazy var showPopupWorkItem = DispatchWorkItem { [weak self] in
        self?.showPopupCallback()
    }
    
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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private var isBookAlreadyAddedToBookshelf = false
    
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
//        isUserInteractionEnabled = false
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
        
//        addSaveButtonAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func configureForAllTitleCellWith(book: Book,  togglePopupButtonTextCallback: @escaping (Bool) -> (), showPopupCallback: @escaping () -> (), hidePopupCallback: @escaping () -> () ) {
        self.book = book
        self.togglePopupButtonTextCallback = togglePopupButtonTextCallback
        self.showPopupCallback = showPopupCallback
        self.hidePopupCallback = hidePopupCallback
        
        ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
        categoryLabel.text = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
        isBookAlreadyAddedToBookshelf = book.isAddedToBookshelf
        saveOrRemoveBookAndToggleImage()
        
        addSaveButtonAction()
    }
//    func configureForAllTitleCellWith(book: Book) {
//        self.book = book
//
//        ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
//        categoryLabel.text = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
//        isBookAlreadyAddedToBookshelf = book.isAddedToBookshelf
//        saveOrRemoveBookAndToggleImage()
//    }
    
    private func addSaveButtonAction() {
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            print("saveButton tapped")
            self.handleSaveButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func handleSaveButtonTapped() {
        hidePopupCallback()
        cancelAndReassignWorkItems()
        
        self.isBookAlreadyAddedToBookshelf = !self.isBookAlreadyAddedToBookshelf
        self.saveOrRemoveBookAndToggleImage()
        
        if isBookAlreadyAddedToBookshelf {
//            self.isBookAlreadyAddedToBookshelf = !self.isBookAlreadyAddedToBookshelf
//            self.saveOrRemoveBookAndToggleImage()
            
            // User removes book, image should be changed after animation completes
            UIView.animate(withDuration: 0.6, animations: { [weak self] in
                guard let self = self else { return }
//                self.togglePopupButtonTextCallback(false)
                self.togglePopupButtonTextCallback(true)
                DispatchQueue.main.async(execute: self.showPopupWorkItem)
                
//                self.isBookAlreadyAddedToBookshelf = !self.isBookAlreadyAddedToBookshelf
//                self.saveOrRemoveBookAndToggleImage()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
                
            })

        } else {
//            self.isBookAlreadyAddedToBookshelf = !self.isBookAlreadyAddedToBookshelf
//            self.saveOrRemoveBookAndToggleImage()
            // User adds book, image should be changed before animation begins
            UIView.animate(withDuration: 0.6, animations: { [weak self] in
                guard let self = self else { return }
//                self.togglePopupButtonTextCallback(true)
                self.togglePopupButtonTextCallback(false)
                DispatchQueue.main.async(execute: self.showPopupWorkItem)
                
//                self.isBookAlreadyAddedToBookshelf = !self.isBookAlreadyAddedToBookshelf
//                self.saveOrRemoveBookAndToggleImage()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
            })
        }

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
    
    private func saveOrRemoveBookAndToggleImage() {
        self.saveButton.tintColor = isBookAlreadyAddedToBookshelf ? Utils.tintColor : .label
        let newImageName = isBookAlreadyAddedToBookshelf ? "heart.fill" : "heart"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let newImage = UIImage(systemName: newImageName, withConfiguration: symbolConfig)
        self.saveButton.setImage(newImage, for: .normal)

        guard let book = book else { return }

        if self.isBookAlreadyAddedToBookshelf {
            toReadBooks.append(book)
        } else {
            toReadBooks.removeAll { $0.title == book.title }
        }

    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: categoryLabel.heightAnchor).isActive = true
    }
    
}
