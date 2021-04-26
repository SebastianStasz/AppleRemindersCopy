//
//  RemindersFiltered.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 22/04/2021.
//

import SwiftUI

struct RemindersFiltered: View {
   private let coreDataManager = CoreDataManager.shared
   @ObservedObject var searchBar: SearchBar
   
   var body: some View {
      List {
         ForEach(coreDataManager.reminderLists) { list in
            let reminders = filterRemindersForList(list)
            if !reminders.isEmpty {
               Section(header: ListHeader(list: list)) {
                  FinalReminderList(reminders: reminders)
               }
            }
         }.textCase(.none)
      }
   }
   
   private func filterRemindersForList(_ list: ReminderListEntity) -> [ReminderEntity] {
      list.reminders.filter { $0.name.lowercased().contains(searchBar.text.lowercased()) }
   }
}
