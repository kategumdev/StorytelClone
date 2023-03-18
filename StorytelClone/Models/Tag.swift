//
//  Tag.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/3/23.
//

import Foundation

struct Tag {
    let title: String
    let books: [Book]
    let titleKind: TitleKind
    
    init(title: String, books: [Book], titleKind: TitleKind) {
        self.title = title
        self.books = books
        self.titleKind = titleKind
    }
    
    static let tags = [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10]
    
    // Hardcoded model objects for tags
    static let tag1 = Tag(title: "Novelas históricas", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag2 = Tag(title: "Acción y aventura", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag3 = Tag(title: "Aventura", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag4 = Tag(title: "Meditación", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag5 = Tag(title: "Biografías históricas", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag6 = Tag(title: "Science environment", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag7 = Tag(title: "Science", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag8 = Tag(title: "Nature", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag9 = Tag(title: "World Cultures", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
    
    static let tag10 = Tag(title: "Fantasy world", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
}
