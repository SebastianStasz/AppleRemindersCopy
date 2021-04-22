//
//  ReminderListListView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 04/04/2021.
//

import SwiftUI

struct ReminderListListView: View {
   @Environment(\.managedObjectContext) private var context
   @EnvironmentObject private var sheet: SheetController
   @StateObject private var reminderListsVM = ReminderListListVM(coreDataManager: CoreDataManager.shared)

   var body: some View {
      if reminderListsVM.isEmpty {
         EmptyListView().padding(.top, 100)
      } else {
         List {
            Section(header: listHeader) {
               ReminderGroupList(reminderGroupsVM: reminderListsVM)
               ReminderListList(reminderLists: reminderListsVM.ungroupedGroup.list)
            }
         }
         .listStyle(InsetGroupedListStyle())
      }
   }

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
      NavigationView {
         ReminderListListView()
      }
   }
}


