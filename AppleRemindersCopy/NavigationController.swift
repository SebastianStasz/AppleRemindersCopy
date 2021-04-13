//
//  NavigationController.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 11/04/2021.
//

import Foundation
import SwiftUI

class NavigationController: ObservableObject {
   @Published var isBottomBarPresented = true
   @Published var isAddListButtonPresented = true
   @Published var accentColor: Color = .blue
   @Published var isSearching = false
   
   func restoreDefaultSettings() {
      isBottomBarPresented = true
      isAddListButtonPresented = true
      accentColor = .blue
   }
   
   func setupBottomBar(hideBottomBar: Bool, color: Color, showAddListBtn: Bool) {
      accentColor = color
      isAddListButtonPresented = showAddListBtn
      if hideBottomBar { isBottomBarPresented = false }
   }
}
