//
//  MiniatureView.swift
//  stopmotion
//
//  Created by USER on 01.11.2024.
//

import SwiftUI

struct MiniatureView: View {
    let frame: Frame
    
    var body: some View {
        frame.miniature(size: CGSize(width: 100, height: 100), canvasSize: CGSize(width: 380, height: 500))
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .border(Color.gray, width: 1)
    }
}
