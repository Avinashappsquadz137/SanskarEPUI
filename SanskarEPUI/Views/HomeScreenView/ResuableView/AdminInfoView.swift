//
//  AdminInfoView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 29/04/25.
//

import SwiftUI

// MARK: - HR Admin Info View
struct AdminInfoView: View {
    @Binding var selectedDates: String
    @State private var eventDetails: [Events] = []
    @State private var selectedBirthdayGuest: Events? = nil

    var body: some View {
        VStack(spacing: 10) {
            ForEach(eventDetails, id: \.emp_Code) { detail in
                if detail.event_type?.lowercased() == "birthday" {
                    birthdayCell(detail: detail)
                } else if detail.event_type?.lowercased() == "leave" {
                    leaveCell(detail: detail)
                } else if detail.event_type?.lowercased() == "booking" {
                    bookingCell(detail: detail)
                }
            }
        }
        .padding()
        .onAppear {
            eventOnSelectedDate()
        }
        .onChange(of: selectedDates) { _ in
            eventOnSelectedDate()
        }
        .navigationDestination(isPresented: Binding<Bool>(
            get: { selectedBirthdayGuest != nil },
            set: { if !$0 { selectedBirthdayGuest = nil } }
        )) {
            if let guest = selectedBirthdayGuest {
                BirthdayWishView(detail: guest)
            }
        }

    }
    
    
    func eventOnSelectedDate() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        if selectedDates.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todayString = formatter.string(from: Date())
            dict["req_date"] = todayString
        } else {
            dict["req_date"] = selectedDates
        }
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.eventDetail,
            method: .post,
            param: dict,
            model: EventDetailsModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        eventDetails = data
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    func birthdayCell(detail: Events) -> some View {
        VStack {
            HStack {
                HStack {
                    if let imageUrl = detail.pImg, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(detail.name ?? "Unknown")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.black)
                        Text(detail.bDay ?? "")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                
                Button(action: {
                    selectedBirthdayGuest = detail
                }) {
                    Text("Message")
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(detail.actionStatus == "1" ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(detail.actionStatus == "1")
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }

    
    func leaveCell(detail: Events) -> some View {
        NavigationLink(destination: LeaveDetailView(detail: detail)) {
            HStack {
                Text(detail.name ?? "Unknown")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                VStack(alignment: .trailing) {
                    Text(detail.leave_type ?? "No Leave Type")
                        .foregroundColor(.gray)
                    Text("\(detail.from_date ?? "") To \(detail.to_date ?? "")")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                }
                Image(systemName: "arrowshape.right.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
    
    
    func bookingCell(detail: Events) -> some View {
        VStack {
            HStack {
                Text(detail.name ?? "Unknown")
                    .bold()
                Spacer()
                Text(detail.dept ?? "No Department")
                    .foregroundColor(.gray)
                Text("Booking")
                    .padding(5)
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(5)
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
    
    func check(status: String ) -> String {
        
        switch status {
        case "A":
            return " Approved"
        case "R":
            return " Pending"
        case "XA":
            return " Declined"
        case "X":
            return " Cancel"
        default:
            return ""
        }
    }
    
    func sColor(status: String ) -> UIColor {
        
        switch status {
        case "A":
            return .systemGreen
        case "R":
            return .systemBlue
        case "XA":
            return .systemRed
        case "X":
            return .systemPurple
        default:
            return .black
        }
    }
    
}

