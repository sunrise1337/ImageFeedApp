//
//  ImageFeedMainView.swift
//  ImageFeedApp
//
//  Created by Konstantin Deulin on 18.06.2024.
//

import SwiftUI

struct ImageFeedMainView: View {
    @ObservedObject private var viewModel: ImageFeedViewModel

    private let navigationTitle = "Image feed"

    var body: some View {
        switch viewModel.viewState {
        case .loaded, .isLoading:
            listView

        case .error(let error):
            ErrorView(error: error)
        }
    }

    private var listView: some View {
        List {
            ForEach(viewModel.textImageCellViewModels) { model in
                TextImageViewCell(viewModel: model)
                    .onTapGesture {
                        viewModel.didSelectRow(model: model.photoVM)
                    }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.white)

            lastRowItem
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
        }
        .task {
            await viewModel.didAppear()
        }
        .refreshable {
            await viewModel.didPullToRefresh()
        }

        .listStyle(.plain)
        .navigationTitle(navigationTitle)
    }

    private var lastRowItem: some View {
        ZStack(alignment: .center) {
            switch viewModel.paginationState {
            case .isLoading:
                ProgressView()
            case .idle:
                EmptyView()
            case .error(let error):
                ErrorView(error: error)
            }
        }
        .frame(height: 75)
        .task {
            await viewModel.didReachLastRow()
        }
    }

    init(viewModel: ImageFeedViewModel) {
        self.viewModel = viewModel
    }
}

struct ErrorView: View {
    let error: Error

    var body: some View {
        Text(error.localizedDescription)
    }
}

