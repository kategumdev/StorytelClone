//
//  FeedTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

class TableHeaderView: UIView {
    // MARK: - Instance properties
    private let headerLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .title1, weight: .semibold, basePointSize: 31, maximumPointSize: 50)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 4)
        return label
    }()

    private lazy var bookTitleForSimilarLabel = UILabel.createLabelWith(font: UIFont.navBarTitleLargeMaxSize, numberOfLines: 2)

    private lazy var sectionDescriptionLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .footnote, weight: .regular, basePointSize: 13, maximumPointSize: 32)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 3)
        return label
    }()

    private lazy var followSeriesView = FollowSeriesView()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.addArrangedSubview(headerLabel)
        return stack
    }()

    lazy var stackTopAnchorConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 19)
    lazy var stackBottomAnchorConstraint = stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)

    lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        view.alpha = 0
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods
    func configureWithDimView(andText text: String) {
        headerLabel.text = text
        addSubview(dimView)
        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.fillSuperview()
    }

    func configureFor(tableSection: TableSection, titleModel: Title?) {

        if let series = titleModel as? Series {
            headerLabel.text = series.title
            followSeriesView.configureWith(series: series)
            stackView.addArrangedSubview(followSeriesView)
            stackView.spacing = 9
        } else if let tag = titleModel as? Tag {
            headerLabel.text = tag.tagTitle
        } else {
            headerLabel.text = tableSection.sectionTitle
        }

        if let book = titleModel as? Book {
            bookTitleForSimilarLabel.text = book.title
            stackView.addArrangedSubview(bookTitleForSimilarLabel)
            stackView.spacing = 9
        }

        if let sectionDescription = tableSection.sectionDescription {
            sectionDescriptionLabel.text = sectionDescription
            stackView.addArrangedSubview(sectionDescriptionLabel)
            stackView.spacing = 15
        }
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

    // MARK: - Helper methods
    private func applyConstraints() {
        let stackLeadingAndTrailingConstant = Constants.commonHorzPadding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackLeadingAndTrailingConstant),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -stackLeadingAndTrailingConstant),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -stackLeadingAndTrailingConstant * 2)
        ])
        stackTopAnchorConstraint.isActive = true
        stackBottomAnchorConstraint.isActive = true

        translatesAutoresizingMaskIntoConstraints = false
        // Avoid constraint's conflict when header is added to table view
        for constraint in constraints {
            constraint.priority = UILayoutPriority(750)
        }
    }
    
}
