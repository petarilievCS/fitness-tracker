//
//  AudioRecorder.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 21.2.25.
//

import Foundation
import AVFoundation
import SwiftUI

@Observable
class AudioRecorder {
    private var audioRecorder: AVAudioRecorder!
    var audioURL: URL?
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("audio.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            audioURL = nil
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        audioURL = audioRecorder.url
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
