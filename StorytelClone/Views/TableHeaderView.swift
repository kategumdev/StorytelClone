//
//  FeedTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

class TableHeaderView: UIView {
    // MARK: - Instance properties
    private let stackBottomAnchor: CGFloat = 14
    private let stackTopAnchorForGreeting: CGFloat = 15
    let stackTopAnchorForCategoryOrSectionTitle: CGFloat = 19
    private let stackLeadingAnchor = Constants.cvPadding
    private let stackTrailingAnchor: CGFloat = Constants.cvPadding
    
    lazy var stackTopAnchorConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: stackTopAnchorForGreeting)
    lazy var stackBottomAnchorConstraint = stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -stackBottomAnchor)

    private let headerLabel = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 31), maximumPointSize: 50, numberOfLines: 4)

    private lazy var bookTitleForSimilarLabel = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 13), maximumPointSize: 32, numberOfLines: 2)

    private lazy var sectionDescriptionLabel = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .regular, size: 13), maximumPointSize: 32, numberOfLines: 3)
    
    private lazy var followSeriesView = FollowSeriesView()

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
    
    func configureWith(seriesTitle: String, numberOfFollowers: Int) {
        headerLabel.text = seriesTitle
        followSeriesView.configureWith(numberOfFollowers: numberOfFollowers)
        stackView.addArrangedSubview(followSeriesView)
        stackView.spacing = 9
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
    
    private func applyConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackLeadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -stackTrailingAnchor)
        ])
        stackTopAnchorConstraint.isActive = true
        stackBottomAnchorConstraint.isActive = true

        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.fillSuperview()
    }

}
