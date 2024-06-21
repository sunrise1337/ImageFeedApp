//
//  TextImageCellViewModel.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 19.06.2024.
//

import Foundation
import UIKit

final class TextImageCellViewModel: ObservableObject, Identifiable {

    // MARK: - ViewState

    enum ViewState {
        case isLoading
        case loaded(UIImage)
        case error(Error)
    }

    // MARK: - Properties

    @Published var viewState: ViewState = .isLoading
    let photoVM: PhotoViewModel

    // MARK: - Init

    init(photoVM: PhotoViewModel) {
        self.photoVM = photoVM
    }
}
