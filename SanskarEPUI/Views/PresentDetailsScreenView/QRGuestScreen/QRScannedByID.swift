//
//  ReturnChallanByID.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 10/01/25.
//

import SwiftUI

struct QRScannedByID: View {
    
    @State private var textFieldValue: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    Text("Enter QR ID")
                        .font(.title)
                        .fontWeight(.bold)
                        .keyboardType(.numberPad)
                    TextField("Enter QR ID", text: $textFieldValue)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: textFieldValue) { newValue in
                            // ✅ Allow only numbers and limit to 6 digits
                            textFieldValue = newValue.filter { $0.isNumber }
                            if textFieldValue.count > 6 {
                                textFieldValue = String(textFieldValue.prefix(6))
                            }
                        }
                        .padding(.bottom, 10)
                    
                    if textFieldValue.count == 6 {
                        Button(action: {
                            print("Button tapped with text: \(textFieldValue)")
                            addQRItemDetail()
                        }) {
                            Text("SUBMIT")
                                .font(.headline)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
            .padding()
            
            .navigationTitle("Enter QR ID")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }.overlay(ToastView())
        }
    }
        func addQRItemDetail() {
            let parameters: [String: Any] =
            [
             "EmpCode": "\(UserDefaultsManager.getEmpCode())",
             "Qrcode": "\(textFieldValue)"
            ]
            ApiClient.shared.callmethodMultipart(
                apiendpoint: Constant.guestInByQrcode,
                method: .post,
                param: parameters,
                model: GetSuccessMessage.self
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if let data = model.data {
                            print("Fetched items: \(data)")
                            if model.status == true {
                                ToastManager.shared.show(message: model.message ?? "Successfully added")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } else {
                                ToastManager.shared.show(message: model.message ?? "Not valid QR code")
                            }
                        } else {
                            print("No data received")
                        }
                    case .failure(let error):
                        ToastManager.shared.show(message: "Not valid QR code or already added")
                        print("API Error: \(error)")
                    }
                }
            }
        }
    }
    

