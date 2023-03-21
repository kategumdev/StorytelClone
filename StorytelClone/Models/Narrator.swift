//
//  Narrator.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 20/3/23.
//

import Foundation

struct Narrator: Title {
    let name: String
    let numberOfFollowers: Int
//    let books: [Book]
    let titleKind: TitleKind = .narrator
    
    init(name: String, numberOfFollowers: Int) {
        self.name = name
        self.numberOfFollowers = numberOfFollowers
    }
    
    static let narrators = [narrator1, narrator2, narrator3, narrator4, narrator5,
                            narrator6, narrator7, narrator8, narrator9, narrator10]
    
    // Hardcoded model objects for narrators
    static let narrator1 = Narrator(name: "Olivia Vives", numberOfFollowers: 29)
    
    static let narrator2 = Narrator(name: "Máximo Huerta", numberOfFollowers: 12)
    
    static let narrator3 = Narrator(name: "Lily Ward", numberOfFollowers: 3)
    
    static let narrator4 = Narrator(name: "Javier Sierra", numberOfFollowers: 38)
    
    static let narrator5 = Narrator(name: "Gabriela Escamilla", numberOfFollowers: 6)
    
    static let narrator6 = Narrator(name: "Susana Bailera", numberOfFollowers: 3)

    static let narrator7 = Narrator(name: "Kim Staunton", numberOfFollowers: 8)
    
    static let narrator8 = Narrator(name: "David Rintoul", numberOfFollowers: 4)
    
    static let narrator9 = Narrator(name: "Neil Gaiman", numberOfFollowers: 321)
    
    static let narrator10 = Narrator(name: "Rebekkah Ross", numberOfFollowers: 46)
}
