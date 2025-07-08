//
//  SanskarEPUIApp.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
//

import SwiftUI
import UserNotifications


@main
struct SanskarEPUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .navigationViewStyle(StackNavigationViewStyle())
                .environment(\.colorScheme, .light)
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("✅ APNs permission granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("❌ APNs permission denied.")
            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("📱 APNs Device Token: \(token)")
        UserDefaultsManager.setFCMToken(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        print("📦 Background notification received: \(userInfo)")
        return .newData
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        print("📩 Foreground Notification Data: \(userInfo)")
        
        return [.alert, .sound, .badge]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        print("📩 User tapped notification: \(userInfo)")
    }
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.yourapp.dontremove" {
            print("User tapped Don't Remove!")
        } else if shortcutItem.type == "com.yourapp.bugreport" {
            print("User tapped Bug Report!")
        }
    }
}


struct SplashView: View {
    let isLoggedIn = UserDefaultsManager.isLoggedIn()
    @State private var isActive = false
    var body: some View {
        if isActive {
            if isLoggedIn {
                MainHomeView()
                    .overlay(ToastView())
                    .navigationViewStyle(StackNavigationViewStyle())
                    .environment(\.colorScheme, .light)
            } else {
                MainLoginView()
                    .navigationViewStyle(StackNavigationViewStyle())
                    .environment(\.colorScheme, .light)
            }
        } else {
            ZStack {
                Color.white.ignoresSafeArea()
                Image("inventory-management")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
