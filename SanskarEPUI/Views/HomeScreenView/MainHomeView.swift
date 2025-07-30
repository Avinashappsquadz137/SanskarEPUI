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
    @State private var PImg: String = UserDefaultsManager.getProfileImage()
    @StateObject private var calendarViewModel = MonthlyCalendarViewModel()
    @StateObject private var homeMasterDetailVM = HomeMasterDetailViewModel()
    @State private var navigateNotification = false
    @State private var navigateToProfile = false

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
                        imageName: "\(PImg)",
                        employeeName: name.uppercased(),
                        employeeCode: empCode,
                        employeeAttendance: "\(selectedAttendance?.inTime ?? "") - \(selectedAttendance?.outTime ?? "")",
                        type: .none,
                        onProfileTapped: {
                            navigateToProfile = true
                        }, showEditButton: false,
                        onEditTapped: nil
                    )
                }
                .padding(10)
                AllListView()
                Spacer()
                NavigationLink(
                    destination: NotificationHistoryListView()
                        .environmentObject(NotificationHandler.shared),
                    isActive: $navigateNotification
                ) {
                    EmptyView()
                }
                .hidden()
                NavigationLink(destination: UserProfileScreenView(), isActive: $navigateToProfile) {
                    EmptyView()
                }
                .hidden()

            }
        }
        .onAppear {
            homeMasterDetailVM.getMasterDetail()
        }
        .navigationBarBackButtonHidden(true)
    }
}
