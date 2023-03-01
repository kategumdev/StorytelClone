//
//  Category.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/2/23.
//

import Foundation

enum VcKind {
    case home
    case particularCategory
    case todasLasCategorias
}

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

struct Category {
    let title: String
    let vcKind: VcKind
    let tableSections: [TableSection]
    
    init(title: String, vcKind: VcKind = .particularCategory, tableSections: [TableSection]) {
        self.title = title
        self.vcKind = vcKind
        self.tableSections = tableSections
    }
    
    static let allCategories = [
        Category.novela,
        Category.zonaPodcast,
        Category.novelaNegra,
        Category.romantica,
        Category.thrillerYHorror,
        Category.fantasiaYCienciaFiccion,
        Category.crecimientoPersonalYLifestyle,
        Category.infantil,
        Category.clasicos,
        Category.juvenilYYoungAdult,
        Category.erotica,
        Category.noFiccion,
        Category.economiaYNegocios,
        Category.relatosCortos,
        Category.historia,
        Category.espiritualidadYReligion,
        Category.biografias,
        Category.poesiaYTeatro,
        Category.aprenderIdiomas,
        Category.inEnglish
    ]
    
    static let home = Category(
        title: "",
        vcKind: .home,
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
    
    static let series = Category(
        title: "Series",
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
    
    static let todasLasCategorias = Category(
        title: "Todas las categorías",
        vcKind: .todasLasCategorias,
        tableSections: [
            TableSection(sectionTitle: "", sectionKind: .verticalCv),
        ])
    
    
    static let zonaPodcast = Category(
        title: "Zona Podcast",
        tableSections: [
            TableSection(sectionTitle: "Los más escuchados esta semana"),
            TableSection(sectionTitle: "Nuevos podcast"),
            TableSection(sectionTitle: "Sigue tus podcast favoritos", sectionKind: .verticalCv),
            TableSection(sectionTitle: "Últimos episodios"),
            TableSection(sectionTitle: "Los más buscados"),
            TableSection(sectionTitle: "Storytel Original: Menlo Park")
        ])
    
    static let soloEnStorytel = Category(
        title: "Solo en Storytel",
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
        title: "Los más populares",
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
        title: "Solo para ti",
        tableSections: [
            TableSection(sectionTitle: "Recomendados para ti"),
            TableSection(sectionTitle: "Novedades para ti")
        ])
    
    static let eBooks = Category(
        title: "Ebooks",
        tableSections: [
            TableSection(sectionTitle: "Novela - Los más leidos"),
            TableSection(sectionTitle: "Novela negra y Thriller - Los más leidos")
        ])
    
    static let novela = Category(
        title: "Novela",
        tableSections: [
            TableSection(sectionTitle: "Los más populares - Novela"),
            TableSection(sectionTitle: "Nuevas novelas")
        ])
    
    static let novelaNegra = Category(
        title: "Novela negra",
        tableSections: [
            TableSection(sectionTitle: "Solo en Storytel"),
            TableSection(sectionTitle: "Los más populares - Novela negra")
        ])
    
    static let romantica = Category(
        title: "Romántica",
        tableSections: [
            TableSection(sectionTitle: "Los más populares - Romántica"),
            TableSection(sectionTitle: "Nuevas histotias de amor")
        ])
    
    static let thrillerYHorror = Category(
        title: "Thriller y Horror",
        tableSections: [TableSection]()
    )
    
    static let fantasiaYCienciaFiccion = Category(
        title: "Fantasía y\nCiencia ficción",
        tableSections: [TableSection]()
    )
    
    static let infantil = Category(
        title: "Infantil",
        tableSections: [TableSection]()
    )
    
    static let crecimientoPersonalYLifestyle = Category(
        title: "Crecimiento\nPersonal y Lifestyle",
        tableSections: [TableSection]()
    )
    
    static let clasicos = Category(
        title: "Clásicos",
        tableSections: [TableSection]()
    )
    
    static let juvenilYYoungAdult = Category(
        title: "Juvenil y\nYoung Adult",
        tableSections: [TableSection]()
    )
    
    static let erotica = Category(
        title: "Erótica",
        tableSections: [TableSection]()
    )
    
    static let noFiccion = Category(
        title: "No ficción",
        tableSections: [TableSection]()
    )
    
    static let economiaYNegocios = Category(
        title: "Economía y negocios",
        tableSections: [TableSection]()
    )
    
    static let relatosCortos = Category(
        title: "Relatos cortos",
        tableSections: [TableSection]()
    )
    
    static let historia = Category(
        title: "Historia",
        tableSections: [TableSection]()
    )
    
    static let espiritualidadYReligion = Category(
        title: "Espiritualidad\ny Religión",
        tableSections: [TableSection]()
    )
    
    static let biografias = Category(
        title: "Biografías",
        tableSections: [TableSection]()
    )
    
    static let poesiaYTeatro = Category(
        title: "Poesía y teatro",
        tableSections: [TableSection]()
    )
    
    static let aprenderIdiomas = Category(
        title: "Aprender idiomas",
        tableSections: [TableSection]()
    )
    
    static let inEnglish = Category(
        title: "In English",
        tableSections: [TableSection]()
    )
    
}


