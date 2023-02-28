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

struct SectionTitleSubtitle {
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
    let categoryTitle: String
    let sectionTitlesSubtitles: [SectionTitleSubtitle]
    
    static let home = Category(
        categoryTitle: "",
        sectionTitlesSubtitles: [
            SectionTitleSubtitle(sectionTitle: "Solo para ti"),
            SectionTitleSubtitle(sectionTitle: "Los títulos del momento"),
            SectionTitleSubtitle(sectionTitle: "¡Escuchalo ahora!", sectionSubtitle: "Una historia como nunca antes habías escuchado", sectionKind: .poster),
            SectionTitleSubtitle(sectionTitle: "Top 50 hoy"),
            SectionTitleSubtitle(sectionTitle: "Nuevos audiolibros"),
            SectionTitleSubtitle(sectionTitle: "Alicia Giménez Bartlett - Serie Petra Delicado"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel"),
            SectionTitleSubtitle(sectionTitle: "Novela: Recomendados para ti"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Tendecia en Storytel"),
            SectionTitleSubtitle(sectionTitle: "Pronto en audiolibro"),
            SectionTitleSubtitle(sectionTitle: "Historias de pelicula (y serie)"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Novela: Los más populares"),
            SectionTitleSubtitle(sectionTitle: "Novela negra: Recomendados para ti"),
            SectionTitleSubtitle(sectionTitle: "", sectionKind: .seriesCategoryButton),
            SectionTitleSubtitle(sectionTitle: "El audiolibro de La Vecina Rubia", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Series Top esta semana"),
            SectionTitleSubtitle(sectionTitle: "", sectionKind: .allCategoriesButton)
        ])
    
    static let series = Category(
        categoryTitle: "Series",
        sectionTitlesSubtitles: [
            SectionTitleSubtitle(sectionTitle: "Series Top esta semana"),
            SectionTitleSubtitle(sectionTitle: "Una historia como nunca antes habías escuchado", sectionSubtitle: "Storytel Original", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Los crímenes de Fjällbacka -\nCamilla Läckberg"),
            SectionTitleSubtitle(sectionTitle: "Series que son tendencia"),
            SectionTitleSubtitle(sectionTitle: "Series exclusivas", sectionKind: .verticalCv),
            SectionTitleSubtitle(sectionTitle: "Serie Tom Ripley de\nPatricia Highsmith"),
            SectionTitleSubtitle(sectionTitle: "Serie el Club del Crimen de los Jueves"),
            SectionTitleSubtitle(sectionTitle: "Las mejores series originales"),
            SectionTitleSubtitle(sectionTitle: "Episodios de una guerra interminable"),
            SectionTitleSubtitle(sectionTitle: "Serie Vientos alisios de\nChristina Courtenay"),
            SectionTitleSubtitle(sectionTitle: "La Rueda del Tiempo de\nRobert Jordan"),
            SectionTitleSubtitle(sectionTitle: "Serie Sektion M de\nChristina Larsson"),
            SectionTitleSubtitle(sectionTitle: "Serie Kim Stone -\nAngela Marsons"),
            SectionTitleSubtitle(sectionTitle: "Susana Martín Gijón para Storytel Original", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Serie Bad Ash -\nAlina Not"),
            SectionTitleSubtitle(sectionTitle: "Mikel Santiago para Storytel Original", sectionSubtitle: "Una serie sonora original", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Storyside - Las historias de/nSherlock Holmes"),
            SectionTitleSubtitle(sectionTitle: "Juan Gómez-Jurado para Storytel Original", sectionSubtitle: "La primera serie sonora del autor en exclusivo para Stirytel", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Alicia Giménez Bartlett - Serie Petra Delicado"),
            SectionTitleSubtitle(sectionTitle: "Storytel Original - Todas las series")
        ])
    
    static let zonaPodcast = Category(
        categoryTitle: "Zona Podcast",
        sectionTitlesSubtitles: [
            SectionTitleSubtitle(sectionTitle: "Los más escuchados esta semana"),
            SectionTitleSubtitle(sectionTitle: "Nuevos podcast"),
            SectionTitleSubtitle(sectionTitle: "Sigue tus podcast favoritos", sectionKind: .verticalCv),
            SectionTitleSubtitle(sectionTitle: "Últimos episodios"),
            SectionTitleSubtitle(sectionTitle: "Los más buscados"),
            SectionTitleSubtitle(sectionTitle: "Storytel Original: Menlo Park")
        ])
    
    static let soloEnStorytel = Category(
        categoryTitle: "Solo en Storytel",
        sectionTitlesSubtitles: [
            SectionTitleSubtitle(sectionTitle: "Una historia como nunca antes habías escuchado", sectionSubtitle: "Storytel Original - Sonido binaural", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "En exclusiva - Los más escuchados esta semana"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel"),
            SectionTitleSubtitle(sectionTitle: "Nuestros bestsellers"),
            SectionTitleSubtitle(sectionTitle: "Seríу Сrímenes del norte de\nMario Escobar"),
            SectionTitleSubtitle(sectionTitle: "La Rueda del Tiempo de\nRobert Jordan"),
            SectionTitleSubtitle(sectionTitle: "Storytel Original - Los más escuchados esta semana"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Serie Los Crímenes del faro de Ibon Martín"),
            SectionTitleSubtitle(sectionTitle: "Novedades en exclusiva: Romántica"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Novelas"),
            SectionTitleSubtitle(sectionTitle: "Juan Gómez-Jurado para Storytel Original", sectionSubtitle: "La primera serie sonora del autor en exclusiva para Storytel", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Novela negra y Thriller"),
            SectionTitleSubtitle(sectionTitle: "¿Te los has perdido?"),
            SectionTitleSubtitle(sectionTitle: "Muy pronto en exclusiva"),
            SectionTitleSubtitle(sectionTitle: "En exclusiva - Tendencias"),
            SectionTitleSubtitle(sectionTitle: "Mikel Santiago para Storytel Original", sectionSubtitle: "Una serie sonora original", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Serie Vientos aliosos de\nChristina Courtenay"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: fantasía y Ciencia ficción"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel - Clásicos"),
            SectionTitleSubtitle(sectionTitle: "Storytel original - Todas las series"),
            SectionTitleSubtitle(sectionTitle: "Los más esperados en exclusiva"),
            SectionTitleSubtitle(sectionTitle: "Narrados en acento ibérico"),
            SectionTitleSubtitle(sectionTitle: "Narrados en acento neutro"),
            SectionTitleSubtitle(sectionTitle: "", sectionKind: .storytelOriginal),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Economía y negocios"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Historia"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Juvenil"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Infantil"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Biografías"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Poesía y Teatro"),
            SectionTitleSubtitle(sectionTitle: "Solo en Storytel: Religión y Espiritualidad"),
            SectionTitleSubtitle(sectionTitle: "Historias inmersivas")
        ])
    
    static let losMasPopulares = Category(
        categoryTitle: "Los más populares",
        sectionTitlesSubtitles: [
            SectionTitleSubtitle(sectionTitle: "Los más populares - Novela"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Novela negra"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Clásicos"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Romántica"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Thriller"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Literatura infantil"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Young adult y juvenil"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Fantasía y Ciencia Ficción"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Historia"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Crecimiento personal"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Non fiction"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Biografía"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Economía y negocios"),
            SectionTitleSubtitle(sectionTitle: "Los más populares - Relatos")
        ])
    
    static let soloParaTi = Category(
        categoryTitle: "Solo para ti",
        sectionTitlesSubtitles: [
            SectionTitleSubtitle(sectionTitle: "Recomendados para ti"),
            SectionTitleSubtitle(sectionTitle: "Novedades para ti")
        ])
    
}


