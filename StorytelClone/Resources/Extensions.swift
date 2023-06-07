//
//  Extensions.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit
import SDWebImage
import NaturalLanguage

extension UIFont {
    
    static let customFootnoteRegular = createScaledFontWith(textStyle: .footnote, weight: .regular, maxPointSize: 34)
    static let customFootnoteSemibold = createScaledFontWith(textStyle: .footnote, weight: .semibold, maxPointSize: 38)
    static let customCalloutSemibold = createScaledFontWith(textStyle: .callout, weight: .semibold, maxPointSize: 45)
    static let customNavBarTitle = createScaledFontWith(textStyle: .callout, weight: .semibold, maxPointSize: 18)

    static func createScaledFontWith(textStyle: UIFont.TextStyle, weight: UIFont.Weight, basePointSize: CGFloat? = nil, maxPointSize: CGFloat? = nil) -> UIFont {
        
        var baseSize: CGFloat
        if let basePointSize = basePointSize {
            baseSize = basePointSize
        } else {
            switch textStyle {
            case .largeTitle: baseSize = 34
            case .title1: baseSize = 28
            case .title2: baseSize = 22
            case .title3: baseSize = 20
            case .headline: baseSize = 17
            case .body: baseSize = 17
            case .callout: baseSize = 16
            case .subheadline: baseSize = 15
            case .footnote: baseSize = 13
            case .caption1: baseSize = 12
            case .caption2: baseSize = 11
            default:
                fatalError("Not valid UIFont.TextStyle")
            }
        }

        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.size: baseSize,
            UIFontDescriptor.AttributeName.family: "Avenir Next",
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight
            ]
        ])

        let fontToScale = UIFont(descriptor: fontDescriptor, size: 0)

        if let maxPointSize = maxPointSize {
            let scaledFont = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: fontToScale, maximumPointSize: maxPointSize)
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
//        let targetHeight: CGFloat = targetHeight
        let targetWidth = targetHeight * imageRatio
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            
            self.draw(in: CGRect(origin: .zero, size: targetSize), blendMode: .normal, alpha: targetAlpha)
        }
        return resizedImage
    }
    
//    static let placeholderBookCoverImage: UIImage? = {
//        let image = UIImage(systemName: "book")
//        return image
//    }()
    
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
    
    static let customBackButtonImage: UIImage? = {
//        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .large)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        return image
    }()
    
    static let transparentNavBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : UIFont.customNavBarTitle]
        appearance.configureWithTransparentBackground()
        
        // Use custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is set to the largest one
        appearance.setBackIndicatorImage(customBackButtonImage, transitionMaskImage: customBackButtonImage)
        return appearance
    }()
    
    static let transparentNavBarAppearanceWithVisibleTitle: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : UIFont.customNavBarTitle]
        appearance.configureWithTransparentBackground()
        
        // Use custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is set to the largest one
        appearance.setBackIndicatorImage(customBackButtonImage, transitionMaskImage: customBackButtonImage)
        return appearance
    }()
    
    static let visibleNavBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .tertiaryLabel
        appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font: UIFont.customNavBarTitle]
        
        // Set custom backIndicatorImage to avoid constraints conflicts (system ones) when dynamic font size is set to the largest one
        appearance.setBackIndicatorImage(customBackButtonImage, transitionMaskImage: customBackButtonImage)
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
    
    static let customBackgroundColor = UIColor(named: "customBackground")
    static let customBackgroundLight = UIColor(red: 253/255, green: 251/255, blue: 250/255, alpha: 1)
    static let customTintColor = UIColor(cgColor: CGColor(red: 255/255, green: 56/255, blue: 0/255, alpha: 1))
    static let seeAllButtonColor = UIColor.label.withAlphaComponent(0.7)
    static let powderGrayBackgroundColor = UIColor(named: "backgroundBookOverview")
    static let unactiveElementColor: UIColor = .secondaryLabel.withAlphaComponent(0.4)
    
    // For category buttons and WideButtonTableViewCell
    static let customCyan = UIColor(red: 0, green: 163/255, blue: 173/255, alpha: 1)
    static let customDarkGray = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
    static let customOrange = UIColor(red: 243/255, green: 101/255, blue: 0, alpha: 1)
    static let appleGreen = UIColor(red: 111/255, green: 152/255, blue: 11/255, alpha: 1)
    static let pineGreen = UIColor(red: 63/255, green: 148/255, blue: 78/255, alpha: 1)
    static let purpleBlue = UIColor(red: 69/255, green: 25/255, blue: 162/255, alpha: 1)
    static let skyBlue = UIColor(red: 39/255, green: 149/255, blue: 213/255, alpha: 1)
    static let electricBlue = UIColor(red: 0, green: 54/255, blue: 195/255, alpha: 1)
    static let fuchsia = UIColor(red: 195/255, green: 1/255, blue: 121/255, alpha: 1)
}

