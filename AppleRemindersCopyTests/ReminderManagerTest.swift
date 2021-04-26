//
//  ReminderManagerTest.swift
//  AppleRemindersCopyTests
//
//  Created by Sebastian Staszczyk on 25/04/2021.
//

import XCTest
import CoreData
@testable import AppleRemindersCopy

class ReminderManagerTest: XCTestCase {
   
   private var context: NSManagedObjectContext!
   private var notificationManager: NotificationManagerMock!
   private var reminderManager: ReminderService!
   
   override func setUpWithError() throws {
      notificationManager = NotificationManagerMock()
      context = PersistenceController.empty.container.viewContext
      reminderManager = ReminderManager(context: context, notificationManager: notificationManager)
   }
   
   override func tearDownWithError() throws {
      context.reset()
   }
   
   func fetchReminders() -> [ReminderEntity] {
      let request = NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
      request.sortDescriptors = []
      
      let fetchedReminders = try! context.fetch(request)
      return fetchedReminders
   }
   
   // MARK: -- Sample Reminder Forms
   
   let reminderFormSample = ReminderForm(name: "Reminder1", notes: "Notes", url: "www.xxx.com", date: Date().addingTimeInterval(500), isFlagged: true, list: nil, priority: .medium, repetition: .fortnightly, endRepetition: .date, endRepetitionDate: Date(), isDateSelected: true, isTimeSelected: true)
   
   let reminderFormWithoutAdditionalInfo = ReminderForm(name: "Reminder2", notes: "", url: "", date: Date(), isFlagged: false, list: nil, priority: .none, repetition: .never, endRepetition: .never, endRepetitionDate: Date(), isDateSelected: false, isTimeSelected: false)
   
   let reminderFormWithAdditionalInfo = ReminderForm(name: "Reminder3", notes: "Sample notes", url: "www.xxx.com", date: Date().addingTimeInterval(500), isFlagged: false, list: nil, priority: .none, repetition: .never, endRepetition: .never, endRepetitionDate: Date(), isDateSelected: true, isTimeSelected: false)
   
   // MARK: -- Creating Reminder Tests
   
   func testCreateReminder() throws {
      let form = reminderFormSample
      reminderManager.create(with: form)
      let reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      
      let reminder = reminders.first!
      XCTAssertNotNil(reminder.id, "Reminder should have id.")
      XCTAssertNotNil(reminder.createdDate_, "Reminder should have createdDate.")
      XCTAssert(reminder.name == form.name)
      XCTAssert(reminder.isFlagged == form.isFlagged)
      XCTAssert(reminder.list == form.list)
      XCTAssert(reminder.priority == form.priority)
      XCTAssert(reminder.repetition == form.repetition)
      XCTAssert(reminder.isTimeSelected == form.isTimeSelected)
      XCTAssert(reminder.url == form.url)
      XCTAssert(reminder.notes == form.notes)
      XCTAssert(reminder.date == form.date)
      XCTAssert(reminder.endRepetitionDate == form.endRepetitionDate)
      XCTAssert(notificationManager.notifications.count == 1, "Notification should be created")
   }
   
   func testCreateReminderWithoutAdditionalInfo() throws {
      let form = reminderFormWithoutAdditionalInfo
      reminderManager.create(with: form)
      let reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      
      let reminder = reminders.first!
      XCTAssertNil(reminder.url, "Reminder url should be nil, because url field in form is empty.")
      XCTAssertNil(reminder.notes, "Reminder notes should be nil, because notes field in form is empty.")
   }
   
   func testCreateReminderWithAdditionalInfo() throws {
      let form = reminderFormWithAdditionalInfo
      reminderManager.create(with: form)
      let reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      
      let reminder = reminders.first!
      XCTAssert(reminder.url == form.url)
      XCTAssert(reminder.notes == form.notes)
   }
   
