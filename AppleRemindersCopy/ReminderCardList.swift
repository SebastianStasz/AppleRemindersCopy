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
         let fromPredicate = NSPredicate(format: "date >= %@", dateRange.dateFrom as NSDate)
         let toPredicate = NSPredicate(format: "date < %@", dateRange.dateTo as NSDate)
         let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
         return predicate
         
      case .flagged:
         return ReminderEntity.predicateFlagged
      case .scheduled:
         return ReminderEntity.predicateScheduled
      default:
         return nil
      }
   }
   
   var sortDescriptor: NSSortDescriptor {
      switch self {
      case .scheduled: return ReminderEntity.sortByScheduledDate
      default: return ReminderEntity.sortByCreatedDate
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
