//
//  NotificationManager.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 15/04/2021.
//

import Foundation
import UserNotifications

class NotificationManager {
   static let shared = NotificationManager()
   private let notificationCenter = UNUserNotificationCenter.current()
   
   // MARK: -- Access
   
   func checkForAuthorization() {
      notificationCenter.getNotificationSettings { [weak self] settings in
         switch settings.authorizationStatus {
         case .notDetermined: self?.requestAuthorization()
         case .authorized: self?.listScheduledNotifications()
         default: break
         }
      }
   }
   
   func listScheduledNotifications() {
      notificationCenter.getPendingNotificationRequests { notifications in
         guard !notifications.isEmpty else { print("No scheduled notifications.") ; return }
         _ = notifications.map { print($0) }
      }
   }
   
   // MARK: -- Private
   
   private func requestAuthorization() {
      notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
         print("Permision granted: \(granted).")
      }
   }
}
