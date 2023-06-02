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

enum NetworkManagerError: Error {
    case noInternetConnection
    case failedToFetch
    case noResults
}

class NetworkManager {
//    static let shared = NetworkManager()
    
    var currentGoogleBooksDataTask: URLSessionDataTask?
    var currentITunesDataTask: URLSessionDataTask?
    
    var savedError: NetworkManagerError?
    
//    private func fetchEbooks(with query: String, completion: @escaping (Result<[Ebook], Error>) -> Void) {
//        savedError = nil
//        currentGoogleBooksDataTask?.cancel()
//
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        guard let url = URL(string: "\(APIConstants.GoogleBooksBaseURL)q=\(query)&key=\(APIConstants.GoogleBooksAPI_KEY)") else { return }
//
//        currentGoogleBooksDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
//            if let error = error as NSError? {
//                if error.domain == NSURLErrorDomain as String && error.code == -1020 {
//                    self?.savedError = NetworkManagerError.noInternetConnection
//                    completion(.failure(NetworkManagerError.noInternetConnection))
////                    print("\n\n\n GOOGLE BOOKS SEARCH WITH NO INTERNET CONNECTION")
//                } else {
//                    self?.savedError = NetworkManagerError.failedToFetch
//                    completion(.failure(NetworkManagerError.failedToFetch))
////                    print("\n\n\n GOOGLE BOOKS SEARCH SOME ERROR")
//                }
//               return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
//                do {
//                    let results = try JSONDecoder().decode(GoogleBooksSearchResponse.self, from: data)
//                    if results.items.isEmpty {
//                        print("RESULTS GOOGLE BOOKS: \(results.items.count)")
//                        completion(.failure(NetworkManagerError.noResults))
//                    } else {
//                        completion(.success(results.items))
//                    }
////                    completion(.success(results.items))
//                } catch {
//                    print("CATCH GOOGLE BOOKS sends .failedToFetch")
//                    self?.savedError = NetworkManagerError.failedToFetch
//                    completion(.failure(NetworkManagerError.failedToFetch))
//                }
//            } else {
//                self?.savedError = NetworkManagerError.failedToFetch
//                completion(.failure(NetworkManagerError.failedToFetch))
////                print("\n\n\n GOOGLE BOOKS SEARCH httpResponse error")
//            }
//        }
//        currentGoogleBooksDataTask?.resume()
//    }
//
//    private func fetchAudiobooks(with query: String, completion: @escaping (Result<[Audiobook], Error>) -> Void) {
//        currentITunesDataTask?.cancel()
//
//        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
//
//        guard let url = URL(string: "http://itunes.apple.com/search?term=\(encodedQuery)&entity=audiobook&limit=10") else { return }
//
//        currentITunesDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
//
//            if let error = error as NSError? {
//                if error.domain == NSURLErrorDomain as String && error.code == -1020 {
//                    self?.savedError = NetworkManagerError.noInternetConnection
//                    completion(.failure(NetworkManagerError.noInternetConnection))
////                    print("\n\n\n ITUNES SEARCH WITH NO INTERNET CONNECTION")
//                } else {
//                    self?.savedError = NetworkManagerError.failedToFetch
//                    completion(.failure(NetworkManagerError.failedToFetch))
////                    print("\n\n\n ITUNES SEARCH  SEARCH SOME ERROR")
//                }
//               return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data  {
//                do {
//                    let results = try JSONDecoder().decode(ITunesSearchResponse.self, from: data)
//                    print("RESULTS ITUNES: \(results.results.count)")
//                    if results.results.isEmpty {
//                        completion(.failure(NetworkManagerError.noResults))
//                    } else {
//                        completion(.success(results.results))
//                    }
////                    completion(.success(results.results))
//                } catch {
//                    print("CATCH GOOGLE BOOKS sends .failedToFetch")
//                    self?.savedError = NetworkManagerError.failedToFetch
//                    completion(.failure(NetworkManagerError.failedToFetch))
//                }
//            } else {
//                self?.savedError = NetworkManagerError.failedToFetch
//                completion(.failure(NetworkManagerError.failedToFetch))
////                print("\n\n\n ITUNES SEARCH httpResponse error")
//            }
//        }
//        currentITunesDataTask?.resume()
//    }
    
