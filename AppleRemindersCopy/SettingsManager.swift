//
//  SettingsManager.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 25/04/2021.
//

import Foundation

protocol SettingsProtocol {
   var defaultTriggerTime: [String: Int] { get }
}

struct SettingsManager: SettingsProtocol {
   
   var defaultTriggerTime: [String: Int] {
      var settings = UserDefaults.standard.array(forKey: UserDefaults.Keys.defaultTriggerTime.rawValue) as? [Int]

      if settings == nil {
         UserDefaults.standard.setValue([9, 0], forKey: UserDefaults.Keys.defaultTriggerTime.rawValue)
         settings = UserDefaults.standard.array(forKey: UserDefaults.Keys.defaultTriggerTime.rawValue) as? [Int]
      }

      return ["hour": settings![0], "minute": settings![1]]
   }
}
