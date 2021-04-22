//
//  ReminderListRow.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 04/04/2021.
//

import SwiftUI

struct ReminderListRow: View {
   private let title: String
   private let image: String
   private let bgColor: Color
   
   var body: some View {
      HStack(spacing: 16) {
         Image(systemName: image)
            .embedInCircle(bgColor: bgColor)
         Text(title)
      }
   }
}

// MARK: -- Initializers

extension ReminderListRow {
   
   init(card: ReminderCard.CardData) {
      title = card.model.title
      image = card.model.image
      bgColor = card.model.color
   }
   
   init(list: ReminderListEntity) {
      title = list.name
      image = list.icon.sfSymbol
      bgColor = list.color
   }
}


// MARK: -- Preview

struct ReminderListRow_Previews: PreviewProvider {
    static var previews: some View {
      let context = CoreDataManager.shared.context
      let list = CoreDataSample.createReminderLists(context: context)[0]
      ReminderListRow(list: list)
         .previewLayout(.sizeThatFits)
         .frame(width: 200)
         .padding()
    }
}
