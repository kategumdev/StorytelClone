//
//  Utils.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/2/23.
//

import UIKit

typealias SeeAllButtonCallback = () -> ()

enum ScrollDirection {
    case forward
    case back
}

struct Utils {
    static func playHaptics(
        withStyle style: UIImpactFeedbackGenerator.FeedbackStyle = .light,
        andIntensity intensity: CGFloat? = nil
    ) {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        
        if let intensity = intensity {
            impactFeedbackGenerator.impactOccurred(intensity: intensity)
        } else {
            impactFeedbackGenerator.impactOccurred()
        }
    }
    
    static func layoutTableHeaderView(_ tableHeader: UIView, inTableView tableView: UITableView) {
        tableHeader.translatesAutoresizingMaskIntoConstraints = true
        let size = tableHeader.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if tableHeader.bounds.size.height != size.height {
            tableHeader.frame.size.height = size.height
            tableView.tableHeaderView = tableHeader
        }
    }
}
