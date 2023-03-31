//
//  BookshelfViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

var toReadBooks = [Book]()

class BookshelfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("BOOKSHELF viewWillAppear")
        if !toReadBooks.isEmpty {
            let bookTitles = toReadBooks.map { $0.title }
            let bookTitlesString = bookTitles.joined(separator: ", ")
            print("\nTBR: \(bookTitlesString)")
        }
    }
    
}
