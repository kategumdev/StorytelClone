//
//  Tag.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/3/23.
//

import Foundation

struct Tag: Title {
    let tagTitle: String
    var titleKind: TitleKind = .tag
    
    init(tagTitle: String) {
        self.tagTitle = tagTitle
    }
    
    static let tags = [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10]
    static let fourTags = [tag1, tag2, tag3, tag4]
    static let twoTags = [tag1, tag2]
    static let tagsBookVC = [Tag(tagTitle: "Grabado en español ibérico"), Tag(tagTitle: "De 15 años en adelante"), Tag(tagTitle: "Magia"), Tag(tagTitle: "Fantasía juvenil"), Tag(tagTitle: "Fantasía"), Tag(tagTitle: "Romántica YA"), Tag(tagTitle: "Emocionante")]
    static let manyTags = tags + tagsBookVC + [Tag(tagTitle: "Shadow and Bone"), Tag(tagTitle: "Vikings"), Tag(tagTitle: "Umbrella academy"), Tag(tagTitle: "Stranger things")]
//    Tag(tagTitle: "Crecimiento personal y aventura fantastica")
    
    // Hardcoded model objects for tags
    static let tag1 = Tag(tagTitle: "Novelas históricas")
    
    static let tag2 = Tag(tagTitle: "Acción y aventura")
    
    static let tag3 = Tag(tagTitle: "Aventura")
    
    static let tag4 = Tag(tagTitle: "Meditación")
    
    static let tag5 = Tag(tagTitle: "Biografías históricas")
    
    static let tag6 = Tag(tagTitle: "Science environment")
    
    static let tag7 = Tag(tagTitle: "Science")
    
    static let tag8 = Tag(tagTitle: "Nature")
    
    static let tag9 = Tag(tagTitle: "World Cultures")
    
    static let tag10 = Tag(tagTitle: "Fantasy world")

}
