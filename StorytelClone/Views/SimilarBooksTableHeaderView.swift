//
//  SimilarBooksView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 25/4/23.
//

import UIKit

//class SimilarBooksTableHeaderView: UIView {
//
//    // MARK: - Instance properties
//    private let imageHeight: CGFloat = 48
//    private let horzStackSpacing: CGFloat = Constants.cvPadding
//    private let leadingTrailingConstant: CGFloat = Constants.cvPadding
//
//    private lazy var imageViewContainer: UIView = {
//        let view = UIView()
//        view.addSubview(imageView)
//        return view
//    }()
//
//    private lazy var imageView: UIImageView = {
//        let view = UIImageView()
//        view.layer.cornerRadius = 2
//        view.layer.borderColor = UIColor.tertiaryLabel.cgColor
//        view.layer.borderWidth = 0.26
//        view.clipsToBounds = true
//        return view
//    }()
//
//    private lazy var imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageHeight)
//
////    private lazy var vertStackWithImage: UIStackView = {
////        let stack = UIStackView()
////        stack.axis = .vertical
////        stack.addArrangedSubview(imageViewContainer)
////        stack.addArrangedSubview(UIView())
////        stack.backgroundColor = .green
////        return stack
////    }()
//
//    private let similarBooksLabel: UILabel = {
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let label = UILabel.createLabel(withFont: font, maximumPointSize: 40)
//        label.text = "Libros similares"
//        label.backgroundColor = .yellow
////        label.sizeToFit()
//        return label
//    }()
//
//    private let bookTitleLabel: UILabel = {
//        let font = UIFont.preferredCustomFontWith(weight: .medium, size: 16)
////        let font = UIFont.preferredCustomFontWith(weight: .medium, size: 13)
//
//        let label = UILabel.createLabel(withFont: font, maximumPointSize: 45, numberOfLines: 2)
//        label.backgroundColor = .cyan
////        label.sizeToFit()
//        return label
//    }()
//
//    private lazy var vertStackWithLabels: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
////        stack.alignment = .leading
////        stack.distribution = .fillProportionally
//        stack.addArrangedSubview(similarBooksLabel)
//        stack.addArrangedSubview(bookTitleLabel)
//        stack.backgroundColor = .blue
//        return stack
//    }()
//
////    private lazy var horzStack: UIStackView = {
////        let stack = UIStackView()
////        stack.axis = .horizontal
//////        stack.distribution = .fillProportionally
////        stack.spacing = horzStackSpacing
////        stack.addArrangedSubview(vertStackWithImage)
////        stack.addArrangedSubview(vertStackWithLabels)
////        stack.backgroundColor = .red
////        return stack
////    }()
//
//    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        backgroundColor = Utils.powderGrayBackgroundColor
//        backgroundColor = .black
//
//        addSubview(imageViewContainer)
//        addSubview(vertStackWithLabels)
////        addSubview(horzStack)
//        applyConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
////    override func layoutSubviews() {
////        super.layoutSubviews()
////        print("vertStackWithLabels height: \(vertStackWithLabels.bounds.height)")
////    }
//
//    // MARK: - View life cycle
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
//        }
//    }
//
//    // MARK: - Instance methods
//    func configureFor(book: Book) {
//        bookTitleLabel.text = book.title
//
//        if let image = book.coverImage {
//            let resizedImage = image.resizeFor(targetHeight: imageHeight)
//
//            if imageView.bounds.width != image.size.width {
//                imageViewWidthConstraint.constant = resizedImage.size.width
//            }
//            imageView.image = resizedImage
//        }
//    }
//
//    // MARK: - Helper methods
//    private func applyConstraints() {
//        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imageViewContainer.topAnchor.constraint(equalTo: topAnchor, constant: Constants.cvPadding),
//            imageViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
//            imageViewContainer.heightAnchor.constraint(equalToConstant: imageHeight),
//            imageViewContainer.heightAnchor.constraint(equalToConstant: imageHeight)
//        ])
//
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor),
//            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
//            imageView.heightAnchor.constraint(equalTo: imageViewContainer.heightAnchor)
//        ])
//        imageViewWidthConstraint.isActive = true
//
//        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
//        let subtrahend = imageHeight + leadingTrailingConstant * 2 + horzStackSpacing
//        NSLayoutConstraint.activate([
//            vertStackWithLabels.widthAnchor.constraint(equalTo: widthAnchor, constant: -subtrahend),
//            vertStackWithLabels.topAnchor.constraint(equalTo: topAnchor, constant: Constants.cvPadding),
//            vertStackWithLabels.leadingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor, constant: Constants.cvPadding),
//            vertStackWithLabels.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cvPadding),
//            vertStackWithLabels.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.cvPadding)
//
////            vertStackWithLabels.topAnchor.constraint(equalTo: similarBooksLabel.topAnchor),
////            vertStackWithLabels.bottomAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor)
//        ])
//
////        vertStackWithImage.translatesAutoresizingMaskIntoConstraints = false
////        vertStackWithImage.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
//
////        horzStack.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            horzStack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.cvPadding),
////            horzStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.cvPadding),
//////            horzStack.heightAnchor.constraint(equalTo: vertStackWithLabels.heightAnchor),
////            horzStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConstant),
////            horzStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConstant)
////        ])
//    }
//
//}

class SimilarBooksTableHeaderView: UIView {

    // MARK: - Instance properties
    private let imageHeight: CGFloat = 48
//    private let horzStackSpacing: CGFloat = Constants.cvPadding
    private let leadingTrailingConstant: CGFloat = Constants.cvPadding

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

    private let similarBooksLabel: UILabel = {
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 40)
        label.text = "Libros similares"
        return label
    }()

    private let bookTitleLabel: UILabel = {
        let font = UIFont.preferredCustomFontWith(weight: .medium, size: 16)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 45, numberOfLines: 2)
        return label
    }()

    private lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
//        stack.spacing = 3
        stack.addArrangedSubview(similarBooksLabel)
        stack.addArrangedSubview(bookTitleLabel)
        stack.addArrangedSubview(UIView())
        stack.setCustomSpacing(3, after: similarBooksLabel)
        return stack
    }()

    private lazy var horzStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
//        stack.spacing = horzStackSpacing
        stack.spacing = Constants.cvPadding
        stack.addArrangedSubview(vertStackWithImage)
        stack.addArrangedSubview(vertStackWithLabels)
        return stack
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Utils.powderGrayBackgroundColor
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

        if let image = book.coverImage {
            let resizedImage = image.resizeFor(targetHeight: imageHeight)

            if imageView.bounds.width != image.size.width {
                imageViewWidthConstraint.constant = resizedImage.size.width
            }
            imageView.image = resizedImage
        }
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

//        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
//        let subtrahend = imageHeight + leadingTrailingConstant * 2 + horzStackSpacing
//        NSLayoutConstraint.activate([
//            vertStackWithLabels.widthAnchor.constraint(equalTo: widthAnchor, constant: -subtrahend),
//
//        ])

        vertStackWithImage.translatesAutoresizingMaskIntoConstraints = false
        vertStackWithImage.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true

        horzStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horzStack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.cvPadding),
            horzStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.cvPadding),
//            horzStack.heightAnchor.constraint(equalTo: vertStackWithLabels.heightAnchor),
            horzStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConstant),
            horzStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConstant)
        ])
    }

}
