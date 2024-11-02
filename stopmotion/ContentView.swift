//
//  ContentView.swift
//  stopmotion
//
//  Created by USER on 29.10.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CanvasViewModel()
    var body: some View {
        VStack {
            FrameToolsButtonsView(viewModel: viewModel)
            CanvasView(viewModel: viewModel)
            FrameListView(viewModel: viewModel)
            PaintToolsButtonsView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
