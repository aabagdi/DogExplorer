//
//  Storage.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import Foundation

class Storage: NSObject {
  
  static func archiveStringArray(object : [String]) -> Data {
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
      return data
    } catch {
      fatalError("Can’t encode data: \(error)")
    }
    
  }
  
  static func loadStringArray(data: Data) -> [String] {
    do {
      let allowedClasses = [NSArray.self, NSString.self]
      guard let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses, from:data) as? [String] else {
        return []
      }
      return array
    } catch {
      fatalError("loadStringArray - Can't encode data: \(error)")
    }
  }
}
