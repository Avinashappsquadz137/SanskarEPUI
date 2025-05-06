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
        VStack(spacing: 10) {
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
                            Text("In-Time:")
                                .bold()
                            Text(selectedAttendance?.inTime ?? "--")
                        }
                        
                        HStack {
                            Text("Out-Time:")
                                .bold()
                            Text(selectedAttendance?.outTime ?? "--")
                        }
                    }
                    Spacer()
                }
                .padding(.leading)
                
                AdminInfoView(selectedDates: $selectedDayOnly)
                
                Spacer()
                
                LegendView()
            }
        }
        .navigationTitle("Calendar View")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}
struct LegendView: View {
    let items = [
        (Color.green, "Present"),
        (Color.red, "Absent / Leave"),
        (Color.blue, "Selected Date"),
        (Color.orange, "Weekend"),
        (Color.gray, "Today"),
        (Color.yellow, "Approved Leave")
    ]
    
    let columns = [
        GridItem(.flexible(minimum: 100), spacing: 16),
        GridItem(.flexible(minimum: 100), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Legend:")
                .font(.headline)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(items, id: \.1) { item in
                    LegendBullet(color: item.0, text: item.1)
                }
            }
        }
        .padding()
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
