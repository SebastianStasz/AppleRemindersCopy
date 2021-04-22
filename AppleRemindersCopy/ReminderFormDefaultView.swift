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
         Group {
            if let date = form.dateDescription {
               form.timeDescription == nil
                  ? Text(date)
                  : Text("\(date) at \(form.timeDescription!)")
            }
         }
         .font(.caption2)
         .opacity(0.5)
      }
   }
}
