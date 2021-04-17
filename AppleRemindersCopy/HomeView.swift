//
//  ContentView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import SwiftUI

struct HomeView: View {
   @Environment(\.managedObjectContext) private var context
   @Environment(\.editMode) private var editMode
   @EnvironmentObject private var nav: NavigationController
   @EnvironmentObject private var sheet: SheetController
   @StateObject private var searchBar: SearchBar = SearchBar()
   
   var body: some View {
      VStack {
         ReminderCardGroupView().padding(.top)
         ReminderListListView()
         Spacer()
      }
      .background(Color.systemGroupedBackground.ignoresSafeArea())
      
      // -- Navigation configuration
      .toolbar { EditButton() }
      .navigationTitleColor(nav.accentColor)
      .add(searchBar).overlay(viewControllerResolver)
      .embedInNavigation(mode: .inline).setupBottomBar()
      
      .sheet(item: $sheet.activeSheet) {
         $0.sheetView.environment(\.managedObjectContext, context)
      }
   }
   
   private var viewControllerResolver: some View {
      ViewControllerResolver { viewController in
         viewController.navigationItem.searchController =
            UISearchController(searchResultsController: nil)
      }
      .frame(width: 0, height: 0)
   }
}


// MARK: -- Preview

struct HomeView_Previews: PreviewProvider {
   static var previews: some View {
      let persistence = PersistenceController.preview.container
      VStack { HomeView() }
         .preferredColorScheme(.dark)
         .environment(\.managedObjectContext, persistence.viewContext)
   }
}

