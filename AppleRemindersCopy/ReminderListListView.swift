//
//  ReminderListListView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 04/04/2021.
//

import SwiftUI

struct ReminderListListView: View {
   @Environment(\.managedObjectContext) private var context
   @Environment(\.editMode) private var editMode
   @EnvironmentObject private var sheet: SheetController
   @StateObject private var listVM = ReminderListVM()

   var body: some View { 
      List {
         Section(header: listHeader) {
            reminderGroupList
            ReminderListList(predicate: NSPredicate(format: "group == nil"))
         }
      }
      .listStyle(InsetGroupedListStyle())
      .environmentObject(listVM)
   }
   
   private var reminderGroupList: some View {
      ForEach(reminderGroupData) { group in
         DisclosureGroup {
            ReminderListList(predicate: NSPredicate(format: "group == %@", group))
         }
         label: {
            DisclosureGroupLabel(group)
               .environment(\.editMode, editMode)
         }
      }
      .onDelete{ listVM.deleteGroup(from: reminderGroupData, at: $0) }
      .onMove { indexSet, index in } // TODO: Reordering
   }

   // MARK: -- Fetch Data
   
   @FetchRequest(entity: ReminderGroup.entity(),
                 sortDescriptors: [NSSortDescriptor(key: "name_", ascending: true)]
   ) private var reminderGroupData: FetchedResults<ReminderGroup>
   
//   @FetchRequest(entity: ReminderList.entity(),
//                 sortDescriptors: [NSSortDescriptor(key: "name_", ascending: true)],
//                 predicate: NSPredicate(format: "group == nil")
//   ) private var reminderListData: FetchedResults<ReminderList>
   
   // MARK: -- List Header
   
   private var listHeader: some View {
      Text("My Lists")
         .foregroundColor(.primary)
         .font(.title2).bold()
         .padding(.leading, 7)
   }
}


// MARK: -- Preview

struct ReminderListListView_Previews: PreviewProvider {
   static var previews: some View {
      let persistence = PersistenceController.preview.container
      NavigationView {
         ReminderListListView()
      }
      .environment(\.managedObjectContext, persistence.viewContext)
   }
}


