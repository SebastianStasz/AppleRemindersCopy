//
//  ReminderFormVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 09/04/2021.
//

import Combine
import CoreData
import Foundation

class ReminderFormVM: ObservableObject {
   private var cancellable: Set<AnyCancellable> = []
   private let reminderManager: ReminderService
   
   init(reminderManager: ReminderService = ReminderManager()) {
      self.reminderManager = reminderManager
   }
   
   var reminderToEdit: ReminderEntity? = nil { didSet { fillForm() } }
   
   // MARK: -- Acces
   
   @Published var form = ReminderForm()
   @Published var isLocationSelected = false
   @Published var isMessagingSelected = false
   @Published private(set) var formHasChanged = false
   
   var isValid: Bool {
      !form.name.isEmpty && form.list != nil
   }
   
   var dateDescription: String? {
      guard form.isDateSelected else { return nil }
      let dateDescription = DateManager.getDateDescription(for: form.date)
      return dateDescription
   }
   
   var timeDescription: String? {
      guard form.isTimeSelected else { return nil }
      return DateManager.time.string(for: form.date)
   }
   
   func saveChanges() {
      if let reminder = reminderToEdit {
         reminderManager.update(reminder, form: form)
      } else {
         reminderManager.create(with: form)
      }
   }
   
   // MARK: -- Private
   
   private func fillForm() {
      if let reminder = reminderToEdit {
         form.fill(by: reminder)
      }
      observeIfFormHasChanges()
   }
   
   private func observeIfFormHasChanges() {
      $form
         .dropFirst(2)
         .sink { [weak self] _ in self?.formHasChanged = true }
         .store(in: &cancellable)
   }
}


