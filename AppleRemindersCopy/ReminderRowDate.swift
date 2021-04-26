//
//  ReminderRowDate.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 23/04/2021.
//

import SwiftUI

struct ReminderRowDate: View {
   @EnvironmentObject var reminder: ReminderEntity
   let dateOptions: DateDescriptionView.Options
   let isListNameShown: Bool
   
    var body: some View {
      HStack(spacing: 2) {
         if isListNameShown { Text(reminder.list.name) }
         
         if isDashPresented { Text("-") }
         
         DateDescriptionView(reminder: reminder, options: dateOptions)
         
         if let repetition = repetition { Text(", \(repetition)") }
      }
    }
   
   private var isDashPresented: Bool {
      reminder.date != nil && isListNameShown && (reminder.isTimeSelected || dateOptions != .time)
   }
   
   private var repetition: String? {
      let repetition = reminder.repetition
      return repetition != .never ? repetition.name : nil
   }
}


// MARK: -- Preview

struct ReminderRowDate_Previews: PreviewProvider {
    static var previews: some View {
      let context = PersistenceController.preview.container.viewContext
      let reminder = CoreDataSample.createReminders(context: context).first!
      ReminderRowDate(dateOptions: .dateAndTime, isListNameShown: true)
         .environmentObject(reminder)
    }
}
