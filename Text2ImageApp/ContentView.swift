//
//  ContentView.swift
//  Text2ImageApp
//
//  Created by Alfian Losari on 17/09/23.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var vm = ViewModel(apiKey: "YOUR_OPENAI_API_KEY")
    
    var body: some View {
        VStack(spacing: 16) {
            switch vm.fetchPhase {
            case .loading: ProgressView("Requesting to AI")
            case .success(let image):
                image.resizable().scaledToFit()
            case .failure(let error):
                Text(error).foregroundStyle(Color.red)
            default: EmptyView()
            }
            
            TextField("Enter prompt", text: $vm.prompt, prompt: Text("Enter prompt"), axis: .vertical)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .disabled(vm.fetchPhase == .loading)
            
            Button("Generate Image") {
                Task { await vm.generateImage() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.fetchPhase == .loading || vm.prompt.isEmpty)
            
        }
        .padding()
        .navigationTitle("XCA AIText2Image")
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
