//
//  NotificationManagerTest.swift
//  AppleRemindersCopyTests
//
//  Created by Sebastian Staszczyk on 25/04/2021.
//

import XCTest
@testable import AppleRemindersCopy

class NotificationManagerTest: XCTestCase {
   private var notificationCenter: UserNotificationCenter!
   private var notificationManager: NotificationService!
   private var settings: SettingsProtocol!
   
   override func setUp() {
      super.setUp()
      settings = SettingsManagerMock()
      notificationCenter = UserNotificationCenterMock()
      notificationManager = NotificationManager(notificationCenter: notificationCenter, settings: settings)
   }
   
   override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
   }
   
   // MARK: -- Sample Notification Models
   
   let notificationPast = NotificationModel.init(id: UUID(), date: Date().addingTimeInterval(-100), withTime: false, title: "Notification 2", body: "", repetition: .never)
   
   let notificationPresent = NotificationModel.init(id: UUID(), date: Date(), withTime: false, title: "Notification 1", body: "", repetition: .never)
   
   let notificationFutureWithoutTime = NotificationModel.init(id: UUID(), date: Date().addingTimeInterval(100), withTime: false, title: "Notification 3", body: "", repetition: .never)
   
   let notificationFutureWithTime = NotificationModel.init(id: UUID(), date: Date().addingTimeInterval(500), withTime: true, title: "Notification 4", body: "", repetition: .daily)
   
   // MARK: -- Tests
   
   func testIfShouldCreateNotification() throws {
      notificationManager.createNotification(notification: notificationPast)
      notificationCenter.getPendingNotificationRequests { notifications in
         XCTAssert(notifications.isEmpty, "Notification with a past date, should NOT be created.")
      }
      
      notificationManager.createNotification(notification: notificationPresent)
      notificationCenter.getPendingNotificationRequests { notifications in
         XCTAssert(notifications.isEmpty, "Notification with the current date, should NOT be created.")
      }
      
      notificationManager.createNotification(notification: notificationFutureWithoutTime)
      notificationCenter.getPendingNotificationRequests { notifications in
         XCTAssert(notifications.count == 1, "Notification with a future date should be created.")
      }
   }
   
   func testCreateNotificationWithSpecifiedTime() throws {
      let notModel = notificationFutureWithTime
      let hour = Calendar.current.component(.hour, from: notModel.date)
      let minute = Calendar.current.component(.minute, from: notModel.date)
      
      notificationManager.createNotification(notification: notModel)
      notificationCenter.getPendingNotificationRequests { notifications in
         XCTAssert(notifications.count == 1, "Notification with a future date should be created.")
         
         // Testing Notificaiton Info
         let notification = notifications.first!
         XCTAssert(notification.identifier == notModel.id.uuidString)
         XCTAssert(notification.content.title == notModel.title)
         XCTAssert(notification.content.body == notModel.body)
         XCTAssert(notification.content.sound == .default)
         XCTAssert(notification.trigger?.repeats == false)
         
         // Testing Notification Trigger Date
         let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
         let trigger = notification.trigger as! UNCalendarNotificationTrigger
         let dateComponents = Calendar.current.dateComponents(components, from: notModel.date)
         let triggerDateComponents = trigger.dateComponents
         XCTAssert(triggerDateComponents.month == dateComponents.month)
         XCTAssert(triggerDateComponents.year == dateComponents.year)
         XCTAssert(triggerDateComponents.day == dateComponents.day)
         XCTAssert(triggerDateComponents.hour == hour, "Time is specified, hour should equal setted value \(hour).")
         XCTAssert(triggerDateComponents.minute == minute, "Time is specified, minute should equal setted value \(minute).")
      }
   }
   
   func testCreateNotificationWithoutSpecifiedTime() throws {
      let notModel = notificationFutureWithoutTime
      let hour = settings.defaultTriggerTime["hour"]!
      let minute = settings.defaultTriggerTime["minute"]!
      
      notificationManager.createNotification(notification: notModel)
      notificationCenter.getPendingNotificationRequests { notifications in
         XCTAssert(notifications.count == 1, "Notification with a future date should be created.")
         
         // Testing Notificaiton Info
         let notification = notifications.first!
         XCTAssert(notification.identifier == notModel.id.uuidString)
         XCTAssert(notification.content.title == notModel.title)
         XCTAssert(notification.content.body == notModel.body)
         XCTAssert(notification.content.sound == .default)
         XCTAssert(notification.trigger?.repeats == false)
         
         // Testing Notification Trigger Date
         let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
         let trigger = notification.trigger as! UNCalendarNotificationTrigger
         let dateComponents = Calendar.current.dateComponents(components, from: notModel.date)
         let triggerDateComponents = trigger.dateComponents
         XCTAssert(triggerDateComponents.month == dateComponents.month)
         XCTAssert(triggerDateComponents.year == dateComponents.year)
         XCTAssert(triggerDateComponents.day == dateComponents.day)
         XCTAssert(triggerDateComponents.hour == hour, "Time is not specified, hour should equal default value \(hour).")
         XCTAssert(triggerDateComponents.minute == minute, "Time is not specified, minute should equal default value \(minute).")
      }
   }
   
   func testDeleteNotification() throws {
      let notification1 = notificationFutureWithoutTime
      let notification2 = notificationFutureWithTime
      
      notificationManager.createNotification(notification: notification1)
      notificationManager.createNotification(notification: notification2)
      notificationCenter.getPendingNotificationRequests { notifications in
         XCTAssert(notifications.count == 2, "Two notifications should be created.")
      }
      notificationManager.deleteNotification(withId: notification1.id)
      notificationCenter.getPendingNotificationRequests { notifications in
         XCTAssert(notifications.count == 1, "First notification should be deleted.")
      }
      notificationManager.deleteNotification(withId: notification2.id)
      notificationCenter.getPendingNotificationRequests { notifications in
         XCTAssert(notifications.isEmpty, "Second notification should be deleted - no notifications.")
      }
   }
   
   
}
