//
//  HealthViewScreen.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 28/05/25.
//
import SwiftUI

struct HealthViewScreen: View {
    
    var urlString = UserDefaultsManager.getinsurancePDF()
    
    @State private var downloadProgress: Double = 0.0
    @State private var isDownloading = false
    @State private var downloadTask: URLSessionDownloadTask?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                Text("Policy No:")
                    .fontWeight(.semibold)
                Spacer()
                Text(UserDefaultsManager.getPolicyNumber())
            }

            HStack {
                Text("Amount:")
                    .fontWeight(.semibold)
                Spacer()
                Text(UserDefaultsManager.getPolicyAmount())
            }

            HStack {
                Text("Valid Till:")
                    .fontWeight(.semibold)
                Spacer()
                Text(UserDefaultsManager.getPolicyValidity())
            }

            Button(action: {
                startDownload()
            }) {
                HStack {
                    Image(systemName: "arrow.down.doc")
                    Text("Download PDF")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isDownloading ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isDownloading)

            // ✅ Progress + Cancel UI
            if isDownloading {
                VStack(spacing: 10) {
                    
                    ProgressView(value: downloadProgress)
                        .progressViewStyle(.linear)
                        .tint(.blue)
                        .scaleEffect(x: 1, y: 2)
                        .animation(.easeInOut, value: downloadProgress)
                    
                    Text("\(Int(downloadProgress * 100))% Downloaded")
                        .font(.subheadline)

                    Button("Cancel Download") {
                        cancelDownload()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
        .overlay(ToastView())
    }
    
    // ✅ START DOWNLOAD
    func startDownload() {
        guard let url = URL(string: urlString) else { return }
        
        isDownloading = true
        downloadProgress = 0.0
        
        let session = URLSession(configuration: .default)
        
        var request = URLRequest(url: url)
        request.setValue("application/pdf", forHTTPHeaderField: "Accept")
        
        let task = session.downloadTask(with: request) { tempURL, response, error in
            
            DispatchQueue.main.async {
                isDownloading = false
                downloadTask = nil
            }
            
            // ❌ Cancel case
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                DispatchQueue.main.async {
                    ToastManager.shared.show(message: "Download Cancelled")
                }
                return
            }
            
            // ❌ Validate PDF
            guard let response = response as? HTTPURLResponse,
                  let mimeType = response.mimeType,
                  mimeType == "application/pdf",
                  let tempURL = tempURL else {
                
                DispatchQueue.main.async {
                    ToastManager.shared.show(message: "Invalid PDF URL")
                }
                return
            }
            
            do {
                let documentsUrl = try FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
                
                // ✅ Unique file name
                let fileName = getUniqueFileName(baseName: "policy", fileExtension: "pdf")
                let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                
                try FileManager.default.moveItem(at: tempURL, to: destinationUrl)
                
                DispatchQueue.main.async {
                    ToastManager.shared.show(message: "\(fileName) downloaded")
                    print("Saved at:", destinationUrl.path)
                }
                
            } catch {
                DispatchQueue.main.async {
                    ToastManager.shared.show(message: "Save failed")
                }
            }
        }
        
        downloadTask = task
        
        // ✅ Progress Tracking
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            DispatchQueue.main.async {
                if let task = downloadTask {
                    downloadProgress = task.progress.fractionCompleted
                    
                    if task.state == .completed {
                        timer.invalidate()
                    }
                } else {
                    timer.invalidate()
                }
            }
        }
        
        RunLoop.main.add(timer, forMode: .common)
        
        task.resume()
    }
    
    // ❌ CANCEL DOWNLOAD
    func cancelDownload() {
        downloadTask?.cancel()
        downloadTask = nil
        
        isDownloading = false
        downloadProgress = 0.0
    }
    
    // ✅ UNIQUE FILE NAME
    func getUniqueFileName(baseName: String, fileExtension: String) -> String {
        let documentsUrl = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        
        var count = 0
        var fileName = "\(baseName).\(fileExtension)"
        
        while FileManager.default.fileExists(
            atPath: documentsUrl.appendingPathComponent(fileName).path
        ) {
            count += 1
            fileName = "\(baseName)_\(count).\(fileExtension)"
        }
        
        return fileName
    }
}
