//
//  BookWithOverviewCellSubviewsContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 6/3/23.
//

import UIKit

class BookWithOverviewCellSubviewsContainer: UIView {
    // MARK: - Static properties
    static let borderColor = UIColor(named: "borderBookOverview")
    static let backgroundColor = UIColor(named: "backgroundBookOverview")
    
    // MARK: - Instance properties
    let bookOverviewButton: DimViewCellButton = {
        let button = DimViewCellButton()
        button.backgroundColor = backgroundColor
        button.layer.borderColor = borderColor?.cgColor
        button.layer.borderWidth = 0.9
        return button
    }()
    
//    private lazy var dimViewForButtonAnimation: UIView = {
//        let view = UIView()
//        view.backgroundColor = Utils.customBackgroundColor
//        return view
//    }()
    
    private let squareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.bookCoverCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 31)
        label.font = font
        return label
    }()
    
    private let overviewLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 21, numberOfLines: 5)
    
    private lazy var starHorzStackView = StarHorzStackView()
    
    private lazy var vertStackView: UIStackView = {
        let stack = UIStackView()
        stack.isUserInteractionEnabled = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalCentering
        [bookTitleLabel, overviewLabel, starHorzStackView].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(12.0, after: bookTitleLabel)
        stack.setCustomSpacing(15, after: overviewLabel)
        return stack
    }()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bookOverviewButton)
        bookOverviewButton.addSubview(vertStackView)
        addSubview(squareImageView)
//        addSubview(dimViewForButtonAnimation)
        
        bookOverviewButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
//        bookOverviewButton.addConfigurationUpdateHandlerWith(viewToTransform: self, viewToChangeAlpha: dimViewForButtonAnimation)
//        addButtonUpdateHandler()
        applyConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            bookOverviewButton.layer.borderColor = BookWithOverviewCellSubviewsContainer.borderColor?.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Helper methods
    func configureFor(book: Book) {
        let titleString = book.title
        bookTitleLabel.attributedText = NSAttributedString(string: titleString).withLineHeightMultiple(0.8)
        let overviewString = book.overview
        overviewLabel.attributedText = NSAttributedString(string: overviewString).withLineHeightMultiple(0.9)
        
        starHorzStackView.configureForOverviewCellSubviewsContainerWith(book: book)
        squareImageView.image = book.coverImage
        
        bookOverviewButton.book = book
      }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        // These two constraints are used only when creating container for calculation of row height for the cell using this container
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        heightAnchor.constraint(equalTo: bookOverviewButton.heightAnchor, constant: 15).isActive = true
        
//        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
//        dimViewForButtonAnimation.fillSuperview()
        
        let leadingConstant: CGFloat = 24
        let imageTopConstant: CGFloat = 8
        let paddingBetweenImageAndStack: CGFloat = 17
        
        vertStackView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchorConstant: CGFloat = (Utils.calculatedSmallSquareImageCoverSize.height - imageTopConstant) + paddingBetweenImageAndStack
        NSLayoutConstraint.activate([
            vertStackView.topAnchor.constraint(equalTo: bookOverviewButton.topAnchor, constant: topAnchorConstant),
            vertStackView.leadingAnchor.constraint(equalTo: bookOverviewButton.leadingAnchor, constant: leadingConstant),
            vertStackView.widthAnchor.constraint(equalTo: bookOverviewButton.widthAnchor, constant: -(leadingConstant * 2))
        ])
 
        let buttonTopConstant: CGFloat = 15 // Creates padding between section header label and this button
        bookOverviewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookOverviewButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonTopConstant),
            bookOverviewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
            bookOverviewButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -(Constants.cvPadding * 2)),
            bookOverviewButton.bottomAnchor.constraint(equalTo: vertStackView.bottomAnchor, constant: 14)
        ])
        
        squareImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            squareImageView.topAnchor.constraint(equalTo: bookOverviewButton.topAnchor, constant: -imageTopConstant),
            squareImageView.leadingAnchor.constraint(equalTo: bookOverviewButton.leadingAnchor, constant: leadingConstant),
            squareImageView.widthAnchor.constraint(equalToConstant: Utils.calculatedSmallSquareImageCoverSize.width),
            squareImageView.heightAnchor.constraint(equalToConstant: Utils.calculatedSmallSquareImageCoverSize.height)
        ])
    }

}
