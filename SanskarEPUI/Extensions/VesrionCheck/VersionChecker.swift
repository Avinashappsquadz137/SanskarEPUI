//
//  VersionChecker.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/07/25.
//
import Foundation
import UIKit

class VersionChecker: ObservableObject {
    @Published var shouldForceUpdate = false
    private let appID = "6459921906"

    func checkForUpdate() {
        guard let url = URL(string: "https://itunes.apple.com/in/lookup?id=\(appID)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String,
                  let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            else {
                return
            }
            print("📱 Current Version: \(currentVersion)")
            print("🛒 App Store Version: \(appStoreVersion)")
            if currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending {
                DispatchQueue.main.async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.shouldForceUpdate = true
                    }
                }
            }
        }.resume()
    }
}
