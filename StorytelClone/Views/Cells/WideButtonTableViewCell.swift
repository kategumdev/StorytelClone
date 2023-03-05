//
//  WideImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/2/23.
//

import UIKit

//protocol WideButtonTableViewCellDelegate: AnyObject {
//  func wideButtonTableViewCellDidTapButton(
//    _ cell: WideButtonTableViewCell, forSectionKind sectionKind: SectionKind)
//}

class WideButtonTableViewCell: UITableViewCell {

    static let identifier = "WideImageTableViewCell"

    static let heightForRow: CGFloat = Utils.calculatedSquareCoverSize.height
    
//    weak var delegate: WideButtonTableViewCellDelegate?
    
    private var timeLayoutSubviewsIsBeingCalled = 0

    private lazy var dimViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
    
    private lazy var wideButton: CellButton = {
        let button = CellButton()
        button.backgroundColor = UIColor(red: 200/255, green: 217/255, blue: 228/255, alpha: 1)
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
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(wideButton)
        contentView.addSubview(wideButtonLabel)
        contentView.addSubview(dimViewForButtonAnimation)
        addButtonUpdateHandler()
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timeLayoutSubviewsIsBeingCalled += 1
        if timeLayoutSubviewsIsBeingCalled == 2 {
            addGradient()
        }
    }
    
    // MARK: - Helper methods
    
    func configureFor(sectionKind: SectionKind, withCallbackForButton callback: @escaping WideButtonCallbackClosure) {
        wideButton.sectionKind = sectionKind
        wideButton.wideButtonCallbackClosure = callback
//        self.sectionKind = sectionKind
        if sectionKind == .seriesCategoryButton {
            wideButtonLabel.text = "Series"
        } else {
            wideButtonLabel.text = "Todas las categorías"
        }
    }
    
    private func addButtonUpdateHandler() {
        wideButton.configurationUpdateHandler = { [weak self] theButton in
            guard let self = self else { return }
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self.dimViewForButtonAnimation.alpha = 0.1
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if self.isHighlighted {
                        print("Button held for more than 2 seconds, do not perform action")
                        self.wideButton.isButtonTooLongInHighlightedState = true
                    }
                }
                self.wideButton.buttonTimer = timer
                
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = .identity
                    self.dimViewForButtonAnimation.alpha = 0
                })
            }
        }
    }
    
    private func applyConstraints() {
        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
        dimViewForButtonAnimation.fillSuperview()
        
        let width = UIScreen.main.bounds.width - Constants.cvPadding * 2
        wideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wideButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            wideButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            wideButton.widthAnchor.constraint(equalToConstant: width),
            wideButton.heightAnchor.constraint(equalToConstant: Utils.calculatedSquareCoverSize.width)
        ])
        
        wideButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wideButtonLabel.leadingAnchor.constraint(equalTo: wideButton.leadingAnchor, constant: Constants.cvPadding),
            wideButtonLabel.bottomAnchor.constraint(equalTo: wideButton.bottomAnchor, constant: -Constants.cvPadding),
        ])

    }
    
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
