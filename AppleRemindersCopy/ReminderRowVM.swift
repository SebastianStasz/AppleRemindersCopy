//
//  ReminderRowVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 18/04/2021.
//

import Combine
import Foundation

class ReminderRowVM: ObservableObject {
   private let coreDataManager = CoreDataManager.shared
   private var cancellable: Set<AnyCancellable> = []
   var reminder: ReminderEntity? = nil { didSet { fillReminderInfo() } }
   
   init() { deleteAfterCompletion() }
   
   // MARK: -- Acces
   
   @Published var name = ""
   @Published var isCompleted = false
   
   func deleteReminder() {
      coreDataManager.delete(reminder!)
   }
   
   func updateName() {
      reminder!.name = name
   }
   
   func selectionEnded() {
      if name.isEmpty { deleteReminder() }
      else if name != reminder!.name { updateName() }
   }
   
   // MARK: -- Helper Functions
   
   private func fillReminderInfo() {
      name = reminder!.name
   }
   
   private func deleteAfterCompletion() {
      $isCompleted
         .dropFirst()
         .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
         .filter { $0 }
         .sink { [weak self] _ in self?.deleteReminder() }
         .store(in: &cancellable)
   }
}
