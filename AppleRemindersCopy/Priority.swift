//
//  Priority.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//

import Foundation

@objc public enum Priority: Int, CaseIterable {
   case none
   case low
   case medium
   case high
   
   var name: String {
      switch self {
      case .none:
         return "None"
      case .low:
         return "Low"
      case .medium:
         return "Medium"
      case .high:
         return "High"
      }
   }
}

extension Priority: Identifiable {
   public var id: Int { rawValue }
}
