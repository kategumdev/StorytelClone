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
        view.backgroundColor = UIColor.customBackgroundColor
        
        let vc1 = UINavigationController(rootViewController: HomeViewController(categoryModel: Category.home))
        let vc2 = UINavigationController(rootViewController: SearchViewController(categoryModel: Category.searchVc, categoriesForButtons: Category.categoriesForAllCategories))
        let vc3 = UINavigationController(rootViewController: BookshelfViewController())
        let vc4 = UINavigationController(rootViewController: ProfileViewController())
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        
        vc1.tabBarItem.image = UIImage(systemName: "lightbulb")?.withConfiguration(symbolConfig)
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")?.withConfiguration(symbolConfig)
        vc3.tabBarItem.image = UIImage(systemName: "heart")?.withConfiguration(symbolConfig)
        vc4.tabBarItem.image = UIImage(systemName: "person")?.withConfiguration(symbolConfig)
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Bookshelf"
        vc4.title = "Profile"
        
        tabBar.isTranslucent = false
        
        // This line avoids tab bar blinking gray when next vc is being pushed
        tabBar.backgroundColor = UIColor.customBackgroundColor
        
        tabBar.standardAppearance.backgroundEffect = nil
        tabBar.standardAppearance.shadowColor = .tertiaryLabel
                
        setTabBarItemColors([tabBar.standardAppearance.stackedLayoutAppearance, tabBar.standardAppearance.inlineLayoutAppearance, tabBar.standardAppearance.compactInlineLayoutAppearance])
        
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }

    
    private func setTabBarItemColors(_ itemAppearances: [UITabBarItemAppearance]) {
        let normalColor = UIColor.label
        let selectedColor = UIColor.customTintColor
        let font = UIFont.createStaticFontWith(weight: .semibold, size: 11)
        
        for appearance in itemAppearances {
            appearance.normal.iconColor = normalColor
            appearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: normalColor, NSAttributedString.Key.font: font]
            appearance.selected.iconColor = selectedColor
            appearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectedColor, NSAttributedString.Key.font: font]
        }
    }

}
