//
//  SheetController.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import Foundation
import SwiftUI

enum ReminderFormOptions {
   case edit(reminder: ReminderEntity)
   case withList(ReminderListEntity)
   case markAsFlagged
   case markAsToday
}

class SheetController: ObservableObject {
   @Published var activeSheet: ActiveSheet? = nil
   @Published var activeActionSheet: ActiveActionSheet? = nil
   
   var reminderList: ReminderListEntity?
   var markAsFlagged: Bool = false
   var markAsToday: Bool = false
   
   func restoreToDefaults() {
      reminderList = nil
      markAsFlagged = false
      markAsToday = false
   }
}

enum ActiveActionSheet: Identifiable {
   case deleteGroup(ReminderListListVM, ReminderGroupEntity)
   
   var view: ActionSheet {
      switch self {
      case .deleteGroup(let viewModel, let group):
         return DeleteGroupActionSheet(reminderGroupsVM: viewModel, group: group).sheet
      }
   }
   
   var id: Int {
      switch self {
      case .deleteGroup: return 0
      }
   }
}

indirect enum ActiveSheet: Identifiable {
   case addReminder(options: ReminderFormOptions?)
   case addList(ReminderListEntity?, ActiveSheet?)
   case addGroup(ReminderGroupEntity?)
   
   var sheetView: some View {
      Group {
         switch self {
         case .addReminder(let options):
            ReminderFormView(options: options)
         case .addList(let list, let sheetToOpen):
            ReminderListFormView(listToEdit: list, sheetToOpenAfterDismiss: sheetToOpen)
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
