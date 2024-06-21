//
//  ApplicationCoordinator.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import UIKit
import SwiftUI

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    func startFlow()
    func routeToDetailsView(model: PhotoViewModel)
}

final class ApplicationCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependencyContainer = DependencyContainer()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func startFlow() {
        let feedPageService = dependencyContainer.getFeedPageService()
        let imageService = dependencyContainer.getImageService()
        let viewModel = ImageFeedViewModel(coordinator: self, feedPageService: feedPageService, imageService: imageService)

        let mainView = ImageFeedMainView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: mainView)
        navigationController.setViewControllers([hostingController], animated: false)
    }

    func routeToDetailsView(model: PhotoViewModel) {
        let detailsView = ImageFeedDetailsView(model: model)
        let hostingController = UIHostingController(rootView: detailsView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}

