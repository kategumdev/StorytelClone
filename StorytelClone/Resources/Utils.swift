//
//  Utils.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/2/23.
//

import UIKit

//typealias BookButtonCallbackClosure = (_ book: Book) -> ()
//typealias WideButtonCallbackClosure = (_ sectionKind: SectionKind) -> ()
//typealias CategoryButtonCallbackClosure = (_ buttonCategory: ButtonCategory) -> ()
typealias ButtonCallbackClosure = (_ item: Any) -> ()

struct Utils {
    
    //MARK: - Fonts
    static let navBarTitleFont = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)
    static let navBarTitleFontScaled = UIFontMetrics.default.scaledFont(for: navBarTitleFont, maximumPointSize: 18)
    
    static let tableViewSectionTitleFont = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)
    static let categoryButtonLabelFont = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)
    
    static let tableViewSectionSubtitleFont = UIFont.preferredCustomFontWith(weight: .regular, size: 13)
    static let wideButtonLabelFont = UIFont.preferredCustomFontWith(weight: .bold, size: 19)
    
    static let customBackgroundColor = UIColor(named: "customBackground")
    
    //MARK: - Colors
    static let pinkCategoryColor = UIColor(red: 234/255, green: 131/255, blue: 136/255, alpha: 1)
    static let coralCategoryColor = UIColor(red: 234/255, green: 114/255, blue: 95/255, alpha: 1)
    static let orangeCategoryColor = UIColor(red: 234/255, green: 156/255, blue: 80/255, alpha: 1)
    static let darkBlueCategoryColor = UIColor(red: 76/255, green: 96/255, blue: 168/255, alpha: 1)
    static let lightBlueCategoryColor = UIColor(red: 199/255, green: 219/255, blue: 231/255, alpha: 1)
    static let yellowCategoryColor = UIColor(red: 237/255, green: 209/255, blue: 106/255, alpha: 1)
    static let peachCategoryColor = UIColor(red: 245/255, green: 202/255, blue: 191/255, alpha: 1)
    static let greenCategoryColor = UIColor(red: 189/255, green: 210/255, blue: 163/255, alpha: 1)
    
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
    
    //MARK: - Calculated Values
    static let calculatedSquareCoverSize: CGSize = {
        let contentViewWidth = UIScreen.main.bounds.width
        let width = (contentViewWidth - Constants.cvPadding * Constants.visibleSquareCvItemsInRow) / Constants.visibleSquareCvItemsInRow
        
        let fullWidth = contentViewWidth + (width / 2)
        let itemWidth = (fullWidth - Constants.cvPadding
                         * Constants.visibleSquareCvItemsInRow) / Constants.visibleSquareCvItemsInRow
    
        let size = CGSize(width: round(itemWidth), height: round(itemWidth))
        return size
    }()
    
//    static let calculatedCvItemSizeSquareCovers: CGSize = {
//        let width = calculatedSquareCoverSize.width
//        let height = calculatedSquareCoverSize.height + BadgeView.badgeTopAnchorPoints
//        let size = CGSize(width: width, height: height)
//        return size
//    }()
    
    static let topPaddingForCvItemWithSquareCovers = BadgeView.badgeTopAnchorPoints + 3
    
    static let calculatedCvItemSizeSquareCovers: CGSize = {
        let width = calculatedSquareCoverSize.width
        let height = calculatedSquareCoverSize.height + topPaddingForCvItemWithSquareCovers
//        let height = calculatedSquareCoverSize.height + BadgeView.badgeTopAnchorPoints + 8
        let size = CGSize(width: width, height: height)
        return size
    }()
    
    static let heightForRowWithHorizontalCv: CGFloat = {
        return calculatedCvItemSizeSquareCovers.height
    }()
    
    static let calculatedCvItemSizeCategory: CGSize = {
        let height = Constants.categoryCvItemHeight
        
        let contentViewWidth = UIScreen.main.bounds.size.width
        let width = round(contentViewWidth - (Constants.cvPadding * 3)) / 2

        let size = CGSize(width: width, height: height)
        return size
    }()
    
}
