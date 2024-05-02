//
//  PermissionView.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/28/24.
//

import Foundation
import SwiftUI

struct PermissionView: View {
    
    @State private var hasCameraPermission = false
    @State private var buttonPressed = false
    @State private var notFirstTime = UserDefaults.standard.bool(forKey: "notFirstTime")
    @Binding var moveToMain: Bool
    @EnvironmentObject var cameraManager: CameraHandler

    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Use Vision Mode")
                .font(.largeTitle)
                .bold()

            Text("please?")
                .font(.title2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .padding()

            
           
            HStack{
                Button(action: {
                    buttonPressed = true
                    cameraManager.requestPermission()
                }) {
                        Text("Set Camera Access")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
                
            
            Button(action: {
                UserDefaults.standard.set(true, forKey: "notFirstTime")
                moveToMain = true
            }) {
                Text("Continue")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(!buttonPressed ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.disabled(!buttonPressed)
            .padding()
        
            
        }
    }
}

