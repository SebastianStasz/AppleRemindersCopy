//
//  ReminderColor.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 02/04/2021.
//

import Foundation
import SwiftUI

@objc public enum ReminderColor: Int, CaseIterable, Codable {
   case red
   case blue
   case pink
   case teal
   case green
   case indigo
   case orange
   case purple
   case yellow
   case gray
   case brown
   case khaki
   
   var color: Color {
      switch self {
      case .red:
         return .systemRed
      case .orange:
         return .systemOrange
      case .yellow:
         return .systemYellow
      case .green:
         return .systemGreen
      case .purple:
         return .systemPurple
      case .pink:
         return .systemPink
      case .blue:
         return .systemBlue
      case .gray:
         return .systemGray
      case .teal:
         return .systemTeal
      case .indigo:
         return .systemIndigo
      case .brown:
         return Color(red: 165/255, green: 42/255, blue: 42/255)
      case .khaki:
         return Color(red: 240/255, green: 230/255, blue: 140/255)
      }
   }
}

extension ReminderColor: Identifiable {
   public var id: Int { rawValue }
}
