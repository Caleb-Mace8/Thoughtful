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
    var person: Person? = nil
    var people: [Person] = []
    var isPresenting: Bool = false
    
    // Helper function to create dates off year, month, and day values as Ints.
    
    func date(year: Int, month: Int, day: Int) -> Date {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        return Calendar.current.date(from: comps) ?? Date()
    }
    
    // Function to fetch the next month of people's birthdays and return them in an ordered list of what is coming up soonest.
    
    func findUpcomingEvents() -> [Person] {
        guard people != [] else { return [] }
        var upcomingPeople: [Person] = []
        let calendar = Calendar.current
        let today = Date.now
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: today)!
        for person in people {
            var bdComp = calendar.dateComponents([.month,.day], from: person.birthday)
            let todayYear = calendar.component(.year, from: today)
            let nextMonthYear = calendar.component(.year, from: nextMonth)
            if todayYear != nextMonthYear {
                if date(year: todayYear, month: bdComp.month!, day: bdComp.day!) < today {
                    bdComp.year = nextMonthYear
                } else {
                    bdComp.year = todayYear
                }
            } else {
                bdComp.year = todayYear
            }
            let birthday = calendar.date(from: bdComp)
            if let birthday {
                if birthday >= today && birthday <= nextMonth {
                    upcomingPeople.append(person)
                }
            }
        }
        upcomingPeople.sort {
            let todayYear = calendar.component(.year, from: today)
            let firstMonth = calendar.component(.month, from: $0.birthday)
            let firstDay = calendar.component(.day, from: $0.birthday)
            let secondMonth = calendar.component(.month, from: $1.birthday)
            let secondDay = calendar.component(.day, from: $1.birthday)
            if date(year: todayYear, month: firstMonth, day: firstDay) < today && date(year: todayYear, month: secondMonth, day: secondDay) < today {
                return date(year: todayYear + 1, month: firstMonth, day: firstDay) < date(year: todayYear + 1, month: secondMonth, day: secondDay)
            } else if date(year: todayYear, month: firstMonth, day: firstDay) < today {
                return date(year: todayYear + 1, month: firstMonth, day: firstDay) < date(year: todayYear, month: secondMonth, day: secondDay)
            } else if date(year: todayYear, month: secondMonth, day: secondDay) < today {
                return date(year: todayYear, month: firstMonth, day: firstDay) < date(year: todayYear + 1, month: secondMonth, day: secondDay)
            } else {
                return date(year: todayYear, month: firstMonth, day: firstDay) < date(year: todayYear, month: secondMonth, day: secondDay)
            }
        }
        return upcomingPeople
    }
}
