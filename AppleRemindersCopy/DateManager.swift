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
      calendar.locale = Locale.current
      calendar.timeZone = NSTimeZone.local
      return calendar
   }
   
   static var date: DateFormatter {
      let formatter = DateFormatter()
      formatter.locale = Locale.current
      formatter.dateStyle = .medium
      return formatter
   }
   
   static var time: DateFormatter {
      let formatter = DateFormatter()
      formatter.locale = Locale.current
      formatter.timeStyle = .short
      return formatter
   }
   
   static var relativeFormatter: RelativeDateTimeFormatter {
      let formatter = RelativeDateTimeFormatter()
      formatter.locale = Locale.current
      formatter.dateTimeStyle = .named
      return formatter
   }
   
   static func getTodayDateRange() -> (dateFrom: Date, dateTo: Date) {
      let calendar = Self.calendar
      let today = calendar.startOfDay(for: Date())
      let dateFrom = calendar.date(byAdding: .hour, value: 2, to: today)!
      let dateTo = calendar.date(byAdding: .hour, value: 24, to: dateFrom)!
//      print(dateFrom)
//      print(dateTo)
      return (dateFrom, dateTo)
   }
   
   static func getDaysFromNow(to date: Date) -> Int {
      let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
      let numberOfDays = components.day
      return numberOfDays!
   }
}

