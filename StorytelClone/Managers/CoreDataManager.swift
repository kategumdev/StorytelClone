//
//  CoreDataManager.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/6/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: DataPersistenceManager {    
    static let shared = CoreDataManager()
    
    private init() { }
    
    // MARK: - Instance methods
    func addPersistedBookOf(book: Book, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let persistedBook = PersistedBook(context: context)
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
            persistedBook.addToNarrators(persistedNarrator)
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
    
    func delete(persistedBook: PersistedBook, completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func fetchPersistedBookWith(
        id: String,
        completion: @escaping (Result<PersistedBook?, Error>) -> Void
    ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = PersistedBook.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let matchingObjects = try context.fetch(request)
            completion(.success(matchingObjects.first))
        } catch {
            completion(.failure(DataPersistenceError.failedToFetchData))
        }
    }
    
    func addOrDeletePersistedBookFrom(
        book: Book,
        completion: @escaping (Result<BookState, Error>
        ) -> Void) {
        var isBookBeingAdded = false
        var fetchedBook: PersistedBook? = nil
        
        fetchPersistedBookWith(id: book.id) { result in
            switch result {
            case .success(let persistedBook):
                isBookBeingAdded = persistedBook == nil ? true : false
                fetchedBook = persistedBook
            case .failure:
                completion(.failure(DataPersistenceError.failedToFetchData))
            }
        }
        
        if isBookBeingAdded {
            // Add persisted book
            addPersistedBookOf(book: book) { result in
                switch result {
                case .success():
                    completion(.success(BookState.added))
                case .failure(let error):
                    completion(.failure(DataPersistenceError.failedToAddData))
                    print(error.localizedDescription)
                }
            }
        } else {
            // Remove persisted book
            guard let persistedBookToDelete = fetchedBook else { return }
            delete(persistedBook: persistedBookToDelete) { result in
                switch result {
                case .success():
                    completion(.success(BookState.deleted))
                case .failure(let error):
                    completion(.failure(DataPersistenceError.failedToDeleteData))
                    print(error.localizedDescription)
                }
            }
        }
    }
}
