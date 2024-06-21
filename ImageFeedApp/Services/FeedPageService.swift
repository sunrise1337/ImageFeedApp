//
//  FeedPageService.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 19.06.2024.
//

import Foundation

protocol FeedPageService: AnyObject {
    func fetchPage(page: Int) async throws -> ImageDataResponseModel
}

final class FeedPageServiceImpl: FeedPageService {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchPage(page: Int) async throws -> ImageDataResponseModel {
        guard var url = URL(string: Constants.APIUrl) else { throw NetworkError.badUrl }

        let queryItem = URLQueryItem(name: Constants.pageQueryItem, value: String(page))
        url.append(queryItems: [queryItem])
        return try await networkService.fetchJSON(from: url, responseType: ImageDataResponseModel.self)
    }
}
