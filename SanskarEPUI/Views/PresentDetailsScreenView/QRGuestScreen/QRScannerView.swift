//
//  QRScannerView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 30/12/24.
//

import SwiftUI
import VisionKit

struct QRScannerView: View {
    @Binding var isShowingScanner: Bool
    @Binding var scannedText: String
    
    @State private var showAddButton: Bool = false 
    
    var body: some View {
        NavigationView {
            VStack {
                if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                    ZStack {
                        QRCodeScannerView { newValue in
                            scannedText = newValue
                            if !newValue.isEmpty {
                                showAddButton = true
                            }
                        }
                        .frame(width: 300, height: 300)
                        .border(Color.gray, width: 2)
                    }
                    if showAddButton {
                        Button(action: {
                            // Handle "Add Item" button tap
                            print("Scanned Text: \(scannedText)")
                            addQRItemDetail()
                          
                        }) {
                            Text("Verify Guest")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                } else {
                    Text("Scanner not available or supported")
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("QR Scanner")
            .navigationBarItems(trailing: Button("Close") {
                isShowingScanner = false
            })
        }
        .overlay(ToastView())
    }
    func addQRItemDetail() {
        let parameters: [String: Any] =
        [
         "EmpCode": "\(UserDefaultsManager.getEmpCode())",
         "Qrcode": "\(scannedText)"
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
                                isShowingScanner = false
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
