//
//  PopupView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/4/23.
//

import UIKit

class PopupButton: UIButton {

//    private let leadingTrailingPaading: CGFloat = Constants.cvPadding
    
    private let leadingPadding: CGFloat = Constants.cvPadding
    private let trailingPadding: CGFloat = Constants.cvPadding - 2

    private let customLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: nil, withScaledFont: false, textColor: Utils.customBackgroundColor!, text: "")
    
    private let labelImagePadding: CGFloat = 8
    private let imageWidthHeight: CGFloat = 20
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Utils.customBackgroundColor
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
        imageView.image = image
        return imageView
    }()
    
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .green
//        backgroundColor = Utils.reversedCustomBackgroundColor
        backgroundColor = UIColor(named: "popupBackground")
//        backgroundColor = .darkGray
        layer.cornerRadius = Constants.bookCoverCornerRadius
        tintColor = UIColor.label.withAlphaComponent(0.7)
        
        addSubview(customLabel)
        customLabel.text = "Added to Bookshelf"
        addSubview(customImageView)
        applyConstraints()
//        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        customLabel.translatesAutoresizingMaskIntoConstraints = false
//        let widthConstant = leadingTrailingPaading * 2 + imageLabelPadding + imageWidthHeight
        let widthConstant = leadingPadding + trailingPadding + labelImagePadding + imageWidthHeight

        NSLayoutConstraint.activate([
            customLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
            customLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            customLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPadding)
        ])
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.widthAnchor.constraint(equalToConstant: imageWidthHeight),
            customImageView.heightAnchor.constraint(equalToConstant: imageWidthHeight),
            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customImageView.leadingAnchor.constraint(equalTo: customLabel.trailingAnchor, constant: labelImagePadding)
        ])
        
        
    }
    
    
    
    
    
    
    
    
    
    private func configureSelf() {
//        tintColor = Utils.customBackgroundColor
        backgroundColor = .green
        layer.cornerRadius = Constants.bookCoverCornerRadius
        titleLabel?.backgroundColor = .blue
        setTitle("Added to Bookshelf", for: .normal)
        titleLabel?.font = Utils.sectionTitleFont
        titleLabel?.textAlignment = .left
        tintColor = UIColor.label.withAlphaComponent(0.7)
        
//        var config = UIButton.Configuration.filled()

//        config.attributedTitle = AttributedString("Added to Bookshelf")
//        config.attributedTitle?.font = Utils.sectionTitleFont
//        config.attributedTitle?.foregroundColor = UIColor.label.withAlphaComponent(0.7)
//        config.titleAlignment = .leading

//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
//        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
//        config.image = image

        
//        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
//        config.image = UIImage(systemName: "xmark")
//        config.imagePlacement = .trailing
//        config.imagePadding = 10

//        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: Constants.cvPadding, bottom: 10, trailing: Constants.cvPadding)

//        configuration = config
//        sizeToFit()
//        titleLabel?.sizeToFit()

        guard let titleLabel = titleLabel else { return }
        let widthConstant = Constants.cvPadding * 2 + imageView!.bounds.width + 10
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
//            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -150),

//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
//    private func configureSelf() {
////        tintColor = Utils.customBackgroundColor
//        tintColor = .green
////        backgroundColor = .green
//        layer.cornerRadius = Constants.bookCoverCornerRadius
//        titleLabel?.backgroundColor = .blue
////        setTitle("Added to Bookshelf", for: .normal)
//        var config = UIButton.Configuration.filled()
//
//        config.attributedTitle = AttributedString("Added to Bookshelf")
//        config.attributedTitle?.font = Utils.sectionTitleFont
//        config.attributedTitle?.foregroundColor = UIColor.label.withAlphaComponent(0.7)
//        config.titleAlignment = .leading
//
////        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
////        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
////        config.image = image
//
//
//        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
//        config.image = UIImage(systemName: "xmark")
//        config.imagePlacement = .trailing
//        config.imagePadding = 10
//
////        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: Constants.cvPadding, bottom: 10, trailing: Constants.cvPadding)
//
//        configuration = config
////        sizeToFit()
//
////        guard let titleLabel = titleLabel else { return }
////        let widthConstant = Constants.cvPadding * 2 + imageView!.bounds.width + 10
////        titleLabel.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
////            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
////            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
////        ])
//    }
    
//    private func applyConstraints() {
//        guard let titleLabel = titleLabel else { return }
//        let widthConstant = Constants.cvPadding * 2 + 18 + 10
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }

}


