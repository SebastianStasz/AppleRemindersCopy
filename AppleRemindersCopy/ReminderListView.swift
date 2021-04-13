//
//  ReminderListView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 07/04/2021.
//

import SwiftUI

struct ReminderListView: View {
   @EnvironmentObject private var sheet: SheetController
   @EnvironmentObject private var nav: NavigationController
   private var listForReminder: ReminderList? = nil
   private let reminderList: AnyView
   private let hideBottomBar: Bool
   private let accentColor: Color
   private let title: String
   
   var body: some View {
      VStack {
         List { reminderList }.listStyle(InsetListStyle())
      }
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.large)

      .onAppear(perform: viewDidAppear)
      .onDisappear(perform: viewDidDisappear)
   }
   
   private func viewDidDisappear() {
      sheet.reminderList = nil
      nav.restoreDefaultSettings()
   }
   
   private func viewDidAppear() {
      sheet.reminderList = listForReminder
      nav.setupBottomBar(hideBottomBar: hideBottomBar, color: accentColor, showAddListBtn: false)
   }
}

// MARK: -- Initializers

extension ReminderListView {
   
   init(card: ReminderCard.Model, reminders: [Reminder]) {
      switch card.list {
      case.all:
         reminderList = AnyView(RemindersSortedByList())
      case .scheduled:
         reminderList = AnyView(RemindersSortedByDay(reminders: reminders))
      default:
         reminderList = AnyView(Reminders(reminders: reminders))
      }
      
      let shouldHide = card.list == .all || card.list == .scheduled
      title = card.title
      accentColor = card.list.accentColor
      hideBottomBar = shouldHide ? true : false
   }
   
   init(list: ReminderList) {
      let predicate = NSPredicate(format: "isCompleted == NO AND list == %@", list)
      
      listForReminder = list
      title = list.name
      accentColor = list.color.color
      reminderList = AnyView(RemindersByFetch(predicate: predicate, showListName: false))
      hideBottomBar = false
   }
}


// MARK: -- Preview

struct ReminderListView_Previews: PreviewProvider {
   static var previews: some View {
      let persistence = PersistenceController.preview.container
      NavigationView {
         NavigationLink(destination: ReminderListView(card: ReminderCard.Default.all.cardModel, reminders: []), isActive: .constant(true))
         { Text("Navigate") }
      }
      .preferredColorScheme(.dark)
      .environment(\.managedObjectContext, persistence.viewContext)
   }
}




