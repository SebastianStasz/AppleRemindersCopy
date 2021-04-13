//
//  ReminderIcon.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 02/04/2021.
//

import Foundation

@objc public enum ReminderIcon: Int, CaseIterable {
   case listBullet
   case bookmarkFill
   case pencilCircleFill
   case trashFill
   case paperplaneFill
   case bookFill
   case graduationcapFill
   case houseFill
   case externaldriveFill
   case docTextFill
   case textBookClosedFill
   case ticketFill
   case sunMaxFill
   case cloudFill
   case flameFill
   case starFill
   case bellFill
   case gearshapeFill
   case tvFill
   case gamecontrollerFill
   case carFill
   case hareFill
   case leafFill
   case paintbrushFill
   case stopwatchFill
   case heartFill
   case sealFill
   case megaphoneFill
   case wrenchAndScrewdriverFill
   case puzzlepieceFill
   case building2Fill
   case keyFill
   case signpostRightFill
   case moonFill
   case cloudBoltRainFill
   case dialMinFill
   
   var sfSymbol: String {
      switch self {
      case .listBullet:
         return "list.bullet"
      case .bookmarkFill:
         return "bookmark.fill"
      case .pencilCircleFill:
         return "pencil.circle.fill"
      case .trashFill:
         return "trash.fill"
      case .paperplaneFill:
         return "paperplane.fill"
      case .bookFill:
         return "book.fill"
      case .graduationcapFill:
         return "graduationcap.fill"
      case .houseFill:
         return "house.fill"
      case .externaldriveFill:
         return "externaldrive.fill"
      case .docTextFill:
         return "doc.text.fill"
      case .textBookClosedFill:
         return "text.book.closed.fill"
      case .ticketFill:
         return "ticket.fill"
      case .sunMaxFill:
         return "sun.max.fill"
      case .cloudFill:
         return "cloud.fill"
      case .flameFill:
         return "flame.fill"
      case .starFill:
         return "star.fill"
      case .bellFill:
         return "bell.fill"
      case .gearshapeFill:
         return "gearshape.fill"
      case .tvFill:
         return "tv.fill"
      case .gamecontrollerFill:
         return "gamecontroller.fill"
      case .carFill:
         return "car.fill"
      case .hareFill:
         return "hare.fill"
      case .leafFill:
         return "leaf.fill"
      case .paintbrushFill:
         return "paintbrush.fill"
      case .stopwatchFill:
         return "stopwatch.fill"
      case .heartFill:
         return "heart.fill"
      case .sealFill:
         return "seal.fill"
      case .megaphoneFill:
         return "megaphone.fill"
      case .wrenchAndScrewdriverFill:
         return "wrench.and.screwdriver.fill"
      case .puzzlepieceFill:
         return "puzzlepiece.fill"
      case .building2Fill:
         return "building.2.fill"
      case .keyFill:
         return "key.fill"
      case .signpostRightFill:
         return "signpost.right.fill"
      case .moonFill:
         return "moon.fill"
      case .cloudBoltRainFill:
         return "cloud.bolt.rain.fill"
      case .dialMinFill:
         return "dial.min.fill"
      }
   }
}

extension ReminderIcon: Identifiable {
   public var id: Int { rawValue }
}
