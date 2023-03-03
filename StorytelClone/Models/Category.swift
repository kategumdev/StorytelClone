//
//  Category.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/2/23.
//

import Foundation

enum SectionKind {
    case horizontalCv
    case verticalCv
    case storytelOriginal
    case poster
    case seriesCategoryButton
    case allCategoriesButton
}

struct TableSection {
    let sectionTitle: String
    let sectionSubtitle: String
    let sectionKind: SectionKind
    
    init(sectionTitle: String, sectionSubtitle: String = "", sectionKind: SectionKind = .horizontalCv) {
        self.sectionTitle = sectionTitle
        self.sectionSubtitle = sectionSubtitle
        self.sectionKind = sectionKind
    }
}

enum CategoryButton: String {
    
    static let categoriesForAllCategories: [CategoryButton] = [
        novela, zonaPodcast, novelaNegra, romantica,
        thrillerYHorror, fantasiaYCienciaFiccion,
        crecimientoPersonalYLifestyle, infantil,
        clasicos, juvenilYYoungAdult, erotica, noFiccion,
        economiaYNegocios, relatosCortos, historia,
        espiritualidadYReligion, biografias, poesiaYTeatro,
        aprenderIdiomas, inEnglish
    ]
    
    static let categoriesForSearchVc: [CategoryButton] = [
        series, zonaPodcast, soloEnStorytel, losMasPopulares,
        soloParaTi, ebooks, novela, novelaNegra, romantica,
        thrillerYHorror, fantasiaYCienciaFiccion, infantil,
        juvenilYYoungAdult, crecimientoPersonalYLifestyle,
        historia, noFiccion, erotica, relatosCortos,
        economiaYNegocios, espiritualidadYReligion, biografias,
        poesiaYTeatro, historiasParaCadaEmocion, aprenderIdiomas,
        inEnglish
    ]
    
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
    case fantasiaYCienciaFiccion = "Fantasía y\nCiencis ficción"
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
    
    static func createModelFor(categoryButton: CategoryButton) -> Category {
        
        switch categoryButton {
        case series: return Category.series
        case soloEnStorytel: return Category.soloEnStorytel
        case losMasPopulares: return Category.losMasPopulares
        case soloParaTi: return Category.soloParaTi
        case ebooks: return Category.eBooks
        case historiasParaCadaEmocion: return Category.historiasParaCadaEmocion
        
        case novela: return Category.novela
        case zonaPodcast: return Category.zonaPodcast
        case novelaNegra: return Category.novelaNegra
        case romantica: return Category.romantica
        case thrillerYHorror: return Category.thrillerYHorror
        case fantasiaYCienciaFiccion: return Category.fantasiaYCienciaFiccion
        case crecimientoPersonalYLifestyle: return Category.crecimientoPersonalYLifestyle
        case infantil: return Category.infantil
        case clasicos: return Category.clasicos
        case juvenilYYoungAdult: return Category.juvenilYYoungAdult
        case erotica: return Category.erotica
        case noFiccion: return Category.noFiccion
        case economiaYNegocios: return Category.economiaYNegocios
        case relatosCortos: return Category.relatosCortos
        case historia: return Category.historia
        case espiritualidadYReligion: return Category.espiritualidadYReligion
        case biografias: return Category.biografias
        case poesiaYTeatro: return Category.poesiaYTeatro
        case aprenderIdiomas: return Category.aprenderIdiomas
        case inEnglish: return Category.inEnglish
        }
    }
}

//struct HomeVcModel {
//    let tableSections: [TableSection]
//
//    init(tableSections: [TableSection]) {
//        self.tableSections = tableSections
//    }
//
//    static let model = HomeVcModel(tableSections: [
//        TableSection(sectionTitle: "Solo para ti"),
//        TableSection(sectionTitle: "Los títulos del momento"),
//        TableSection(sectionTitle: "¡Escuchalo ahora!", sectionSubtitle: "Una historia como nunca antes habías escuchado", sectionKind: .poster),
//        TableSection(sectionTitle: "Top 50 hoy"),
//        TableSection(sectionTitle: "Nuevos audiolibros"),
//        TableSection(sectionTitle: "Alicia Giménez Bartlett - Serie Petra Delicado"),
//        TableSection(sectionTitle: "Solo en Storytel"),
//        TableSection(sectionTitle: "Novela: Recomendados para ti"),
//        TableSection(sectionTitle: "Solo en Storytel", sectionKind: .storytelOriginal),
//        TableSection(sectionTitle: "Tendecia en Storytel"),
//        TableSection(sectionTitle: "Pronto en audiolibro"),
//        TableSection(sectionTitle: "Historias de pelicula (y serie)"),
//        TableSection(sectionTitle: "Solo en Storytel", sectionKind: .storytelOriginal),
//        TableSection(sectionTitle: "Novela: Los más populares"),
//        TableSection(sectionTitle: "Novela negra: Recomendados para ti"),
//        TableSection(sectionTitle: "", sectionKind: .seriesCategoryButton),
//        TableSection(sectionTitle: "El audiolibro de La Vecina Rubia", sectionKind: .storytelOriginal),
//        TableSection(sectionTitle: "Series Top esta semana"),
//        TableSection(sectionTitle: "", sectionKind: .allCategoriesButton)
//    ])
//}

