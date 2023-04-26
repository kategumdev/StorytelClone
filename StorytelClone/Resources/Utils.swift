//
//  Utils.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/2/23.
//

import UIKit

typealias ButtonCallback = (_ item: Any) -> ()
typealias SelectedTitleCallback = (_ title: Title) -> ()

enum ScrollDirection {
    case forward
    case back
}

struct Utils {
    
    //MARK: - Fonts
    static let navBarTitleFont = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)

    static let navBarTitleFontScaled = UIFontMetrics.default.scaledFont(for: navBarTitleFont, maximumPointSize: 18)
    
    static let sectionTitleFont = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)

    static let categoryButtonLabelFont = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)
    
    static let sectionSubtitleFont = UIFont.preferredCustomFontWith(weight: .regular, size: 13)
    static let wideButtonLabelFont = UIFont.preferredCustomFontWith(weight: .bold, size: 19)
    
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
    

    //MARK: - Colors
    static let customBackgroundColor = UIColor(named: "customBackground")
    static let customBackgroundLight = UIColor(red: 253/255, green: 251/255, blue: 250/255, alpha: 1)
    
    static let tintColor = UIColor(cgColor: CGColor(red: 255/255, green: 56/255, blue: 0/255, alpha: 1))
    
    static let pinkCategoryColor = UIColor(red: 234/255, green: 131/255, blue: 136/255, alpha: 1)
    static let coralCategoryColor = UIColor(red: 234/255, green: 114/255, blue: 95/255, alpha: 1)
    static let orangeCategoryColor = UIColor(red: 234/255, green: 156/255, blue: 80/255, alpha: 1)
    static let darkBlueCategoryColor = UIColor(red: 76/255, green: 96/255, blue: 168/255, alpha: 1)
    static let lightBlueCategoryColor = UIColor(red: 199/255, green: 219/255, blue: 231/255, alpha: 1)
    static let yellowCategoryColor = UIColor(red: 237/255, green: 209/255, blue: 106/255, alpha: 1)
    static let peachCategoryColor = UIColor(red: 245/255, green: 202/255, blue: 191/255, alpha: 1)
    static let greenCategoryColor = UIColor(red: 189/255, green: 210/255, blue: 163/255, alpha: 1)
    
    static let seeAllButtonColor = UIColor.label.withAlphaComponent(0.7)
    
    static let powderGrayBackgroundColor = UIColor(named: "backgroundBookOverview")
    
    //MARK: - Calculated Values
    static let calculatedSquareCoverSize: CGSize = {
        let contentViewWidth = UIScreen.main.bounds.width
        let width = (contentViewWidth - Constants.cvPadding * Constants.visibleHorzCvItemsInRow) / Constants.visibleHorzCvItemsInRow
        
        let fullWidth = contentViewWidth + (width / 2)
        let itemWidth = (fullWidth - Constants.cvPadding
                         * Constants.visibleHorzCvItemsInRow) / Constants.visibleHorzCvItemsInRow
    
        let size = CGSize(width: round(itemWidth), height: round(itemWidth))
        return size
    }()

    static let topPaddingForCvItemWithSquareCovers = BadgeView.badgeTopAnchorPoints + 3
    
    static let calculatedCvItemSizeSquareCovers: CGSize = {
        let width = calculatedSquareCoverSize.width
        let height = calculatedSquareCoverSize.height + topPaddingForCvItemWithSquareCovers
        let size = CGSize(width: width, height: height)
        return size
    }()

    static let heightForRowWithHorizontalCv: CGFloat = {
        return calculatedCvItemSizeSquareCovers.height
    }()
    
    static let calculatedHorzCvItemSizeLargeCovers: CGSize = {
        let contentViewWidth = UIScreen.main.bounds.width
        let visiblePartOfThirdCover = 14
        
        let widthForContent = contentViewWidth - ((Constants.paddingForHorzCvLargeCovers * 2) + Constants.cvPadding + Constants.visiblePartOfThirdLargeCover)
        let itemWidth = widthForContent / (Constants.visibleHorzCvItemsInRow - 1)
 
        let roundedItemWidth = round(itemWidth)

        // Get height for 2:3 aspect ratio
        let height = ((3/2) * roundedItemWidth) + Constants.posterAndLargeCoversCellTopPadding
        let size = CGSize(width: roundedItemWidth, height: height)
        return size
    }()
    
    static let heightForRowWithHorzCvLargeCovers: CGFloat = {
        return calculatedHorzCvItemSizeLargeCovers.height
    }()
    
    static let heightForRowWithWideButton: CGFloat = Utils.calculatedSquareCoverSize.height

    static let calculatedSmallSquareImageCoverSize: CGSize = {
        let width = round(4/5 * calculatedSquareCoverSize.width)
        let height = width
        return CGSize(width: width, height: height)
    }()
    
    static func playHaptics(withStyle style: UIImpactFeedbackGenerator.FeedbackStyle = .light, andIntensity intensity: CGFloat? = nil) {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        
        if let intensity = intensity {
            impactFeedbackGenerator.impactOccurred(intensity: intensity)
        } else {
            impactFeedbackGenerator.impactOccurred()
        }
    }

}
