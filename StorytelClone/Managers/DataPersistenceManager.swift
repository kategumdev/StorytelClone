//
//  DataPersistenceManager.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/6/23.
//

import Foundation
import UIKit

class DataPersistenceManager {
    
    enum DataPersistenceError: Error {
        case failedToAddData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func addPersistedBookOf(book: Book, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let persistedBook = PersistedBook(context: context)
        
//        persistedBook.id = UUID(uuidString: book.id)
        persistedBook.id = book.id
        persistedBook.title = book.title
        persistedBook.coverImage = book.coverImage?.pngData()
        persistedBook.titleKind = book.titleKind.rawValue
        persistedBook.overview = book.overview
        persistedBook.category = book.category.rawValue
        persistedBook.rating = book.rating
        persistedBook.reviewsNumber = Int16(book.reviewsNumber)
        persistedBook.duration = book.duration
        persistedBook.language = book.language
        persistedBook.series = book.series
        persistedBook.releaseDate = book.releaseDate
        persistedBook.publisher = book.publisher
        persistedBook.isFinished = book.isFinished
        persistedBook.isDownloaded = book.isDownloaded
        persistedBook.imageURLString = book.imageURLString
        persistedBook.audioUrlString = book.audioUrlString
        persistedBook.date = book.date
        
        let tagsTitles = book.tags.map { $0.tagTitle }
        persistedBook.tags = NSArray(array: tagsTitles)
        
        if let translatorsArray = book.translators {
            persistedBook.translators = NSArray(array: translatorsArray)
        }
        
        if let seriesPart = book.seriesPart {
            persistedBook.seriesPart = Int16(seriesPart)
        }
        
        for author in book.authors {
            let persistedAuthor = PersistedStoryteller(context: context)
            persistedAuthor.name = author.name
            persistedAuthor.numberOfFollowers = Int16(author.numberOfFollowers)
            persistedAuthor.titleKind = author.titleKind.rawValue
            persistedBook.addToAuthors(persistedAuthor)
        }
        
        for narrator in book.narrators {
            let persistedNarrator = PersistedStoryteller(context: context)
            persistedNarrator.name = narrator.name
            persistedNarrator.numberOfFollowers = Int16(narrator.numberOfFollowers)
            persistedNarrator.titleKind = narrator.titleKind.rawValue
            persistedBook.addToAuthors(persistedNarrator)
        }
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DataPersistenceError.failedToAddData))
        }
        
    }
    
    func fetchPersistedBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = PersistedBook.fetchRequest()
        
        do {
            let persistedBooks = try context.fetch(request)
            let books = persistedBooks.map { $0.transformToBook() }
            completion(.success(books))
        } catch {
            completion(.failure(DataPersistenceError.failedToFetchData))
        }
    }

}
