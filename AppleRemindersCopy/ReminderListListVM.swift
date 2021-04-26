//
//  ReminderListListVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 20/04/2021.
//

import Combine
import Foundation

class ReminderListListVM: ObservableObject {
   private var cancellable: Set<AnyCancellable> = []
   private var coreDataManager: CoreDataManager
   
   init(coreDataManager: CoreDataManager) {
      self.coreDataManager = coreDataManager
      updateGroupsChanges()
   }
   
   // MARK: -- Acces
   
   @Published private(set) var groups: [ReminderGroupEntity] = []
   var ungroupedGroup: ReminderGroupEntity { coreDataManager.ungroupedGroup }
   var isEmpty: Bool { ungroupedGroup.list.isEmpty && groups.isEmpty }
   
   func getGroup(at indexSet: IndexSet) -> ReminderGroupEntity {
      let index = indexSet.map{ $0 }.first!
      let group = groups[index]
      return group
   }

   func delete(_ group: ReminderGroupEntity, withLists: Bool) {
      if withLists { _ = group.list.map { coreDataManager.delete($0) } }
      else { _ = group.list.map { $0.group = ungroupedGroup } }
      coreDataManager.delete(group)
   }
   
   // MARK: -- Helpers
   
   private func updateGroupsChanges() {
      coreDataManager.$reminderGroups
         .sink { [weak self] in
            self?.groups = $0.filter { $0.id?.uuidString != UserDefaults.ungroupedGroupId }
         }
         .store(in: &cancellable)
   }
}
