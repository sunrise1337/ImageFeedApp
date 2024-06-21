//
//  TextImageViewCell.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import Foundation
import SwiftUI

struct TextImageViewCell: View {
    @ObservedObject var viewModel: TextImageCellViewModel
    
    var body: some View {
        HStack {
            ImageCellView(viewModel: viewModel)
                .frame(width: 75, height: 75)
                .clipped()
            Spacer()
            Text(viewModel.photoVM.photographer)
                .foregroundStyle(.black)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 8)
    }
}

