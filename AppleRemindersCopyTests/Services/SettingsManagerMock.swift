//
//  SettingsManagerMock.swift
//  AppleRemindersCopyTests
//
//  Created by Sebastian Staszczyk on 25/04/2021.
//

import Foundation
@testable import AppleRemindersCopy

struct SettingsManagerMock: SettingsProtocol {
   private(set) var defaultTriggerTime = ["hour": 13, "minute": 0]
}
