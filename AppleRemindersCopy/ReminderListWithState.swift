//
//  ReminderListWithState.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 16/04/2021.
//

import SwiftUI

struct ReminderListWithState: View {
   @StateObject private var remindersVM = RemindersVM()
   let config: RemindersVM.Config
   
   var body: some View {
      ForEach(remindersVM.reminders) { reminder in
         ReminderRow(reminder: reminder).environmentObject(remindersVM)
      }
      .onDelete(perform: remindersVM.delete)
      
      VStack {}.onAppear { remindersVM.config = config }
   }
}
