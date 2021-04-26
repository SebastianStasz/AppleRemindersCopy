//
//  TodoCardView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import SwiftUI

struct ReminderCardView: View {
   @FetchRequest private var reminders: FetchedResults<ReminderEntity>
   private let card: ReminderCard.CardData
   
   private var remindersCount: String {
      String(reminders.count)
   }
   
   init(card: ReminderCard.CardData) {
      self.card = card
      _reminders = FetchRequest(entity: ReminderEntity.entity(),
                                sortDescriptors: [card.model.list.sortDescriptor],
                                predicate: card.model.list.predicate)
   }
   
   var body: some View {
      NavigationLink(destination: destination) {
         reminderCardBody
      }
      .buttonStyle(PlainButtonStyle())
   }
   
   private var destination: some View {
      Group {
         if card.model == .flagged {
            ReminderListWithList(reminders: reminders.map{$0}, showListName: true)
               .embedinRemindersView(markAsFlagged: true, title: card.model.title, accentColor: card.model.color, hideBottomBar: card.model.list.isBottomBarHidden)
            
         } else if card.model == .today {
            ReminderListWithList(reminders: reminders.map{$0}, showListName: true)
               .embedinRemindersView(markAsToday: true, title: card.model.title, accentColor: card.model.color, hideBottomBar: card.model.list.isBottomBarHidden)
            
         } else {
            Group {
               if card.model == .scheduled {
                  RemindersScheduled(reminders: reminders)
               } else {
                  RemindersAll()
               }
            }.embedinRemindersView(title: card.model.title, accentColor: card.model.color, hideBottomBar: card.model.list.isBottomBarHidden)
         }
      }
   }
   
   private var reminderCardBody: some View {
      VStack(alignment: .leading, spacing: 16) {
         HStack {
            Image(systemName: card.model.image)
               .embedInCircle(bgColor: card.model.color)
            
            Spacer()
            
            Text(remindersCount).font(.title).bold()
         }
         
         Text(card.model.title)
            .font(.headline)
            .foregroundColor(.gray)
      }
      .padding(10)
      .background(Color.secondarySystemGroupedBackground)
      .cornerRadius(10)
   }
}

// MARK: -- Initializer

//extension ReminderCardView {
//   init(reminderCard: ReminderCard.Model) {
//      card = reminderCard
//   }
//}


// MARK: -- Preview

//struct ReminderCardView_Previews: PreviewProvider {
//   static var previews: some View {
//      let context = PersistenceController.preview.container.viewContext
//         NavigationView {
//            ReminderCardView(reminderCard: ReminderCard.Default.today.cardModel)
//         }
//      .environment(\.managedObjectContext, context)
//   }
//}
//
