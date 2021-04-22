//
//  DeleteGroupActionSheet.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 21/04/2021.
//

import SwiftUI

struct DeleteGroupActionSheet: Identifiable {
   let reminderGroupsVM: ReminderListListVM
   let group: ReminderGroupEntity
   let id = UUID()
   
   var sheet: ActionSheet {
      ActionSheet(title: title, message: message, buttons: [
         
         .default(Text("Delete Group Only")) {
            reminderGroupsVM.delete(group, withLists: false)
         },
         
         .destructive(Text("Delete Group and Lists")) {
            reminderGroupsVM.delete(group, withLists: true)
         },
         
         .cancel()
      ])
   }

   private var title: Text { Text("Delete \"\(group.name)\"") }
   private let message = Text("Choose whether to keep or delete this group's lists and their reminders.")
}
