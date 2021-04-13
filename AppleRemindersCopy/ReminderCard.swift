//
//  ReminderCardModel.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 02/04/2021.
//

import Foundation
import SwiftUI

class ReminderCard {
   private let key = UserDefaults.Keys.reminderCards.rawValue
   private(set) var all: [Model] = [] { didSet { save() } }
   
   init() {
      UserDefaults.standard.reset()
      loadReminderCards()
   }
   
   // MARK: -- Interactions
   
   func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
      all.move(fromOffsets: indices, toOffset: newOffset)
   }
   
   func toggle(cards: Set<String>) {
      _ = all.indices.map {
         let shoulbBeEnabled = cards.contains(all[$0].title)
         all[$0].isEnabled = shoulbBeEnabled ? true : false
      }
   }

   // MARK: -- Model Logic
   
   private func loadReminderCards() {
      let data = UserDefaults.standard.data(forKey: key)
      data == nil ? createReminderCards() : decodeReminderCards(from: data!)
   }
   
   private func decodeReminderCards(from data: Data) {
      print("Reminder Cards in memory")
      let reminderCards = try! PropertyListDecoder().decode([ReminderCard.Model].self, from: data)
      all = reminderCards
   }
   
   private func createReminderCards() {
      print("Creating Reminder Cards")
      all = ReminderCard.Default.allCases.map { $0.cardModel }
   }
   
   private func save() {
      let reminderCardsData = try! PropertyListEncoder().encode(all)
      UserDefaults.standard.set(reminderCardsData, forKey: key)
   }
}

// MARK: -- Reminder Card Model

extension ReminderCard {
   struct Model: Hashable, Codable {
      let list: ReminderCardList
      let title: String
      let image: String
      let color: ReminderColor
      var isEnabled: Bool
      var count = 20
   }
}

// MARK: -- Reminder Card Default

extension ReminderCard {
   enum Default: String, Identifiable, CaseIterable {
      case today
      case scheduled
      case all
      case flagged
      case assignedToMe
      
      var cardModel: ReminderCard.Model {
         switch self {
         case .today:
            return ReminderCard.Model(list: .today, title: "Today", image: "bookmark.fill", color: .blue, isEnabled: true)
         case .scheduled:
            return ReminderCard.Model(list: .scheduled, title: "Scheduled", image: "calendar", color: .red, isEnabled: true)
         case .all:
            return ReminderCard.Model(list: .all, title: "All", image: "tray.fill", color: .gray, isEnabled: true)
         case .flagged:
            return ReminderCard.Model(list: .flagged, title: "Flagged", image: "flag.fill", color: .orange, isEnabled: true)
         case .assignedToMe:
            return ReminderCard.Model(list: .all, title: "Assigned to Me", image: "person.fill", color: .green, isEnabled: false)
         }
      }
      
      var id: String { rawValue }
   }
}
