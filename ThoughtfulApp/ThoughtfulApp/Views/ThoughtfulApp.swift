//
//  ThoughtfulApp.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct ThoughtfulApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State var notificationManager = NotificationManager()

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootTabView()
                if !hasCompletedOnboarding {
                    OnboardingFlow(isPresented: Binding(
                        get: { !hasCompletedOnboarding },
                        set: { newValue in hasCompletedOnboarding = !newValue }
                    ))
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
        .environment(notificationManager)
        .modelContainer(for: Person.self)
    }
}
