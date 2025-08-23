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
    @State private var notificationCount: Int = 0
    
    @State private var showNotice = false
    @State private var remindLaterTime: Date? = nil
    
    var body: some View {
        ZStack {
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
                    .hidden()
                    NavigationLink(destination: UserProfileScreenView(), isActive: $navigateToProfile) {
                        EmptyView()
                    }
                    .hidden()
                    
                }
            }
            if showNotice  , let detail = homeMasterDetailVM.masterDetail{
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                NoticePopupView(
                    title: detail.notice_title ?? "Notice",
                    message: detail.notice_message ?? "",
                    onGotIt: {
                        showNotice = false
                        remindLaterTime = nil
                        UserDefaults.standard.removeObject(forKey: "remindLaterTimes")
                    },
                    onRemindLater: {
                        showNotice = false
                        let nextTime = Date().addingTimeInterval(3600) // 1 hour
                        remindLaterTime = nextTime
                        UserDefaults.standard.set(nextTime, forKey: "remindLaterTimes")
                    }
                )
            }
        }
        .onAppear {
            homeMasterDetailVM.getMasterDetail()
        }
        .onChange(of: homeMasterDetailVM.masterDetail) { newDetail in
            notificationCount = newDetail?.notification_count ?? 0
            if let detail = newDetail, detail.notice_active == true {
                let savedRemindTime = UserDefaults.standard.object(forKey: "remindLaterTimes") as? Date
                if savedRemindTime == nil || savedRemindTime! <= Date() {
                    showNotice = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
