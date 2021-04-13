//
//  SheetController.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import Foundation
import SwiftUI

class SheetController: ObservableObject {
   @Published var activeSheet: ActiveSheet? = nil
   var reminderList: ReminderList?
}

enum ActiveSheet: Identifiable {
   case addReminder(Reminder?, ReminderList?)
   case addList(ReminderList?)
   case addGroup(ReminderGroup?)
   
   var sheetView: some View {
      Group {
         switch self {
         case .addReminder(let reminder, let list):
            ReminderFormView(reminderToEdit: reminder, reminderList: list)
         case .addList(let list):
            ListCreatingView(listToEdit: list)
         case .addGroup(let group):
            ReminderGroupFormView(group: group)
         }
      }
   }
   
   var id: Int {
      switch self {
      case .addReminder: return 0
      case .addList: return 1
      case .addGroup: return 2
      }
   }
}
