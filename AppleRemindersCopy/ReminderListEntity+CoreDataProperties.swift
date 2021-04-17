//
//  ReminderListEntity+CoreDataProperties.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 15/04/2021.
//
//

import Foundation
import CoreData


extension ReminderListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderListEntity> {
        return NSFetchRequest<ReminderListEntity>(entityName: "ReminderListEntity")
    }

    @NSManaged public var color_: ReminderColor
    @NSManaged public var icon: ReminderIcon
    @NSManaged public var id: UUID?
    @NSManaged public var name_: String?
    @NSManaged public var remindersCount: Int64
    @NSManaged public var group: ReminderGroupEntity?
    @NSManaged public var reminders_: NSSet?

}

// MARK: Generated accessors for reminders_
extension ReminderListEntity {

    @objc(addReminders_Object:)
    @NSManaged public func addToReminders_(_ value: ReminderEntity)

    @objc(removeReminders_Object:)
    @NSManaged public func removeFromReminders_(_ value: ReminderEntity)

    @objc(addReminders_:)
    @NSManaged public func addToReminders_(_ values: NSSet)

    @objc(removeReminders_:)
    @NSManaged public func removeFromReminders_(_ values: NSSet)

}

extension ReminderListEntity : Identifiable {

}
