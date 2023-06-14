//
//  PersistedStoryteller+CoreDataClass.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/6/23.
//
//

import Foundation
import CoreData

@objc(PersistedStoryteller)
public class PersistedStoryteller: NSManagedObject {

    func transformToStoryteller() -> Storyteller {
        let persistedStoryteller = self
        let kind = StorytellerKind.createCaseFrom(rawValueString: persistedStoryteller.titleKind)
        print("kind of storyteller is \(kind)")
        let storyteller = Storyteller(storytellerKind: kind, name: persistedStoryteller.name, numberOfFollowers: Int(persistedStoryteller.numberOfFollowers))
        return storyteller
    }
}
