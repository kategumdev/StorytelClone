//
//  PersistedStoryteller+CoreDataProperties.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/6/23.
//
//

import Foundation
import CoreData


extension PersistedStoryteller {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedStoryteller> {
        return NSFetchRequest<PersistedStoryteller>(entityName: "PersistedStoryteller")
    }

    @NSManaged public var titleKind: String
    @NSManaged public var numberOfFollowers: Int16
    @NSManaged public var name: String

}

extension PersistedStoryteller : Identifiable {

}
