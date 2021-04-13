//
//  AppleRemindersCopyApp.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import SwiftUI

@main
struct AppleRemindersCopyApp: App {
   @Environment(\.scenePhase) private var scenePhase
   @StateObject private var sheetController = SheetController()
   @StateObject private var navigationController = NavigationController()
   private let context = PersistenceController.context
   
   var body: some Scene {
      WindowGroup {
         HomeView()
            .environment(\.managedObjectContext, context)
            .environmentObject(navigationController)
            .environmentObject(sheetController)
      }
      .onChange(of: scenePhase) { phase in
          if phase == .background {
            try! context.save()
          }
      }
   }
}

//private func setupNavigationBar() {
//   UINavigationBar.appearance().barTintColor = UIColor(backgroundColor)
//   UINavigationBar.appearance().shadowImage = UIImage()
//   UINavigationBar.appearance().isTranslucent = false
//}
