//
//  ReminderGroupFormView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 06/04/2021.
//

import CoreData
import SwiftUI

struct ReminderGroupFormView: View {
   @Environment(\.presentationMode) private var presentation
   @FetchRequest private var fetchedLists: FetchedResults<ReminderListEntity>
   @StateObject private var groupVM = ReminderGroupFormVM()
   let group: ReminderGroupEntity?
   
   private var otherLists: [ReminderListEntity] {
      fetchedLists.map{$0}
   }
   
   init(group: ReminderGroupEntity? = nil) {
      self.group = group
      var predicate: NSPredicate
      if let group = group {
         predicate = NSPredicate(format: "group == nil OR group != %@", group)
      } else {
         predicate = NSPredicate(format: "group == nil")
      }
      _fetchedLists = FetchRequest(entity: ReminderListEntity.entity(), sortDescriptors: [], predicate: predicate)
   }
   
   var body: some View {
      Form {
         TextField("", text: $groupVM.name)
         
         NavigationLink(destination: GroupInfoInclude(groupVM: groupVM)) {
            HStack {
               Text("Include")
               Spacer()
               Text("\(String((group?.list.count)!)) Lists")
            }
         }
      }
      .toolbar { navigationBar }
      .embedInNavigation(mode: .inline, title: "Group Info")
      .onAppear(perform: viewDidLoad)
   }
   
   private var navigationBar: some ToolbarContent {
      NavigationBar(cancelAction: dismiss, actionText: "Done", action: createList, isValid: groupVM.isValid)
   }
   
   // MARK: -- Intents
   
   private func dismiss() {
      presentation.wrappedValue.dismiss()
   }
   
   private func createList() {
      groupVM.saveChanges()
      dismiss()
   }
   
   private func viewDidLoad() {
      groupVM.group = group
      groupVM.otherListsPlaceholder = otherLists.map{$0}
   }
}

// MARK: -- Preview

struct GroupEditingView_Previews: PreviewProvider {
   static var previews: some View {
      let persistence = PersistenceController.preview.container
      let groupList = CoreDataSample.createSampleGroupLists()
      
      ReminderGroupFormView(group: groupList[0])
         .environment(\.managedObjectContext, persistence.viewContext)
   }
}


