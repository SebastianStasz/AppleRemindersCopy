//
//  SecondaryTextFieldStyle.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 05/04/2021.
//

import SwiftUI

struct SecondaryTextFieldStyle: TextFieldStyle {
   let color: Color
   
   func _body(configuration: TextField<Self._Label>) -> some View {
      configuration
         .font(Font.title.bold())
         .multilineTextAlignment(.center)
         .foregroundColor(color)
         .padding(10)
         .background(Color.tertiarySystemGroupedBackground)
         .cornerRadius(10)
   }
}
