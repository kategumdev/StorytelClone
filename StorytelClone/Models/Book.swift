//
//  Book.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

struct Book: Title, Equatable {
    
    // MARK: - Instance properties
    let id, title, overview, duration, language, releaseDate, publisher: String
    var imageURLString, audioUrlString: String?
    let series: String?
    let authors, narrators: [Storyteller]
    var isFinished, isDownloaded: Bool
    var coverImage: UIImage? // needed only for hardcoded book objects
    var titleKind: TitleKind
    let category: Category
    let rating: Double
    let reviewsNumber: Int
    let seriesPart: Int?
    let translators: [String]?
    let tags: [Tag]
    
    private let dataPersistenceManager: any DataPersistenceManager
    
    // MARK: - Initializer
    init(id: String, title: String, authors: [Storyteller],
         coverImage: UIImage?, titleKind: TitleKind, overview: String = "No overview added",
         category: Category, rating: Double = 4.5, reviewsNumber: Int = 80,
         duration: String = "21h 24m", language: String = "Spanish",
         narrators: [Storyteller] = [Storyteller](), series: String? = nil,
         seriesPart: Int? = nil, releaseDate: String = "Unknown",
         publisher: String = "Publisher", translators: [String]? = nil, tags: [Tag] = [Tag](),
         isFinished: Bool = false, isDownloaded: Bool = false, imageURLString: String? = nil,
         audioUrlString: String? = nil,
         dataPersistenceManager: some DataPersistenceManager = CoreDataManager.shared) {
        self.id = id
        self.title = title
        self.authors = authors
        self.coverImage = coverImage
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
        self.releaseDate = releaseDate
        self.publisher = publisher
        self.translators = translators
        self.tags = tags
        self.isFinished = isFinished
        self.isDownloaded = isDownloaded
        self.imageURLString = imageURLString
        self.audioUrlString = audioUrlString
        self.dataPersistenceManager = dataPersistenceManager
    }
    
    // MARK: - Instance methods
    func isOnBookshelf() -> Bool {
        let bookId = self.id
        var isBookAdded = false
        
        dataPersistenceManager.fetchPersistedBookWith(id: bookId) { result in
            switch result {
            case .success(let persistedBook):
                isBookAdded = persistedBook != nil ? true : false
            case .failure(let error):
                isBookAdded = false
                print("Error when fetching book with id \(bookId)" + error.localizedDescription)
            }
        }
        return isBookAdded
    }

}

// MARK: - Static methods
extension Book {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func createBooksFromEbooks(_ ebooks: [Ebook]?) -> [Book] {
        var createdBooks = [Book]()
        guard let unwrappedEbooks = ebooks else {
            return createdBooks
        }
        
        for ebook in unwrappedEbooks {
            let imageLinks = ebook.volumeInfo.imageLinks
            
            // Get link to the largest available image
            let imageURLString = [ImageLink.large, .medium, .small, .thumbnail]
                .compactMap { imageLinks?[$0.rawValue] }
                .first ?? ""
                        
            let book = Book(
                id: ebook.id,
                title: ebook.volumeInfo.title,
                authors: Storyteller.createAuthorFrom(names: ebook.volumeInfo.authors),
                coverImage: nil,
                titleKind: .ebook,
                overview: ebook.volumeInfo.description ?? "This book has no description",
                category: .ebooks,
                rating: ebook.volumeInfo.averageRating ?? 0.0,
                reviewsNumber: ebook.volumeInfo.ratingsCount ?? 0,
                language: ebook.volumeInfo.language?.convertLanguageCodeIntoString() ?? "Unknown",
                releaseDate: ebook.volumeInfo.publishedDate?.formatDate() ?? "Unknown",
                publisher: ebook.volumeInfo.publisher ?? "Unknown",
                tags: Tag.createTagsFrom(strings: ebook.volumeInfo.categories),
                imageURLString: imageURLString
            )
            createdBooks.append(book)
        }
        return createdBooks
    }
    
