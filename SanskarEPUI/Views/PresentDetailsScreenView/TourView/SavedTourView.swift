//
//  SavedTourView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/06/25.
//

import SwiftUI
import PhotosUI

struct SavedTourView: View {
    let request: BillingList
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var fileName: String = ""
    @State private var description = ""
    @State private var amounts = ""
    @State private var showDateilScreen = false
    @Environment(\.presentationMode) var presentationMode
    
    var totalAmount: Double = 0.0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            // Main Card
            ScrollView{
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("TourId:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(request.tourID ?? "")
                            .truncationMode(.tail)
                        
                    }
                    
                    HStack {
                        Text("Location:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(request.location ?? "")
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    HStack {
                        Text("Amount")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("₹\(String(format: "%.2f", calculateTotalAmount()))")
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Add Bill Image Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Add Bill Image")
                            .fontWeight(.semibold)
                        Spacer()
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Image(systemName: "plus.square.dashed")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if let selectedImage = selectedImage {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                            
                            Image(systemName: "plus.square.dashed")
                                .padding(8)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .padding(5)
                        }
                        
                        if !fileName.isEmpty {
                            Text("File: \(fileName)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    TextField("Enter Amount", text: $amounts)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                    TextField("Enter Description", text: $description)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                    CustonButton(title: "SAVE", backgroundColor: .orange) {
                        
                    }
  
                    CustonButton(title: "Preview", backgroundColor: .orange) {
                        showDateilScreen = true
                    }
                    
                }
                
                .fullScreenCover(isPresented: $showDateilScreen) {
                    NavigationStack {
                        VStack {
                            ScrollView {
                                if let details = request.alldata {
                                    VStack(spacing: 12) {
                                        ForEach(details.indices, id: \.self) { index in
                                            let detail = details[index]
                                            BillingDetailCard(
                                                sno: index + 1,
                                                amount: detail.amount ?? "0",
                                                imageName: detail.billing_thumbnail,
                                                onEdit: {
                                                    print("Edit tapped for SNO \(index + 1)")
                                                },
                                                onDelete: {
                                                    print("Delete tapped for SNO \(index + 1)")
                                                }
                                            )
                                        }
                                    }
                                    .padding()
                                } else {
                                    Text("No billing details available.")
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                            }
                            CustonButton(title: "Submit", backgroundColor: .orange) {
                                
                            }
                            .padding()
                        }
                        .navigationTitle("Billing Details")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    showDateilScreen = false
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Back")
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .padding()
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.selectedImage = uiImage
                    self.fileName = newItem?.itemIdentifier ?? "Selected Image"
                }
            }
        }
    }
    func calculateTotalAmount() -> Double {
        guard let data = request.alldata else { return 0.0 }
        return data.compactMap { Double($0.amount ?? "0") }.reduce(0, +)
    }
    
}


struct BillingDetailCard: View {
    let sno: Int
    let amount: String
    let imageName: String?
    var onEdit: () -> Void = {}
    var onDelete: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("SNO.")
                    .fontWeight(.bold)
                Spacer()
                Text("Image")
                    .fontWeight(.bold)
                Spacer()
                Text("Amount")
                    .fontWeight(.bold)
            }
            HStack {
                Text("\(sno)")
                Spacer()
                
                if let imageName = imageName, !imageName.isEmpty,
                   let url = URL(string: "https://sap.sanskargroup.in/uploads/tour/\(imageName)") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(6)
                        case .failure(_):
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        default:
                            ProgressView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Text("₹ \(String(format: "%.2f", Double(amount) ?? 0.0))")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
            HStack {
                Spacer()
                
                Button(action: onEdit) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .foregroundColor(.orange)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}
