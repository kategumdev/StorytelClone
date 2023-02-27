//
//  Extensions.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/2/23.
//

import UIKit

extension UIFont {
    
    static func preferredCustomFontWith(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        
        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.size: size,
            UIFontDescriptor.AttributeName.family: "Avenir Next"
        ])

        let weightedFontDescriptor = fontDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight
            ]
        ])
        
        return UIFont(descriptor: weightedFontDescriptor, size: 0)
    }
}

extension UIView {
    func fillSuperview(withConstant constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant)
        ])
    }
}

extension UINavigationController {
    func hideNavBarBackground() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor.clear
    }
 
    func showNavBarBackground() {
        self.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationBar.shadowImage = nil
        self.view.backgroundColor = nil
    }
    
    
    
    func makeTransparent() {
        self.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : Utils.navBarTitleFont]
        self.navigationBar.standardAppearance.configureWithTransparentBackground()
        
        
//        self.navigationBar.standardAppearance.backgroundImage = UIImage()
//        self.navigationBar.standardAppearance.shadowImage = UIImage()
        
    }
    
    func makeVisible() {

//        self.navigationBar.standardAppearance.backgroundImage = nil
//        self.navigationBar.standardAppearance.shadowImage = nil
        
        self.navigationBar.standardAppearance.configureWithDefaultBackground()
        self.navigationBar.standardAppearance.shadowColor = .tertiaryLabel
        self.navigationBar.standardAppearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
        self.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : Utils.navBarTitleFont]
    }
    

}