    private func fetchEbooks(with query: String, completion: @escaping (Result<[Ebook], Error>) -> Void) {
        savedError = nil
        currentGoogleBooksDataTask?.cancel()
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(APIConstants.GoogleBooksBaseURL)q=\(query)&key=\(APIConstants.GoogleBooksAPI_KEY)") else { return }
        
        currentGoogleBooksDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain as String && error.code == -1020 {
                    self?.savedError = NetworkManagerError.noInternetConnection
                    completion(.failure(NetworkManagerError.noInternetConnection))
                } else if error.code == -999 {
                    // dataTask was cancelled (because of new search or user taps Cancel button in SearchVC)
                       return
                } else {
                    self?.savedError = NetworkManagerError.failedToFetch
                    completion(.failure(NetworkManagerError.failedToFetch))
                }
               return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                do {
                    let results = try JSONDecoder().decode(GoogleBooksSearchResponse.self, from: data)
                    completion(.success(results.items))
                } catch {
                    self?.savedError = NetworkManagerError.noResults
                    completion(.failure(NetworkManagerError.noResults))
                }
            } else {
                self?.savedError = NetworkManagerError.failedToFetch
                completion(.failure(NetworkManagerError.failedToFetch))
            }
        }
        currentGoogleBooksDataTask?.resume()
    }
    
    private func fetchAudiobooks(with query: String, completion: @escaping (Result<[Audiobook], Error>) -> Void) {
        currentITunesDataTask?.cancel()
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        guard let url = URL(string: "http://itunes.apple.com/search?term=\(encodedQuery)&entity=audiobook&limit=10") else { return }
        
        currentITunesDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
           
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain as String && error.code == -1020 {
                    self?.savedError = NetworkManagerError.noInternetConnection
                    completion(.failure(NetworkManagerError.noInternetConnection))
                    return
                } else if error.code == -999 {
                    // dataTask was cancelled (because of new search or user taps Cancel button in SearchVC)
                       return
                } else {
                    self?.savedError = NetworkManagerError.failedToFetch
                    completion(.failure(NetworkManagerError.failedToFetch))
                }
               return
            }
             
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data  {
                do {
                    let results = try JSONDecoder().decode(ITunesSearchResponse.self, from: data)
                    completion(.success(results.results))
                } catch {
                    self?.savedError = NetworkManagerError.noResults
                    completion(.failure(NetworkManagerError.noResults))
                }
            } else {
                self?.savedError = NetworkManagerError.failedToFetch
                completion(.failure(NetworkManagerError.failedToFetch))
            }
        }
        currentITunesDataTask?.resume()
    }
    
    func fetchBooks(withQuery query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let dataTaskGroup = DispatchGroup()
        
        var savedError: Error?
        var allFetchedBooks = [Book]()
        
        // Do Google Books search
        dataTaskGroup.enter()
        fetchEbooks(with: query) { result in
            switch result {
            case .success(let ebooks):
                let books = Book.createBooksFromEbooks(ebooks)
                allFetchedBooks += books
            case .failure(let error):
                savedError = error
            }
            dataTaskGroup.leave()
        }
        
        // Do iTunes search
        dataTaskGroup.enter()
        fetchAudiobooks(with: query) { result in
            switch result {
            case .success(let audiobooks):
                let books = Book.createBooksFromAudiobooks(audiobooks)
                allFetchedBooks += books
            case .failure(let error):
                savedError = error
            }
            dataTaskGroup.leave()
        }
        
        dataTaskGroup.notify(queue: DispatchQueue.main) {
//            print("\n\n dataTaskGroup notified and performing completion")
            if !allFetchedBooks.isEmpty {
                completion(.success(allFetchedBooks))
            } else if let unwrappedSavedError = savedError {
                completion(.failure(unwrappedSavedError))
            } else {
                completion(.failure(NetworkManagerError.noResults)) // when not empty and no errors
            }
        }
    }
    
