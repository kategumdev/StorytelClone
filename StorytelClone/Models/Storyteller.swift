//
//  Storyteller.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 1/5/23.
//

import Foundation

struct Storyteller: Title, Equatable {
    
    static func createAuthorFrom(names: [String]?) -> [Storyteller] {
        var authors = [Storyteller]()
        
        if let authorNames = names {
            for name in authorNames {
                let author = Storyteller(storytellerKind: .author, name: name, numberOfFollowers: 350)
                authors.append(author)
            }
            return authors
        }
        
        let author = Storyteller(storytellerKind: .author, name: "Unknown author", numberOfFollowers: 0)
        authors.append(author)
        return authors
    }

    enum StorytellerKind {
        case author
        case narrator
    }

    let name: String
    let numberOfFollowers: Int
    var titleKind: TitleKind

    init(storytellerKind: StorytellerKind, name: String, numberOfFollowers: Int) {
        self.name = name
        self.numberOfFollowers = numberOfFollowers
        
        switch storytellerKind {
        case .author: self.titleKind = .author
        case .narrator: self.titleKind = .narrator
        }
    }

    // MARK: - Hardcoded model objects for authors
    static let authors = [author1, author2, author3, author4, author5, author6,
                          author7, author8, author9, author10]
    
    static let author1 = Storyteller(storytellerKind: .author, name: "Fernando Aramburu", numberOfFollowers: 368)
    static let author2 = Storyteller(storytellerKind: .author, name: "Megan Maxwell", numberOfFollowers: 2100)
    static let author3 = Storyteller(storytellerKind: .author, name: "Javier Cercas", numberOfFollowers: 2000)
    static let author4 = Storyteller(storytellerKind: .author, name: "Juan Gómez-Jurado", numberOfFollowers: 1235)
    static let author5 = Storyteller(storytellerKind: .author, name: "Paloma Sánchez-Garnica", numberOfFollowers: 1235000)
    static let author6 = Storyteller(storytellerKind: .author, name: "Lorraine Cocó", numberOfFollowers: 453679)
    static let author7 = Storyteller(storytellerKind: .author, name: "Sarah J. Maas", numberOfFollowers: 1000000)
    static let author8 = Storyteller(storytellerKind: .author, name: "Ian Gibson", numberOfFollowers: 2456769)
    static let author9 = Storyteller(storytellerKind: .author, name: "Manuel Vilas", numberOfFollowers: 98)
    static let author10 = Storyteller(storytellerKind: .author, name: "Luis Sepúlveda", numberOfFollowers: 124)
    static let tolkien = Storyteller(storytellerKind: .author, name: "J.R.R Tolkien", numberOfFollowers: 5200)
    static let brunoLopez = Storyteller(storytellerKind: .author, name: "Bruno Teixidor López", numberOfFollowers: 2)
    static let pabloToledo = Storyteller(storytellerKind: .author, name: "Pablo Lara Toledo", numberOfFollowers: 1)
    static let shannonChakraborty = Storyteller(storytellerKind: .author, name: "Shannon Chakraborty", numberOfFollowers: 102)
    static let tucker = Storyteller(storytellerKind: .author, name: "K.A. Tucker", numberOfFollowers: 1300)
    static let francineRivers = Storyteller(storytellerKind: .author, name: "Francine Rivers", numberOfFollowers: 704)
    static let ryderCarrol = Storyteller(storytellerKind: .author, name: "Ryder Carrol", numberOfFollowers: 34)
    static let neilGaiman = Storyteller(storytellerKind: .author, name: "Neil Gaiman", numberOfFollowers: 4500)
    static let robertLow = Storyteller(storytellerKind: .author, name: "Robert Low", numberOfFollowers: 20)
    static let kingfisher = Storyteller(storytellerKind: .author, name: "T. Kingfisher", numberOfFollowers: 100)
    static let melissaBroder = Storyteller(storytellerKind: .author, name: "Melissa Broder", numberOfFollowers: 100)
    static let octaviaButler = Storyteller(storytellerKind: .author, name: "Octavia E. Butler", numberOfFollowers: 100)
    static let monicaAli = Storyteller(storytellerKind: .author, name: "Monica Ali", numberOfFollowers: 100)
    static let gellida = Storyteller(storytellerKind: .author, name: "César Pérez Gellida", numberOfFollowers: 100)
    static let angelaVallvey = Storyteller(storytellerKind: .author, name: "Ángela Vallvey", numberOfFollowers: 100)
    static let chantalVanMierlo = Storyteller(storytellerKind: .author, name: "Chantal van Mierlo", numberOfFollowers: 100)
    static let susanaMartinGijon = Storyteller(storytellerKind: .author, name: "Susana Martín Gijón", numberOfFollowers: 100)
    
    // MARK: - Hardcoded model objects for narrators
    static let narrators = [narrator1, narrator2, narrator3, narrator4, narrator5,
                            narrator6, narrator7, narrator8, narrator9, narrator10]
    static let narrator1 = Storyteller(storytellerKind: .narrator, name: "Olivia Vives", numberOfFollowers: 29)
    static let narrator2 = Storyteller(storytellerKind: .narrator, name: "Máximo Huerta", numberOfFollowers: 12)
    static let narrator3 = Storyteller(storytellerKind: .narrator, name: "Lily Ward", numberOfFollowers: 3)
    static let narrator4 = Storyteller(storytellerKind: .narrator, name: "Javier Sierra", numberOfFollowers: 38)
    static let narrator5 = Storyteller(storytellerKind: .narrator, name: "Gabriela Escamilla", numberOfFollowers: 6)
    static let narrator6 = Storyteller(storytellerKind: .narrator, name: "Susana Bailera", numberOfFollowers: 3)
    static let narrator7 = Storyteller(storytellerKind: .narrator, name: "Kim Staunton", numberOfFollowers: 8)
    static let narrator8 = Storyteller(storytellerKind: .narrator, name: "David Rintoul", numberOfFollowers: 4)
    static let narrator9 = Storyteller(storytellerKind: .narrator, name: "Neil Gaiman", numberOfFollowers: 321)
    static let narrator10 = Storyteller(storytellerKind: .narrator, name: "Rebekkah Ross", numberOfFollowers: 46)

}
