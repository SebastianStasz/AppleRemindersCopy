//
//  ReminderFormComponents.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 10/04/2021.
//

import SwiftUI

struct ReminderFormPrioritySelection: View {
   @EnvironmentObject private var form: ReminderFormVM
   
   var body: some View {
      Section {
         Toggle(isOn: $form.form.isFlagged) {
            ReminderFormLabel.flag(nil).view
         }
         Picker(selection: $form.form.priority,
                label: ReminderFormLabel.priority.view)
         {
            ForEach(Priority.allCases) { Text($0.name).tag($0) }
         }
      }
   }
}


struct ReminderFormLocationSelection: View {
   @EnvironmentObject private var form: ReminderFormVM
   
   var body: some View {
      Section {
         Toggle(isOn: $form.isLocationSelected) {
            ReminderFormLabel.location(nil).view
         }
      }
   }
}


struct ReminderFormMessagingSelection: View {
   @EnvironmentObject private var form: ReminderFormVM
   
   var body: some View {
      Section {
         Toggle(isOn: $form.isMessagingSelected) {
            ReminderFormLabel.messeging(nil).view
         }
         Text(messagingInfo)
            .font(.footnote)
            .opacity(0.5)
      }
   }
   
   private var messagingInfo: String {
      "Selecting this option will show the reminder notification when chatting a person in Messages."
   }
}
