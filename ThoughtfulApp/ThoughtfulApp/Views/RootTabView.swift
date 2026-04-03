//
//  RootTabView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/6/26.
//

import SwiftUI

struct RootTabView: View {
    
    var body: some View {
        TabView {
            Tab("People", systemImage: "person.2") {
                HomeView()
            }
            Tab("Lists", systemImage: "book.pages") {
                ListsRootView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(.accent)
    }
}

#Preview {
    RootTabView()
}
