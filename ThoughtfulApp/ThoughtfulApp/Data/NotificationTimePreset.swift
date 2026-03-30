//
//  NotificationTimePreset.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/24/26.
//


enum NotificationTimePreset: String, CaseIterable, Identifiable, Hashable {
    case aWeekBefore
    case twoWeeksBefore
    case aMonthBefore
    case custom
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
            case .aWeekBefore:
                return "A Week Before"
            case .twoWeeksBefore:
                return "Two Weeks Before"
            case .aMonthBefore:
                return "A Month Before"
            case .custom:
                return "Custom"
        }
    }

    // Gives the cases a Int value thats computed off the cases value
    
    var dayOffset: Int {
        switch self {
            case .aWeekBefore:
                return -7
            case .twoWeeksBefore:
                return -14
            case .aMonthBefore:
                return -30
            case .custom:
                return 0
        }
    }
}
