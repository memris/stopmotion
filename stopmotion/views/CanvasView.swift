//
//  AnimationView.swift
//  stopmotion
//
//  Created by USER on 29.10.2024.
//

import SwiftUI

struct CanvasView: View {
    @StateObject private var viewModel = CanvasViewModel()
    
    
    var body: some View {
        VStack(spacing: 10) {
            
            FrameToolsButtonsView(viewModel: viewModel)
            // Spacer()
            ZStack {
                viewModel.paperImage
                    .resizable()
                    .frame(width: 380, height: 500)
                
                ForEach(0..<viewModel.frames.count, id: \.self) { index in
                    Canvas { context, size in
                        if index == viewModel.currentFrameIndex {
                            for line in viewModel.frames[index].lines {
                                var path = Path()
                                path.addLines(line.points)
                                
                                if line.mode == .draw {
                                    context.blendMode = .normal
                                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth))
                                } else {
                                    context.blendMode = .destinationOut
                                    context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: line.lineWidth * 2))
                                }
                            }
                        }
                        if index == viewModel.currentFrameIndex - 1 && viewModel.currentFrameIndex > 0 {
                            for line in viewModel.frames[index].lines {
                                var path = Path()
                                path.addLines(line.points)
                                
                                if line.mode == .draw {
                                    context.blendMode = .normal
                                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth))
                                } else {
                                    context.blendMode = .destinationOut
                                    context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: line.lineWidth * 2))
                                }
                            }
                        }
                    }
                    .frame(width: 380, height: 500)
                    .opacity(
                        viewModel.isAnimating &&  index == viewModel.currentFrameIndex ? 1 :
                            viewModel.isAnimating && index == viewModel.currentFrameIndex - 1 ? 0 :
                            index == viewModel.currentFrameIndex  ? 1 : (index == viewModel.currentFrameIndex - 1 ? 0.3 : 0))
                }
                .gesture(
                    DragGesture()
                        .onChanged { dragValue in
                            guard !viewModel.isAnimating else { return }
                            if viewModel.currentFrame.wrappedValue.lines.isEmpty {
                                if let selectionModeIndex = viewModel.selectionModeIndex, let mode = Mode(rawValue: selectionModeIndex) {
                                    viewModel.currentFrame.wrappedValue.lines = [Line(color: viewModel.selectedColor, points: [dragValue.startLocation], mode: mode, lineWidth: 5)]
                                }
                            } else {
                                let lastLine = viewModel.currentFrame.wrappedValue.lines[viewModel.currentFrame.wrappedValue.lines.count - 1]
                                if let selectionModeIndex = viewModel.selectionModeIndex {
                                    if dragValue.startLocation != lastLine.points.first! || lastLine.mode != Mode(rawValue: selectionModeIndex)! {
                                        let newLine = Line(color: viewModel.selectedColor, points: [dragValue.startLocation], mode: Mode(rawValue: selectionModeIndex)!, lineWidth: 5)
                                        viewModel.currentFrame.wrappedValue.lines.append(newLine)
                                    } else {
                                        viewModel.currentFrame.wrappedValue.lines[viewModel.currentFrame.wrappedValue.lines.count - 1].points.append(dragValue.location)
                                        viewModel.currentFrame.wrappedValue = viewModel.currentFrame.wrappedValue
                                    }
                                }
                            }
                        }
                )
            }
            .cornerRadius(20)
            //Spacer()
            PaintToolsButtonsView(viewModel: viewModel)
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            CanvasView()
        }
    }
}
