//
//  Series.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 20/3/23.
//

import UIKit

struct Series: Title {
    let title: String
    let authors: [Author]
    let coverImage: UIImage?
    let titleKind: TitleKind
    let category: ButtonCategory
    let language: Language
    let numberOfFollowers: Int
    let books: [Book]
    let narrators: [Narrator]?
    
    init(title: String, authors: [Author], coverImage: UIImage?, titleKind: TitleKind = .series, category: ButtonCategory, language: Language, numberOfFollowers: Int, books: [Book], narrators: [Narrator]? = nil) {
        self.title = title
        self.authors = authors
        self.coverImage = coverImage
        self.titleKind = titleKind
        self.category = category
        self.language = language
        self.numberOfFollowers = numberOfFollowers
        self.books = books
        self.narrators = narrators
    }
    
    static let series1 = Series(title: "El señor de los anillos", authors: [Author.tolkien], coverImage: UIImage(named: "series1book1"), titleKind: .series, category: .fantasiaYCienciaFiccion, language: .spanish, numberOfFollowers: 613, books: [Book.senorDeLosAnillos1, Book.senorDeLosAnillos2], narrators: [Narrator.narrator5])

    static let series2 = Series(title: "Old Fairytales", authors: [Author.author5, Author.author3], coverImage: UIImage(named: "image21"), titleKind: .series, category: .fantasiaYCienciaFiccion, language: .english, numberOfFollowers: 350, books: [Book.book21, Book.book2, Book.book3, Book.book23, Book.book9, Book.book19, Book.book8, Book.book4, Book.book20])

    static let series3 = Series(title: "Gatos salvajes", authors: [Author.author9], coverImage: UIImage(named: "image23"), titleKind: .series, category: .novela, language: .spanish, numberOfFollowers: 500, books: [Book.book23, Book.book21, Book.book2, Book.book3, Book.book14, Book.book9, Book.book19, Book.book8, Book.book4, Book.book20])
    
//    static let series1 = Series(title: "El señor de los anillos", authors: [Author.tolkien], coverImage: UIImage(named: "series1book1"), titleKind: .series, category: .fantasiaYCienciaFiccion, language: .spanish, numberOfFollowers: 613, narrators: [Narrator.narrator5])
//
//    static let series2 = Series(title: "Old Fairytales", authors: [Author.author5, Author.author3], coverImage: UIImage(named: "image21"), titleKind: .series, category: .fantasiaYCienciaFiccion, language: .english, numberOfFollowers: 350)
//
//    static let series3 = Series(title: "Gatos salvajes", authors: [Author.author9], coverImage: UIImage(named: "image23"), titleKind: .series, category: .novela, language: .spanish, numberOfFollowers: 500)
}
