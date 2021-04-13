//
//  RemindersByFetch.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import SwiftUI

struct RemindersByFetch: View {
   @Environment(\.managedObjectContext) private var context
   @FetchRequest private var remindersData: FetchedResults<Reminder>
   @StateObject private var remindersVM: RemindersVM
   
   init(predicate: NSPredicate?, showListName: Bool = true) {
      let remindersVM = RemindersVM(showListName: showListName)
      _remindersVM = StateObject(wrappedValue: remindersVM)
      _remindersData = FetchRequest(entity: Reminder.entity(), sortDescriptors: [], predicate: predicate)
   }
   
   private var reminders: [Reminder] {
      remindersData.map { $0 }
   }
   
   var body: some View {
      if reminders.isEmpty { NoRemindersMessage() }
      else { list}
   }
   
   private var list: some View {
      ForEach(reminders) { reminder in
         ReminderRow(reminder: reminder)
      }
      .onDelete(perform: delete)
      .environmentObject(remindersVM)
   }
   
   private func delete(at indexSet: IndexSet) {
      let index = indexSet.map{$0}.first!
      context.delete(reminders[index])
   }
}
