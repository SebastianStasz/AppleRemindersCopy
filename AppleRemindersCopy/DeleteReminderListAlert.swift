//
//  DeleteReminderListAlert.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 21/04/2021.
//

import Foundation
import SwiftUI

struct DeleteReminderListAlert: Identifiable {
   let id = UUID()
   let list: ReminderListEntity
   
   var body: Alert {
      Alert(title: title, message: message, primaryButton: deleteListBtn, secondaryButton: .cancel())
   }
   
   private var deleteListBtn: Alert.Button {
      .destructive(Text("Delete")) { CoreDataManager.shared.delete(list) }
   }
   
   private var title: Text { Text("Delete \"\(list.name)\"?") }
   private let message = Text("This will delete all reminders in this list.")
}
