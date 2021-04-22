//
//  UserDefaults+Extensions.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 03/04/2021.
//

import Foundation

extension UserDefaults {
   
//   static let ungroupedGroupId = UserDefaults.standard.string(forKey: UserDefaults.Keys.ungroupedGroupId.rawValue)
   
   static var ungroupedGroupId: String {
      let id = UserDefaults.standard.string(forKey: UserDefaults.Keys.ungroupedGroupId.rawValue)
      
      guard let validId = id else {
         UserDefaults.standard.set(UUID().uuidString, forKey: UserDefaults.Keys.ungroupedGroupId.rawValue)
         return UserDefaults.standard.string(forKey: UserDefaults.Keys.ungroupedGroupId.rawValue)!
      }
      return validId
   }
   
   enum Keys: String, CaseIterable {
      case reminderCards
      case ungroupedGroupId
   }
   
   func hardReset() {
         Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
     }
}
