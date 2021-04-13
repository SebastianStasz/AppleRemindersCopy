//
//  DisclosureGroupLabel.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 12/04/2021.
//

import SwiftUI

struct DisclosureGroupLabel: View {
   @EnvironmentObject private var sheet: SheetController
   @Environment(\.editMode) private var editMode
   private let group: ReminderGroup
   
   var body: some View {
      HStack {
         Image(systemName: "rectangle.stack")
            .font(Font.title2).opacity(0.6)
         
         Text(group.name.uppercased())
            .bold().font(.subheadline)
         
         Spacer()
         
         if isEditMode { editButton }
         else { Text(reminderCount).opacity(0.4) }
      }
   }
   
   private var editButton: some View {
      Button(action: { sheet.activeSheet = .addGroup(group) }) {
         Image(systemName: "info.circle").font(.title2)
      }
   }
   
   private var reminderCount: String {
      String(group.list.map{ $0.remindersCount }.reduce(0, +))
   }
   
   private var isEditMode: Bool {
      editMode?.wrappedValue == .active
   }
   
   init(_ group: ReminderGroup) {
      self.group = group
   }
}


// MARK: -- Preview

struct DisclosureGroupLabel_Previews: PreviewProvider {
    static var previews: some View {
      let group = CoreDataSample.createSampleGroupLists()[0]
      DisclosureGroupLabel(group)
    }
}
