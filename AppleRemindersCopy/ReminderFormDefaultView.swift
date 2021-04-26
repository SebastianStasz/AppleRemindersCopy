//
//  ReminderFormDefaultView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 18/04/2021.
//

import SwiftUI

struct ReminderFormDefaultView: View {
   @EnvironmentObject private var form: ReminderFormVM
   let saveChanges: () -> Void
   
   var body: some View {
      Group {
         ReminderFormNotes()
         
         Section {
            NavigationLink(destination: ReminderFormDetailView(saveChanges: saveChanges)) {
               detailsLinkLabel
            }
         }
      }
   }
   
   private var detailsLinkLabel: some View {
      VStack(alignment: .leading) {
         Text("Details")
         if form.form.isDateSelected {
            DateDescriptionView(date: form.form.date, options: dateOptions)
               .font(.footnote).opacity(0.7)
         }
      }
   }
   
   private var dateOptions: DateDescriptionView.Options {
      return form.form.isTimeSelected ? .dateAndTime : .date
   }
}
