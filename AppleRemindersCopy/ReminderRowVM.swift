//
//  ReminderRowVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 18/04/2021.
//

import Combine
import Foundation

class ReminderRowVM: ObservableObject {
   private let reminderManager: ReminderService
   private var cancellable: Set<AnyCancellable> = []
   var reminder: ReminderEntity? { didSet { fillReminderInfo() } }
   
   init(reminderManager: ReminderService = ReminderManager()) {
      self.reminderManager = reminderManager
      
      actionAfterCompleted()
   }
   
   // MARK: -- View Acces
   
   @Published var isCompleted = false
   @Published var name = ""
   var url: URL? = nil
   
   var priorityIndicator: String? {
      guard let reminder = reminder, reminder.priority != .none else { return nil }
      return String(repeating: "!", count: reminder.priority.rawValue)
   }
   
   func selectionEnded() {
      if name.isEmpty {
         deleteReminder() ; return
      }
      if name != reminder!.name {
         reminder!.name = name
      }
   }
   
   // MARK: -- Private
   
   private func actionAfterCompleted() {
      $isCompleted
         .dropFirst()
         .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
         .filter { $0 }
         .sink { [weak self] _ in
            // TODO: Check for memory cycle
            self?.reminderManager.markAsCompleted(self!.reminder!)
         }
         .store(in: &cancellable)
   }
   
   private func deleteReminder() {
      reminderManager.delete(reminder!)
   }
   
   private func fillReminderInfo() {
      name = reminder!.name
      
      if let url = reminder!.url, var components = URLComponents(string: url) {
         if components.scheme == nil { components.scheme = "http" }
         self.url = components.url
      }
   }
}
