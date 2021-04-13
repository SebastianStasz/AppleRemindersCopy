//
//  ReminderFormView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//

import SwiftUI

struct ReminderFormView: View {
   @Environment(\.presentationMode) private var presentation
   @Environment(\.managedObjectContext) private var context
   @StateObject private var form = ReminderFormVM()
   let reminderList: ReminderList?
   let reminderToEdit: Reminder?
   
   @FetchRequest(entity: ReminderList.entity(),
                 sortDescriptors: [NSSortDescriptor(key: "name_", ascending: true)]
   ) private var reminderLists: FetchedResults<ReminderList>
   
   var body: some View {
      Form {
         TextField("Title", text: $form.reminderModel.title)
         
         if isEditing {
            TextEditor(text: $form.reminderModel.notes)
               .overlay(notesPlaceholder, alignment: .topLeading)
            
            TextField("URL", text: $form.reminderModel.url)
            
            ReminderDetailFormComponents()
         } else {
            TextEditor(text: $form.reminderModel.notes)
               .frame(height: 100).overlay(notesPlaceholder, alignment: .topLeading)
            
            Section {
               NavigationLink(destination: ReminderFormDetailView(saveChanges: saveChanges)) {
                  detailsLinkLabel
               }
            }
         }
         
         Picker("List", selection: $form.reminderModel.list) {
            ForEach(reminderLists) {
               ReminderListRow(list: $0, showRemindersCount: false)
                  .tag(Optional($0))
            }
         }
      }
      .toolbar { navigationBar }
      .embedInNavigation(mode: .inline, title: "New Reminder")
      .onAppear(perform: viewDidLoad)
      .environmentObject(form)
   }
   
   private var detailsLinkLabel: some View {
      VStack(alignment: .leading) {
         Text("Details")
         Group {
            if let date = form.dateDescription {
               form.timeDescription == nil
                  ? Text(date)
                  : Text("\(date) at \(form.timeDescription!)")
            }
         }
         .font(.caption2)
         .opacity(0.5)
      }
   }
   
   private var notesPlaceholder: some View {
      let opacity = form.reminderModel.notes.isEmpty ? 0.2 : 0
      return Text("Notes").opacity(opacity).padding(.top, 10)
   }
   
   private var navigationBar: some ToolbarContent {
      NavigationBar(cancelAction: dismiss,
                    actionText: isEditing ? "Done" : "Add",
                    action: saveChanges,
                    isValid: form.isValid)
   }
   
   // MARK: -- Intents
   
   private func viewDidLoad() {
      form.reminderToEdit = reminderToEdit
      if let list = reminderList {
         form.reminderModel.list = list
      }
      else if reminderToEdit == nil, let list = reminderLists.first {
         form.reminderModel.list = list
      }
   }
   
   private func dismiss() {
      presentation.wrappedValue.dismiss()
   }
   
   private func saveChanges() {
      form.saveChanges()
      dismiss()
   }
   
   private var isEditing: Bool {
      reminderToEdit != nil
   }
   
   // MARK: -- Initializer
   
   init(reminderToEdit: Reminder? = nil, reminderList: ReminderList? = nil) {
      self.reminderToEdit = reminderToEdit
      self.reminderList = reminderList
   }
}

// MARK: -- Preview

struct ReminderFormView_Previews: PreviewProvider {
   static var previews: some View {
      let persistence = PersistenceController.preview.container
      ReminderFormView()
         .environment(\.managedObjectContext, persistence.viewContext)
   }
}
