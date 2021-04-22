//
//  ReminderListFormVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import Combine
import Foundation

struct ListForm {
   var name = ""
   var color: ReminderColor = .blue
   var icon: ReminderIcon = .listBullet
}

class ReminderListFormVM: ObservableObject {
   private var cancellable: Set<AnyCancellable> = []
   private let coreData = CoreDataManager.shared
   var listToEdit: ReminderListEntity? { didSet { fillFormForEditList() } }
   
   @Published var form = ListForm()
   @Published var hasChanged = false
   var isValid: Bool { !form.name.isEmpty }
   
   func saveChanges() {
      let isEditing = listToEdit != nil
      isEditing ? fillListInfo(listToEdit!) : createList()
   }
   
   private func fillListInfo(_ list: ReminderListEntity) {
      list.name = form.name
      list.icon = form.icon
      list.color_ = form.color
   }
   
   private func createList() {
      let list = ReminderListEntity(context: coreData.context)
      list.id = UUID()
      list.group = coreData.ungroupedGroup
      fillListInfo(list)
   }
   
   private func fillFormForEditList() {
      if let list = listToEdit {
         form.name = list.name
         form.icon = list.icon
         form.color = list.color_
      }
      lookForChanges()
   }
   
   private func lookForChanges() {
      $form.dropFirst()
         .sink { [weak self] _ in self?.hasChanged = true}
         .store(in: &cancellable)
   }
}
