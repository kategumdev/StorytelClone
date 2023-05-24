//
//  Utils.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/2/23.
//

import UIKit

enum ScrollDirection {
    case forward
    case back
}

struct Utils {

    //MARK: - Colors
    static let customBackgroundColor = UIColor(named: "customBackground")
    static let customBackgroundLight = UIColor(red: 253/255, green: 251/255, blue: 250/255, alpha: 1)
    
    static let tintColor = UIColor(cgColor: CGColor(red: 255/255, green: 56/255, blue: 0/255, alpha: 1))
  
    static let seeAllButtonColor = UIColor.label.withAlphaComponent(0.7)
    
    static let powderGrayBackgroundColor = UIColor(named: "backgroundBookOverview")
    
    static let unactiveElementColor: UIColor = .secondaryLabel.withAlphaComponent(0.4)
    
    //MARK: - Calculated Values
    static let calculatedSquareCoverSize: CGSize = {
        let contentViewWidth = UIScreen.main.bounds.width
        let width = (contentViewWidth - Constants.commonHorzPadding * Constants.visibleHorzCvItemsInRow) / Constants.visibleHorzCvItemsInRow
        
        let fullWidth = contentViewWidth + (width / 2)
        let itemWidth = (fullWidth - Constants.commonHorzPadding
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
        
        let widthForContent = contentViewWidth - ((Constants.paddingForHorzCvLargeCovers * 2) + Constants.commonHorzPadding + Constants.visiblePartOfThirdLargeCover)
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
    
    static func layoutTableHeaderView(_ tableHeader: UIView, inTableView tableView: UITableView) {
        //        resultsTable.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = true
        tableHeader.translatesAutoresizingMaskIntoConstraints = true
        let size = tableHeader.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        if tableHeader.frame.size.height != size.height {
//                        print("header frame adjusted, height \(size.height)")
            tableHeader.frame.size.height = size.height
            //            filterTableHeader.frame.size.width = resultsTable.bounds.width
            tableView.tableHeaderView = tableHeader
        }
    }

}
