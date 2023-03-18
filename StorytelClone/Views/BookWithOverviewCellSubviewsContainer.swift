//
//  BookWithOverviewCellSubviewsContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 6/3/23.
//

import UIKit

class BookWithOverviewCellSubviewsContainer: UIView {
    
    static let borderColor = UIColor(named: "borderBookOverview")
    static let backgroundColor = UIColor(named: "backgroundBookOverview")
    
    let bookOverviewButton: CellButton = {
        let button = CellButton()
        button.backgroundColor = backgroundColor
        button.layer.borderColor = borderColor?.cgColor
        button.layer.borderWidth = 0.9
        return button
    }()
    
    private lazy var dimViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
    
    let squareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.bookCoverCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 31)
        label.font = font
        return label
    }()
    
    let overviewLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 21, numberOfLines: 5)
    
//    let overviewLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 5
//        label.adjustsFontForContentSizeCategory = true
//        let font = Utils.sectionSubtitleFont
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 21)
//        label.font = scaledFont
//        return label
//    }()
    
    let starView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 18).isActive = true
        view.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.label.withAlphaComponent(0.7)
       
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2).isActive = true
        
        return view
    }()
    
    let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
//        imageView.contentMode = .center
        imageView.tintColor = UIColor.label.withAlphaComponent(0.7)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        return imageView
    }()
    
    let ratingLabel: UILabel = {
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.sizeToFit()
        return label
    }()
    
//    let ratingLabel: UILabel = {
//       let label = UILabel()
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 16)
//        label.font = scaledFont
//        label.adjustsFontForContentSizeCategory = true
//        label.textColor = UIColor.secondaryLabel
//        label.sizeToFit()
//        return label
//    }()
    
    let vertBarLabel: UILabel = {
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
    
    let categoryLabel: UILabel = {
        let font = UIFont.preferredCustomFontWith(weight: .medium, size: 11)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 16)
        label.textColor = UIColor.label.withAlphaComponent(0.7)
        label.sizeToFit()
        return label
    }()
    
//    let categoryLabel: UILabel = {
//        let label = UILabel()
//        let font = UIFont.preferredCustomFontWith(weight: .medium, size: 11)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 16)
//        label.font = scaledFont
//        label.adjustsFontForContentSizeCategory = true
//        label.textColor = UIColor.label.withAlphaComponent(0.7)
//        label.sizeToFit()
//        return label
//    }()

//    let spacerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        return view
//    }()
    
    lazy var horzStackView: UIStackView = {
        let stack = UIStackView()
        stack.isUserInteractionEnabled = false
        stack.axis = .horizontal
        stack.alignment = .center
        [starView, ratingLabel, vertBarLabel, categoryLabel, UIView()].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(4, after: starView)
        stack.setCustomSpacing(6, after: ratingLabel)
        stack.setCustomSpacing(6, after: vertBarLabel)
        return stack
    }()
    
    lazy var vertStackView: UIStackView = {
        let stack = UIStackView()
        stack.isUserInteractionEnabled = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalCentering
        [bookTitleLabel, overviewLabel, horzStackView].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(12.0, after: bookTitleLabel)
        stack.setCustomSpacing(15, after: overviewLabel)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bookOverviewButton)
        bookOverviewButton.addSubview(vertStackView)
        addSubview(squareImageView)
        addSubview(dimViewForButtonAnimation)
        addButtonUpdateHandler()
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
    private func addButtonUpdateHandler() {
        bookOverviewButton.configurationUpdateHandler = { [weak self] theButton in
            guard let self = self else { return }
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self.dimViewForButtonAnimation.alpha = 0.1
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if theButton.isHighlighted {
                        print("Button held for more than 2 seconds, do not perform action")
                        self.bookOverviewButton.isButtonTooLongInHighlightedState = true
                    }
                }
                self.bookOverviewButton.buttonTimer = timer
                
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = .identity
                    self.dimViewForButtonAnimation.alpha = 0
                })
            }
        }
    }
    
    func configureFor(book: Book) {
        let titleString = book.title
        bookTitleLabel.attributedText = NSAttributedString(string: titleString).withLineHeightMultiple(0.8)
        let overviewString = book.overview
        overviewLabel.attributedText = NSAttributedString(string: overviewString).withLineHeightMultiple(0.9)
        
        ratingLabel.text = String(book.rating).replacingOccurrences(of: ".", with: ",")
        categoryLabel.text = book.category.rawValue
        squareImageView.image = book.coverImage
        
        bookOverviewButton.book = book
        
        
    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        // These two constraints are used only when creating container for calculation of row height for the cell using this container
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        heightAnchor.constraint(equalTo: bookOverviewButton.heightAnchor, constant: 15).isActive = true
        
        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
        dimViewForButtonAnimation.fillSuperview()
        
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
