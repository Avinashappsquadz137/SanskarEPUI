//
//  QRCodeScannerView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 24/05/25.
//
import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewRepresentable {
    class ScannerView: UIView, AVCaptureMetadataOutputObjectsDelegate {
        private var captureSession: AVCaptureSession?
        private var previewLayer: AVCaptureVideoPreviewLayer?
        var onCodeScanned: ((String) -> Void)?
        private var isScanning = true

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .black
            initializeCamera()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            backgroundColor = .black
            initializeCamera()
        }

        private func initializeCamera() {
            let session = AVCaptureSession()

            guard let videoDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  session.canAddInput(videoInput) else {
                print("🚨 Failed to get video input")
                return
            }

            session.addInput(videoInput)

            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                metadataOutput.metadataObjectTypes = [.qr]
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.frame = self.bounds

            if let layer = previewLayer {
                self.layer.insertSublayer(layer, at: 0)
            }

            self.captureSession = session
            session.startRunning()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = bounds
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
            guard isScanning,
                  let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let code = metadataObject.stringValue else { return }

            isScanning = false
            onCodeScanned?(code)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isScanning = true
            }
        }
    }

    var completion: (String) -> Void

    func makeUIView(context: Context) -> ScannerView {
        let view = ScannerView()
        view.onCodeScanned = completion
        return view
    }

    func updateUIView(_ uiView: ScannerView, context: Context) {}
}
