//
//  RemindersSortedByList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import SwiftUI

struct RemindersSortedByList: View {
   @Environment(\.managedObjectContext) private var context
   @FetchRequest(entity: ReminderList.entity(), sortDescriptors: []
   ) private var reminderListData: FetchedResults<ReminderList>
   
   var body: some View {
      if !reminderListData.isEmpty { list }
      else { NoRemindersMessage() }
   }
   
   private var list: some View {
      ForEach(reminderListData) { list in
         Section(header: ListHeader(list: list)) {
            RemindersByFetch(predicate: getPredicate(for: list), showListName: false)
               .padding(.bottom, 5)
         }
         .textCase(nil)
      }
   }
   
   private func getPredicate(for list: ReminderList) -> NSPredicate {
      NSPredicate(format: "isCompleted == NO AND list == %@", list)
   }
   
   private var listHeader: some View {
      Text("My Lists")
         .foregroundColor(.primary)
         .font(.title2).bold()
         .padding(.leading, 7)
   }
}
