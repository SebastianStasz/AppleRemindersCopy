//
//  CoreData+Extensions.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 06/04/2021.
//

import Foundation

extension ReminderList {
   var name: String {
      get { name_! }
      set { name_ = newValue }
   }
   
   var reminders: [Reminder] {
      get {
         let set = reminders_ as? Set<Reminder> ?? []
         return set.sorted { $0.name < $1.name }
      }
   }
}

extension ReminderGroup {
   var name: String {
      get { name_! }
      set { name_ = newValue }
   }
   
   var list: [ReminderList] {
      get {
         let set = list_ as? Set<ReminderList> ?? []
         return set.sorted { $0.name > $1.name }
      }
   }
}

extension Reminder {
   var name: String {
      get { name_! }
      set { name_ = newValue }
   }
}
