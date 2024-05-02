//
//  Vision.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import SwiftUI
import Speech

struct Vision: View {
    @StateObject var cameraManager = CameraHandler()
    @State private var video: CIImage?
    @State var notFirstTime = UserDefaults.standard.bool(forKey: "notFirstTime")
    @State var moveToMain = false
    @State var holdView = false
    
    let modelManager = ModelManager()
    
    @State var userIsSpeaking = false
    @State var recording = false
    @State private var audioRecorder: AVAudioRecorder!
    @State private var transcribedText = ""
    
    
    var body: some View {
        VStack{
        VStack{
            
            Button(action: {
                
                if userIsSpeaking {
                    stopRecording()
                } else {
                    transcribedText = ""
                    Speech.requestPermission()
                    startRecording()
                }
                
                userIsSpeaking.toggle()
                
            }, label: {
                if userIsSpeaking {
                    Text("Stop Listening..")
                } else {
                    VStack{
                        Image(systemName: "mic.circle")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 70, height: 70)
                    }.frame(height: 110)
                }
            })
        }
        
        
        
        VStack{
            VStack{
                if !notFirstTime && !moveToMain {
                    PermissionView(moveToMain: $moveToMain).environmentObject(cameraManager)
                } else {
                    if holdView {
                        Text("HOOOOOLD")
                    } else {
                        CameraView(image: cameraManager.frame).environmentObject(cameraManager).ignoresSafeArea()
                    }
                    
                }
            }
            
            
            
            
            VStack{
                if holdView {
                    Button {
                        cameraManager.startCaptureSession()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
                    
                    
                    Button {
                        askQuestion()
                    } label: {
                        Text("Ask Question")
                    }
                    
                }
            }.padding(.bottom)
        }.onDisappear{
            cameraManager.stopCaptureSession()
        }
        
    }
        
    }
    
    func transcribeAudio(url: URL) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)
        
        recognizer?.recognitionTask(with: request) { (result, error) in
            
            guard let result = result else {
                print("some error happend")
                
                return
            }
            
            if result.isFinal {
                transcribedText = result.bestTranscription.formattedString
                print(transcribedText)
            }
            
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        getRecording()
    }
    
    func getRecording() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            transcribeAudio(url: audio)
            // break
        }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            print("---1")
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            print("---2")
            try recordingSession.setActive(true)
            print("---3")
        } catch {
            print("Some error happened")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("human.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func askQuestion() {
        if let capturedImage = cameraManager.captureUIImage() {
            Task {
                let result = await modelManager.askImageQuestion(prompt: "Hello", image1: capturedImage)
                print("Received response: \(result)")
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
}


class Speech {
    
    static func speak(sentence: String) {
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    static func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }


    static func requestPermission() {
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus == .authorized {
                    print("Thanks")
                } else {
                    print("Okay...")
                }
            }
        }
}
