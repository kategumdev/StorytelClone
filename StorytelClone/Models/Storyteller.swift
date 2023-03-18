//
//  Author.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/3/23.
//

import Foundation


//enum StorytellerType {
//    case author
//    case narrator
//}

struct Storyteller {
    let name: String
    let numberOfFollowers: Int
    let books: [Book]
    let titleKind: TitleKind
    
    init(name: String, numberOfFollowers: Int, books: [Book], titleKind: TitleKind) {
        self.name = name
        self.numberOfFollowers = numberOfFollowers
        self.books = books
        self.titleKind = titleKind
    }
    
    static let authors = [author1, author2, author3]
    static let narrators = [narrator1, narrator2, narrator3]
    
    // Hardcoded model objects for authors
    static let author1 = Storyteller(name: "Fernando Aramburu", numberOfFollowers: 368, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
    
    static let author2 = Storyteller(name: "Megan Maxwell", numberOfFollowers: 2100, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
    
    static let author3 = Storyteller(name: "Javier Cercas", numberOfFollowers: 481, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
    
    // Hardcoded model objects for narrators
    static let narrator1 = Storyteller(name: "Olivia Vives", numberOfFollowers: 29, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
    
    static let narrator2 = Storyteller(name: "Máximo Huerta", numberOfFollowers: 12, books: [Book.book23], titleKind: .narrator)
    
    static let narrator3 = Storyteller(name: "Lily Ward", numberOfFollowers: 3, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)

}

