//
//  DependencyContainer.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 19.06.2024.
//

import Foundation

final class DependencyContainer {
    private let networkService: NetworkService = NetworkServiceImpl()
    private let imageService: ImageService
    private let feedPageService: FeedPageService

    init() {
        self.imageService = ImageServiceImpl(networkService: networkService)
        self.feedPageService = FeedPageServiceImpl(networkService: networkService)
    }

    func getNetworkService() -> NetworkService {
        return networkService
    }

    func getImageService() -> ImageService {
        return imageService
    }

    func getFeedPageService() -> FeedPageService {
        return feedPageService
    }
}
