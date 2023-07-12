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
        configureSelf()
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        view.backgroundColor = UIColor.customBackgroundColor
        configureRootVCs()
        configureTabBar()
    }

    private func configureRootVCs() {
        let homeVC = HomeViewController(category: Category.home)
        let vc1 = UINavigationController(rootViewController: homeVC)
        
        let searchVC = SearchViewController(
            category: Category.searchVc,
            categoriesForButtons: Category.categoriesForAllCategories)
        let vc2 = UINavigationController(rootViewController: searchVC)
        
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
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: false)
    }
    
    private func configureTabBar() {
        tabBar.isTranslucent = false
        tabBar.standardAppearance.backgroundEffect = nil
        tabBar.standardAppearance.shadowColor = .tertiaryLabel
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        setTabBarItemColors()
        
        // This line avoids the tab bar blinking gray when next vc is being pushed
        tabBar.backgroundColor = UIColor.customBackgroundColor
    }
    
    private func setTabBarItemColors() {
        let normalColor = UIColor.label
        let selectedColor = UIColor.customTintColor
        let font = UIFont.createStaticFontWith(weight: .semibold, size: 11)
        
        let itemAppearances = [
            tabBar.standardAppearance.stackedLayoutAppearance,
            tabBar.standardAppearance.inlineLayoutAppearance,
            tabBar.standardAppearance.compactInlineLayoutAppearance
        ]
        
        for appearance in itemAppearances {
            appearance.normal.iconColor = normalColor
            appearance.normal.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: normalColor,
                NSAttributedString.Key.font: font
            ]
            
            appearance.selected.iconColor = selectedColor
            appearance.selected.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: selectedColor,
                NSAttributedString.Key.font: font
            ]
        }
    }
}
