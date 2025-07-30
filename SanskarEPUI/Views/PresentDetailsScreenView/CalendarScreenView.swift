//
//  CalendarScreenView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 03/05/25.
//


import SwiftUI

struct CalendarScreenView: View {
    @State private var selectedDate = Date()
    @State private var selectedAttendance: EpmDetails? = nil
    @State private var selectedDayOnly: String = ""

    var body: some View {
        VStack(spacing: 8) {
            MonthlyCalendarView(
                selectedDate: $selectedDate,
                selectedAttendance: $selectedAttendance,
                selectedDayOnly: $selectedDayOnly
            )
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        if !selectedDayOnly.isEmpty {
                            Text("Selected Date: \(selectedDayOnly)")
                                .font(.headline)
                        }
                        HStack {
                            if let inTime = selectedAttendance?.inTime, !inTime.isEmpty {
                                Text("In-")
                                    .bold()
                                Text(inTime)
                            }
                            if let outTime = selectedAttendance?.outTime, !outTime.isEmpty {
                                Text("Out-")
                                    .bold()
                                Text(outTime)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading)
                LegendView()
                AdminInfoView(selectedDates: $selectedDayOnly)
                
                Spacer()
            }
        }
        .navigationTitle("Calendar View")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}
struct LegendView: View {
    let items = [
        (Color.green, "Present"),
        (Color.orange, "Absent"),
        (Color.red, "Weekend"),
        (Color.yellow, "Approved Leave")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(items, id: \.1) { item in
                    LegendBullet(color: item.0, text: item.1)
                }
            }
            .padding()
        }
    }
}

struct LegendBullet: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .font(.caption)
        }
    }
}
