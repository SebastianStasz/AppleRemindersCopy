//
//  ListCreatingVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import Foundation

class ListCreatingVM: ObservableObject {
   private let context = PersistenceController.context
   var listToEdit: ReminderList? {
      didSet { fillFormForEditList(listToEdit!) }
   }
   @Published var name = ""
   @Published var color: ReminderColor = .blue
   @Published var icon: ReminderIcon = .listBullet
   
   var isValid: Bool {
      !name.isEmpty
   }
   
   func saveChanges() {
      let isEditing = listToEdit != nil
      isEditing ? fillListInfo(listToEdit!) : createList()
   }
   
   private func fillListInfo(_ list: ReminderList) {
      list.name = name
      list.icon = icon
      list.color = color
   }
   
   private func createList() {
      let list = ReminderList(context: context)
      list.id = UUID()
      fillListInfo(list)
   }
   
   private func fillFormForEditList(_ list: ReminderList) {
      name = list.name
      icon = list.icon
      color = list.color
   }
}
