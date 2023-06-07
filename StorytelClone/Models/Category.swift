//
//  Category.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/2/23.
//

import UIKit

enum SubCategoryKind {
    case horizontalCv
    case verticalCv
    case oneBookWithOverview
    case poster
    case largeCoversHorizontalCv
    case seriesCategoryButton
    case allCategoriesButton
    case searchVc
}

enum BookKinds {
    case onlyEbooks
    case onlyAudiobooks
    case ebooksAndAudiobooks
}

struct SubCategory {
    let title: String
    let subtitle: String
    let kind: SubCategoryKind
    let searchQuery: String
    let books: [Book]
    let description: String?
    var toShowTitleModel: Title?
    let canBeShared: Bool
    let canBeFiltered: Bool
    let categoryToShow: Category?
    let bookKinds: BookKinds
    #warning("add property bookKinds with values: onlyEbooks, onlyAudiobooks, ebookAndAudiobooks, fetch data in network manager checking this property")
    
    init(title: String, subtitle: String = "", kind: SubCategoryKind = .horizontalCv, searchQuery: String, books: [Book] = Book.books, description: String? = nil, toShowTitleModel: Title? = nil, canBeShared: Bool = true, canBeFiltered: Bool = true, categoryToShow: Category? = nil, bookKinds: BookKinds = .ebooksAndAudiobooks) {
        self.title = title
        self.subtitle = subtitle
        self.kind = kind
        self.searchQuery = searchQuery
        self.books = books
        self.description = description
        self.toShowTitleModel = toShowTitleModel
        self.canBeShared = canBeShared
        self.canBeFiltered = canBeFiltered
        self.categoryToShow = categoryToShow
        self.bookKinds = bookKinds
    }
    
    static let generalForAllTitlesVC = SubCategory(title: "", searchQuery: "")
    static let similarTitles = SubCategory(title: "Similar titles", searchQuery: "", canBeShared: false)
    static let librosSimilares = SubCategory(title: "Libros similares", searchQuery: "", canBeShared: false)
}

enum ButtonCategory: String {
    
    case series = "Series"
    case soloEnStorytel = "Solo en Storytel"
    case losMasPopulares = "Los más populares"
    case soloParaTi = "Solo para ti"
    case ebooks = "Ebooks"
    case historiasParaCadaEmocion = "Historias para\ncada emoción"
    
    case novela = "Novela"
    case zonaPodcast = "Zona Podcast"
    case novelaNegra = "Novela negra"
    case romantica = "Romántica"
    case thrillerYHorror = "Thriller y Horror"
    case fantasiaYCienciaFiccion = "Fantasía y\nCiencia ficción"
    case crecimientoPersonalYLifestyle = "Crecimiento\npersonal y Lifestyle"
    case infantil = "Infantil"
    case clasicos = "Clásicos"
    case juvenilYYoungAdult = "Juvenil y\nYoung Adult"
    case erotica = "Erótica"
    case noFiccion = "No ficción"
    case economiaYNegocios = "Economía\ny negocios"
    case relatosCortos = "Relatos cortos"
    case historia = "Historia"
    case espiritualidadYReligion = "Espiritualidad\ny Religión"
    case biografias = "Biografías"
    case poesiaYTeatro = "Poesía y Teatro"
    case aprenderIdiomas = "Aprender idiomas"
    case inEnglish = "In English"
    
    static let buttonCategoriesForAllCategories: [ButtonCategory] = [
        novela, zonaPodcast, novelaNegra, romantica,
        thrillerYHorror, fantasiaYCienciaFiccion,
        crecimientoPersonalYLifestyle, infantil,
        juvenilYYoungAdult, clasicos, historia, noFiccion, erotica,
        relatosCortos, economiaYNegocios,
        espiritualidadYReligion, biografias, poesiaYTeatro,
        aprenderIdiomas, inEnglish
    ]
    
    static let buttonCategoriesForSearchVc: [ButtonCategory] = [
        series, zonaPodcast, soloEnStorytel, losMasPopulares,
        soloParaTi, ebooks, novela, novelaNegra, romantica,
        thrillerYHorror, fantasiaYCienciaFiccion, infantil,
        juvenilYYoungAdult, crecimientoPersonalYLifestyle,
        historia, noFiccion, erotica, relatosCortos,
        economiaYNegocios, espiritualidadYReligion, biografias,
        poesiaYTeatro, historiasParaCadaEmocion, aprenderIdiomas,
        inEnglish
    ]
    
