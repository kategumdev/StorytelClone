//
//  AlamofireNetworkManager.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import Foundation
import Alamofire

enum NetworkManagerError: Error {
    case noInternetConnection
    case failedToFetch
    case noResults
}

class AlamofireNetworkManager: NetworkManager {
    enum WebService {
        case googleBooks
        case itunes
        
        var url: String {
            switch self {
            case .googleBooks: return "https://www.googleapis.com/books/v1/volumes?"
            case .itunes: return "http://itunes.apple.com/search?"
            }
        }
        
        var apiKey: String {
            switch self {
            case .googleBooks:
                if let apiKey = ProcessInfo.processInfo.environment["GOOGLE_BOOKS_API_KEY"] {
                    return apiKey
                } else {
                    fatalError("Could not find value for key 'GOOGLE_BOOKS_API_KEY' in the environmental variables")
                }
            case .itunes: return "" // No key is needed for this api
            }
        }
    }
    
    private var dataRequests: [DataRequest] = []
    var hasError = false
    
    func fetchBooks(
        withQuery query: String,
        bookKindsToFetch: BookKinds,
        completion: @escaping (SearchResult) -> Void
    ) {
        hasError = false

        let fetchGroup = DispatchGroup()
        var fetchError: Error?
        var allFetchedBooks = [Book]()

        let handleResultClosure: (SearchResult) -> Void = { result in
            switch result {
            case .success(let books):
                allFetchedBooks += books
            case .failure(let error): fetchError = error
            }
            fetchGroup.leave()
        }

        if bookKindsToFetch == .ebooksAndAudiobooks || bookKindsToFetch == .onlyEbooks {
            fetchGroup.enter()
            // Perform Google Books search
            fetch(
                webService: .googleBooks,
                resultValueType: GoogleBooksSearchResponse.self,
                query: query,
                completion: handleResultClosure)
        }

        if bookKindsToFetch == .ebooksAndAudiobooks || bookKindsToFetch == .onlyAudiobooks {
            // Perform iTunes search
            fetchGroup.enter()
            fetch(
                webService: .itunes,
                resultValueType: ITunesSearchResponse.self,
                query: query,
                completion: handleResultClosure)
        }

        fetchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            if !allFetchedBooks.isEmpty {
                self?.hasError = false
                completion(.success(allFetchedBooks))
            } else if let unwrappedSavedError = fetchError as? NetworkManagerError {
                self?.hasError = true
                completion(.failure(unwrappedSavedError))
            } else {
                self?.hasError = true
                // When empty and no errors
                completion(.failure(NetworkManagerError.noResults))
            }
        }
    }
    
    private func fetch<T: Decodable & SearchResponse>(
        webService: WebService,
        resultValueType: T.Type,
        query: String,
        completion: @escaping (SearchResult
        ) -> Void) {
        var parameters: [String : String] = [:]
        switch webService {
        case .googleBooks:
            parameters = ["q" : query, "key" : webService.apiKey]
        case .itunes:
            parameters = [
                "term" : query,
                "entity" : "audiobook",
                "limit" : "10"
            ]
        }

        let dataRequest = AF.request(webService.url, parameters: parameters)
          .validate()
          .responseDecodable(of: T.self) { response in
              switch response.result {
              case .success(let data):
                  let books = data.books
                  if books.isEmpty {
                      completion(.failure(NetworkManagerError.noResults))
                  } else {
                      completion(.success(books))
                  }
              case .failure(let error):
                  guard let afError = error.asAFError else { return }
                  
                  if
                    let urlError = afError.underlyingError as? URLError,
                    urlError.code == URLError.notConnectedToInternet || urlError.code == URLError.dataNotAllowed {
                        completion(.failure(NetworkManagerError.noInternetConnection))
                  } else if !afError.isExplicitlyCancelledError {
                      /* Avoid calling completion if request was cancelled (new search or
                       Cancel button tap in search bar). When completion is not called,
                       completion of fetchBooks func won't be called as well (dispatchGroup
                       will not be able to call its leave() as it's inside request that
                       won't be called) and nothing will be done which is needed behavior */
                      completion(.failure(NetworkManagerError.failedToFetch))
                  }
              }
          }
        dataRequests.append(dataRequest)
    }
    
    func cancelRequests() {
        dataRequests.forEach { $0.cancel() }
        dataRequests.removeAll()
    }

    deinit {
        cancelRequests()
    }
}
