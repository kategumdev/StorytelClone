//
//  PersistedBook+CoreDataClass.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/6/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(PersistedBook)
public class PersistedBook: NSManagedObject {

    func transformToBook() -> Book {
        let persistedBook = self
        
        var authors = [Storyteller]()
        if let persistedStorytellersArray = persistedBook.authors?.array as? [PersistedStoryteller] {
            for persistedStoryteller in persistedStorytellersArray {
                let author = persistedStoryteller.transformToStoryteller()
                authors.append(author)
            }
        }
        
        var narrators = [Storyteller]()
        if let persistedStorytellersArray = persistedBook.narrators?.array as? [PersistedStoryteller] {
            for persistedStoryteller in persistedStorytellersArray {
                let narrator = persistedStoryteller.transformToStoryteller()
                narrators.append(narrator)
            }
        }
        
        let persistedImageData = persistedBook.coverImage
        let image = persistedImageData != nil ? UIImage(data: persistedImageData!) : nil
                
        let book = Book(
            id: persistedBook.id,
            title: persistedBook.title,
            authors: authors,
            coverImage: image,
            titleKind: TitleKind.createCaseFrom(rawValueString: persistedBook.titleKind),
            overview: persistedBook.overview,
            category: Category.createCaseFrom(rawValueString: persistedBook.category),
            rating: persistedBook.rating,
            reviewsNumber: Int(persistedBook.reviewsNumber),
            duration: persistedBook.duration,
            language: persistedBook.language,
            narrators: narrators,
            series: persistedBook.series,
            seriesPart: persistedBook.seriesPart != 0 ? Int(persistedBook.seriesPart) : nil,
            releaseDate: persistedBook.releaseDate,
            publisher: persistedBook.publisher,
            translators: persistedBook.translators as? [String],
            tags: Tag.createTagsFrom(strings: persistedBook.tags as? [String]),
            isFinished: persistedBook.isFinished,
            isDownloaded: persistedBook.isDownloaded,
            imageURLString: persistedBook.imageURLString,
            audioUrlString: persistedBook.audioUrlString
//            date: persistedBook.date
        )
        
        return book
    }
    
}
