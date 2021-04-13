//
//  ReminderGroupFormVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 06/04/2021.
//

import CoreData
import Foundation

class ReminderGroupFormVM: ObservableObject {
   private let persistence = PersistenceController.preview
   
   private var context: NSManagedObjectContext {
      persistence.container.viewContext
   }
   
   var group: ReminderGroup? { didSet { updateGroupInfo() } }
   var isValid: Bool { !name.isEmpty }
   
   @Published var name = ""
   @Published var otherListsPlaceholder: [ReminderList] = []
   @Published private(set) var includedListsPlaceholder: [ReminderList] = []
   
   // MARK: -- Intents
   
   func removeFromGroup(listAt indexSet: IndexSet) {
      let index = indexSet.map{$0}.first!
      let list = includedListsPlaceholder.remove(at: index)
      otherListsPlaceholder.append(list)
   }
   
   func addToGroup(list: ReminderList) {
      let index = otherListsPlaceholder.firstIndex(of: list)
      includedListsPlaceholder.append(list)
      otherListsPlaceholder.remove(at: index!)
   }
   
   func saveChanges() {
      group == nil ? createGroup() : updateGroup(group!)
      persistence.save()
   }
   
   // MARK: -- Core Data
   
   private func updateGroup(_ group: ReminderGroup) {
      group.name = name
      _ = includedListsPlaceholder.map{ group.addToList_($0) }
      _ = otherListsPlaceholder.map{ group.removeFromList_($0) }
   }
   
   private func createGroup() {
      let newGroup = ReminderGroup(context: context)
      newGroup.id = UUID()
      newGroup.name = name
      _ = includedListsPlaceholder.map{ newGroup.addToList_($0) }
   }
   
   // MARK: -- Helpers
   
   private func updateGroupInfo() {
      includedListsPlaceholder = group?.list ?? []
      name = group?.name ?? ""
   }
}
