//
//  DateManager.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//

import Foundation

struct DateManager {
   
   static var calendar: Calendar {
      var calendar = Calendar.current
      calendar.timeZone = NSTimeZone.local
      return calendar
   }
   
   static func getTodayDateRange() -> (dateFrom: Date, dateTo: Date) {
      let calendar = Self.calendar
      let dateFrom = calendar.startOfDay(for: Date())
      let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
      return (dateFrom, dateTo!)
   }
   
   static var date: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      return formatter
   }
   
   static var time: DateFormatter {
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      return formatter
   }
   
   
   static var relativeFormatter: RelativeDateTimeFormatter {
      let formatter = RelativeDateTimeFormatter()
      formatter.dateTimeStyle = .named
      return formatter
   }
   
   static func getDaysFromNow(to date: Date) -> Int {
      let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
      let numberOfDays = components.day
      return numberOfDays!
   }
}

