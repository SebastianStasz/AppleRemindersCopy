//
//  ReminderFormView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//

import SwiftUI

struct ReminderFormView: View {
   @Environment(\.presentationMode) private var presentation
   @StateObject private var form = ReminderFormVM()
   @State private var alert: DiscardChangesAlert?
   @State private var isEditing = false
   
   private let coreDataManager = CoreDataManager.shared
   let options: ReminderFormOptions?
   
   var body: some View {
      Form {
         TextField("Title", text: $form.form.name)
         
         if isEditing { ReminderFormEditingView() }
         else { ReminderFormDefaultView(saveChanges: saveChanges) }
         
         ReminderFormListPicker(reminderLists: coreDataManager.reminderLists)
      }
      .toolbar { navigationBar }
      .embedInNavigation(mode: .inline, title: title)
      .onAppear(perform: viewDidLoad)
      .environmentObject(form)
      .alert(item: $alert) { $0.body }
   }
   
   private var navigationBar: some ToolbarContent {
      NavigationBar(cancelAction: close,
                    actionText: isEditing ? "Done" : "Add",
                    action: saveChanges,
                    isValid: form.isValid)
   }
   
   private var title: String {
      isEditing ? "Edit Reminder" : "New Reminder"
   }
   
   // MARK: -- Intents
   
   private func viewDidLoad() {
      switch options {
      case .edit(let reminder):
         form.reminderToEdit = reminder
         isEditing = true
      case .withList(let reminderList):
         form.reminderToEdit = nil
         form.form.list = reminderList
      case .markAsFlagged:
         form.form.isFlagged = true
         setDefaultList()
         form.reminderToEdit = nil
      case .markAsToday:
         form.form.isDateSelected = true
         setDefaultList()
         form.reminderToEdit = nil
      case .none:
         setDefaultList()
         form.reminderToEdit = nil
      }
   }
   
   private func setDefaultList() {
      if let list = coreDataManager.reminderLists.first {
         form.form.list = list
      }
   }
   
   private func saveChanges() {
      form.saveChanges()
      dismiss()
   }
   
   private func close() {
      form.formHasChanged ? presentAlert() : dismiss()
   }
   
   private func presentAlert() {
      alert = DiscardChangesAlert(presentationMode: presentation, title: title)
   }
   
   private func dismiss() {
      presentation.wrappedValue.dismiss()
   }
}


// MARK: -- Preview

struct ReminderFormView_Previews: PreviewProvider {
   static var previews: some View {
      let persistence = PersistenceController.preview.container
      ReminderFormView(options: nil)
         .environment(\.managedObjectContext, persistence.viewContext)
   }
}
