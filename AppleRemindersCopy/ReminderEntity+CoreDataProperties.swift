//
//  ReminderEntity+CoreDataProperties.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 15/04/2021.
//
//

import Foundation
import CoreData


extension ReminderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderEntity> {
        return NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var endRepetitionDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isFlagged: Bool
    @NSManaged public var isTimeSelected: Bool
    @NSManaged public var name_: String?
    @NSManaged public var notes: String?
    @NSManaged public var priority: Priority
    @NSManaged public var repetition: Repetition
    @NSManaged public var url: String?
    @NSManaged public var list: ReminderListEntity

}

extension ReminderEntity : Identifiable {

}
