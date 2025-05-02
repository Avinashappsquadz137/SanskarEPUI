//
//  PunchHistoryView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 01/05/25.
//

import SwiftUI

struct PunchHistoryView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var attendanceData: [Attendance] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Select Period Header
            HStack {
                Text("Select Period")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
            }
            .padding(.horizontal)
            
            // Date Pickers
            HStack(spacing: 12) {
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke())

                DatePicker("", selection: $endDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke())
            }
            .padding(.horizontal)

            // Table Header
            HStack(spacing: 5) {
                Text("Date")
                    .bold()
                    .frame(width: 50, alignment: .center)
                Text("In Time")
                    .bold()
                    .frame(width: 70, alignment: .center)
                Text("Out Time")
                    .bold()
                    .frame(width: 70, alignment: .center)
                Text("Location")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(Color.gray.opacity(0.8))
            .foregroundColor(.white)

            // Table Rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(attendanceData, id: \.date) { record in
                        HStack(spacing: 5) {
                            Text("\(record.date ?? 0)")
                                .frame(width: 50, alignment: .center)
                            Text(record.inTime ?? "-")
                                .frame(width: 70, alignment: .center)
                            Text(record.outTime ?? "-")
                                .frame(width: 70, alignment: .center)
                            Text("\(record.locationIn ?? "-"), \(record.locationOut ?? "-")")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }
        }
        .padding(.top)
        .onAppear {
            punchHistoryAPI()
        }
    }
    
    func punchHistoryAPI() {
        var dict = [String: Any]()
        let empCode = UserDefaultsManager.getEmpCode()
        dict["EmpCode"] = empCode
        
//        let fromDateText = frombtn.title(for: .normal) ?? ""
//        let toDateText = tobtn.title(for: .normal) ?? ""
//        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: startDate)
      //  let currentMonth = calendar.component(.month, from: startDate)
//        if let fromDate = dateFormatter.date(from: fromDateText),
//           let toDate = dateFormatter.date(from: toDateText),
//           fromDateText != "From Date",
//           toDateText != "To Date" {
//            
//            let fromEpoch = String(Int(fromDate.timeIntervalSince1970 * 1000))
//            if let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate) {
//                let toEpoch = String(Int(endOfDay.timeIntervalSince1970 * 1000))
//                dict["to_date"] = toEpoch
//            }
//
//
//
//            dict["from_date"] = fromEpoch
//            dict["month"] = "-1"
//            dict["year"] = "\(currentYear)"
//        } else {
//            dict["month"] = String(format: "%02d", currentMonth)
//            dict["year"] = "\(currentYear)"
//        }
        dict["month"] = "5"//String(format: "%02d", currentMonth)
        dict["year"] = "\(currentYear)"
        
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getMonthWiseEmpDetail,
            method: .post,
            param: dict,
            model: PunchHistoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        attendanceData = data
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
