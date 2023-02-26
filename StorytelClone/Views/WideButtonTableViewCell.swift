//
//  WideImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/2/23.
//

import UIKit

class WideButtonTableViewCell: UITableViewCell {

    static let identifier = "WideImageTableViewCell"
    static let heightForRow: CGFloat = Constants.calculatedSquareCoverSize.height + Constants.gapBetweenSectionsOfTablesWithSquareCovers
    
    private var timeLayoutSubviewsIsBeingCalled = 0
    
    private var buttonTimer: Timer?
    private var isButtonTooLongInHighlightedState = false
    
    private lazy var castViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var wideButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.bookCoverCornerRadius
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 200/255, green: 217/255, blue: 228/255, alpha: 1)
        
        button.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }

            if self.isButtonTooLongInHighlightedState {
                print("do nothing on touchUpInside")
                self.isButtonTooLongInHighlightedState = false

            } else {
                // Invalidate the timer and perform the touchUpInside action
                self.buttonTimer?.invalidate()
                print("DO smth on touchUpInside")
            }

        }), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        button.configuration = config

        button.configurationUpdateHandler = { [weak self] theButton in
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    
                    self?.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self?.castViewForButtonAnimation.alpha = 0.4
                    
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if button.isHighlighted {
                        print("Button held for more than 2 seconds, do not perform action")
                        self?.isButtonTooLongInHighlightedState = true
                    }
                }
                self?.buttonTimer = timer
                
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self?.transform = .identity
                    self?.castViewForButtonAnimation.alpha = 0
                })
            }
            
        }
        
        return button
    }()
    
    let wideButtonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        let font = Utils.wideButtonLabelFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 24)
        label.font = scaledFont
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6// Increase opacity for a stronger shadow effect
        return label
    }()
    
    
    // MARK: - View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(wideButton)
        contentView.addSubview(wideButtonLabel)
        contentView.addSubview(castViewForButtonAnimation)
        applyConstraints()
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        castViewForButtonAnimation.frame = contentView.bounds
        
        timeLayoutSubviewsIsBeingCalled += 1
        if timeLayoutSubviewsIsBeingCalled == 2 {
            addGradient()
        }
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        let width = UIScreen.main.bounds.width - Constants.cvPadding * 2
        
        wideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wideButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            wideButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            wideButton.widthAnchor.constraint(equalToConstant: width),
            wideButton.heightAnchor.constraint(equalToConstant: Constants.calculatedSquareCoverSize.width)
        ])
        
        wideButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wideButtonLabel.leadingAnchor.constraint(equalTo: wideButton.leadingAnchor, constant: 18),
            wideButtonLabel.bottomAnchor.constraint(equalTo: wideButton.bottomAnchor, constant: -18),
        ])

    }

//    private func addGradient() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [
//            UIColor.clear.cgColor,
//            UIColor.black.withAlphaComponent(0.3).cgColor
//        ]
//        gradientLayer.locations = [0.4, 1]
//        gradientLayer.frame = wideButton.bounds
//        wideButton.layer.addSublayer(gradientLayer)
//    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.45).cgColor
        ]
        gradientLayer.locations = [0.4, 1]
        gradientLayer.frame = wideButton.bounds
        wideButton.layer.addSublayer(gradientLayer)
    }
    
}
