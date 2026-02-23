//
//  HomeViewModel.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/19/26.
//
import Observation
import Foundation

@Observable
class HomeViewModel {
    var people: [Person] = []
    
    func findUpcomingEvents() -> [Person] {
        guard people != [] else { return [] }
        var upcomingPeople: [Person] = []
        let today = Date.now
        let nextMonth = today.addingTimeInterval(60 * 60 * 24 * 30)
        
        for person in people {
            if person.birthday >= today, person.birthday <= nextMonth {
                upcomingPeople.append(person)
            }
        }
        return people.sorted { $0.birthday < $1.birthday }
    }
}