extension UITabBar {
    
    static let tabBarHeight: CGFloat = {
        var height: CGFloat = 0.0
        if let scene = UIApplication.shared.connectedScenes.first,
           let windowScene = scene as? UIWindowScene,
           let mainWindow = windowScene.windows.first
        {
            height = mainWindow.safeAreaInsets.bottom + UITabBarController().tabBar.frame.size.height
        }
        return height
    }()
}

extension UIImageView {
    
    static let placeholderImage = UIImage(named: "placeholderCover")
    
    func setImageForBook(_ book: Book, defaultImageViewHeight: CGFloat, imageViewWidthConstraint: NSLayoutConstraint) {
        self.contentMode = .scaleAspectFill
        
        if let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
            self.sd_setImage(with: imageURL, placeholderImage: UIImageView.placeholderImage) { [weak self] image, error, cachType, url in
                if let image = image {
                    self?.setImage(image, defaultImageViewHeight: defaultImageViewHeight, imageViewWidthConstraint: imageViewWidthConstraint, forBook: book)
                }
            }
        } else {
            self.setImage(book.coverImage, defaultImageViewHeight: defaultImageViewHeight, imageViewWidthConstraint: imageViewWidthConstraint, forBook: book)
            #warning("When not using hardcoded book objects, pass nil instead of book.coverImage")
        }
    }
    
    func setImage(_ image: UIImage?, defaultImageViewHeight: CGFloat, imageViewWidthConstraint: NSLayoutConstraint, forBook book: Book) {
        let defaultImageViewWidth = defaultImageViewHeight
        
        // Configure image view and set placeholder image if passed image is nil
        guard let image = image else {
            var newImageWidth: CGFloat = defaultImageViewWidth // for square image view
            if book.titleKind == .ebook {
                newImageWidth = defaultImageViewWidth * 0.65 // for rectangle image view
            }
            
            if imageViewWidthConstraint.constant != newImageWidth {
                imageViewWidthConstraint.constant = newImageWidth
            }

            self.image = UIImageView.placeholderImage
            return
        }
        
        // Configure image view, resize and set passed image
        let resizedImage = image.resizeFor(targetHeight: defaultImageViewHeight)
        let resizedImageWidth = resizedImage.size.width

        if resizedImageWidth < defaultImageViewWidth {
            if imageViewWidthConstraint.constant != resizedImageWidth {
                imageViewWidthConstraint.constant = resizedImageWidth
            }
        } else if imageViewWidthConstraint.constant != defaultImageViewWidth {
            imageViewWidthConstraint.constant = defaultImageViewWidth
        }

        self.image = resizedImage
    }
    
}

extension String {
    
    func formatDate() -> String {
        let dateString = self

        let inputOutputFormats: [String : String] = [
            "yyyy-MM-dd'T'HH:mm:ssZ" : "dd MMM yyyy",
            "yyyy-MM'T'HH:mm:ssZ" : "MMM yyyy",
            "yyyy'T'HH:mm:ssZ" : "yyyy",
            "yyyy-MM-dd" : "dd MMM yyyy",
            "yyyy-MM" : "MMM yyyy",
            "yyyy" : "yyyy"
        ]

        let inputFormatter = DateFormatter()
        let outputFormatter = DateFormatter()
        var formattedDate: String?
        
        for (inputFormat, outputFormat) in inputOutputFormats {
            inputFormatter.dateFormat = inputFormat
            
            if let date = inputFormatter.date(from: dateString) {
                outputFormatter.dateFormat = outputFormat
                formattedDate = outputFormatter.string(from: date)
                break
            }
        }
        return formattedDate ?? "Unknown"
    }
    
