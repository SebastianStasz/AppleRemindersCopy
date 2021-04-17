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
   case all
   case today
   case flagged
   case scheduled
   case assignedToMe
   
   var predicate: NSPredicate? {
      switch self {
      case .today:
         let dateRange = DateManager.getTodayDateRange()
         let fromPredicate = NSPredicate(format: "%@ >= %@", Date() as NSDate, dateRange.dateFrom as NSDate)
         let toPredicate = NSPredicate(format: "%@ < %@", Date() as NSDate, dateRange.dateTo as NSDate)
         let isCompleted = NSPredicate(format: "isCompleted == NO")
         let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, isCompleted])
         return predicate
      case .flagged:
         return NSPredicate(format: "isCompleted == NO AND isFlagged == YES")
      case .scheduled:
         return NSPredicate(format: "isCompleted == NO AND date != NULL")
      default:
         return NSPredicate(format: "isCompleted == NO")
      }
   }
   
   var view: AnyView {
      switch self {
      case .all:
         return AnyView(RemindersAll())
      case .scheduled:
         return AnyView(RemindersScheduled())
      case .flagged:
         return AnyView(RemincerListWithEnvironment())
      case .today:
         return AnyView(RemincerListWithEnvironment())
      case .assignedToMe:
         return AnyView(RemindersAll()) // Temporary
      }
   }
   
   var showListName: Bool {
      switch self {
      case .all: return false
      default: return true
      }
   }
   
   var isBottomBarHidden: Bool {
      switch self {
      case .today: return false
      case .flagged: return false
      default: return true
      }
   }
}
