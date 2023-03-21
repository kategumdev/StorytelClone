//
//  Extensions.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

extension UIFont {
    
    static func preferredCustomFontWith(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        
        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.size: size,
            UIFontDescriptor.AttributeName.family: "Avenir Next"
        ])

        let weightedFontDescriptor = fontDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight
            ]
        ])
        
        return UIFont(descriptor: weightedFontDescriptor, size: 0)
    }
}

extension UIView {
    func fillSuperview(withConstant constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant)
        ])
    }
}

extension NSAttributedString {
    func withLineHeightMultiple(_ multiple: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineHeightMultiple = multiple
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
}

extension UILabel {
    
//    static func createLabel(withFont font: UIFont, maximumPointSize: CGFloat, numberOfLines: Int = 1) -> UILabel {
//        let label = UILabel()
//        label.numberOfLines = numberOfLines
//        label.lineBreakMode = .byTruncatingTail
//        label.adjustsFontForContentSizeCategory = true
//        let font = font
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: maximumPointSize)
//        label.font = scaledFont
//        return label
//    }
    
    static func createLabel(withFont font: UIFont, maximumPointSize: CGFloat, numberOfLines: Int = 1, withScaledFont: Bool = true) -> UILabel {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        
        if withScaledFont {
//            let font = font
            let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: maximumPointSize)
            label.font = scaledFont
        } else {
            label.font = font
        }
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: maximumPointSize)
//        label.font = scaledFont
        return label
    }
    
}

//extension NSAttributedString {
//    func withLineSpacing(_ spacing: CGFloat) -> NSAttributedString {
//        let attributedString = NSMutableAttributedString(attributedString: self)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineBreakMode = .byTruncatingTail
//        paragraphStyle.lineSpacing = spacing
//        attributedString.addAttribute(.paragraphStyle,
//                                      value: paragraphStyle,
//                                      range: NSRange(location: 0, length: string.count))
//        return NSAttributedString(attributedString: attributedString)
//    }
//}
