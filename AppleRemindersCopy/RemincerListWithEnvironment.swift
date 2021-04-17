//
//  RemincerListWithEnvironment.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 16/04/2021.
//

import SwiftUI

struct RemincerListWithEnvironment: View {
   @EnvironmentObject private var remindersVM: RemindersVM
   
   var body: some View {
      List {
         ForEach(remindersVM.reminders) { reminder in
            ReminderRow(reminder: reminder).environmentObject(remindersVM)
         }
         .onDelete(perform: remindersVM.delete)
      }
   }
}
