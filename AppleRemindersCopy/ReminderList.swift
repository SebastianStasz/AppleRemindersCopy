//
//  ReminderList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 16/04/2021.
//

import SwiftUI

// MARK: -- Main ReminderList

struct ReminderList: View {
   @State private var selectedReminder: ReminderEntity?
   let reminders: [ReminderEntity]
   
   var body: some View {
      ForEach(reminders) { reminder in
         ReminderRow(reminder: reminder, selectedReminder: $selectedReminder)
      }
      .onDelete(perform: delete)
   }
   
   private func delete(at indexSet: IndexSet) {
      let index = indexSet.map { $0 }.first!
      let reminder = reminders[index]
      CoreDataManager.shared.delete(reminder)
   }
}

// MARK: -- ReminderList embeded in List

struct ReminderListWithList: View {
   let reminders: [ReminderEntity]
   
   var body: some View {
      if reminders.isEmpty { NoRemindersMessage() }
      else {
         List {
            ReminderList(reminders: reminders)
         }
      }
   }
}

// MARK: -- ReminerList by Fetching reminders

struct ReminderListFetch: View {
   @FetchRequest private var reminders: FetchedResults<ReminderEntity>
   
   init(list: ReminderListEntity) {
      _reminders = FetchRequest(entity: ReminderEntity.entity(),
                                sortDescriptors: [ReminderEntity.sortByCreatedDate],
                                predicate: NSPredicate(format: "list == %@", list))
   }
   
   var body: some View {
      ReminderListWithList(reminders: reminders.map{$0})
   }
}