//struct AllCategoriesVcModel {
//    let title: String
//    let tableSections: [TableSection]
//    let categoryButtons: [CategoryButton]
//
//    init(title: String, tableSections: [TableSection], categoryButtons: [CategoryButton]) {
//        self.title = title
//        self.tableSections = tableSections
//        self.categoryButtons = categoryButtons
//    }
//
//    static let allCategoriesModel = AllCategoriesVcModel(
//        title: "Todas las categorías",
//        tableSections: [TableSection(sectionTitle: "", sectionKind: .verticalCv)],
//        categoryButtons: CategoryButton.categoriesForAllCategories
//    )
//}
//
//struct SearchVcModel {
//    let tableSections: [TableSection]
//
//    init(tableSections: [TableSection]) {
//        self.tableSections = tableSections
//    }
//
//    static let model = SearchVcModel(tableSections: [
//        TableSection(sectionTitle: "", sectionKind: .verticalCv),
//        TableSection(sectionTitle: "Todas las categorías", sectionKind: .verticalCv)
//    ])
//}

struct Category {
    let title: String
    let tableSections: [TableSection]
    
    init(title: String, tableSections: [TableSection]) {
        self.title = title
        self.tableSections = tableSections
    }
    
    static let series = Category(
        title: CategoryButton.series.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Series Top esta semana"),
            TableSection(sectionTitle: "Una historia como nunca antes habías escuchado", sectionSubtitle: "Storytel Original", sectionKind: .storytelOriginal),
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
            TableSection(sectionTitle: "Susana Martín Gijón para Storytel Original", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Serie Bad Ash -\nAlina Not"),
            TableSection(sectionTitle: "Mikel Santiago para Storytel Original", sectionSubtitle: "Una serie sonora original", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Storyside - Las historias de/nSherlock Holmes"),
            TableSection(sectionTitle: "Juan Gómez-Jurado para Storytel Original", sectionSubtitle: "La primera serie sonora del autor en exclusivo para Stirytel", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Alicia Giménez Bartlett - Serie Petra Delicado"),
            TableSection(sectionTitle: "Storytel Original - Todas las series")
        ])
    

    
    static let zonaPodcast = Category(
        title: CategoryButton.zonaPodcast.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Los más escuchados esta semana"),
            TableSection(sectionTitle: "Nuevos podcast"),
            TableSection(sectionTitle: "Sigue tus podcast favoritos", sectionKind: .verticalCv),
            TableSection(sectionTitle: "Últimos episodios"),
            TableSection(sectionTitle: "Los más buscados"),
            TableSection(sectionTitle: "Storytel Original: Menlo Park")
        ])
    
    static let soloEnStorytel = Category(
        title: CategoryButton.soloEnStorytel.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Una historia como nunca antes habías escuchado", sectionSubtitle: "Storytel Original - Sonido binaural", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "En exclusiva - Los más escuchados esta semana"),
            TableSection(sectionTitle: "Solo en Storytel"),
            TableSection(sectionTitle: "Nuestros bestsellers"),
            TableSection(sectionTitle: "Seríу Сrímenes del norte de\nMario Escobar"),
            TableSection(sectionTitle: "La Rueda del Tiempo de\nRobert Jordan"),
            TableSection(sectionTitle: "Storytel Original - Los más escuchados esta semana"),
            TableSection(sectionTitle: "Solo en Storytel", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Serie Los Crímenes del faro de Ibon Martín"),
            TableSection(sectionTitle: "Novedades en exclusiva: Romántica"),
            TableSection(sectionTitle: "Solo en Storytel: Novelas"),
            TableSection(sectionTitle: "Juan Gómez-Jurado para Storytel Original", sectionSubtitle: "La primera serie sonora del autor en exclusiva para Storytel", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Solo en Storytel: Novela negra y Thriller"),
            TableSection(sectionTitle: "¿Te los has perdido?"),
            TableSection(sectionTitle: "Muy pronto en exclusiva"),
            TableSection(sectionTitle: "En exclusiva - Tendencias"),
            TableSection(sectionTitle: "Mikel Santiago para Storytel Original", sectionSubtitle: "Una serie sonora original", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Serie Vientos aliosos de\nChristina Courtenay"),
            TableSection(sectionTitle: "Solo en Storytel: fantasía y Ciencia ficción"),
            TableSection(sectionTitle: "Solo en Storytel - Clásicos"),
            TableSection(sectionTitle: "Storytel original - Todas las series"),
            TableSection(sectionTitle: "Los más esperados en exclusiva"),
            TableSection(sectionTitle: "Narrados en acento ibérico"),
            TableSection(sectionTitle: "Narrados en acento neutro"),
            TableSection(sectionTitle: "", sectionKind: .storytelOriginal),
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
        title: CategoryButton.losMasPopulares.rawValue,
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
        title: CategoryButton.soloParaTi.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Recomendados para ti"),
            TableSection(sectionTitle: "Novedades para ti")
        ])
    
    static let eBooks = Category(
        title: CategoryButton.ebooks.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Novela - Los más leidos"),
            TableSection(sectionTitle: "Novela negra y Thriller - Los más leidos")
        ])
    
    static let novela = Category(
        title: CategoryButton.novela.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Los más populares - Novela"),
            TableSection(sectionTitle: "Nuevas novelas")
        ])
    
    static let novelaNegra = Category(
        title: CategoryButton.novelaNegra.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Solo en Storytel"),
            TableSection(sectionTitle: "Los más populares - Novela negra")
        ])
    
