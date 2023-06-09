//
//  SimilarBooksView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 25/4/23.
//

import UIKit

class SimilarBooksTableHeaderView: UIView {

    // MARK: - Instance properties
    private let imageHeight: CGFloat = 48

    private lazy var imageViewContainer: UIView = {
        let view = UIView()
        view.addSubview(imageView)
        return view
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.tertiaryLabel.cgColor
        view.layer.borderWidth = 0.26
        view.clipsToBounds = true
        return view
    }()

    private lazy var imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageHeight)
    
    private lazy var vertStackWithImage: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(imageViewContainer)
        stack.addArrangedSubview(UIView())
        return stack
    }()
    
    private let similarBooksLabel = UILabel.createLabelWith(font: UIFont.customFootnoteSemibold, text: "Libros similares")

    private let bookTitleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .callout, weight: .medium, maxPointSize: 45)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 2)
        return label
    }()

    private lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        [similarBooksLabel, bookTitleLabel, UIView()].forEach { stack.addArrangedSubview($0)}
        stack.setCustomSpacing(3, after: similarBooksLabel)
        return stack
    }()

    private lazy var horzStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.commonHorzPadding
        stack.addArrangedSubview(vertStackWithImage)
        stack.addArrangedSubview(vertStackWithLabels)
        return stack
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.powderGrayBackgroundColor
        addSubview(horzStack)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }

    // MARK: - Instance methods
    func configureFor(book: Book) {
        bookTitleLabel.text = book.title
        imageView.setImageForBook(book, defaultImageViewHeight: imageHeight, imageViewWidthConstraint: imageViewWidthConstraint)
    }

    // MARK: - Helper methods
    private func applyConstraints() {
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewContainer.heightAnchor.constraint(equalToConstant: imageHeight),
            imageViewContainer.heightAnchor.constraint(equalToConstant: imageHeight)
        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: imageViewContainer.heightAnchor)
        ])
        imageViewWidthConstraint.isActive = true

        vertStackWithImage.translatesAutoresizingMaskIntoConstraints = false
        vertStackWithImage.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true

        horzStack.translatesAutoresizingMaskIntoConstraints = false
        horzStack.fillSuperview(withConstant: Constants.commonHorzPadding)
        
        translatesAutoresizingMaskIntoConstraints = false
        // Avoid constraint's conflict when header is added to table view
        for constraint in constraints {
            constraint.priority = UILayoutPriority(750)
        }
    }

}
