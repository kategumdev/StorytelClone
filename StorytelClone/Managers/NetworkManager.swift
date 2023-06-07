//
//  NetworkManager.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import Foundation

struct APIConstants {
    static let GoogleBooksAPI_KEY = "AIzaSyBCtyopfZRlAavL6vF6NxmBhKtEglt7jPM"
    static let GoogleBooksBaseURL = "https://www.googleapis.com/books/v1/volumes?"
}

//https://www.googleapis.com/books/v1/volumes?q=gaiman&key=AIzaSyBCtyopfZRlAavL6vF6NxmBhKtEglt7jPM

typealias SearchResult = Result<[Book], Error>

enum NetworkManagerError: Error {
    case noInternetConnection
    case failedToFetch
    case noResults
}

class NetworkManager {
    private var currentGoogleBooksDataTask: URLSessionDataTask?
    private var currentITunesDataTask: URLSessionDataTask?
    private(set) var hasError = false
    
    private func fetchEbooks(with query: String, completion: @escaping (Result<[Ebook], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(APIConstants.GoogleBooksBaseURL)q=\(query)&key=\(APIConstants.GoogleBooksAPI_KEY)") else { return }
        
        currentGoogleBooksDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain as String && error.code == -1020 {
                    completion(.failure(NetworkManagerError.noInternetConnection))
                } else if error.code != -999 {
                    completion(.failure(NetworkManagerError.failedToFetch))
                    // avoid calling completion when -999, which means dataTask was cancelled (new search or Cancel button tap in search bar). When dataTask completion is not called, completion of fetchBooks func won't be called as well (dispatchGroup will not be able to call its leave() as it's inside dataTask that won't be called) and nothing will be done which is needed behavior
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                do {
                    let results = try JSONDecoder().decode(GoogleBooksSearchResponse.self, from: data)
                    completion(.success(results.items))
                } catch {
                    completion(.failure(NetworkManagerError.noResults))
                }
            } else {
                completion(.failure(NetworkManagerError.failedToFetch))
            }
        }
        currentGoogleBooksDataTask?.resume()
    }
    
    private func fetchAudiobooks(with query: String, completion: @escaping (Result<[Audiobook], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: "http://itunes.apple.com/search?term=\(encodedQuery)&entity=audiobook&limit=10") else { return }
        
        currentITunesDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain as String && error.code == -1020 {
                    completion(.failure(NetworkManagerError.noInternetConnection))
                } else if error.code != -999 {
                    completion(.failure(NetworkManagerError.failedToFetch))
                    // avoid calling completion when -999, which means dataTask was cancelled (new search or Cancel button tap in search bar). When dataTask completion is not called, completion of fetchBooks func won't be called as well (dispatchGroup will not be able to call its leave() as it's inside dataTask that won't be called) and nothing will be done which is needed behavior
                }
                return
            }
             
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data  {
                do {
                    let results = try JSONDecoder().decode(ITunesSearchResponse.self, from: data)
                    completion(.success(results.results))
                } catch {
                    completion(.failure(NetworkManagerError.noResults))
                }
            } else {
                completion(.failure(NetworkManagerError.failedToFetch))
            }
        }
        currentITunesDataTask?.resume()
    }
    
    func fetchBooks(withQuery query: String, bookKindsToFetch: BookKinds, completion: @escaping (SearchResult) -> Void) {
        hasError = false

        let dataTaskGroup = DispatchGroup()
        var fetchError: Error?
        var allFetchedBooks = [Book]()
        let queryString = query.trimmingCharacters(in: .whitespaces)

        // Perform Google Books search
        if bookKindsToFetch == .ebooksAndAudiobooks || bookKindsToFetch == .onlyEbooks {
            dataTaskGroup.enter()
            fetchEbooks(with: queryString) { result in
                switch result {
                case .success(let ebooks):
                    let books = Book.createBooksFromEbooks(ebooks)
                    allFetchedBooks += books
                case .failure(let error): fetchError = error
                }
                dataTaskGroup.leave()
            }
        }
        
        if bookKindsToFetch == .ebooksAndAudiobooks || bookKindsToFetch == .onlyAudiobooks {
            // Perform iTunes search
            dataTaskGroup.enter()
            fetchAudiobooks(with: queryString) { result in
                switch result {
                case .success(let audiobooks):
                    let books = Book.createBooksFromAudiobooks(audiobooks)
                    allFetchedBooks += books
                case .failure(let error): fetchError = error
                }
                dataTaskGroup.leave()
            }
        }

        dataTaskGroup.notify(queue: DispatchQueue.main) { [weak self] in
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
#warning("If either task was cancelled (and therefore its completion wasn't called), dataTaskGroup.notify won't be called. Does it need to be cleaned somehow?")
    }
    
    func cancelTasks() {
        currentGoogleBooksDataTask?.cancel()
        currentGoogleBooksDataTask = nil
        currentITunesDataTask?.cancel()
        currentITunesDataTask = nil
    }
    
    deinit {
        print("Particular instance of NetworkManager cancels data tasks in deinit")
        cancelTasks()
    }
    
}
