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
   var reminderList: ReminderListEntity?
}

enum ActiveSheet: Identifiable {
   case addReminder(ReminderEntity?, ReminderListEntity?)
   case addList(ReminderListEntity?)
   case addGroup(ReminderGroupEntity?)
   
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
