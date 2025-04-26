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

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current 
    return formatter
}()
