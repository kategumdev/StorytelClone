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
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.adjustsFontForContentSizeCategory = true
        let font = Utils.tableViewSectionSubtitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 21)
        label.font = scaledFont
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.isUserInteractionEnabled = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalCentering
        [self.bookTitleLabel, self.overviewLabel].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(12.0, after: self.bookTitleLabel)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bookOverviewButton)
        bookOverviewButton.addSubview(stackView)
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
    
    func configureTextWith(bookTitle: String, overview: String) {
        bookTitleLabel.attributedText = NSAttributedString(string: bookTitle).withLineHeightMultiple(0.8)
        overviewLabel.attributedText = NSAttributedString(string: overview).withLineHeightMultiple(0.9)
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
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchorConstant: CGFloat = (Utils.calculatedSmallSquareImageCoverSize.height - imageTopConstant) + paddingBetweenImageAndStack
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: bookOverviewButton.topAnchor, constant: topAnchorConstant),
            stackView.leadingAnchor.constraint(equalTo: bookOverviewButton.leadingAnchor, constant: leadingConstant),
            stackView.widthAnchor.constraint(equalTo: bookOverviewButton.widthAnchor, constant: -(leadingConstant * 2))
        ])
 
        let buttonTopConstant: CGFloat = 15 // Creates padding between section header label and this button
        bookOverviewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookOverviewButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonTopConstant),
            bookOverviewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
            bookOverviewButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -(Constants.cvPadding * 2)),
            bookOverviewButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20)
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
