//
//  RemindersSortedByDate.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import SwiftUI

struct RemindersSortedByDay: View {
   @Environment(\.managedObjectContext) private var context
   let reminders: [Reminder]
   
   var body: some View {
      if !remindersByDay.isEmpty { list }
      else { NoRemindersMessage() }
   }
   
   private var list: some View {
      ForEach(remindersByDay, id: \.0) { list in
         Section(header: ListHeader(title: list.0, color: .white)) {
            Reminders(reminders: list.1, showListName: true)
         }
         .textCase(nil)
      }
   }
}

// MARK: -- Sorting Logic

extension RemindersSortedByDay {
   var remindersByDay: [(String, [Reminder])] {
      var result: [(String, [Reminder])] = []

      var subArray: [Reminder] = []
      var days = -1
      var date = ""

      for reminder in reminders {
         let reminderDays = DateHelper.getDaysFromNow(to: reminder.date!)
         if days == -1 {
            days = reminderDays
            date = DateHelper.date.string(from: reminder.date!)
            subArray.append(reminder)
         } else {
            if reminderDays == days {
               subArray.append(reminder)
            } else {
               result.append((date, subArray))
               subArray = []
               days = reminderDays
               date = DateHelper.date.string(from: reminder.date!)
               subArray.append(reminder)
            }
         }
      }
      return result
   }
}
