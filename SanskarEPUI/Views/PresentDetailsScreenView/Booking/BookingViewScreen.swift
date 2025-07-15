//
//  BookingViewScreen.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 28/05/25.
//
//roleID == 1  tyagi ji , permission 1
//roleID == 2 vipil ji , permission 2
//roleID == 3 sales , permission 3
//roleID == 4 reception, permission 4
//roleID == 5 HOD  , permission 5
//roleID == 6 employees
//roleID == 7 qc employee
//roleID == 8 Qc hod
//roleID == 9 Qc team by channel
//roleID == 10 Library
import SwiftUI

struct BookingViewScreen: View {
    @State private var bookings: [NewBooking] = []
    @State private var navigateToAddKatha = false
    @State private var searchText = ""
    @State private var showOnlyApproved = false
    @State private var navigateApprove = false
    @State private var navigateClientDetails = false
    @State private var selectedBooking: NewBooking?
    
    @State private var keyId: String? = nil
    @State private var dateRange: String = "all"
    @State private var selectDateStart: Date = Date()
    @State private var selectDateEnd: Date = Date()
    
    @State private var showDropdown = false
    @State private var dateKeyOptions: [GetDateKey] = []
    @State private var showCustomDatePicker = false
    
    var filteredBookings: [NewBooking] {
        if searchText.isEmpty {
            return bookings
        } else {
            return bookings.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    onFilter: {
                        if dateKeyOptions.isEmpty {
                            getDateKeyModel()
                        }
                        showDropdown.toggle()
                    },
                    onSearch: { query in self.searchText = query },
                    onAddListToggle: {  navigateToAddKatha = true },
                    isListMode: false,
                    showFilter: !showOnlyApproved
                )
                if showCustomDatePicker {
                    VStack(spacing: 16) {
                        DatePicker("Select Start Date", selection: $selectDateStart, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                        DatePicker("Select End Date", selection: $selectDateEnd, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                        
                        Button("Apply") {
                            self.kathaGetDataByDateAPI()
                            withAnimation {
                                showDropdown = false
                                showCustomDatePicker = false
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                }
                NavigationLink(
                    destination: BookKathaView(isSelected: false),
                    isActive: $navigateToAddKatha
                ) {
                    EmptyView()
                }
                .hidden()
                NavigationLink(
                    destination: selectedBooking.map { BookingApproveSchedule(booking: $0) },
                    isActive: $navigateApprove
                ) {
                    EmptyView()
                }.hidden()
                NavigationLink(
                    destination: selectedBooking.map { ClientDetailFormView(booking: $0) },
                    isActive: $navigateClientDetails
                ) {
                    EmptyView()
                }.hidden()
                if filteredBookings.isEmpty {
                    EmptyStateView(imageName: "EmptyList", message: "No Booking List found")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredBookings, id: \.katha_booking_id) { booking in
                                NewBookingCellView(
                                    config: NewBookingCellConfig(
                                        showAmount: true,
                                        showGST: true
                                    ), onTap: {
                                        selectedBooking = booking
                                        if  showOnlyApproved == false {
                                            navigateApprove = true
                                        } else {
                                            navigateClientDetails = true //clientDetail's Form
                                        }
                                        
                                    }, name: booking.name, amount: booking.amount, gST: booking.gST, channelName: booking.channelName, venue: booking.venue, katha_date: booking.katha_date, katha_from_Date: booking.katha_from_Date, kathaTiming: booking.kathaTiming, slotTiming: booking.slotTiming, status: booking.status
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            if showDropdown && !dateKeyOptions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(dateKeyOptions, id: \.key) { option in
                        Button(action: {
                            self.keyId = String(option.key ?? -3)
                            self.dateRange = option.date_range ?? "all"
                            if self.dateRange == "custom" {
                                withAnimation {
                                    self.showDropdown = false
                                    self.showCustomDatePicker = true
                                }
                            } else {
                                self.kathaGetDataByDateAPI()
                                withAnimation {
                                    self.showDropdown = false
                                    self.showCustomDatePicker = false
                                }
                            }
                        }) {
                            Text(option.date_range ?? "Unknown")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .foregroundColor(.black)
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(Color.gray.opacity(0.3)),
                            alignment: .bottom
                        )
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                .padding(.horizontal)
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Toggle("", isOn: $showOnlyApproved)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .labelsHidden()
            }
        }
        .onChange(of: showOnlyApproved) { value in
            resetDateFilter()
            if value {
                dateRange = ""
                kathaGetDataByDateAPI()
                getDateKeyModel()
            } else {
             
                getApproveKathalist()
            }
        }
        .onAppear {
            resetDateFilter()
            getApproveKathalist()
        }
        .onDisappear() {
            showOnlyApproved = false
        }
        .background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if showDropdown {
                        showDropdown = false
                    }
                }
        )
        
    }
    
    //assignBookingDetail
    
    func resetDateFilter() {
        dateRange = "all"
        keyId = nil
        showCustomDatePicker = false
        showDropdown = false
        selectDateStart = Date()
        selectDateEnd = Date()
    }

    func getApproveKathalist() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
            "category_id": "2"
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getApproveKathalist,
            method: .post,
            param: params,
            model: NewBookingModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.bookings = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func assignBookingDetailAPI() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.assignBookingDetail,
            method: .post,
            param: params,
            model: AssignBookingDetailModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                  
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    func kathaGetDataByDateAPI() {
        var dict: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        if keyId != nil
        {
            dict["value"]  = keyId
        }
        else
        {
            dict["value"]   = "-3"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if dateRange == "custom" {
            dict["start_date"] = formatter.string(from: selectDateStart)
            dict["end_date"] = formatter.string(from: selectDateEnd)
        } else {
            dict["start_date"] = ""
            dict["end_date"] = ""
        }
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaGetDataByDate,
            method: .post,
            param: dict,
            model: NewBookingModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.bookings = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    print(model.data)
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func getDateKeyModel() {
        var dict: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getDateKeyAPI,
            method: .post,
            param: dict,
            model: GetDateKeyModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.dateKeyOptions = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    print(model.data)
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    
}
struct NewBookingCellConfig {
    var showAmount: Bool = true
    var showGST: Bool = true
}


struct NewBookingCellView: View {
    
    var config: NewBookingCellConfig = NewBookingCellConfig()
    var onTap: (() -> Void)?
    
    let name : String?
    let amount : String?
    let gST : String?
    let channelName : String?
    let venue : String?
    let katha_date : String?
    let katha_from_Date : String?
    let kathaTiming : String?
    let slotTiming : String?
    let status : String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(name?.uppercased() ?? "N/A")")
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    onTap?()
                }) {
                    Image(systemName: "arrowshape.forward.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                
            }
            if config.showAmount || config.showGST {
                HStack {
                    Text("Amount: \(amount ?? "N/A")")
                        .font(.caption2)
                    Spacer()
                    Text("GST: \(gST ?? "N/A")")
                        .font(.caption2)
                }
            }
            
            HStack {
                Text("Channel: \(channelName ?? "N/A")")
                    .font(.caption2)
                Spacer()
                Text("Venue: \(venue ?? "N/A")")
                    .font(.caption2)
            }
            
            Text("Date: \(katha_date ?? katha_from_Date ?? "N/A")").font(.caption2)
            Text("Time: \(kathaTiming ?? slotTiming ?? "N/A")").font(.caption2)
            Text("Status: \(status ?? "N/A")").font(.caption2)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
