//
//  ReminderCard.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 02/04/2021.
//

import Foundation
import SwiftUI

class ReminderCard {
   private let key = UserDefaults.Keys.reminderCards.rawValue
   private(set) var all: [CardData] = [] { didSet { save() } }
   
   init() {
//      UserDefaults.standard.hardReset()
      loadReminderCards()
   }
   
   // MARK: -- Interactions
   
   func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
      all.move(fromOffsets: indices, toOffset: newOffset)
   }
   
   func toggle(cards: Set<String>) {
      _ = all.indices.map {
         let shoulbBeEnabled = cards.contains(all[$0].model.title)
         all[$0].isEnabled = shoulbBeEnabled ? true : false
      }
   }

   // MARK: -- Model Logic
   
   private func loadReminderCards() {
      let data = UserDefaults.standard.data(forKey: key)
      data == nil ? createReminderCards() : decodeReminderCards(from: data!)
   }
   
   private func decodeReminderCards(from data: Data) {
      print("Loading Reminder Cards")
      let reminderCards = try! PropertyListDecoder().decode([ReminderCard.CardData].self, from: data)
      all = reminderCards
   }
   
   private func createReminderCards() {
      print("Creating Reminder Cards")
      all = ReminderCardModel.allCases.map { ReminderCard.CardData(model: $0) }
   }
   
   private func save() {
      let reminderCardsData = try! PropertyListEncoder().encode(all)
      UserDefaults.standard.set(reminderCardsData, forKey: key)
   }
}

// MARK: -- Card Data

extension ReminderCard {
   
   struct CardData: Codable, Identifiable {
      let model: ReminderCardModel
      var isEnabled: Bool
      
      var id: Int { model.id }
      
      init(model: ReminderCardModel, isEnabled: Bool = true) {
         self.model = model
         self.isEnabled = isEnabled
      }
   }
}

