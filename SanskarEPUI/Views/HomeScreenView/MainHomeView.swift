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
                    imageName: "person.fill", employeeName: "AVINASH GUPTA",
                    employeeCode: "SANS-00298",
                    attendanceStatus: "Present",
                    employeeAttendance: "\(selectedAttendance?.inTime ?? "N/A") - \(selectedAttendance?.outTime ?? "N/A")"
                )
                
            }
            .padding(10)
            MonthlyCalendarView(selectedDate: $selectedDate, selectedAttendance: $selectedAttendance)
            AdminInfoView()
                .padding()
            Spacer()
        }
    }
}

// MARK: - Calendar Model
enum AttendanceStatus {
    case present
    case absent
    case weekend
    case holiday
    case unknown
}


struct CalendarDay: Identifiable, Hashable {
    let id = UUID()
    let date: Date?
    let status: AttendanceStatus?
}

// MARK: - Monthly Calendar View
struct MonthlyCalendarView: View {
    
    @Binding var selectedDate: Date
    @State private var currentMonth = Calendar.current.component(.month, from: Date())
    @State private var currentYear = Calendar.current.component(.year, from: Date())
    @State private var selectedDay: Int?
    @State private var epmDetails: [EpmDetails] = []
    @State private var selectedFullDate: Date?
    @Binding var selectedAttendance: EpmDetails?
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthYearFormatter.string(from: selectedDate))
                    .font(.title2).bold()
                
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            let weekdays = calendar.shortWeekdaySymbols
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }
            
            // Date grid
            let days = generateCalendarDays()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                    let isSelected = day.date != nil && calendar.component(.day, from: day.date!) == selectedDay
                    let isToday = day.date != nil && calendar.isDateInToday(day.date!)
                    let dayText = day.date != nil ? dayFormatter.string(from: day.date!) : ""
                    
                    Text(dayText)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(
                            index % 7 == 0
                            ? Color.orange
                            : isSelected
                            ? Color.blue
                            : isToday
                            ? Color.gray
                            : circleColor(for: day.status)
                        )
                        .foregroundColor(
                            index % 7 == 0 || isSelected || isToday ? .white : .primary
                        )
                        .clipShape(Circle())
                        .onTapGesture {
                            if let date = day.date {
                                selectedDay = calendar.component(.day, from: date)
                                selectedFullDate = date
                                updateAttendance(for: date)
                            }
                        }
                }
            }
            
        }
        .onAppear {
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: selectedDate)
            let currentYear = calendar.component(.year, from: selectedDate)
            getItemDetailByChallanId(currentMonth: String(currentMonth), currentYear: String(currentYear))
        }
        
        .padding()
        .background(Color.pink.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        .padding(.horizontal)
    }
 
    
    func updateAttendance(for date: Date) {
        let day = calendar.component(.day, from: date)
        if let attendance = epmDetails.first(where: {
            calendar.component(.day, from: date) == $0.date
        }) {
            self.selectedAttendance = attendance
            print("In: \(attendance.inTime ?? "N/A")")
            print("Out: \(attendance.outTime ?? "N/A")")
        }
        
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
            
            let newMonth = calendar.component(.month, from: newDate)
            let newYear = calendar.component(.year, from: newDate)
            
            getItemDetailByChallanId(currentMonth: String(newMonth), currentYear: String(newYear))
        }
    }
    
    private func generateCalendarDays() -> [CalendarDay] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }
        guard let dayRange = calendar.range(of: .day, in: .month, for: selectedDate) else {
            return []
        }
        let offset = (firstWeekday - calendar.firstWeekday + 7) % 7
        var days: [CalendarDay] = Array(repeating: CalendarDay(date: nil, status: nil), count: offset)
        for day in dayRange {
            if let date = calendar.date(bySetting: .day, value: day, of: selectedDate) {
                let status = getStatus(for: date)
                days.append(CalendarDay(date: date, status: status))
            }
        }
        return days
    }
    private func getStatus(for date: Date) -> AttendanceStatus {
        let day = calendar.component(.day, from: date)
        
        if let entry = epmDetails.first(where: { $0.date == day }) {
            switch entry.status {
            case -1:
                return .weekend      // Orange
            case 3:
                return .holiday      // Yellow
            case 1:
                return .absent       // Green
            case 0:
                return .present       // Red
            default:
                return .unknown
            }
        }
        return .weekend
    }
    
    private func circleColor(for status: AttendanceStatus?) -> Color {
        switch status {
        case .present:
            return .green
        case .absent:
            return .red
        case .weekend:
            return .orange
        case .holiday:
            return .yellow
        case .unknown, nil:
            return .white
        }
    }
    
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    func getItemDetailByChallanId(currentMonth : String , currentYear : String ) {
        var dict = [String: Any]()
        dict["EmpCode"] = "SANS-00345"
        dict["month"] = "\(currentMonth)"
        dict["year"] = "\(currentYear)"
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.monthWiseDetailApi,
            method: .post,
            param: dict,
            model: MonthWiseEmpDetail.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.epmDetails = data
                        self.selectedDay = calendar.component(.day, from: selectedDate)
                        ToastManager.shared.show(message: model.message ?? "Added Successfully")
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

// MARK: - HR Admin Info View
struct AdminInfoView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text("HR Admin").bold()
                Text("23-Apr-1988")
            }
            
            Spacer()
            
            Button(action: {
                print("Message tapped")
            }) {
                Text("Message")
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
