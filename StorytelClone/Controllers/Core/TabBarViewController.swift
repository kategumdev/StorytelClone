//
//  TabBarViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        
        let vc1 = UINavigationController(rootViewController: HomeViewController(model: Category.home))
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: BookshelfViewController())
        let vc4 = UINavigationController(rootViewController: ProfileViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "lightbulb")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "heart")
        vc4.tabBarItem.image = UIImage(systemName: "person")
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Bookshelf"
        vc4.title = "Profile"
        
        tabBar.isTranslucent = false
        
        tabBar.standardAppearance.backgroundEffect = nil
        
        tabBar.standardAppearance.shadowColor = .tertiaryLabel
                
        setTabBarItemColors([tabBar.standardAppearance.stackedLayoutAppearance, tabBar.standardAppearance.inlineLayoutAppearance, tabBar.standardAppearance.compactInlineLayoutAppearance])
        
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }

    
    // MARK: - Helper methods
    private func setTabBarItemColors(_ itemAppearances: [UITabBarItemAppearance]) {
        let normalColor = UIColor.label
        let selectedColor = UIColor(cgColor: CGColor(red: 255/255, green: 56/255, blue: 0/255, alpha: 1))
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 11)
        
        for appearance in itemAppearances {
            appearance.normal.iconColor = normalColor
            appearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: normalColor, NSAttributedString.Key.font: font]
            appearance.selected.iconColor = selectedColor
            appearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectedColor, NSAttributedString.Key.font: font]
        }
    }

}
