//
//  ReminderGroupFormView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 06/04/2021.
//

import SwiftUI

struct ReminderGroupFormView: View {
   @Environment(\.presentationMode) private var presentation
   @StateObject private var groupVM = ReminderGroupFormVM()
   let group: ReminderGroupEntity?
   
   init(group: ReminderGroupEntity? = nil) {
      self.group = group
   }
   
   var body: some View {
      Form {
         TextField("", text: $groupVM.name)
         
         NavigationLink(destination: GroupInfoInclude(groupVM: groupVM)) {
            HStack {
               Text("Include") ; Spacer()
               Text("\(groupVM.includedListsCount) Lists")
            }
         }
      }
      .toolbar { navigationBar }
      .embedInNavigation(mode: .inline, title: navigationTitle)
      .onAppear(perform: sendGroupToViewModel)
   }
   
   private var navigationBar: some ToolbarContent {
      NavigationBar(cancelAction: dismiss, actionText: "Done", action: createList, isValid: groupVM.isValid)
   }
   
   // MARK: -- Intents
   
   private func createList() {
      groupVM.saveChanges()
      dismiss()
   }
   
   private func dismiss() {
      presentation.wrappedValue.dismiss()
   }
   
   private func sendGroupToViewModel() {
      groupVM.group = group
   }
   
   // MARK: -- Helpers
   
   private var navigationTitle: String {
      group != nil ? "Group Info" : "New Group"
   }
}


// MARK: -- Preview

struct GroupEditingView_Previews: PreviewProvider {
   static var previews: some View {
      let context = CoreDataManager.shared.context
      let groupList = CoreDataSample.createReminderGroups(context: context)
      
      ReminderGroupFormView(group: groupList[0])
         .environment(\.managedObjectContext, context)
   }
}


