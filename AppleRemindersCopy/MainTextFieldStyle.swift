//
//  MainTextFieldStyle.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 02/04/2021.
//

import SwiftUI

struct MainTextFieldStyle: TextFieldStyle {
   let colorScheme: ColorScheme
   let isSelected: Bool
   
   private var selectedBackgroundColor: Color {
      colorScheme == .dark ? .systemGray6 : .systemGray5
   }
   
   private var overlayImageColor: Color {
      colorScheme == .dark ? .systemGray3 : .systemGray2
   }
   
   func _body(configuration: TextField<Self._Label>) -> some View {
      configuration
         .padding(.vertical, 5)
         .padding(.horizontal, 35)
         .background(isSelected ? Color.systemFill : selectedBackgroundColor)
         .cornerRadius(10)
         .overlay(overlayImage, alignment: .leading)
   }
   
   private var overlayImage: some View {
      Image(systemName: "magnifyingglass")
         .foregroundColor(overlayImageColor)
         .padding(.leading, 10)
   }
}
