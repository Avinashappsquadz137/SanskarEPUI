//
//  BirthdayWishView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 29/04/25.
//

import SwiftUI

struct BirthdayWishView: View {
    let detail: Events
    @State private var messageText: String = ""
    
    let defaultMessages = [
        "Wishing you a day filled with love and cheer!",
        "Have a wonderful birthday!",
        "Happy Birthday! Stay blessed!"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Image
            if let imageUrl = detail.pImg, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 150, height: 150)
                .clipShape(Rectangle())
                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                .shadow(radius: 4)
               
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
            }
            
            Text("Happy Birthday")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("To our dear \(detail.name ?? "friend")")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Default Message Buttons
            VStack(alignment: .leading, spacing: 8) {
                Text("Select a message:")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                ForEach(defaultMessages, id: \.self) { msg in
                    Button(action: {
                        messageText = msg
                    }) {
                        Text(msg)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            // TextField
            TextField("Type your message here...", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Send Button
            Button(action: {
                print("Message sent: \(messageText)")
                // Add your actual send logic here
            }) {
                Text("Send")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
