//
//  FeedTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

class FeedTableHeaderView: UIView {
    
    static let greetingsLabelBottomAnchorConstant: CGFloat = 4
    static let greetingsLabelTopAnchorConstant: CGFloat = 15

    private static func getScaledFontForGreetingsLabel() -> UIFont {
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 31)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 50)
        return scaledFont
    }
    
    static func createGreetingsLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 46
        label.adjustsFontForContentSizeCategory = true
        label.font = FeedTableHeaderView.getScaledFontForGreetingsLabel()
        return label
    }
    
    let greetingsLabel = createGreetingsLabel()
    
    //MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(greetingsLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        greetingsLabel.translatesAutoresizingMaskIntoConstraints = false
        let greetingsLabelConstraints = [
            greetingsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            greetingsLabel.topAnchor.constraint(equalTo: topAnchor, constant: FeedTableHeaderView.greetingsLabelTopAnchorConstant),
            greetingsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -FeedTableHeaderView.greetingsLabelBottomAnchorConstant),
            greetingsLabel.widthAnchor.constraint(lessThanOrEqualToConstant: greetingsLabel.preferredMaxLayoutWidth)
            
        ]
        NSLayoutConstraint.activate(greetingsLabelConstraints)
    }
    
     func updateGreetingsLabel() {
        let date = Date()
        let dateFormatter = DateFormatter()
        // this line garanties that time will always be formatted the same for correct calculations
        dateFormatter.locale = Locale(identifier: "en_ES")
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "HH"

        guard let time = Int(dateFormatter.string(from: date)) else { return }
        
        let morningRange: [Int] = [5, 6, 7, 8, 9, 10, 11]
        let afternoonRange: [Int] = [12, 13, 14, 15, 16]
//        let eveningRange: [Int] = [17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4]
        
        if morningRange.contains(time) {
            greetingsLabel.text = "Good morning"
        } else if afternoonRange.contains(time) {
            greetingsLabel.text = "Good afternoon"
        } else {
            greetingsLabel.text = "Good evening"
        }
        
    }

}
