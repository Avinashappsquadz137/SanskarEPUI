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
                        print("Notification tapped")
                    }
                )
                VStack(spacing: 16) {
                    EmployeeCard(
                        imageName: "person.fill", employeeName: "\(String(describing: name.uppercased()))",
                        employeeCode: "\(empCode)",
                        employeeAttendance: "\(selectedAttendance?.inTime ?? "N/A") - \(selectedAttendance?.outTime ?? "N/A")",ellipsisShow : true
                    )
                    
                }
                .padding(10)
                MonthlyCalendarView(
                    selectedDate: $selectedDate,
                    selectedAttendance: $selectedAttendance,
                    selectedDayOnly: $selectedDayOnly
                )
                ScrollView{
                    AdminInfoView(selectedDates: $selectedDayOnly)
                }
                Spacer()
            }
        }
    }
}

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
                ForEach(eventDetails, id: \.emp_Code) { detail in
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
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(detail.name ?? "Unknown").bold()
                            Text("\(detail.dept ?? "")")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            print("Message tapped for \(detail.name ?? "")")
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
}
