//
//  MainLoginView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 08/07/25.
//

import SwiftUI

struct MainLoginView: View {
    
    @State private var mobile: String = "8130067305"
    @State private var digit1: String = ""
    @State private var digit2: String = ""
    @State private var digit3: String = ""
    @State private var digit4: String = ""
    @State private var showingLoginScreen = false
    @State private var showValidationError: Bool = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    enum PinField {
        case digit1, digit2, digit3, digit4
    }
    
    @FocusState private var focusedField: PinField?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Image("bgImageLogin")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {
                        Text("Employee")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("Portal")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                    }
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            TextField("Enter Your Mobile No", text: $mobile)
                                .keyboardType(.numberPad)
                                .font(.subheadline)
                                .padding(12)
                                .frame(height: 50)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                                .padding(.horizontal, 24)
                                .onChange(of: mobile) { newValue in
                                    mobile = String(newValue.prefix(10).filter { $0.isNumber })
                                    showValidationError = (mobile.count != 10 && !mobile.isEmpty)
                                }
                            
                            if showValidationError {
                                Text("Mobile number must be 10 digits.")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.horizontal, 24)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        HStack(spacing: 12) {
                            otpTextField(text: $digit1, next: .digit2, prev: nil, tag: .digit1)
                            otpTextField(text: $digit2, next: .digit3, prev: .digit1, tag: .digit2)
                            otpTextField(text: $digit3, next: .digit4, prev: .digit2, tag: .digit3)
                            otpTextField(text: $digit4, next: nil, prev: .digit3, tag: .digit4)
                        }
                        .padding(.horizontal, 24)
 
                        
                        CustonButton(title: "Login", backgroundColor: .orange) {
                            hideKeyboard()
                            LoginApi()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        NavigationLink(
                            destination: MainHomeView(),
                            isActive: $showingLoginScreen
                        ) {
                            EmptyView()
                        }
                    }
                    NavigationLink(destination: ForgetPassword()) {
                        Text("Forget Pin ?")
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.top)
                            .padding(.trailing, 28)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    Spacer()
                }
                Image("SanskarLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 130)
                    .padding(.top, 16)
                    .padding(.trailing, 16)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
        .overlay(ToastView())
    }
    
    // MARK: - OTP TextField
    func otpTextField(text: Binding<String>, next: PinField?, prev: PinField?, tag: PinField) -> some View {
        TextField("", text: text)
            .keyboardType(.numberPad)
            .frame(width: 80, height: 75)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .font(.title2)
            .multilineTextAlignment(.center)
            .focused($focusedField, equals: tag)
            .onChange(of: text.wrappedValue) { newValue in
                if newValue.count > 1 {
                    text.wrappedValue = String(newValue.prefix(1))
                }
                if newValue.count == 1 {
                    focusedField = next
                } else if newValue.isEmpty {
                    focusedField = prev
                }
            }
    }
    
    // MARK: - API Call
    func LoginApi() {
        let pin = digit1 + digit2 + digit3 + digit4
        let dict: [String: Any] = [
            "CntNo": mobile,
            "pin": pin,
            "Device-Id": UserDefaultsManager.deviceId,
            "User-Type": UserDefaultsManager.getDeviceType(),
            "Device-Model": UserDefaultsManager.getSavedDeviceModel(),
            "device_token": UserDefaultsManager.getFCMToken()
        ]
        print(dict)
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getlogin,
            method: .post,
            param: dict,
            model: LoginModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        if let userData = model.data {
                         
                            UserDefaultsManager.saveUserData(from: userData)
                            UserDefaultsManager.setLoggedIn(true)
                            UserDefaultsManager.setName(userData.name ?? "")
                            UserDefaultsManager.setEmpCode(userData.empCode ?? "")
                            print(userData.name ?? "")
                            print(userData.empCode ?? "")
                            ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                            showingLoginScreen = true
                        }
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "MobileNo and Pin doesn't Matched")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
}
