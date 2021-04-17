//
//  ReminderListFormVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import Foundation

class ReminderListFormVM: ObservableObject {
   private let context = PersistenceController.context
   var listToEdit: ReminderListEntity? {
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
   
   private func fillListInfo(_ list: ReminderListEntity) {
      list.name = name
      list.icon = icon
      list.color_ = color
   }
   
   private func createList() {
      let list = ReminderListEntity(context: context)
      list.id = UUID()
      fillListInfo(list)
   }
   
   private func fillFormForEditList(_ list: ReminderListEntity) {
      name = list.name
      icon = list.icon
      color = list.color_
   }
}