//class PopupButton: UIButton {
//
////    private let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: nil, withScaledFont: false, textColor: Utils.customBackgroundColor!, text: "")
//
//    var timesLayout = 1
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureSelf()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
////    override func layoutSubviews() {
////        super.layoutSubviews()
////        if timesLayout == 2 {
////            applyConstraints()
////        }
////
////        timesLayout += 1
////
////    }
//
//
//    private func configureSelf() {
////        tintColor = Utils.customBackgroundColor
//        backgroundColor = .green
//        layer.cornerRadius = Constants.bookCoverCornerRadius
//        titleLabel?.backgroundColor = .blue
//        setTitle("Added to Bookshelf", for: .normal)
//        titleLabel?.font = Utils.sectionTitleFont
//        titleLabel?.textAlignment = .left
//        tintColor = UIColor.label.withAlphaComponent(0.7)
//
////        var config = UIButton.Configuration.filled()
//
////        config.attributedTitle = AttributedString("Added to Bookshelf")
////        config.attributedTitle?.font = Utils.sectionTitleFont
////        config.attributedTitle?.foregroundColor = UIColor.label.withAlphaComponent(0.7)
////        config.titleAlignment = .leading
//
////        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
////        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
////        config.image = image
//
//
////        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
////        config.image = UIImage(systemName: "xmark")
////        config.imagePlacement = .trailing
////        config.imagePadding = 10
//
////        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: Constants.cvPadding, bottom: 10, trailing: Constants.cvPadding)
//
////        configuration = config
////        sizeToFit()
////        titleLabel?.sizeToFit()
//
//        guard let titleLabel = titleLabel else { return }
//        let widthConstant = Constants.cvPadding * 2 + imageView!.bounds.width + 10
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
////            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -150),
//
////            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
////            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//
////    private func configureSelf() {
//////        tintColor = Utils.customBackgroundColor
////        tintColor = .green
//////        backgroundColor = .green
////        layer.cornerRadius = Constants.bookCoverCornerRadius
////        titleLabel?.backgroundColor = .blue
//////        setTitle("Added to Bookshelf", for: .normal)
////        var config = UIButton.Configuration.filled()
////
////        config.attributedTitle = AttributedString("Added to Bookshelf")
////        config.attributedTitle?.font = Utils.sectionTitleFont
////        config.attributedTitle?.foregroundColor = UIColor.label.withAlphaComponent(0.7)
////        config.titleAlignment = .leading
////
//////        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
//////        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
//////        config.image = image
////
////
////        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
////        config.image = UIImage(systemName: "xmark")
////        config.imagePlacement = .trailing
////        config.imagePadding = 10
////
//////        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: Constants.cvPadding, bottom: 10, trailing: Constants.cvPadding)
////
////        configuration = config
//////        sizeToFit()
////
//////        guard let titleLabel = titleLabel else { return }
//////        let widthConstant = Constants.cvPadding * 2 + imageView!.bounds.width + 10
//////        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//////        NSLayoutConstraint.activate([
//////            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
//////            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
//////            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//////        ])
////    }
//
////    private func applyConstraints() {
////        guard let titleLabel = titleLabel else { return }
////        let widthConstant = Constants.cvPadding * 2 + 18 + 10
////        titleLabel.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthConstant),
////            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
////            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
////        ])
////    }
//
//}
