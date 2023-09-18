//
//  ViewModel.swift
//  Text2ImageApp
//
//  Created by Alfian Losari on 17/09/23.
//

import Foundation
import Observation
import OpenAIClient
import SwiftUI

@Observable
class ViewModel {
    
    let client: OpenAIClient
    
    var prompt = ""
    var fetchPhase = FetchPhase.initial
    
    init(apiKey: String) {
        self.client = .init(apiKey: apiKey)
    }
    
    @MainActor
    func generateImage() async {
        self.fetchPhase = .loading
        do {
            let url = try await client.generateImage(prompt: prompt)
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                self.fetchPhase = .failure("failed to download image")
                return
            }
            self.fetchPhase = .success(Image(uiImage: image))
        } catch {
            self.fetchPhase = .failure(error.localizedDescription)
        }
    }
    
}


enum FetchPhase: Equatable {
    case initial
    case loading
    case success(Image)
    case failure(String)
}

