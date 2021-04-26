//
//  Calendar+Extensions.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 10/04/2021.
//

import Foundation

extension Calendar {
   func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
      let fromDate = startOfDay(for: from)
      let toDate = startOfDay(for: to)
      let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
      
      return numberOfDays.day!
   }
   
   /// Return number of minutes between specified dates.
   func numberOfMinutesBetween(_ from: Date, and to: Date) -> Int {
      let dateFromMinutes = Calendar.current.component(.minute, from: from)
      let dateToMinutes = Calendar.current.component(.minute, from: to)
      let numberOfMinutes = dateFromMinutes - dateToMinutes
      return numberOfMinutes
   }
}
