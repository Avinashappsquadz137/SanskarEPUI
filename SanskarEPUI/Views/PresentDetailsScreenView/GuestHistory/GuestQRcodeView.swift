//
//  GuestQRcodeView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/08/25.
//

import SwiftUI

struct GuestQRcodeView: View {
    var guest: GuestHistory
    
    @State private var qrImage: UIImage?
    @State private var showShareSheet = false
    
    var body: some View {
        VStack(spacing: 10) {
            if let name = guest.name {
                Text(name.uppercased())
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }

            if let thumb = guest.qrthumbnail, let url = URL(string: thumb) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(16)
                        .shadow(radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }
            
            if let name = guest.qrcode {
                Text(name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            Button(action: {
                showShareSheet = true
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share QR Code")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(14)
                .shadow(radius: 4)
            }
            .padding(.horizontal, 40)
            .sheet(isPresented: $showShareSheet) {
                if let qrImage = guest.qrthumbnail {
                        let shareMessage = """
                        Guest Details:
                        Name: \(guest.name ?? "Sanskar TV")
                        Date: \(guest.guest_date ?? "")
                        Reason: \(guest.reason ?? "")
                        """
                        ShareSheet(activityItems: [qrImage, shareMessage])
                        
                    } else if let qrText = guest.qrcode {
                        let shareMessage = """
                        Guest QR Code:
                        \(qrText)
                        """
                        ShareSheet(activityItems: [shareMessage])
                    }
            }
            
            Spacer()
        }
        .padding()
        
    }
}
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
