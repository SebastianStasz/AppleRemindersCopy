//
//  SearchBar.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 12/04/2021.
//

import SwiftUI

class SearchBar: NSObject, ObservableObject {
   let searchController: UISearchController = UISearchController(searchResultsController: nil)
   @Published var text: String = ""
   
   override init() {
      super.init()
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchResultsUpdater = self
   }
}

extension SearchBar: UISearchResultsUpdating {
   
   func updateSearchResults(for searchController: UISearchController) {
      // Publish search bar text changes.
      if let searchBarText = searchController.searchBar.text {
         text = searchBarText
      }
   }
}

struct SearchBarModifier: ViewModifier {
   let searchBar: SearchBar
   
   func body(content: Content) -> some View {
      content.overlay(viewControllerResolver)
   }
   
   private var viewControllerResolver: some View {
      ViewControllerResolver { viewController in
         viewController.navigationItem.searchController = searchBar.searchController
      }
      .frame(width: 0, height: 0)
   }
}

extension View {
   
   func add(_ searchBar: SearchBar) -> some View {
      return self.modifier(SearchBarModifier(searchBar: searchBar))
   }
}
