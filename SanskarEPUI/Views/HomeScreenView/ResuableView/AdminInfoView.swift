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
    private let moodOptions = ["😊", "😴", "😕", "🫠", "🤔"]
    @State private var selectedMood: String? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            if eventDetails.isEmpty {
                if selectedMood == nil {
                    VStack(spacing: 10) {
                        Text("How are you feeling today?")
                            .font(.headline)
                            .foregroundColor(.gray)
                        HStack(spacing: 16) {
                            ForEach(moodOptions, id: \.self) { mood in
                                Text(mood)
                                    .font(.system(size: 40))
                                    .onTapGesture {
                                        selectedMood = mood
                                    }
                            }
                        }
                    }
                    .padding()
                }
                if let mood = selectedMood {
                    VStack(spacing: 5) {
                        Text("Today Mood: ")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text(mood)
                            .font(.system(size: 100))
                            .foregroundColor(.gray)
                        Text("No Events Found")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            } else {
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

            }
        }
        .padding()
        .onAppear {
            eventOnSelectedDate()
        }
        .onChange(of: selectedDates) { _ in
            selectedMood = nil
            eventOnSelectedDate()
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
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
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
                NavigationLink(destination: BirthdayWishView(detail: detail)) {
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
                            Text(detail.name ?? "Unknown").bold().foregroundColor(.black)
                            Text(detail.bDay ?? "")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
                Button(action: {
                    print("Message tapped for \(detail.name ?? "Unknown")")
                }) {
                    Text("Message")
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
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

