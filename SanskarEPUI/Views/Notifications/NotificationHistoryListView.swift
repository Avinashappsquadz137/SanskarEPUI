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
    @State private var selectedItem: PushHistory?
    @State private var showGuestPopup = false

    var filteredNotifications: [PushHistory] {
        searchText.isEmpty
            ? notifications
            : notifications.filter {
                $0.notification_title?.localizedCaseInsensitiveContains(searchText) == true ||
                $0.notification_content?.localizedCaseInsensitiveContains(searchText) == true
            }
    }

    var body: some View {
        ZStack {
            VStack {
                SearchBars(text: $searchText)

                List(filteredNotifications, id: \.id) { item in
                    NotificationRowView(item: item)
                        .onTapGesture {
                            if item.notification_type == "8" || item.notification_type == "9" {
                                selectedItem = item
                                showGuestPopup = true
                            } else if item.notification_type == "14"{
                                
                            }
                        }
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

            // Guest Popup Overlay
            if showGuestPopup, let item = selectedItem {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                GuestArrivalAlert(
                    img : item.notification_thumbnail ?? "",
                    guestName: item.notification_content ?? "Guest",
                    onAccept: { location in
                        print("Accepted with location: \(location)")
                        showGuestPopup = false
                    },
                    onReject: {
                        print("Rejected")
                        showGuestPopup = false
                    },
                    onClose: {
                        showGuestPopup = false
                    }
                )
                .padding()
                .zIndex(1)
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: showGuestPopup)
        .navigationTitle("Notification History")
        .onAppear {
            pushHistoryAPI()
        }
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


struct GuestArrivalAlert: View {
    var img : String
    var guestName: String
    var onAccept: (String) -> Void
    var onReject: () -> Void
    var onClose: () -> Void

    @State private var locationText = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    onClose()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                }
            }
            .padding(.trailing)
            
            VStack(spacing: 16) {
                if let url = URL(string: img) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill.badge.plus")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                }
                Text("\(guestName) has arrived")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                TextField("Enter Location", text: $locationText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                HStack(spacing: 20) {
                    Button("Accept") {
                        onAccept(locationText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Button("Reject") {
                        onReject()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}
