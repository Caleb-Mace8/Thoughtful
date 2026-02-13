//
//  RootView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI

struct RootView: View {
    @State var router = MainRouter()
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            HomeView()
                .navigationDestination(for: MainRouter.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environment(router)
    }
}

#Preview {
    RootView()
}