    var category: Category {
        switch self {
        case .series: return Category.series
        case .soloEnStorytel: return Category.soloEnStorytel
        case .losMasPopulares: return Category.losMasPopulares
        case .soloParaTi: return Category.soloParaTi
        case .ebooks: return Category.eBooks
        case .historiasParaCadaEmocion: return Category.historiasParaCadaEmocion
        
        case .novela: return Category.novela
        case .zonaPodcast: return Category.zonaPodcast
        case .novelaNegra: return Category.novelaNegra
        case .romantica: return Category.romantica
        case .thrillerYHorror: return Category.thrillerYHorror
        case .fantasiaYCienciaFiccion: return Category.fantasiaYCienciaFiccion
        case .crecimientoPersonalYLifestyle: return Category.crecimientoPersonalYLifestyle
        case .infantil: return Category.infantil
        case .clasicos: return Category.clasicos
        case .juvenilYYoungAdult: return Category.juvenilYYoungAdult
        case .erotica: return Category.erotica
        case .noFiccion: return Category.noFiccion
        case .economiaYNegocios: return Category.economiaYNegocios
        case .relatosCortos: return Category.relatosCortos
        case .historia: return Category.historia
        case .espiritualidadYReligion: return Category.espiritualidadYReligion
        case .biografias: return Category.biografias
        case .poesiaYTeatro: return Category.poesiaYTeatro
        case .aprenderIdiomas: return Category.aprenderIdiomas
        case .inEnglish: return Category.inEnglish
        }
    }
    
    var colorForBackground: UIColor {
        switch self {
        case .series, .novela, .clasicos, .poesiaYTeatro: return UIColor.customCyan
        case .soloEnStorytel, .infantil, .juvenilYYoungAdult: return UIColor.customOrange
        case .losMasPopulares, .historiasParaCadaEmocion, .romantica, .erotica: return UIColor.fuchsia
        case .soloParaTi, .historia, .biografias: return UIColor.pineGreen
        case .ebooks, .thrillerYHorror, .relatosCortos: return UIColor.customDarkGray
        case .zonaPodcast, .noFiccion, .aprenderIdiomas, .economiaYNegocios: return UIColor.appleGreen
        case .novelaNegra, .fantasiaYCienciaFiccion: return UIColor.purpleBlue
        case .crecimientoPersonalYLifestyle, .espiritualidadYReligion: return UIColor.skyBlue
        case .inEnglish: return UIColor.electricBlue
        }
    }
    
}

struct Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.title == rhs.title
    }
    #warning("Equatable implemention has to check id or smth like that, not title")
    
    let title: String
    let subCategories: [SubCategory]
    var bookToShowMoreTitlesLikeIt: Book?
    
    init(title: String, subCategories: [SubCategory], bookToShowMoreTitlesLikeIt: Book? = nil) {
        self.title = title
        self.subCategories = subCategories
        self.bookToShowMoreTitlesLikeIt = bookToShowMoreTitlesLikeIt
    }
    
    static let series = Category(
        title: ButtonCategory.series.rawValue,
        subCategories: [
            SubCategory(title: "Series Top esta semana", searchQuery: "Gameofthrones"),
            SubCategory(title: "Las mejores series originales", searchQuery: "harrypotter"),
            SubCategory(title: "Series que son tendencia", searchQuery: "shadowhunters")]
    )
        
