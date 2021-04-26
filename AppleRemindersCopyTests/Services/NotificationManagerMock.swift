//
//  NotificationManagerMock.swift
//  AppleRemindersCopyTests
//
//  Created by Sebastian Staszczyk on 25/04/2021.
//

import Foundation
@testable import AppleRemindersCopy

class NotificationManagerMock: NotificationService {
   var notifications: [String] = []
   
   func deleteNotification(withId id: UUID) {
      if let index = notifications.firstIndex(where: { $0 == id.uuidString }) {
         notifications.remove(at: index)
      }
   }
   
   func createNotification(notification: NotificationModel) {
      notifications.append(notification.id.uuidString)
   }
}
