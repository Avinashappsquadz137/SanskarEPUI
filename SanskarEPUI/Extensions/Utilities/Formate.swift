//
//  Formate.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 25/04/25.
//
import Foundation
import UIKit

var dayFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
}

var monthYearFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current 
    return formatter
}()

 func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MMM-yyyy"
    return formatter.string(from: date)
}
extension Date {
    func toLocalTime() -> Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        return addingTimeInterval(seconds)
    }
}
// MARK: - Dismiss Keyboard
func hideKeyboard() {
   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                   to: nil, from: nil, for: nil)
}
func initials(from name: String?) -> String {
    guard let name = name else { return "" }
    let parts = name.split(separator: " ")
    let first = parts.first?.first.map { String($0) } ?? ""
    let last = parts.dropFirst().first?.first.map { String($0) } ?? ""
    return (first + last).uppercased()
}

func isTodayBirthday(_ dateString: String) -> Bool {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MMM-yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX") 
    
    guard let birthDate = formatter.date(from: dateString) else {
        return false
    }
    
    let calendar = Calendar.current
    let today = Date()
    
    let birthDay = calendar.component(.day, from: birthDate)
    let birthMonth = calendar.component(.month, from: birthDate)
    
    let todayDay = calendar.component(.day, from: today)
    let todayMonth = calendar.component(.month, from: today)
    
    return (birthDay == todayDay) && (birthMonth == todayMonth)
}
func shouldShowConfettiToday() -> Bool {
    let key = "confetti_shown_date"
    let today = Date().formatted(date: .abbreviated, time: .omitted)
    
    let lastShown = UserDefaults.standard.string(forKey: key)
    
    if lastShown == today {
        return false // already shown today
    } else {
        UserDefaults.standard.set(today, forKey: key)
        return true
    }
}
