//
//  ImageDataResponseModel.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import Foundation

struct ImageDataResponseModel: Decodable {
    let photos: [PhotoModel]
}

struct PhotoModel: Decodable {
    let photographer: String
    let src: SourceModel
}

struct SourceModel: Decodable {
    let large: String
    let small: String
}
