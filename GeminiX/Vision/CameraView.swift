//
//  CameraView.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import SwiftUI


struct CameraView: View {
    var image: CGImage?
    private let label = Text("frame")
    @EnvironmentObject var cameraManager: CameraHandler
    @State private var loading = true
    @State private var video: CIImage?
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var loaded = 0
    
    var body: some View {
        if let image {
            Image(image, scale: 2.0, orientation: .left, label: label).resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        } else {
            Text("dd")
        }
        
        
        
        //        if loading {
        //            ZStack{
        //                Color.black
        //
        //                ProgressView().progressViewStyle(.circular).scaleEffect(10)
        //
        //            }.onReceive(timer) { _ in
        //                if loaded < 3 {
        //                    loaded += 1
        //                } else if loaded == 3 {
        //                    loading = false
        //                } else {
        //                    loaded = 100
        //                }
        //            }
        //        } else {
        //            if let image {
        //                Image(image, scale: 2.0, orientation: .left, label: label).resizable()
        //                    .aspectRatio(contentMode: .fill)
        //                    .ignoresSafeArea()
        //            } else {
        //                ZStack{
        //                    Color.red
        //                    if cameraManager.permissionGranted {
        //                        Text("Loading Camera View...").foregroundColor(.white)
        //                    }
        //                }
        //            }
        //        }
    }
}
