//
//  ReminderFormVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 09/04/2021.
//

import Foundation

struct ReminderModel {
   var title = ""
   var notes = ""
   var url = ""
   var date = Date()
   var isFlagged = false
   var list: ReminderList?
   var priority: Priority = .none
   var repetition: Repetition = .never
   var endRepetition: EndRepetition = .never
   var endRepetitionDate = Date()
}

class ReminderFormVM: ObservableObject {
   private let context = PersistenceController.context
   var reminderToEdit: Reminder? = nil {
      didSet {
         if let reminder = reminderToEdit {
            fillForm(reminder)
         }
      }
   }
   
   // MARK: -- Acces
   
   @Published var reminderModel = ReminderModel()
   @Published var isDateSelected = false
   @Published var isTimeSelected = false
   @Published var isLocationSelected = false
   @Published var isMessagingSelected = false
   
   var isValid: Bool {
      !reminderModel.title.isEmpty && reminderModel.list != nil
   }
   
   var dateDescription: String? {
      guard isDateSelected else { return nil }
      let daysFromToday = DateHelper.calendar.numberOfDaysBetween(Date(), and: reminderModel.date)
      return abs(daysFromToday) < 3
      ? DateHelper.relativeFormatter.localizedString(from: DateComponents(day: daysFromToday)).capitalized
      : DateHelper.date.string(for: reminderModel.date)
   }
   
   var timeDescription: String? {
      guard isTimeSelected else { return nil }
      return DateHelper.time.string(for: reminderModel.date)
   }
   
   func saveChanges() {
      reminderToEdit != nil ? fillReminderInfo(for: reminderToEdit!) : createReminder()
   }
   
   // MARK: -- Logic
   
   private func createReminder() {
      let reminder = Reminder(context: context)
      reminder.id = UUID()
      fillReminderInfo(for: reminder)
   }
   
   private func fillReminderInfo(for reminder: Reminder) {
      reminder.name = reminderModel.title
      reminder.list = reminderModel.list!
      reminder.isFlagged = reminderModel.isFlagged
      reminder.priority = reminderModel.priority
      reminder.repetition = reminderModel.repetition
      
      if reminderModel.endRepetition == .date {
         reminder.endRepetitionDate = reminderModel.endRepetitionDate
      }
      
      if isDateSelected {
         reminder.date = reminderModel.date
      }
      
      if isTimeSelected {
         reminder.isTimeSelected = true
      }
      
      if !reminderModel.notes.isEmpty {
         reminder.notes = reminderModel.notes
      }
      
      if !reminderModel.url.isEmpty {
         reminder.url = reminderModel.url
      }
   }
   
   private func fillForm(_ reminder: Reminder) {
      reminderModel.title = reminder.name
      reminderModel.isFlagged = reminder.isFlagged
      reminderModel.list = reminder.list
      reminderModel.priority = reminder.priority
      reminderModel.repetition = reminder.repetition
      isTimeSelected = reminder.isTimeSelected
      
      if let endRepetitionDate = reminder.endRepetitionDate {
         reminderModel.endRepetition = .date
         reminderModel.endRepetitionDate = endRepetitionDate
      }
      
      if let date = reminder.date {
         isDateSelected = true
         reminderModel.date = date
      }
      
      if let notes = reminder.notes {
         reminderModel.notes = notes
      }
      
      if let url = reminder.url {
         reminderModel.url = url
      }
   }
}


