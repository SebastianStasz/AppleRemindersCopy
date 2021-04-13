//
//  ReminderList+CoreDataProperties.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//
//

import Foundation
import CoreData


extension ReminderList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderList> {
        return NSFetchRequest<ReminderList>(entityName: "ReminderList")
    }

    @NSManaged public var color: ReminderColor
    @NSManaged public var icon: ReminderIcon
    @NSManaged public var remindersCount: Int64
    @NSManaged public var name_: String?
    @NSManaged public var id: UUID?
    @NSManaged public var group: ReminderGroup?
    @NSManaged public var reminders_: NSSet?

}

// MARK: Generated accessors for reminders
extension ReminderList {

    @objc(addRemindersObject:)
    @NSManaged public func addToReminders(_ value: Reminder)

    @objc(removeRemindersObject:)
    @NSManaged public func removeFromReminders(_ value: Reminder)

    @objc(addReminders:)
    @NSManaged public func addToReminders(_ values: NSSet)

    @objc(removeReminders:)
    @NSManaged public func removeFromReminders(_ values: NSSet)

}

extension ReminderList : Identifiable {

}
