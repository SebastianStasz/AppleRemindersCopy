//
//  ReadingViewSize.swift
//  AppleRemindersCopy
//
//  Created by Sebastian Staszczyk on 05/04/2021.
//

import SwiftUI

// MARK: -- Reading View Size

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(geometryReader)
         .onPreferenceChange(SizePreferenceKey.self) { newValue in
            DispatchQueue.main.async { onChange(newValue) }
         }
    }
    
    private var geometryReader: some View {
        GeometryReader { geometryProxy in
            Color.clear
                .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
        }
    }
}

// MARK: -- Child to ancestors communication

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
