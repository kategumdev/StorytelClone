//
//  Category.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/2/23.
//

import UIKit

enum SectionKind {
    case horizontalCv
    case verticalCv
    case oneBookWithOverview
    case poster
    case largeCoversHorizontalCv
    case seriesCategoryButton
    case allCategoriesButton
    case searchVc
}

struct TableSection {
    let sectionTitle: String
    let sectionSubtitle: String
    let sectionKind: SectionKind
    let books: [Book]
    let sectionDescription: String?
    var toShowTitleModel: Title?
    let canBeShared: Bool
    let canBeFiltered: Bool
    let toShowCategory: Category?
    
    init(sectionTitle: String, sectionSubtitle: String = "", sectionKind: SectionKind = .horizontalCv, books: [Book] = Book.books, sectionDescription: String? = nil, toShowTitleModel: Title? = nil, canBeShared: Bool = true, canBeFiltered: Bool = true, toShowCategory: Category? = nil) {
        self.sectionTitle = sectionTitle
        self.sectionSubtitle = sectionSubtitle
        self.sectionKind = sectionKind
        self.books = books
        self.sectionDescription = sectionDescription
        self.toShowTitleModel = toShowTitleModel
        self.canBeShared = canBeShared
        self.canBeFiltered = canBeFiltered
        self.toShowCategory = toShowCategory
    }
    
    static let generalForAllTitlesVC = TableSection(sectionTitle: "")
    static let similarTitles = TableSection(sectionTitle: "Similar titles", canBeShared: false)
    static let librosSimilares = TableSection(sectionTitle: "Libros similares", canBeShared: false)
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
        clasicos, juvenilYYoungAdult, erotica, noFiccion,
        economiaYNegocios, relatosCortos, historia,
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
        case .series: return UIColor(red: 0, green: 163/255, blue: 173/255, alpha: 1)
        case .soloEnStorytel: return UIColor(red: 243/255, green: 101/255, blue: 0, alpha: 1)
        case .losMasPopulares: return UIColor(red: 195/255, green: 1/255, blue: 121/255, alpha: 1)
        case .soloParaTi: return UIColor(red: 63/255, green: 148/255, blue: 78/255, alpha: 1)
        case .ebooks: return UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        case .historiasParaCadaEmocion: return UIColor(red: 195/255, green: 1/255, blue: 121/255, alpha: 1)
        case .novela: return UIColor(red: 0, green: 163/255, blue: 173/255, alpha: 1)
        case .zonaPodcast: return UIColor(red: 111/255, green: 152/255, blue: 11/255, alpha: 1)
        case .novelaNegra: return UIColor(red: 69/255, green: 25/255, blue: 162/255, alpha: 1)
        case .romantica: return UIColor(red: 195/255, green: 1/255, blue: 121/255, alpha: 1)
        case .thrillerYHorror: return UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        case .fantasiaYCienciaFiccion: return UIColor(red: 69/255, green: 25/255, blue: 162/255, alpha: 1)
        case .crecimientoPersonalYLifestyle: return UIColor(red: 39/255, green: 149/255, blue: 213/255, alpha: 1)
        case .infantil: return UIColor(red: 243/255, green: 101/255, blue: 0, alpha: 1)
        case .clasicos: return UIColor(red: 0, green: 163/255, blue: 173/255, alpha: 1)
        case .juvenilYYoungAdult: return UIColor(red: 243/255, green: 101/255, blue: 0, alpha: 1)
        case .erotica: return UIColor(red: 195/255, green: 1/255, blue: 121/255, alpha: 1)
        case .noFiccion: return UIColor(red: 111/255, green: 152/255, blue: 11/255, alpha: 1)
        case .economiaYNegocios: return UIColor(red: 111/255, green: 152/255, blue: 11/255, alpha: 1)
        case .relatosCortos: return UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        case .historia: return UIColor(red: 63/255, green: 148/255, blue: 78/255, alpha: 1)
        case .espiritualidadYReligion: return UIColor(red: 39/255, green: 149/255, blue: 213/255, alpha: 1)
        case .biografias: return UIColor(red: 63/255, green: 148/255, blue: 78/255, alpha: 1)
        case .poesiaYTeatro: return UIColor(red: 0, green: 163/255, blue: 173/255, alpha: 1)
        case .aprenderIdiomas: return UIColor(red: 111/255, green: 152/255, blue: 11/255, alpha: 1)
        case .inEnglish: return UIColor(red: 0, green: 54/255, blue: 195/255, alpha: 1)
        }
    }
    
}

