//
//  ReminderFormDateSection.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 09/04/2021.
//

import SwiftUI

struct ReminderFormDateSection: View {
   @EnvironmentObject private var form: ReminderFormVM
   @State private var extendedLabel: ExtendedLabel?
   
   var body: some View {
      Section {
         ExtendableLabel(extendedLabel: $extendedLabel,
                         isToggle: $form.isDateSelected,
                         label: .date,
                         title: ReminderFormLabel.date(form.dateDescription))
         {
            DatePicker("Date", selection: $form.reminderModel.date,
                       displayedComponents: [.date])
         }
         
         ExtendableLabel(extendedLabel: $extendedLabel,
                         isToggle: $form.isTimeSelected,
                         label: .time,
                         title: ReminderFormLabel.time(form.timeDescription))
         {
            DatePicker("Time", selection: $form.reminderModel.date,
                       displayedComponents: [.hourAndMinute])
         }
      }
      .datePickerStyle(GraphicalDatePickerStyle())
      
      .onChange(of: form.isDateSelected) {
         if $0 {
            extendedLabel = form.isTimeSelected ? .time : .date }
         else { form.isTimeSelected = false }
      }
      .onChange(of: form.isTimeSelected) {
         if $0 {
            form.isDateSelected = true
            extendedLabel = .time
         }
      }
   }
}

// MARK: -- Extendable Label

struct ExtendableLabel<Content: View>: View {
   @Binding var extendedLabel: ExtendedLabel?
   @Binding var isToggle: Bool
   let label: ExtendedLabel
   let title: ReminderFormLabel
   let pickerContent: () -> Content
   
   var body: some View {
      VStack {
         Toggle(isOn: $isToggle) {
            title.view
               .frame(maxWidth: .infinity, alignment: .leading)
               .contentShape(Rectangle())
               .onTapGesture { toggleExtendedLabel(to: label) }
         }
            
         if isToggle && isExtended {
            pickerContent()
         }
      }
   }
   
   private var isExtended: Bool {
      extendedLabel == label
   }
   
   private func toggleExtendedLabel(to label: ExtendedLabel) {
      extendedLabel = isExtended ? nil : label
   }
}

enum ExtendedLabel {
   case date
   case time
}
