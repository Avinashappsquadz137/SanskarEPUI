//
//  BookingViewScreen.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 28/05/25.
//

import SwiftUI

struct BookingViewScreen: View {
    @State private var bookings: [NewBooking] = []
    @State private var navigateToAddKatha = false
    @State private var searchText = ""
    
    @State private var navigate = false
    @State private var selectedBooking: NewBooking?
    var body: some View {
        VStack {
            CustomNavigationBar(
                onSearch: { query in self.searchText = query },
                onAddListToggle: {  navigateToAddKatha = true },
                isListMode: false
            )
            NavigationLink(
                destination: BookKathaView(isSelected: false),
                isActive: $navigateToAddKatha
            ) {
                EmptyView()
            }
            .hidden()
            NavigationLink(
                         destination: selectedBooking.map { BookingApproveSchedule(booking: $0) },
                         isActive: $navigate
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
                                    navigate = true
                                }, name: booking.name, amount: booking.amount, gST: booking.gST, channelName: booking.channelName, venue: booking.venue, katha_date: booking.katha_date, katha_from_Date: booking.katha_from_Date, kathaTiming: booking.kathaTiming, slotTiming: booking.slotTiming, status: booking.status
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            getApproveKathalist()
        }
    }
    
    var filteredBookings: [NewBooking] {
        if searchText.isEmpty {
            return bookings
        } else {
            return bookings.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
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
