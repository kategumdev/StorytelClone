//
//  FeedTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

class FeedTableHeaderView: UIView {
    
    var viewHeight: CGFloat = 0

    let greetingsLabel: UILabel = {
        
        let label = UILabel()
        // these two lines and setting preferredMaxLayoutWidth in layoutSubviews() enable changing label to a multilined one
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 31)
        
        // these two lines enable dynamic sizing
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics.default.scaledFont(for: label.font)
        
        label.text = "Good"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(greetingsLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        greetingsLabel.preferredMaxLayoutWidth = self.bounds.width - 50
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        greetingsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let greetingsLabelConstraints = [
            greetingsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            greetingsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
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
        let eveningRange: [Int] = [17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4]
        
        if morningRange.contains(time) {
            greetingsLabel.text = "Good morning"
        } else if afternoonRange.contains(time) {
            greetingsLabel.text = "Good afternoon"
        } else if eveningRange.contains(time) {
            greetingsLabel.text = "Good evening"
        }
        
//        switch time {
//        case 5..<12: greetingsLabel.text = "Good morning"
//        case 12..<17: greetingsLabel.text = "Good afternoon"
//        case 17..<5: greetingsLabel.text = "Good evening"
//        default:
//            fatalError("current date doesn't match any range")
//        }
    }
}
