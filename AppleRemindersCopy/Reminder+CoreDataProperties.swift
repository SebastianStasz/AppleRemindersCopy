//
//  Reminder+CoreDataProperties.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//
//

import Foundation
import CoreData


extension Reminder {
   
   @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
      return NSFetchRequest<Reminder>(entityName: "Reminder")
   }
   
   @NSManaged public var date: Date?
   @NSManaged public var endRepetitionDate: Date?
   @NSManaged public var id: UUID?
   @NSManaged public var isFlagged: Bool
   @NSManaged public var name_: String?
   @NSManaged public var notes: String?
   @NSManaged public var priority: Priority
   @NSManaged public var repetition: Repetition
   @NSManaged public var url: String?
   @NSManaged public var isCompleted: Bool
   @NSManaged public var isTimeSelected: Bool
   @NSManaged public var list: ReminderList
   
}

extension Reminder : Identifiable {
   
}
