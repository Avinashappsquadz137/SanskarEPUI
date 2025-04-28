//
//  AllListScreenView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import SwiftUI

struct AllListView: View {
    @State private var reqType: [SideBar] = []
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(reqType.indices, id: \.self) { index in
                        let item = reqType[index]
                        let name = item.name ?? ""
                        let id = item.id ?? 0
                        NavigationLink(
                            destination: destinationView(for: id)
                        ) {
                            HStack(spacing: 10) {
                                Image(uiImage: imageForID(id))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                Text(name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .minimumScaleFactor(0.8)
                                Spacer()
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 2  - 20)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                        }
                    }
                    .padding(8)
                }
            }
        }
        .navigationTitle("All Options")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchSidebarAPI()
        }
        
    }
    
    func fetchSidebarAPI() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.sidebarapi,
            method: .post,
            param: dict,
            model: SideBarApi.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.reqType = data
                        let manualItem = SideBar(id: 1000, name: "User Profile")
                        self.reqType.insert(manualItem, at: 0)
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
    
    private func imageForID(_ id: Int) -> UIImage {
        switch id {
        case 1: return UIImage(named: "approved") ?? defaultImage()
        case 2: return UIImage(named: "Leave") ?? defaultImage()
        case 3: return UIImage(named: "booking") ?? defaultImage()
        case 4: return UIImage(named: "Inventory") ?? defaultImage()
        case 5: return UIImage(named: "interview") ?? defaultImage()
        case 6: return UIImage(named: "Tour") ?? defaultImage()
        case 7: return UIImage(named: "Reports") ?? defaultImage()
        case 8: return UIImage(named: "Guest") ?? defaultImage()
        case 11: return UIImage(named: "healthcare") ?? defaultImage()
        case 14: return UIImage(named: "Privacy Policy") ?? defaultImage()
        case 24: return UIImage(named: "biometricAttendance") ?? defaultImage()
        case 25: return UIImage(named: "attendance") ?? defaultImage()
        case 1000: return UIImage(named: "Profile") ?? defaultImage()
            
        default: return defaultImage()
        }
    }
    
    private func defaultImage() -> UIImage {
        return UIImage(named: "default") ?? UIImage(systemName: "questionmark.square")!
    }
    
    @ViewBuilder
        private func destinationView(for id: Int) -> some View {
            if id == 1000 {
                UserProfileScreenView()
            } else {
                Text("No screen available")
            }
        }
}