//    static let series = Category(
//        title: ButtonCategory.series.rawValue,
//        subCategories: [
//            SubCategory(title: "Series Top esta semana"),
//            SubCategory(title: "Una historia como nunca antes habías escuchado", subtitle: "Storytel Original", kind: .oneBookWithOverview),
//            SubCategory(title: "Los crímenes de Fjällbacka -\nCamilla Läckberg"),
//            SubCategory(title: "Series que son tendencia"),
//            SubCategory(title: "Series exclusivas", kind: .verticalCv),
//            SubCategory(title: "Serie Tom Ripley de\nPatricia Highsmith"),
//            SubCategory(title: "Serie el Club del Crimen de los Jueves"),
//            SubCategory(title: "Las mejores series originales"),
//            SubCategory(title: "Episodios de una guerra interminable"),
//            SubCategory(title: "Serie Vientos alisios de\nChristina Courtenay"),
//            SubCategory(title: "La Rueda del Tiempo de\nRobert Jordan"),
//            SubCategory(title: "Serie Sektion M de\nChristina Larsson"),
//            SubCategory(title: "Serie Kim Stone -\nAngela Marsons"),
//            SubCategory(title: "Susana Martín Gijón para Storytel Original", kind: .oneBookWithOverview),
//            SubCategory(title: "Serie Bad Ash -\nAlina Not"),
//            SubCategory(title: "Mikel Santiago para Storytel Original", subtitle: "Una serie sonora original", kind: .oneBookWithOverview),
//            SubCategory(title: "Storyside - Las historias de/nSherlock Holmes"),
//            SubCategory(title: "Juan Gómez-Jurado para Storytel Original", subtitle: "La primera serie sonora del autor en exclusivo para Stirytel", kind: .oneBookWithOverview),
//            SubCategory(title: "Alicia Giménez Bartlett - Serie Petra Delicado"),
//            SubCategory(title: "Storytel Original - Todas las series")]
//    )
    
    static let zonaPodcast = Category(
        title: ButtonCategory.zonaPodcast.rawValue,
        subCategories: [
            SubCategory(title: "Los más escuchados esta semana", searchQuery: "podcast"),
            SubCategory(title: "Nuevos podcast", searchQuery: "About"),
//            SubCategory(title: "Sigue tus podcast favoritos", kind: .verticalCv),
//            SubCategory(title: "Últimos episodios"),
//            SubCategory(title: "Los más buscados"),
//            SubCategory(title: "Storytel Original: Menlo Park")
        ]
    )
    
    static let soloEnStorytel = Category(
        title: ButtonCategory.soloEnStorytel.rawValue,
        subCategories: [
            SubCategory(title: "Una historia como nunca antes habías escuchado", subtitle: "Storytel Original", kind: .oneBookWithOverview, searchQuery: "shadow and bone"),
            SubCategory(title: "En exclusiva - Los más escuchados esta semana", searchQuery: "sarah j maas"),
            SubCategory(title: "Solo en Storytel", searchQuery: "tree"),
//            SubCategory(title: "Nuestros bestsellers"),
//            SubCategory(title: "Seríу Сrímenes del norte de\nMario Escobar"),
//            SubCategory(title: "La Rueda del Tiempo de\nRobert Jordan"),
//            SubCategory(title: "Storytel Original - Los más escuchados esta semana"),
//            SubCategory(title: "Solo en Storytel", kind: .oneBookWithOverview),
//            SubCategory(title: "Serie Los Crímenes del faro de Ibon Martín"),
//            SubCategory(title: "Novedades en exclusiva: Romántica"),
//            SubCategory(title: "Solo en Storytel: Novelas"),
//            SubCategory(title: "Juan Gómez-Jurado para Storytel Original", subtitle: "La primera serie sonora del autor en exclusiva para Storytel", kind: .oneBookWithOverview),
//            SubCategory(title: "Solo en Storytel: Novela negra y Thriller"),
//            SubCategory(title: "¿Te los has perdido?"),
//            SubCategory(title: "Muy pronto en exclusiva"),
//            SubCategory(title: "En exclusiva - Tendencias"),
//            SubCategory(title: "Mikel Santiago para Storytel Original", subtitle: "Una serie sonora original", kind: .oneBookWithOverview),
//            SubCategory(title: "Serie Vientos aliosos de\nChristina Courtenay"),
//            SubCategory(title: "Solo en Storytel: fantasía y Ciencia ficción"),
//            SubCategory(title: "Solo en Storytel - Clásicos"),
//            SubCategory(title: "Storytel original - Todas las series"),
//            SubCategory(title: "Los más esperados en exclusiva"),
//            SubCategory(title: "Narrados en acento ibérico"),
//            SubCategory(title: "Narrados en acento neutro"),
//            SubCategory(title: "", kind: .oneBookWithOverview),
//            SubCategory(title: "Solo en Storytel: Economía y negocios"),
//            SubCategory(title: "Solo en Storytel: Historia"),
//            SubCategory(title: "Solo en Storytel: Juvenil"),
//            SubCategory(title: "Solo en Storytel: Infantil"),
//            SubCategory(title: "Solo en Storytel: Biografías"),
//            SubCategory(title: "Solo en Storytel: Poesía y Teatro"),
//            SubCategory(title: "Solo en Storytel: Religión y Espiritualidad"),
//            SubCategory(title: "Historias inmersivas")
        ])
    
    static let losMasPopulares = Category(
        title: ButtonCategory.losMasPopulares.rawValue,
        subCategories: [
            SubCategory(title: "Los más populares - Novela", searchQuery: "story"),
            SubCategory(title: "Los más populares - Novela negra", searchQuery: "dark"),
            SubCategory(title: "Los más populares - Clásicos", searchQuery: "bronte"),
            SubCategory(title: "Los más populares - Romántica", searchQuery: "romance"),
            SubCategory(title: "Los más populares - Thriller", searchQuery: "stephen king"),
//            SubCategory(title: "Los más populares - Literatura infantil"),
//            SubCategory(title: "Los más populares - Young adult y juvenil"),
//            SubCategory(title: "Los más populares - Fantasía y Ciencia Ficción"),
//            SubCategory(title: "Los más populares - Historia"),
//            SubCategory(title: "Los más populares - Crecimiento personal"),
//            SubCategory(title: "Los más populares - Non fiction"),
//            SubCategory(title: "Los más populares - Biografía"),
//            SubCategory(title: "Los más populares - Economía y negocios"),
//            SubCategory(title: "Los más populares - Relatos")
        ])
    
    static let soloParaTi = Category(
        title: ButtonCategory.soloParaTi.rawValue,
        subCategories: [
            SubCategory(title: "Recomendados para ti", searchQuery: "shadow"),
            SubCategory(title: "Novedades para ti", searchQuery: "bones")
        ])
    
    static let eBooks = Category(
        title: ButtonCategory.ebooks.rawValue,
        subCategories: [
            SubCategory(title: "Novela - Los más leidos", searchQuery: "armentrout"),
            SubCategory(title: "Novela negra y Thriller - Los más leidos", searchQuery: "stephen king")
        ])
    
    static let novela = Category(
        title: ButtonCategory.novela.rawValue,
        subCategories: [
            SubCategory(title: "Los más populares - Novela", searchQuery: "gaiman"),
            SubCategory(title: "Nuevas novelas", searchQuery: "town")
        ])
    
    static let novelaNegra = Category(
        title: ButtonCategory.novelaNegra.rawValue,
        subCategories: [
            SubCategory(title: "Solo en Storytel", searchQuery: "dark"),
            SubCategory(title: "Los más populares - Novela negra", searchQuery: "mist")
        ])
    
    static let romantica = Category(
        title: ButtonCategory.romantica.rawValue,
        subCategories: [
            SubCategory(title: "Los más populares - Romántica", searchQuery: "romance"),
            SubCategory(title: "Nuevas histotias de amor", searchQuery: "boyfriend")
        ])
    
    static let thrillerYHorror = Category(
        title: ButtonCategory.thrillerYHorror.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let fantasiaYCienciaFiccion = Category(
        title: ButtonCategory.fantasiaYCienciaFiccion.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let infantil = Category(
        title: ButtonCategory.infantil.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let crecimientoPersonalYLifestyle = Category(
        title: ButtonCategory.crecimientoPersonalYLifestyle.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let clasicos = Category(
        title: ButtonCategory.clasicos.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let juvenilYYoungAdult = Category(
        title: ButtonCategory.juvenilYYoungAdult.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let erotica = Category(
        title: ButtonCategory.erotica.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let noFiccion = Category(
        title: ButtonCategory.noFiccion.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let economiaYNegocios = Category(
        title: ButtonCategory.economiaYNegocios.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let relatosCortos = Category(
        title: ButtonCategory.relatosCortos.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let historia = Category(
        title: ButtonCategory.historia.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let espiritualidadYReligion = Category(
        title: ButtonCategory.espiritualidadYReligion.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let biografias = Category(
        title: ButtonCategory.biografias.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let poesiaYTeatro = Category(
        title: ButtonCategory.poesiaYTeatro.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let aprenderIdiomas = Category(
        title: ButtonCategory.aprenderIdiomas.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let inEnglish = Category(
        title: ButtonCategory.inEnglish.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let historiasParaCadaEmocion = Category(
        title: ButtonCategory.historiasParaCadaEmocion.rawValue,
        subCategories: [SubCategory]()
    )
    
    static let home = Category(
        title: "",
        subCategories: [
            SubCategory(title: "Solo para ti", searchQuery: "dragon", canBeShared: false),
            SubCategory(title: "Los títulos del momento", searchQuery: "brother", description: "Las novedades más interesantes, los títulos de los que todos hablan, los que pensamos que deberías estar escuchando, todo lo que no te puedes perder. ¡Feliz escucha!"),
//            SubCategory(title: "Los títulos del momento", searchQuery: "horse", description: "Las novedades más interesantes, los títulos de los que todos hablan, los que pensamos que deberías estar escuchando, todo lo que no te puedes perder. ¡Feliz escucha!"),

//            SubCategory(title: "¡Escuchalo ahora!", subtitle: "Una historia como nunca antes habías escuchado", kind: .poster, searchQuery: "rise of dragons", bookKinds: .onlyAudiobooks),
//            SubCategory(title: "¡Escuchalo ahora!", subtitle: "Una historia como nunca antes habías escuchado", kind: .poster, searchQuery: "Los juegos del hambre", bookKinds: .onlyAudiobooks),
            SubCategory(title: "¡Escuchalo ahora!", subtitle: "Una historia como nunca antes habías escuchado", kind: .poster, searchQuery: "tears of the moon", bookKinds: .onlyAudiobooks),

            
            SubCategory(title: "Storytel Original", subtitle: "Historias para escuchar", kind: .largeCoversHorizontalCv, searchQuery: "magic", books: Book.booksWithLargeCovers),
            SubCategory(title: "Top 50 hoy", searchQuery: "sister", description: "Aquí podrás ver los títulos más populares en nuestra app. Se actualiza cada día, así que si algún libro te llama la atención ¡guárdalo en tu biblioteca!", canBeFiltered: false),
//            SubCategory(title: "Nuevos audiolibros", searchQuery: "bird"),
//            SubCategory(title: "Nuevos audiolibros", searchQuery: "moon"),
//            SubCategory(title: "Nuevos audiolibros", searchQuery: "hygge"),
            SubCategory(title: "Nuevos audiolibros", searchQuery: "star", bookKinds: .onlyAudiobooks),


//            SubCategory(title: "Alicia Giménez Bartlett - Serie Petra Delicado"),
//            SubCategory(title: "Solo en Storytel", description: "Historias que solo podrás encontrar aquí."),
            SubCategory(title: "Novela: Recomendados para ti", searchQuery: "gaiman", canBeShared: false),
            SubCategory(title: "Solo en Storytel", kind: .oneBookWithOverview, searchQuery: "Mitos nordicos", books: [Book.bookWithOverview1], bookKinds: .onlyAudiobooks),
            SubCategory(title: "Tendecia en Storytel", searchQuery: "vikings"),
//            SubCategory(title: "Pronto en audiolibro"),
//            SubCategory(title: "Historias de pelicula (y serie)"),
            SubCategory(title: "Solo en Storytel", kind: .oneBookWithOverview, searchQuery: "anansiboys", books: [Book.bookWithOverview2], bookKinds: .onlyAudiobooks),
            SubCategory(title: "Novela: Los más populares", searchQuery: "thunder"),
            
            // subtitle and description have to be dynamic (one of books user saved)
            SubCategory(title: "Porque te interesa", subtitle: "Una corte der rosas y espinas: Una corte der rosas y espinas 1", searchQuery: "sarah j maas", description: "Una corte der rosas y espinas: Una corte der rosas y espinas 1", canBeShared: false),
//            SubCategory(title: "Novela negra: Recomendados para ti", canBeShared: false),
            SubCategory(title: "", kind: .seriesCategoryButton, searchQuery: ""),
            SubCategory(title: "El audiolibro de George R.R. Martin", kind: .oneBookWithOverview, searchQuery: "a clash of kings", books: [Book.bookWithOverview], bookKinds: .onlyAudiobooks),
            SubCategory(title: "Series Top esta semana", searchQuery: "shadow"),
            SubCategory(title: "", kind: .allCategoriesButton, searchQuery: "")
        ])
    #warning("In 'Porque te interesa' SubCategory: subtitle and description have to be dynamic (one of books user saved)")
    
    static let todasLasCategorias = Category(
        title: "Todas las categorías",
        subCategories: [
            SubCategory(title: "", kind: .verticalCv, searchQuery: ""),
        ])
    
    static let searchVc = Category(
        title: "",
        subCategories: [
            SubCategory(title: "", searchQuery: ""),
            SubCategory(title: "Todas las categorías", kind: .searchVc, searchQuery: "")
        ])
    
}


