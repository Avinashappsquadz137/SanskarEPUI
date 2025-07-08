//
//  UserProfileScreenView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import SwiftUI

struct UserProfileScreenView: View {
    @State private var showLogoutAlert: Bool = false
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
                employeeAttendance: "",type: .pencil
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
                showLogoutAlert = true
            }
            .padding(.horizontal, 10)
        }
        .alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you really want to log out?"),
                primaryButton: .destructive(Text("Log Out")) {
                    LogoutApi()
                },
                secondaryButton: .cancel()
            )
        }.overlay(ToastView())
        
    }
    func LogoutApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getlogout,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        print("API Success: \(model)")
                        ToastManager.shared.show(message: model.message ?? "Logout Device Successfully")
                        UserDefaultsManager.removeUserData()
                        UserDefaultsManager.setLoggedIn(false)
                        logout()
                        
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    func logout() {
        UserDefaultsManager.setLoggedIn(false)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: MainLoginView().environment(\.colorScheme, .light))
                window.makeKeyAndVisible()
            }
        }
    }
}

