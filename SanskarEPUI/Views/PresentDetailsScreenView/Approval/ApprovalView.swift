//
//  ApprovalView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//

import SwiftUI

struct ApprovalView: View {
    let availableIDs: [Int] 
    @State private var selectedSegment = 0
    var body: some View {
        VStack {
            if availableIDs.contains(22) && availableIDs.contains(23) {
                Picker("Select Approval Type", selection: $selectedSegment) {
                    Text("Leave").tag(0)
                    Text("Booking").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if selectedSegment == 0 {
                    LeaveApprovalView()
                } else {
                    BookingApprovalView()
                }

            } else if availableIDs.contains(22) {
                LeaveApprovalView()
            } else if availableIDs.contains(23) {
                BookingApprovalView()
            } else {
                Text("No approval views available")
            }
        }
    }
}



