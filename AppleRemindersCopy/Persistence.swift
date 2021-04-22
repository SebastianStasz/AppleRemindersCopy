//
//  Persistence.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import CoreData

struct PersistenceController {
   let container: NSPersistentContainer
   
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

// MARK: -- Preview Persistence Controller

extension PersistenceController {
   
   static var preview: PersistenceController = {
      let result = PersistenceController(inMemory: true)
      let viewContext = result.container.viewContext
      
      _ = CoreDataSample.createReminders(context: viewContext)

      do {
         try viewContext.save()
      } catch {
         let nsError = error as NSError
         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      return result
   }()
}
