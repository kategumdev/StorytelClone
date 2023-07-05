//
//  Storyteller.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 1/5/23.
//

import Foundation

struct Storyteller: Title, Equatable {

    // MARK: - Instance properties
    let name: String
    let numberOfFollowers: Int
    var titleKind: TitleKind
    
    // MARK: - Initializer
    init(titleKind: TitleKind, name: String, numberOfFollowers: Int) {
        self.name = name
        self.numberOfFollowers = numberOfFollowers
        self.titleKind = titleKind
    }

}

// MARK: - Static properties and methods
extension Storyteller {
    static func createAuthorFrom(names: [String]?) -> [Storyteller] {
        var authors = [Storyteller]()
        
        if let authorNames = names {
            for name in authorNames {
                let author = Storyteller(titleKind: .author, name: name, numberOfFollowers: 350)
                authors.append(author)
            }
            return authors
        }
        
        let author = Storyteller(titleKind: .author, name: "Unknown author", numberOfFollowers: 0)
        authors.append(author)
        return authors
    }
        
    // Hardcoded model objects for authors
    static let authors = [author1, author2, author3, author4, author5, author6,
                          author7, author8, author9, author10]
    
    static let author1 = Storyteller(titleKind: .author, name: "Fernando Aramburu", numberOfFollowers: 368)
    static let author2 = Storyteller(titleKind: .author, name: "Megan Maxwell", numberOfFollowers: 2100)
    static let author3 = Storyteller(titleKind: .author, name: "Javier Cercas", numberOfFollowers: 2000)
    static let author4 = Storyteller(titleKind: .author, name: "Juan Gómez-Jurado", numberOfFollowers: 1235)
    static let author5 = Storyteller(titleKind: .author, name: "Paloma Sánchez-Garnica", numberOfFollowers: 1235000)
    static let author6 = Storyteller(titleKind: .author, name: "Lorraine Cocó", numberOfFollowers: 453679)
    static let author7 = Storyteller(titleKind: .author, name: "Sarah J. Maas", numberOfFollowers: 1000000)
    static let author8 = Storyteller(titleKind: .author, name: "Ian Gibson", numberOfFollowers: 2456769)
    static let author9 = Storyteller(titleKind: .author, name: "Manuel Vilas", numberOfFollowers: 98)
    static let author10 = Storyteller(titleKind: .author, name: "Luis Sepúlveda", numberOfFollowers: 124)
    static let tolkien = Storyteller(titleKind: .author, name: "J.R.R Tolkien", numberOfFollowers: 5200)
    static let brunoLopez = Storyteller(titleKind: .author, name: "Bruno Teixidor López", numberOfFollowers: 2)
    static let pabloToledo = Storyteller(titleKind: .author, name: "Pablo Lara Toledo", numberOfFollowers: 1)
    static let shannonChakraborty = Storyteller(titleKind: .author, name: "Shannon Chakraborty", numberOfFollowers: 102)
    static let tucker = Storyteller(titleKind: .author, name: "K.A. Tucker", numberOfFollowers: 1300)
    static let francineRivers = Storyteller(titleKind: .author, name: "Francine Rivers", numberOfFollowers: 704)
    static let ryderCarrol = Storyteller(titleKind: .author, name: "Ryder Carrol", numberOfFollowers: 34)
    static let neilGaiman = Storyteller(titleKind: .author, name: "Neil Gaiman", numberOfFollowers: 4500)
    static let robertLow = Storyteller(titleKind: .author, name: "Robert Low", numberOfFollowers: 20)
    static let kingfisher = Storyteller(titleKind: .author, name: "T. Kingfisher", numberOfFollowers: 100)
    static let melissaBroder = Storyteller(titleKind: .author, name: "Melissa Broder", numberOfFollowers: 100)
    static let octaviaButler = Storyteller(titleKind: .author, name: "Octavia E. Butler", numberOfFollowers: 100)
    static let monicaAli = Storyteller(titleKind: .author, name: "Monica Ali", numberOfFollowers: 100)
    static let gellida = Storyteller(titleKind: .author, name: "César Pérez Gellida", numberOfFollowers: 100)
    static let angelaVallvey = Storyteller(titleKind: .author, name: "Ángela Vallvey", numberOfFollowers: 100)
    static let chantalVanMierlo = Storyteller(titleKind: .author, name: "Chantal van Mierlo", numberOfFollowers: 100)
    static let susanaMartinGijon = Storyteller(titleKind: .author, name: "Susana Martín Gijón", numberOfFollowers: 100)
    static let jenkins = Storyteller(titleKind: .author, name: "Taylor Jenkins Reid", numberOfFollowers: 550)
    
    // Hardcoded model objects for narrators
    static let narrators = [narrator1, narrator2, narrator3, narrator4, narrator5,
                            narrator6, narrator7, narrator8, narrator9, narrator10]
    static let narrator1 = Storyteller(titleKind: .narrator, name: "Olivia Vives", numberOfFollowers: 29)
    static let narrator2 = Storyteller(titleKind: .narrator, name: "Máximo Huerta", numberOfFollowers: 12)
    static let narrator3 = Storyteller(titleKind: .narrator, name: "Lily Ward", numberOfFollowers: 3)
    static let narrator4 = Storyteller(titleKind: .narrator, name: "Javier Sierra", numberOfFollowers: 38)
    static let narrator5 = Storyteller(titleKind: .narrator, name: "Gabriela Escamilla", numberOfFollowers: 6)
    static let narrator6 = Storyteller(titleKind: .narrator, name: "Susana Bailera", numberOfFollowers: 3)
    static let narrator7 = Storyteller(titleKind: .narrator, name: "Kim Staunton", numberOfFollowers: 8)
    static let narrator8 = Storyteller(titleKind: .narrator, name: "David Rintoul", numberOfFollowers: 4)
    static let narrator9 = Storyteller(titleKind: .narrator, name: "Neil Gaiman", numberOfFollowers: 321)
    static let narrator10 = Storyteller(titleKind: .narrator, name: "Rebekkah Ross", numberOfFollowers: 46)
}
