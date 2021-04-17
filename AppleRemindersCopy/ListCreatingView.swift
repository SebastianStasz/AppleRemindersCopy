//
//  ListCreatingView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 04/04/2021.
//

import SwiftUI

struct ListCreatingView: View {
   @Environment(\.managedObjectContext) private var context
   @Environment(\.presentationMode) private var presentation
   @Environment(\.colorScheme) private var scheme
   @StateObject private var listVM = ReminderListFormVM()
   private let listToEdit: ReminderListEntity?
   
   init(listToEdit: ReminderListEntity? = nil) {
      self.listToEdit = listToEdit
   }
   
   private let backgroundColor: Color = .secondarySystemGroupedBackground
   private let mainIconCircleSize: CGFloat = 120
   private let mainPadding: CGFloat = 30
   private var navigationTitle: String {
      listToEdit == nil ? "New List" : "Name & Appearance"
   }
   
   var body: some View {
      VStack(spacing: mainPadding) {
         
         ImageInCircle(icon: listVM.icon.sfSymbol, padding: 30, color: listVM.color.color, iconColor: .white)
            .frame(width: mainIconCircleSize)
         
         TextField("", text: $listVM.name)
            .textFieldStyle(SecondaryTextFieldStyle(color: listVM.color.color))
            .padding(.vertical, 10)
            .padding(.horizontal)
         
         ScrollView {
            VStack {
               AdaptiveVGrid(ReminderColor.allCases, inColumn: 2) { color in
                  circleColor(color: color)
               }
               .padding(.bottom, 16).padding(.top, 8)
               
               AdaptiveVGrid(ReminderIcon.allCases, inColumn: 6) { icon in
                  ImageInCircle(icon: icon.sfSymbol, padding: 9)
                     .selectionIndicator(listVM.icon == icon)
                     .onTapGesture { listVM.icon = icon }
               }
               .padding(.bottom, mainPadding)
            }
            .padding(.horizontal)
         }
         .oneEdgeBorder(edge: .top, lineWidth: 2, color: .tertiarySystemGroupedBackground)
      }
      .padding(.top, mainPadding + 20)
      .edgesIgnoringSafeArea(.bottom)
      .background(backgroundColor.ignoresSafeArea())
      .toolbar { navigationBar }
      .embedInNavigation(mode: .inline, title: navigationTitle)
      .onAppear(perform: viewDidLoad)
   }
   
   private var navigationBar: some ToolbarContent {
      Group {
         ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel", action: dismiss)
         }
         ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done", action: saveChanges)
               .disabled(!listVM.isValid)
         }
      }
   }
   
   private func circleColor(color: ReminderColor) -> some View {
      Circle()
         .fill(color.color)
         .aspectRatio(contentMode: .fill)
         .selectionIndicator(listVM.color == color)
         .onTapGesture{ listVM.color = color }
   }
   
   private func viewDidLoad() {
      if let list = listToEdit {
         listVM.listToEdit = list
      }
   }
   
   // MARK: -- Intents
   
   private func dismiss() {
      presentation.wrappedValue.dismiss()
   }
   
   private func saveChanges() {
      listVM.saveChanges()
      dismiss()
   }
}

// MARK: -- Preview

struct ListCreatingView_Previews: PreviewProvider {
   static var previews: some View {
      ListCreatingView(listToEdit: nil)
         .previewDevice("iPhone 12")
         .preferredColorScheme(.dark)
   }
}

extension View {
   func selectionIndicator(_ isSelected: Bool) -> some View {
      self
         .padding(6)
         .overlay(Circle()
                     .strokeBorder(lineWidth: 2.5)
                     .opacity(isSelected ? 0.5 : 0))
   }
}
