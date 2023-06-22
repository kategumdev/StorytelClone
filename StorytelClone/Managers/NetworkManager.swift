//
//  NetworkManager.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import Foundation
import Alamofire
import SDWebImage

typealias SearchResult = Result<[Book], Error>

protocol SearchResponse {
    var books: [Book] { get }
}

enum NetworkManagerError: Error {
    case noInternetConnection
    case failedToFetch
    case noResults
}

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

class NetworkManager {
    private let sdWebImageDownloader = SDWebImageDownloader()
    private var dataRequests: [DataRequest] = []
    private(set) var hasError = false
    
    private func fetch<T: Decodable & SearchResponse>(webService: WebService, resultValueType: T.Type, query: String, completion: @escaping (SearchResult) -> Void) {
        
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
                  
                  if let urlError = afError.underlyingError as? URLError, urlError.code == URLError.notConnectedToInternet || urlError.code == URLError.dataNotAllowed {
                        completion(.failure(NetworkManagerError.noInternetConnection))
                  } else if !afError.isExplicitlyCancelledError {
                      // avoid calling completion if request was cancelled (new search or Cancel button tap in search bar). When completion is not called, completion of fetchBooks func won't be called as well (dispatchGroup will not be able to call its leave() as it's inside request that won't be called) and nothing will be done which is needed behavior
                      completion(.failure(NetworkManagerError.failedToFetch))
                  }
              }
          }
        dataRequests.append(dataRequest)
    }
    
    func fetchBooks(withQuery query: String, bookKindsToFetch: BookKinds, completion: @escaping (SearchResult) -> Void) {
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
            fetch(webService: .googleBooks, resultValueType: GoogleBooksSearchResponse.self, query: query, completion: handleResultClosure)
        }
        
        if bookKindsToFetch == .ebooksAndAudiobooks || bookKindsToFetch == .onlyAudiobooks {
            // Perform iTunes search
            fetchGroup.enter()
            fetch(webService: .itunes, resultValueType: ITunesSearchResponse.self, query: query, completion: handleResultClosure)
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
                completion(.failure(NetworkManagerError.noResults)) // when empty and no errors
            }
        }
    }
    
    func loadAndResizeImagesFor(books: [Book], subCategoryKind: SubCategoryKind, completion: @escaping (([Book]) -> Void)) {
        
        // Load and resize poster image
        guard subCategoryKind != .poster else {
            if let book = books.first, let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
                sdWebImageDownloader.downloadImage(with: imageURL) { image, data, error, success in
                    if let image = image {
                        let resizedImage = image.resizeFor(targetHeight: PosterTableViewCell.calculatedButtonHeight, andSetAlphaTo: 1)
                        var bookWithImage = book
                        bookWithImage.coverImage = resizedImage
                        completion([bookWithImage])
                    }
                }
            }
            return
        }
        
        // Load and resize images for other sub category kinds
        let downloadTaskGroup = DispatchGroup()
        var booksWithImages = [Book]() // it will contain only books that have downloaded images
        
        for book in books {
            if let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
                downloadTaskGroup.enter()
                sdWebImageDownloader.downloadImage(with: imageURL) { image, data, error, success in
                    if let image = image {
                        var targetHeight: CGFloat
                        if subCategoryKind == .horizontalCv {
                            targetHeight = Constants.largeSquareBookCoverSize.height
                        } else {
                            // for sub category with large rectangle covers
                            targetHeight = TableViewCellWithHorzCvLargeRectangleCovers.itemSize.height
                        }
                        let resizedImage = image.resizeFor(targetHeight: targetHeight, andSetAlphaTo: 1)
                        var bookWithImage = book
                        bookWithImage.coverImage = resizedImage
                        booksWithImages.append(bookWithImage)
                    }
                    downloadTaskGroup.leave()
                }
            }
        }
        downloadTaskGroup.notify(queue: DispatchQueue.main) {
            booksWithImages.shuffle()
            completion(booksWithImages)
        }
    }
    
    func cancelRequestsAndDownloads() {
        sdWebImageDownloader.cancelAllDownloads()
        
        for request in dataRequests {
            request.cancel()
        }
        dataRequests.removeAll()
    }

    deinit {
        print("Particular instance of NetworkManager cancels requests and downloads in deinit")
        cancelRequestsAndDownloads()
    }
    
}
