//
//  GoogleBooksSearchResponse.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 26/5/23.
//

import Foundation

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
//    let imageLinks: [ImageLink]
    let imageLinks: [String : String]?
    let language: String?
}

enum ImageLink: String {
    case smallThumbnail
    case thumbnail
}


//struct ImageLink: Codable {
//    let smallThumbnail: String?
//    let thumbnail: String?
//    let small: String?
//    let medium: String?
//    let large: String?
//    let extraLarge: String?
//}



//struct GoogleBooksSearchResponse: Codable {
//    let items: [VideoElement]
//}
//
//struct VideoElement: Codable {
//    let id: IdVideoElement
//}
//
//struct IdVideoElement: Codable {
//    let kind: String
//    let videoId: String
//}
