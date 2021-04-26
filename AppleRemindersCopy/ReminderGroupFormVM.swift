//
//  ReminderGroupFormVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 06/04/2021.
//

import CoreData
import Foundation

class ReminderGroupFormVM: ObservableObject {
   private let coreDataManager = CoreDataManager.shared
   
   var includedListsCount: String { String(includedListsPlaceholder.count) }
   var group: ReminderGroupEntity? { didSet { updateGroupInfo() } }
   var isValid: Bool { !name.isEmpty }
   
   @Published var name = ""
   @Published private(set) var otherListsPlaceholder: [ReminderListEntity] = []
   @Published private(set) var includedListsPlaceholder: [ReminderListEntity] = []
   
   // MARK: -- Intents
   
   func removeFromGroup(listAt indexSet: IndexSet) {
      let index = indexSet.map{$0}.first!
      let list = includedListsPlaceholder.remove(at: index)
      otherListsPlaceholder.append(list)
   }
   
   func addToGroup(list: ReminderListEntity) {
      let index = otherListsPlaceholder.firstIndex(of: list)
      includedListsPlaceholder.append(list)
      otherListsPlaceholder.remove(at: index!)
   }
   
   func saveChanges() {
      group == nil ? createGroup() : updateGroup(group!)
   }
   
   // MARK: -- Core Data
   
   private func updateGroup(_ group: ReminderGroupEntity) {
      group.name = name
      _ = otherListsPlaceholder.filter{ $0.group == group }
         .map { $0.group = coreDataManager.ungroupedGroup }
      
      _ = includedListsPlaceholder.map{ group.addToList_($0) }
   }
   
   private func createGroup() {
      let newGroup = ReminderGroupEntity(context: coreDataManager.context)
      newGroup.id = UUID()
      newGroup.name = name
      _ = includedListsPlaceholder.map{ newGroup.addToList_($0) }
   }
   
   // MARK: -- Helpers
   
   private func updateGroupInfo() {
      let otherLists = coreDataManager.reminderGroups.filter { $0.name != group?.name }.flatMap{ $0.list }
      
      name = group?.name ?? ""
      includedListsPlaceholder = group?.list ?? []
      otherListsPlaceholder = otherLists
   }
}
