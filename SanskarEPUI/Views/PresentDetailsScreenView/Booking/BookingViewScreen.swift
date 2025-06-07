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
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                onSearch: { query in self.searchText = query },
                onAddListToggle: {  navigateToAddKatha = true },
                isListMode: false
            )
            NavigationLink(
                destination: BookKathaView(),
                isActive: $navigateToAddKatha
            ) {
                EmptyView()
            }
            .hidden()
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredBookings, id: \.katha_booking_id) { booking in
                        NewBookingCellView(
                            booking: booking
                        )
                    }
                }
                .padding()
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

struct NewBookingCellView: View {
    let booking: NewBooking
    @State private var navigate = false
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(booking.name ?? "N/A")")
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    navigate = true
                }) {
                    Image(systemName: "arrowshape.forward.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                NavigationLink(destination: BookingApproveSchedule(booking: booking), isActive: $navigate) {
                    EmptyView()
                }
            }
            HStack {
                Text("Amount: \(booking.amount ?? "N/A")")
                    .font(.caption2)
                Spacer()
                Text("GST: \(booking.gST ?? "N/A")")
                    .font(.caption2)
            }
            
            HStack {
                Text("Channel: \(booking.channelName ?? "N/A")")
                    .font(.caption2)
                Spacer()
                Text("Venue: \(booking.venue ?? "N/A")")
                    .font(.caption2)
            }
            
            Text("Date: \(booking.katha_date ?? booking.katha_from_Date ?? "N/A")").font(.caption2)
            Text("Time: \(booking.kathaTiming ?? booking.slotTiming ?? "N/A")").font(.caption2)
            Text("Status: \(booking.status ?? "N/A")").font(.caption2)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