    func removeHTMLTags() -> String {
        let cleanedText1 = self.replacingOccurrences(of: "<br />", with: "\n")
        let cleanedText2 = cleanedText1.replacingOccurrences(of: "&#xa0;", with: " ")
        let cleanedText3 = cleanedText2.replacingOccurrences(of: "&gt;", with: "")
        let cleanedText4 = cleanedText3.replacingOccurrences(of: "\n ", with: "\n")
        
        #warning("Maybe replacing occurences can be done only once")
        
        let htmlTagPattern = "<.*?>"
        let regex = try! NSRegularExpression(pattern: htmlTagPattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: cleanedText4.utf16.count)
        let cleanText = regex.stringByReplacingMatches(in: cleanedText4, options: [], range: range, withTemplate: "")
        return cleanText
    }
    
    func convertLanguageCodeIntoString() -> String? {
        let languageCode = self
        let language = Locale.current.localizedString(forIdentifier: languageCode)
        return language
    }
    
    
    func detectLanguage() -> String? {
        let text = self
        
        let languageRecognizer = NLLanguageRecognizer()
        languageRecognizer.processString(text)
        let languageCode = languageRecognizer.dominantLanguage?.rawValue
        
        return languageCode?.convertLanguageCodeIntoString()
    }
    
}
//extension UIButton {
//
//    func setImageForBook(_ book: Book, buttonWidthConstraint: NSLayoutConstraint, completion: @escaping () -> Void) {
////        self.contentMode = .scaleAspectFill
//
//        if let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
//            self.sd_setImage(with: imageURL, for: .normal, placeholderImage: UIImageView.placeholderImage) { [weak self] image, error, cachType, url in
//                if let image = image {
////                    self?.setImage(image, buttonWidthConstraint: buttonWidthConstraint, forBook: book)
//                    self?.setImage(image, buttonWidthConstraint: buttonWidthConstraint, forBook: book, completion: completion)
//
////                    completion()
//                }
//            }
////            self.sd_setImage(with: imageURL, for: .normal, placeholderImage: UIImageView.placeholderImage)
//        } else {
////            self.setImage(book.coverImage, buttonWidthConstraint: buttonWidthConstraint, forBook: book)
//            self.setImage(book.coverImage, buttonWidthConstraint: buttonWidthConstraint, forBook: book, completion: completion)
//            #warning("When not using hardcoded book objects, pass nil instead of book.coverImage")
//        }
//    }
//
//    func setImage(_ image: UIImage?, buttonWidthConstraint: NSLayoutConstraint, forBook book: Book, completion: @escaping () -> Void) {
////        let defaultButtonWidth = defaultButtonHeight
////        let defaultButtonWidth = Constants.largeSquareBookCoverSize.width
//        let defaultImageWidth = Constants.largeSquareBookCoverSize.width
//
//        // Configure button and set placeholder image if passed image is nil
//        guard let image = image else {
//            var newImageWidth: CGFloat = defaultImageWidth // for square image view
//            if book.titleKind == .ebook {
//                newImageWidth = defaultImageWidth * 0.65 // for rectangle image view
//            }
//
//            if buttonWidthConstraint.constant != newImageWidth {
//                buttonWidthConstraint.constant = newImageWidth
//            }
//
//            completion()
//            self.setImage(image, for: .normal)
////            self.configuration?.image = UIImageView.placeholderImage
////            self.image = UIImageView.placeholderImage
//            return
//        }
//
//        // Configure button, resize and set passed image
//        let defaultImageHeight = Constants.largeSquareBookCoverSize.width
//
//        let resizedImage = image.resizeFor(targetHeight: defaultImageHeight)
//        let resizedImageWidth = resizedImage.size.width
//
//        if resizedImageWidth < defaultImageWidth {
//            if buttonWidthConstraint.constant != resizedImageWidth {
//                buttonWidthConstraint.constant = resizedImageWidth
//            }
//        } else if buttonWidthConstraint.constant != defaultImageWidth {
//            buttonWidthConstraint.constant = defaultImageWidth
//        }
//
//        print("resized image size: \(resizedImage.size)")
//
////        self.configuration?.image = resizedImage
////        self.setNeedsLayout()
////        self.layoutIfNeeded()
//        completion()
//        self.setImage(resizedImage, for: .normal)
////        self.setNeedsLayout()
////        self.layoutIfNeeded()
////        self.layoutIfNeeded()
////        self.image = resizedImage
//    }
//}



