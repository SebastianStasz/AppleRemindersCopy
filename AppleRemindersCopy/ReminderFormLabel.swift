//
//  ReminderFormLabelView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 09/04/2021.
//

import SwiftUI

struct ReminderFormLabelView: View {
   let symbol: String
   let title: String
   let subtitle: String?
   let color: Color
   
   var body: some View {
      HStack(spacing: 15) {
         Image(systemName: symbol)
            .font(.subheadline)
            .foregroundColor(.white)
            .background(background)
         
         VStack(alignment: .leading) {
            Text(title)
//               .font(.subheadline)
            
            if let subtitle = subtitle {
               Text(subtitle)
                  .font(.footnote)
                  .foregroundColor(.systemBlue)
            }
         }
      }
   }
   
   private var background: some View {
      Rectangle()
         .fill(color)
         .frame(width: 25, height: 25)
         .cornerRadius(7)
   }
}

// MARK: -- Preview

struct ReminderFormLabelView_Previews: PreviewProvider {
   static var previews: some View {
      ReminderFormLabelView(symbol: "calendar", title: "Date", subtitle: "Today", color: .systemRed)
         .preferredColorScheme(.dark)
         .frame(width: 300, height: 45, alignment: .leading)
         .padding()
         .previewLayout(.sizeThatFits)
   }
}

enum ReminderFormLabel {
   case date(String?)
   case time(String?)
   case `repeat`
   case priority
   case location(String?)
   case messeging(String?)
   case flag(String?)
   
   @ViewBuilder
   var view: some View {
      switch self {
      case .date(let subtitle):
         ReminderFormLabelView(symbol: "calendar", title: "Date", subtitle: subtitle, color: .systemRed)
      case .time(let subtitle):
         ReminderFormLabelView(symbol: "clock.fill", title: "Time", subtitle: subtitle, color: .systemBlue)
      case .repeat:
         ReminderFormLabelView(symbol: "repeat", title: "Repeat", subtitle: nil, color: .systemGray2)
      case .priority:
         ReminderFormLabelView(symbol: "exclamationmark.triangle", title: "Priority", subtitle: nil, color: .systemGray2)
      case .location(let subtitle):
         ReminderFormLabelView(symbol: "location.fill", title: "Location", subtitle: subtitle, color: .systemBlue)
      case .messeging(let subtitle):
         ReminderFormLabelView(symbol: "message.fill", title: "When Messaging", subtitle: subtitle, color: .systemGreen)
      case .flag(let subtitle):
         ReminderFormLabelView(symbol: "flag.fill", title: "Flag", subtitle: subtitle, color: .systemOrange)
      }
   }
}
