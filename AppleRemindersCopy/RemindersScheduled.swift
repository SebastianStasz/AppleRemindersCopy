//
//  RemindersScheduled.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import SwiftUI

struct RemindersScheduled: View {
   private let coreDataManager = CoreDataManager.shared
   let reminders: FetchedResults<ReminderEntity>
   @State private var selectedReminder: ReminderEntity?
   
   var body: some View {
      if reminders.isEmpty { NoRemindersMessage() }
      else { list }
   }
   
   private var list: some View {
      List {
         ForEach(filteredByDay, id: \.0) { list in
            Section(header: ListHeader(title: list.0, color: .white)) {
               ForEach(list.1) { reminder in
                  ReminderRow(reminder: reminder, selectedReminder: $selectedReminder)
               }
               .onDelete { delete(at: $0, from: list.1) }
            }
            .textCase(nil)
         }
      }.animation(.easeInOut)
   }
   
   private func delete(at indexSet: IndexSet, from list: [ReminderEntity]) {
      let index = indexSet.map { $0 }.first!
      let reminder = reminders.first { $0 == list[index] }!
      coreDataManager.delete(reminder)
   }
   
   private var filteredByDay: [(String, [ReminderEntity])] {
      let all = reminders.count - 1
      var result: [(String, [ReminderEntity])] = []

      var subArray: [ReminderEntity] = []
      var days: Int? = nil
      var date = ""

      _ = reminders.enumerated().map { index, reminder in
         let reminderDays = DateManager.getDaysFromNow(to: reminder.date!)
         if days == nil {
            days = reminderDays
            date = DateManager.date.string(from: reminder.date!)
            subArray.append(reminder)
         } else {
            if reminderDays == days {
               subArray.append(reminder)
               if index == all { result.append((date, subArray)) }
            } else {
               result.append((date, subArray))
               subArray = []
               days = reminderDays
               date = DateManager.date.string(from: reminder.date!)
               subArray.append(reminder)
            }
         }
      }

      return result
   }
}
