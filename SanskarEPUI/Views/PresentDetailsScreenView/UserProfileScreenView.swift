//
//  UserProfileScreenView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import SwiftUI

struct UserProfileScreenView: View {
    
    @State private var name: String = UserDefaultsManager.getName()
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    let data = [
        "Available PL", "Joining Date", "Degignation", "Department", "Address","Reporting Authority","Pan Number","Aadhar Number","Blood Group"
    ]
    @State private var fieldValues: [String: String] = [:]
    var body: some View {
        VStack(spacing: 16) {
            EmployeeCard(
                imageName: "person.fill", employeeName: "\(String(describing: name.uppercased()))",
                employeeCode: "\(empCode)",
                employeeAttendance: "",ellipsisShow : false
            )
            .padding(.horizontal, 10)
           
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(data, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item)
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            TextField("Enter \(item)", text: Binding(
                                get: { fieldValues[item] ?? "" },
                                set: { fieldValues[item] = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            CustonButton(title: "Logout", backgroundColor: .orange) {
                print("Cancel button tapped!")
            }
            .padding(.horizontal, 10)
        }
        
        
    }
}

#Preview {
    UserProfileScreenView()
}
