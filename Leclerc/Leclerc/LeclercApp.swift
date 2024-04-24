//
//  LeclercApp.swift
//  Leclerc
//
//  Created by Pablo Salas on 23/04/24.
//

import SwiftUI

@main
struct LeclercApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            } else {
                ContentView()
            }
        }
    }
}
