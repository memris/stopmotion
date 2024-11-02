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
    @Published var redoHistory: [Line] = []
    
    @Published var selectedColor: Color = .black
    
    @Published var isShowingFrameList = false
    
    @Published var frames: [Frame] = [Frame()]
    @Published var currentFrameIndex = 0
    
    @Published var isAnimating = false
    @Published var timer: Timer? = nil
    
    var currentFrame: Binding<Frame> {
        Binding(
            get: {self.frames[self.currentFrameIndex]},
            set: {self.frames[self.currentFrameIndex] = $0})
    }
    
    
    var paperImage: Image = Image("paper")
    
}
