//
//  NavigationTitleColor.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 08/04/2021.
//

import SwiftUI

struct NavigationTitleColor: ViewModifier {
   init(color: Color) {
      let uiColor = UIColor(color)
      let nav = UINavigationBar.appearance()
      nav.largeTitleTextAttributes = [.foregroundColor: uiColor]
//      nav.titleTextAttributes = [.foregroundColor: uiColor]
   }
   
   func body(content: Content) -> some View { content }
}

extension View {
   func navigationTitleColor(_ color: Color) -> some View {
      modifier(NavigationTitleColor(color: color))
   }
}

struct NavigationBottomBar: ViewModifier {
   init() {
      let toolbar = UIToolbar.appearance()
      toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
      toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
   }
   
   func body(content: Content) -> some View { content }
}

extension View {
   func hideNavigationBottomBar() -> some View {
      modifier(NavigationBottomBar())
   }
}