    static let romantica = Category(
        title: CategoryButton.romantica.rawValue,
        tableSections: [
            TableSection(sectionTitle: "Los más populares - Romántica"),
            TableSection(sectionTitle: "Nuevas histotias de amor")
        ])
    
    static let thrillerYHorror = Category(
        title: CategoryButton.thrillerYHorror.rawValue,
        tableSections: [TableSection]()
    )
    
    static let fantasiaYCienciaFiccion = Category(
        title: CategoryButton.fantasiaYCienciaFiccion.rawValue,
        tableSections: [TableSection]()
    )
    
    static let infantil = Category(
        title: CategoryButton.infantil.rawValue,
        tableSections: [TableSection]()
    )
    
    static let crecimientoPersonalYLifestyle = Category(
        title: CategoryButton.crecimientoPersonalYLifestyle.rawValue,
        tableSections: [TableSection]()
    )
    
    static let clasicos = Category(
        title: CategoryButton.clasicos.rawValue,
        tableSections: [TableSection]()
    )
    
    static let juvenilYYoungAdult = Category(
        title: CategoryButton.juvenilYYoungAdult.rawValue,
        tableSections: [TableSection]()
    )
    
    static let erotica = Category(
        title: CategoryButton.erotica.rawValue,
        tableSections: [TableSection]()
    )
    
    static let noFiccion = Category(
        title: CategoryButton.noFiccion.rawValue,
        tableSections: [TableSection]()
    )
    
    static let economiaYNegocios = Category(
        title: CategoryButton.economiaYNegocios.rawValue,
        tableSections: [TableSection]()
    )
    
    static let relatosCortos = Category(
        title: CategoryButton.relatosCortos.rawValue,
        tableSections: [TableSection]()
    )
    
    static let historia = Category(
        title: CategoryButton.historia.rawValue,
        tableSections: [TableSection]()
    )
    
    static let espiritualidadYReligion = Category(
        title: CategoryButton.espiritualidadYReligion.rawValue,
        tableSections: [TableSection]()
    )
    
    static let biografias = Category(
        title: CategoryButton.biografias.rawValue,
        tableSections: [TableSection]()
    )
    
    static let poesiaYTeatro = Category(
        title: CategoryButton.poesiaYTeatro.rawValue,
        tableSections: [TableSection]()
    )
    
    static let aprenderIdiomas = Category(
        title: CategoryButton.aprenderIdiomas.rawValue,
        tableSections: [TableSection]()
    )
    
    static let inEnglish = Category(
        title: CategoryButton.inEnglish.rawValue,
        tableSections: [TableSection]()
    )
    
    static let historiasParaCadaEmocion = Category(
        title: CategoryButton.historiasParaCadaEmocion.rawValue,
        tableSections: [TableSection]()
    )
    
    static let home = Category(
        title: "",
        tableSections: [
            TableSection(sectionTitle: "Solo para ti"),
            TableSection(sectionTitle: "Los títulos del momento"),
            TableSection(sectionTitle: "¡Escuchalo ahora!", sectionSubtitle: "Una historia como nunca antes habías escuchado", sectionKind: .poster),
            TableSection(sectionTitle: "Top 50 hoy"),
            TableSection(sectionTitle: "Nuevos audiolibros"),
            TableSection(sectionTitle: "Alicia Giménez Bartlett - Serie Petra Delicado"),
            TableSection(sectionTitle: "Solo en Storytel"),
            TableSection(sectionTitle: "Novela: Recomendados para ti"),
            TableSection(sectionTitle: "Solo en Storytel", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Tendecia en Storytel"),
            TableSection(sectionTitle: "Pronto en audiolibro"),
            TableSection(sectionTitle: "Historias de pelicula (y serie)"),
            TableSection(sectionTitle: "Solo en Storytel", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Novela: Los más populares"),
            TableSection(sectionTitle: "Novela negra: Recomendados para ti"),
            TableSection(sectionTitle: "", sectionKind: .seriesCategoryButton),
            TableSection(sectionTitle: "El audiolibro de La Vecina Rubia", sectionKind: .storytelOriginal),
            TableSection(sectionTitle: "Series Top esta semana"),
            TableSection(sectionTitle: "", sectionKind: .allCategoriesButton)
        ])
    
    
    static let todasLasCategorias = Category(
        title: "Todas las categorías",
        tableSections: [
            TableSection(sectionTitle: "", sectionKind: .verticalCv),
        ])
    
}