   func testCreateReminderWithoutDate() throws {
      let form = reminderFormWithoutAdditionalInfo
      reminderManager.create(with: form)
      let reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      
      let reminder = reminders.first!
      XCTAssert(reminder.isTimeSelected == form.isTimeSelected)
      XCTAssertNil(reminder.date, "Reminder Date should be nil, because date in form is NOT selected.")
      XCTAssertNil(reminder.endRepetitionDate, "End Repetition Date should be nil, because \"endRepetition is .never\".")
      XCTAssert(notificationManager.notifications.isEmpty, "Notification should NOT be created.")
   }
   
   func testCreateReminderWithDate() throws {
      let form = reminderFormWithAdditionalInfo
      reminderManager.create(with: form)
      let reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      
      let reminder = reminders.first!
      XCTAssert(reminder.isTimeSelected == form.isTimeSelected)
      XCTAssert(reminder.date == form.date, "Reminder Date should be specified.")
      XCTAssertNil(reminder.endRepetitionDate, "End Repetition Date should be nil, because \"endRepetition is .never\".")
      XCTAssert(notificationManager.notifications.count == 1, "Notification should be created.")
   }
   
   // MARK: -- Deleting Reminder Tests
   
   func testDeleteReminder() throws {
      let form = reminderFormWithoutAdditionalInfo
      reminderManager.create(with: form)
      var reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      XCTAssert(notificationManager.notifications.count == 1, "Notification should be created.")
      
      let reminder = reminders.first!
      reminderManager.delete(reminder)
      reminders = fetchReminders()
      XCTAssert(reminders.isEmpty, "Reminder should be deleted.")
      XCTAssert(notificationManager.notifications.isEmpty, "Notification should be deleted.")
   }
   
   // MARK: -- Updating Reminder Tests
   
   func testUpdateReminder() throws {
      let form = reminderFormSample
      reminderManager.create(with: form)
      var reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      XCTAssert(notificationManager.notifications.count == 1, "Notification should be created.")
      
      // Reminder Info before updating
      let reminder = reminders.first!
      XCTAssertNotNil(reminder.id, "Reminder should have id.")
      XCTAssertNotNil(reminder.createdDate_, "Reminder should have createdDate.")
      XCTAssert(reminder.name == form.name)
      XCTAssert(reminder.isFlagged == form.isFlagged)
      XCTAssert(reminder.list == form.list)
      XCTAssert(reminder.priority == form.priority)
      XCTAssert(reminder.repetition == form.repetition)
      XCTAssert(reminder.isTimeSelected == form.isTimeSelected)
      XCTAssert(reminder.url == form.url)
      XCTAssert(reminder.notes == form.notes)
      XCTAssert(reminder.date == form.date)
      XCTAssert(reminder.endRepetitionDate == form.endRepetitionDate)
      
      let updatedForm = reminderFormWithAdditionalInfo
      reminderManager.update(reminder, form: updatedForm)
      reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should still exist.")
      XCTAssert(notificationManager.notifications.count == 1, "Old notification should be deleted. New notification should be created for updated reminder.")
      
      // Reminder Info after updating
      let updatedReminder = reminders.first!
      XCTAssert(updatedReminder.id == reminder.id, "Reminder should have the same id.")
      XCTAssert(updatedReminder.createdDate_ == reminder.createdDate_, "Reminder should have the same createdDate.")
      XCTAssert(updatedReminder.name == updatedForm.name)
      XCTAssert(updatedReminder.isFlagged == updatedForm.isFlagged)
      XCTAssert(updatedReminder.list == updatedForm.list)
      XCTAssert(updatedReminder.priority == updatedForm.priority)
      XCTAssert(updatedReminder.repetition == updatedForm.repetition)
      XCTAssert(updatedReminder.isTimeSelected == updatedForm.isTimeSelected)
      XCTAssert(updatedReminder.url == updatedForm.url)
      XCTAssert(updatedReminder.notes == updatedForm.notes)
      XCTAssert(updatedReminder.date == updatedForm.date)
      XCTAssert(updatedReminder.endRepetitionDate == updatedForm.endRepetitionDate)
   }
   
   // MARK: -- Marking Reminder as Completed Tests
   
