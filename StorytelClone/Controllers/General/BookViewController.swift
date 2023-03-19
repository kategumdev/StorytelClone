//
//  BookViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class BookViewController: UIViewController {
    
    var book: Book?
    
    init(book: Book?) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        title = book?.title
//        navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance

        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        navigationController?.navigationBar.isTranslucent = false

//        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("viewDidDisappear")
//        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
//    }

}
