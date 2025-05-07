//
//  GuestRecordHistory.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/05/25.
//
import SwiftUI

struct GuestRecordHistory: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var guestHistory: [GuestHistory] = []
    @State private var isLoading = false
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                
                
                if guestHistory.isEmpty {
                    Text("No guest history available.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    CustomNavigationBar(
                        onFilter: { print("Filter tapped") },
                        onSearch: { query in print("Searching: \(query)") },
                        onAddListToggle: { print("Toggled") },
                        isListMode: true
                    )
                    List(guestHistory, id: \.id) { guest in
                        HStack(alignment: .center, spacing: 12) {
                            if let imageUrl = guest.image, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.green, lineWidth: 2))
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Name: \(guest.name ?? "")")
                                    .font(.system(size: 17, weight: .semibold))
                                Text("Date: \(guest.guest_date ?? "")")
                                    .font(.system(size: 14))
                                Text("Mobile: \(guest.mobile ?? "")")
                                    .font(.system(size: 14))
                                Text("Address: \(guest.address ?? "")")
                                    .font(.system(size: 14))
                                Text("Reason: \(guest.reason ?? "")")
                                    .font(.system(size: 14))
                                Text("In-Time: \(guest.in_time ?? "")")
                                    .font(.system(size: 14))
                                Text("Out-Time: \(guest.out_time ?? "")")
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            
                            Image(systemName: "pencil")
                                .font(.title)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    showSheet.toggle()
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        
                    }
                    .listStyle(PlainListStyle())
                    
                }
            }
        }
      
        .navigationTitle("Guest History")
        .onAppear {
            GuestHistoryApi()
        }
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                GeometryReader { geometry in
                    VStack {
                        AllListView()
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        showSheet.toggle()
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .presentationDetents([
                                .height(UIScreen.main.bounds.height * 0.65),
                                .large
                            ])
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.clear)
                    .cornerRadius(15)
                }
            }
        }
    }
    
    func GuestHistoryApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.guestRecordHistoryApi,
            method: .post,
            param: dict,
            model: GuestHistoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.guestHistory = data
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
