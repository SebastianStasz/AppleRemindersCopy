//
//  ReminderListList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 13/04/2021.
//

import SwiftUI

struct ReminderListList: View {
   @Environment(\.editMode) private var editMode
   let reminderLists: [ReminderListEntity]
   
   var body: some View {
      ForEach(reminderLists) { list in
         ReminderListRowLink(config: .byList(list), list: list)
            .environment(\.editMode, editMode)
            .padding(.vertical, 3)
      }
      .onDelete(perform: delete)
      .onMove { indexSet, index in } // TODO: Reordering
   }
   
   private func delete(at indexSet: IndexSet) {
      let index = indexSet.map{ $0 }.first!
      let list = reminderLists[index]
      CoreDataManager.shared.delete(list)
   }
}

