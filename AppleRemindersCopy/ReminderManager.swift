//
//  ReminderManager.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 24/04/2021.
//

import CoreData
import Foundation

protocol ReminderService {
   var context: NSManagedObjectContext { get }
   var notificationManager: NotificationService { get }
   
   func create(with form: ReminderForm) -> Void
   func delete(_ reminder: ReminderEntity) -> Void
   func update(_ reminder: ReminderEntity, form: ReminderForm) -> Void
   func markAsCompleted(_ reminder: ReminderEntity) -> Void
}

struct ReminderManager: ReminderService {
   let context: NSManagedObjectContext
   let notificationManager: NotificationService
   
   init(context: NSManagedObjectContext = CoreDataManager.shared.context, notificationManager: NotificationService = NotificationManager.shared) {
      self.context = context
      self.notificationManager = notificationManager
   }
   
   // MARK: -- Access
   
   func create(with form: ReminderForm) {
      let reminder = ReminderEntity(context: context)
      reminder.id = UUID()
      reminder.createdDate_ = Date()
      fillReminderInfo(for: reminder, by: form)
   }
   
   func delete(_ reminder: ReminderEntity) {
      notificationManager.deleteNotification(withId: reminder.id_)
      context.delete(reminder)
   }
   
   func update(_ reminder: ReminderEntity, form: ReminderForm) {
      fillReminderInfo(for: reminder, by: form)
   }
   
   func markAsCompleted(_ reminder: ReminderEntity) {
      if reminder.repetition == .never {
         print("No repetitive. Deleting entirely.")
         delete(reminder) ; return
      } else {
         print("Is repetitive.")
         checkForNextDate(for: reminder) ; return
      }
   }
   
   // MARK: -- Private
   
   private func checkForNextDate(for reminder: ReminderEntity) {
      let oldDate = reminder.date! // TODO: Temporary force unwraped
      let newDate = DateManager.getNextDate(for: oldDate, repetition: reminder.repetition)
      
      guard let endDate = reminder.endRepetitionDate else {
         print("Infinite repetition.")
         setNextReminder(for: reminder, at: newDate)
         return
      }
      
      let endRepetitionDate = DateManager.getDateRange(for: endDate).dateStart
      
      if endRepetitionDate > newDate {
         setNextReminder(for: reminder, at: newDate)
      } else {
         print("Repetition Ended, Deleting.")
         delete(reminder)
      }
   }
   
   private func setNextReminder(for reminder: ReminderEntity, at date: Date) {
      print("Setting next reminder")
      var reminderForm = ReminderForm()
      reminderForm.fill(by: reminder)
      reminderForm.date = date
      delete(reminder)
      create(with: reminderForm)
   }
   
   private func fillReminderInfo(for reminder: ReminderEntity, by form: ReminderForm) {
      reminder.name = form.name
      reminder.notes = form.notes.isEmpty ? nil : form.notes
      reminder.url = form.url.isEmpty ? nil : form.url
      reminder.priority = form.priority
      reminder.isFlagged = form.isFlagged
      reminder.repetition = form.repetition
      reminder.isTimeSelected = form.isTimeSelected
      reminder.date = form.isDateSelected ? form.date : nil
      form.list?.addToReminders_(reminder)
      
      if form.endRepetition == .date {
         reminder.endRepetitionDate = form.endRepetitionDate
      }
      
      setNotification(for: reminder)
   }
   
   private func setNotification(for reminder: ReminderEntity) {
      let notificationModel = NotificationModel.create(from: reminder)
      guard let model = notificationModel, model.date >= Date() else { return }
      notificationManager.deleteNotification(withId: reminder.id_)
      notificationManager.createNotification(notification: model)
   }
}
