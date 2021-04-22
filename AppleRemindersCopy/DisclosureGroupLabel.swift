//
//  DisclosureGroupLabel.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 12/04/2021.
//

import SwiftUI

struct DisclosureGroupLabel: View {
   @Environment(\.editMode) private var editMode
   @EnvironmentObject private var sheet: SheetController
   let group: ReminderGroupEntity
   
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
      String(group.list.map{ $0.reminders.count }.reduce(0, +))
   }
   
   private var isEditMode: Bool {
      editMode?.wrappedValue == .active
   }
}


// MARK: -- Preview

struct DisclosureGroupLabel_Previews: PreviewProvider {
    static var previews: some View {
      let context = CoreDataManager.shared.context
      let group = CoreDataSample.createReminderGroups(context: context)[0]
      DisclosureGroupLabel(group: group)
    }
}
