//
//  VoiceRecorderView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 21.2.25.
//

import SwiftUI

struct VoiceRecorderView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: VoiceRecorderViewModel
    
    init(dataService: DataServiceProtocol, userId: Int) {
        self.viewModel = VoiceRecorderViewModel(dataService: dataService, user: userId)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text(viewModel.title)
                .font(.headline)
            
            if viewModel.isRecording {
                WaveformView()
                    .frame(height: 100)
                    .padding()
            }
            
            Button(action: {
                viewModel.recordButtonPressed()
            }) {
                Image(systemName: viewModel.iconName)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(viewModel.iconColor)
            }
            
            if viewModel.showSendButton {
                Button("Send") {
                    viewModel.sendButtonPressed()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .padding()
        .onChange(of: viewModel.recordingSaved) { _, saved in
            if saved {
                dismiss()
            }
        }
    }
}

#Preview {
    VoiceRecorderView(dataService: MockDataService(), userId: 0)
}
