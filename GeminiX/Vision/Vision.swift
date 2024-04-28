//
//  Vision.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import SwiftUI


struct Vision: View {
    @StateObject var cameraManager = CameraHandler()
    @State private var video: CIImage?
    @State var notFirstTime = UserDefaults.standard.bool(forKey: "notFirstTime")
    @State var moveToMain = false
    
    @State var holdView = false
    
    var body: some View {
//        CameraView(image: cameraManager.frame).environmentObject(cameraManager).ignoresSafeArea()
        if !notFirstTime && !moveToMain {
            PermissionView(moveToMain: $moveToMain).environmentObject(cameraManager)
        } else {
            if holdView {
                Text("HOOOOOLD")
            } else {
                CameraView(image: cameraManager.frame).environmentObject(cameraManager).ignoresSafeArea()
            }
           
        }
        

        
        
        if holdView {
            Button {
                cameraManager.startCaptureSessionWithDelay()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    holdView = false
                }
                
            } label: {
                Text("ReStart")
            }
        } else {
            Button {
                holdView = true
                cameraManager.stopCaptureSession()
            } label: {
                Text("Stop")
            }
        }
    }
}
