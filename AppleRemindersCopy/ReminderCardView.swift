//
//  TodoCardView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import SwiftUI

struct ReminderCardView: View {
   @FetchRequest private var reminders: FetchedResults<Reminder>
   private let card: ReminderCard.Model
   
   var body: some View {
      NavigationLink(destination: ReminderListView(card: card, reminders: reminders.map{$0})) {
         reminderCardBody
      }
      .buttonStyle(PlainButtonStyle())
   }
   
   private var reminderCardBody: some View {
      VStack(alignment: .leading, spacing: 16) {
         HStack {
            Image(systemName: card.image)
               .embedInCircle(bgColor: card.color.color)
            
            Spacer()
            
            Text(String(reminders.count))
               .font(.title).bold()
         }
         
         Text(card.title)
            .font(.headline)
            .foregroundColor(.gray)
      }
      .padding(10)
      .background(Color.secondarySystemGroupedBackground)
      .cornerRadius(10)
   }
}

// MARK: -- Initializer

extension ReminderCardView {
   init(reminderCard: ReminderCard.Model) {
      card = reminderCard
      _reminders = FetchRequest(entity: Reminder.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: card.list.predicate)
   }
}


// MARK: -- Preview

struct ReminderCardView_Previews: PreviewProvider {
   static var previews: some View {
      let context = PersistenceController.preview.container.viewContext
         NavigationView {
            ReminderCardView(reminderCard: ReminderCard.Default.today.cardModel)
         }
      .environment(\.managedObjectContext, context)
   }
}

