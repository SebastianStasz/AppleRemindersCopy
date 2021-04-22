//
//  CoreDataSample.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 20/04/2021.
//

import CoreData
import Foundation

struct CoreDataSample {
   
   static private func createUngroupedReminderGroup(context: NSManagedObjectContext) -> ReminderGroupEntity {
      let groupId = UserDefaults.ungroupedGroupId
      
      let ungroupedGroup = ReminderGroupEntity(context: context)
      ungroupedGroup.id = UUID(uuidString: groupId)!
      ungroupedGroup.name_ = groupId
      
      return ungroupedGroup
   }
   
   static func createReminderGroups(context: NSManagedObjectContext) -> [ReminderGroupEntity] {
      let groupRandomLists = groupNames.map { name -> ReminderGroupEntity in
         let group = ReminderGroupEntity(context: context)
         group.id = UUID()
         group.name_ = name
         return group
      }
      let groupLists = Array(Set(groupRandomLists + [createUngroupedReminderGroup(context: context)]))
      return groupLists
   }
   
   static func createReminderLists(context: NSManagedObjectContext) -> [ReminderListEntity] {
      let reminderGrpups = createReminderGroups(context: context)
      let reminderLists = listNames.map { name -> ReminderListEntity in
         let list = ReminderListEntity(context: context)
         list.id = UUID()
         list.name = name
         list.icon = ReminderIcon.allCases.randomElement()!
         list.color_ = ReminderColor.allCases.randomElement()!
         list.group = reminderGrpups.randomElement()
         return list
      }
      return reminderLists
   }
   
   static func createReminders(context: NSManagedObjectContext) -> [ReminderEntity] {
      let reminderLists = createReminderLists(context: context)
      let reminders = reminderNames.map { name -> ReminderEntity in
         let reminder = ReminderEntity(context: context)
         reminder.id = UUID()
         reminder.name = name
         reminder.createdDate_ = Date()
         reminder.date = [CoreDataSample.randomDate(), Date(), nil].randomElement()!
         reminder.notes = notes.randomElement()!
         reminder.isFlagged = [true, false].randomElement()!
         reminder.priority = Priority.allCases.randomElement()!
         reminder.repetition = Repetition.allCases.randomElement()!
         reminder.url = ["sampleurl.com", nil].randomElement()!
         reminder.list = reminderLists.randomElement()!
         return reminder
      }
      return reminders
   }
   
   static func randomDate() -> Date {
       let months = [2, 3]
       let days = Array(1...3)
       
       var components = DateComponents()
       components.day = days.randomElement()
       components.month = months.randomElement()
       components.year = 2021
       let date = Calendar.current.date(from: components)
       return date ?? Date()
   }
}

// MARK: -- Dumy Data

extension CoreDataSample {
   
   static private let groupNames = ["Main", "Important"]
   static private let listNames = ["Work", "Studies", "Personal", "This Week", "Private"]
   static private let notes = ["repellendus sunt dolores architecto voluptatum", nil]
   static private let reminderNames = ["Delectus aut autem", "Quis ut nam facilis et officia qui", "Fugiat veniam minus", "Et porro tempora", "Laboriosam mollitia", "Qui ullam ratione", "Illo expedita", "Quo adipisci enim", "Repellendus sunt", "Illo porro", "Tempora mollitia", "Qui aut autem", "Illo delectus aut", "Er tempora fugiat", "Delectus aut autem", "Quis ut nam facilis et officia qui", "Fugiat veniam minus", "Et porro tempora", "Quo adipisci enim", "Repellendus sunt", "Illo porro", "Delectus aut autem", "Quis ut nam facilis et officia qui", "Fugiat veniam minus", "Et porro tempora", "Laboriosam mollitia", "Qui ullam ratione", "Illo expedita", "Quo adipisci enim", "Repellendus sunt", "Illo porro", "Tempora mollitia", "Qui aut autem", "Illo delectus aut", "Er tempora fugiat"]
}
