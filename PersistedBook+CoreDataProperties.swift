//
//  PersistedBook+CoreDataProperties.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/6/23.
//
//

import Foundation
import CoreData


extension PersistedBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedBook> {
        return NSFetchRequest<PersistedBook>(entityName: "PersistedBook")
    }

    @NSManaged public var audioUrlString: String?
    @NSManaged public var category: String
    @NSManaged public var coverImage: Data?
    @NSManaged public var date: Date?
    @NSManaged public var duration: String
    @NSManaged public var id: String
    @NSManaged public var imageURLString: String?
    @NSManaged public var isDownloaded: Bool
    @NSManaged public var isFinished: Bool
    @NSManaged public var language: String
    @NSManaged public var overview: String
    @NSManaged public var publisher: String
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String
    @NSManaged public var reviewsNumber: Int16
    @NSManaged public var series: String?
    @NSManaged public var seriesPart: Int16
    @NSManaged public var tags: NSArray
    @NSManaged public var title: String
    @NSManaged public var titleKind: String
    @NSManaged public var translators: NSArray?
    @NSManaged public var authors: NSOrderedSet?
    @NSManaged public var narrators: NSOrderedSet?

}

// MARK: Generated accessors for authors
extension PersistedBook {

    @objc(insertObject:inAuthorsAtIndex:)
    @NSManaged public func insertIntoAuthors(_ value: PersistedStoryteller, at idx: Int)

    @objc(removeObjectFromAuthorsAtIndex:)
    @NSManaged public func removeFromAuthors(at idx: Int)

    @objc(insertAuthors:atIndexes:)
    @NSManaged public func insertIntoAuthors(_ values: [PersistedStoryteller], at indexes: NSIndexSet)

    @objc(removeAuthorsAtIndexes:)
    @NSManaged public func removeFromAuthors(at indexes: NSIndexSet)

    @objc(replaceObjectInAuthorsAtIndex:withObject:)
    @NSManaged public func replaceAuthors(at idx: Int, with value: PersistedStoryteller)

    @objc(replaceAuthorsAtIndexes:withAuthors:)
    @NSManaged public func replaceAuthors(at indexes: NSIndexSet, with values: [PersistedStoryteller])

    @objc(addAuthorsObject:)
    @NSManaged public func addToAuthors(_ value: PersistedStoryteller)

    @objc(removeAuthorsObject:)
    @NSManaged public func removeFromAuthors(_ value: PersistedStoryteller)

    @objc(addAuthors:)
    @NSManaged public func addToAuthors(_ values: NSOrderedSet)

    @objc(removeAuthors:)
    @NSManaged public func removeFromAuthors(_ values: NSOrderedSet)

}

// MARK: Generated accessors for narrators
extension PersistedBook {

    @objc(insertObject:inNarratorsAtIndex:)
    @NSManaged public func insertIntoNarrators(_ value: PersistedStoryteller, at idx: Int)

    @objc(removeObjectFromNarratorsAtIndex:)
    @NSManaged public func removeFromNarrators(at idx: Int)

    @objc(insertNarrators:atIndexes:)
    @NSManaged public func insertIntoNarrators(_ values: [PersistedStoryteller], at indexes: NSIndexSet)

    @objc(removeNarratorsAtIndexes:)
    @NSManaged public func removeFromNarrators(at indexes: NSIndexSet)

    @objc(replaceObjectInNarratorsAtIndex:withObject:)
    @NSManaged public func replaceNarrators(at idx: Int, with value: PersistedStoryteller)

    @objc(replaceNarratorsAtIndexes:withNarrators:)
    @NSManaged public func replaceNarrators(at indexes: NSIndexSet, with values: [PersistedStoryteller])

    @objc(addNarratorsObject:)
    @NSManaged public func addToNarrators(_ value: PersistedStoryteller)

    @objc(removeNarratorsObject:)
    @NSManaged public func removeFromNarrators(_ value: PersistedStoryteller)

    @objc(addNarrators:)
    @NSManaged public func addToNarrators(_ values: NSOrderedSet)

    @objc(removeNarrators:)
    @NSManaged public func removeFromNarrators(_ values: NSOrderedSet)

}

extension PersistedBook : Identifiable {

}
