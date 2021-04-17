//
//  RemindersVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 15/04/2021.
//

import CoreData
import Foundation
import SwiftUI

class RemindersVM: ObservableObject {
   private let coreDataManager = CoreDataManager.shared
   var config: RemindersVM.Config? = nil { didSet { fetchReminders() } }
   
   @Published private(set) var reminders: [ReminderEntity] = []
   @Published var selectedReminder: ReminderEntity? = nil
   
   var isEmpty: Bool { reminders.isEmpty }
   var count: String { String(reminders.count) }
   
   func delete(at indexSet: IndexSet) {
      let index = indexSet.map { $0 }.first!
      let reminder = reminders[index]
      reminders.remove(at: index)
      coreDataManager.delete(reminder)
   }
   
   func removeFromList(at index: Int) {
      _ = withAnimation { reminders.remove(at: index) }
   }
   
   private func fetchReminders() {
      let request = NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
      request.sortDescriptors = [ReminderEntity.sortByDate]
      request.predicate = config?.predicate ?? nil

      do {
         reminders = try coreDataManager.context.fetch(request)
      } catch let err {
         print("RemindersVM: Error when fetching data \(err)")
      }
   }
}

extension RemindersVM {
   enum Config {
      case byList(ReminderListEntity)
      case byCard(ReminderCard.CardData)
      
      var predicate: NSPredicate? {
         switch self {
         case .byList(let list):
            return NSPredicate(format: "list == %@", list)
         case.byCard(let card):
            return card.model.list.predicate
         }
      }
      
      var title: String {
         switch self {
         case .byList(let list): return list.name
         case .byCard(let card): return card.model.title
         }
      }
      
      var accentColor: Color {
         switch self {
         case .byList(let list): return list.color
         case .byCard(let card): return card.model.color
         }
      }
      
      var showListName: Bool {
         switch self {
         case .byList(_): return false
         case .byCard(let card): return card.model.list.showListName
         }
      }
   }
}
