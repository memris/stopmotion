//
//  FrameToolsButtonsView.swift
//  stopmotion
//
//  Created by USER on 01.11.2024.
//

import SwiftUI

struct FrameToolsButtonsView: View {
    @ObservedObject var viewModel: CanvasViewModel
    
    var body: some View {
        HStack(spacing:20){
            Spacer()
            HStack {
                Button{
                    if !viewModel.currentFrame.wrappedValue.lines.isEmpty {
                        let lastAction = viewModel.currentFrame.wrappedValue.lines.removeLast()
                        viewModel.redoHistory.append(lastAction)
                    }
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundColor(Theme.onSurface)
                        .font(.system(size: 16))
                        .padding(9)
                        .overlay(
                            Circle()
                                .stroke( Theme.onSurface, lineWidth: 2)
                        )
                }
                .disabled(viewModel.isAnimating)
                Button{
                    if !viewModel.redoHistory.isEmpty {
                        let lastRedoAction = viewModel.redoHistory.removeLast()
                        viewModel.currentFrame.wrappedValue.lines.append(lastRedoAction)
                    }
                } label: {
                    Image(systemName: "arrow.uturn.right")
                        .foregroundColor(Theme.onSurface)
                        .font(.system(size: 16))
                        .padding(9)
                        .overlay(
                            Circle()
                                .stroke( Theme.onSurface, lineWidth: 2)
                        )
                }
            }
            .opacity(viewModel.isAnimating ? 0 : 1)
            .disabled(viewModel.isAnimating)
            HStack(spacing: 6) {
                //новый кадр
                Button {
                    let newFrame = Frame()
                    viewModel.frames.insert(newFrame, at: viewModel.currentFrameIndex + 1)
                    viewModel.currentFrameIndex += 1
                } label: {
                    Image(systemName: "doc.badge.plus")
                        .renderingMode(.template)
                        .foregroundColor(Theme.onSurface)
                        .font(.system(size: 28))
                        .padding(9)
                }
                //удалить текущий кадр
                Button{
                    if viewModel.currentFrameIndex == 0 {
                        viewModel.frames.removeLast()
                        viewModel.frames = [Frame()]
                    }
                    if viewModel.currentFrameIndex > 0 {
                        viewModel.frames.remove(at: viewModel.currentFrameIndex)
                        viewModel.currentFrameIndex = viewModel.currentFrameIndex - 1
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(Theme.onSurface)
                        .font(.system(size: 28))
                        .padding(6)
                    
                }
                // список кадров
                Button {
                    withAnimation(.easeInOut(duration: 0.3)){
                        viewModel.isShowingFrameList.toggle()
                    }
                } label: {
                    Image(systemName: "square.3.layers.3d.down.left")
                        .foregroundColor(viewModel.isShowingFrameList ? Theme.accentColor : Theme.onSurface)
                        .font(.system(size: 28))
                        .padding(6)
                }
                //дублирование кадра
                Button {
                    viewModel.duplicateCurrentFrame()
                }
            label: {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(Theme.onSurface)
                    .font(.system(size: 24))
                    .padding(6)
            }
            }
            .opacity(viewModel.isAnimating ? 0 : 1)
            .disabled(viewModel.isAnimating)
            Button {
                if viewModel.isAnimating {
                    viewModel.stopAnimation()
                } else {
                    viewModel.startAnimation()
                }
            } label: {
                Image(viewModel.isAnimating ? "stop" : "play")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            Spacer()
        }
    }
}
