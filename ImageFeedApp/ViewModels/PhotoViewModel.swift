//
//  PhotoViewModel.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import Foundation
import UIKit

struct PhotoViewModel {

    // MARK: - Properties

    let photographer: String
    let src: SourceModel

    var smallImageURL: URL? {
        URL(string: src.small)
    }

    var bigImageURL: URL? {
        URL(string: src.large)
    }

    // MARK: - Init

    init(model: PhotoModel) {
        self.photographer = model.photographer
        self.src = model.src
    }
}
