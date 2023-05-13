//
//  BookDetailsScrollViewCustomButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 13/5/23.
//

import UIKit

class BookDetailsScrollViewCustomButton: UIButton {
    
    static let imageHeight: CGFloat = 10
    
    static func getScaledFont() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: Utils.navBarTitleFont, maximumPointSize: 45)
    }
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.tintColor = .label.withAlphaComponent(0.8)
        imageView.contentMode = .scaleAspectFit
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: imageHeight, weight: .semibold)
//        let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
//        customImageView.image = image
        return imageView
    }()
    
    private let customTitleLabel: UILabel = {
        let label = UILabel()
        label.font = getScaledFont()
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = .yellow
        return label
    }()
    
    private var symbolImageName: String?
    
    init(symbolImageName: String?) {
        self.symbolImageName = symbolImageName
        super.init(frame: .zero)
        tintColor = .label.withAlphaComponent(0.8)
        addSubview(customImageView)
        configureImage()

        addSubview(customTitleLabel)
        applyConstraints()
        backgroundColor = .blue
        sizeToFit()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(customImageView)
//        addSubview(customTitleLabel)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configureWith(text: String, symbolImageName: String?) {
//        customTitleLabel.text = text
//
//        guard let symbolImageName = symbolImageName else { return }
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: BookDetailsScrollViewCustomButton.imageHeight, weight: .semibold)
//        let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
//        customImageView.image = image
//    }
    
    func configureWith(text: String) {
        print("set text")
//        customTitleLabel.text = text
        customTitleLabel.attributedText = NSAttributedString(string: text).withLineHeightMultiple(0.1)
        customTitleLabel.sizeToFit()
        
        // Customize font and line spacing
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 0  // Adjust line spacing as desired
//        paragraphStyle.
//
//        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
//        customTitleLabel.attributedText = attributedString
        
        
    }
    
    func updateScaledFont() {
        customTitleLabel.font = BookDetailsScrollViewCustomButton.getScaledFont()
    }
    
    private func configureImage() {
        guard let symbolImageName = symbolImageName else { return }
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: BookDetailsScrollViewCustomButton.imageHeight, weight: .semibold)
        let image = UIImage(systemName: symbolImageName, withConfiguration: symbolConfig)
        customImageView.image = image
    }
    
    private func applyConstraints() {
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.widthAnchor.constraint(equalToConstant: BookDetailsScrollViewCustomButton.imageHeight),
            customImageView.heightAnchor.constraint(equalToConstant: BookDetailsScrollViewCustomButton.imageHeight),
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: customTitleLabel.leadingAnchor, constant: -4),
//            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            customImageView.centerYAnchor.constraint(equalTo: customTitleLabel.centerYAnchor)
        ])
        
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTitleLabel.topAnchor.constraint(equalTo: topAnchor),

            customTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            customTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
//        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        customTitleLabel.fillSuperview()
//
    }
    
}
