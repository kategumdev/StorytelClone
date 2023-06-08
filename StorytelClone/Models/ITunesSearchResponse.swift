//
//  ITunesSearchResponse.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 30/5/23.
//

import Foundation

struct ITunesSearchResponse: Codable {
    var resultCount = 0
    var results = [Audiobook]()
}

struct Audiobook: Codable {
    var collectionId: Int
    var bookName: String
    var authorName: String
    var description: String?
    var genre: String?
    var smallImageUrl: String?
    var largeImageUrl: String?
    var audioUrlString: String?
    var releaseDate: String?
    
    var id: String {
        return "\(collectionId)"
    }
    
    enum CodingKeys: String, CodingKey {
        case bookName = "collectionName"
        case authorName = "artistName"
        case genre = "primaryGenreName"
        case smallImageUrl = "artworkUrl60"
        case largeImageUrl = "artworkUrl100"
        case audioUrlString = "previewUrl"
        case description, releaseDate, collectionId
    }
    
}


//http://itunes.apple.com/search?term=gaiman&entity=audiobook
