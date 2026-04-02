//
//  NotificationManager.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/26/26.
//

import Foundation
import UserNotifications
import Observation

@Observable
final class NotificationManager: NSObject {
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .criticalAlert]) { granted, _ in
            if granted {
            
            }
        }
    }
    
    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    private func notificationID(for person: Person) -> String {
        "birthday-\(person.id.uuidString)"
    }
    
    func scheduleNotification(for person: Person) {
        if let notificationDate = person.notificationDate {
            let content = UNMutableNotificationContent()
            content.title = "Upcoming birthday"
            content.body = "\(person.name)'s birthday is coming up!"
            content.sound = .default
            content.userInfo = ["personID": person.id.uuidString]
            
            var components = Calendar.current.dateComponents(
                [.month, .day],
                from: notificationDate
            )
            components.hour = 12
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: true
            )
            let request = UNNotificationRequest(
                identifier: notificationID(for: person),
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func cancelNotification(for person: Person) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [notificationID(for: person)]
            )
    }
    
    func rescheduleNotification(for person: Person) {
        cancelNotification(for: person)
        scheduleNotification(for: person)
    }
    
    func updateReminder(for person: Person) {
        if person.notifications {
            scheduleNotification(for: person)
        } else {
            cancelNotification(for: person)
        }
    }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (
                UNNotificationPresentationOptions
            ) -> Void
        ) {
            completionHandler([.banner, .sound])
        }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            completionHandler()
        }
}
