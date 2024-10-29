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

struct CanvasView: View {
    @State private var selectionModeIndex: Int? = nil
    @State private var lines: [Line] = []
    private var paperImage: Image = Image("paper")
    @State private var redoHistory: [Line] = []
    @State private var selectedColor: Color = .black
    @State private var isShowingColorPicker = false

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing:20){
                Button{
                    if !lines.isEmpty {
                        let lastAction = lines.removeLast()
                        redoHistory.append(lastAction)
                    }
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(9)
                        .overlay(
                            Circle()
                                .stroke( .black, lineWidth: 2)
                        )
                }
                Button{
                    if !redoHistory.isEmpty {
                        let lastRedoAction = redoHistory.removeLast()
                        lines.append(lastRedoAction)
                    }
                } label: {
                    Image(systemName: "arrow.uturn.right")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(9)
                        .overlay(
                            Circle()
                                .stroke( .black, lineWidth: 2)
                        )
                }
                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
             }
         Spacer()
            ZStack {
                paperImage
                    .resizable()
                    .frame(width: 350, height: 600)
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)

                        if line.mode == .draw {
                            context.blendMode = .normal
                            context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth))
                        } else {
                            context.blendMode = .destinationOut //для стирания
                            context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: line.lineWidth * 2))
                        }
                    }
                }
                
                .gesture(
                    DragGesture()
                        .onChanged { dragValue in
                            if lines.isEmpty {
                                if let selectionModeIndex = selectionModeIndex, let mode = Mode(rawValue: selectionModeIndex) {
                                    lines = [Line(color: selectedColor, points: [dragValue.startLocation], mode: mode, lineWidth: 5)]
                                }
                               
                            } else {
                                let lastLine = lines[lines.count - 1]
                                if let selectionModeIndex = selectionModeIndex {
                                   
                                    if dragValue.startLocation != lastLine.points.first! || lastLine.mode != Mode(rawValue: selectionModeIndex)! {
                                        let newLine = Line(color: selectedColor, points: [dragValue.startLocation], mode: Mode(rawValue: selectionModeIndex)!, lineWidth: 5)
                                        lines.append(newLine)
                                    } else {
                                        lines[lines.count - 1].points.append(dragValue.location)
                                    }
                                }
                              
                            }
                        }
                    
                )
                .frame(width: 350, height: 600)
                
            }
            .cornerRadius(20)
            Spacer()
            HStack(spacing:20){
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
