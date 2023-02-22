//
//  WideImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/2/23.
//

import UIKit

class WideImageTableViewCell: UITableViewCell {

    static let identifier = "WideImageTableViewCell"
    static let heightForRow: CGFloat = Constants.calculatedSquareCoverSize.height + Constants.gapBetweenSectionsOfTablesWithSquareCovers
    
    private var timeLayoutSubviewsIsBeingCalled = 0
    
    private let gradientView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.bookCoverCornerRadius
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 200/255, green: 217/255, blue: 228/255, alpha: 1)
//        view.isOpaque = false
        return view
    }()
    
    // MARK: - View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(gradientView)
        
        applyConstraints()
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timeLayoutSubviewsIsBeingCalled += 1
        if timeLayoutSubviewsIsBeingCalled == 2 {
            addGradient()
        }
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        let width = UIScreen.main.bounds.width - Constants.cvLeftRightPadding * 2
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
           gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
           gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvLeftRightPadding),
           gradientView.widthAnchor.constraint(equalToConstant: width),
           gradientView.heightAnchor.constraint(equalToConstant: Constants.calculatedSquareCoverSize.width)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.locations = [0.4, 1]
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
    
}
