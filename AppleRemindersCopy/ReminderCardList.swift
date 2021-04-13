//
//  ReminderCardList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//

import CoreData
import Foundation
import SwiftUI

enum ReminderCardList: Int, Codable {
   case today
   case scheduled
   case flagged
   case all
   
   var predicate: NSPredicate? {
      switch self {
      case .today:
         let dateRange = DateHelper.getTodayDateRange()
         let fromPredicate = NSPredicate(format: "%@ >= %@", Date() as NSDate, dateRange.dateFrom as NSDate)
         let toPredicate = NSPredicate(format: "%@ < %@", Date() as NSDate, dateRange.dateTo as NSDate)
         let isCompleted = NSPredicate(format: "isCompleted == NO")
         let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, isCompleted])
         return predicate
      case .flagged:
         return NSPredicate(format: "isCompleted == NO AND isFlagged == YES")
      default:
         return NSPredicate(format: "isCompleted == NO")
      }
   }
   
   var accentColor: Color {
      switch self {
      case .today: return .systemBlue
      case .scheduled: return .systemRed
      case .all: return .systemGray
      case .flagged: return .systemOrange
      }
   }
   
   var isBottomBarPresented: Bool {
      switch self {
      case .today: return true
      case .flagged: return true
      default: return false
      }
   }
}
