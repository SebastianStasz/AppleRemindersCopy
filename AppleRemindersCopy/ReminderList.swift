//
//  ReminderList.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 16/04/2021.
//

import SwiftUI

// MARK: -- Main ReminderList

struct FinalReminderList: View {
   private let notificationManager = NotificationManager.shared
   @State private var selectedReminder: ReminderEntity?
   let reminders: [ReminderEntity]
   let showListName: Bool
   let showTimeOnly: Bool
   
   init(reminders: [ReminderEntity], showListName: Bool = false, showTimeOnly: Bool = false) {
      self.reminders = reminders
      self.showListName = showListName
      self.showTimeOnly = showTimeOnly
   }
   
   var body: some View {
      ForEach(reminders) { reminder in
         ReminderRow(reminder: reminder, selectedReminder: $selectedReminder, dateOptions: dateOptions, showListName: showListName)
      }
      .onDelete(perform: delete)
   }
   
   private func delete(at indexSet: IndexSet) {
      let index = indexSet.map { $0 }.first!
      let reminder = reminders[index]
      print("Deleting reminder")
      NotificationManager.shared.deleteNotification(withId: reminder.id_)
      CoreDataManager.shared.delete(reminder)
   }
   
   private var dateOptions: DateDescriptionView.Options {
      return showTimeOnly ? .time : .dateAndTime
   }
}

// MARK: -- ReminderList embeded in List

struct ReminderListWithList: View {
   let reminders: [ReminderEntity]
   let showListName: Bool
   
   init(reminders: [ReminderEntity], showListName: Bool = false) {
      self.reminders = reminders
      self.showListName = showListName
   }
   
   var body: some View {
      if reminders.isEmpty { NoRemindersMessage() }
      else {
         List {
            FinalReminderList(reminders: reminders, showListName: showListName)
         }
      }
   }
}

// MARK: -- ReminerList by Fetching reminders

struct ReminderListFetch: View {
   @FetchRequest private var reminders: FetchedResults<ReminderEntity>
   
   init(list: ReminderListEntity) {
      _reminders = FetchRequest(entity: ReminderEntity.entity(),
                                sortDescriptors: [ReminderEntity.sortByCreatedDate],
                                predicate: NSPredicate(format: "list == %@", list))
   }
   
   var body: some View {
      ReminderListWithList(reminders: reminders.map{$0})
   }
}
