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
    @State private var name = "avinash Gupta"

    var body: some View {
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
                    employeeCode: "SANS-00298",
                    employeeAttendance: "\(selectedAttendance?.inTime ?? "N/A") - \(selectedAttendance?.outTime ?? "N/A")"
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

// MARK: - HR Admin Info View
struct AdminInfoView: View {
    @Binding var selectedDates: String
 
    @State private var eventDetails: [Events] = []
    var body: some View {
           VStack(spacing: 12) {
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
           .padding()
           .onAppear {
               eventOnSelectedDate()
           }
           .onChange(of: selectedDates) { _ in
               eventOnSelectedDate()
           }
       }

    
    func eventOnSelectedDate() {
       
        var dict = [String: Any]()
        dict["EmpCode"] = "SANS-00345"
        dict["req_date"] = selectedDates
        
        
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
