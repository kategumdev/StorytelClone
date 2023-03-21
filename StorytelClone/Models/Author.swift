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


struct Author: Title {
    let name: String
    let numberOfFollowers: Int
//    let books: [Book]
    let titleKind: TitleKind = .author
    
    init(name: String, numberOfFollowers: Int) {
        self.name = name
        self.numberOfFollowers = numberOfFollowers
    }
    
    static let authors = [author1, author2, author3, author4, author5, author6,
                          author7, author8, author9, author10]
    
    // Hardcoded model objects for authors
    static let author1 = Author(name: "Fernando Aramburu", numberOfFollowers: 368)
    
    static let author2 = Author(name: "Megan Maxwell", numberOfFollowers: 2100)
    
    static let author3 = Author(name: "Javier Cercas", numberOfFollowers: 481)
    
    static let author4 = Author(name: "Juan Gómez-Jurado", numberOfFollowers: 1200)
    
    static let author5 = Author(name: "Paloma Sánchez-Garnica", numberOfFollowers: 909)
    
    static let author6 = Author(name: "Lorraine Cocó", numberOfFollowers: 358)
    
    static let author7 = Author(name: "Sarah J. Maas", numberOfFollowers: 7900)
    
    static let author8 = Author(name: "Ian Gibson", numberOfFollowers: 36)
    
    static let author9 = Author(name: "Manuel Vilas", numberOfFollowers: 98)
    
    static let author10 = Author(name: "Luis Sepúlveda", numberOfFollowers: 124)
    
    static let tolkien = Author(name: "J.R.R Tolkien", numberOfFollowers: 5200)
    
    static let brunoLopez = Author(name: "Bruno Teixidor López", numberOfFollowers: 2)
    
    static let pabloToledo = Author(name: "Pablo Lara Toledo", numberOfFollowers: 1)
    
    static let shannonChakraborty = Author(name: "Shannon Chakraborty", numberOfFollowers: 102)
    
    static let tucker = Author(name: "K.A. Tucker", numberOfFollowers: 1300)
    
    static let francineRivers = Author(name: "Francine Rivers", numberOfFollowers: 704)
    
    static let ryderCarrol = Author(name: "Ryder Carrol", numberOfFollowers: 34)
    
    static let neilGaiman = Author(name: "Neil Gaiman", numberOfFollowers: 4500)
    
    static let robertLow = Author(name: "Robert Low", numberOfFollowers: 20)
    
    static let kingfisher = Author(name: "T. Kingfisher", numberOfFollowers: 100)
    
    static let melissaBroder = Author(name: "Melissa Broder", numberOfFollowers: 100)
    
    static let octaviaButler = Author(name: "Octavia E. Butler", numberOfFollowers: 100)
    
    static let monicaAli = Author(name: "Monica Ali", numberOfFollowers: 100)
    
    static let gellida = Author(name: "César Pérez Gellida", numberOfFollowers: 100)
    
    static let angelaVallvey = Author(name: "Ángela Vallvey", numberOfFollowers: 100)
    
    static let chantalVanMierlo = Author(name: "Chantal van Mierlo", numberOfFollowers: 100)
    
    static let susanaMartinGijon = Author(name: "Susana Martín Gijón", numberOfFollowers: 100)


    
    
    
    
    
    
}





//struct Storyteller: Title {
//    let name: String
//    let numberOfFollowers: Int
//    let books: [Book]
//    let titleKind: TitleKind
//
//    init(name: String, numberOfFollowers: Int, books: [Book], titleKind: TitleKind) {
//        self.name = name
//        self.numberOfFollowers = numberOfFollowers
//        self.books = books
//        self.titleKind = titleKind
//    }
//
//    static let authors = [author1, author2, author3, author4, author5, author6,
//                          author7, author8, author9, author10]
//    static let narrators = [narrator1, narrator2, narrator3, narrator4, narrator5,
//                            narrator6, narrator7, narrator8, narrator9, narrator10]
//
//    // Hardcoded model objects for authors
//    static let author1 = Storyteller(name: "Fernando Aramburu", numberOfFollowers: 368, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author2 = Storyteller(name: "Megan Maxwell", numberOfFollowers: 2100, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author3 = Storyteller(name: "Javier Cercas", numberOfFollowers: 481, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author4 = Storyteller(name: "Juan Gómez-Jurado", numberOfFollowers: 1200, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author5 = Storyteller(name: "Paloma Sánchez-Garnica", numberOfFollowers: 909, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author6 = Storyteller(name: "Lorraine Cocó", numberOfFollowers: 358, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author7 = Storyteller(name: "Sarah J. Maas", numberOfFollowers: 7900, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author8 = Storyteller(name: "Ian Gibson", numberOfFollowers: 36, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author9 = Storyteller(name: "Manuel Vilas", numberOfFollowers: 98, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//    static let author10 = Storyteller(name: "Luis Sepúlveda", numberOfFollowers: 124, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .author)
//
//
//    // Hardcoded model objects for narrators
//    static let narrator1 = Storyteller(name: "Olivia Vives", numberOfFollowers: 29, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//
//    static let narrator2 = Storyteller(name: "Máximo Huerta", numberOfFollowers: 12, books: [Book.book23], titleKind: .narrator)
//
//    static let narrator3 = Storyteller(name: "Lily Ward", numberOfFollowers: 3, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//
//    static let narrator4 = Storyteller(name: "Javier Sierra", numberOfFollowers: 38, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//
//    static let narrator5 = Storyteller(name: "Gabriela Escamilla", numberOfFollowers: 6, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//
//    static let narrator6 = Storyteller(name: "Susana Bailera", numberOfFollowers: 3, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//
//    static let narrator7 = Storyteller(name: "Kim Staunton", numberOfFollowers: 8, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//
//    static let narrator8 = Storyteller(name: "David Rintoul", numberOfFollowers: 4, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//
//    static let narrator9 = Storyteller(name: "Neil Gaiman", numberOfFollowers: 321, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//
//    static let narrator10 = Storyteller(name: "Rebekkah Ross", numberOfFollowers: 46, books: [Book.book1, Book.book2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book7, Book.book8], titleKind: .narrator)
//}
//
