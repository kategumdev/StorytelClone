//
//  Storyteller.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 1/5/23.
//

import Foundation

//struct Storyteller {
//
//    enum StorytellerKind {
//        case author
//        case narrator
//    }
//
//    let name: String
//    let numberOfFollowers: Int
//    let storytellerKind: StorytellerKind
//
//    lazy var titleKind: TitleKind = {
//        switch storytellerKind {
//        case .author: return .author
//        case .narrator: return .narrator
//        }
//    }()
//
//    init(storytellerKind: StorytellerKind, name: String, numberOfFollowers: Int) {
//        self.storytellerKind = storytellerKind
//        self.name = name
//        self.numberOfFollowers = numberOfFollowers
//    }
//
//    static let authors = [author1, author2, author3, author4, author5, author6,
//                          author7, author8, author9, author10]
//
//    // Hardcoded model objects for authors
//    static let author1 = Storyteller(storytellerKind: .author, name: "Fernando Aramburu", numberOfFollowers: 368)
//    static let author2 = Storyteller(storytellerKind: .author, name: "Megan Maxwell", numberOfFollowers: 2100)
//    static let author3 = Storyteller(storytellerKind: .author, name: "Javier Cercas", numberOfFollowers: 2000)
//    static let author4 = Storyteller(storytellerKind: .author, name: "Juan Gómez-Jurado", numberOfFollowers: 1235)
//    static let author5 = Storyteller(storytellerKind: .author, name: "Paloma Sánchez-Garnica", numberOfFollowers: 1235000)
//
//    static let author6 = Storyteller(storytellerKind: .author, name: "Lorraine Cocó", numberOfFollowers: 453679)
//
//    static let author7 = Storyteller(storytellerKind: .author, name: "Sarah J. Maas", numberOfFollowers: 1000000)
//
//    static let author8 = Storyteller(storytellerKind: .author, name: "Ian Gibson", numberOfFollowers: 2456769)
//
//    static let author9 = Storyteller(storytellerKind: .author, name: "Manuel Vilas", numberOfFollowers: 98)
//
//    static let author10 = Storyteller(storytellerKind: .author, name: "Luis Sepúlveda", numberOfFollowers: 124)
//
//    static let tolkien = Storyteller(storytellerKind: .author, name: "J.R.R Tolkien", numberOfFollowers: 5200)
//
//    static let brunoLopez = Storyteller(storytellerKind: .author, name: "Bruno Teixidor López", numberOfFollowers: 2)
//
//    static let pabloToledo = Storyteller(storytellerKind: .author, name: "Pablo Lara Toledo", numberOfFollowers: 1)
//
//    static let shannonChakraborty = Storyteller(storytellerKind: .author, name: "Shannon Chakraborty", numberOfFollowers: 102)
//
//    static let tucker = Storyteller(storytellerKind: .author, name: "K.A. Tucker", numberOfFollowers: 1300)
//
//    static let francineRivers = Storyteller(storytellerKind: .author, name: "Francine Rivers", numberOfFollowers: 704)
//
//    static let ryderCarrol = Storyteller(storytellerKind: .author, name: "Ryder Carrol", numberOfFollowers: 34)
//
//    static let neilGaiman = Storyteller(storytellerKind: .author, name: "Neil Gaiman", numberOfFollowers: 4500)
//
//    static let robertLow = Storyteller(storytellerKind: .author, name: "Robert Low", numberOfFollowers: 20)
//
//    static let kingfisher = Storyteller(storytellerKind: .author, name: "T. Kingfisher", numberOfFollowers: 100)
//
//    static let melissaBroder = Storyteller(storytellerKind: .author, name: "Melissa Broder", numberOfFollowers: 100)
//
//    static let octaviaButler = Storyteller(storytellerKind: .author, name: "Octavia E. Butler", numberOfFollowers: 100)
//
//    static let monicaAli = Storyteller(storytellerKind: .author, name: "Monica Ali", numberOfFollowers: 100)
//
//    static let gellida = Storyteller(storytellerKind: .author, name: "César Pérez Gellida", numberOfFollowers: 100)
//
//    static let angelaVallvey = Storyteller(storytellerKind: .author, name: "Ángela Vallvey", numberOfFollowers: 100)
//
//    static let chantalVanMierlo = Storyteller(storytellerKind: .author, name: "Chantal van Mierlo", numberOfFollowers: 100)
//
//    static let susanaMartinGijon = Storyteller(storytellerKind: .author, name: "Susana Martín Gijón", numberOfFollowers: 100)
//
//}
