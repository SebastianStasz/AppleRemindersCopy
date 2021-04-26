//
//  ReminderRowInfo.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 24/04/2021.
//

import SwiftUI

struct ReminderRowInfo: View {
   @EnvironmentObject private var reminderVM: ReminderRowVM
   @EnvironmentObject var reminder: ReminderEntity
   let dateOptions: DateDescriptionView.Options
   let isListNameShown: Bool
   
   var body: some View {
      VStack(alignment: .leading, spacing: 0) {
         ReminderRowDate(dateOptions: dateOptions, isListNameShown: isListNameShown)
         
         if let notes = reminder.notes { Text(notes) }
         
         if reminderVM.url != nil { urlLinkButton }
         
      }
      .foregroundColor(.gray)
      .font(Font.subheadline.leading(.tight))
      .opacity(0.9)
   }
   
   private var urlLinkButton: some View {
      Button(action: {}) {
         Link(destination: reminderVM.url!) {
            Text(reminder.url!)
               .underline()
               .foregroundColor(.systemBlue)
         }
         .contentShape(Rectangle())
      }
   }
}
