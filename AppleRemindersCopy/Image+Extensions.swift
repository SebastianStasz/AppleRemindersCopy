//
//  Image+Extensions.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 02/04/2021.
//

import SwiftUI

extension Image {
   func embedInCircle(bgColor: Color, textColor: Color = .white, size: CGFloat = 32, padding: CGFloat = 7) -> some View {
      Circle()
         .foregroundColor(bgColor)
         .frame(width: size, height: size)
         .overlay(self.resizable().scaledToFit().padding(padding).foregroundColor(textColor))
   }
}
