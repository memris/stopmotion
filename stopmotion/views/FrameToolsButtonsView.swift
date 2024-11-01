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
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                        .padding(9)
                        .overlay(
                            Circle()
                                .stroke( .black, lineWidth: 2)
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
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                        .padding(9)
                        .overlay(
                            Circle()
                                .stroke( .black, lineWidth: 2)
                        )
                }
            }
            .opacity(viewModel.isAnimating ? 0 : 1)
            .disabled(viewModel.isAnimating)
            HStack(spacing: 0) {
                //новый кадр
                Button{
                    viewModel.frames.append(Frame())
                    viewModel.currentFrameIndex = viewModel.frames.count - 1
                } label: {
                    Image("file-plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .colorInvert()
                    
                }
                //удалить текущий кадр
                Button{
                    if viewModel.currentFrameIndex > 0 {
                        viewModel.frames.remove(at: viewModel.currentFrameIndex)
                        viewModel.currentFrameIndex = viewModel.currentFrameIndex - 1
                    }
                } label: {
                    Image("remove")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .colorInvert()
                    
                }
                // список кадров
                Button {
                    // TODO: отображать список кадров(фиол если активно)
                } label: {
                    Image("layers")
                        .resizable()
                        .frame(width: 38, height: 38)
                        .colorInvert()
                }
            }
            .opacity(viewModel.isAnimating ? 0 : 1)
            .disabled(viewModel.isAnimating)
            //                //предыдущий кадр
            //                Button{
            //                    if currentFrameIndex > 0 {
            //                        frames[currentFrameIndex].lines = currentFrame.wrappedValue.lines
            //                        currentFrameIndex -= 1
            //                    }
            //                }
            //            label: {
            //                Image(systemName: "arrow.left")
            //
            //            }
            //                //следующий кадр
            //                Button {
            //                    if currentFrameIndex < frames.count - 1 {
            //                        frames[currentFrameIndex].lines = currentFrame.wrappedValue.lines
            //                        currentFrameIndex += 1
            //                    }
            //                } label: {
            //                    Image(systemName: "arrow.right")
            //
            //                }
            Button {
                if viewModel.isAnimating { viewModel.isAnimating = false
                    viewModel.timer?.invalidate()
                    viewModel.timer = nil
                    viewModel.currentFrameIndex = viewModel.frames.count - 1
                }
                else {
                    viewModel.currentFrameIndex = 0
                    viewModel.isAnimating = true
                    viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
                        viewModel.currentFrameIndex = (viewModel.currentFrameIndex + 1) % viewModel.frames.count
                    }
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
