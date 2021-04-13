//
//  ReminderRow.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import Combine
import SwiftUI

struct ReminderRow: View {
   @Environment(\.managedObjectContext) private var context
   @EnvironmentObject private var sheet: SheetController
   @EnvironmentObject private var listVM: RemindersVM
   
   let reminder: Reminder
   @State var name = "" {
      didSet { reminder.name = name }
   }
   @State var isCompleted = false {
      didSet {
         DispatchQueue.main.asyncAfter(deadline: .now() + 3) { setCompletion() }
      }
   }
   
   var body: some View {
      HStack {
         HStack(spacing: 15) {
            Button { isCompleted.toggle() } label: {}
               .buttonStyle(CheckMarkButtonStyle(isCompleted: isCompleted, color: reminder.list.color.color))
            
            VStack(alignment: .leading, spacing: 6) {
               TextField("", text: $name) { isFocused in
                  isFocused ? selectionStarted() : selectionEnded()
               }
               
               if listVM.showListName {
                  Text(reminder.list.name).foregroundColor(.gray)
               }
            }
         }
         
         Spacer()
         
         if listVM.selectedReminder == reminder { detailsButton }
      }
      .padding(.top, 5)
      .onAppear(perform: viewDidAppear)
      .onDisappear(perform: viewDidDisappear)
   }
   
   private var detailsButton: some View {
      Label("Show details", systemImage: "info.circle")
         .labelStyle(IconOnlyLabelStyle())
         .font(.title2)
         .foregroundColor(.systemBlue)
         .onTapGesture { showReminderForm() }
   }

   private func viewDidAppear() {
      name = reminder.name
      isCompleted = reminder.isCompleted
   }
   
   private func viewDidDisappear() {

   }
   
   private func selectionStarted() {
      listVM.selectedReminder = reminder
   }
   
   private func selectionEnded() {
      deleteReminder()
      listVM.selectedReminder = nil
   }
   
   private func setCompletion() {
      guard isCompleted else { return }
      reminder.isCompleted = true
      deleteReminder()
   }
   
   private func deleteReminder() {
      guard name.isEmpty else { return }
      context.delete(reminder)
   }
   
   private func showReminderForm() {
      hideKeyboard()
      selectionEnded()
      sheet.activeSheet = .addReminder(reminder, nil)
   }
}


// MARK: -- Preview
//
//struct ReminderRow_Previews: PreviewProvider {
//   static var previews: some View {
//      let reminder = CoreDataSample.createReminders().first!
//      ReminderRow(reminder: ReminderVM(reminder: reminder),
//                  showListName: true,
//                  selectedReminder: .constant(reminder))
//         .previewLayout(.sizeThatFits)
//         .frame(width: 300, alignment: .leading)
//         .padding()
//   }
//}
