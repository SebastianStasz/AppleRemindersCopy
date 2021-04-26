//
//  DateManager.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//

import Foundation

struct DateManager {
   
   // MARK: -- Helpers
   
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
   
   // MARK: -- Fuctions
   
   static func getDateRange(for date: Date) -> (dateStart: Date, dateEnd: Date) {
      let calendar = Self.calendar
      let date = calendar.startOfDay(for: date)
      let dateStart = calendar.date(byAdding: .hour, value: 2, to: date)!
      let dateEnd = calendar.date(byAdding: .hour, value: 24, to: dateStart)!
      return (dateStart, dateEnd)
   }
   
   static func getDaysFromNow(to date: Date) -> Int {
      let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
      let numberOfDays = components.day
      return numberOfDays!
   }
   
   static func getDateDescription(for date: Date) -> String {
      let daysFromToday = calendar.numberOfDaysBetween(Date(), and: date)
      return abs(daysFromToday) < 3
         ? relativeFormatter.localizedString(from: DateComponents(day: daysFromToday)).capitalized
         : self.date.string(for: date)!
   }
   
   static func isDateMissed(_ date: Date, byTime: Bool) -> Bool {
      guard !byTime else { return date < Date() }
      return Calendar.current.numberOfDaysBetween(date, and: Date()) > 0
   }
   
   static func getNextDate(for date: Date, repetition: Repetition) -> Date {
      var newDate: Date? = Date()
      switch repetition {
      case .never:
         break
      case .daily:
         newDate = calendar.date(byAdding: .day, value: 1, to: date)
      case .weekly:
         newDate = calendar.date(byAdding: .day, value: 7, to: date)
      case .fortnightly:
         newDate = calendar.date(byAdding: .day, value: 14, to: date)
      case .monthly:
         newDate = calendar.date(byAdding: .month, value: 1, to: date)
      case .every3Months:
         newDate = calendar.date(byAdding: .month, value: 3, to: date)
      case .every6Months:
         newDate = calendar.date(byAdding: .month, value: 6, to: date)
      case .yearly:
         newDate = calendar.date(byAdding: .year, value: 1, to: date)
      }
      return newDate!
   }
}

