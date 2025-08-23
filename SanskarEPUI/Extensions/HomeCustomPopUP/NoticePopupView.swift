//
//  NoticePopupView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 16/08/25.
//

import SwiftUI

struct NoticePopupView: View {
    let title: String
    let message: String
    let onGotIt: () -> Void
    let onRemindLater: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .padding(.top)
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack {
                Button(action: onGotIt) {
                    Text("Got it")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: onRemindLater) {
                    Text("Remind Later")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}

//#Preview {
//    NoticePopupView(title: "hello", message: "To day leave ", onGotIt: <#() -> Void#>, onRemindLater: <#() -> Void#>)
//}
