//
//  NetworkService.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badRequest
    case unsupportedImage
    case badUrl
}

enum Constants {
    static let APIUrl = "https://api.pexels.com/v1/curated"
    static let pageQueryItem = "page"
}

protocol NetworkService: AnyObject {
    func fetchData(from url: URL) async throws -> Data
    func fetchJSON<T: Decodable>(from url: URL, responseType: T.Type) async throws -> T
}

final class NetworkServiceImpl: NetworkService {
    private enum Constants {
        static let APIKey = "LrnXetfYzNSOX6f7iTEXk0JvgqKtN23tmtmQSh4Q7KCsqy1Op6PZ76SZ"
        static let authorizationHeader = "Authorization"
    }

    private let jsonDecoder = JSONDecoder()
    private let urlSession = URLSession.shared

    func fetchJSON<T>(from url: URL, responseType: T.Type) async throws -> T where T : Decodable {
        let data = try await fetchData(from: url)
        let decodedResponse = try jsonDecoder.decode(T.self, from: data)
        return decodedResponse
    }

    func fetchData(from url: URL) async throws -> Data {
        let request = makeRequest(for: url)
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }

        return data
    }

    private func makeRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(Constants.APIKey, forHTTPHeaderField: Constants.authorizationHeader)
        return request
    }
}
