//
//  Tag.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/3/23.
//

import Foundation

struct Tag: Title {
    let tagTitle: String
    let titleKind: TitleKind = .tag
    
    init(tagTitle: String) {
        self.tagTitle = tagTitle
    }
    
    static let tags = [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10]
    static let tagsBookVC = [Tag(tagTitle: "Grabado en español ibérico"), Tag(tagTitle: "De 15 años en adelante"), Tag(tagTitle: "Magia"), Tag(tagTitle: "Fantasía juvenil"), Tag(tagTitle: "Fantasía"), Tag(tagTitle: "Romántica YA"), Tag(tagTitle: "Emocionante")]
    static let manyTags = tags + tagsBookVC + [Tag(tagTitle: "Shadow and Bone"), Tag(tagTitle: "Vikings"), Tag(tagTitle: "Umbrella academy"), Tag(tagTitle: "Stranger things")]
//    Tag(tagTitle: "Crecimiento personal y aventura fantastica")
    
    // Hardcoded model objects for tags
    static let tag1 = Tag(tagTitle: "Novelas históricas")
    
    static let tag2 = Tag(tagTitle: "Acción y aventura")
    
    static let tag3 = Tag(tagTitle: "Aventura")
    
    static let tag4 = Tag(tagTitle: "Meditación")
    
    static let tag5 = Tag(tagTitle: "Biografías históricas")
    
    static let tag6 = Tag(tagTitle: "Science environment")
    
    static let tag7 = Tag(tagTitle: "Science")
    
    static let tag8 = Tag(tagTitle: "Nature")
    
    static let tag9 = Tag(tagTitle: "World Cultures")
    
    static let tag10 = Tag(tagTitle: "Fantasy world")

}


//struct Tag: Title {
//    let tagTitle: String
//    let books: [Book]
//    let titleKind: TitleKind
//
//    init(tagTitle: String, books: [Book], titleKind: TitleKind) {
//        self.tagTitle = tagTitle
//        self.books = books
//        self.titleKind = titleKind
//    }
//
//    static let tags = [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10]
//
//    // Hardcoded model objects for tags
//    static let tag1 = Tag(tagTitle: "Novelas históricas", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag2 = Tag(tagTitle: "Acción y aventura", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag3 = Tag(tagTitle: "Aventura", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag4 = Tag(tagTitle: "Meditación", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag5 = Tag(tagTitle: "Biografías históricas", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag6 = Tag(tagTitle: "Science environment", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag7 = Tag(tagTitle: "Science", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag8 = Tag(tagTitle: "Nature", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag9 = Tag(tagTitle: "World Cultures", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//
//    static let tag10 = Tag(tagTitle: "Fantasy world", books: [Book.book10, Book.book11, Book.book12, Book.book13, Book.book14, Book.book15, Book.book16, Book.book17, Book.book18, Book.book19, Book.book20], titleKind: .tag)
//}
