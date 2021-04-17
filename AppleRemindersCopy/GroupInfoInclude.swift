//
//  GroupInfoInclude.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

struct GroupInfoInclude: View {
   @Environment(\.managedObjectContext) private var context
   @Environment(\.editMode) private var editMode
   @ObservedObject var groupVM: ReminderGroupFormVM
   
   var body: some View {
      VStack {
         List {
            Section(header: Text("Include")) {
               ForEach(groupVM.includedListsPlaceholder) { Text($0.name) }
                  .onDelete(perform: groupVM.removeFromGroup)
            }
            
            Section(header: Text("More Lists")) {
               ForEach(groupVM.otherListsPlaceholder, content: moreListRow)
            }
         }
         .listStyle(InsetGroupedListStyle())
      }
      .navigationTitle("Include")
      .onAppear { editMode?.wrappedValue = .active }
   }
   
   private func moreListRow(list: ReminderListEntity) -> some View {
      HStack {
         Image(systemName: "plus.circle.fill")
            .foregroundColor(.systemGreen)
            .font(.title2)
            .padding(.trailing, 10)
            .onTapGesture { groupVM.addToGroup(list: list) }
         
         Text(list.name)
      }
   }
}

// MARK: -- Preview

struct GroupInfoInclude_Previews: PreviewProvider {
   static var previews: some View {
      let viewModel = ReminderGroupFormVM()
      GroupInfoInclude(groupVM: viewModel)
   }
}
