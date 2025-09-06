//
//  SalesEmployeeDetailsView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/09/25.
//
import SwiftUI

struct SalesEmployeeDetailsView: View {
    let employeeCode: String
    @State private var isImageFullScreen = false
    @State private var isLoading: Bool = false
    // Pagination & Data
    @State private var employeeDetails: BookingSalesDetails?
    @State private var recentKathas: [RecentKathas] = []
    @State private var currentPage = 1
    @State private var totalPages = 1
    // Filter Dates
    @State private var fromDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var toDate: Date = Date()
    @State private var showFilterSheet = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // Profile Image
                profileHeaderView
                // Extra Details
                employeeInfoView
                
                Divider()
                
                // Recent Kathas List
                if recentKathas.isEmpty {
                    Text("No Kathas found")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(recentKathas.indices, id: \.self) { index in
                                let katha = recentKathas[index]
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(katha.kathaName ?? "Unknown")
                                        .font(.headline)
                                    Text("Date: \(katha.date ?? "")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Amount: ₹\(katha.amount ?? 0, specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .onAppear {
                                    if index == recentKathas.count - 1 && currentPage < totalPages && !isLoading {
                                        currentPage += 1
                                        salesEMPDetailsAPI()
                                    }
                                }
                            }
                            if isLoading && currentPage > 1 {
                                ProgressView("Loading more...")
                                    .padding()
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .onAppear {
                salesEMPDetailsAPI()
            }
            if isLoading {
                ProgressView("Loading...")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilterSheet = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            filterSheet
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            ImageFullScreenView(imageURL: employeeDetails?.profileImage ?? "", isPresented: $isImageFullScreen)
        )
    }
    
    // MARK: - API Call
    func salesEMPDetailsAPI() {
        isLoading = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dict: [String: Any] = [
            "EmpCode": employeeCode,
            "page": String(currentPage),
            "fromDate": dateFormatter.string(from: fromDate),
            "toDate": dateFormatter.string(from: toDate)
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaBookingSalesDetails,
            method: .post,
            param: dict,
            model: KathaBookingSalesDetailsModel.self,
            baseUrl: Constant.EP_BASEURL
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let model):
                    if model.status == true, let data = model.data {
                        self.employeeDetails = data
                        self.totalPages = data.pagination?.totalPages ?? 1
                        if currentPage == 1 {
                            self.recentKathas = data.recentKathas ?? []
                        } else {
                            self.recentKathas.append(contentsOf: data.recentKathas ?? [])
                        }
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Views
    private var profileHeaderView: some View {
        Group {
            if let url = employeeDetails?.profileImage,
               let imageUrl = URL(string: url) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.3))
                        .overlay(Text(initials(from: employeeDetails?.name)))
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .onTapGesture {
                    isImageFullScreen = true
                }
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Text(initials(from: employeeDetails?.name))
                            .font(.system(size: 40))
                            .bold()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .foregroundColor(.black)
                            .padding(10)
                    )
                    .frame(width: 100, height: 100)
            }
            
            Text(employeeDetails?.name ?? "Unknown")
                .font(.title2).bold()
        }
    }
    
    private var employeeInfoView: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let code = employeeDetails?.phone {
                Text("Phone: \(code)")
            }
            if let totalKathaBooked = employeeDetails?.totalKathaBooked {
                Text("Total Katha: \(totalKathaBooked)")
            }
            if let kathaPending = employeeDetails?.kathaPending {
                Text("Katha Pending: \(kathaPending)")
            }
            if let totalAmount = employeeDetails?.totalAmount {
                Text("Total Amount: ₹\(totalAmount , specifier: "%.2f")")
            }
        }
        .font(.body)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var filterSheet: some View {
        NavigationView {
            Form {
                DatePicker("From Date", selection: $fromDate, displayedComponents: .date)
                DatePicker("To Date", selection: $toDate, displayedComponents: .date)
            }
            .navigationTitle("Filter")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        currentPage = 1
                        salesEMPDetailsAPI()
                        showFilterSheet = false
                    }
                }
            }
        }
    }
}
