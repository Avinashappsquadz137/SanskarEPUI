//
//  MainHomeView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
//


import SwiftUI

struct MainHomeView: View {
    
    @State private var selectedDate = Date()
    @State private var selectedAttendance: EpmDetails? = nil
    @State private var selectedDayOnly: String = ""
    @State private var name: String = UserDefaultsManager.getName()
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MainNavigationBar(
                    logoName: "sanskar",
                    projectName: "SEP",
                    onSearchTapped: {
                        print("Search tapped")
                    },
                    onNotificationTapped: {
                        print("Notification tapped")
                    }
                )
                VStack(spacing: 16) {
                    EmployeeCard(
                        imageName: "person.fill", employeeName: "\(String(describing: name.uppercased()))",
                        employeeCode: "\(empCode)",
                        employeeAttendance: "\(selectedAttendance?.inTime ?? "N/A") - \(selectedAttendance?.outTime ?? "N/A")",ellipsisShow : true
                    )}
                .padding(10)
                MonthlyCalendarView(
                    selectedDate: $selectedDate,
                    selectedAttendance: $selectedAttendance,
                    selectedDayOnly: $selectedDayOnly
                )
                ScrollView{
                    AdminInfoView(selectedDates: $selectedDayOnly)
                }
                Spacer()
            }
        }
    }
}
