//
//  ImageFeedViewModel.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import Foundation
import UIKit

@MainActor
final class ImageFeedViewModel: ObservableObject {

    // MARK: - States

    enum PaginationState {
        case isLoading
        case idle
        case error(Error)
    }

    enum ViewState {
        case isLoading
        case loaded
        case error(Error)
    }

    // MARK: - Properties

    private let feedPageService: FeedPageService
    private let imageService: ImageService
    private let coordinator: Coordinator

    private var page = 1
    private var didAppearOnce = false

    private var photoModels: [PhotoModel] = [] {
        didSet {
            Task { await photosDidChange() }
        }
    }

    @Published private(set) var viewState: ViewState = .isLoading
    @Published private(set) var paginationState: PaginationState = .isLoading
    @Published private(set) var textImageCellViewModels: [TextImageCellViewModel] = []

    // MARK: - Init

    init(coordinator: Coordinator, feedPageService: FeedPageService, imageService: ImageService) {
        self.coordinator = coordinator
        self.feedPageService = feedPageService
        self.imageService = imageService
    }

    // MARK: - Public

    func didAppear() async {
        guard !didAppearOnce else { return }
        photoModels = await fetchPhotoModels()
        didAppearOnce = true
    }

    func didPullToRefresh() async {
        imageService.clearCache()
        page = 1
        photoModels = await fetchPhotoModels()
    }

    func didReachLastRow() async {
        guard !photoModels.isEmpty else { return }
        page += 1
        let models = await fetchPhotoModels()
        photoModels.append(contentsOf: models)
    }

    func didSelectRow(model: PhotoViewModel) {
        coordinator.routeToDetailsView(model: model)
    }

    // MARK: - Private

    private func fetchPhotoModels() async -> [PhotoModel] {
        do {
            paginationState = .isLoading
            viewState = .isLoading

            let response = try await feedPageService.fetchPage(page: page)
            paginationState = .idle
            viewState = .loaded

            return response.photos

        } catch {
            paginationState = .error(error)
            viewState = .error(error)
            return []
        }
    }

    private func photosDidChange() async {
        await withTaskGroup(of: Void.self) { group in
            var viewModels: [TextImageCellViewModel] = []
            photoModels.forEach {
                let textImageCellVM = TextImageCellViewModel(photoVM: .init(model: $0))
                viewModels.append(textImageCellVM)

                group.addTask {
                    await self.fetchThumbnail(viewModel: textImageCellVM)
                }
            }
            textImageCellViewModels = viewModels
        }
    }

    private func fetchThumbnail(viewModel: TextImageCellViewModel) async {
        do {
            let image = try await imageService.fetchImage(viewModel.photoVM.smallImageURL)
            viewModel.viewState = .loaded(image)
        } catch {
            viewModel.viewState = .error(error)
        }
    }
}
