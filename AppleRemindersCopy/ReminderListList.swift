//
//  ReminderListList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 13/04/2021.
//

import SwiftUI

struct ReminderListList: View {
   @Environment(\.editMode) private var editMode
   @EnvironmentObject private var listVM: ReminderListVM
   @FetchRequest private var reminderLists: FetchedResults<ReminderList>
   
   init(predicate: NSPredicate) {
      _reminderLists = FetchRequest(entity: ReminderList.entity(),
                                    sortDescriptors: [NSSortDescriptor(key: "name_", ascending: true)], predicate: predicate)
   }
   
   var body: some View {
      ForEach(reminderLists) { list in
         NavigationLink(destination: ReminderListView(list: list)) {
            ReminderListRow(list: list)
               .environment(\.editMode, editMode)
               .padding(.vertical, 3)
         }
      }
      .onDelete{ listVM.deleteList(from: reminderLists.map{ $0 }, at: $0) }
      .onMove { indexSet, index in } // TODO: Reordering
   }
}

