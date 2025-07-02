//
//  NotificationHistoryListView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 01/07/25.
//

import SwiftUI

struct NotificationHistoryListView: View {
    @State private var notifications: [PushHistory] = []
    @State private var searchText = ""
    var filteredNotifications: [PushHistory] {
        if searchText.isEmpty {
            return notifications
        } else {
            return notifications.filter {
                $0.notification_title?.localizedCaseInsensitiveContains(searchText) == true ||
                $0.notification_content?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    var body: some View {
        VStack {
            SearchBars(text: $searchText)
            List(filteredNotifications, id: \.id) { item in
                NotificationRowView(item: item)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteNotification(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            approveNotification(item)
                        } label: {
                            Label("Approve", systemImage: "checkmark")
                        }
                        .tint(.blue)
                    }
            }
            .listStyle(.plain)
        }
        .onAppear {
            pushHistoryAPI()
        }
        .navigationTitle("Notification History")
        
    }
    func deleteNotification(_ item: PushHistory) {
        print("Delete tapped for ID:", item.id ?? "N/A")
        // Call API or remove from array
        notifications.removeAll { $0.id == item.id }
    }
    
    func approveNotification(_ item: PushHistory) {
        print("Approve tapped for ID:", item.id ?? "N/A")
        // Call API or update status
        // Example: update status locally
        if let index = notifications.firstIndex(where: { $0.id == item.id }) {
            notifications[index].status = true
        }
    }
    
    func pushHistoryAPI () {
        var dict = [String: Any]()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.pushHistoryList,
            method: .post,
            param: dict,
            model: NotificationPushHistory.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.notifications = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Success")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
}


struct NotificationRowView: View {
    let item: PushHistory
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let imageURL = item.notification_thumbnail,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.notification_title ?? "No Title")
                    .font(.headline)
                
                Text(item.notification_content ?? "No Description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            if item.status == true {
                Circle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                    .padding(.top, 6)
            } else {
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .padding(.top, 6)
            }
            
            
        }
        .padding(.vertical, 8)
    }
}
