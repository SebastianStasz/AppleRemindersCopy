//
//  ImageInCircle.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 05/04/2021.
//

import SwiftUI

struct ImageInCircle: View {
   private let icon: String
   private let color: Color
   private let iconPadding: CGFloat
   private let iconColor: Color
   
   var body: some View {
      Circle()
         .fill(color)
         .scaledToFit()
         .overlay(imageOverlay)
   }
   
   private var imageOverlay: some View {
      Image(systemName: icon)
         .resizable()
         .scaledToFit()
         .font(Font.body.bold())
         .padding(iconPadding)
         .foregroundColor(iconColor)
   }
   
   init(icon: String, padding: CGFloat = 7, color: Color = .tertiarySystemGroupedBackground, iconColor: Color = Color("listIconColor")) {
      self.icon = icon
      self.iconPadding = padding
      self.color = color
      self.iconColor = iconColor
   }
}

// MARK: -- Preview

struct ImageInCircle_Previews: PreviewProvider {
    static var previews: some View {
        ImageInCircle(icon: "star", padding: 50)
         .padding()
         .previewLayout(.sizeThatFits)
    }
}
