//
//  NotificationManager.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 15/04/2021.
//

import Foundation
import UserNotifications

protocol UserNotificationCenter {
   func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
   func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void)
   func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void)
   
   func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
   func removePendingNotificationRequests(withIdentifiers: [String])
}

extension UNUserNotificationCenter: UserNotificationCenter {}


protocol NotificationService {
   func deleteNotification(withId id: UUID) -> Void
   func createNotification(notification: NotificationModel) -> Void
}

class NotificationManager: NotificationService {
   static let shared = NotificationManager()
   private let notificationCenter: UserNotificationCenter
   private let defaultTime: [String: Int]
   
   init(notificationCenter: UserNotificationCenter = UNUserNotificationCenter.current(), settings: SettingsProtocol = SettingsManager()) {
      self.notificationCenter = notificationCenter
      defaultTime = settings.defaultTriggerTime
   }
   
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
   
   func deleteNotification(withId id: UUID) {
      let id = id.uuidString
      notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
      listScheduledNotifications()
   }
   
   func createNotification(notification: NotificationModel) {
      guard notification.date >= Date() else { return }
      
      let id = notification.id.uuidString
      let content = getContentFor(notification)
      let trigger = getTriggerFor(notification)
      let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
      notificationCenter.add(request) { error in
         if let error = error { print(error) }
      }
      print(trigger.nextTriggerDate() ?? "NIL")
      listScheduledNotifications()
   }
   
   // MARK: -- Private
   
   private func getTriggerFor(_ notification: NotificationModel) -> UNCalendarNotificationTrigger {
      var dateComponents = DateComponents()
      let date = notification.date
      
      if notification.withTime {
         dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
      } else {
         dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
         dateComponents.hour = defaultTime["hour"]
         dateComponents.minute = defaultTime["minute"]
      }
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
      return trigger
   }
   
   private func getContentFor(_ notification: NotificationModel) -> UNMutableNotificationContent {
      let content = UNMutableNotificationContent()
      content.title = notification.title
      content.body = notification.body
      content.sound = .default
      return content
   }
   
   private func requestAuthorization() {
      notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
         print("Permision granted: \(granted).")
      }
   }
   
   private func listScheduledNotifications() {
      notificationCenter.getPendingNotificationRequests { notifications in
         guard !notifications.isEmpty else { print("No scheduled notifications.") ; return }
         print("-----------------------------")
         _ = notifications.map { print($0) }
      }
   }
}

struct NotificationModel {
   let id: UUID
   let date: Date
   let withTime: Bool
   let title: String
   let body: String
   let repetition: Repetition
   
   static func create(from reminder: ReminderEntity) -> NotificationModel? {
      guard let date = reminder.date else { return nil }
      
      let notificationModel = NotificationModel(id: reminder.id_, date: date, withTime: reminder.isTimeSelected, title: reminder.name, body: reminder.notes ?? "", repetition: reminder.repetition)
      
      return notificationModel
   }
}

