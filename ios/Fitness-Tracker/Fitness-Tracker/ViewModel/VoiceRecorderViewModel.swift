//
//  VoiceRecorderViewModel.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 21.2.25.
//

import SwiftUI

@Observable
class VoiceRecorderViewModel {
    private var dataService: DataServiceProtocol
    private var recorder = AudioRecorder()
    private let user: Int
    
    var isRecording = false
    
    var recordingSaved = false
    
    var title: String {
        return isRecording ? "Recording..." : "Ready to Record"
    }
    
    var iconName: String {
        isRecording ? "stop.circle.fill" : "mic.circle.fill"
    }
    
    var iconColor: Color {
        isRecording ? .red : .blue
    }
    
    var showSendButton: Bool {
        return recorder.audioURL != nil
    }
    
    init(dataService: DataServiceProtocol, user: Int) {
        self.dataService = dataService
        self.user = user
    }
    
    func recordButtonPressed() {
        isRecording ? recorder.stopRecording() : recorder.startRecording()
        isRecording.toggle()
    }
    
    func sendButtonPressed() {
        guard let audioURL = recorder.audioURL, let data = try? Data(contentsOf: audioURL) else { return }
        print("Sending audio from: \(audioURL)")
        Task {
            try await dataService.parseVoice(audio: data, for: user)
            recordingSaved = true
        }
    }
}
