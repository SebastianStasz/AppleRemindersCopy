//
//  ReminderListVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 09/04/2021.
//

import Foundation
import SwiftUI

class ReminderListVM: ObservableObject {
   private let context = PersistenceController.context
   
   func deleteGroup(from list: FetchedResults<ReminderGroup>, at indexSet: IndexSet) {
      let index = indexSet.map{ $0 }.first!
      let list = list[index]
      context.delete(list)
   }
   
   func deleteList(from list: [ReminderList], at indexSet: IndexSet) {
      let index = indexSet.map{ $0 }.first!
      let list = list[index]
      context.delete(list)
   }
}
