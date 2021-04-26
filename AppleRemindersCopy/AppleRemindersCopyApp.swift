//
//  AppleRemindersCopyApp.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import SwiftUI

@main
struct AppleRemindersCopyApp: App {
   private let context = CoreDataManager.shared.context
   @Environment(\.scenePhase) private var scenePhase
   @StateObject private var sheetController = SheetController()
   @StateObject private var navigationController = NavigationController()
   
   init() {
      NotificationManager.shared.checkForAuthorization()
      setNotificationBadge()
   }
   
   var body: some Scene {
      WindowGroup {
         HomeView()
            .environment(\.managedObjectContext, context)
            .environmentObject(navigationController)
            .environmentObject(sheetController)
      }
      .onChange(of: scenePhase) { phase in
          if phase == .background { try! context.save() }
      }
   }
}

func setNotificationBadge() {
   let ammount = CoreDataManager.shared.getMissedRemindersCount()
   UIApplication.shared.applicationIconBadgeNumber = ammount
}

// TODO:
// - Refactor scheduled reminders filtering
// - Refactor creating reminder options
// - Refactor ReminderRow
// - ReminderList / ReminderGroup ordering

// Bugs:
// - GroupList Row count not updating properly
// - IconBagdeNumber not working
