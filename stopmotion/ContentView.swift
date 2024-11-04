//
//  ContentView.swift
//  stopmotion
//
//  Created by USER on 29.10.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CanvasViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .ignoresSafeArea()
            HStack {
                VStack {
                    Spacer()
                    FrameToolsButtonsView(viewModel: viewModel)
                    CanvasView(viewModel: viewModel)
                    FrameListView(viewModel: viewModel)
                    PaintToolsButtonsView(viewModel: viewModel)
                    Spacer()
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .light)
    }
}
