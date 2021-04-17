//
//  Persistence.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import CoreData

struct PersistenceController {
   static let shared = PersistenceController()
   
   static let context = PersistenceController.preview.container.viewContext
   
   let container: NSPersistentContainer
   
   static var preview: PersistenceController = {
      let result = PersistenceController(inMemory: true)
      let viewContext = result.container.viewContext
      
      let listNames = ["Work", "Studies", "Personal", "This Week", "Private"]
      var reminderLists: [ReminderListEntity] = []
      
      for index in listNames.indices {
         let list = ReminderListEntity(context: viewContext)
         list.id = UUID()
         list.name = listNames[index]
         list.icon = ReminderIcon.allCases.randomElement()!
         list.color_ = ReminderColor.allCases.randomElement()!
         list.reminders_ = []
         list.group = nil

         reminderLists.append(list)
      }

      let groupNames = ["Main", "Important"]
      var groupLists: [ReminderGroupEntity] = []

      for name in groupNames {
         let group = ReminderGroupEntity(context: viewContext)
         group.id = UUID()
         group.name_ = name
         group.list_ = []
         groupLists.append(group)
      }

      groupLists[0].list_ = [reminderLists[0]]
      groupLists[1].list_ = [reminderLists[1], reminderLists[2]]

      let reminderNames = ["Delectus aut autem", "Quis ut nam facilis et officia qui", "Fugiat veniam minus", "Et porro tempora", "Laboriosam mollitia", "Qui ullam ratione", "Illo expedita", "Quo adipisci enim", "Repellendus sunt", "Illo porro", "Tempora mollitia", "Qui aut autem", "Illo delectus aut", "Er tempora fugiat", "Delectus aut autem", "Quis ut nam facilis et officia qui", "Fugiat veniam minus", "Et porro tempora", "Quo adipisci enim", "Repellendus sunt", "Illo porro", "Delectus aut autem", "Quis ut nam facilis et officia qui", "Fugiat veniam minus", "Et porro tempora", "Laboriosam mollitia", "Qui ullam ratione", "Illo expedita", "Quo adipisci enim", "Repellendus sunt", "Illo porro", "Tempora mollitia", "Qui aut autem", "Illo delectus aut", "Er tempora fugiat"]
      let notes = ["repellendus sunt dolores architecto voluptatum", nil]

      var reminders: [ReminderEntity] = []

      for name in reminderNames {
         let reminder = ReminderEntity(context: viewContext)
         reminder.id = UUID()
         reminder.name = name
         reminder.date = [CoreDataSample.randomDate(), Date(), nil].randomElement()!
         reminder.notes = notes.randomElement()!
         reminder.isFlagged = [true, false].randomElement()!
         reminder.priority = Priority.allCases.randomElement()!
         reminder.repetition = Repetition.allCases.randomElement()!
         reminder.url = ["sampleurl.com", nil].randomElement()!
         reminder.list = reminderLists.randomElement()!
         reminders.append(reminder)
      }

      do {
         try viewContext.save()
      } catch {
         let nsError = error as NSError
         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      return result
   }()
   
   init(inMemory: Bool = false) {
      container = NSPersistentContainer(name: "AppleRemindersCopy")
      if inMemory {
         container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
      }
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      })
   }
}

// MARK: -- Sample Data

struct CoreDataSample {

   static func createSampleGroupLists() -> [ReminderGroupEntity] {
      let groupNames = ["Main", "Important"]
      var groupList: [ReminderGroupEntity] = []
      
      for name in groupNames {
         let group = ReminderGroupEntity(context: PersistenceController.preview.container.viewContext)
         group.id = UUID()
         group.name_ = name
         group.list_ = []
         groupList.append(group)
      }
      
      return groupList
   }
   
   static func createSampleReminderLists() -> [ReminderListEntity] {
      let listNames = ["Work", "Studies", "Personal", "This Week", "Private"]
      var reminderLists: [ReminderListEntity] = []
      var reminderGroups: [ReminderGroupEntity?] = Self.createSampleGroupLists()
      reminderGroups.append(nil)
      
      for index in listNames.indices {
         let list = ReminderListEntity(context: PersistenceController.preview.container.viewContext)
         list.id = UUID()
         list.name = listNames[index]
         list.icon = ReminderIcon.allCases.randomElement()!
         list.color_ = ReminderColor.allCases.randomElement()!
         list.reminders_ = []
         list.group = reminderGroups.randomElement()!
         
         reminderLists.append(list)
      }
      
      return reminderLists
   }
   
   static func createReminders() -> [ReminderEntity] {
      let reminderNames = ["delectus aut autem", "quis ut nam facilis et officia qui", "fugiat veniam minus", "et porro tempora", "laboriosam mollitia", "qui ullam ratione", "illo expedita", "quo adipisci enim", "repellendus sunt"]
      let notes = ["repellendus sunt dolores architecto voluptatum", nil]
      
      let reminerLists = Self.createSampleReminderLists()
      var reminders: [ReminderEntity] = []
      
      for name in reminderNames {
         let reminder = ReminderEntity(context: PersistenceController.preview.container.viewContext)
         reminder.id = UUID()
         reminder.name = name
         reminder.date = Date()
         reminder.notes = notes.randomElement()!
         reminder.isFlagged = [true, false].randomElement()!
         reminder.priority = Priority.allCases.randomElement()!
         reminder.repetition = Repetition.allCases.randomElement()!
         reminder.url = ["sampleurl.com", nil].randomElement()!
         reminder.list = reminerLists[4]
         reminders.append(reminder)
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
