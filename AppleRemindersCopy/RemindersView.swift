//
//  RemindersView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 15/04/2021.
//

import SwiftUI

struct RemindersView: ViewModifier {
   @EnvironmentObject private var sheet: SheetController
   @EnvironmentObject private var nav: NavigationController
   var listForReminder: ReminderListEntity? = nil
   let hideBottomBar: Bool
   let accentColor: Color
   let title: String
   
   func body(content: Content) -> some View {
      content
         .padding(.bottom, hideBottomBar ? 0 : 49)
         .navigationTitle(title)
         .navigationBarTitleDisplayMode(.large)

         .onAppear(perform: viewDidAppear)
         .onDisappear(perform: viewDidDisappear)
   }
   
   private func viewDidDisappear() {
      sheet.reminderList = nil
      nav.restoreDefaultSettings()
   }
   
   private func viewDidAppear() {
      sheet.reminderList = listForReminder
      nav.setupBottomBar(hideBottomBar: hideBottomBar, color: accentColor, showAddListBtn: false)
   }
}

extension View {
   func embedinRemindersView(title: String, accentColor: Color, hideBottomBar: Bool) -> some View {
      self.modifier(RemindersView(hideBottomBar: hideBottomBar, accentColor: accentColor, title: title))
   }
}
