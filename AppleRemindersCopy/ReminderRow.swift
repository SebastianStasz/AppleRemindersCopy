//
//  ReminderRow.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import Combine
import SwiftUI

class ReminderRowVM: ObservableObject {
   private let coreDataManager = CoreDataManager.shared
   private var cancellable: Set<AnyCancellable> = []
   
   var listVM: RemindersVM? = nil
   var reminder: ReminderEntity? = nil { didSet { setReminderInfo() } }
   
   @Published var name = ""
   @Published var isCompleted = false
   
   init() {
      $isCompleted
         .dropFirst()
         .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
         .filter { $0 }
         .sink { [weak self] _ in
               self?.deleteReminder()
         }
         .store(in: &cancellable)
   }
   
   func selectionStarted() {
      listVM!.selectedReminder = reminder
   }
   
   func selectionEnded() {
      listVM!.selectedReminder = nil
      if name.isEmpty { deleteReminder() }
      else if name != reminder?.name {
         reminder?.name = name
         coreDataManager.save()
      }
   }
   
   private func deleteReminder() {
      let index = (listVM?.reminders.firstIndex(of: reminder!)!)!
      listVM?.removeFromList(at: index)
      coreDataManager.delete(reminder!)
   }
   
   private func setReminderInfo() {
      name = reminder!.name
      isCompleted = reminder!.isCompleted
   }
}

struct ReminderRow: View {
   @EnvironmentObject private var sheet: SheetController
   @EnvironmentObject private var listVM: RemindersVM
   @StateObject private var reminderVM = ReminderRowVM()
   let reminder: ReminderEntity

   var body: some View {
      HStack {
         HStack(spacing: 15) {
            Button { reminderVM.isCompleted.toggle() } label: {}
               .buttonStyle(CheckMarkButtonStyle(isCompleted: reminderVM.isCompleted, color: reminder.listColor))
            
            VStack(alignment: .leading, spacing: 6) {
               TextField("", text: $reminderVM.name) { isFocused in
                  isFocused ? reminderVM.selectionStarted() : reminderVM.selectionEnded()
               }
               
               if listVM.config?.showListName ?? false {
                  Text(reminder.list.name).foregroundColor(.gray)
               }
            }
         }
         
         Spacer()
         
         if listVM.selectedReminder == reminder { detailsButton }
      }
      .padding(.top, 5)
      .onAppear(perform: viewDidAppear)
   }

   private var detailsButton: some View {
      Label("Show details", systemImage: "info.circle")
         .labelStyle(IconOnlyLabelStyle())
         .font(.title2)
         .foregroundColor(.systemBlue)
         .onTapGesture { showReminderForm() }
   }
   
   // MARK: -- Functions

   private func viewDidAppear() {
      reminderVM.listVM = listVM
      reminderVM.reminder = reminder
   }
   
   private func showReminderForm() {
      hideKeyboard()
      reminderVM.selectionEnded()
      sheet.activeSheet = .addReminder(reminder, nil)
   }
}


// MARK: -- Preview

struct ReminderRow_Previews: PreviewProvider {
   static var previews: some View {
      let reminder = CoreDataSample.createReminders().first!
      ReminderRow(reminder: reminder)
         .previewLayout(.sizeThatFits)
         .frame(width: 300, alignment: .leading)
         .padding()
   }
}
