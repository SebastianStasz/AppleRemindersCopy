//
//  ReminderFormEditingView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 18/04/2021.
//

import SwiftUI

struct ReminderFormEditingView: View {
   @EnvironmentObject private var form: ReminderFormVM
   
   var body: some View {
      Group {
         TextField("Notes", text: $form.form.notes)
         TextField("URL", text: $form.form.url)
         ReminderDetailFormComponents()
      }
   }
}
