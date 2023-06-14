//
//  DataPersistenceManager.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/6/23.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DataPersistenceError: Error {
        case failedToAddData
        case failedToFetchData
        case failedToDeleteData
//        case failedToCheckIfBookIsSaved
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
//        persistedBook.date = book.date
        persistedBook.date = Date()
        
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
    
//    func deleteBookWith(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//
//        let request = PersistedBook.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
////        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(PersistedBook.id), id])
//
//        do {
//            let matchingObjects = try context.fetch(request)
//            for object in matchingObjects {
//                context.delete(object)
//            }
//            try context.save()
//            completion(.success(()))
//        } catch {
//            completion(.failure(DataPersistenceError.failedToDeleteData))
//        }
//
//    }
    
    func delete(persistedBook: PersistedBook, completion: @escaping (Result<Void, Error>) -> Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(persistedBook)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataPersistenceError.failedToDeleteData))
        }
        
    }

    
//    func deleteBookWith(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        fetchPersistedBookWith(id: id) { [weak self] result in
//            switch result {
//            case .success(let persistedBook):
//                do {
//                    context.delete(persistedBook)
//                    try context.save()
//                    completion(.success(()))
//                } catch {
//                    completion(.failure(DataPersistenceError.failedToDeleteData))
//                }
//
//
//            case .failure(let error):
//                completion(.failure(error))
//            }
//
//        }
//
//
//
//    }
    
//    func checkIfBookIsSaved(id: String) -> Bool {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//
//        let request = PersistedBook.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
////        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(PersistedBook.id), id])
//
//        do {
//            let matchingObjects = try context.fetch(request)
//            for object in matchingObjects {
//                context.delete(object)
//            }
//            try context.save()
//            completion(.success(()))
//        } catch {
//            completion(.failure(DataPersistenceError.failedToDeleteData))
//        }
//    }
    
//    func checkIfBookIsSaved(bookId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//
//        let request = PersistedBook.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", bookId)
////        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(PersistedBook.id), id])
//
//        do {
//            let matchingObjects = try context.fetch(request)
////            completion(.success(matchingObjects.first))
//            if matchingObjects.first != nil {
//                completion(.success(true))
//            } else {
//                completion(.success(false))
//            }
//        } catch {
//            completion(.failure(DataPersistenceError.failedToFetchData))
//        }
//    }
    
    
//    func fetchPersistedBookWith(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//
//        let request = PersistedBook.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
////        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(PersistedBook.id), id])
//
//        do {
//            let matchingObjects = try context.fetch(request)
////            completion(.success(matchingObjects.first))
//            if matchingObjects.first != nil {
//                completion(.success(true))
//            } else {
//                completion(.success(false))
//            }
//        } catch {
//            completion(.failure(DataPersistenceError.failedToFetchData))
//        }
//    }
    
    
    
    func fetchPersistedBookWith(id: String, completion: @escaping (Result<PersistedBook?, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let request = PersistedBook.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
//        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(PersistedBook.id), id])

        do {
            let matchingObjects = try context.fetch(request)
            completion(.success(matchingObjects.first))
//            if let persistedBook = matchingObjects.first {
//                completion(.success((persistedBook)))
//            }
        } catch {
            completion(.failure(DataPersistenceError.failedToFetchData))
        }
    }

}
