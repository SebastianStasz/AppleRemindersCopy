//
//  NavigationBar.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

struct NavigationBar: ToolbarContent {
   let cancelAction: () -> Void
   let actionText: String
   let action: () -> Void
   let isValid: Bool
   
   var body: some ToolbarContent {
      Group {
         ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel", action: cancelAction)
         }
         ToolbarItem(placement: .navigationBarTrailing) {
            Button(actionText, action: action).disabled(!isValid)
         }
      }
   }
}


// MARK: -- Preview

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
         Text("Content")
      }
      .toolbar {
         NavigationBar(cancelAction: {}, actionText: "Add", action: {}, isValid: true)
      }
    }
}
