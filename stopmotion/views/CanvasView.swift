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
    @State private var selectionModeIndex: Int = 0
    @State private var lines: [Line] = []

    var body: some View {
        VStack {
            Picker("Mode:", selection: $selectionModeIndex) {
                Text("Draw mode").tag(0)
                Text("Eraser Mode").tag(1)
            }
            .pickerStyle(.segmented)

            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)

                    if line.mode == .draw {
                        context.blendMode = .normal
                        context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth))
                    } else {
                        context.blendMode = .destinationOut // .destinationOut для стирания
                        context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: line.lineWidth * 2))
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { dragValue in
                        if lines.isEmpty {
                            lines = [Line(color: .black, points: [dragValue.startLocation], mode: Mode(rawValue: selectionModeIndex)!, lineWidth: 5)]
                        } else {
                            let lastLine = lines[lines.count - 1]

                            if dragValue.startLocation != lastLine.points.first! || lastLine.mode != Mode(rawValue: selectionModeIndex)! {
                                // Start a new line if start location is different or mode changed
                                let newLine = Line(color: .black, points: [dragValue.startLocation], mode: Mode(rawValue: selectionModeIndex)!, lineWidth: 5) // Добавлен lineWidth
                                lines.append(newLine)
                            } else {
                                // Append point to last line
                                lines[lines.count - 1].points.append(dragValue.location)
                            }
                        }
                    }
            )
            .frame(width: 300, height: 400)
            .border(Color.gray, width: 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
