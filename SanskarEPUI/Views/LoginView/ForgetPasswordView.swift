//
//  ForgetPasswordView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 08/07/25.
//

import SwiftUI

struct ForgetPassword: View {
    @State private var digit1: String = ""
    @State private var digit2: String = ""
    @State private var digit3: String = ""
    @State private var digit4: String = ""

    enum PinField {
        case digit1, digit2, digit3, digit4
    }

    @FocusState private var focusedField: PinField?

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bgImageLogin")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        Image("SanskarLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 130)
                            .padding(.top, 10)
                            .padding(.trailing, 16)
                    }
                    Text("Enter your OTP")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 8)

                    Spacer().frame(height: 20)
                    HStack(spacing: 12) {
                        otpTextField(text: $digit1, next: .digit2, prev: nil, tag: .digit1)
                        otpTextField(text: $digit2, next: .digit3, prev: .digit1, tag: .digit2)
                        otpTextField(text: $digit3, next: .digit4, prev: .digit2, tag: .digit3)
                        otpTextField(text: $digit4, next: nil, prev: .digit3, tag: .digit4)
                    }
                    .padding(.horizontal, 24)
                    Button(action: {
                        hideKeyboard()
                        let enteredOTP = digit1 + digit2 + digit3 + digit4
                        print("Entered OTP: \(enteredOTP)")
                    }) {
                        Text("Verify OTP")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    HStack {
                        Text("Didn't receive the code?")
                            .foregroundColor(.black)
                            .bold()

                        Button(action: {
                            print("Resend OTP tapped")
                        }) {
                            Text("Resend")
                                .foregroundColor(.red)
                                .bold()
                        }
                    }
                    .padding(.top, 12)

                    Spacer()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    // MARK: - OTP Field View
    func otpTextField(text: Binding<String>, next: PinField?, prev: PinField?, tag: PinField) -> some View {
        TextField("", text: text)
            .keyboardType(.numberPad)
            .frame(width: 70, height: 65)
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

}
