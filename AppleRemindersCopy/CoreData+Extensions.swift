//
//  CoreData+Extensions.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 06/04/2021.
//

import CoreData
import Foundation
import SwiftUI

extension ReminderListEntity {
   static let sortByName = NSSortDescriptor(key: "name_", ascending: true)
   static let sortByCreatedDate = NSSortDescriptor(key: "createdDate_", ascending: true)
   
   var name: String {
      get { name_ ?? "" }
      set { name_ = newValue }
   }
   
   var reminders: [ReminderEntity] {
      get {
         let set = reminders_ as? Set<ReminderEntity> ?? []
         return set.sorted { $0.createdDate < $1.createdDate }
      }
   }
   
   var image: String { icon.sfSymbol }
   var color: Color { color_.color }
}

extension ReminderGroupEntity {
   static let sortByName = NSSortDescriptor(key: "name_", ascending: true)
   
   var name: String {
      get { name_ ?? "I should not be here" }
      set { name_ = newValue }
   }
   
   var list: [ReminderListEntity] {
      get {
         let set = list_ as? Set<ReminderListEntity> ?? []
         return set.sorted { $0.name > $1.name }
      }
   }
}

extension ReminderEntity {
   static let sortByScheduledDate = NSSortDescriptor(key: "date", ascending: true)
   static let sortByCreatedDate = NSSortDescriptor(key: "createdDate_", ascending: true)
   
   static let predicateFlagged = NSPredicate(format: "isFlagged == YES")
   static let predicateScheduled = NSPredicate(format: "date != NULL")
   static var predicateToday: NSPredicate {
      let dateRange = DateManager.getDateRange(for: Date())
      let predicate = NSPredicate(format: "date < %@", dateRange.dateEnd as NSDate)
      return predicate
   }
   
   // MARK: -- Access
   
   var id_: UUID {
      get { id! }
      set { id = newValue }
   }
   
   var name: String {
      get { name_ ?? ""}
      set { name_ = newValue }
   }
   
   var createdDate: Date { createdDate_! }
   var listColor: Color { list.color_.color }
}


