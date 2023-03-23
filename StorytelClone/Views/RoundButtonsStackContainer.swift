//
//  RoundButtonsStackContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 22/3/23.
//

import UIKit

class RoundButtonsStackContainer: UIStackView {
    
    static let buttonWidthAndHeight = UIScreen.main.bounds.width * 0.12

//    private let buttonWidthAndHeight = UIScreen.main.bounds.width * 0.12
//    private let topAndBottomPadding: CGFloat = 60


    
//    private lazy var stackWithRoundButtons: UIStackView = {
//       let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.distribution = .equalSpacing
//        stack.spacing = 45
//        [viewWithListenButton, viewWithSaveButton].forEach { stack.addArrangedSubview($0)}
//        return stack
//    }()
    
    private lazy var viewWithListenButton: UIView = {
        let view = UIView()
//        view.backgroundColor = .magenta
        view.addSubview(listenButton)
        view.addSubview(listenLabel)
        return view
    }()
    
    private let listenButton: UIButton = {
        let button = UIButton()
        button.tintColor = Utils.tintColor
        var config = UIButton.Configuration.filled()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        let image = UIImage(systemName: "headphones", withConfiguration: symbolConfig)?.withTintColor(Utils.customBackgroundLight)
        config.image = image
//        config.imagePlacement = .all
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 9.5, bottom: 10, trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private let listenLabel: UILabel = {
        let font = Utils.sectionSubtitleFont
//        let font = UIFont.preferredCustomFontWith(weight: .regular, size: 15)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: nil, withScaledFont: false)
        label.text = "Listen"
        label.textAlignment = .center
//        label.backgroundColor = .yellow
        return label
    }()
    
    private lazy var viewWithSaveButton: UIView = {
        let view = UIView()
//        view.backgroundColor = .magenta
//        let font = UIFont.preferredCustomFontWith(weight: .regular, size: 17)
//        let label = UILabel.createLabel(withFont: font, maximumPointSize: nil, withScaledFont: false)
//        label.text = "Save"
        view.addSubview(saveButton)
        view.addSubview(saveLabel)
        return view
    }()
    
//    private let saveButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = UIColor.label
////        var config = UIButton.Configuration.bordered()
//        var config = UIButton.Configuration.bordered()
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
//        let image = UIImage(systemName: "heart", withConfiguration: symbolConfig)
//        config.image = image
//
////        config.imagePlacement = .all
//        config.cornerStyle = .capsule
//        config.baseBackgroundColor = .clear
////        config.baseBackgroundColor = Utils.customBackgroundColor
//        button.configuration = config
//
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.label.cgColor
//        return button
//    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
//        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
//        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = RoundButtonsStackContainer.buttonWidthAndHeight / 2
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 9.5, leading: 9.5, bottom: 8.5, trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private let saveLabel: UILabel = {
        let font = Utils.sectionSubtitleFont
//        let font = UIFont.preferredCustomFontWith(weight: .regular, size: 15)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: nil, withScaledFont: false)
        label.text = "Save"
        label.textAlignment = .center
//        label.backgroundColor = .yellow
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .blue
        axis = .horizontal
//        alignment = .center
        distribution = .fillProportionally
//        distribution = .equalSpacing
        spacing = RoundButtonsStackContainer.buttonWidthAndHeight - 10
        addArrangedSubview(viewWithListenButton)
        addArrangedSubview(viewWithSaveButton)
        translatesAutoresizingMaskIntoConstraints = false
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            saveButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    private func applyConstraints() {
//        let buttonWidthAndHeight = UIScreen.main.bounds.width * 0.12
        let buttonLabelPadding: CGFloat = 15
        
        // Listen button
        listenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listenButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            listenButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            listenButton.topAnchor.constraint(equalTo: viewWithListenButton.topAnchor),
            listenButton.leadingAnchor.constraint(equalTo: viewWithListenButton.leadingAnchor),
            listenButton.bottomAnchor.constraint(equalTo: listenLabel.topAnchor, constant: -buttonLabelPadding)
        ])
        
        listenLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listenLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            listenLabel.centerXAnchor.constraint(equalTo: viewWithListenButton.centerXAnchor),
            listenLabel.bottomAnchor.constraint(equalTo: viewWithListenButton.bottomAnchor)
        ])

        viewWithListenButton.translatesAutoresizingMaskIntoConstraints = false
        viewWithListenButton.widthAnchor.constraint(equalTo: listenButton.widthAnchor).isActive = true
