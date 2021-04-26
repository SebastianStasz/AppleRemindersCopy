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
      form.form.endRepetition == .date
         ? DateManager.date.string(from: form.form.endRepetitionDate)
         : "Never"
   }
   
   var body: some View {
      Section {
         Picker(selection: $form.form.repetition,
                label: ReminderFormLabel.repeat.view)
         {
            ForEach(Repetition.allCases) { Text($0.name).tag($0) }
         }
         
         if form.form.repetition != .never {
            NavigationLink(destination: endRepetitionDetailView) {
               HStack {
                  Text("End Repeat")
                  Spacer()
                  Text(endRepetitionSelection).opacity(0.5)
               }
            }
         }
      }.disabled(!form.form.isDateSelected)
   }
   
   private var endRepetitionDetailView: some View {
      VStack {
         Picker(selection: $form.form.endRepetition,
                label: Text("End Repetition"))
         {
            ForEach(EndRepetition.allCases) { Text($0.name).tag($0) }
         }
         .pickerStyle(SegmentedPickerStyle())
         .padding()
         
         DatePicker("Date", selection: $form.form.endRepetitionDate, displayedComponents: [.date])
            .datePickerStyle(GraphicalDatePickerStyle())
            .disabled(form.form.endRepetition == .never)
         
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
