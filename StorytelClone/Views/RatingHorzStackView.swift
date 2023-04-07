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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        return button
    }()
    
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
        isUserInteractionEnabled = false
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
    func configureForAllTitleCellWith(book: Book) {
        ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
        categoryLabel.text = book.category.rawValue.replacingOccurrences(of: "\n", with: " ")
    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: categoryLabel.heightAnchor).isActive = true
    }
    
}
