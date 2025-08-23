//
//  MasterSearchScreenView.swift
//  SanskarEPUI
//
//  Created by Avinash Gupta on 22/08/25.
//

import SwiftUI

struct MasterSearchScreenView: View {
    @State private var searchText = ""
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    @State private var employees: [MasterListSearch] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search...", text: $searchText)
                    .padding(.leading, 12)
                    .padding(.vertical, 8)
                    .padding(.trailing, 30)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        HStack {
                            Spacer()
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    employees = [] // clear results
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 8)
                            }
                        }
                    )
                    .onChange(of: searchText) { newValue in
                        if newValue.count >= 3 {
                            MasterListSearchAPI()
                        } else {
                            employees = []
                        }
                    }
            }
            .padding()
            
            if isLoading {
                ProgressView("Searching...")
                    .padding()
            }
            else if employees.isEmpty {
                // Show placeholder text when no list
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.6))
                    
                    Text("Search by Name or Employee Code")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(employees, id: \.empCode) { emp in
                        EmployeeCardView(employee: emp)
                    }
                }
                .padding(.horizontal)
            }
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Master Search Screen")
    }
    
    func MasterListSearchAPI() {
        let dict: [String: Any] = [
            "EmpCode": empCode,
            "Search": searchText
        ]
        isLoading = true
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.masterSearchList,
            method: .post,
            param: dict,
            model: MasterListSearchModel.self
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let model):
                    if model.status == true {
                        employees = model.data ?? []
                    } else {
                        employees = []
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                    }
                case .failure(let error):
                    employees = []
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
struct EmployeeCardView: View {
    let employee: MasterListSearch
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Top Section: Image + Basic Info
            HStack(alignment: .center, spacing: 16) {
                AsyncImage(url: URL(string: employee.pImgUrl ?? "")) { img in
                    img.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                
                VStack(alignment: .leading, spacing: 4) {
                    // Navigate on Name
                    //                    NavigationLink(destination: EmployeeDetailView(employee: employee)) {
                    Text(employee.name?.uppercased() ?? "Unknown")
                        .font(.headline)
                        .foregroundColor(.blue)
                    //                    }
                    
                    Text(employee.designation ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(employee.empCode ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(employee.dept ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            // Contact Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    Text(employee.emailID ?? "N/A")
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                    Text(employee.mobile ?? "N/A")
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: "teletype")
                        .foregroundColor(.green)
                    Text(employee.extn ?? "N/A")
                        .font(.subheadline)
                    
                }
            }
            
            Divider()
            
            // Leave Info Section
            HStack(spacing: 16) {
                if let plBalance = employee.pLBalance {
                    //                    NavigationLink(destination: LeaveDetailView(employee: employee)) {
                    VStack {
                        Text("PL Balance")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(plBalance)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    //                    }
                }
                
                VStack {
                    Text("Approved")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(employee.approveLeave ?? "0")
                        .bold()
                        .foregroundColor(.green)
                }
                
                VStack {
                    Text("Pending")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(employee.pendingLeave ?? "0")
                        .bold()
                        .foregroundColor(.orange)
                }
                
                VStack {
                    Text("Rejected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(employee.rejectLeave ?? "0")
                        .bold()
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}
