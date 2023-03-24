//
//  Book.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

//enum BookKind: String {
//    case audiobook = "Audiobook"
//    case ebook = "Ebook"
//    case audioBookAndEbook = "Audiobook & Ebook"
//}

struct Book: Title {
    let title: String
    let authors: [Author]
    let coverImage: UIImage?
    let largeCoverImage: UIImage?
    let titleKind: TitleKind
    let overview: String
    let category: ButtonCategory
    let rating: Double
    let reviewsNumber: Int
    let duration: String
    let language: Language
    let narrators: [Narrator]?
    let series: String?
    let seriesPart: Int?
    
    init(title: String, authors: [Author], coverImage: UIImage?, largeCoverImage: UIImage? = nil, titleKind: TitleKind, overview: String = "", category: ButtonCategory, rating: Double = 4.5, reviewsNumber: Int = 80, duration: String = "21h 24m", language: Language = .spanish, narrators: [Narrator]? = nil, series: String? = nil, seriesPart: Int? = nil) {
        self.title = title
        self.authors = authors
        self.coverImage = coverImage
        self.largeCoverImage = largeCoverImage
        self.titleKind = titleKind
        self.overview = overview
        self.category = category
        self.rating = rating
        self.reviewsNumber = reviewsNumber
        self.duration = duration
        self.language = language
        self.narrators = narrators
        self.series = series
        self.seriesPart = seriesPart
    }
    
    static let books = [book1, book2, book3, book4, book5, book6, book7, book8, book9, book10]
    
    static let booksWithLargeCovers = [book11, book12, book13, book14, book15, book16, book17, book18, book19]
    
    static let posterBook =  Book(title: "Modo Noche", authors: [Author.brunoLopez, Author.pabloToledo], coverImage: UIImage(named: "modoNoche"), titleKind: .audiobook, category: .thrillerYHorror)
    
    static let book1 = Book(title: "The city of brass", authors: [Author.shannonChakraborty], coverImage: UIImage(named: "image1"), titleKind: .audiobook, category: .novela)
    
    static let book2 = Book(title: "The simple wild", authors: [Author.tucker], coverImage: UIImage(named: "image2"), titleKind: .audioBookAndEbook, category: .novela)
    
    static let book3 = Book(title: "The masterpiece", authors: [Author.francineRivers], coverImage: UIImage(named: "image3"), titleKind: .audiobook, category: .novela, rating: 4.5, language: .english, narrators: [Narrator.narrator1])
    
    static let book4 = Book(title: "The bullet journal method", authors: [Author.ryderCarrol], coverImage: UIImage(named: "image4"), titleKind: .audiobook, category: .crecimientoPersonalYLifestyle)
    
    static let book5 = Book(title: "The ocean at the end of the lane", authors: [Author.neilGaiman], coverImage: UIImage(named: "image5"), titleKind: .audiobook, category: .novela)
    
    static let book6 = Book(title: "The whale road", authors: [Author.robertLow], coverImage: UIImage(named: "image6"), titleKind: .audiobook, category: .novela)
    
    static let book7 = Book(title: "What moves the dead", authors: [Author.kingfisher], coverImage: UIImage(named: "image7"), titleKind: .audiobook, category: .novela)
    
    static let book8 = Book(title: "Milk fed", authors: [Author.melissaBroder], coverImage: UIImage(named: "image8"), titleKind: .audioBookAndEbook, category: .novela)
    
    static let book9 = Book(title: "Kindred", authors: [Author.octaviaButler], coverImage: UIImage(named: "image9"), titleKind: .audiobook, category: .fantasiaYCienciaFiccion)
    