struct Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.title == rhs.title
    }
    #warning("Equatable implemention has to check id or smth like that, not title")
    
    let title: String
    let tableSections: [TableSection]
    var bookToShowMoreTitlesLikeIt: Book?
    
    init(title: String, tableSections: [TableSection], bookToShowMoreTitlesLikeIt: Book? = nil) {
        self.title = title
        self.tableSections = tableSections
        self.bookToShowMoreTitlesLikeIt = bookToShowMoreTitlesLikeIt
    }
        
    static let series = Category(
        title: ButtonCategory.series.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Series Top esta semana"),
            TableSection(sectionTitle: "Una historia como nunca antes habías escuchado", sectionSubtitle: "Storytel Original", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "Los crímenes de Fjällbacka -\nCamilla Läckberg"),
            TableSection(sectionTitle: "Series que son tendencia"),
            TableSection(sectionTitle: "Series exclusivas", sectionKind: .verticalCv),
            TableSection(sectionTitle: "Serie Tom Ripley de\nPatricia Highsmith"),
            TableSection(sectionTitle: "Serie el Club del Crimen de los Jueves"),
            TableSection(sectionTitle: "Las mejores series originales"),
            TableSection(sectionTitle: "Episodios de una guerra interminable"),
            TableSection(sectionTitle: "Serie Vientos alisios de\nChristina Courtenay"),
            TableSection(sectionTitle: "La Rueda del Tiempo de\nRobert Jordan"),
            TableSection(sectionTitle: "Serie Sektion M de\nChristina Larsson"),
            TableSection(sectionTitle: "Serie Kim Stone -\nAngela Marsons"),
            TableSection(sectionTitle: "Susana Martín Gijón para Storytel Original", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "Serie Bad Ash -\nAlina Not"),
            TableSection(sectionTitle: "Mikel Santiago para Storytel Original", sectionSubtitle: "Una serie sonora original", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "Storyside - Las historias de/nSherlock Holmes"),
            TableSection(sectionTitle: "Juan Gómez-Jurado para Storytel Original", sectionSubtitle: "La primera serie sonora del autor en exclusivo para Stirytel", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "Alicia Giménez Bartlett - Serie Petra Delicado"),
            TableSection(sectionTitle: "Storytel Original - Todas las series")
        ])
    
    static let zonaPodcast = Category(
        title: ButtonCategory.zonaPodcast.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Los más escuchados esta semana"),
            TableSection(sectionTitle: "Nuevos podcast"),
            TableSection(sectionTitle: "Sigue tus podcast favoritos", sectionKind: .verticalCv),
            TableSection(sectionTitle: "Últimos episodios"),
            TableSection(sectionTitle: "Los más buscados"),
            TableSection(sectionTitle: "Storytel Original: Menlo Park")
        ])
    
    static let soloEnStorytel = Category(
        title: ButtonCategory.soloEnStorytel.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Una historia como nunca antes habías escuchado", sectionSubtitle: "Storytel Original - Sonido binaural", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "En exclusiva - Los más escuchados esta semana"),
            TableSection(sectionTitle: "Solo en Storytel"),
            TableSection(sectionTitle: "Nuestros bestsellers"),
            TableSection(sectionTitle: "Seríу Сrímenes del norte de\nMario Escobar"),
            TableSection(sectionTitle: "La Rueda del Tiempo de\nRobert Jordan"),
            TableSection(sectionTitle: "Storytel Original - Los más escuchados esta semana"),
            TableSection(sectionTitle: "Solo en Storytel", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "Serie Los Crímenes del faro de Ibon Martín"),
            TableSection(sectionTitle: "Novedades en exclusiva: Romántica"),
            TableSection(sectionTitle: "Solo en Storytel: Novelas"),
            TableSection(sectionTitle: "Juan Gómez-Jurado para Storytel Original", sectionSubtitle: "La primera serie sonora del autor en exclusiva para Storytel", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "Solo en Storytel: Novela negra y Thriller"),
            TableSection(sectionTitle: "¿Te los has perdido?"),
            TableSection(sectionTitle: "Muy pronto en exclusiva"),
            TableSection(sectionTitle: "En exclusiva - Tendencias"),
            TableSection(sectionTitle: "Mikel Santiago para Storytel Original", sectionSubtitle: "Una serie sonora original", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "Serie Vientos aliosos de\nChristina Courtenay"),
            TableSection(sectionTitle: "Solo en Storytel: fantasía y Ciencia ficción"),
            TableSection(sectionTitle: "Solo en Storytel - Clásicos"),
            TableSection(sectionTitle: "Storytel original - Todas las series"),
            TableSection(sectionTitle: "Los más esperados en exclusiva"),
            TableSection(sectionTitle: "Narrados en acento ibérico"),
            TableSection(sectionTitle: "Narrados en acento neutro"),
            TableSection(sectionTitle: "", sectionKind: .oneBookWithOverview),
            TableSection(sectionTitle: "Solo en Storytel: Economía y negocios"),
            TableSection(sectionTitle: "Solo en Storytel: Historia"),
            TableSection(sectionTitle: "Solo en Storytel: Juvenil"),
            TableSection(sectionTitle: "Solo en Storytel: Infantil"),
            TableSection(sectionTitle: "Solo en Storytel: Biografías"),
            TableSection(sectionTitle: "Solo en Storytel: Poesía y Teatro"),
            TableSection(sectionTitle: "Solo en Storytel: Religión y Espiritualidad"),
            TableSection(sectionTitle: "Historias inmersivas")
        ])
    
    static let losMasPopulares = Category(
        title: ButtonCategory.losMasPopulares.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Los más populares - Novela"),
            TableSection(sectionTitle: "Los más populares - Novela negra"),
            TableSection(sectionTitle: "Los más populares - Clásicos"),
            TableSection(sectionTitle: "Los más populares - Romántica"),
            TableSection(sectionTitle: "Los más populares - Thriller"),
            TableSection(sectionTitle: "Los más populares - Literatura infantil"),
            TableSection(sectionTitle: "Los más populares - Young adult y juvenil"),
            TableSection(sectionTitle: "Los más populares - Fantasía y Ciencia Ficción"),
            TableSection(sectionTitle: "Los más populares - Historia"),
            TableSection(sectionTitle: "Los más populares - Crecimiento personal"),
            TableSection(sectionTitle: "Los más populares - Non fiction"),
            TableSection(sectionTitle: "Los más populares - Biografía"),
            TableSection(sectionTitle: "Los más populares - Economía y negocios"),
            TableSection(sectionTitle: "Los más populares - Relatos")
        ])
    
    static let soloParaTi = Category(
        title: ButtonCategory.soloParaTi.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Recomendados para ti"),
            TableSection(sectionTitle: "Novedades para ti")
        ])
    
    static let eBooks = Category(
        title: ButtonCategory.ebooks.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Novela - Los más leidos"),
            TableSection(sectionTitle: "Novela negra y Thriller - Los más leidos")
        ])
    
    static let novela = Category(
        title: ButtonCategory.novela.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Los más populares - Novela"),
            TableSection(sectionTitle: "Nuevas novelas")
        ])
    
    static let novelaNegra = Category(
        title: ButtonCategory.novelaNegra.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Solo en Storytel"),
            TableSection(sectionTitle: "Los más populares - Novela negra")
        ])
    
    static let romantica = Category(
        title: ButtonCategory.romantica.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Los más populares - Romántica"),
            TableSection(sectionTitle: "Nuevas histotias de amor")
        ])
    
    static let thrillerYHorror = Category(
        title: ButtonCategory.thrillerYHorror.rawValue,
        tableSections: [TableSection]()
    )
    
    static let fantasiaYCienciaFiccion = Category(
        title: ButtonCategory.fantasiaYCienciaFiccion.rawValue,
        tableSections: [TableSection]()
    )
    
    static let infantil = Category(
        title: ButtonCategory.infantil.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Los más populares - Romántica"),
            TableSection(sectionTitle: "Nuevas histotias de amor")
        ]
    )
