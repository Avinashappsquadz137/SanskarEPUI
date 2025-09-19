//
//  AddNewGuestView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 07/05/25.
//
import SwiftUI
import PhotosUI

struct AddNewGuestView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var guestName: String = ""
    @State private var guestAddress: String = ""
    @State private var reason: String = ""
    @State private var selectedDate = Date()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    @State private var isImagePickerPresented = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImageSourceActionSheet = false
    
    @State private var isSubmitting = false
    
    var onGuestAdded: ((GuestHistory) -> Void)? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        Text("Guest Name")
                            .font(.headline)
                        TextField("Enter Guest Name", text: $guestName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Address")
                            .font(.headline)
                        TextField("Enter Address", text: $guestAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Reason")
                            .font(.headline)
                        TextField("Enter Reason", text: $reason)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        DatePicker("Select Date & Time", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                            .font(.headline)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Photo")
                            .font(.headline)
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                                .cornerRadius(10)
                                .padding(.bottom, 5)
                        }
                        
                        Button(action: {
                            showImageSourceActionSheet = true
                        }) {
                            Label("Choose Image Source", systemImage: "photo")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .confirmationDialog(
                            "Choose Image Source",
                            isPresented: $showImageSourceActionSheet,
                            titleVisibility: .visible
                        ) {
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
                               ImagePicker(sourceType: selectedSourceType, selectedImage: $selectedImage)
                           }
                    }
                    CustonButton(
                        title: "Submit",
                        backgroundColor: (guestName.isEmpty || guestAddress.isEmpty || reason.isEmpty || isSubmitting ) ? .gray : .orange
                    ) {
                        isSubmitting = true
                        addNewGuestApi()
                    }
                    .disabled(guestName.isEmpty || guestAddress.isEmpty || reason.isEmpty || isSubmitting)
                }
                .padding()
            }
        }
        .overlay(ToastView())
    }
    //MARK: - Multi Part
    func addNewGuestApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        dict["Guest_Name"] = guestName
        dict["Address"] = guestAddress
        dict["Reason"] = reason
        dict["Date1"] = ISO8601DateFormatter().string(from: selectedDate)

        var imagesData: [String: Data] = [:]

        let finalImage: UIImage
        if let selected = selectedImage {
            finalImage = selected
        } else {
            finalImage = UIImage(named: "Profile") ?? UIImage()
        }

        if let imageData = finalImage.jpegData(compressionQuality: 0.8) {
            imagesData["image"] = imageData
        }

        ApiClient.shared.callHttpMethod(
            apiendpoint: Constant.applyNewGuest,
            method: .post,
            param: dict,
            model: GuestRequestQRModel.self,
            isMultipart: true,
            images: imagesData
        ) { result in
            switch result {
            case .success(let model):
                if model.status == true {
                    if let guestData = model.data {
                        print(model.data ?? "No data")
                        let newGuest = GuestHistory(from: guestData)
                        ToastManager.shared.show(message: "\(model.message ?? "")")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            onGuestAdded?(newGuest)
                            dismiss()
                        }
                    } else {
                        dismiss()
                    }
                } else {
                    isSubmitting = false
                    print("Request failed: \(model.message ?? "Unknown error")")
                }
            case .failure(let error):
                isSubmitting = false
                print("Error updating repair details:", error)
            }
        }
    }

}

