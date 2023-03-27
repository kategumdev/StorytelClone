//
//  SeeMoreView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/3/23.
//

import UIKit

class SeeMoreView: UIView {
    
    static let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//    static let bottomPadding: CGFloat = 24
    
    
//    private let bottomPadding: CGFloat = 24
    let viewHeight: CGFloat = 110
    
    private let seeMoreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString("See more")
        buttonConfig.attributedTitle?.font = SeeMoreView.font
//        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: bottomPadding, leading: 0, bottom: bottomPadding, trailing: 0)
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        buttonConfig.titleAlignment = .center
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
        let image = UIImage(systemName: "chevron.down", withConfiguration: symbolConfig)
        buttonConfig.image = image
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 4
        button.configuration = buttonConfig
        
//        button.sizeToFit()
//        button.backgroundColor = .cyan
        return button
    }()
    
    private lazy var intrinsicButtonHeight: CGFloat = {
        seeMoreButton.sizeToFit()
        let height = seeMoreButton.bounds.height
        return height
    }()
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta.withAlphaComponent(0.5)
//        view.backgroundColor = Utils.customBackgroundColor?.withAlphaComponent(0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dimView)
        addSubview(seeMoreButton)
//        backgroundColor = .green
//        backgroundColor = Utils.customBackgroundColor
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func getIntrinsicButtonHeight() -> CGFloat {
//        seeMoreButton.sizeToFit()
//        let height = seeMoreButton.bounds.height
//        return height
//    }
    
    private func applyConstraints() {
        
        dimView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: topAnchor),
//            dimView.heightAnchor.constraint(equalTo: seeMoreButton.heightAnchor),
            dimView.heightAnchor.constraint(equalToConstant: viewHeight / 2),
//            dimView.heightAnchor.constraint(equalTo: seeMoreButton.heightAnchor),
            dimView.widthAnchor.constraint(equalTo: widthAnchor),
            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            dimView.bottomAnchor.constraint(equalTo: seeMoreButton.topAnchor)
        ])
        
        let intrinsicButtonHeight = intrinsicButtonHeight
        print("intrinsicButtonHeight: \(intrinsicButtonHeight)")
//        let topAndBottomPadding = viewHeight - intrinsicButtonHeight
        let bottomPadding = ((viewHeight / 2) - intrinsicButtonHeight) / 2
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            seeMoreButton.heightAnchor.constraint(equalToConstant: intrinsicButtonHeight),
//            seeMoreButton.topAnchor.constraint(equalTo: dimView.bottomAnchor),
//            seeMoreButton.heightAnchor.constraint(equalToConstant: viewHeight / 2),
            seeMoreButton.widthAnchor.constraint(equalTo: widthAnchor),
            seeMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
        ])
        
        
//        dimView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            dimView.topAnchor.constraint(equalTo: topAnchor),
////            dimView.heightAnchor.constraint(equalTo: seeMoreButton.heightAnchor),
////            dimView.heightAnchor.constraint(equalToConstant: viewHeight / 2),
//            dimView.heightAnchor.constraint(equalTo: seeMoreButton.heightAnchor),
//            dimView.widthAnchor.constraint(equalTo: widthAnchor),
//            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            dimView.bottomAnchor.constraint(equalTo: seeMoreButton.topAnchor)
//        ])
        
    }
    
    
    
    
//    private func applyConstraints() {
//
//        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
////            seeMoreButton.topAnchor.constraint(equalTo: dimView.bottomAnchor),
//            seeMoreButton.widthAnchor.constraint(equalTo: widthAnchor),
////            seeMoreButton.heightAnchor.constraint(equalToConstant: 70),
////            seeMoreButton.heightAnchor.constraint(equalToConstant: viewHeight / 2),
//            seeMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
////            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
//            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//
//
//        dimView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            dimView.topAnchor.constraint(equalTo: topAnchor),
////            dimView.heightAnchor.constraint(equalTo: seeMoreButton.heightAnchor),
////            dimView.heightAnchor.constraint(equalToConstant: viewHeight / 2),
//            dimView.heightAnchor.constraint(equalTo: seeMoreButton.heightAnchor),
//            dimView.widthAnchor.constraint(equalTo: widthAnchor),
//            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            dimView.bottomAnchor.constraint(equalTo: seeMoreButton.topAnchor)
//        ])
//
//    }
    
    
    
    
    
//    private func applyConstraints() {
//
//        dimView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            dimView.topAnchor.constraint(equalTo: topAnchor),
////            dimView.heightAnchor.constraint(equalTo: seeMoreButton.heightAnchor),
//            dimView.heightAnchor.constraint(equalToConstant: viewHeight / 2),
//            dimView.widthAnchor.constraint(equalTo: widthAnchor),
//            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
////            dimView.bottomAnchor.constraint(equalTo: seeMoreButton.topAnchor)
//        ])
//
//        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
////            seeMoreButton.topAnchor.constraint(equalTo: dimView.bottomAnchor),
//            seeMoreButton.widthAnchor.constraint(equalTo: widthAnchor),
////            seeMoreButton.heightAnchor.constraint(equalToConstant: 70),
////            seeMoreButton.heightAnchor.constraint(equalToConstant: viewHeight / 2),
//            seeMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
////            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
//            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//
////        translatesAutoresizingMaskIntoConstraints = false
////        let height = (seeMoreButton.bounds.height + SeeMoreView.topAndBottomPadding * 2) * 2
////        heightAnchor.constraint(equalToConstant: height).isActive = true
//    }
    
}
