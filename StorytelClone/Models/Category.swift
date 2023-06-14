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
    let searchQuery: String // Hardcoded values
    let description: String?
    var titleModelToShow: Title?
    let canBeShared: Bool
    let canBeFiltered: Bool
    let categoryToShow: Category?
    let bookKinds: BookKinds
        
    init(title: String, subtitle: String = "", kind: SubCategoryKind = .horizontalCv, searchQuery: String, description: String? = nil, titleModelToShow: Title? = nil, canBeShared: Bool = true, canBeFiltered: Bool = true, categoryToShow: Category? = nil, bookKinds: BookKinds = .ebooksAndAudiobooks) {
        self.title = title
        self.subtitle = subtitle
        self.kind = kind
        self.searchQuery = searchQuery
        self.description = description
        self.titleModelToShow = titleModelToShow
        self.canBeShared = canBeShared
        self.canBeFiltered = canBeFiltered
        self.categoryToShow = categoryToShow
        self.bookKinds = bookKinds
    }
    
    static let generalForAllTitlesVC = SubCategory(title: "", searchQuery: "")
    static let similarTitles = SubCategory(title: "Similar titles", searchQuery: "", canBeShared: false)
    static let librosSimilares = SubCategory(title: "Libros similares", searchQuery: "dark", canBeShared: false)
}

enum Category: String {
    case home, todasLasCategorias, searchVc
    
    case series, soloEnStorytel, losMasPopulares
    case soloParaTi, ebooks, historiasParaCadaEmocion

    case novela, zonaPodcast, novelaNegra, romantica
    case thrillerYHorror, fantasiaYCienciaFiccion, crecimientoPersonalYLifestyle
    case infantil, clasicos, juvenilYYoungAdult, erotica
    case noFiccion, economiaYNegocios, relatosCortos, historia
    case espiritualidadYReligion, biografias, poesiaYTeatro
    case aprenderIdiomas, inEnglish
    
    case librosSimilares
        
    static let categoriesForAllCategories: [Category] = [
        .novela, .zonaPodcast, .novelaNegra, .romantica,
        .thrillerYHorror, .fantasiaYCienciaFiccion,
        .crecimientoPersonalYLifestyle, .infantil,
        .juvenilYYoungAdult, .clasicos, .historia, .noFiccion, .erotica,
        .relatosCortos, .economiaYNegocios,
        .espiritualidadYReligion, .biografias, .poesiaYTeatro,
        .aprenderIdiomas, .inEnglish
    ]

