//
//  SecureUnarchiveTransformer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/6/23.
//

import Foundation

class SecureUnarchiveTransformer: NSSecureUnarchiveFromDataTransformer {
  
  override static var allowedTopLevelClasses: [AnyClass] {
      [NSArray.self, NSString.self]
  }
  
  static func register() {
    let className = String(describing: SecureUnarchiveTransformer.self)
    let name = NSValueTransformerName(className)
    let transformer = SecureUnarchiveTransformer()
    ValueTransformer.setValueTransformer(transformer, forName: name)
  }

}
