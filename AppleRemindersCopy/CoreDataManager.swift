//
//  CoreDataManager.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 16/04/2021.
//

import CoreData
import Foundation

struct CoreDataManager {
   static let shared = CoreDataManager()
   private init() {}
   
   private let persistence = PersistenceController.preview
   
   var context: NSManagedObjectContext {
      persistence.container.viewContext
   }
   
   func save() {
      guard context.hasChanges else { return }
      do {
         try context.save()
         print("Context saved successfuly!")
      } catch {
         print("Error when saving context: \(error)")
      }
   }
   
   func delete(_ object: NSManagedObject) {
      context.delete(object)
      save()
   }
   
}
