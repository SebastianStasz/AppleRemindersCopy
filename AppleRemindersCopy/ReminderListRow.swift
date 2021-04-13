//
//  ReminderListRow.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 04/04/2021.
//

import SwiftUI

struct ReminderListRow: View {
   @EnvironmentObject private var sheet: SheetController
   @Environment(\.editMode) private var editMode
   private let isEditingListBlocked: Bool
   private let isReminderCountShown: Bool
   private let list: ReminderList?
   private let title: String
   private let image: String
   private let bgColor: Color
   private let textColor: Color
   
   var body: some View {
      HStack(spacing: 16) {
         
         Image(systemName: image)
            .embedInCircle(bgColor: bgColor, textColor: textColor, size: 32)
         
         Text(title)
         
         if isEditMode {
            Spacer() ; editButton
            
         } else if shouldPresentReminderCount {
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
   
   private var reminderCount: String {
      String(list!.remindersCount)
   }
   
   private var shouldPresentReminderCount: Bool {
      isReminderCountShown && list != nil
   }
   
   private var isEditMode: Bool {
      guard !isEditingListBlocked else { return false }
      return editMode?.wrappedValue == .active
   }
}

// MARK: -- Initializers

extension ReminderListRow {
   
   init(card: ReminderCard.Model) {
      title = card.title
      image = card.image
      bgColor = card.color.color
      textColor = .white
      
      isReminderCountShown = false
      list = nil
      isEditingListBlocked = true
   }
   
   init(list: ReminderList, showRemindersCount: Bool = true) {
      title = list.name
      image = list.icon.sfSymbol
      bgColor = list.color.color
      textColor = .white
      
      self.isReminderCountShown = showRemindersCount
      self.list = list
      isEditingListBlocked = false
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
