//
//  Thancho2App.swift
//  Thancho2
//
//  Created by 박지희 on 4/14/25.

import SwiftUI
import SwiftData

@main
struct Thancho2App: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(for: [Journal.self]) // ✅ SwiftData 연결
    }
}
