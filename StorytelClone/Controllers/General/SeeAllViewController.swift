//
//  SeeAllViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

#warning("Replace all uses of this class with AllTitlesViewController and delete this file")
// Presented when seeAllButton tapped
class SeeAllViewController: UIViewController {
    
    let tableSection: TableSection
    
    init(tableSection: TableSection) {
        self.tableSection = tableSection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        title = tableSection.sectionTitle
        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
    }

}
