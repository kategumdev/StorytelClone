//
//  Series.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 20/3/23.
//

import UIKit

struct Series: Title {
    let title: String
    let authors: [Storyteller]
    let coverImage: UIImage?
    var titleKind: TitleKind
    let category: Category
    let language: Language
    let numberOfFollowers: Int
    let books: [Book]
    let narrators: [Storyteller]?
    let isFollowed: Bool
    
    init(title: String, authors: [Storyteller], coverImage: UIImage?, titleKind: TitleKind = .series, category: Category, language: Language, numberOfFollowers: Int, books: [Book], narrators: [Storyteller]? = nil, isFollowed: Bool = false) {
        self.title = title
        self.authors = authors
        self.coverImage = coverImage
        self.titleKind = titleKind
        self.category = category
        self.language = language
        self.numberOfFollowers = numberOfFollowers
        self.books = books
        self.narrators = narrators
        self.isFollowed = isFollowed
    }
    
    static let series1 = Series(title: "El señor de los anillos", authors: [Storyteller.tolkien], coverImage: UIImage(named: "series1book1"), titleKind: .series, category: .fantasiaYCienciaFiccion, language: .spanish, numberOfFollowers: 613, books: [Book.senorDeLosAnillos1, Book.senorDeLosAnillos2], narrators: [Storyteller.narrator5])

    static let series2 = Series(title: "Old Fairytales", authors: [Storyteller.author5, Storyteller.author3], coverImage: UIImage(named: "image21"), titleKind: .series, category: .fantasiaYCienciaFiccion, language: .english, numberOfFollowers: 2345, books: [Book.book21, Book.book2, Book.book3, Book.book23, Book.book9, Book.book19, Book.book8, Book.book4, Book.book20], isFollowed: true)

    static let series3 = Series(title: "Gatos salvajes", authors: [Storyteller.author9], coverImage: UIImage(named: "image23"), titleKind: .series, category: .novela, language: .spanish, numberOfFollowers: 1205, books: [Book.book23, Book.book21, Book.book2, Book.book3, Book.book14, Book.book9, Book.book19, Book.book8, Book.book4, Book.book20], isFollowed: true)
    
}
