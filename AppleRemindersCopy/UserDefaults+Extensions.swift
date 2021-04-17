//
//  UserDefaults+Extensions.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 03/04/2021.
//

import Foundation

extension UserDefaults {
   
   enum Keys: String, CaseIterable {
      case reminderCards
   }
   
   func hardReset() {
         Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
     }
}
