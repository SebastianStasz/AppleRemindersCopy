//
//  ReminderListRow.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 04/04/2021.
//

import SwiftUI

struct ReminderListRow: View {
   @Environment(\.editMode) private var editMode
   @EnvironmentObject private var sheet: SheetController
   
   private let title: String
   private let image: String
   private let bgColor: Color
   private let textColor: Color
   
   private let list: ReminderListEntity?
   private let isEditModeBlocked: Bool
   private let reminderCount: String?
   
   var body: some View {
      HStack(spacing: 16) {
         
         Image(systemName: image)
            .embedInCircle(bgColor: bgColor, textColor: textColor, size: 32)
         
         Text(title)
         
         if isEditMode {
            Spacer() ; editButton
            
         } else if let reminderCount = reminderCount {
            Spacer() ; Text(reminderCount).opacity(0.4)
         }
      }
   }
   
   private var editButton: some View {
      Image(systemName: "info.circle")
         .font(.title2)
         .foregroundColor(.systemBlue)
         .onTapGesture { sheet.activeSheet = .addList(list) }
   }
   
   private var isEditMode: Bool {
      guard !isEditModeBlocked else { return false }
      return editMode?.wrappedValue == .active
   }
}

// MARK: -- Initializers

extension ReminderListRow {
   
   init(card: ReminderCard.CardData) {
      title = card.model.title
      image = card.model.image
      bgColor = card.model.color
      textColor = .white
      
      list = nil
      reminderCount = nil
      isEditModeBlocked = true
   }
   
   init(list: ReminderListEntity, reminderCount: String? = nil) {
      title = list.name
      image = list.icon.sfSymbol
      bgColor = list.color
      textColor = .white
      
      self.list = list
      self.reminderCount = reminderCount
      isEditModeBlocked = false
   }
}


// MARK: -- Preview

struct ReminderListRow_Previews: PreviewProvider {
    static var previews: some View {
      let list = CoreDataSample.createSampleReminderLists()[0]
      ReminderListRow(list: list)
         .previewLayout(.sizeThatFits)
         .frame(width: 200)
         .padding()
    }
}
