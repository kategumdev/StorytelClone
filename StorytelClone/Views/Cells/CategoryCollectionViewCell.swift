//
//  CategoryCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
        
    // MARK: - Instance properties
    private var categoryOfButton: ButtonCategory?
    
    private lazy var dimViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
    
    private lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let font = Utils.categoryButtonLabelFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 20)
        label.font = scaledFont
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6// Increase opacity for a stronger shadow effect
        return label
    }()
    
    private lazy var cellButton: CellButton = {
        let button = CellButton()
        button.addSubview(categoryTitleLabel)
        return button
    }()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellButton)
        contentView.addSubview(dimViewForButtonAnimation)
        addButtonUpdateHandler()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CategoryCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Helper methods
    func configure(withColor color: UIColor, categoryOfButton category: ButtonCategory, callback: @escaping ButtonCallback ) {
        cellButton.backgroundColor = color
        cellButton.categoryButton = category
        cellButton.callback = callback
        categoryTitleLabel.text = category.rawValue
    }
    
    private func addButtonUpdateHandler() {
        cellButton.configurationUpdateHandler = { [weak self] theButton in
            guard let self = self else { return }
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self.dimViewForButtonAnimation.alpha = 0.1
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if self.isHighlighted {
                        print("Button held for more than 2 seconds, do not perform action")
                        self.cellButton.isButtonTooLongInHighlightedState = true
                    }
                }
                self.cellButton.buttonTimer = timer
                
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = .identity
                    self.dimViewForButtonAnimation.alpha = 0
                })
            }
        }
    }
    
    private func applyConstraints() {
        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
        dimViewForButtonAnimation.fillSuperview()

        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.fillSuperview()
        
        categoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTitleLabel.leadingAnchor.constraint(equalTo: cellButton.leadingAnchor, constant: Constants.cvPadding),
            categoryTitleLabel.bottomAnchor.constraint(equalTo: cellButton.bottomAnchor, constant: -(Constants.cvPadding - 4)),
            categoryTitleLabel.trailingAnchor.constraint(equalTo: cellButton.trailingAnchor, constant: -Constants.cvPadding)
        ])
    }
    
}