    static let book10 = Book(title: "Brick lane", authors: [Author.monicaAli], coverImage: UIImage(named: "image10"), titleKind: .ebook, category: .novela)
    
    
    
    
    static let book11 = Book(title: "Kodiak", authors: [Author.gellida], coverImage: UIImage(named: "kodiak"), largeCoverImage: UIImage(named: "kodiakLarge"), titleKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book12 = Book(title: "El resto de tu vida fue ayer", authors: [Author.angelaVallvey], coverImage: UIImage(named: "elRestoDeTuVidaFueAyer"), largeCoverImage: UIImage(named: "elRestoDeTuVidaFueAyerLarge"), titleKind: .audioBookAndEbook, category: .thrillerYHorror)
    
    static let book13 = Book(title: "Julia Menken", authors: [Author.chantalVanMierlo], coverImage: UIImage(named: "juliaMenken"), largeCoverImage: UIImage(named: "juliaMenkenLarge"), titleKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book14 = Book(title: "Muerte en Padmasana", authors: [Author.susanaMartinGijon], coverImage: UIImage(named: "muerteEnPadmasana"), largeCoverImage: UIImage(named: "muerteEnPadmasanaLarge"), titleKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book15 = Book(title: "Bogalusa", authors: [Author.pabloToledo], coverImage: UIImage(named: "bogalusa"), largeCoverImage: UIImage(named: "bogalusaLarge"), titleKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book16 = Book(title: "No olvides mi nombre", authors: [Author.pabloToledo], coverImage: UIImage(named: "noOlvidesMiNombre"), largeCoverImage: UIImage(named: "noOlvidesMiNombreLarge"), titleKind: .audioBookAndEbook, category: .novela)
    
    static let book17 = Book(title: "Odisea", authors: [Author.pabloToledo], coverImage: UIImage(named: "odisea"), largeCoverImage: UIImage(named: "odiseaLarge"), titleKind: .audioBookAndEbook, category: .clasicos)
    
    static let book18 = Book(title: "Desajuste de cuentas", authors: [Author.pabloToledo], coverImage: UIImage(named: "desajusteDeCuentas"), largeCoverImage: UIImage(named: "desajusteDeCuentasLarge"), titleKind: .audioBookAndEbook, category: .novelaNegra)
    
    static let book19 = Book(title: "La suelta", authors: [Author.pabloToledo], coverImage: UIImage(named: "laSuelta"), largeCoverImage: UIImage(named: "laSueltaLarge"), titleKind: .audiobook, category: .thrillerYHorror)
    
    static let book20 = Book(title: "Sixteenth Summer", authors: [Author.pabloToledo], coverImage: UIImage(named: "sixteenthSummer"), titleKind: .ebook, overview: "Anna is dreading another tourist-filled summer on Dune Island that follows the same routine: beach, ice cream, friends, repeat. That is, until she locks eyes with Will, the gorgeous and sweet guy visiting from New York. Soon, her summer is filled with flirtatious fun as Anna falls head over heels in love.\nBut with every perfect afternoon, sweet kiss, and walk on the beach, Anna can’t ignore that the days are quickly growing shorter, and Will has to leave at the end of August. Anna’s never felt anything like this before, but when forever isn’t even a possibility, one summer doesn’t feel worth the promise of her heart breaking…", category: .juvenilYYoungAdult, rating: 3.0, language: .english)
    
    static let book21 = Book(title: "Todos quieren a Daisy Jones", authors: [Author.pabloToledo], coverImage: UIImage(named: "image21"), titleKind: .ebook, category: .novela, rating: 4.3)
    
    static let book22 = Book(title: "La travesía final", authors: [Author.pabloToledo], coverImage: UIImage(named: "image22"), titleKind: .ebook, category: .novela, rating: 4.7)
    
    static let book23 = Book(title: "El hombre nacido en Danzig", authors: [Author.pabloToledo], coverImage: UIImage(named: "image23"), titleKind: .ebook, category: .novela, rating: 0.0)
    
    
    
    static let bookWithOverview = Book(
        title: "La cuenta atrás para el verano: La vida son recuerdos y los míos tienen nombres de persona",
        authors: [Author.pabloToledo], coverImage: UIImage(named: "bookWithOverview"), titleKind: .audiobook, overview: "¿Sabrías decir cuántas personas han formado parte de tu vida y cuántas han sido capaces de cambiarla? Las últimas son las que realmente importan.\nLauri, la primera y más responsable amiga de la infancia y Nacho, mi primer amor de la adolescencia. La malhumorada y siempre sincera Lucía, la calmada Sara y el sarcástico Pol. También Álex, el que siempre vuelve, y la única mujer capaz de susurrar gritando, Laura. Y por supuesto, MI PADRE, en mayúsculas.", category: .novela)
    
    static let bookWithOverview1 = Book(title: "La mujer que quería más", authors: [Author.pabloToledo], coverImage: UIImage(named: "bookWithOverview1"), titleKind: .audioBookAndEbook, overview: "Una historia entrañable para aprender la mejor lección que la vida te puede dar: nunca debe darte vergüenza pedir más…\n\nKate rompe con su novio justo cuando estaban a punto de irse a vivir juntos y, después de pasarse algunos días comiendo ganchitos debajo del edredón, decide volver a casa de su madre, al filo de los cuarenta. Para despejar su mente empieza a colaborar con la Residencia Lauderdale para damas excepcionales. Allí conoce a Cecily Finn, una mujer de noventa y seis años, punzante como una aguja y con una vida fascinante. Cecily le recomienda un manual de autoayuda diferente, un libro de recetas de 1957, con menús para cualquier situación y que promete respuestas a preguntas esenciales.\n\n¿Podrá encontrar Kate el menú ideal para su corazón roto?\n\nAsí comienza una entrañable relación entre dos almas solitarias y obstinadas, que deben demostrarse la una a la otra que la comida es un placer al que no debemos renunciar, que la vida es para vivirla y que el camino al corazón de un hombre resulta… irrelevante.", category: .novela)
    
    static let bookWithOverview2 = Book(title: "Mariposas heladas", authors: [Author.pabloToledo], coverImage: UIImage(named: "bookWithOverview2"), titleKind: .audiobook, overview: "Una gélida mañana de invierno, el cuerpo sin vida de una monja, que aparentemente ha sido atropellada por un coche, aparece en las afueras de Lipowo, una localidad situada al norte de Varsovia. Pero pronto queda fuera de duda que primero fue asesinada y luego simularon un accidente. Unos días después, cuando aparece el cadáver de otra mujer, sin que entre ellas hubiera un vínculo aparente, la Policía debe darse prisa antes de que el asesino actúe de nuevo.\nLas sospechas recaerán sobre algunos de los habitantes del pueblo: la propietaria de una tienda, el heredero de una familia adinerada o el hijo de uno de los oficiales de la Policía. La comisaria Klementyna Kopp y el comisario Daniel Podgórski tendrán que ponerse manos a la obra, investigar la verdadera identidad de la monja, su pasado y los motivos que la llevaron a Lipowo. Esta vez, además de con su equipo, Daniel contará con la ayuda de una recién llegada, Veronika —psicóloga que viene de Varsovia, acaba de divorciarse y busca un nuevo comienzo lejos de la ciudad—, por la que se siente irresistiblemente atraído.", category: .novelaNegra)
    
    static let senorDeLosAnillos1 = Book(title: "El Señor de los Anillos n° 01/03 La Comunidad del Anillo", authors: [Author.tolkien], coverImage: UIImage(named: "series1book1"), largeCoverImage: nil, titleKind: .audiobook, overview: "«Este libro es como un relámpago en un cielo claro. Decir que la novela heroica, espléndida, elocuente y desinhibida, ha retornado de pronto en una época de un antirromanticismo casi patológico, sería inadecuado. Para quienes vivimos en esa extraña época, el retorno —y el alivio que nos trae— es sin duda lo más importante. Pero para la historia misma de la novela —una historia que se remonta a la Odisea y a antes de la Odisea— no es un retorno, sino un paso adelante o una revolución: la conquista de un territorio nuevo.» —C.S. Lewis, Time & Tide, 1954\n«La obra de Tolkien, difundida en millones de ejemplares, traducida a docenas de lenguas, inspiradora de slogans pintados en las paredes de Nueva York y de Buenos Aires... una coherente mitología de una autenticidad universal creada en pleno siglo veinte.» —George Steiner, Le Monde, 1973", category: .fantasiaYCienciaFiccion, rating: 4.8, duration: "22h 29m", language: .spanish, narrators: [Narrator.narrator1, Narrator.narrator2], series: "El señor de los anillos", seriesPart: 1)
    
    static let senorDeLosAnillos2 = Book(title: "El Señor de los Anillos n° 02/03 Las Dos Torres", authors: [Author.tolkien], coverImage: UIImage(named: "series1book2"), largeCoverImage: nil, titleKind: .audiobook, overview: "«Ningún escritor del género ha aprovechado tanto como Tolkien las propiedades características de la Misión, el viaje heróico, el Objeto Numinoso, satisfaciendo nuestro sentido de la realidad histórica y social… Tolkien ha triunfado donde fracasó Milton.» —W.H. Auden\n«La invención de los pueblos extraños, incidentes curiosos u hechos maravillosos es en este segundo volumen de la trilogía tan exuberante y convincente como siempre. A medida que avanza la historia, el mundo del Anillo crece en dimensión y misterio, poblado por figuras curiosas, terroríficas, adorables o divertidas. La historia misma es soberbia.» —The Observer", category: .fantasiaYCienciaFiccion, rating: 4.8, duration: "20h 1m", language: .spanish, narrators: [Narrator.narrator1, Narrator.narrator2], series: "El señor de los anillos", seriesPart: 2)

}

