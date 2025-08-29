//
//  ReturnChallanView.swiftqrcode.viewfinder
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 09/01/25.
//
import SwiftUI

struct GuestQRView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Environment(\.presentationMode) var presentationMode
    @State private var showDateilScreen = false
    @State var isShowingScannerQR = false
    @Binding var isShowingScanner: Bool
    @State private var scannedText = ""
    @State private var checkedStates: [String] = []
    let itemTitles = ["Scan QR", "Enter QR ID"]
    let itemImages = ["qrcode.viewfinder", "number"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<itemImages.count, id: \.self) { index in
                        QRScanCell(
                            index: index,
                            title: itemTitles[index], imageName: itemImages[index]
                        ) { tappedIndex in
                            print("Tapped on item with index: \(tappedIndex)")
                            if tappedIndex == 0 {
                                isShowingScannerQR = true
                            } else if tappedIndex == 1 {
                                showDateilScreen = true
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Guest QR Scan") 
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
                .fullScreenCover(isPresented: $isShowingScannerQR) {
                    QRScannerView(isShowingScanner: $isShowingScannerQR, scannedText: $scannedText)
                }
                .fullScreenCover(isPresented: $showDateilScreen) {
                    QRScannedByID().environment(\.colorScheme, .light)
                }
        }
    }
    
}
