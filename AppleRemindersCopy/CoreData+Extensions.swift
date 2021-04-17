//
//  CoreData+Extensions.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 06/04/2021.
//

import Foundation
import SwiftUI

extension ReminderListEntity {
   static let sortByName = NSSortDescriptor(key: "name_", ascending: true)
   
   var name: String {
      get { name_ ?? "" }
      set { name_ = newValue }
   }
   
   var color: Color {
      color_.color
   }
   
   var reminders: [ReminderEntity] {
      get {
         let set = reminders_ as? Set<ReminderEntity> ?? []
         return set.sorted { $0.name < $1.name }
      }
   }
}

extension ReminderGroupEntity {
   static let sortByName = NSSortDescriptor(key: "name_", ascending: true)
   static let filterWithoutGroups = NSPredicate(format: "group == NULL")
   
   var name: String {
      get { name_! }
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
   static let sortByDate = NSSortDescriptor(key: "date", ascending: true)
   
   var name: String {
      get { name_ ?? ""}
      set { name_ = newValue }
   }
   
   var listColor: Color {
      list.color_.color
   }
}
