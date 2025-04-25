//
//  EmployeeCard.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
//
import SwiftUI

struct EmployeeCard: View {
    var imageName: String = "person.fill"
    var employeeName: String = "AVINASH GUPTA"
    var employeeCode: String = "SANS-00301"
    var attendanceStatus: String = "Present"
    var employeeAttendance: String = "10:00 AM"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(employeeName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(employeeCode)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text(employeeAttendance)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(attendanceStatus)
                            .font(.subheadline)
                            .foregroundColor(attendanceStatus == "Present" ? .green : .red)
                        Spacer()
                        Button(action: {
                            print("More tapped")
                        }) {
                            Image(systemName: "ellipsis.circle")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
