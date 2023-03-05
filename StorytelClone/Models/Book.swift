//
//  Book.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

enum BookKind {
    case audiobook
    case ebook
    case audioBookAndEbook
}

struct Book {
    let title: String
    let author: String
    let coverImage: UIImage?
    let largeCoverImage: UIImage?
    let bookKind: BookKind
    
    init(title: String, author: String, coverImage: UIImage?, largeCoverImage: UIImage? = nil, bookKind: BookKind) {
        self.title = title
        self.author = author
        self.coverImage = coverImage
        self.largeCoverImage = largeCoverImage
        self.bookKind = bookKind
    }
    
    static let books = [book1, book2, book3, book4, book5, book6, book7, book8, book9, book10]
    
    static let booksWithLargeCovers = [book11, book12, book13, book14, book15, book16, book17, book18, book19]
    
    static let posterBook =  Book(title: "Modo Noche", author: "Bruno Teixidor López, Pablo Lara Toledo", coverImage: UIImage(named: "modoNoche"), bookKind: .audiobook)
    
    static let book1 = Book(title: "The city of brass", author: "Shannon Chakraborty", coverImage: UIImage(named: "image1"), bookKind: .audiobook)
    
    static let book2 = Book(title: "The simple wild", author: "K.A. Tucker", coverImage: UIImage(named: "image2"), bookKind: .audioBookAndEbook)
    
    static let book3 = Book(title: "The masterpiece", author: "Francine Rivers", coverImage: UIImage(named: "image3"), bookKind: .audiobook)
    
    static let book4 = Book(title: "The bullet journal method", author: "Ryder Carrol", coverImage: UIImage(named: "image4"), bookKind: .audiobook)
    
    static let book5 = Book(title: "The ocean at the end of the lane", author: "Neil Gaiman", coverImage: UIImage(named: "image5"), bookKind: .audiobook)
    
    static let book6 = Book(title: "The whale road", author: "Robert Low", coverImage: UIImage(named: "image6"), bookKind: .audiobook)
    
    static let book7 = Book(title: "What moves the dead", author: "T. Kingfisher", coverImage: UIImage(named: "image7"), bookKind: .audiobook)
    
    static let book8 = Book(title: "Milk fed", author: "Melissa Broder", coverImage: UIImage(named: "image8"), bookKind: .audioBookAndEbook)
    
    static let book9 = Book(title: "Kindred", author: "Octavia E. Butler", coverImage: UIImage(named: "image9"), bookKind: .audiobook)
    
    static let book10 = Book(title: "Brick lane", author: "Monica Ali", coverImage: UIImage(named: "image10"), bookKind: .ebook)
    
    
    
    
    static let book11 = Book(title: "Kodiak", author: "César Pérez Gellida", coverImage: UIImage(named: "kodiak"), largeCoverImage: UIImage(named: "kodiakLarge"), bookKind: .audioBookAndEbook)
    
    static let book12 = Book(title: "El resto de tu vida fue ayer", author: "Ángela Vallvey", coverImage: UIImage(named: "elRestoDeTuVidaFueAyer"), largeCoverImage: UIImage(named: "elRestoDeTuVidaFueAyerLarge"), bookKind: .audioBookAndEbook)
    
    static let book13 = Book(title: "Julia Menken", author: "Chantal van Mierlo", coverImage: UIImage(named: "juliaMenken"), largeCoverImage: UIImage(named: "juliaMenkenLarge"), bookKind: .audioBookAndEbook)
    
    static let book14 = Book(title: "Muerte en Padmasana", author: "Susana Martín Gijón", coverImage: UIImage(named: "muerteEnPadmasana"), largeCoverImage: UIImage(named: "muerteEnPadmasanaLarge"), bookKind: .audioBookAndEbook)
    
    static let book15 = Book(title: "Bogalusa", author: "César Pérez Gellida", coverImage: UIImage(named: "bogalusa"), largeCoverImage: UIImage(named: "bogalusaLarge"), bookKind: .audioBookAndEbook)
    
    static let book16 = Book(title: "No olvides mi nombre", author: "Carlos Aimeur", coverImage: UIImage(named: "noOlvidesMiNombre"), largeCoverImage: UIImage(named: "noOlvidesMiNombreLarge"), bookKind: .audioBookAndEbook)
    
    static let book17 = Book(title: "Odisea", author: "Javier Alonso López", coverImage: UIImage(named: "odisea"), largeCoverImage: UIImage(named: "odiseaLarge"), bookKind: .audioBookAndEbook)
    
    static let book18 = Book(title: "Desajuste de cuentas", author: "Benito Olmo", coverImage: UIImage(named: "desajusteDeCuentas"), largeCoverImage: UIImage(named: "desajusteDeCuentasLarge"), bookKind: .audioBookAndEbook)
    
    static let book19 = Book(title: "La suelta", author: "Juan Gómez-Jurado", coverImage: UIImage(named: "laSuelta"), largeCoverImage: UIImage(named: "laSueltaLarge"), bookKind: .audiobook)
    
}
