//
//  ImageFeedDetailsView.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import Foundation
import SwiftUI

struct ImageFeedDetailsView: View {
    @State var model: PhotoViewModel

    private let errorImageName = "exclamationmark.circle"
    private let unknownErrorText = "Unknown"
    private var authorString: String {
        "Author: \(model.photographer)"
    }

    var body: some View {
        VStack {
            Text(authorString)
            AsyncImage(url: model.bigImageURL, content: view)
        }
    }

    @ViewBuilder
    private func view(for phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            ProgressView()
        case .success(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .failure(let error):
            VStack(spacing: 16) {
                Image(systemName: errorImageName)
                    .foregroundColor(.red)
                Text(error.localizedDescription)
            }
        @unknown default:
            Text(unknownErrorText)
                .foregroundColor(.gray)
        }
    }
}
