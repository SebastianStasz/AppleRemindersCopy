//
//  ReminderCardsVM.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 03/04/2021.
//

import Foundation

class ReminderCardsVM: ObservableObject {
   @Published private var reminderCard = ReminderCard()
   
   private var isSingleCard: Bool {
      enabledCards.count % 2 == 1
   }
   
   private var enabledCards: [ReminderCard.CardData] {
      allCards.filter { $0.isEnabled }
   }
   
   init() {
      selectedCards = Set(reminderCard.all.filter { $0.isEnabled }.map { $0.model.title })
   }
   
   // MARK: -- Access
   
   @Published var selectedCards: Set<String> = [] {
      didSet { reminderCard.toggle(cards: selectedCards) }
   }
   
   var allCards: [ReminderCard.CardData] {
      reminderCard.all
   }
   
   var gridCards: [ReminderCard.CardData] {
      return isSingleCard ? enabledCards.dropLast() : enabledCards
   }
   
   var singleCard: ReminderCard.CardData? {
      isSingleCard ? enabledCards.last : nil
   }
   
   // MARK: -- Intents
   
   func move(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
      reminderCard.move(fromOffsets: indices, toOffset: newOffset)
   }
}
