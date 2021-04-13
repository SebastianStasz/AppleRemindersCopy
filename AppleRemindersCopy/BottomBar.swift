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
   
   func body(content: Content) -> some View {
      content.toolbar { bottomBarBody }
   }
   
   private var bottomBarBody: some ToolbarContent {
      ToolbarItemGroup(placement: .bottomBar) {
         if nav.isBottomBarPresented {
            
            NewReminderButton(action: showReminderCreatingSheet,
                              color: nav.accentColor)
            
            Spacer()
            
            if nav.isAddListButtonPresented {
               Button(action: showListCreatingSheet) {
                  Text("Add List")
               }
            }
         }
      }
   }
   
   private func showListCreatingSheet() {
      sheet.activeSheet = .addList(nil)
   }
   
   private func showReminderCreatingSheet() {
      sheet.activeSheet = .addReminder(nil, sheet.reminderList)
   }
}

extension View {
   func setupBottomBar() -> some View {
      modifier(BottomBar())
   }
}
