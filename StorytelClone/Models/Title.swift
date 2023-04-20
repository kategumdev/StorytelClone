//
//  TitleKind.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/3/23.
//

import Foundation

protocol Title {
    var titleKind: TitleKind { get }
}

enum TitleKind: String {
    case audiobook = "Audiobook"
    case ebook = "Ebook"
    case audioBookAndEbook = "Audiobook & Ebook"
    case author = "Author"
    case narrator = "Narrator"
    case tag = "Tag"
    case series = "Series"
}
//
//// For Author and Narrator types
//protocol Storyteller {
//
//}


