//
//  MainNavigationBar.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
//

import SwiftUI

struct MainNavigationBar: View {
    var logoName: String = "sanskar"
    var projectName: String = "SEP"
    var onSearchTapped: () -> Void = {}
    var onNotificationTapped: () -> Void = {}
    var onQRTapped: () -> Void = {}
    var notificationCount: Int = 0

    var body: some View {
        HStack(spacing: 16) {
            Image(logoName)
                .resizable()
                .frame(width: 100, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(projectName)
                .font(.headline)
                .foregroundColor(.primary)

            Spacer()
            HStack(spacing: 5){
                Button(action: onQRTapped) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(8)
                }
                Button(action: onSearchTapped) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(8)
                }
                
                ZStack(alignment: .topTrailing) {
                    Button(action: onNotificationTapped) {
                        Image(systemName: "bell")
                            .foregroundColor(.black)
                            .font(.title2)
                            .padding(8)
                    }
                    
                    if notificationCount > 0 {
                        Text("\(notificationCount)")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Circle().fill(Color.red))
                            .offset(x :-1,y: -1)
                    }
                }
            }
        }
        .padding(.top , -10)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }
}
