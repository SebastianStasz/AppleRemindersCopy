//
//  ReminderForm.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 23/04/2021.
//

import Foundation

struct ReminderForm {
   var name = ""
   var notes = ""
   var url = ""
   var date = Date()
   var isFlagged = false
   var list: ReminderListEntity?
   var priority: Priority = .none
   var repetition: Repetition = .never
   var endRepetition: EndRepetition = .never
   var endRepetitionDate = Date()
   
   var isDateSelected = false {
      willSet {
         if isDateSelected == false { date = Date() }
      }
   }
   var isTimeSelected = false
}

extension ReminderForm {
   mutating func fill(by reminder: ReminderEntity) {
      self.name = reminder.name
      self.isFlagged = reminder.isFlagged
      self.list = reminder.list
      self.priority = reminder.priority
      self.repetition = reminder.repetition
      self.isTimeSelected = reminder.isTimeSelected
      
      if let endRepetitionDate = reminder.endRepetitionDate {
         self.endRepetition = .date
         self.endRepetitionDate = endRepetitionDate
      }
      
      if let date = reminder.date {
         isDateSelected = true
         self.date = date
      }
      
      if let notes = reminder.notes {
         self.notes = notes
      }
      
      if let url = reminder.url {
         self.url = url
      }
   }
}
