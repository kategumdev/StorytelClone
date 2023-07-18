//
//  DataPersistenceManager.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/7/23.
//

import Foundation

enum DataPersistenceError: Error {
    case failedToAddData
    case failedToFetchData
    case failedToDeleteData
}

enum BookState {
    case deleted
    case added
}

protocol DataPersistenceManager {
    associatedtype SharedType
    static var shared: SharedType { get }
    
    func fetchPersistedBooks(completion: @escaping (Result<[Book], Error>) -> Void)
    
    func fetchPersistedBookWith(id: String, completion: @escaping (Result<PersistedBook?, Error>) -> Void)

    func addPersistedBookOf(book: Book, completion: @escaping (Result<Void, Error>) -> Void)
    
    func delete(persistedBook: PersistedBook, completion: @escaping (Result<Void, Error>) -> Void)
    
    func addOrDeletePersistedBookFrom(book: Book, completion: @escaping (Result<BookState, Error>) -> Void)
}
