//
//  EditGuestView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 07/05/25.
//

import SwiftUI

struct EditGuestView: View {
    @EnvironmentObject var store: GuestStore
    @Environment(\.dismiss) private var dismiss
    @Binding var triggerSubmit: Bool
    // Editable fields
    @State private var name: String = ""
    @State private var reason: String = ""
    @State private var selectedDate: Date = Date()
    @State private var isImageFullScreen = false
    
    //MARK: - Edit Photo
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var selectedSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImageSourceActionSheet = false
    @State private var showEditButton: Bool = true
    // Computed guest ID safely from store
    var selectedId: String? {
        return store.selectedGuest?.id
    }
    
    var body: some View {
        ScrollView {
            if let guest = store.selectedGuest {
                VStack(spacing: 10) {
                    // MARK: Guest Image
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if let imageUrl = guest.image,
                                      let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }

                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.green, lineWidth: 2))
                        Button(action: {
                            showImageSourceActionSheet = true
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .background(Color.white.clipShape(Circle()))
                        }
                        .offset(x: -15, y: -15)
                        
                    }
                    
                    // MARK: Editable Name Field
                    TextField("Guest Name", text: $name)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    // MARK: Date Picker
                    DatePicker("Select Date & Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    // MARK: Reason TextEditor
                    VStack(alignment: .leading) {
                        Text("Reason")
                            .font(.headline)
                        TextEditor(text: $reason)
                            .frame(height: 80)
                            .padding(4)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
                    }
                    
                    // MARK: Submit Button
                    CustonButton(title: "Submit", backgroundColor: .orange) {
                        editGuestRequest()
                       
                    }
                }
                .padding()
                .onAppear {
                    // populate fields from selected guest
                    name = guest.name ?? ""
                    reason = guest.reason ?? ""
                    
                    if let imageUrlString = guest.image,
                       let url = URL(string: imageUrlString) {
                        URLSession.shared.dataTask(with: url) { data, _, _ in
                            if let data = data, let uiImage = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.selectedImage = uiImage
                                }
                            }
                        }.resume()
                    }
                }
                .onChange(of: triggerSubmit) { newValue in
                    if newValue {
                        editGuestRequest()
                        triggerSubmit = false
                    }
                }
                .fullScreenCover(isPresented: $isImageFullScreen) {
                    FullScreenImageView(imageURL: guest.image)
                }
            } else {
                Text("No guest selected")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .confirmationDialog("Choose Image Source", isPresented: $showImageSourceActionSheet, titleVisibility: .visible) {
            Button("Camera") {
                selectedSourceType = .camera
                isImagePickerPresented = true
            }
            Button("Gallery") {
                selectedSourceType = .photoLibrary
                isImagePickerPresented = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(
                sourceType: selectedSourceType,
                selectedImage: $selectedImage
            )
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationTitle("Edit Guest")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Edit Guest Request Function
    func editGuestRequest() {
        guard let guestId = selectedId else { return }
        
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        dict["Guest_Name"] = name
        dict["id"] = guestId
        dict["WhomtoMeet"] = "\(UserDefaultsManager.getName())"
        dict["Reason"] = reason
        dict["Date1"] = ISO8601DateFormatter().string(from: selectedDate)
        
        var imagesData: [String: Data] = [:]
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
            imagesData["image"] = imageData
        }
        
        ApiClient.shared.callHttpMethod(
            apiendpoint: Constant.applyNewGuest,
            method: .post,
            param: dict,
            model: GuestRequestQRModel.self,
            isMultipart: !imagesData.isEmpty,
            images: imagesData
        ) { result in
            switch result {
            case .success(let model):
                if model.status == true {
                    ToastManager.shared.show(message: model.message ?? "Successfully updated guest")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                } else {
                    print("Request failed: \(model.message ?? "Unknown error")")
                }
            case .failure(let error):
                print("Error updating guest:", error)
            }
        }
    }
}
