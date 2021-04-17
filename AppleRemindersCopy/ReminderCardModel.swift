//
//  ReminderCardModel.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 17/04/2021.
//

import Foundation
import SwiftUI

enum ReminderCardModel: Int, Codable, CaseIterable {
   case all
   case today
   case flagged
   case scheduled
   case assignedToMe
   
   var title: String {
      switch self {
      case .all: return "All"
      case .today: return "Today"
      case .flagged: return "Flagged"
      case .scheduled: return "Schduled"
      case .assignedToMe: return "Assigned To Me"
      }
   }
   
   var image: String {
      switch self {
      case .all: return "tray.fill"
      case .today: return "bookmark.fill"
      case .flagged: return "flag.fill"
      case .scheduled: return "calendar"
      case .assignedToMe: return "person.fill"
      }
   }
   
   var color: Color {
      switch self {
      case .all: return .systemGray
      case .today: return .systemBlue
      case .flagged: return .systemOrange
      case .scheduled: return .systemRed
      case .assignedToMe: return .systemGreen
      }
   }
   
   var list: ReminderCardList {
      return ReminderCardList.init(rawValue: self.id)!
   }
}

extension ReminderCardModel: Identifiable {
   var id: Int { rawValue }
}
