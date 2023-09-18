//
//  OpenAIClient.swift
//  OpenAIClient
//
//  Created by Alfian Losari on 17/09/23.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

struct AuthMiddleware: ClientMiddleware {
    
    let apiKey: String
    
    func intercept(_ request: Request, baseURL: URL, operationID: String, next: (Request, URL) async throws -> Response) async throws -> Response {
        var request = request
        request.headerFields.append(.init(
            name: "Authorization", value: "Bearer \(apiKey)"))
        return try await next(request, baseURL)
    }
    
}

public struct OpenAIClient {
    
    let client: Client
    
    public init(apiKey: String) {
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport(),
            middlewares: [AuthMiddleware(apiKey: apiKey)])
    }
    
    public func generateImage(prompt: String) async throws -> URL {
        let response = try await client.createImage(.init(body: .json(
            .init(
                n: 1,
                prompt: prompt,
                response_format: .url,
                size: ._1024x1024
            ))))
        
        switch response {
        case .ok(let response):
            switch response.body {
            case .json(let imageResponse) where imageResponse.data.first?.url != nil:
                return URL(string: imageResponse.data[0].url!)!
            default:
                throw "Unknown response"
            }
        default:
            throw "Failed to generate image"
        }
    }
    
}

extension String: LocalizedError {
    
    public var errorDescription: String? { self }
}