    static func createBooksFromAudiobooks(_ audiobooks: [Audiobook]?) -> [Book] {
        var createdBooks = [Book]()
        guard let unwrappedAudiobooks = audiobooks else {
            return createdBooks
        }
        
        for audiobook in unwrappedAudiobooks {
            let description: String = audiobook.description?.removeHTMLTags() ?? "This book has no description"
            
            let imageSize = UIDevice.current.userInterfaceIdiom == .pad ? "800x800" : "400x400"
            let imageUrlString = audiobook.largeImageUrl?.replacingOccurrences(of: "100x100", with: imageSize)

            var stringsForTags = [String]()
            if let string = audiobook.genre {
                stringsForTags.append(string)
            }
            
            let book = Book(
                id: audiobook.id,
                title: audiobook.bookName,
                authors: Storyteller.createAuthorFrom(names: [audiobook.authorName]),
                coverImage: nil,
                titleKind: .audiobook,
                overview: description,
                category: .novela,
                rating: 0.0,
                reviewsNumber: 0,
                language: description.detectLanguage() ?? "Unknown",
                releaseDate: audiobook.releaseDate?.formatDate() ?? "Unknown",
                publisher: "Unknown",
                tags: Tag.createTagsFrom(strings: stringsForTags),
                imageURLString: imageUrlString,
                audioUrlString: audiobook.audioUrlString
            )
            createdBooks.append(book)
        }
        return createdBooks
    }

}

// MARK: - Static properties
extension Book {
    static let books = [book1, book23, book3, book22, book21, book6, book7, book8, book9, book10]
    
    static let initialBooksForSearchResultsVC = [
        Book.book1,
        Book.book23,
        Book.senorDeLosAnillos1,
        Book.book2,
        Book.book22,
        Book.book5,
        Book.book20,
        Book.book7,
        Book.book8,
        Book.book21,
        Book.book9,
        Book.book18,
        Book.book17,
        Book.book15,
        Book.book4,
        Book.book6,
        Book.book19
    ]
        
    static let book1 = Book(
        id: "01",
        title: "The city of brass",
        authors: [Storyteller.shannonChakraborty],
        coverImage: UIImage(named: "image1"),
        titleKind: .audiobook,
        overview: "Discover this spellbinding debut from S.A. Chakraborty.\n\n\n‘An extravagant feast of a book – spicy and bloody, dizzyingly magical, and still, somehow, utterly believable’ Laini Taylor, Sunday Times and New York Times bestselling author\n\n\nAmong the bustling markets of eighteenth century Cairo, the city’s outcasts eke out a living swindling rich Ottoman nobles and foreign invaders alike.\n\nBut alongside this new world the old stories linger. Tales of djinn and spirits. Of cities hidden among the swirling sands of the desert, full of enchantment, desire and riches. Where magic pours down every street, hanging in the air like dust.\n\nMany wish their lives could be filled with such wonder, but not Nahri. She knows the trades she uses to get by are just tricks and sleights of hand: there’s nothing magical about them. She only wishes to one day leave Cairo, but as the saying goes…\n\nBe careful what you wish for.",
        category: .novela,
        tags: Tag.twoTags
    )
    
    static let book2 = Book(
        id: "02",
        title: "The simple wild",
        authors: [Storyteller.tucker],
        coverImage: UIImage(named: "image2"),
        titleKind: .audioBookAndEbook,
        overview: "City girl Calla Fletcher attempts to reconnect with her estranged father, and unwittingly finds herself torn between her desire to return to the bustle of Toronto and a budding relationship with a rugged Alaskan pilot in this masterful new romance from acclaimed author K.A. Tucker.\n\nCalla Fletcher was two when her mother took her and fled the Alaskan wild, unable to handle the isolation of the extreme, rural lifestyle, leaving behind Calla’s father, Wren Fletcher, in the process. Calla never looked back, and at twenty-six, a busy life in Toronto is all she knows. But when her father reaches out to inform her that his days are numbered, Calla knows that it’s time to make the long trip back to the remote frontier town where she was born.\n\nShe braves the roaming wildlife, the odd daylight hours, the exorbitant prices, and even the occasional—dear God—outhouse, all for the chance to connect with her father: a man who, despite his many faults, she can’t help but care for. While she struggles to adjust to this new subarctic environment, Jonah—the quiet, brooding, and proud Alaskan pilot who keeps her father’s charter plane company operational—can’t imagine calling anywhere else home. And he’s clearly waiting with one hand on the throttle to fly this city girl back to where she belongs, convinced that she’s too pampered to handle the wild.\n\nJonah is probably right, but Calla is determined to prove him wrong. As time passes, she unexpectedly finds herself forming a bond with the burly pilot. As his undercurrent of disapproval dwindles, it’s replaced by friendship—or perhaps something deeper? But Calla is not in Alaska to stay and Jonah will never leave. It would be foolish of her to kindle a romance, to take the same path her parents tried—and failed at—years ago.\n\nIt’s a simple truth that turns out to be not so simple after all.",
        category: .novela
    )
    
