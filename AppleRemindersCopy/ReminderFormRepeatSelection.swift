//
//  ReminderFormRepeatSelection.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 10/04/2021.
//

import SwiftUI

struct ReminderFormRepeatSelection: View {
   @EnvironmentObject private var form: ReminderFormVM
   
   private var endRepetitionSelection: String {
      form.reminderModel.endRepetition == .date
         ? DateHelper.date.string(from: form.reminderModel.endRepetitionDate)
         : "Never"
   }
   
   var body: some View {
      Section {
         Picker(selection: $form.reminderModel.repetition,
                label: ReminderFormLabel.repeat.view)
         {
            ForEach(Repetition.allCases) { Text($0.name).tag($0) }
         }
         
         if form.reminderModel.repetition != .never {
            NavigationLink(destination: endRepetitionDetailView) {
               HStack {
                  Text("End Repeat")
                  Spacer()
                  Text(endRepetitionSelection).opacity(0.5)
               }
            }
         }
      }
   }
   
   private var endRepetitionDetailView: some View {
      VStack {
         Picker(selection: $form.reminderModel.endRepetition,
                label: Text("End Repetition"))
         {
            ForEach(EndRepetition.allCases) { Text($0.name).tag($0) }
         }
         .pickerStyle(SegmentedPickerStyle())
         .padding()
         
         DatePicker("Date", selection: $form.reminderModel.endRepetitionDate, displayedComponents: [.date])
            .datePickerStyle(GraphicalDatePickerStyle())
            .disabled(form.reminderModel.endRepetition == .never)
         
         Spacer()
      }
      .navigationTitle("End Repeat")
      .padding()
   }
}

// MARK: -- Preview

struct ReminderFormRepeatSelection_Previews: PreviewProvider {
   static var previews: some View {
      let form = ReminderFormVM()
      NavigationView{
         Form { ReminderFormRepeatSelection() }
      }
      .environmentObject(form)
   }
}
