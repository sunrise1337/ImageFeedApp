//
//  ImageCellView.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import SwiftUI

struct ImageCellView: View {
    @ObservedObject var viewModel: TextImageCellViewModel
    
    private let errorImageName = "exclamationmark.circle"
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .isLoading:
                ProgressView()
            case .loaded(let image):
                Image(uiImage: image)
            case .error(let error):
                VStack{
                    Image(systemName: errorImageName)
                    Text(error.localizedDescription)
                }
            }
        }
    }
}
