//
//  CanvasViewModel.swift
//  stopmotion
//
//  Created by USER on 29.10.2024.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
    @Published var selectionModeIndex: Int? = nil
    
    @Published var lines: [Line] = []
    @Published var lineWidth: CGFloat = 3
    
    @Published var redoHistory: [Line] = []
    
    @Published var selectedColor: Color = .black
    
    @Published var isShowingFrameList = false
    
    @Published var frames: [Frame] = [Frame()]
    @Published var currentFrameIndex = 0
    
    @Published var isAnimating = false
    @Published var timer: Timer? = nil
    @Published var animationSpeed: Double = 1.0 {
        didSet {
            if isAnimating {
                startAnimation()
            }
        }
    }
    
    
    @Published var isMenuOpen = false
    
    var currentFrame: Binding<Frame> {
        Binding(
            get: {self.frames[self.currentFrameIndex]},
            set: {self.frames[self.currentFrameIndex] = $0})
    }
    
    
    var paperImage: Image = Image("paper")
    
    
    func updateLineWidth(newLineWidth: CGFloat) {
        lineWidth = newLineWidth
    }
    
    func generateRandomFrames(count: Int, canvasSize: CGSize) {
        var randomFrames: [Frame] = []
        let color = selectedColor
        
        for _ in 0..<count {
            var point1: CGPoint
            var point2: CGPoint
            var point3: CGPoint
            
            repeat {
                let randomX1 = CGFloat.random(in: 0...(canvasSize.width ))
                let randomY1 = CGFloat.random(in: 0...(canvasSize.height ))
                point1 = CGPoint(x: randomX1, y: randomY1)
                
                let randomX2 = CGFloat.random(in: 0...(canvasSize.width ))
                let randomY2 = CGFloat.random(in: 0...(canvasSize.height))
                point2 = CGPoint(x: randomX2, y: randomY2)
                
                let randomX3 = CGFloat.random(in: 0...(canvasSize.width ))
                let randomY3 = CGFloat.random(in: 0...(canvasSize.height ))
                point3 = CGPoint(x: randomX3, y: randomY3)
            } while point1 == point2 || point1 == point3 || point2 == point3
            
            let line1 = Line(color: color, points: [point1, point2], mode: .draw, lineWidth: 2.0)
            let line2 = Line(color: color, points: [point2, point3], mode: .draw, lineWidth: 2.0)
            let line3 = Line(color: color, points: [point3, point1], mode: .draw, lineWidth: 2.0)
            
            let frame = Frame(lines: [line1, line2, line3])
            randomFrames.append(frame)
        }
        if frames.count == 1 {
            frames = randomFrames
        } else {
            frames.append(contentsOf: randomFrames)
        }
    }
    
    private func interval(forSpeed speed: Double) -> TimeInterval {
        let baseInterval: TimeInterval = 0.15
        return baseInterval / speed
    }
    
    func startAnimation() {
        guard !isAnimating, !frames.isEmpty else { return }
        isAnimating = true
        currentFrameIndex = 0
        timer?.invalidate()
        let interval = interval(forSpeed: animationSpeed)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.currentFrameIndex = (self.currentFrameIndex + 1) % self.frames.count
        }
    }
    func changeAnimationSpeed(to speed: Double) {
        animationSpeed = speed
    }
    
    func stopAnimation() {
        guard isAnimating else { return }
        isAnimating = false
        timer?.invalidate()
        timer = nil
        currentFrameIndex = frames.count - 1
    }
    
    func duplicateCurrentFrame() {
        guard !frames.isEmpty, currentFrameIndex < frames.count else { return }
        
        let newFrame = Frame(
            lines: frames[currentFrameIndex].lines.map { $0 }
        )
        let insertIndex = currentFrameIndex + 1
        if currentFrameIndex < frames.count - 1 {
            frames.insert(newFrame, at: insertIndex)
        } else {
            frames.append(newFrame)
        }
    }
}
