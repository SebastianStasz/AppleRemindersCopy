//
//  TodoCardView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import SwiftUI

struct ReminderCardView: View {
   @StateObject private var remindersVM = RemindersVM()
   let config: RemindersVM.Config
   let card: ReminderCard.CardData
   
   var body: some View {
      NavigationLink(destination: destination) {
         reminderCardBody
      }
      .buttonStyle(PlainButtonStyle())
      .onAppear { remindersVM.config = config }
   }
   
   private var destination: some View {
      card.model.list.view
         .embedinRemindersView(title: config.title,
                               accentColor: card.model.color,
                               hideBottomBar: card.model.list.isBottomBarHidden)
         .environmentObject(remindersVM)
   }
   
   private var reminderCardBody: some View {
      VStack(alignment: .leading, spacing: 16) {
         HStack {
            Image(systemName: card.model.image)
               .embedInCircle(bgColor: card.model.color)
            
            Spacer()
            
            Text(remindersVM.count).font(.title).bold()
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
