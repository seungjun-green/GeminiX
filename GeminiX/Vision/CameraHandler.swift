//
//  CameraHandler.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import AVFoundation
import CoreImage
import UIKit

extension CameraHandler {
    func captureUIImage() -> UIImage? {
        guard let cgImage = self.frame else { return nil }
        return UIImage(cgImage: cgImage)
    }
}


class CameraHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    public var permissionGranted = false
    private let captureSession = AVCaptureSession()
    public var sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    
    override init() {
        super.init()
        let notFirstTime = UserDefaults.standard.bool(forKey: "notFirstTime")
        
        if notFirstTime {
            checkPermission()
        }
        
        if permissionGranted || !notFirstTime {
            print("this part should not be run twice!!!!")
            
            startCaptureSession()
        }
    }
    
   
    
    
    public func startCaptureSession() {
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func stopCamera() {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
            }
        }
    
    func stopCaptureSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
       
     

    }
    

    
    public func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                permissionGranted = true
            case .notDetermined:
                requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    public func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
            if granted {
                self.startCaptureSession()
            }
        }
    }
    
    
//    public func requestPermission() {
//        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
//            DispatchQueue.main.async {  // Ensure UI updates are on the main thread.
//                self.permissionGranted = granted
//                if granted {
//                    self.startCaptureSessionWithDelay()
//                } else {
//                    // Provide a fallback method to instruct users to enable permissions manually
//                    self.informUserToEnablePermissionsManually()
//                }
//            }
//        }
//    }
//
//    private func informUserToEnablePermissionsManually() {
//        // Update your UI to show a message that guides users to enable camera access manually
//        // through System Preferences. This could be an alert, a label, or any other method
//        // that fits your application design.
//        print("Please enable camera access in your System Preferences to continue.")
//    }
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permissionGranted else { return }
        
        let videoDevice: AVCaptureDevice?
        #if targetEnvironment(macCatalyst)
        videoDevice = AVCaptureDevice.default(for: .video)
        #else
        videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back)
        #endif
        
        guard let videoDevice = videoDevice,
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else {
            print("Failed to get the video device or input")
            return
        }
        
        captureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
//        videoOutput.connection(with: .video)?.videoOrientation = .landscapeRight
    }

}


extension CameraHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
    }
    
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return cgImage
    }
    
}
