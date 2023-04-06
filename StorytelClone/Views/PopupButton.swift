//
//  PopupView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/4/23.
//

import UIKit

class PopupButton: UIButton {
    // MARK: - Instance properties
    private let leadingPadding: CGFloat = Constants.cvPadding
    private let trailingPadding: CGFloat = Constants.cvPadding - 2

//    private let customLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: nil, withScaledFont: false, textColor: Utils.customBackgroundColor!, text: "")
    let customLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: nil, withScaledFont: false, textColor: Utils.customBackgroundColor!, text: "")

    
    private let labelImagePadding: CGFloat = 8
    private let imageWidthHeight: CGFloat = 20
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Utils.customBackgroundColor
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
        imageView.image = image
        return imageView
    }()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "popupBackground")
        layer.cornerRadius = Constants.bookCoverCornerRadius
        tintColor = UIColor.label.withAlphaComponent(0.7)
        
        addSubview(customLabel)
        customLabel.text = "Added to Bookshelf"
        addSubview(customImageView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstant = leadingPadding + trailingPadding + labelImagePadding + imageWidthHeight
        NSLayoutConstraint.activate([
            customLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
            customLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            customLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPadding)
        ])
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.widthAnchor.constraint(equalToConstant: imageWidthHeight),
            customImageView.heightAnchor.constraint(equalToConstant: imageWidthHeight),
            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customImageView.leadingAnchor.constraint(equalTo: customLabel.trailingAnchor, constant: labelImagePadding)
        ])
    }
    
}



