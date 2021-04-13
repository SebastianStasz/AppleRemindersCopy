//
//  NewReminderButton.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

struct NewReminderButton: View {
   let action: () -> Void
   let color: Color
   
   var body: some View {
      Button(action: action) {
         HStack {
            Image(systemName: "plus.circle.fill").font(.title2)
            Text("New Reminder")
         }
         .font(.headline)
         .foregroundColor(color)
      }
   }
}

// MARK: -- Preview

struct NewReminderButton_Previews: PreviewProvider {
    static var previews: some View {
      NewReminderButton(action: {}, color: .blue)
    }
}
