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
final class NotificationManager {
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
    
    func scheduleNotification(_ triggerDate: Date) {
        
    }
    
    func cancelNotification(_ identifier: String) {
        
    }
    
    func rescheduleNotification(identifier: String, triggerDate: Date) {
        cancelNotification(identifier)
        scheduleNotification(triggerDate)
    }
}
