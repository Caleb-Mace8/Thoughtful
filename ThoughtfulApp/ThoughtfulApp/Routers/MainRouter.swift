//
//  MainRouter.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//
import SwiftUI
import Observation

@Observable
final class MainRouter {
    var navigationPath = NavigationPath()
    
    enum Route: Hashable {
        case homeView
        case addEditPersonView(person: Person?)
        case personView(person: Person)
        case addEditGiftView(gift: Gift?, person: Person)
        case settingsView
    }
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
            case .homeView:
                HomeView()
            case .addEditPersonView(person: let person):
                EmptyView()
            case .personView(person: let person):
                EmptyView()
            case .addEditGiftView(gift: let gift, person: let person):
                EmptyView()
            case .settingsView:
                EmptyView()
        }
    }
    
    func navigateTo(_ route: Route) {
        navigationPath.append(route)
    }
}
