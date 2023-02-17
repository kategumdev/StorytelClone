//
//  Extensions.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

//extension UIFont {
//  func withWeight(_ weight: UIFont.Weight) -> UIFont {
//    let newDescriptor = fontDescriptor.addingAttributes([.traits: [
//      UIFontDescriptor.TraitKey.weight: weight]
//    ])
//    return UIFont(descriptor: newDescriptor, size: pointSize)
//  }
//}
//
//
//extension UIFont {
//    static func withWeightAndSize(weight fontWeight: UIFont.Weight, size fontSize: CGFloat) -> UIFont {
//
//        var descriptor = UIFontDescriptor(name: "Nelvetica Neue", size: fontSize)
//        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : fontWeight]])
//        let font = UIFont(descriptor: descriptor, size: fontSize)
//        return font
//    }
//}

//extension UIFont {
//    static func preferredCustomFont(forTextStyle textStyle: TextStyle, weight: Weight) -> UIFont {
//        let defaultDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
//        let fontSize = defaultDescriptor.pointSize
//
//        let fontDescriptor = UIFontDescriptor(fontAttributes: [
//            UIFontDescriptor.AttributeName.size: fontSize,
//            UIFontDescriptor.AttributeName.family: "Avenir Next"
//        ])
//
//        // Add the font weight to the descriptor
//        let weightedFontDescriptor = fontDescriptor.addingAttributes([
//            UIFontDescriptor.AttributeName.traits: [
//                UIFontDescriptor.TraitKey.weight: weight
//            ]
//        ])
//        return UIFont(descriptor: weightedFontDescriptor, size: 0)
//    }
//}

extension UIFont {
    static func preferredCustomFontWith(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        
        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.size: size,
            UIFontDescriptor.AttributeName.family: "Avenir Next"
        ])

        // Add the font weight to the descriptor
        let weightedFontDescriptor = fontDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight
            ]
        ])
        return UIFont(descriptor: weightedFontDescriptor, size: 0)
    }
}
