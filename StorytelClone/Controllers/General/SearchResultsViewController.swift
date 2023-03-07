//
//  SearchResultsViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/3/23.
//

import UIKit

class SearchResultsViewController: UIViewController {

    let buttonsScrollView = ScopeButtonsViewSearchResults()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        view.addSubview(buttonsScrollView)
        
        buttonsScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
//            buttonsScrollView.heightAnchor.constraint(equalToConstant: 50)
        ])
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}
