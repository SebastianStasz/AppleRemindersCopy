//
//  ReminderFormVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 09/04/2021.
//

import Combine
import Foundation

struct ReminderForm {
   var title = ""
   var notes = ""
   var url = ""
   var date = Date()
   var isFlagged = false
   var list: ReminderListEntity?
   var priority: Priority = .none
   var repetition: Repetition = .never
   var endRepetition: EndRepetition = .never
   var endRepetitionDate = Date()
   
   var isDateSelected = false
   var isTimeSelected = false
   var isLocationSelected = false
   var isMessagingSelected = false
}

class ReminderFormVM: ObservableObject {
   private var cancellable: Set<AnyCancellable> = []
   private let coreDataManager = CoreDataManager.shared
   var reminderToEdit: ReminderEntity? = nil { didSet { fillForm() } }
   
   // MARK: -- Acces
   
   @Published var form = ReminderForm()
   @Published private(set) var hasChanged = false
   
   var isValid: Bool {
      !form.title.isEmpty && form.list != nil
   }
   
   var dateDescription: String? {
      guard form.isDateSelected else { return nil }
      let daysFromToday = DateManager.calendar.numberOfDaysBetween(Date(), and: form.date)
      return abs(daysFromToday) < 3
      ? DateManager.relativeFormatter.localizedString(from: DateComponents(day: daysFromToday)).capitalized
      : DateManager.date.string(for: form.date)
   }
   
   var timeDescription: String? {
      guard form.isTimeSelected else { return nil }
      return DateManager.time.string(for: form.date)
   }
   
   func saveChanges() {
      reminderToEdit != nil ? fillReminderInfo(for: reminderToEdit!) : createReminder()
   }
   
   // MARK: -- Logic
   
   private func createReminder() {
      let reminder = ReminderEntity(context: coreDataManager.context)
      reminder.id = UUID()
      reminder.createdDate_ = Date()
      fillReminderInfo(for: reminder)
   }
   
   private func fillReminderInfo(for reminder: ReminderEntity) {
      reminder.name = form.title
      reminder.notes = form.notes
      reminder.url = form.url
      reminder.isFlagged = form.isFlagged
      reminder.priority = form.priority
      reminder.repetition = form.repetition
      
      if form.endRepetition == .date {
         reminder.endRepetitionDate = form.endRepetitionDate
      }
      
      if form.isDateSelected {
         reminder.date = form.date
      } else {
         reminder.date = nil
      }
      
      if form.isTimeSelected {
         reminder.isTimeSelected = true
      }

      form.list?.addToReminders_(reminder)
   }
   
   private func fillForm() {
      if let reminder = reminderToEdit {
         form.title = reminder.name
         form.isFlagged = reminder.isFlagged
         form.list = reminder.list
         form.priority = reminder.priority
         form.repetition = reminder.repetition
         form.isTimeSelected = reminder.isTimeSelected
         
         if let endRepetitionDate = reminder.endRepetitionDate {
            form.endRepetition = .date
            form.endRepetitionDate = endRepetitionDate
         }
         
         if let date = reminder.date {
            form.isDateSelected = true
            form.date = date
         }
         
         if let notes = reminder.notes {
            form.notes = notes
         }
         
         if let url = reminder.url {
            form.url = url
         }
      }
      lookForChanges()
   }
   
   private func lookForChanges() {
      $form.dropFirst()
         .sink { [weak self] _ in self?.hasChanged = true }
         .store(in: &cancellable)
   }
}


