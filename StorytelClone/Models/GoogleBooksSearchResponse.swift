//
//  GoogleBooksSearchResponse.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import UIKit

struct GoogleBooksSearchResponse: Decodable {
    private let fetchedBooks: [Ebook]
    
    enum CodingKeys: String, CodingKey {
        case fetchedBooks = "items"
    }
}

extension GoogleBooksSearchResponse: SearchResponse {
    var books: [Book] {
        return Book.createBooksFromEbooks(fetchedBooks)
    }
}

struct Ebook: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let printedPageCount: Int?
    let categories: [String]?
    let averageRating: Double?
    let ratingsCount: Int?
    let imageLinks: [String : String]?
    let language: String?
}

enum ImageLink: String {
    case smallThumbnail
    case thumbnail
    case small
    case medium
    case large
    case extraLarge
}
