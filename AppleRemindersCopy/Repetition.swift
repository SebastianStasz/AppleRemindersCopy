//
//  Repetition.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//

import Foundation

@objc public enum Repetition: Int, CaseIterable {
   case never
   case daily
   case weekly
   case fortnightly
   case monthly
   case every3Months
   case every6Months
   case yearly
   
   var name: String {
      switch self {
      
      case .never:
         return "Never"
      case .daily:
         return "Daily"
      case .weekly:
         return "Weekly"
      case .fortnightly:
         return "Fortnightly"
      case .monthly:
         return "Monthly"
      case .every3Months:
         return "Every 3 Months"
      case .every6Months:
         return "Every 6 Months"
      case .yearly:
         return "Yearly"
      }
   }
}

extension Repetition: Identifiable {
   public var id: Int { rawValue }
}

enum EndRepetition: Int, CaseIterable {
   case never
   case date
   
   var name: String {
      switch self {
      case .never:
         return "Never"
      case .date:
         return "End Repeat Date"
      }
   }
}

extension EndRepetition: Identifiable {
   var id: Int { rawValue }
}
