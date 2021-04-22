//
//  ReminderGroupList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 19/04/2021.
//

import SwiftUI

struct ReminderGroupList: View {
   @Environment(\.editMode) private var editMode
   @ObservedObject var reminderGroupsVM: ReminderListListVM
   @State private var actionSheet: DeleteGroupActionSheet?
   
   var body: some View {
      ForEach(reminderGroupsVM.groups) { group in
         DisclosureGroup {
            ReminderListList(reminderLists: group.list)
         }
         label: {
            DisclosureGroupLabel(group: group)
               .environment(\.editMode, editMode)
         }
      }
      .onDelete(perform: delete)
      .onMove { indexSet, index in } // TODO: Reordering
      .actionSheet(item: $actionSheet) { $0.sheet }
   }
   
   // MARK: -- Intents
   
   private func delete(at indexSet: IndexSet) {
      let group = reminderGroupsVM.getGroup(at: indexSet)
      group.list.isEmpty ? deleteGroup(group) : showActionSheet(for: group)
   }
   
   // MARK: -- Helpers
   
   private func deleteGroup(_ group: ReminderGroupEntity) {
      reminderGroupsVM.delete(group, withLists: false)
   }
   
   private func showActionSheet(for group: ReminderGroupEntity) {
      actionSheet = .init(reminderGroupsVM: reminderGroupsVM, group: group)
   }
}


// MARK: -- Preview

struct ReminderGroupList_Previews: PreviewProvider {
    static var previews: some View {
      let vm = ReminderListListVM(coreDataManager: CoreDataManager())
        ReminderGroupList(reminderGroupsVM: vm)
    }
}
