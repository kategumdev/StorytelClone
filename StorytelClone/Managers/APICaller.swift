//
//  APICaller.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import Foundation

struct APIConstants {
    static let GoogleBooksAPI_KEY = "AIzaSyBCtyopfZRlAavL6vF6NxmBhKtEglt7jPM"
    static let GoogleBooksBaseURL = "https://www.googleapis.com/books/v1/volumes?"
}

//enum APIError: Error {
//    case failedToGetData
//}

class APICaller {
    static let shared = APICaller()
    
    func getBooks(with query: String, completion: @escaping (Result<[BookModel], Error>) -> Void) {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(APIConstants.GoogleBooksBaseURL)q=\(query)&key=\(APIConstants.GoogleBooksAPI_KEY)") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(GoogleBooksSearchResponse.self, from: data)

//                let jsonString = try String(contentsOf: url, encoding: .utf8)
//                print("\(jsonString)")

                completion(.success(results.items))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
//    func searchBookWith(isbn: String) {
//        // Remove whitespaces and newlines
//        let cleanedString = isbn.components(separatedBy: .whitespacesAndNewlines).joined()
//
//        // Remove non-numeric characters
//        let filteredString = cleanedString.filter { $0.isNumber }
//        print(filteredString) // Output: "12345678"
//
////        guard let query = isbn.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        let baseUrlString = "https://openlibrary.org/api/books?bibkeys=ISBN:"
//
//        guard let url = URL(string: "\(baseUrlString)\(filteredString)&jscmd=data&format=json") else { return }
////        guard let url = URL(string: "\(baseUrlString)\(filteredString)&jscmd=details&format=json") else { return }
//
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else { return }
//
//            // Assuming you have the JSON data stored in a variable named jsonData
//            let jsonString = String(data: data, encoding: .utf8)
//
//            if let jsonString = jsonString {
//                // Use the jsonString as needed
//                print(jsonString)
//            } else {
//                // Failed to convert JSON data to string
//                print("Failed to convert JSON data to string.")
//            }
//
//        }
//        task.resume()
//    }
    
}

