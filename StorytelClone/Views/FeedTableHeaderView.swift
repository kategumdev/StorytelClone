//
//  FeedTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

class FeedTableHeaderView: UIView {
    
    static let labelBottomAnchor: CGFloat = 4
    static let labelTopAnchorForGreeting: CGFloat = 15
    static let labelTopAnchorForCategory: CGFloat = 19
    static let labelLeadingAnchor = Constants.cvPadding
    static let labelTrailingAnchor: CGFloat = 46
    
    lazy var topAnchorConstraint = headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: FeedTableHeaderView.labelTopAnchorForGreeting)
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        
        label.adjustsFontForContentSizeCategory = true
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 31)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 50)
        label.font = scaledFont
        return label
    }()
    
    let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        view.alpha = 0
        return view
    }()
    
    //MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
        addSubview(dimView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FeedTableHeaderView.labelLeadingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -FeedTableHeaderView.labelBottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -FeedTableHeaderView.labelTrailingAnchor)
        ])
        topAnchorConstraint.isActive = true
        
        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.fillSuperview()
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
            headerLabel.text = "Good morning"
        } else if afternoonRange.contains(time) {
            headerLabel.text = "Good afternoon"
        } else {
            headerLabel.text = "Good evening"
        }
    }

}
