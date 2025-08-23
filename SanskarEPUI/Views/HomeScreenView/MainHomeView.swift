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
    @State private var navigateSearchScreen = false
    @State private var navigateToProfile = false
    @State private var notificationCount: Int = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MainNavigationBar(
                    logoName: "sanskar",
                    projectName: "SEP",
                    onSearchTapped: {
                        navigateSearchScreen = true
                    },
                    onNotificationTapped: {
                        navigateNotification = true
                        print("Notification tapped")
                    },
                    notificationCount: notificationCount
                )
                VStack(spacing: 16) {
                    EmployeeCard(
                        imageName: "\(PImg)",
                        employeeName: name.uppercased(),
                        employeeCode: empCode,
                        employeeAttendance: {
                            let inTime = homeMasterDetailVM.masterDetail?.InTime ?? ""
                            let outTime = homeMasterDetailVM.masterDetail?.OutTime ?? ""

                            if inTime.isEmpty {
                                return Text("Absent")
                                    .foregroundColor(.red)
                                    .font(.callout)
                            } else {
                                return Text("In - \(inTime)" + (outTime.isEmpty ? "" : "  Out - \(outTime)"))
                                    .foregroundColor(.primary)
                                    .font(.callout)
                            }
                        }(),
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
                NavigationLink(
                    destination: MasterSearchScreenView(),
                    isActive: $navigateSearchScreen
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
        .onChange(of: homeMasterDetailVM.masterDetail) { newDetail in
            notificationCount = newDetail?.notification_count ?? 0
        }
        .navigationBarBackButtonHidden(true)
    }
}