    static let book3 = Book(
        id: "03",
        title: "The masterpiece",
        authors: [Storyteller.francineRivers],
        coverImage: UIImage(named: "image3"),
        titleKind: .audiobook,
        category: .novela,
        rating: 4.5,
        language: "English",
        narrators: [Storyteller.narrator1]
    )
    
    static let book4 = Book(
        id: "04",
        title: "The bullet journal method",
        authors: [Storyteller.ryderCarrol],
        coverImage: UIImage(named: "image4"),
        titleKind: .audiobook,
        category: .crecimientoPersonalYLifestyle
    )
    
    static let book5 = Book(
        id: "05",
        title: "The ocean at the end of the lane",
        authors: [Storyteller.neilGaiman],
        coverImage: UIImage(named: "image5"),
        titleKind: .audiobook,
        category: .novela
    )
    
    static let book6 = Book(
        id: "06",
        title: "The whale road",
        authors: [Storyteller.robertLow],
        coverImage: UIImage(named: "image6"),
        titleKind: .audiobook,
        category: .novela
    )
    
    static let book7 = Book(
        id: "07",
        title: "What moves the dead",
        authors: [Storyteller.kingfisher],
        coverImage: UIImage(named: "image7"),
        titleKind: .audiobook,
        category: .novela
    )
    
    static let book8 = Book(
        id: "08",
        title: "Milk fed",
        authors: [Storyteller.melissaBroder],
        coverImage: UIImage(named: "image8"),
        titleKind: .audioBookAndEbook,
        category: .novela
    )
    
    static let book9 = Book(
        id: "09",
        title: "Kindred",
        authors: [Storyteller.octaviaButler],
        coverImage: UIImage(named: "image9"),
        titleKind: .audiobook,
        category: .fantasiaYCienciaFiccion
    )
    
    static let book10 = Book(
        id: "10",
        title: "Brick lane",
        authors: [Storyteller.monicaAli],
        coverImage: UIImage(named: "image10"),
        titleKind: .ebook,
        category: .novela
    )
    
    
    static let book11 = Book(
        id: "11",
        title: "Kodiak",
        authors: [Storyteller.gellida],
        coverImage: UIImage(named: "kodiak"),
        titleKind: .audioBookAndEbook,
        category: .novelaNegra
    )
    
    static let book12 = Book(
        id: "12",
        title: "El resto de tu vida fue ayer",
        authors: [Storyteller.angelaVallvey],
        coverImage: UIImage(named: "elRestoDeTuVidaFueAyer"),
        titleKind: .audioBookAndEbook,
        category: .thrillerYHorror
    )
    
    static let book13 = Book(
        id: "13",
        title: "Julia Menken",
        authors: [Storyteller.chantalVanMierlo],
        coverImage: UIImage(named: "juliaMenken"),
        titleKind: .audioBookAndEbook,
        category: .novelaNegra
    )
    
    static let book14 = Book(
        id: "14",
        title: "Muerte en Padmasana",
        authors: [Storyteller.susanaMartinGijon],
        coverImage: UIImage(named: "muerteEnPadmasana"),
        titleKind: .audioBookAndEbook,
        category: .novelaNegra
    )
    
