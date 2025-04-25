//
//  Formate.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 25/04/25.
//
import Foundation

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

var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // or "dd-MMM-yyyy" depending on API
    formatter.timeZone = TimeZone(secondsFromGMT: 0) // IMPORTANT: Use UTC to avoid shift
    formatter.locale = Locale(identifier: "en_US_POSIX") // Consistent parsing
    return formatter
}()
