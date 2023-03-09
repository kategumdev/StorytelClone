//
//  PageContentViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 9/3/23.
//

import UIKit

class PageContentViewController: UIViewController {
    
//    let index: Int = 0
//
//    init(index: Int) {
//        self.index = index
//        super.init(nibName: nil, bundle: nil)
    
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 19)
        label.textColor = UIColor.label
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}
