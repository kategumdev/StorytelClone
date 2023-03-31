//
//  FeedTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

class TableHeaderView: UIView {

//    // MARK: - Static properties
//    static let labelBottomAnchor: CGFloat = 4
//    static let labelTopAnchorForGreeting: CGFloat = 15
//    static let labelTopAnchorForCategoryOrSectionTitle: CGFloat = 19
//    static let labelLeadingAnchor = Constants.cvPadding
//    static let labelTrailingAnchor: CGFloat = 46

    // MARK: - Instance properties
    private let stackBottomAnchor: CGFloat = 4
    private let stackTopAnchorForGreeting: CGFloat = 15
    let stackTopAnchorForCategoryOrSectionTitle: CGFloat = 19
    private let stackLeadingAnchor = Constants.cvPadding
//    private let stackTrailingAnchor: CGFloat = 46
    private let stackTrailingAnchor: CGFloat = Constants.cvPadding
    
    lazy var stackTopAnchorConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: stackTopAnchorForGreeting)


    private let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping

        label.adjustsFontForContentSizeCategory = true
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 31)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 50)
        label.font = scaledFont
        return label
    }()

    private lazy var bookTitleForSimilarLabel: UILabel = {
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 32, numberOfLines: 2)
        return label
    }()

    private lazy var sectionDescriptionLabel: UILabel = {
        let font = UIFont.preferredCustomFontWith(weight: .regular, size: 13)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 32, numberOfLines: 3)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.addArrangedSubview(headerLabel)
        return stack
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
//        addSubview(headerLabel)
        addSubview(stackView)
        addSubview(dimView)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper methods
    
    func configureWith(title: String) {
        headerLabel.text = title
    }
    
    func configureWith(title: String, bookTitleForSimilar: String) {
        headerLabel.text = title
        bookTitleForSimilarLabel.text = bookTitleForSimilar
        stackView.addArrangedSubview(bookTitleForSimilarLabel)
        stackView.spacing = 9
    }
    
    func configureWith(title: String, sectionDescription: String) {
        headerLabel.text = title
        sectionDescriptionLabel.text = sectionDescription
        stackView.addArrangedSubview(sectionDescriptionLabel)
        stackView.spacing = 15
    }
    
    private func applyConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackLeadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -stackBottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -stackTrailingAnchor)
        ])
        stackTopAnchorConstraint.isActive = true
        
        
        
//        headerLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackLeadingAnchor),
//            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -stackBottomAnchor),
//            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -stackTrailingAnchor)
//        ])
//        topAnchorConstraint.isActive = true

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







//class FeedTableHeaderView: UIView {
//
//    // MARK: - Static properties
//    static let labelBottomAnchor: CGFloat = 4
//    static let labelTopAnchorForGreeting: CGFloat = 15
//    static let labelTopAnchorForCategoryOrSectionTitle: CGFloat = 19
//    static let labelLeadingAnchor = Constants.cvPadding
//    static let labelTrailingAnchor: CGFloat = 46
//
//    // MARK: - Instance properties
//    lazy var topAnchorConstraint = headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: FeedTableHeaderView.labelTopAnchorForGreeting)
//
//    let headerLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 4
//        label.lineBreakMode = .byWordWrapping
//
//        label.adjustsFontForContentSizeCategory = true
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 31)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 50)
//        label.font = scaledFont
//        return label
//    }()
//
//    let dimView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Utils.customBackgroundColor
//        view.alpha = 0
//        return view
//    }()
//
//    //MARK: - View life cycle
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(headerLabel)
//        addSubview(dimView)
//        applyConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Helper methods
//    private func applyConstraints() {
//        headerLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FeedTableHeaderView.labelLeadingAnchor),
//            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -FeedTableHeaderView.labelBottomAnchor),
//            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -FeedTableHeaderView.labelTrailingAnchor)
//        ])
//        topAnchorConstraint.isActive = true
//
//        dimView.translatesAutoresizingMaskIntoConstraints = false
//        dimView.fillSuperview()
//    }
//
//     func updateGreetingsLabel() {
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        // This line garanties that time will always be formatted the same for correct calculations
//        dateFormatter.locale = Locale(identifier: "en_ES")
//        dateFormatter.timeStyle = .none
//        dateFormatter.dateFormat = "HH"
//
//        guard let time = Int(dateFormatter.string(from: date)) else { return }
//
//        let morningRange: [Int] = [5, 6, 7, 8, 9, 10, 11]
//        let afternoonRange: [Int] = [12, 13, 14, 15, 16]
//
//        if morningRange.contains(time) {
//            headerLabel.text = "Good morning"
//        } else if afternoonRange.contains(time) {
//            headerLabel.text = "Good afternoon"
//        } else {
//            headerLabel.text = "Good evening"
//        }
//    }
//
//}
