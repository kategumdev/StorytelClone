//
//  BookDetailsView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/3/23.
//

import UIKit

class BookDetailsView: UIView {

    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 2
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.layer.borderWidth = 0.26
        imageView.clipsToBounds = true
        return imageView
    }()
    
//    let bookTitleLabel: UILabel = {
//        let label = UILabel()
//        let font = Utils.wideButtonLabelFont
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 24)
//        label.font = scaledFont
//        return label
//    }()
    
    private let bookTitleLabel: UILabel = UILabel.createLabel(withFont: Utils.wideButtonLabelFont, maximumPointSize: 45, numberOfLines: 2, withScaledFont: true)
    
    
    
//    private let authorLabel: UILabel = {
//        let label = UILabel()
//
//        let attributedString = NSMutableAttributedString(string: "By: Sarah J. Maas")
//        let font1 = UIFont.preferredCustomFontWith(weight: .medium, size: 17)
//        let scaledFont1 = UIFontMetrics.default.scaledFont(for: font1, maximumPointSize: 45)
//        let byAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont1, .foregroundColor: UIColor.red]
//
//        let font2 = Utils.navBarTitleFont
//        let scaledFont2 = UIFontMetrics.default.scaledFont(for: font2, maximumPointSize: 45)
//        let authorNameAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont2, .foregroundColor: UIColor.black]
//
//        attributedString.addAttributes(byAttributes, range: NSRange(location: 0, length: 3))
//        attributedString.addAttributes(authorNameAttributes, range: NSRange(location: 3, length: attributedString.length - 3))
//
//        label.attributedText = attributedString
//        return label
//    }()
    
    private let authorLabel = UILabel()
    
    private func updateAuthorLabel(withName name: String) {
        let attributedString = NSMutableAttributedString(string: "By: \(name)")
        let font1 = UIFont.preferredCustomFontWith(weight: .medium, size: 16)
        let scaledFont1 = UIFontMetrics.default.scaledFont(for: font1, maximumPointSize: 45)
        let byAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont1, .foregroundColor: UIColor.red]
        
        let font2 = Utils.navBarTitleFont
        let scaledFont2 = UIFontMetrics.default.scaledFont(for: font2, maximumPointSize: 45)
        let authorNameAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont2, .foregroundColor: UIColor.black]

        attributedString.addAttributes(byAttributes, range: NSRange(location: 0, length: 3))
        attributedString.addAttributes(authorNameAttributes, range: NSRange(location: 3, length: attributedString.length - 3))
        
        authorLabel.attributedText = attributedString
    }
    
    private let narratorLabel = UILabel()
    
    private func updateNarratorLabel(withName name: String) {
        let attributedString = NSMutableAttributedString(string: "With: \(name)")
        let font1 = UIFont.preferredCustomFontWith(weight: .medium, size: 17)
        let scaledFont1 = UIFontMetrics.default.scaledFont(for: font1, maximumPointSize: 45)
        let byAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont1, .foregroundColor: UIColor.red]
        
        let font2 = Utils.navBarTitleFont
        let scaledFont2 = UIFontMetrics.default.scaledFont(for: font2, maximumPointSize: 45)
        let authorNameAttributes: [NSAttributedString.Key: Any] = [.font: scaledFont2, .foregroundColor: UIColor.black]

        attributedString.addAttributes(byAttributes, range: NSRange(location: 0, length: 5))
        attributedString.addAttributes(authorNameAttributes, range: NSRange(location: 5, length: attributedString.length - 5))
        
        narratorLabel.attributedText = attributedString
    }
    
    private lazy var viewWithShowSeriesButton: UIView = {
       let view = UIView()
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.borderWidth = 0.5
        view.addSubview(showSeriesButton)
        return view
    }()
    
    private lazy var showSeriesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Part 1 in Cazadores de sombras. Las últimas horas", for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
//        button.titleLabel?.font = scaledFont
        button.titleLabel?.font = font
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        // Set leading image
        let leadingSymbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let leadingImage = UIImage(systemName: "rectangle.stack", withConfiguration: leadingSymbolConfig)
        button.setImage(leadingImage, for: .normal)
//        button.contentHorizontalAlignment = .trailing
        
//        let trailingImageView = UIImageView(frame: CGRect(x: bounds.maxX - 30,
//                                                          y: (button.titleLabel?.bounds.midY)! - 5,
//                                                              width: 20,
//                                                              height: frame.height - 10))
//        trailingImageView.image?.withRenderingMode(.alwaysOriginal)
//        trailingImageView.image = leftImage
//        trailingImageView.contentMode = .scaleAspectFit
//        trailingImageView.layer.masksToBounds = true
//        addSubview(trailingImageView)
        
        return button
    }()

    
    
    
    
    
}
