//
//  UserDefultS.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 09/01/25.
//

import Foundation

extension Notification.Name {
    static let updateValueNotification = Notification.Name("updateValueNotification")
}


class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let fromDateKey = "fromDate"
    private let toDateKey = "toDate"
    private let isLoggedInKey = "isLoggedIn"
    private let isUserName =  "isUserName"
    private let emailKey = "userEmail"
    private let fCMToken = "FCMToken"
    
    func saveFromDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: fromDateKey)
    }

    func saveToDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: toDateKey)
    }

    func getFromDate() -> Date? {
        return UserDefaults.standard.object(forKey: fromDateKey) as? Date
    }

    func getToDate() -> Date? {
        return UserDefaults.standard.object(forKey: toDateKey) as? Date
    }
    
    func setLoggedIn(_ loggedIn: Bool) {
        UserDefaults.standard.set(loggedIn, forKey: isLoggedInKey)
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func setUserName(_ userName: String) {
        UserDefaults.standard.set(userName, forKey: isUserName)
    }
    
    func getUserName() -> String {
        return UserDefaults.standard.string(forKey: isUserName) ?? ""
    }
   
    func setEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: emailKey)
    }

    func getEmail() -> String {
        return UserDefaults.standard.string(forKey: emailKey) ?? ""
    }
    
    func setFCMToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: fCMToken)
    }

    func getFCMToken() -> String {
        return UserDefaults.standard.string(forKey: fCMToken) ?? ""
    }
    
}
