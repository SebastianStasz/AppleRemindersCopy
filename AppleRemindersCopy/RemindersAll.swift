//
//  RemindersSortedByList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import SwiftUI

struct RemindersAll: View {
   @EnvironmentObject private var sheet: SheetController
   
   @FetchRequest(entity: ReminderListEntity.entity(),
                 sortDescriptors: [ReminderListEntity.sortByName]
   ) private var reminderLists: FetchedResults<ReminderListEntity>
   
   var count: Int {
      Int(reminderLists.map { $0.reminders.count }.reduce(0, +))
   }
   
   var body: some View {
      if reminderLists.isEmpty { NoRemindersMessage() }
      else { list }
   }
   
   private var list: some View {
      List {
         ForEach(reminderLists) { list in
            Section(header: ListHeader(list: list)) {
               FinalReminderList(reminders: list.reminders)
               Button { showReminderCreatingSheet(list: list) } label: {
                  addReminderButtonLabel
               }
            }
         }
         .textCase(nil)
      }
   }
   
   private var addReminderButtonLabel: some View {
      Label("Create Reminder", systemImage: "plus.circle.fill")
         .font(.title)
         .foregroundColor(.gray)
         .opacity(0.5)
         .labelStyle(IconOnlyLabelStyle())
         .padding(.vertical, 5)
   }
   
   private func showReminderCreatingSheet(list: ReminderListEntity) {
      sheet.activeSheet = .addReminder(options: .withList(list))
   }
}