    static let categoriesForSearchVc: [Category] = [
        .series, .zonaPodcast, .soloEnStorytel, .losMasPopulares,
        .soloParaTi, .ebooks, .novela, .novelaNegra, .romantica,
        .thrillerYHorror, .fantasiaYCienciaFiccion, .infantil,
        .juvenilYYoungAdult, .crecimientoPersonalYLifestyle,
        .historia, .noFiccion, .erotica, .relatosCortos,
        .economiaYNegocios, .espiritualidadYReligion, .biografias,
        .poesiaYTeatro, .historiasParaCadaEmocion, .aprenderIdiomas,
        .inEnglish
    ]
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .todasLasCategorias: return "Todas las categorías"
        case .searchVc: return "Search"
        case .series: return "Series"
        case .soloEnStorytel: return "Solo en Storytel"
        case .losMasPopulares: return  "Los más populares"
        case .soloParaTi: return "Solo para ti"
        case .ebooks: return "Ebooks"
        case .historiasParaCadaEmocion: return "Historias para\ncada emoción"
        case .novela: return "Novela"
        case .zonaPodcast: return "Zona Podcast"
        case .novelaNegra: return "Novela negra"
        case .romantica: return "Romántica"
        case .thrillerYHorror: return "Thriller y Horror"
        case .fantasiaYCienciaFiccion: return "Fantasía y\nCiencia ficción"
        case .crecimientoPersonalYLifestyle: return "Crecimiento\npersonal y Lifestyle"
        case .infantil: return "Infantil"
        case .clasicos: return "Clásicos"
        case .juvenilYYoungAdult: return "Juvenil y\nYoung Adult"
        case .erotica: return "Erótica"
        case .noFiccion: return "No ficción"
        case .economiaYNegocios: return "Economía\ny negocios"
        case .relatosCortos: return "Relatos cortos"
        case .historia: return "Historia"
        case .espiritualidadYReligion: return "Espiritualidad\ny Religión"
        case .biografias: return "Biografías"
        case .poesiaYTeatro: return "Poesía y Teatro"
        case .aprenderIdiomas: return "Aprender idiomas"
        case .inEnglish: return "In English"
        case .librosSimilares: return "Libros similares"
        }
    }
    
    var buttonBackgroundColor: UIColor {
        switch self {
        case .home, .todasLasCategorias, .searchVc, .librosSimilares: return .label // placeholder, not used in project
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
    
#warning("In 'Porque te interesa' SubCategory: subtitle and description have to be dynamic (one of books user saved)")
    var subCategories: [SubCategory] {
        switch self {
        case .home: return [
            SubCategory(title: "Solo para ti", searchQuery: "dragon", canBeShared: false),
            SubCategory(title: "Los títulos del momento", searchQuery: "brother", description: "Las novedades más interesantes, los títulos de los que todos hablan, los que pensamos que deberías estar escuchando, todo lo que no te puedes perder. ¡Feliz escucha!"),
            SubCategory(title: "¡Escuchalo ahora!", subtitle: "Una historia como nunca antes habías escuchado", kind: .poster, searchQuery: "tears of the moon", bookKinds: .onlyAudiobooks),
            SubCategory(title: "Storytel Original", subtitle: "Historias para escuchar", kind: .largeCoversHorizontalCv, searchQuery: "magic", bookKinds: .onlyAudiobooks),
            SubCategory(title: "Top 50 hoy", searchQuery: "sister", description: "Aquí podrás ver los títulos más populares en nuestra app. Se actualiza cada día, así que si algún libro te llama la atención ¡guárdalo en tu biblioteca!", canBeFiltered: false),
            SubCategory(title: "Nuevos audiolibros", searchQuery: "star", bookKinds: .onlyAudiobooks),
            SubCategory(title: "Novela: Recomendados para ti", searchQuery: "gaiman", canBeShared: false),
            SubCategory(title: "Solo en Storytel", kind: .oneBookWithOverview, searchQuery: "Mitos nordicos", bookKinds: .onlyAudiobooks),
            SubCategory(title: "Tendecia en Storytel", searchQuery: "vikings"),
            SubCategory(title: "Solo en Storytel", kind: .oneBookWithOverview, searchQuery: "anansiboys", bookKinds: .onlyAudiobooks),
            SubCategory(title: "Novela: Los más populares", searchQuery: "thunder"),
            SubCategory(title: "Porque te interesa", subtitle: "Una corte der rosas y espinas: Una corte der rosas y espinas 1", searchQuery: "sarah j maas", description: "Una corte der rosas y espinas: Una corte der rosas y espinas 1", canBeShared: false),
            SubCategory(title: "", kind: .seriesCategoryButton, searchQuery: ""),
            SubCategory(title: "El audiolibro de George R.R. Martin", kind: .oneBookWithOverview, searchQuery: "a clash of kings"),
            SubCategory(title: "Series Top esta semana", searchQuery: "shadow"),
            SubCategory(title: "", kind: .allCategoriesButton, searchQuery: "")
        ]
        case .todasLasCategorias: return [SubCategory(title: "", kind: .verticalCv, searchQuery: "")]
        case .searchVc: return [
            SubCategory(title: "", searchQuery: ""),
            SubCategory(title: "Todas las categorías", kind: .searchVc, searchQuery: "")
        ]
        case .series: return [
            SubCategory(title: "Series Top esta semana", searchQuery: "Gameofthrones"),
            SubCategory(title: "Las mejores series originales", searchQuery: "harrypotter"),
            SubCategory(title: "Series que son tendencia", searchQuery: "shadowhunters")
        ]
        case .soloEnStorytel: return [
            SubCategory(title: "Una historia como nunca antes habías escuchado", subtitle: "Storytel Original", kind: .oneBookWithOverview, searchQuery: "shadow and bone"),
            SubCategory(title: "En exclusiva - Los más escuchados esta semana", searchQuery: "sarah j maas"),
            SubCategory(title: "Solo en Storytel", searchQuery: "tree"),
        ]
        case .losMasPopulares: return [
            SubCategory(title: "Los más populares - Novela", searchQuery: "story"),
            SubCategory(title: "Los más populares - Novela negra", searchQuery: "dark"),
            SubCategory(title: "Los más populares - Clásicos", searchQuery: "bronte"),
            SubCategory(title: "Los más populares - Romántica", searchQuery: "romance"),
            SubCategory(title: "Los más populares - Thriller", searchQuery: "stephen king"),
        ]
        case .soloParaTi: return [
            SubCategory(title: "Recomendados para ti", searchQuery: "shadow"),
            SubCategory(title: "Novedades para ti", searchQuery: "bones")
        ]
        case .ebooks: return [
            SubCategory(title: "Novela - Los más leidos", searchQuery: "armentrout"),
            SubCategory(title: "Novela negra y Thriller - Los más leidos", searchQuery: "stephen king")
        ]
        case .historiasParaCadaEmocion: return [SubCategory]()
        case .novela: return [
            SubCategory(title: "Los más populares - Novela", searchQuery: "gaiman"),
            SubCategory(title: "Nuevas novelas", searchQuery: "town")
        ]
        case .zonaPodcast: return [
            SubCategory(title: "Los más escuchados esta semana", searchQuery: "podcast"),
            SubCategory(title: "Nuevos podcasts", searchQuery: "About"),
        ]
        case .novelaNegra: return [
            SubCategory(title: "Solo en Storytel", searchQuery: "dark"),
            SubCategory(title: "Los más populares - Novela negra", searchQuery: "mist")
        ]
        case .romantica: return [
            SubCategory(title: "Los más populares - Romántica", searchQuery: "romance"),
            SubCategory(title: "Nuevas histotias de amor", searchQuery: "boyfriend")
        ]
        case .thrillerYHorror: return [SubCategory]()
        case .fantasiaYCienciaFiccion: return [SubCategory]()
        case .crecimientoPersonalYLifestyle: return [SubCategory]()
        case .infantil: return [SubCategory]()
        case .clasicos: return [SubCategory]()
        case .juvenilYYoungAdult: return [SubCategory]()
        case .erotica: return [SubCategory]()
        case .noFiccion: return [SubCategory]()
        case .economiaYNegocios: return [SubCategory]()
        case .relatosCortos: return [SubCategory]()
        case .historia: return [SubCategory]()
        case .espiritualidadYReligion: return [SubCategory]()
        case .biografias: return [SubCategory]()
        case .poesiaYTeatro: return [SubCategory]()
        case .aprenderIdiomas: return [SubCategory]()
        case .inEnglish: return [SubCategory]()
        case .librosSimilares: return [SubCategory]()
        }
    }
    
    static func createCaseFrom(rawValueString: String) -> Category {
        let enumCase = Category(rawValue: rawValueString)
        
        if let enumCase = enumCase {
            return enumCase
        } else {
            print("enum Category couldn't create value from this rawValue \(rawValueString)")
            return .ebooks
        }
    }

}
