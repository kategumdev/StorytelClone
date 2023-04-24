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
    
    #warning("Refactor to have only maximumPointSize and no withScaledFont")
    static func createLabel(withFont font: UIFont, maximumPointSize: CGFloat?, numberOfLines: Int = 1, withScaledFont: Bool = true, textColor: UIColor = .label, text: String = "") -> UILabel {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        label.textColor = textColor
        label.text = text
        
        if withScaledFont {
            guard let maximumPointSize = maximumPointSize else { return label }
            let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: maximumPointSize)
            label.font = scaledFont
        } else {
            label.font = font
        }
        return label
    }
    
}

extension UIImage {
    
    // Resize image accounting for its ratio
    func resizeFor(targetHeight: CGFloat, andSetAlphaTo targetAlpha: CGFloat = 1) -> UIImage {
        let imageRatio = self.size.width / self.size.height
        let targetHeight: CGFloat = targetHeight
        let targetWidth = targetHeight * imageRatio
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            
            self.draw(in: CGRect(origin: .zero, size: targetSize), blendMode: .normal, alpha: targetAlpha)
//            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
}

extension Int {
    func shorted() -> String {
        if self >= 1000 && self < 10000 {
            return String(format: "%.1fK", Double(self/100)/10).replacingOccurrences(of: ".0", with: "")
        }
        
        if self >= 10000 && self < 1000000 {
            return "\(self/1000)K"
        }
        
        if self >= 1000000 && self < 10000000 {
            return String(format: "%.1fM", Double(self/100000)/10).replacingOccurrences(of: ".0", with: "")
        }
        
        if self >= 10000000 {
            return "\(self/1000000)M"
        }
        
        return String(self)
    }
}

extension UINavigationController {
    
    static let transparentNavBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : Utils.navBarTitleFontScaled]
        appearance.configureWithTransparentBackground()
        
        // Set custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is se to the largest one
        let config = UIImage.SymbolConfiguration(pointSize: Utils.navBarTitleFont.pointSize, weight: .semibold, scale: .large)
        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: config)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        return appearance
    }()
    
    static let transparentNavBarAppearanceWithVisibleTitle: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : Utils.navBarTitleFontScaled]
        appearance.configureWithTransparentBackground()
        
        // Set custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is se to the largest one
        let config = UIImage.SymbolConfiguration(pointSize: Utils.navBarTitleFont.pointSize, weight: .semibold, scale: .large)
        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: config)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        return appearance
    }()
    
    static let visibleNavBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .tertiaryLabel
        appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : Utils.navBarTitleFontScaled]
        
        // Set custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is set to the largest one
        let config = UIImage.SymbolConfiguration(pointSize: Utils.navBarTitleFont.pointSize, weight: .semibold, scale: .large)
        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: config)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        return appearance
    }()
    
//    func makeNavbarAppearance(transparent: Bool) {
//        if transparent {
//            self.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearance
//            // print("navBar made transparent")
//        } else {
//            self.navigationBar.standardAppearance = UINavigationController.visibleNavBarAppearance
//            // print("navBar made visible")
//        }
//    }
    
//    func makeNavbarAppearance(transparent: Bool, withVisibleTitle: Bool = false) {
//
//        if transparent {
//            let appearance = UINavigationController.transparentNavBarAppearance
//            if withVisibleTitle {
////                var attributes = appearance.titleTextAttributes
//                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : Utils.navBarTitleFontScaled]
////                self.navigationBar.standardAppearance = appearance
//            }
//            self.navigationBar.standardAppearance = appearance
//
////            self.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearance
//            // print("navBar made transparent")
//        } else {
//            self.navigationBar.standardAppearance = UINavigationController.visibleNavBarAppearance
//            // print("navBar made visible")
//        }
//    }
    
    func makeNavbarAppearance(transparent: Bool, withVisibleTitle: Bool = false) {
                
        if transparent && withVisibleTitle {
            self.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearanceWithVisibleTitle
            // print("navBar made transparent with visible title")
        } else if transparent {
            self.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearance
            // print("navBar made transparent")
        } else {
            self.navigationBar.standardAppearance = UINavigationController.visibleNavBarAppearance
            // print("navBar made visible")
        }
        
    }
    
//    func adjustAppearanceTo(currentOffsetY: CGFloat, offsetYToCompareTo: CGFloat) {
//
//        if currentOffsetY > offsetYToCompareTo && self.navigationBar.standardAppearance != UINavigationController.visibleNavBarAppearance {
//            self.navigationBar.standardAppearance = UINavigationController.visibleNavBarAppearance
////            print("to visible")
//        }
//
//        if currentOffsetY <= offsetYToCompareTo && self.navigationBar.standardAppearance != UINavigationController.transparentNavBarAppearance {
//            self.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearance
////            print("to transparent")
//        }
//    }
    
    
    
    
//    func adjustAppearanceTo(currentOffsetY: CGFloat, offsetYToCompareTo: CGFloat, withVisibleTitleWhenTransparent: Bool = false) {
//
//        if currentOffsetY > offsetYToCompareTo && self.navigationBar.standardAppearance != UINavigationController.visibleNavBarAppearance {
//            self.navigationBar.standardAppearance = UINavigationController.visibleNavBarAppearance
////            print("to visible")
//        }
//
//        if currentOffsetY <= offsetYToCompareTo && self.navigationBar.standardAppearance != UINavigationController.transparentNavBarAppearance {
//            self.makeNavbarAppearance(transparent: true, withVisibleTitle: withVisibleTitleWhenTransparent)
//
////            self.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearance
////            print("to transparent")
//        }
//    }
    
    func adjustAppearanceTo(currentOffsetY: CGFloat, offsetYToCompareTo: CGFloat, withVisibleTitleWhenTransparent: Bool = false) {
        
        if currentOffsetY > offsetYToCompareTo && self.navigationBar.standardAppearance != UINavigationController.visibleNavBarAppearance {
            self.navigationBar.standardAppearance = UINavigationController.visibleNavBarAppearance
//            print("to visible")
        }

        if currentOffsetY <= offsetYToCompareTo {
            self.makeNavbarAppearance(transparent: true, withVisibleTitle: withVisibleTitleWhenTransparent)
        }
        
//        if currentOffsetY <= offsetYToCompareTo && self.navigationBar.standardAppearance != UINavigationController.transparentNavBarAppearance {
//            self.makeNavbarAppearance(transparent: true, withVisibleTitle: withVisibleTitleWhenTransparent)

//            self.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearance
//            print("to transparent")
//        }
    }
}
