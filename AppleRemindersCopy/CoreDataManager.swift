//
//  CoreDataManager.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 19/04/2021.
//

import Combine
import CoreData
import Foundation

class CoreDataManager: NSObject, ObservableObject {
   private var cancellable: Set<AnyCancellable> = []
   static let shared = CoreDataManager()
   
   private let groupsController: NSFetchedResultsController<ReminderGroupEntity>
   private let persistence: PersistenceController
   let context: NSManagedObjectContext
   
   override init() {
      persistence = PersistenceController.preview /// Preview Context
//      persistence = PersistenceController() /// Real Context
      context = persistence.container.viewContext
      let request: NSFetchRequest<ReminderGroupEntity> = ReminderGroupEntity.fetchRequest()
      request.sortDescriptors = [ReminderGroupEntity.sortByName]
      
      groupsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context,
                                                    sectionNameKeyPath: nil, cacheName: nil)
      super.init()
      groupsController.delegate = self
      groupsPerformFetch()
      saveContextPublisher()
   }
   
   // MARK: -- Acces
   
   @Published private(set) var all: [ReminderGroupEntity] = []
   
   var ungroupedGroup: ReminderGroupEntity {
      let group = all.filter { $0.id?.uuidString == UserDefaults.ungroupedGroupId }.first
      guard let ungroupedGroup = group else {
         return createUngroupedReminderGroup()
      }
      return ungroupedGroup
   }
   
   func delete(_ object: NSManagedObject) {
      context.delete(object)
   }
   
   // MARK: -- Logic
   
   private func createUngroupedReminderGroup() -> ReminderGroupEntity {
      let groupId = UserDefaults.ungroupedGroupId
      let group = ReminderGroupEntity(context: context)
      group.id = UUID(uuidString: groupId)!
      group.name = groupId
      return group
   }
   
   private func saveContextPublisher() {
      NotificationCenter.default
         .publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
         .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
         .sink { [weak self] notification in self?.save() }
         .store(in: &cancellable)
   }
   
   private func save() {
      context.perform { [weak self] in
         do {
            try self?.context.save()
            print("Context saved successfuly!")
         } catch {
            print("Error when saving context: \(error)")
         }
      }
   }
}

// MARK: -- Fetch Result Controller

extension CoreDataManager: NSFetchedResultsControllerDelegate {
   
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      guard let reminderGroups = controller.fetchedObjects as? [ReminderGroupEntity] else { return }
      all = reminderGroups
   }
   
   func groupsPerformFetch() {
      do {
         try groupsController.performFetch()
         all = groupsController.fetchedObjects ?? []
      } catch {
         print("\nCurrencyManager: failed to fetch currencies\n")
      }
   }
}
