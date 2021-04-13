//
//  ReminderCardGroupView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 02/04/2021.
//

import SwiftUI

struct ReminderCardGroupView: View {
   @Environment(\.editMode) private var editMode
   @StateObject private var reminderCards = ReminderCardsVM()
   
   init() {
      UITableViewCell.appearance().multipleSelectionBackgroundView = UIView()
   }
   
   var body: some View {
      VStack(spacing: spacing) {
         if isEditingMode { reminderCardList }
         else { reminderCardsGroupView }
      }
   }

   private var reminderCardList: some View {
      List(selection: $reminderCards.selectedCards) {
         Section(header: Text("Customize")) {
            ForEach(reminderCards.allCards, id: \.self) {
               ReminderListRow(card: $0)
                  .tag($0.title)
                  .padding(.vertical, 3)
                  .buttonStyle(PlainButtonStyle())
                  .listRowBackground(Color.secondarySystemGroupedBackground)
            }
            .onMove(perform: reminderCards.move)
         }
      }.listStyle(InsetGroupedListStyle())
   }
   
   private var reminderCardsGroupView: some View {
      Group {
         LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(reminderCards.gridCards, id: \.self) { card in
               ReminderCardView(reminderCard: card)
            }
         }
         
         if let card = reminderCards.singleCard {
            ReminderCardView(reminderCard: card)
         }
      }
      .padding(.horizontal)
   }
   
   private var isEditingMode: Bool {
      editMode?.wrappedValue == .active
   }
   
   private let spacing: CGFloat = 16
   private let columns = [ GridItem(.adaptive(minimum: 150), spacing: 16) ]
}


// MARK: -- Preview

struct ReminderCardsGroupView_Previews: PreviewProvider {
    static var previews: some View {
      ReminderCardGroupView()
         .preferredColorScheme(.light)
         .environment(\.editMode, Binding.constant(EditMode.inactive))
    }
}


