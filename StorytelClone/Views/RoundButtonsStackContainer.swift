//
//  RoundButtonsStackContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 22/3/23.
//

import UIKit

class RoundButtonsStackContainer: UIStackView {
    
    static let buttonWidthAndHeight = UIScreen.main.bounds.width * 0.12
    
    private let bookKind: TitleKind

    private lazy var viewWithListenButton: UIView = {
        let view = UIView()
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
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 9.5, bottom: 10, trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private let listenLabel: UILabel = {
        let font = Utils.sectionSubtitleFont
        let label = UILabel.createLabel(withFont: font, maximumPointSize: nil, withScaledFont: false)
        label.text = "Listen"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var viewWithReadButton: UIView = {
       let view = UIView()
        view.addSubview(readButton)
        view.addSubview(readLabel)
        return view
    }()
    
    private let readButton: UIButton = {
        let button = UIButton()
        button.tintColor = Utils.tintColor
        var config = UIButton.Configuration.filled()
        let image = UIImage(named: "glasses")?.withTintColor(Utils.customBackgroundLight)
        
        // Resize image
        if let image = image {
            let resizedImage = image.resizeFor(targetHeight: 25)
            config.image = resizedImage
        }
 
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8.5, leading: 9.5, bottom: 9.5, trailing: 8.5)
        button.configuration = config
        return button
    }()
    
    private let readLabel: UILabel = {
        let font = Utils.sectionSubtitleFont
        let label = UILabel.createLabel(withFont: font, maximumPointSize: nil, withScaledFont: false)
        label.text = "Read"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var viewWithSaveButton: UIView = {
        let view = UIView()
        view.addSubview(saveButton)
        view.addSubview(saveLabel)
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
//        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
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
        let label = UILabel.createLabel(withFont: font, maximumPointSize: nil, withScaledFont: false)
        label.text = "Save"
        label.textAlignment = .center
        return label
    }()
    
    private var hasListenButton = true
    private var hasReadButton = true
    
    
    init(forBookKind bookKind: TitleKind) {
        self.bookKind = bookKind
        super.init(frame: .zero)
        configureSelf()
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
    
    private func configureSelf() {
        axis = .horizontal
//        alignment = .center
        distribution = .fillProportionally
//        distribution = .equalSpacing
        spacing = RoundButtonsStackContainer.buttonWidthAndHeight - 10
        
        if bookKind == .audioBookAndEbook {
            addArrangedSubview(viewWithListenButton)
            addArrangedSubview(viewWithReadButton)
            addArrangedSubview(viewWithSaveButton)
        } else if bookKind == .audiobook {
            hasReadButton = false
            addArrangedSubview(viewWithListenButton)
            addArrangedSubview(viewWithSaveButton)
        } else {
            hasListenButton = false
            addArrangedSubview(viewWithReadButton)
            addArrangedSubview(viewWithSaveButton)
        }
        
    }
    
   
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
//        let buttonWidthAndHeight = UIScreen.main.bounds.width * 0.12
        let buttonLabelPadding: CGFloat = 15

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

        if hasListenButton {
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
        }

        if hasReadButton {
            // Read button
            readButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                readButton.heightAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                readButton.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                readButton.topAnchor.constraint(equalTo: viewWithReadButton.topAnchor),
                readButton.leadingAnchor.constraint(equalTo: viewWithReadButton.leadingAnchor),
                readButton.bottomAnchor.constraint(equalTo: readLabel.topAnchor, constant: -buttonLabelPadding)
            ])

            readLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                readLabel.widthAnchor.constraint(equalToConstant: RoundButtonsStackContainer.buttonWidthAndHeight),
                readLabel.centerXAnchor.constraint(equalTo: viewWithReadButton.centerXAnchor),
                readLabel.bottomAnchor.constraint(equalTo: viewWithReadButton.bottomAnchor)
            ])

            viewWithReadButton.translatesAutoresizingMaskIntoConstraints = false
            viewWithReadButton.widthAnchor.constraint(equalTo: readButton.widthAnchor).isActive = true
        }

        // Set height of stack view
//        viewWithSaveButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

    }
    
}
