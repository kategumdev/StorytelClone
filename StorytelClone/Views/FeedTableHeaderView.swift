//
//  FeedTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

class FeedTableHeaderView: UIView {
    
    static let labelBottomAnchor: CGFloat = 4
    static let labelTopAnchor: CGFloat = 15
    static let labelLeadingAnchor = Constants.cvPadding
    static let labelTrailingAnchor: CGFloat = 46
    
    private let greetingsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 31)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 50)
        label.font = scaledFont
        return label
    }()
    
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
        NSLayoutConstraint.activate([
            greetingsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FeedTableHeaderView.labelLeadingAnchor),
            greetingsLabel.topAnchor.constraint(equalTo: topAnchor, constant: FeedTableHeaderView.labelTopAnchor),
            greetingsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -FeedTableHeaderView.labelBottomAnchor),
            greetingsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -FeedTableHeaderView.labelTrailingAnchor)
        ])
    }
    
     func updateGreetingsLabel() {
        let date = Date()
        let dateFormatter = DateFormatter()
        // This line garanties that time will always be formatted the same for correct calculations
        dateFormatter.locale = Locale(identifier: "en_ES")
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "HH"

        guard let time = Int(dateFormatter.string(from: date)) else { return }
        
        let morningRange: [Int] = [5, 6, 7, 8, 9, 10, 11]
        let afternoonRange: [Int] = [12, 13, 14, 15, 16]
        
        if morningRange.contains(time) {
            greetingsLabel.text = "Good morning"
        } else if afternoonRange.contains(time) {
            greetingsLabel.text = "Good afternoon"
        } else {
            greetingsLabel.text = "Good evening"
        }
    }

}
