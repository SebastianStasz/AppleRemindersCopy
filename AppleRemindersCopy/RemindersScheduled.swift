//
//  RemindersScheduled.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import SwiftUI

struct RemindersScheduled: View {
   @EnvironmentObject private var remindersVM: RemindersVM
   
   var body: some View {
      List {
         if remindersVM.isEmpty { NoRemindersMessage() }
         else {
            ForEach(filterByDay(), id: \.0) { list in
               Section(header: ListHeader(title: list.0, color: .white)) {
                  ForEach(list.1) { reminder in
                     ReminderRow(reminder: reminder).environmentObject(remindersVM)
                  }
                  .onDelete(perform: remindersVM.delete)
               }
               .textCase(nil)
            }
         }
      }
   }
   
   private func filterByDay() -> [(String, [ReminderEntity])] {
      var result: [(String, [ReminderEntity])] = []

      var subArray: [ReminderEntity] = []
      var days = -1
      var date = ""

      for reminder in remindersVM.reminders {
         let reminderDays = DateManager.getDaysFromNow(to: reminder.date!)
         if days == -1 {
            days = reminderDays
            date = DateManager.date.string(from: reminder.date!)
            subArray.append(reminder)
         } else {
            if reminderDays == days {
               subArray.append(reminder)
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
