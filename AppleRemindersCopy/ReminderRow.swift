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
   
   let dateOptions: DateDescriptionView.Options
   let isListNameShown: Bool
   
   init(reminder: ReminderEntity, selectedReminder: Binding<ReminderEntity?>,
        dateOptions: DateDescriptionView.Options = .dateAndTime,
        showListName: Bool = false)
   {
      self.reminder = reminder
      _selectedReminder = selectedReminder
      isListNameShown = showListName
      self.dateOptions = dateOptions
   }
   
   var body: some View {
      HStack(spacing: 15) {
         Button { reminderVM.isCompleted.toggle() } label: {}
            .buttonStyle(CheckMarkButtonStyle(isCompleted: reminderVM.isCompleted, color: reminder.listColor))
         
         VStack(alignment: .leading, spacing: 2) {
            HStack {
               if let priority = reminderVM.priorityIndicator {
                  Text(priority).foregroundColor(reminder.list.color)
               }
               
               TextField("", text: $reminderVM.name) { isFocused in
                  isFocused ? selectionStarted() : selectionEnded()
               }
               
               if reminder.isFlagged { flagIcon }
               
               if selectedReminder == reminder { detailsButton }
            }
            
            if isAdditionalInfo {
               ReminderRowInfo(dateOptions: dateOptions, isListNameShown: isListNameShown)
                  .environmentObject(reminder).environmentObject(reminderVM)
            }
         }
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
         .padding(.leading)
         .onTapGesture { showReminderForm() }
   }
   
   private var flagIcon: some View {
      Image(systemName: "flag.fill")
         .font(.subheadline)
         .foregroundColor(.systemOrange)
   }
   
   private var isAdditionalInfo: Bool {
      let isDate = reminder.date != nil && reminder.isTimeSelected || dateOptions != .time
      guard reminder.notes != nil || reminder.url != nil || isDate else { return false }
      return true
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

struct ReminderRow_Previews: PreviewProvider {
   static var previews: some View {
      let context = PersistenceController.preview.container.viewContext
      let reminders = CoreDataSample.createReminders(context: context)
      let reminders2 = reminders[0...3]
      
      ForEach(reminders2) { reminder in
         ReminderRow(reminder: reminder, selectedReminder: .constant(reminders2.first))
      }
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
      .frame(width: 300, alignment: .leading)
      .padding()
   }
}
