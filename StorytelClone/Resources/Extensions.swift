//
//  Extensions.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

extension UIFont {
    static let sectionSubtitle = createScaledFontWith(textStyle: .footnote, weight: .regular, basePointSize: 13, maximumPointSize: 34)
    static let sectionSubtitleSemibold = createScaledFontWith(textStyle: .footnote, weight: .semibold, basePointSize: 13, maximumPointSize: 38)
    
    static let navBarTitle = createScaledFontWith(textStyle: .callout, weight: .semibold, basePointSize: 16, maximumPointSize: 18)
    static let navBarTitleLargeMaxSize = createScaledFontWith(textStyle: .callout, weight: .semibold, basePointSize: 16)
    
    static let customCalloutRegular = UIFont.createScaledFontWith(textStyle: .callout, weight: .regular, basePointSize: 16)
    
    static func createScaledFontWith(textStyle: UIFont.TextStyle, weight: UIFont.Weight, basePointSize: CGFloat, maximumPointSize: CGFloat? = nil) -> UIFont {

        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.size: basePointSize,
            UIFontDescriptor.AttributeName.family: "Avenir Next",
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight
            ]
        ])

        let fontToScale = UIFont(descriptor: fontDescriptor, size: 0)

        if let maximumPointSize = maximumPointSize {
            let scaledFont = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: fontToScale, maximumPointSize: maximumPointSize)
            return scaledFont
        } else {
            let scaledFont = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: fontToScale)
            return scaledFont
        }

    }
    
    static func createStaticFontWith(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.family: "Avenir Next",
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight
            ]
        ])
        let font = UIFont(descriptor: fontDescriptor, size: size)
        return font
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
//        paragraphStyle.maximumLineHeight = 5
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
}

extension UILabel {
    
    static func createLabelWith(font: UIFont, numberOfLines: Int = 1, textColor: UIColor = .label, text: String = "") -> UILabel {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        label.textColor = textColor
        label.text = text
        label.font = font
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
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : UIFont.navBarTitle]
        appearance.configureWithTransparentBackground()
        
        // Set custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is set to the largest one
        
        let pointSize = UIFont.navBarTitle.fontDescriptor.pointSize
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .semibold, scale: .large)
//        let config = UIImage.SymbolConfiguration(pointSize: Utils.navBarTitleFont.pointSize, weight: .semibold, scale: .large)
        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: config)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        return appearance
    }()
    
    static let transparentNavBarAppearanceWithVisibleTitle: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : UIFont.navBarTitle]
        appearance.configureWithTransparentBackground()
        
        // Set custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is se to the largest one
        let pointSize = UIFont.navBarTitle.fontDescriptor.pointSize
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .semibold, scale: .large)
        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: config)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        return appearance
    }()
    
    static let visibleNavBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .tertiaryLabel
        appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font: UIFont.navBarTitle]
        
        // Set custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is set to the largest one
        let pointSize = UIFont.navBarTitle.fontDescriptor.pointSize
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .semibold, scale: .large)
        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: config)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        return appearance
    }()
    
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
    
    func adjustAppearanceTo(currentOffsetY: CGFloat, offsetYToCompareTo: CGFloat, withVisibleTitleWhenTransparent: Bool = false) {
        
        if currentOffsetY > offsetYToCompareTo && self.navigationBar.standardAppearance != UINavigationController.visibleNavBarAppearance {
            self.navigationBar.standardAppearance = UINavigationController.visibleNavBarAppearance
            // print("navBar to visible")
        }

        if currentOffsetY <= offsetYToCompareTo {
            self.makeNavbarAppearance(transparent: true, withVisibleTitle: withVisibleTitleWhenTransparent)
        }

    }
}

extension UIColor {
    
    static let pinkCategoryColor = UIColor(red: 234/255, green: 131/255, blue: 136/255, alpha: 1)

}
