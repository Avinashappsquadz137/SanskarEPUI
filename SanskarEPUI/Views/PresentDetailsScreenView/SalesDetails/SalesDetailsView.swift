//
//  SalesDetailsView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/09/25.
//

import SwiftUI

// MARK: - Main View
struct SalesDetailsView: View {
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    @State private var employees: [SalesDetailsList] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                } else if employees.isEmpty {
                    Text("No employees found")
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(employees) { employee in
                                NavigationLink(destination: SalesEmployeeDetailsView(employeeCode: employee.empCode ?? "")) {
                                    SalesEmployeeRow(employee: employee)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Sales Team")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            salesDetailsAPI()
        }
    }
    
    // MARK: - API Call
    func salesDetailsAPI() {
        isLoading = true
        let dict: [String: Any] = ["EmpCode": empCode]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.salesDetailsList,
            method: .post,
            param: dict,
            model: SalesDetailsListModel.self,
            baseUrl: Constant.EP_BASEURL
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let model):
                    if model.status == true, let data = model.data {
                        self.employees = data
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                        print("API responded with failure: \(model)")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}

// MARK: - Row View
struct SalesEmployeeRow: View {
    let employee: SalesDetailsList
    
    var body: some View {
        HStack(spacing: 16) {
            profileImage
            
            VStack(alignment: .leading, spacing: 4) {
                Text(employee.name ?? "Unknown")
                    .font(.headline)
                Text(employee.designation ?? "SALES")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let code = employee.empCode {
                Text("#\(code)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
    
    private var profileImage: some View {
        Group {
            if let url = employee.empImage,
               !url.isEmpty,
               let imageUrl = URL(string: url) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.3))
                        .overlay(Text(initials(from: employee.name)))
                }
            } else {
                Circle().fill(Color.blue.opacity(0.3))
                    .overlay(Text(initials(from: employee.name)))
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
    }
}
