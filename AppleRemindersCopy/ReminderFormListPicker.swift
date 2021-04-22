//
//  ReminderFormListPicker.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 18/04/2021.
//

import SwiftUI

struct ReminderFormListPicker: View {
   @EnvironmentObject private var sheet: SheetController
   @EnvironmentObject private var form: ReminderFormVM
   let reminderLists: [ReminderListEntity]
   
   var body: some View {
      Section {
         if reminderLists.isEmpty { createListButton }
         else { reminderListPicker }
      }
   }
   
   private var reminderListPicker: some View {
      Picker("List", selection: $form.form.list) {
         ForEach(reminderLists) {
            ReminderListRow(list: $0).tag(Optional($0))
         }
      }
   }
   
   private var createListButton: some View {
      Group {
         Button("Create List") {
            sheet.activeSheet = .addList(nil, .addReminder(options: .none))
         }
         Text("You need to create reminder list first.")
            .font(.footnote).opacity(0.5)
      }
   }
}
