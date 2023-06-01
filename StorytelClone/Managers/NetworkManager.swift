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
    case noResultsForQuery
    case failedToGetData
}

class NetworkManager {
    static let shared = NetworkManager()
    
    var currentGoogleBooksDataTask: URLSessionDataTask?
    var currentITunesDataTask: URLSessionDataTask?
    
    private func fetchEbooks(with query: String, completion: @escaping ([Ebook]?) -> Void) {
        currentGoogleBooksDataTask?.cancel()
//        currentGoogleBooksDataTask = nil
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(APIConstants.GoogleBooksBaseURL)q=\(query)&key=\(APIConstants.GoogleBooksAPI_KEY)") else { return }
        
        currentGoogleBooksDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain as String && error.code == -1020 {
                    print("\n\n\n GOOGLE BOOKS SEARCH WITH NO INTERNET CONNECTION")
                } else {
                    print("\n\n\n GOOGLE BOOKS SEARCH SOME ERROR")
                }
               return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                do {
                    let results = try JSONDecoder().decode(GoogleBooksSearchResponse.self, from: data)
                    completion(results.items)
                } catch {
                    completion(nil)
                }
            }
        }
        currentGoogleBooksDataTask?.resume()
    }
    
    private func fetchAudiobooks(with query: String, completion: @escaping ([Audiobook]?) -> Void) {
        currentITunesDataTask?.cancel()
//        currentITunesDataTask = nil
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        guard let url = URL(string: "http://itunes.apple.com/search?term=\(encodedQuery)&entity=audiobook&limit=10") else { return }

        currentITunesDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
           
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain as String && error.code == -1020 {
                    print("\n\n\n GOOGLE BOOKS SEARCH WITH NO INTERNET CONNECTION")
                } else {
                    print("\n\n\n GOOGLE BOOKS SEARCH SOME ERROR")
                }
               return
            }
             
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data  {
                do {
                    let results = try JSONDecoder().decode(ITunesSearchResponse.self, from: data)
                    #warning("check if results.items is empty and pass corresponding error to completion")
                    completion(results.results)
                } catch {
                    completion(nil)
                }
            }
        }
        currentITunesDataTask?.resume()
    }
    
    func fetchBooks(withQuery query: String, completion: @escaping ([Book]) -> Void) {
        let dataTaskGroup = DispatchGroup()
        
        var allFetchedBooks = [Book]()
        
        dataTaskGroup.enter()
        fetchEbooks(with: query) { ebooks in
            let books = Book.createBooksFromEbooks(ebooks)
            allFetchedBooks += books
            print("Google books data task COMPLETED")
            dataTaskGroup.leave()
        }
        
        dataTaskGroup.enter()
        fetchAudiobooks(with: query) { audiobooks in
            let books = Book.createBooksFromAudiobooks(audiobooks)
            allFetchedBooks += books
            print("iTunes data task COMPLETED")
            dataTaskGroup.leave()
        }
        
        dataTaskGroup.notify(queue: DispatchQueue.main) {
            print("dataTaskGroup notified and performing completion")
            completion(allFetchedBooks)
        }
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
