//
//  ReminderListRowLink.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 16/04/2021.
//

import SwiftUI

struct ReminderListRowLink: View {
   @Environment(\.editMode) private var editMode
   @EnvironmentObject private var sheet: SheetController
   @ObservedObject var list: ReminderListEntity
   
   var body: some View {
      NavigationLink(destination: destination) { reminderRowBody }
   }
   
   private var reminderRowBody: some View {
      HStack(spacing: 16) {

         ReminderListRow(list: list) ; Spacer()
         
         if isEditMode { editButton }
         else { remindersCountText }
      }
   }
   
   private var destination: some View {
      ReminderListFetch(list: list)
         .embedinRemindersView(list: list, title: list.name, accentColor: list.color, hideBottomBar: false)
   }

   private var editButton: some View {
      Image(systemName: "info.circle")
         .font(.title2)
         .foregroundColor(.systemBlue)
         .onTapGesture { sheet.activeSheet = .addList(list, nil) }
   }
   
   private var remindersCountText: some View {
      Text(String(list.reminders.count)).opacity(0.4)
   }
   
   private var isEditMode: Bool {
      return editMode?.wrappedValue == .active
   }
}
