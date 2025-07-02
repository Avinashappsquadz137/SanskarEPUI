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
    @StateObject private var calendarViewModel = MonthlyCalendarViewModel()
    @State private var navigateNotification = false
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
                        navigateNotification = true
                        print("Notification tapped")
                    }
                )
                VStack(spacing: 16) {
                    EmployeeCard(
                        imageName: "person.fill",
                        employeeName: name.uppercased(),
                        employeeCode: empCode,
                        employeeAttendance: "\(selectedAttendance?.inTime ?? "") - \(selectedAttendance?.outTime ?? "")",
                        type: .none
                    )
                }
                .padding(10)
                AllListView()
                Spacer()
                NavigationLink(
                    destination: NotificationHistoryListView(),
                    isActive: $navigateNotification
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
}
