//
//  TestView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 05/04/2021.
//

import SwiftUI

struct AdaptiveVGrid<Data, ID, Content>: View where Data: RandomAccessCollection, ID: Hashable, Content: View {
   private let data: Data
   private let forEachBuilder: (Data.Element) -> Content
   private let identityKeyPath: KeyPath<Data.Element, ID>
   private let inColumn: Int
   private let spacing: CGFloat
   @State private var width: CGFloat = 0
   
   init(_ data: Data, id: KeyPath<Data.Element, ID>, inColumn: Int, spacing: CGFloat = 10,
        @ViewBuilder content: @escaping (Data.Element) -> Content) {
      self.data = data
      identityKeyPath = id
      forEachBuilder = content
      self.inColumn = inColumn
      self.spacing = spacing
   }
   
   var body: some View {
      LazyHGrid(rows: getLayout(width: width), spacing: spacing) {
         ForEach(data, id: identityKeyPath, content: forEachBuilder)
      }
      .frame(maxWidth: .infinity)
      .readSize { width = $0.width }
   }
   
   private func getLayout(width: CGFloat) -> [GridItem] {
      let itemInRow = CGFloat(data.count / inColumn)
      let itemSize = (width - (itemInRow - 1) * spacing) / itemInRow
      let gridItem = GridItem(.flexible(minimum: itemSize, maximum: itemSize), spacing: spacing)
      return Array(repeating: gridItem, count: inColumn)
   }
}

// MARK: -- Initilizer

extension AdaptiveVGrid where ID == Data.Element.ID, Data.Element: Identifiable {
   init(_ data: Data, inColumn: Int, spacing: CGFloat = 10,
        @ViewBuilder content: @escaping (Data.Element) -> Content)
   {
      self.init(data, id: \.id, inColumn: inColumn, spacing: spacing, content: content)
   }
}

// MARK: -- Preview

struct AdaptiveVGrid_Previews: PreviewProvider {
   static var previews: some View {
      VStack {
         ScrollView {
            AdaptiveVGrid(ReminderIcon.allCases, inColumn: 2) { _ in
               Circle().aspectRatio(contentMode: .fit)
            }
            
            AdaptiveVGrid(ReminderIcon.allCases, inColumn: 6) { _ in
               Circle().aspectRatio(contentMode: .fit)
                  .foregroundColor(.red)
            }
         }
      }
   }
}