   func test_markAsCompleted_reminder_without_repetition() {
      let reminderForm = ReminderForm(name: "Reminder", notes: "", url: "", date: Date().addingTimeInterval(500), isFlagged: true, list: nil, priority: .medium, repetition: .never, endRepetition: .never, endRepetitionDate: Date(), isDateSelected: true, isTimeSelected: true)
      var reminders: [ReminderEntity] = []
      
      reminderManager.create(with: reminderForm)
      reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      XCTAssert(notificationManager.notifications.count == 1, "Notification should be created.")
      
      reminderManager.markAsCompleted(reminders.first!)
      reminders = fetchReminders()
      XCTAssert(reminders.isEmpty, "Reminder without repetition should be deleted entirely.")
      XCTAssert(notificationManager.notifications.isEmpty, "Notification should be deleted.")
   }
   
   func test_markAsCompleted_reminder_with_repetition_and_no_end_repetition_date() {
      let reminderForm = ReminderForm(name: "Reminder", notes: "", url: "", date: Date().addingTimeInterval(500), isFlagged: true, list: nil, priority: .medium, repetition: .daily, endRepetition: .never, endRepetitionDate: Date(), isDateSelected: true, isTimeSelected: true)
      var reminders: [ReminderEntity] = []
      var reminderDate = Date()
      
      reminderManager.create(with: reminderForm)
      reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      XCTAssert(notificationManager.notifications.count == 1, "Notification should be created.")
      var reminder = reminders.first!
      reminderDate = reminderForm.date
      XCTAssert(reminder.date == reminderDate)
      
      for _ in 0...10 {
         reminderManager.markAsCompleted(reminders.first!)
         reminders = fetchReminders()
         XCTAssert(reminders.count == 1, "Old reminder should be deleted, new reminder should be created.")
         XCTAssert(notificationManager.notifications.count == 1, "Old notification should be deleted, new notification should be created.")
         reminder = reminders.first!
         reminderDate = DateManager.getNextDate(for: reminderDate, repetition: reminderForm.repetition)
         XCTAssert(reminder.date == reminderDate, "Reminder date should be set for the next day.")
      }
   }
   
   func test_markAsCompleted_reminder_with_repetition_and_with_end_repetition_date() {
      let endRepetitionDate = DateManager.calendar.date(byAdding: .day, value: 10, to: Date().addingTimeInterval(500))!
      let reminderForm = ReminderForm(name: "Reminder", notes: "", url: "", date: Date().addingTimeInterval(500), isFlagged: true, list: nil, priority: .medium, repetition: .daily, endRepetition: .date, endRepetitionDate: endRepetitionDate, isDateSelected: true, isTimeSelected: true)
      var reminders: [ReminderEntity] = []
      var reminderDate = Date()

      reminderManager.create(with: reminderForm)
      reminders = fetchReminders()
      XCTAssert(reminders.count == 1, "One reminder should be created.")
      XCTAssert(notificationManager.notifications.count == 1, "Notification should be created.")
      var reminder = reminders.first!
      reminderDate = reminderForm.date
      XCTAssert(reminder.date == reminderDate)
      
      for _ in 1...9 {
         reminderManager.markAsCompleted(reminders.first!)
         reminders = fetchReminders()
         XCTAssert(reminders.count == 1, "Old reminder should be deleted, new reminder should be created.")
         XCTAssert(notificationManager.notifications.count == 1, "Old notification should be deleted, new notification should be created.")
         reminder = reminders.first!
         reminderDate = DateManager.getNextDate(for: reminderDate, repetition: reminderForm.repetition)
         XCTAssert(reminder.date == reminderDate, "Reminder date should be set for the next day.")
      }
      
      reminderManager.markAsCompleted(reminders.first!)
      reminders = fetchReminders()
      XCTAssert(reminders.isEmpty, "Reminder with date after endRepetitionDate should be deleted entirely.")
      XCTAssert(notificationManager.notifications.isEmpty, "Notification should be deleted.")
   }
}
