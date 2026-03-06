//
//  PeopleRouter.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI
import Observation

enum Route: Hashable {
    case homeView
    case personView(person: Person)
    case giftView(gift: Gift)
}

enum SheetView: Hashable, Identifiable {
    case addEditPersonView(person: Person?)
    case addEditGiftView(gift: Gift?, person: Person)
    
    var id: String {
        switch self {
            case .addEditPersonView:
                return "addEditPersonView"
            case .addEditGiftView:
                return "addEditGiftView"
        }
    }
}

@Observable
final class PeopleRouter {
    var navigationPath = NavigationPath()
    var sheetPresenting: SheetView? = nil
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
            case .homeView:
                HomeView()
            case .personView(let person):
                PersonView(person: person)
            case .giftView(let gift):
                GiftView(gift: gift)
        }
    }
    
    func navigateTo(_ route: Route) {
        navigationPath.append(route)
    }
    
    func present(_ sheet: SheetView) {
        sheetPresenting = sheet
    }
    
    func dismissSheet() {
        sheetPresenting = nil
    }
}
