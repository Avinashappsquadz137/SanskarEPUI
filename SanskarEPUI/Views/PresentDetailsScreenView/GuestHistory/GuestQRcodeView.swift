//
//  GuestQRcodeView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/08/25.
//

import SwiftUI

struct GuestQRcodeView: View {
    @EnvironmentObject var store: GuestStore
    
    @State private var showShareSheet = false
    
    var body: some View {
        if let guest = store.selectedGuest {
            VStack(spacing: 10) {
                
                if let name = guest.name {
                    Text(name.uppercased())
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                
                if let thumb = guest.qrthumbnail,
                   let url = URL(string: thumb) {
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
                
                if let code = guest.qrcode {
                    Text(code)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    showShareSheet = true
                } label: {
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
                    if let thumb = guest.qrthumbnail {
                        TicketShareView(imageURL: thumb, guest: guest)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct TicketShareView: View {
    
    let imageURL: String
    let guest: GuestHistory
    
    @State private var generatedImage: UIImage? = nil
    
    var body: some View {
        Group {
            if let img = generatedImage {
                
                let message = """
                Name: \(guest.name ?? "")
                QR: \(guest.qrcode ?? "")
                Date: \(guest.reqdate ?? "")
                Reason: \(guest.reason ?? "")
                """
                
                ShareSheet(activityItems: [img, message])
                
            } else {
                ProgressView("Preparing Ticket...")
                    .onAppear {
                        loadImage(from: imageURL) { image in
                            if let qrImg = image {
                                generatedImage = generateTicketImage(qrImage: qrImg, guest: guest)
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - Image Load
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - Ticket Image Generator
    func generateTicketImage(qrImage: UIImage, guest: GuestHistory) -> UIImage {
        let size = CGSize(width: 350, height: 450)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { ctx in
            let context = ctx.cgContext

            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            let qrSize: CGFloat = 350
            let x = (size.width - qrSize) / 2
            let y = (size.height - qrSize) / 2
            let name = "SANSKAR VISITOR"
            let nameAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            name.draw(at: CGPoint(x: 20, y: 20), withAttributes: nameAttr)
            // Draw QR
            qrImage.draw(in: CGRect(x: x, y: y, width: qrSize, height: qrSize))
        }
    }
}

