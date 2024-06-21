//
//  ImageService.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import Foundation
import UIKit

protocol ImageService: AnyObject {
    func fetchImage(_ url: URL?) async throws -> UIImage
    func clearCache()
}

final class ImageServiceImpl: ImageService {
    private let networkService: NetworkService
    private let cache = NSCache<NSString, UIImage>()

    init(networkService: NetworkService) {
        self.networkService = networkService
        self.cache.countLimit = 100
    }

    func fetchImage(_ url: URL?) async throws -> UIImage {
        guard let url = url else { throw NetworkError.badUrl }

        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        } else {
            let data = try await networkService.fetchData(from: url)
            guard let uiImage = UIImage(data: data) else { throw NetworkError.unsupportedImage }
            cache.setObject(uiImage, forKey: url.absoluteString as NSString)
            return uiImage
        }
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
