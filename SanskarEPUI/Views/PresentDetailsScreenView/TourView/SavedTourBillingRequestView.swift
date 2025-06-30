//
//  SavedTourBillingRequestView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/06/25.
//
import SwiftUI

struct SavedTourBillingRequestView: View {
    
    @State private var tourRequests: [BillingList] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(tourRequests) { request in
                        TourRequestCard(
                            tourId: request.tourID ?? "N/A",
                            status: request.status ?? "N/A",
                            location: request.location ?? "N/A",
                            date: "\(request.date1 ?? "-") to \(request.date2 ?? "-")",
                            onTap: {
                                print("Tapped on \(request.tourID ?? "")")
                            }
                        )
                    }
                }
                .padding()
            }
           
            .onAppear {
                tourBillingApprovalList()
            }
        }
        .navigationTitle("Saved Billing Requests")
    }

    // MARK: - API Call
    func tourBillingApprovalList() {
        let params: [String: Any] = [
            "Emp_Code": "\(UserDefaultsManager.getEmpCode())",
            "type": "0",
        ]

        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getTourBillingApprovalList,
            method: .post,
            param: params,
            model: TourBillingListModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.tourRequests = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                case .failure(let error):
                    ToastManager.shared.show(message: "Failed to fetch tour list.")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
