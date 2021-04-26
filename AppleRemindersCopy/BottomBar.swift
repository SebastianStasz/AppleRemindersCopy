//
//  BottomBar.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

struct BottomBar: ViewModifier {
   @EnvironmentObject private var sheet: SheetController
   @EnvironmentObject private var nav: NavigationController
   let isEditMode: Bool
   
   func body(content: Content) -> some View {
      content.toolbar { bottomBarBody }
   }
   
   private var bottomBarBody: some ToolbarContent {
      ToolbarItemGroup(placement: .bottomBar) {
         if nav.isBottomBarPresented {
            
            if isEditMode {
               Button(action: showGroupCreatingSheet) { Text("Add Group") }
            } else {
               NewReminderButton(action: showReminderCreatingSheet, color: nav.accentColor)
            }
            
            Spacer()
            
            if nav.isAddListButtonPresented {
               Button(action: showListCreatingSheet) { Text("Add List") }
            }
         }
      }
   }
   
   // MARK: -- Intetns
   
   private func showListCreatingSheet() {
      sheet.activeSheet = .addList(nil, nil)
   }
   
   private func showGroupCreatingSheet() {
      sheet.activeSheet = .addGroup(nil)
   }
   
   private func showReminderCreatingSheet() {
      if sheet.markAsFlagged {
         sheet.activeSheet = .addReminder(options: .markAsFlagged)
      }
      else if sheet.markAsToday {
         sheet.activeSheet = .addReminder(options: .markAsToday)
      }
      else {
         let list = sheet.reminderList
         sheet.activeSheet = list != nil
            ? .addReminder(options: .withList(list!))
            : .addReminder(options: .none)
      }
   }
}

extension View {
   func setupBottomBar(isEditMode: Bool) -> some View {
      modifier(BottomBar(isEditMode: isEditMode))
   }
}
