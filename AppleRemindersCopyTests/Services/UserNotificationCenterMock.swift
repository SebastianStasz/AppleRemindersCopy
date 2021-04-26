//
//  UserNotificationCenterMock.swift
//  AppleRemindersCopyTests
//
//  Created by Sebastian Staszczyk on 25/04/2021.
//

import Foundation
import NotificationCenter
@testable import AppleRemindersCopy

class UserNotificationCenterMock: UserNotificationCenter {
   var pendingNotifications: [UNNotificationRequest] = []
   var settingsCoder = MockNSCoder()
   
   func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
      completionHandler(true, nil)
   }
   
   func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void) {
      completionHandler(pendingNotifications)
   }
   
   func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void) {
      let settings = UNNotificationSettings(coder: settingsCoder)!
      completionHandler(settings)
   }

   func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
      pendingNotifications.append(request)
      completionHandler?(nil)
   }
   
   func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
      pendingNotifications.removeAll { notification in
         identifiers.contains { $0 == notification.identifier }
      }
   }
}

// MARK: -- MockNSCoder

class MockNSCoder: NSCoder {
   var authorizationStatus = UNAuthorizationStatus.authorized.rawValue
   
   override func decodeInt64(forKey key: String) -> Int64 {
      return Int64(authorizationStatus)
   }
   
   override func decodeBool(forKey key: String) -> Bool {
      return true
   }
}