//    func fetchBooks(withQuery query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
//        let dataTaskGroup = DispatchGroup()
//
//        var savedError: Error?
//        var allFetchedBooks = [Book]()
//
//        dataTaskGroup.enter()
//        fetchEbooks(with: query) { result in
//
//            switch result {
//            case .success(let ebooks):
//                let books = Book.createBooksFromEbooks(ebooks)
//                allFetchedBooks += books
//            case .failure(let error):
//                savedError = error
//            }
////            print("Google books data task COMPLETED")
//            dataTaskGroup.leave()
//        }
//
//        dataTaskGroup.enter()
//        fetchAudiobooks(with: query) { result in
//
//            switch result {
//            case .success(let audiobooks):
//                let books = Book.createBooksFromAudiobooks(audiobooks)
//                allFetchedBooks += books
//            case .failure(let error):
//                savedError = error
//            }
////            print("iTunes data task COMPLETED")
//            dataTaskGroup.leave()
//        }
//
//        dataTaskGroup.notify(queue: DispatchQueue.main) {
//            print("dataTaskGroup notified and performing completion")
//            print("allFetchedBooks count \(allFetchedBooks.count)")
//            print("savedError: \(savedError)")
//            if !allFetchedBooks.isEmpty {
//                completion(.success(allFetchedBooks))
//            } else if let error = savedError {
//                completion(.failure(error))
//            } else {
//                completion(.success(allFetchedBooks))
//            }
//        }
//    }
    
    deinit {
        print("Particular instance of NetworkManager cancels data tasks in deinit")
        currentGoogleBooksDataTask?.cancel()
        currentGoogleBooksDataTask = nil
        
        currentITunesDataTask?.cancel()
        currentITunesDataTask = nil
    }
    
}


//class NetworkManager {
//    static let shared = NetworkManager()
//
//    var currentGoogleBooksDataTask: URLSessionDataTask?
//    var currentITunesDataTask: URLSessionDataTask?
//
//    private func fetchEbooks(with query: String, completion: @escaping ([Ebook]?) -> Void) {
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        guard let url = URL(string: "\(APIConstants.GoogleBooksBaseURL)q=\(query)&key=\(APIConstants.GoogleBooksAPI_KEY)") else { return }
//
//        currentGoogleBooksDataTask?.cancel()
//        currentGoogleBooksDataTask = nil
//
//        currentGoogleBooksDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else { return }
//
//            do {
//                let results = try JSONDecoder().decode(GoogleBooksSearchResponse.self, from: data)
//
////                let jsonString = try String(contentsOf: url, encoding: .utf8)
////                print("\(jsonString)")
//                completion(results.items)
//            } catch {
//                completion(nil)
//                print("ERROR OCCURED IN DATA TASK Google Books API")
//                print(error.localizedDescription)
//            }
//        }
//        currentGoogleBooksDataTask?.resume()
//    }
//
//    private func fetchAudiobooks(with query: String, completion: @escaping ([Audiobook]?) -> Void) {
//        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
//
//        guard let url = URL(string: "http://itunes.apple.com/search?term=\(encodedQuery)&entity=audiobook&limit=10") else { return }
//
//        currentITunesDataTask?.cancel()
//        currentITunesDataTask = nil
//
//        currentITunesDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else { return }
//
//            do {
//                let results = try JSONDecoder().decode(ITunesSearchResponse.self, from: data)
//                completion(results.results)
//            } catch {
//                completion(nil)
//                print("ERROR OCCURED IN DATA TASK iTunes API")
//                print(error.localizedDescription)
//            }
//        }
//        currentITunesDataTask?.resume()
//    }
//
//    func fetchBooks(withQuery query: String, completion: @escaping ([Book]) -> Void) {
//        let dataTaskGroup = DispatchGroup()
//
//        var allFetchedBooks = [Book]()
//
//        dataTaskGroup.enter()
//        fetchEbooks(with: query) { ebooks in
//            let books = Book.createBooksFromEbooks(ebooks)
//            allFetchedBooks += books
//            print("Google books data task COMPLETED")
//            dataTaskGroup.leave()
//        }
//
//        dataTaskGroup.enter()
//        fetchAudiobooks(with: query) { audiobooks in
//            let books = Book.createBooksFromAudiobooks(audiobooks)
//            allFetchedBooks += books
//            print("iTunes data task COMPLETED")
//            dataTaskGroup.leave()
//        }
//
//        dataTaskGroup.notify(queue: DispatchQueue.main) {
//            print("dataTaskGroup notified and performing completion")
//            completion(allFetchedBooks)
//        }
//    }
//
//}
