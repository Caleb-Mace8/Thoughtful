//
//  PeopleRootView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI
import SwiftData

struct PeopleRootView: View {
    @State var pRouter = PeopleRouter()
    var body: some View {
        NavigationStack(path: $pRouter.navigationPath) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    pRouter.view(for: route)
                }
        }
        .environment(pRouter)
    }
}

#Preview {
    PeopleRootView()
        .modelContainer(for: Person.self, inMemory: true)
}
