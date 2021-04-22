//
//  ReminderFormViewComponents.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 18/04/2021.
//

import SwiftUI

struct ReminderFormNotes: View {
   @EnvironmentObject private var form: ReminderFormVM
   
   private var opacity: Double {
      form.form.notes.isEmpty ? 0.2 : 0
   }
   
   var body: some View {
      TextEditor(text: $form.form.notes)
         .frame(height: 100)
         .overlay(notesPlaceholder, alignment: .topLeading)
   }
   
   private var notesPlaceholder: some View {
      Text("Notes")
         .opacity(opacity)
         .padding(.top, 10)
   }
}
