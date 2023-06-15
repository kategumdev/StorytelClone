//
//  TitleKind.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/3/23.
//

import Foundation

protocol Title {
    var titleKind: TitleKind { get set}
}

enum TitleKind: String, CaseIterable {
    case audiobook = "Audiobook"
    case ebook = "Ebook"
    case audioBookAndEbook = "Audiobook & Ebook"
    case author = "Author"
    case narrator = "Narrator"
    case tag = "Tag"
    case series = "Series"
    
    static func createCaseFrom(rawValueString: String) -> TitleKind {
        let enumCase = TitleKind(rawValue: rawValueString)
        if let enumCase = enumCase {
            return enumCase
        } else {
            print("enum TitleKind couldn't create value from this rawValue \(rawValueString)")
            return .audiobook
        }
    }
    
}
