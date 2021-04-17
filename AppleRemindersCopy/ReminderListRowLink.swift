//
//  ReminderListRowLink.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 16/04/2021.
//

import SwiftUI

struct ReminderListRowLink: View {
   @Environment(\.editMode) private var editMode
   @StateObject private var remindersVM = RemindersVM()
   let config: RemindersVM.Config
   let list: ReminderListEntity
   
   var body: some View {
      NavigationLink(destination: destination) {
         ReminderListRow(list: list, reminderCount: remindersVM.count)
            .environment(\.editMode, editMode)
      }
      .onAppear { remindersVM.config = config }
   }
   
   private var destination: some View {
      RemincerListWithEnvironment()
         .embedinRemindersView(title: config.title, accentColor: config.accentColor, hideBottomBar: false)
         .environmentObject(remindersVM)
   }
}
