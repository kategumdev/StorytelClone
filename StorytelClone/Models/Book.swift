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
    let overview: String
    let category: ButtonCategory
    let rating: Double
    let duration: String
    let language: String
    
    init(title: String, author: String, coverImage: UIImage?, largeCoverImage: UIImage? = nil, bookKind: BookKind, overview: String = "", category: ButtonCategory, rating: Double = 4.5, duration: String = "5h 5m", language: String = "Spanish") {
        self.title = title
        self.author = author
        self.coverImage = coverImage
        self.largeCoverImage = largeCoverImage
        self.bookKind = bookKind
        self.overview = overview
        self.category = category
        self.rating = rating
        self.duration = duration
        self.language = language
    }
    
    static let books = [book1, book2, book3, book4, book5, book6, book7, book8, book9, book10]
    
    static let booksWithLargeCovers = [book11, book12, book13, book14, book15, book16, book17, book18, book19]
    
    static let posterBook =  Book(title: "Modo Noche", author: "Bruno Teixidor López, Pablo Lara Toledo", coverImage: UIImage(named: "modoNoche"), bookKind: .audiobook, category: .thrillerYHorror)
    
    static let book1 = Book(title: "The city of brass", author: "Shannon Chakraborty", coverImage: UIImage(named: "image1"), bookKind: .audiobook, category: .novela)
    
    static let book2 = Book(title: "The simple wild", author: "K.A. Tucker", coverImage: UIImage(named: "image2"), bookKind: .audioBookAndEbook, category: .novela)
    
    static let book3 = Book(title: "The masterpiece", author: "Francine Rivers", coverImage: UIImage(named: "image3"), bookKind: .audiobook, category: .novela)
    
    static let book4 = Book(title: "The bullet journal method", author: "Ryder Carrol", coverImage: UIImage(named: "image4"), bookKind: .audiobook, category: .crecimientoPersonalYLifestyle)
    
    static let book5 = Book(title: "The ocean at the end of the lane", author: "Neil Gaiman", coverImage: UIImage(named: "image5"), bookKind: .audiobook, category: .novela)
    
    static let book6 = Book(title: "The whale road", author: "Robert Low", coverImage: UIImage(named: "image6"), bookKind: .audiobook, category: .novela)
    
    static let book7 = Book(title: "What moves the dead", author: "T. Kingfisher", coverImage: UIImage(named: "image7"), bookKind: .audiobook, category: .novela)
    
    static let book8 = Book(title: "Milk fed", author: "Melissa Broder", coverImage: UIImage(named: "image8"), bookKind: .audioBookAndEbook, category: .novela)
    
    static let book9 = Book(title: "Kindred", author: "Octavia E. Butler", coverImage: UIImage(named: "image9"), bookKind: .audiobook, category: .fantasiaYCienciaFiccion)
    
    static let book10 = Book(title: "Brick lane", author: "Monica Ali", coverImage: UIImage(named: "image10"), bookKind: .ebook, category: .novela)
    
    
    
    
    static let book11 = Book(title: "Kodiak", author: "César Pérez Gellida", coverImage: UIImage(named: "kodiak"), largeCoverImage: UIImage(named: "kodiakLarge"), bookKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book12 = Book(title: "El resto de tu vida fue ayer", author: "Ángela Vallvey", coverImage: UIImage(named: "elRestoDeTuVidaFueAyer"), largeCoverImage: UIImage(named: "elRestoDeTuVidaFueAyerLarge"), bookKind: .audioBookAndEbook, category: .thrillerYHorror)
    
    static let book13 = Book(title: "Julia Menken", author: "Chantal van Mierlo", coverImage: UIImage(named: "juliaMenken"), largeCoverImage: UIImage(named: "juliaMenkenLarge"), bookKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book14 = Book(title: "Muerte en Padmasana", author: "Susana Martín Gijón", coverImage: UIImage(named: "muerteEnPadmasana"), largeCoverImage: UIImage(named: "muerteEnPadmasanaLarge"), bookKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book15 = Book(title: "Bogalusa", author: "César Pérez Gellida", coverImage: UIImage(named: "bogalusa"), largeCoverImage: UIImage(named: "bogalusaLarge"), bookKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book16 = Book(title: "No olvides mi nombre", author: "Carlos Aimeur", coverImage: UIImage(named: "noOlvidesMiNombre"), largeCoverImage: UIImage(named: "noOlvidesMiNombreLarge"), bookKind: .audioBookAndEbook, category: .novela)
    
    static let book17 = Book(title: "Odisea", author: "Javier Alonso López", coverImage: UIImage(named: "odisea"), largeCoverImage: UIImage(named: "odiseaLarge"), bookKind: .audioBookAndEbook, category: .clasicos)
    
    static let book18 = Book(title: "Desajuste de cuentas", author: "Benito Olmo", coverImage: UIImage(named: "desajusteDeCuentas"), largeCoverImage: UIImage(named: "desajusteDeCuentasLarge"), bookKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book19 = Book(title: "La suelta", author: "Juan Gómez-Jurado", coverImage: UIImage(named: "laSuelta"), largeCoverImage: UIImage(named: "laSueltaLarge"), bookKind: .audiobook, category: .thrillerYHorror)
    
    
    
    static let bookWithOverview = Book(
        title: "La cuenta atrás para el verano: La vida son recuerdos y los míos tienen nombres de persona",
        author: "La Vecina Rubia", coverImage: UIImage(named: "bookWithOverview"), bookKind: .audiobook, overview: "¿Sabrías decir cuántas personas han formado parte de tu vida y cuántas han sido capaces de cambiarla? Las últimas son las que realmente importan.\nLauri, la primera y más responsable amiga de la infancia y Nacho, mi primer amor de la adolescencia. La malhumorada y siempre sincera Lucía, la calmada Sara y el sarcástico Pol. También Álex, el que siempre vuelve, y la única mujer capaz de susurrar gritando, Laura. Y por supuesto, MI PADRE, en mayúsculas.", category: .novela)
    
    static let bookWithOverview1 = Book(title: "La mujer que quería más", author: "Vicky Zimmerman", coverImage: UIImage(named: "bookWithOverview1"), bookKind: .audioBookAndEbook, overview: "Una historia entrañable para aprender la mejor lección que la vida te puede dar: nunca debe darte vergüenza pedir más…\n\nKate rompe con su novio justo cuando estaban a punto de irse a vivir juntos y, después de pasarse algunos días comiendo ganchitos debajo del edredón, decide volver a casa de su madre, al filo de los cuarenta. Para despejar su mente empieza a colaborar con la Residencia Lauderdale para damas excepcionales. Allí conoce a Cecily Finn, una mujer de noventa y seis años, punzante como una aguja y con una vida fascinante. Cecily le recomienda un manual de autoayuda diferente, un libro de recetas de 1957, con menús para cualquier situación y que promete respuestas a preguntas esenciales.\n\n¿Podrá encontrar Kate el menú ideal para su corazón roto?\n\nAsí comienza una entrañable relación entre dos almas solitarias y obstinadas, que deben demostrarse la una a la otra que la comida es un placer al que no debemos renunciar, que la vida es para vivirla y que el camino al corazón de un hombre resulta… irrelevante.", category: .novela)
    
    static let bookWithOverview2 = Book(title: "Mariposas heladas", author: "Katarzyna Puzyńska", coverImage: UIImage(named: "bookWithOverview2"), bookKind: .audiobook, overview: "Una gélida mañana de invierno, el cuerpo sin vida de una monja, que aparentemente ha sido atropellada por un coche, aparece en las afueras de Lipowo, una localidad situada al norte de Varsovia. Pero pronto queda fuera de duda que primero fue asesinada y luego simularon un accidente. Unos días después, cuando aparece el cadáver de otra mujer, sin que entre ellas hubiera un vínculo aparente, la Policía debe darse prisa antes de que el asesino actúe de nuevo.\nLas sospechas recaerán sobre algunos de los habitantes del pueblo: la propietaria de una tienda, el heredero de una familia adinerada o el hijo de uno de los oficiales de la Policía. La comisaria Klementyna Kopp y el comisario Daniel Podgórski tendrán que ponerse manos a la obra, investigar la verdadera identidad de la monja, su pasado y los motivos que la llevaron a Lipowo. Esta vez, además de con su equipo, Daniel contará con la ayuda de una recién llegada, Veronika —psicóloga que viene de Varsovia, acaba de divorciarse y busca un nuevo comienzo lejos de la ciudad—, por la que se siente irresistiblemente atraído.", category: .novelaNegra)
    

}