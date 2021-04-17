//
//  CheckMarkButtonStyle.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

struct CheckMarkButtonStyle: ButtonStyle {
   let isCompleted: Bool
   let color: Color
   
   private var symbol: String {
      isCompleted ? "largecircle.fill.circle" : "circle"
   }
   
   private var checkMarkColor: Color {
      isCompleted ? color : Color.gray.opacity(0.5)
   }
   
   func makeBody(configuration: Configuration) -> some View {
      Image(systemName: symbol)
         .font(Font.title.weight(.light))
         .foregroundColor(checkMarkColor)
         .opacity(configuration.isPressed ? 0.5 : 1)
   }
}
