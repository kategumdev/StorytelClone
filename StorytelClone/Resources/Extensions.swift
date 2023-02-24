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
    NSLayoutConstraint.activate(
      [leadingAnchor.constraint(
        equalTo: superview.leadingAnchor,
        constant: constant),
       topAnchor.constraint(
        equalTo: superview.topAnchor,
        constant: constant),
       trailingAnchor.constraint(
        equalTo: superview.trailingAnchor,
        constant: -constant),
       bottomAnchor.constraint(
        equalTo: superview.bottomAnchor,
        constant: -constant)]
        )
    }
}