//        viewWithListenButton.trailingAnchor.constraint(equalTo: listenButton.trailingAnchor).isActive = true
//        viewWithListenButton.leadingAnchor.constraint(equalTo: listenButton.leadingAnchor).isActive = true
        
        // Save button
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            saveButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            saveButton.topAnchor.constraint(equalTo: viewWithSaveButton.topAnchor),
            saveButton.leadingAnchor.constraint(equalTo: viewWithSaveButton.leadingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: saveLabel.topAnchor, constant: -buttonLabelPadding)
        ])
        
        saveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
            saveLabel.centerXAnchor.constraint(equalTo: viewWithSaveButton.centerXAnchor),
            saveLabel.bottomAnchor.constraint(equalTo: viewWithSaveButton.bottomAnchor)

        ])
        
        viewWithSaveButton.translatesAutoresizingMaskIntoConstraints = false
        viewWithSaveButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor).isActive = true
        
        // Set height of stack view
//        viewWithSaveButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
    }
    
    
//    private func applyConstraints() {
////        let buttonWidthAndHeight = UIScreen.main.bounds.width * 0.12
//        let buttonLabelPadding: CGFloat = 15
//
//        // Listen button
//        listenButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            listenButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
//            listenButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
////            listenButton.topAnchor.constraint(equalTo: viewWithListenButton.topAnchor, constant: topAndBottomPadding),
//            listenButton.topAnchor.constraint(equalTo: viewWithListenButton.topAnchor),
//            listenButton.bottomAnchor.constraint(equalTo: listenLabel.topAnchor, constant: -buttonLabelPadding)
//        ])
//
//        listenLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            listenLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
////            listenLabel.bottomAnchor.constraint(equalTo: viewWithListenButton.bottomAnchor, constant: -topAndBottomPadding)
//            listenLabel.bottomAnchor.constraint(equalTo: viewWithListenButton.bottomAnchor)
//        ])
//
//        viewWithListenButton.translatesAutoresizingMaskIntoConstraints = false
//        viewWithListenButton.widthAnchor.constraint(equalTo: listenButton.widthAnchor).isActive = true
//
//        NSLayoutConstraint.activate([
////            viewWithListenButton.topAnchor.constraint(equalTo: listenButton.topAnchor),
////            viewWithListenButton.bottomAnchor.constraint(equalTo: listenLabel.bottomAnchor),
//        ])
//
//        // Save button
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            saveButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
//            saveButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
////            saveButton.topAnchor.constraint(equalTo: viewWithSaveButton.topAnchor, constant: topAndBottomPadding),
//            saveButton.topAnchor.constraint(equalTo: viewWithSaveButton.topAnchor),
//            saveButton.bottomAnchor.constraint(equalTo: saveLabel.topAnchor, constant: -buttonLabelPadding)
//        ])
//
//        saveLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            saveLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
////            saveLabel.bottomAnchor.constraint(equalTo: viewWithSaveButton.bottomAnchor, constant: -topAndBottomPadding)
//            saveLabel.bottomAnchor.constraint(equalTo: viewWithSaveButton.bottomAnchor)
//
//        ])
//
//        viewWithSaveButton.translatesAutoresizingMaskIntoConstraints = false
//        viewWithSaveButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor).isActive = true
//
//        // Set height of stack view
//        viewWithSaveButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//
//    }
    
}
