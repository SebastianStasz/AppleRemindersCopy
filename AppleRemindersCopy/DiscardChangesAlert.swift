//
//  DiscardChangesAlert.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 21/04/2021.
//

import SwiftUI

struct DiscardChangesAlert: Identifiable {
   @Binding var presentationMode: PresentationMode
   let title: String
   
   var body: Alert {
      Alert(title: Text(title), primaryButton: discardChanges, secondaryButton: .cancel())
   }
   
   private var discardChanges: Alert.Button {
      .destructive(Text("Discard Changes")) { presentationMode.dismiss() }
   }

   let id = UUID()
}
