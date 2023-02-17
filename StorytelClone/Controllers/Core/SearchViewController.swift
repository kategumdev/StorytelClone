//
//  SearchViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        configureNavBar()

    }
    
    private func configureNavBar() {
        navigationItem.title = "Explore"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
//        navigationController?.navigationBar.isTranslucent = true
        
    }
    

}