    static let book15 = Book(
        id: "15",
        title: "Bogalusa",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "bogalusa"),
        titleKind: .audioBookAndEbook,
        category: .novelaNegra
    )
    
    static let book16 = Book(
        id: "16",
        title: "No olvides mi nombre",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "noOlvidesMiNombre"),
        titleKind: .audioBookAndEbook,
        category: .novela
    )
    
    static let book17 = Book(
        id: "17",
        title: "Odisea",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "odisea"),
        titleKind: .audioBookAndEbook,
        category: .clasicos
    )
    
    static let book18 = Book(
        id: "18",
        title: "Desajuste de cuentas",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "desajusteDeCuentas"),
        titleKind: .audioBookAndEbook,
        category: .novelaNegra
    )
    
    static let book19 = Book(
        id: "19",
        title: "La suelta",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "laSuelta"),
        titleKind: .audiobook,
        category: .thrillerYHorror
    )
    
    
    static let book20 = Book(
        id: "20",
        title: "Sixteenth Summer",
        authors: [Storyteller.pabloToledo, Storyteller.author1, Storyteller.author3],
        coverImage: UIImage(named: "sixteenthSummer"),
        titleKind: .ebook,
        overview: "Anna is dreading another tourist-filled summer on Dune Island that follows the same routine: beach, ice cream, friends, repeat. That is, until she locks eyes with Will, the gorgeous and sweet guy visiting from New York. Soon, her summer is filled with flirtatious fun as Anna falls head over heels in love.\nBut with every perfect afternoon, sweet kiss, and walk on the beach, Anna can’t ignore that the days are quickly growing shorter, and Will has to leave at the end of August. Anna’s never felt anything like this before, but when forever isn’t even a possibility, one summer doesn’t feel worth the promise of her heart breaking…",
        category: .juvenilYYoungAdult,
        rating: 3.0,
        language: "English"
    )
    
    static let book21 = Book(
        id: "21",
        title: "Todos quieren a Daisy Jones",
        authors: [Storyteller.jenkins],
        coverImage: UIImage(named: "image21"),
        titleKind: .ebook,
        overview: "Tiene el mundo a sus pies, pero todo se le va de las manos.\nElla es la estrella del rock más importante del planeta.\nTodos tienen una opinión sobre ella.\nTodos sueñan con ella.\nTodos buscan ser como ella.\nTodos quieren algo de ella.\n'No soy la musa de alguien. No soy una musa. Soy ese alguien.'\nTodos quieren a Daisy Jones.\n\n'Devoré esta novela en un día. Daisy conquistó mi corazón.'\nReese Witherspoon\nBestseller de The New York Times",
        category: .novela,
        rating: 4.3,
        translators: ["Lucía Barahona"],
        tags: Tag.tags
    )
    
    static let book22 = Book(
        id: "22",
        title: "La travesía final",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "image22"),
        titleKind: .ebook,
        category: .novela,
        rating: 4.7,
        tags: Tag.threeTags
    )
    
    static let book23 = Book(
        id: "23",
        title: "El hombre nacido en Danzig",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "image23"),
        titleKind: .ebook,
        overview: "Riquelme, el detective, es un tipo gris pero eficiente que no está convencido de revelar los resultados de sus investigaciones. Su cliente, protagonista de esa novela, es un hombre doliente y confundido porque su mujer, Elisa Miller, lo ha abandonado. Elena, Mónica, Sonia, son las sombras que atormentan con sus apariciones al desubicado personaje. Séneca, Schopenhauer y Weininger, pero también el jugador de basquetbol Magic Johnson, son las voces que agitan la conciencia del hombre cada vez que éste sostiene diálogos con sus héroes morales y deportivos.",
        category: .novela,
        rating: 0.0,
        tags: Tag.fourTags
    )
    
    static let bookWithOverview = Book(
        id: "24",
        title: "La cuenta atrás para el verano: La vida son recuerdos y los míos tienen nombres de persona",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "bookWithOverview"),
        titleKind: .audiobook,
        overview: "¿Sabrías decir cuántas personas han formado parte de tu vida y cuántas han sido capaces de cambiarla? Las últimas son las que realmente importan.\nLauri, la primera y más responsable amiga de la infancia y Nacho, mi primer amor de la adolescencia. La malhumorada y siempre sincera Lucía, la calmada Sara y el sarcástico Pol. También Álex, el que siempre vuelve, y la única mujer capaz de susurrar gritando, Laura. Y por supuesto, MI PADRE, en mayúsculas.",
        category: .novela
    )
    
    static let bookWithOverview1 = Book(
        id: "25",
        title: "La mujer que quería más",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "bookWithOverview1"),
        titleKind: .audioBookAndEbook,
        overview: "Una historia entrañable para aprender la mejor lección que la vida te puede dar: nunca debe darte vergüenza pedir más…\n\nKate rompe con su novio justo cuando estaban a punto de irse a vivir juntos y, después de pasarse algunos días comiendo ganchitos debajo del edredón, decide volver a casa de su madre, al filo de los cuarenta. Para despejar su mente empieza a colaborar con la Residencia Lauderdale para damas excepcionales. Allí conoce a Cecily Finn, una mujer de noventa y seis años, punzante como una aguja y con una vida fascinante. Cecily le recomienda un manual de autoayuda diferente, un libro de recetas de 1957, con menús para cualquier situación y que promete respuestas a preguntas esenciales.\n\n¿Podrá encontrar Kate el menú ideal para su corazón roto?\n\nAsí comienza una entrañable relación entre dos almas solitarias y obstinadas, que deben demostrarse la una a la otra que la comida es un placer al que no debemos renunciar, que la vida es para vivirla y que el camino al corazón de un hombre resulta… irrelevante.",
        category: .novela,
        tags: Tag.manyTags
    )
    
    static let bookWithOverview2 = Book(
        id: "26",
        title: "Mariposas heladas",
        authors: [Storyteller.pabloToledo],
        coverImage: UIImage(named: "bookWithOverview2"),
        titleKind: .audiobook,
        overview: "Una gélida mañana de invierno, el cuerpo sin vida de una monja, que aparentemente ha sido atropellada por un coche, aparece en las afueras de Lipowo, una localidad situada al norte de Varsovia. Pero pronto queda fuera de duda que primero fue asesinada y luego simularon un accidente. Unos días después, cuando aparece el cadáver de otra mujer, sin que entre ellas hubiera un vínculo aparente, la Policía debe darse prisa antes de que el asesino actúe de nuevo.\nLas sospechas recaerán sobre algunos de los habitantes del pueblo: la propietaria de una tienda, el heredero de una familia adinerada o el hijo de uno de los oficiales de la Policía. La comisaria Klementyna Kopp y el comisario Daniel Podgórski tendrán que ponerse manos a la obra, investigar la verdadera identidad de la monja, su pasado y los motivos que la llevaron a Lipowo. Esta vez, además de con su equipo, Daniel contará con la ayuda de una recién llegada, Veronika —psicóloga que viene de Varsovia, acaba de divorciarse y busca un nuevo comienzo lejos de la ciudad—, por la que se siente irresistiblemente atraído.",
        category: .novelaNegra,
        rating: 0.5,
        tags: [Tag(tagTitle: "Aventura"), Tag(tagTitle: "Fantasía"), Tag(tagTitle: "Novela negra")]
    )
    
    static let senorDeLosAnillos1 = Book(
        id: "27",
        title: "El Señor de los Anillos n° 01/03 La Comunidad del Anillo",
        authors: [Storyteller.tolkien],
        coverImage: UIImage(named: "series1book1"),
        titleKind: .audiobook,
        overview: "«Este libro es como un relámpago en un cielo claro. Decir que la novela heroica, espléndida, elocuente y desinhibida, ha retornado de pronto en una época de un antirromanticismo casi patológico, sería inadecuado. Para quienes vivimos en esa extraña época, el retorno —y el alivio que nos trae— es sin duda lo más importante. Pero para la historia misma de la novela —una historia que se remonta a la Odisea y a antes de la Odisea— no es un retorno, sino un paso adelante o una revolución: la conquista de un territorio nuevo.» —C.S. Lewis, Time & Tide, 1954\n«La obra de Tolkien, difundida en millones de ejemplares, traducida a docenas de lenguas, inspiradora de slogans pintados en las paredes de Nueva York y de Buenos Aires... una coherente mitología de una autenticidad universal creada en pleno siglo veinte.» —George Steiner, Le Monde, 1973",
        category: .fantasiaYCienciaFiccion,
        rating: 4.8,
        duration: "22h 29m",
        language: "Spanish",
        narrators: [Storyteller.narrator1, Storyteller.narrator2],
        series: "El señor de los anillos",
        seriesPart: 1,
        translators: ["Matilde Horne", "Luis Doménech"],
        tags: Tag.tagsBookVC
    )
    
    static let senorDeLosAnillos2 = Book(
        id: "28",
        title: "El Señor de los Anillos n° 02/03 Las Dos Torres",
        authors: [Storyteller.tolkien],
        coverImage: UIImage(named: "series1book2"),
        titleKind: .audiobook,
        overview: "«Ningún escritor del género ha aprovechado tanto como Tolkien las propiedades características de la Misión, el viaje heróico, el Objeto Numinoso, satisfaciendo nuestro sentido de la realidad histórica y social… Tolkien ha triunfado donde fracasó Milton.» —W.H. Auden\n«La invención de los pueblos extraños, incidentes curiosos u hechos maravillosos es en este segundo volumen de la trilogía tan exuberante y convincente como siempre. A medida que avanza la historia, el mundo del Anillo crece en dimensión y misterio, poblado por figuras curiosas, terroríficas, adorables o divertidas. La historia misma es soberbia.» —The Observer",
        category: .fantasiaYCienciaFiccion,
        rating: 4.8,
        duration: "20h 1m",
        language: "Spanish",
        narrators: [Storyteller.narrator1, Storyteller.narrator2],
        series: "El señor de los anillos",
        seriesPart: 2,
        translators: ["Matilde Horne", "Luis Doménech"]
    )
    
}

