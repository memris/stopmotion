//
//  FrameListView.swift
//  stopmotion
//
//  Created by USER on 01.11.2024.
//

import SwiftUI

struct FrameListView: View {
    @ObservedObject var viewModel: CanvasViewModel
    
    var body: some View {
        if viewModel.isShowingFrameList {
            ScrollView(.horizontal) {
                HStack {
                    Spacer()
                    ForEach(viewModel.frames) { frame in
                        MiniatureView(frame: frame)
                            .onTapGesture {
                                if let index = viewModel.frames.firstIndex(where: { $0.id == frame.id }) {
                                    viewModel.currentFrameIndex = index
                                }
                            }
                            .background(
                                viewModel.currentFrameIndex == viewModel.frames.firstIndex(where: { $0.id == frame.id }) ?
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Theme.accentColor.opacity(0.2)) 
                                : nil
                            )
                    }
                }
                .opacity(viewModel.isAnimating ? 0 : 1)
                .disabled(viewModel.isAnimating)
            }
        }
    }
}
