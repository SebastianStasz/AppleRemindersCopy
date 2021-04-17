//
//  ReminderListComponents.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

// MARK: -- No Reminders Message

struct NoRemindersMessage: View {
   var body: some View {
      Text("No Reminders")
         .frame(maxWidth: .infinity, alignment: .leading)
         .opacity(0.2)
   }
}

// MARK: -- List Header

struct ListHeader: View {
   let title: String
   let color: Color
   
   var body: some View {
      Text(title)
         .foregroundColor(color)
         .font(.title2).bold()
         .padding(.leading, 20)
         .padding(.top, 15).padding(.bottom, 7)
         .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
         .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
         .oneEdgeBorder(edge: .top, lineWidth: 1, color: Color.primary.opacity(0.1))
         .background(Color.systemBackground)
   }
}

extension ListHeader {
   init(list: ReminderListEntity) {
      title = list.name
      color = list.color
   }
}


// MARK: -- Preview

struct ListHeader_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
         NoRemindersMessage()
         ListHeader(title: "This week", color: .systemRed)
      }
    }
}
