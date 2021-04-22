//
//  ReminderListFormView.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 04/04/2021.
//

import SwiftUI

struct ReminderListFormView: View {
   @Environment(\.managedObjectContext) private var context
   @Environment(\.presentationMode) private var presentation
   @Environment(\.colorScheme) private var scheme
   @EnvironmentObject private var sheet: SheetController
   
   @StateObject private var listVM = ReminderListFormVM()
   @State private var alert: DiscardChangesAlert?
   private let listToEdit: ReminderListEntity?
   private let sheetToOpenAfterDismiss: ActiveSheet?
   
   init(listToEdit: ReminderListEntity? = nil, sheetToOpenAfterDismiss: ActiveSheet? = nil) {
      self.listToEdit = listToEdit
      self.sheetToOpenAfterDismiss = sheetToOpenAfterDismiss
   }
   
   private let backgroundColor: Color = .secondarySystemGroupedBackground
   private let mainIconCircleSize: CGFloat = 120
   private let mainPadding: CGFloat = 30
   private var title: String {
      listToEdit == nil ? "New List" : "Name & Appearance"
   }
   
   var body: some View {
      VStack(spacing: mainPadding) {
         
         ImageInCircle(icon: listVM.form.icon.sfSymbol, padding: 30, color: listVM.form.color.color, iconColor: .white)
            .frame(width: mainIconCircleSize)
         
         TextField("", text: $listVM.form.name)
            .textFieldStyle(SecondaryTextFieldStyle(color: listVM.form.color.color))
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
                     .selectionIndicator(listVM.form.icon == icon)
                     .onTapGesture { listVM.form.icon = icon }
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
      .embedInNavigation(mode: .inline, title: title)
      .onAppear(perform: viewDidLoad)
      .alert(item: $alert) { $0.body }
   }
   
   private var navigationBar: some ToolbarContent {
      Group {
         ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel", action: close)
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
         .selectionIndicator(listVM.form.color == color)
         .onTapGesture{ listVM.form.color = color }
   }
   
   // MARK: -- Intents
   
   private func close() {
      listVM.hasChanged ? presentAlert() : dismiss()
   }
   
   private func saveChanges() {
      listVM.saveChanges()
      dismiss()
   }
   
   // MARK: -- Helpers
   
   private func presentAlert() {
      alert = .init(presentationMode: presentation, title: title)
   }
   
   private func dismiss() {
      sheet.activeSheet = sheetToOpenAfterDismiss
   }
   
   private func viewDidLoad() {
      listVM.listToEdit = listToEdit
   }
}

// MARK: -- Preview

struct ListCreatingView_Previews: PreviewProvider {
   static var previews: some View {
      ReminderListFormView(listToEdit: nil)
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
