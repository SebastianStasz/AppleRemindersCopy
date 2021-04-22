//
//  ReminderListList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 13/04/2021.
//

import SwiftUI

struct ReminderListList: View {
   @Environment(\.editMode) private var editMode
   @State private var alert: DeleteReminderListAlert?
   var reminderLists: [ReminderListEntity]
   
   var body: some View {
      ForEach(reminderLists) { list in
         ReminderListRowLink(list: list)
            .environment(\.editMode, editMode)
            .padding(.vertical, 3)
      }
      .onDelete(perform: delete)
      .onMove { indexSet, index in } // TODO: Reordering
      .alert(item: $alert) { $0.body }
   }
   
   private func delete(at indexSet: IndexSet) {
      let index = indexSet.map{ $0 }.first!
      let list = reminderLists[index]
      list.reminders.isEmpty ? deleteReminderList(list) : showDeleteReminderListAlert(for: list)
   }
   
   // MARK: -- Helpers
   
   private func showDeleteReminderListAlert(for list: ReminderListEntity) {
      alert = .init(list: list)
   }
   
   private func deleteReminderList(_ list: ReminderListEntity) {
      CoreDataManager.shared.delete(list)
   }
   
   init(reminderLists: [ReminderListEntity]) {
      self.reminderLists = reminderLists
   }
}
