//
//  AllListScreenView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import SwiftUI

struct AllListView: View {
    @State private var reqType: [SideBar] = []
    @StateObject private var store = GuestStore()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var searchText = ""
    var filteredReqType: [SideBar] {
        if searchText.isEmpty {
            return reqType
        } else {
            return reqType.filter { ($0.name ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    var body: some View {
        VStack {
            SearchBars(text: $searchText)
            ScrollView {
                LazyVGrid(columns: columns ,spacing: 8) {
                    ForEach(filteredReqType.indices, id: \.self) { index in
                        let item = filteredReqType[index]
                        NavigationLink(
                            destination: destinationView(for: item.id ?? 0)
                        ) {
                            CardView(item: item)
                                .padding(3)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            fetchSidebarAPI()
        }
    }
    
    func fetchSidebarAPI() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.sidebarapi,
            method: .post,
            param: dict,
            model: SideBarApi.self
        ) { result in
            DispatchQueue.main.async {
                switch result { 
                case .success(let model):
                    if var data = model.data {
                        data = data.filter { $0.id != 4 }
                        self.reqType = data
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for id: Int) -> some View {
        if id == 27 {
            UserProfileScreenView()
        } else if id == 2 {
            ApplyLeaveView()
        }else if id == 25 {
            PunchHistoryView()
                .navigationTitle("Punch History")
        }else if id == 101 {
            CalendarScreenView()
        } else if id == 8 {
            GuestRecordHistory()
                .environmentObject(store)
        } else if id == 17 {
            MyReportsViews()
                .navigationTitle("My Reports")
        } else if id  == 18 {
            AllReportsViews()
                .navigationTitle("All Reports")
        } else if id == 7 {
            let availableReport = reqType.map { $0.id ?? 0 }
            ReportsViews(availableReports : availableReport)
                .navigationTitle("Reports")
        } else if id == 22 {
            LeaveApprovalView()
                .navigationTitle("Leave Approval")
        }  else if id == 23 {
            BookingApprovalView()
                .navigationTitle("Booking Approval")
        }  else if id == 1{
            let approvalIDs = reqType.map { $0.id ?? 0 }
            ApprovalView(availableIDs: approvalIDs)
                .navigationTitle("Approval")
        } else if id == 14 {
            WebOpenerView(urlString: "https://app.sanskargroup.in/terms.html")
        }else if id ==  11 {
            HealthViewScreen()
                .navigationTitle("Health Policy Card")
        } else if id == 3 {
            Group {
                if UserDefaultsManager.getBookingRoleID() == "4" {
                    BookReceptionScreen()
                } else if UserDefaultsManager.getBookingRoleID() == "9" {
                    QCMetaViewScreen()
                } else {
                    BookingViewScreen()
                }
            }
            .navigationTitle("Booking View")
        }else if id == 5 {
            RequestViewScreen()
                .navigationTitle("Request View")
        }else if id == 6 {
            MainTourView()
                .navigationTitle("TOUR")
        }else if id  == 24 {
            SelfPunchView()
                .navigationTitle("Self Punch")
        }else if id == 26 {
            CalendarScreenView()
        }else if id == 28 {
            if UserDefaultsManager.getBookingRoleID() == "3" {
                SalesEmployeeDetailsView(employeeCode: UserDefaultsManager.getEmpCode())
            }else if UserDefaultsManager.getBookingRoleID() == "1" {
                SalesDetailsView()
            }else {
                Text("Work In Progress")
            }
        } else {
            Text("Work In Progress")
        }
    }
}

// MARK: - Subview to simplify NavigationLink label

struct CardView: View {
    let item: SideBar
    
    var body: some View {
        HStack(spacing: 5) {
            Image(uiImage: imageForID(item.id ?? 0))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text(item.name ?? "")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .minimumScaleFactor(0.8)
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width / 2  - 30)
        .background(Color(.white))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
    }
    
    private func imageForID(_ id: Int) -> UIImage {
        switch id {
        case 1: return UIImage(named: "approved") ?? defaultImage()
        case 2: return UIImage(named: "Leave") ?? defaultImage()
        case 3: return UIImage(named: "booking") ?? defaultImage()
        case 4: return UIImage(named: "Inventory") ?? defaultImage()
        case 5: return UIImage(named: "interview") ?? defaultImage()
        case 6: return UIImage(named: "Tour") ?? defaultImage()
        case 7: return UIImage(named: "Reports") ?? defaultImage()
        case 8: return UIImage(named: "Guest") ?? defaultImage()
        case 11: return UIImage(named: "healthcare") ?? defaultImage()
        case 14: return UIImage(named: "Privacy Policy") ?? defaultImage()
        case 17: return UIImage(named: "Reports") ?? defaultImage()
        case 18: return UIImage(named: "Reports") ?? defaultImage()
        case 24: return UIImage(named: "biometricAttendance") ?? defaultImage()
        case 25: return UIImage(named: "attendance") ?? defaultImage()
        case 23: return UIImage(named: "booking") ?? defaultImage()
        case 22: return UIImage(named: "Leave") ?? defaultImage()
        case 27: return UIImage(named: "Profile") ?? defaultImage()
        case 26:return UIImage(named: "Leave") ?? defaultImage()
        case 28:return UIImage(named: "SalesIcon") ?? defaultImage()
        default: return defaultImage()
        }
    }
    
    private func defaultImage() -> UIImage {
        return UIImage(named: "default") ?? UIImage(systemName: "questionmark.square")!
    }
}
struct WebOpenerView: View {
    let urlString: String

    var body: some View {
        Text("Opening Web Page...")
            .onAppear {
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
    }
}
