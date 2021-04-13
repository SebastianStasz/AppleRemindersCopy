//
//  View+Extentions.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 01/04/2021.
//

import SwiftUI

// MARK: -- Embed in Navigation View

extension View {
   func embedInNavigation(mode: NavigationBarItem.TitleDisplayMode = .automatic, title: String? = nil) -> some View {
      return Group {
         if let title = title {
             NavigationView {
               self
                  .navigationTitle(title)
                  .navigationBarTitleDisplayMode(mode)
            }
         } else {
            NavigationView {
               self.navigationBarTitleDisplayMode(mode)
//                  .navigationTitleColor(.black)
           }
         }
      }
    }
}

// MARK: -- Dismiss Keyboard

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

// MARK: -- One Edge Border

extension View {
   func oneEdgeBorder(edge: Alignment, lineWidth: CGFloat = 1, color: Color = .primary) -> some View {
      self
         .overlay(Rectangle()
                     .frame(width: nil, height: lineWidth, alignment: edge)
                     .foregroundColor(color), alignment: edge)
   }
}
