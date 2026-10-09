//
//  NetworkError.swift
//  GreenCheck
//
//  Created by Rajbir Singh Sehmi on 10/6/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatusError(statusCode: Int)
    case productNotFound
    case decodingError(error: Error)
    case unknown(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Requested URL is invalid. Pleae check again"
            
        case .invalidResponse:
            return "Invalid Response is recieved from the server"
            
        case .httpStatusError(let statusCode):
            return "Server responded with error code: \(statusCode)"
            
        case .productNotFound:
            return "Requested Product not found."
            
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
            
        case .unknown(let error):
            return "Unknown error encountered: \(error.localizedDescription)"
        }
    }
}
