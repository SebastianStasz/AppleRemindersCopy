//
//  ReminderFormDetailView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 09/04/2021.
//

import SwiftUI

struct ReminderDetailFormComponents: View {
   @EnvironmentObject private var form: ReminderFormVM
   
   var body: some View {
      ReminderFormDateSection()
      
      ReminderFormRepeatSelection()
      
      ReminderFormLocationSelection()
      
      ReminderFormMessagingSelection()
      
      ReminderFormPrioritySelection()
   }
}

struct ReminderFormDetailView: View {
   @EnvironmentObject private var form: ReminderFormVM
   let saveChanges: () -> Void
   
    var body: some View {
      VStack {
         Form {
            ReminderDetailFormComponents()
            
            TextField("URL", text: $form.reminderModel.url)
         }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: addButton)
      .navigationTitle("Details")
    }
   
   private var addButton: some View {
      Button("Add") { saveChanges() }
         .disabled(!form.isValid)
   }
}

// MARK: -- Preview

struct ReminderFormDetailView_Previews: PreviewProvider {
    static var previews: some View {
      let form = ReminderFormVM()
      NavigationView {
         NavigationLink(destination: ReminderFormDetailView(saveChanges: {}),
                        isActive: .constant(true))
         {
            Text("Go")
         }
      }
      .environmentObject(form)
      .preferredColorScheme(.dark)
    }
}

