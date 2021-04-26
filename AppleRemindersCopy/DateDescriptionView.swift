//
//  DateDescriptionView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 22/04/2021.
//

import SwiftUI

struct DateDescriptionView: View {
   let date: Date
   let options: Options
   
   private var isSpecifiedTime: Bool { options != .date }
   
   private var isMissed: Bool {
      return DateManager.isDateMissed(date, byTime: isSpecifiedTime)
   }
   
   private var dateDescription: String {
      let dateDescription = DateManager.getDateDescription(for: date)
      return dateDescription
   }
   
   private var timeDescription: String? {
      guard isSpecifiedTime else { return nil }
      return DateManager.time.string(for: date)
   }
   
   var body: some View {
      Group {
         if timeDescription != nil { timeDescriptionView }
         else { Text(dateDescription) }
      }
      .foregroundColor(isMissed ? .systemRed : .gray)
   }
   
   private var timeDescriptionView: some View {
      Group {
         if options == .time {
            Text(timeDescription!)
         } else {
            Text("\(dateDescription) at \(timeDescription!)")
         }
      }
   }
}

extension DateDescriptionView {
   enum Options {
      case dateAndTime
      case time
      case date
   }
}

extension DateDescriptionView {
   
   init?(reminder: ReminderEntity, options: DateDescriptionView.Options = .dateAndTime) {
      guard let date = reminder.date, reminder.isTimeSelected || options != .time else {
         return nil
      }
      
      self.date = date
      self.options = reminder.isTimeSelected ? options : .date
   }
}


// MARK: -- Preview

struct DateDescriptionView_Previews: PreviewProvider {
   static var previews: some View {
      DateDescriptionView(date: Date(), options: .dateAndTime)
   }
}
