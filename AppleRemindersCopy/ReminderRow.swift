//
//  ReminderRow.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import Combine
import SwiftUI

struct ReminderRow: View {
   @EnvironmentObject private var sheet: SheetController
   @StateObject private var reminderVM = ReminderRowVM()
   @Binding var selectedReminder: ReminderEntity?
   @ObservedObject var reminder: ReminderEntity
   let isListNameShown: Bool
   
   init(reminder: ReminderEntity, selectedReminder: Binding<ReminderEntity?>, showListName: Bool = false) {
      self.reminder = reminder
      _selectedReminder = selectedReminder
      isListNameShown = showListName
   }
   
   var body: some View {
      HStack {
         HStack(spacing: 15) {
            Button { reminderVM.isCompleted.toggle() } label: {}
               .buttonStyle(CheckMarkButtonStyle(isCompleted: reminderVM.isCompleted, color: reminder.listColor))
            
            VStack(alignment: .leading, spacing: 6) {
               TextField("", text: $reminderVM.name) { isFocused in
                  isFocused ? selectionStarted() : selectionEnded()
               }
               
               if isListNameShown {
                  Text(reminder.list.name).foregroundColor(.gray)
               }
            }
         }
         
         Spacer()
         
         if reminder.isFlagged {
            Image(systemName: "flag.fill")
               .font(.subheadline)
               .foregroundColor(.systemOrange)
               .padding(.trailing)
         }
         
         if selectedReminder == reminder { detailsButton }
      }
      .padding(.top, 5)
      .onAppear(perform: updateViewModel)
      .onChange(of: reminder.name) { _ in updateViewModel() }
   }

   private var detailsButton: some View {
      Label("Show details", systemImage: "info.circle")
         .labelStyle(IconOnlyLabelStyle())
         .font(.title2)
         .foregroundColor(.systemBlue)
         .onTapGesture { showReminderForm() }
   }
   
   // MARK: -- Intents
   
   private func selectionStarted() {
      selectedReminder = reminder
   }
   
   private func selectionEnded() {
      selectedReminder = nil
      reminderVM.selectionEnded()
   }
   
   private func showReminderForm() {
      hideKeyboard()
      selectionEnded()
      sheet.activeSheet = .addReminder(options: .edit(reminder: reminder))
   }
   
   private func updateViewModel() {
      reminderVM.reminder = reminder
   }
}


// MARK: -- Preview

//struct ReminderRow_Previews: PreviewProvider {
//   static var previews: some View {
//      let reminder = CoreDataSample.createReminders().first!
//      ReminderRow(reminder: reminder)
//         .previewLayout(.sizeThatFits)
//         .frame(width: 300, alignment: .leading)
//         .padding()
//   }
//}
