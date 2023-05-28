//
//  GoogleBooksSearchResponse.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import UIKit

struct GoogleBooksSearchResponse: Codable {
    let items: [BookModel]
}

struct BookModel: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
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
