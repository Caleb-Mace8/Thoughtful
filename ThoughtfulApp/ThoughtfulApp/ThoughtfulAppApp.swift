//
//  ThoughtfulAppApp.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI
import SwiftData

@main
struct ThoughtfulAppApp: App {
    var body: some Scene {
        WindowGroup {
            
        }
        .modelContainer(for: Person.self)
    }
}
