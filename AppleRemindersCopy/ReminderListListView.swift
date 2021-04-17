//
//  ReminderListListView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 04/04/2021.
//

import SwiftUI

struct ReminderListListView: View {
   @Environment(\.editMode) private var editMode
   @EnvironmentObject private var sheet: SheetController
   
   @FetchRequest(entity: ReminderGroupEntity.entity(),
                 sortDescriptors: [ReminderGroupEntity.sortByName]
   ) private var reminderGroups: FetchedResults<ReminderGroupEntity>
   
   @FetchRequest(entity: ReminderListEntity.entity(),
                 sortDescriptors: [ReminderListEntity.sortByName],
                 predicate: ReminderGroupEntity.filterWithoutGroups
   ) private var ungroupedLists: FetchedResults<ReminderListEntity>

   var body: some View { 
      List {
         Section(header: listHeader) {
            ForEach(reminderGroups) { group in
               DisclosureGroup {
                  ReminderListList(reminderLists: group.list)
               }
               label: {
                  DisclosureGroupLabel(group).environment(\.editMode, editMode)
               }
            }
            .onDelete(perform: delete)
            .onMove { indexSet, index in } // TODO: Reordering
            
            ReminderListList(reminderLists: ungroupedLists.map {$0})
         }
      }
      .listStyle(InsetGroupedListStyle())
   }
   
   private var listHeader: some View {
      Text("My Lists")
         .foregroundColor(.primary)
         .font(.title2).bold()
         .padding(.leading, 7)
   }
   
   private func delete(at indexSet: IndexSet) {
      let index = indexSet.map{ $0 }.first!
      let group = reminderGroups[index]
      CoreDataManager.shared.delete(group)
   }
}


// MARK: -- Preview

struct ReminderListListView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationView {
         ReminderListListView()
      }
   }
}


