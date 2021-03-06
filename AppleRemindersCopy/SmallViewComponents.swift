//
//  SmallViewComponents.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

// MARK: -- Empty ReminderList List

struct EmptyListView: View {
    var body: some View {
      VStack(spacing: 20) {
         
         Image(systemName: "eyeglasses")
            .font(.largeTitle)
         
         Text("No Reminder Lists")
            .font(.title2)
      }
      .opacity(0.3)
    }
}

// MARK: -- No Reminders Message

struct NoRemindersMessage: View {
   var body: some View {
      Text("No Reminders").opacity(0.5)
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
         .animation(.none)
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