//        tableSections: [TableSection]()
    
    
    static let crecimientoPersonalYLifestyle = Category(
        title: ButtonCategory.crecimientoPersonalYLifestyle.rawValue,
        tableSections: [TableSection]()
    )
    
    static let clasicos = Category(
        title: ButtonCategory.clasicos.rawValue,
        tableSections: [TableSection]()
    )
    
    static let juvenilYYoungAdult = Category(
        title: ButtonCategory.juvenilYYoungAdult.rawValue,
        tableSections: [TableSection]()
    )
    
    static let erotica = Category(
        title: ButtonCategory.erotica.rawValue,
        tableSections: [TableSection]()
    )
    
    static let noFiccion = Category(
        title: ButtonCategory.noFiccion.rawValue,
        tableSections: [TableSection]()
    )
    
    static let economiaYNegocios = Category(
        title: ButtonCategory.economiaYNegocios.rawValue,
        tableSections: [TableSection]()
    )
    
    static let relatosCortos = Category(
        title: ButtonCategory.relatosCortos.rawValue,
        tableSections: [TableSection]()
    )
    
    static let historia = Category(
        title: ButtonCategory.historia.rawValue,
        tableSections: [TableSection]()
    )
    
    static let espiritualidadYReligion = Category(
        title: ButtonCategory.espiritualidadYReligion.rawValue,
        tableSections: [TableSection]()
    )
    
    static let biografias = Category(
        title: ButtonCategory.biografias.rawValue,
        tableSections: [TableSection]()
    )
    
    static let poesiaYTeatro = Category(
        title: ButtonCategory.poesiaYTeatro.rawValue,
        tableSections: [TableSection]()
    )
    
    static let aprenderIdiomas = Category(
        title: ButtonCategory.aprenderIdiomas.rawValue,
        tableSections: [TableSection]()
    )
    
    static let inEnglish = Category(
        title: ButtonCategory.inEnglish.rawValue,
        tableSections: [TableSection]()
    )
    
    static let historiasParaCadaEmocion = Category(
        title: ButtonCategory.historiasParaCadaEmocion.rawValue,
        tableSections: [TableSection]()
    )
    
    static let home = Category(
        title: "",
        tableSections: [
            TableSection(sectionTitle: "Solo para ti", canBeShared: false),
            TableSection(sectionTitle: "Los títulos del momento", sectionDescription: "Las novedades más interesantes, los títulos de los que todos hablan, los que pensamos que deberías estar escuchando, todo lo que no te puedes perder. ¡Feliz escucha!"),
            TableSection(sectionTitle: "¡Escuchalo ahora!", sectionSubtitle: "Una historia como nunca antes habías escuchado", sectionKind: .poster),
            TableSection(sectionTitle: "Storytel Original", sectionSubtitle: "Historias para escuchar", sectionKind: .largeCoversHorizontalCv, books: Book.booksWithLargeCovers),
            TableSection(sectionTitle: "Top 50 hoy", sectionDescription: "Aquí podrás ver los títulos más populares en nuestra app. Se actualiza cada día, así que si algún libro te llama la atención ¡guárdalo en tu biblioteca!", canBeFiltered: false),
            TableSection(sectionTitle: "Nuevos audiolibros"),
            TableSection(sectionTitle: "Alicia Giménez Bartlett - Serie Petra Delicado"),
            TableSection(sectionTitle: "Solo en Storytel", sectionDescription: "Historias que solo podrás encontrar aquí."),
            TableSection(sectionTitle: "Novela: Recomendados para ti", canBeShared: false),
            TableSection(sectionTitle: "Solo en Storytel", sectionKind: .oneBookWithOverview, books: [Book.bookWithOverview1]),
            TableSection(sectionTitle: "Tendecia en Storytel"),
            TableSection(sectionTitle: "Pronto en audiolibro"),
            TableSection(sectionTitle: "Historias de pelicula (y serie)"),
            TableSection(sectionTitle: "Solo en Storytel", sectionKind: .oneBookWithOverview, books: [Book.bookWithOverview2]),
            TableSection(sectionTitle: "Novela: Los más populares"),
            
            // sectionSubtitle and sectionDescription have to be dynamic (one of books user saved)
            TableSection(sectionTitle: "Porque te interesa", sectionSubtitle: "Una corte der rosas y espinas: Una corte der rosas y espinas 1", sectionDescription: "Una corte der rosas y espinas: Una corte der rosas y espinas 1", canBeShared: false),
            TableSection(sectionTitle: "Novela negra: Recomendados para ti", canBeShared: false),
            TableSection(sectionTitle: "", sectionKind: .seriesCategoryButton),
            TableSection(sectionTitle: "El audiolibro de La Vecina Rubia", sectionKind: .oneBookWithOverview, books: [Book.bookWithOverview]),
            TableSection(sectionTitle: "Series Top esta semana"),
            TableSection(sectionTitle: "", sectionKind: .allCategoriesButton)
        ])
    #warning("In 'Porque te interesa' TableSection: sectionSubtitle and sectionDescription have to be dynamic (one of books user saved)")
    
    static let todasLasCategorias = Category(
        title: "Todas las categorías",
        tableSections: [
            TableSection(sectionTitle: "", sectionKind: .verticalCv),
        ])
    
    static let searchVc = Category(
        title: "",
        tableSections: [
            TableSection(sectionTitle: ""),
            TableSection(sectionTitle: "Todas las categorías", sectionKind: .searchVc)
        ])
    
}


