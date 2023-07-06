//
//  NetworkManager.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/7/23.
//

import Foundation

typealias SearchResult = Result<[Book], Error>

protocol SearchResponse {
    var books: [Book] { get }
}

protocol NetworkManager {
    var hasError: Bool { get set }
    
    func fetchBooks(withQuery query: String, bookKindsToFetch: BookKinds, completion: @escaping (SearchResult) -> Void)
    
    func loadAndResizeImagesFor(books: [Book], subCategoryKind: SubCategoryKind, completion: @escaping (([Book]) -> Void))
    
    func cancelRequestsAndDownloads()
    
}

