//
//  ReminerList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

class RemindersVM: ObservableObject {
   @Published var selectedReminder: Reminder? = nil
   let showListName: Bool

   init(showListName: Bool) {
      self.showListName = showListName
   }
}

struct Reminders: View {
   @Environment(\.managedObjectContext) private var context
   @StateObject private var remindersVM: RemindersVM
   private let reminders: [Reminder]
   
   var body: some View {
      if !reminders.isEmpty { list }
      else { Text("No Reminders").opacity(0.2) }
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
   
   init(reminders: [Reminder], showListName: Bool = true) {
      self.reminders = reminders
      let remindersVM = RemindersVM(showListName: showListName)
      _remindersVM = StateObject(wrappedValue: remindersVM)
   }
}


// MARK: -- Preview

struct Reminders_Previews: PreviewProvider {
   static var previews: some View {
      ScrollView {
         VStack(alignment: .leading) {
            Reminders(reminders: [], showListName: true)
         }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
   }
}

struct NoRemindersMessage: View {
   var body: some View {
      Text("No Reminders")
         .frame(maxWidth: .infinity, alignment: .leading)
         .opacity(0.2)
   }
}
