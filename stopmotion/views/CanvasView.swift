//
//  AnimationView.swift
//  stopmotion
//
//  Created by USER on 29.10.2024.
//

import SwiftUI

enum Mode {
    case draw
    case erase
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .draw
        case 1: self = .erase
        default: return nil
        }
    }
}

struct Line {
    var color: Color
    var points: [CGPoint]
    var mode: Mode
    var lineWidth: CGFloat
}

struct Frame: Identifiable {
    let id = UUID()
    var lines: [Line] = []
}

struct CanvasView: View {
    @State private var selectionModeIndex: Int? = nil
    @State private var lines: [Line] = []
    private var paperImage: Image = Image("paper")
    @State private var redoHistory: [Line] = []
    @State private var selectedColor: Color = .black
    @State private var isShowingColorPicker = false
    
    @State private var frames: [Frame] = [Frame()]
    @State private var currentFrameIndex = 0
    
    @State private var isAnimating = false
    @State private var timer: Timer? = nil
    
    var currentFrame: Binding<Frame> {
        Binding(
            get: {frames[currentFrameIndex]},
            set: {frames[currentFrameIndex] = $0})
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing:20){
                Spacer()
                HStack {
                    Button{
                        if !currentFrame.wrappedValue.lines.isEmpty {
                            let lastAction = currentFrame.wrappedValue.lines.removeLast()
                            redoHistory.append(lastAction)
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
                    Button{
                        if !redoHistory.isEmpty {
                            let lastRedoAction = redoHistory.removeLast()
                            currentFrame.wrappedValue.lines.append(lastRedoAction)
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
                HStack(spacing: 0) {
                    //новый кадр
                     Button{
                        frames.append(Frame())
                         currentFrameIndex = frames.count - 1
                     } label: {
                         Image("file-plus")
                             .resizable()
                                 .frame(width: 40, height: 40)
                             .colorInvert()
                        
                     }
                     //удалить текущий кадр
                     Button{
                         if currentFrameIndex > 0 {
                             frames.remove(at: currentFrameIndex)
                             currentFrameIndex = currentFrameIndex - 1
                         }
                     } label: {
                         Image("remove")
                             .resizable()
                                 .frame(width: 40, height: 40)
                             .colorInvert()
                        
                     }
                }
                //предыдущий кадр
                Button{
                    if currentFrameIndex > 0 {
                        frames[currentFrameIndex].lines = currentFrame.wrappedValue.lines
                        currentFrameIndex -= 1
                    }
                }
            label: {
                Image(systemName: "arrow.left")
                
            }
                //следующий кадр
                Button {
                    if currentFrameIndex < frames.count - 1 {
                        frames[currentFrameIndex].lines = currentFrame.wrappedValue.lines
                        currentFrameIndex += 1
                    }
                } label: {
                    Image(systemName: "arrow.right")
                    
                }
                Button {
                    if isAnimating { isAnimating = false
                        timer?.invalidate()
                        timer = nil
                        currentFrameIndex = frames.count - 1}
                   else {
                       currentFrameIndex = 0
                        isAnimating = true
                               timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                                   currentFrameIndex = (currentFrameIndex + 1) % frames.count
                               }
                    }
                  
                   
                } label: {
                    Image(isAnimating ? "stop" : "play")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                Spacer()
            }
            Spacer()
            ZStack {
                paperImage
                    .resizable()
                    .frame(width: 350, height: 600)
                
                ForEach(0..<frames.count, id: \.self) { index in
                    Canvas { context, size in
                        if index == currentFrameIndex {
                            for line in frames[index].lines {
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
                        if index == currentFrameIndex - 1 && currentFrameIndex > 0 {
                            for line in frames[index].lines {
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
                    .frame(width: 350, height: 600)
                    .opacity(
                        isAnimating &&  index == currentFrameIndex ? 1 :
                                isAnimating && index == currentFrameIndex - 1 ? 0 :
                        index == currentFrameIndex  ? 1 : (index == currentFrameIndex - 1 ? 0.3 : 0))
                }
                .gesture(
                    DragGesture()
                        .onChanged { dragValue in
                            if currentFrame.wrappedValue.lines.isEmpty {
                                if let selectionModeIndex = selectionModeIndex, let mode = Mode(rawValue: selectionModeIndex) {
                                    currentFrame.wrappedValue.lines = [Line(color: selectedColor, points: [dragValue.startLocation], mode: mode, lineWidth: 5)]
                                }
                            } else {
                                let lastLine = currentFrame.wrappedValue.lines[currentFrame.wrappedValue.lines.count - 1]
                                if let selectionModeIndex = selectionModeIndex {
                                    if dragValue.startLocation != lastLine.points.first! || lastLine.mode != Mode(rawValue: selectionModeIndex)! {
                                        let newLine = Line(color: selectedColor, points: [dragValue.startLocation], mode: Mode(rawValue: selectionModeIndex)!, lineWidth: 5)
                                        currentFrame.wrappedValue.lines.append(newLine)
                                    } else {
                                        currentFrame.wrappedValue.lines[currentFrame.wrappedValue.lines.count - 1].points.append(dragValue.location)
                                        currentFrame.wrappedValue = currentFrame.wrappedValue
                                    }
                                }
                            }
                        }
                )
                .frame(width: 350, height: 600)
            }
            .frame(width: 350, height: 600)
            .cornerRadius(20)
            Spacer()
            HStack(spacing:20){
                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
                Button{
                    selectionModeIndex = 0
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(selectionModeIndex == 0 ? Theme.accentColor : .black)
                        .font(.system(size: 30))
                        .padding(9)
                        .overlay(
                            Circle()
                                .stroke(selectionModeIndex == 0 ? Theme.accentColor : .black, lineWidth: 3)
                        )
                }
                Button{
                    selectionModeIndex = 1
                } label: {
                    Image(systemName: "eraser")
                        .foregroundColor(selectionModeIndex == 1 ? Theme.accentColor : .black)
                        .font(.system(size: 27))
                        .padding(9)
                        .overlay(
                            Circle()
                                .stroke(selectionModeIndex == 1 ? Theme.accentColor : .black, lineWidth: 3)
                        )
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
