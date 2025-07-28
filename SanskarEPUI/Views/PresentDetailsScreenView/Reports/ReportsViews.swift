//
//  ReportsViews.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//

import SwiftUI

struct ReportsViews: View {
    let availableReports: [Int]
    @State private var selectedSegment = 0
    var body: some View {
        VStack {
            if availableReports.contains(17) && availableReports.contains(18) {
     
                Picker("Select Report", selection: $selectedSegment) {
                    Text("My Reports").tag(0)
                    Text("All Reports").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if selectedSegment == 0 {
                    MyReportsViews()
                } else {
                    AllReportsViews()
                }

            } else if availableReports.contains(17) {
                MyReportsViews()
            } else if availableReports.contains(18) {
                AllReportsViews()
            } else {
                Text("No approval views available")
            }
        }
    }
}
