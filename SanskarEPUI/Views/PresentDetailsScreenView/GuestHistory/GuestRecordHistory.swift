//
//  GuestRecordHistory.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/05/25.
//
import SwiftUI


class GuestStore: ObservableObject {
    @Published var guests: [GuestHistory] = []
    @Published var selectedGuest: GuestHistory? = nil
}


struct GuestRecordHistory: View {
    
    @EnvironmentObject var store: GuestStore
    @Environment(\.dismiss) private var dismiss
    @State private var guestHistory: [GuestHistory] = []
    @State private var isLoading = false
    @State private var showSheet = false
    @State private var openQR = false
    @State private var showFilterSheet = false
    @State private var addNewGuestSheet = false
    @State private var startDate: String = ""
    @State private var endDate: String = ""
    @State private var searchText: String = ""
    @State private var isImageFullScreen = false
    @State private var startDateRaw: Date = Date()
    @State private var endDateRaw: Date = Date()
    @State private var fullScreenImageURL: String? = nil
    @State private var isEditing = false

    var filteredGuestHistory: [GuestHistory] {
        if searchText.isEmpty {
            return guestHistory
        } else {
            return guestHistory.filter {
                ($0.name ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {                          
                CustomNavigationBar(
                    onFilter: { showFilterSheet.toggle()  },
                    onSearch: {  query in
                        self.searchText = query },
                    onAddListToggle: { addNewGuestSheet.toggle() },
                    isListMode: true
                )
                Spacer()
                if guestHistory.isEmpty {
                    EmptyStateView(imageName: "EmptyList", message: "No Notifications found")
                } else {
                    List(filteredGuestHistory, id: \.id) { guest in
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
                                .onTapGesture {
                                    fullScreenImageURL = guest.image
                                    isImageFullScreen = true
                                }
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
                                Text("Reason: \(guest.reason ?? "")")
                                    .font(.system(size: 14))
                                    .lineLimit(1)                
                                    .truncationMode(.tail)
                                Text("In-Time: \(guest.in_time ?? "")")
                                    .font(.system(size: 14))
                                Text("Out-Time: \(guest.out_time ?? "")")
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            VStack {
                                if isEditing {
                                    Image(systemName: "pencil")
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .onTapGesture {
                                            store.selectedGuest = guest
                                            showSheet.toggle()
                                        }
                                }
                                Spacer()
                                Button(action: {
                                    store.selectedGuest = guest
                                    openQR.toggle()
                                }) {
                                    HStack(spacing: 5) {
                                        Image(systemName: "qrcode")
                                            .font(.title2)
                                       
                                    }
                                    .padding(5)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                }
                                .buttonStyle(PlainButtonStyle())
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(isEditing ? "Done" : "Edit") {
                        isEditing.toggle()
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
            }
        }
        .fullScreenCover(isPresented: $isImageFullScreen) {
            FullScreenImageView(imageURL: fullScreenImageURL)
        }
        .navigationTitle("Guest History")
        .onAppear {
            GuestHistoryApi()
        }
        .sheet(isPresented: $openQR) {
                NavigationStack {
                    GeometryReader { geometry in
                        VStack {
                            GuestQRcodeView()
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            openQR.toggle()
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
                                    .height(UIScreen.main.bounds.height * 0.45),
                                    .large
                                ])
                            
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .background(Color.clear)
                        .cornerRadius(15)
                    }
                }
        }
        .sheet(isPresented: $showSheet) {
                NavigationStack {
                    GeometryReader { geometry in
                        VStack {
                            EditGuestView() 
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
        .sheet(isPresented: $showFilterSheet) {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Filter by Date")
                        .font(.headline)
                    
                    DatePicker("Start Date", selection: $startDateRaw, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)
                    
                    DatePicker("End Date", selection: $endDateRaw, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)
                    
                    CustonButton(
                        title: "Submit",
                        backgroundColor: .orange
                    ) {
                        startDate = dateFormatter.string(from: startDateRaw)
                        endDate = dateFormatter.string(from: endDateRaw)
                        showFilterSheet = false
                        GuestHistoryApi()
                    }
                }
                .padding()
                .presentationDetents([.height(300)])
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showFilterSheet = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $addNewGuestSheet) {
            NavigationStack {
                GeometryReader { geometry in
                    VStack {
                        AddNewGuestView { newGuest in
                         
                            self.store.selectedGuest = newGuest
                            self.openQR = true
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    addNewGuestSheet.toggle()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .navigationTitle("Add New Guest")
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
        .sheet(isPresented: $addNewGuestSheet) {
            NavigationStack {
                AddNewGuestView { newGuest in
                    self.store.selectedGuest = newGuest
                    self.openQR = true
                }
            }
        }

        .onChange(of: addNewGuestSheet) { newValue in
            if !newValue {
                GuestHistoryApi()
            }
        }
    }
    
    func GuestHistoryApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        if !startDate.isEmpty {
            dict["fromDate"] = startDate
        }
        
        if !endDate.isEmpty {
            dict["toDate"] = endDate
        }
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
extension GuestHistory {
    init(from requestQR: GuestRequestQR, name: String? = nil, reason: String? = nil, guestDate: String? = nil ,reqdate : String? = nil) {
        self.id = nil
        self.name = requestQR.name
        self.in_time = nil
        self.out_time = nil
        self.reason = requestQR.reason
        self.guest_date = requestQR.reqdate
        self.address = nil
        self.mobile = nil
        self.image = nil
        self.reqdate = requestQR.reqdate
        self.to_whome = nil
        self.type = nil
        self.qrcode = requestQR.qrcode
        self.qrthumbnail = requestQR.qrthumbnail
    }
}
