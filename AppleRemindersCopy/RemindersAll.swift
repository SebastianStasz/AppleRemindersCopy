//
//  RemindersSortedByList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import SwiftUI

struct RemindersAll: View {
   @FetchRequest(entity: ReminderListEntity.entity(),
                 sortDescriptors: [ReminderListEntity.sortByName]
   ) private var reminderLists: FetchedResults<ReminderListEntity>
   
   private var count: Int {
      Int(reminderLists.map { $0.remindersCount }.reduce(0, +))
   }
   
   var body: some View {
      List {
         if !reminderLists.isEmpty { list }
         else { NoRemindersMessage() }
      }
   }
   
   private var list: some View {
      ForEach(reminderLists) { list in
         Section(header: ListHeader(list: list)) {
            ReminderListWithState(config: .byList(list))
         }
      }
      .textCase(nil)
   }
}
