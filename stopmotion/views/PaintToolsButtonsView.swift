//
//  PaintToolsButtonsView.swift
//  stopmotion
//
//  Created by USER on 01.11.2024.
//

import SwiftUI

struct PaintToolsButtonsView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State private var selectedOption = ""
    
    var body: some View {
        HStack(spacing:20){
            Spacer()
                .frame(width: 30)
            ColorPicker("", selection: $viewModel.selectedColor)
                .labelsHidden()
            VStack {
                Slider(value: $viewModel.lineWidth, in: 1...10)
                    .padding()
                HStack{
                    Button{
                        if viewModel.selectionModeIndex == 0 {
                            viewModel.selectionModeIndex = nil
                        } else {
                            viewModel.selectionModeIndex = 0
                        }
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(viewModel.selectionModeIndex == 0 ? Theme.accentColor : Theme.onSurface)
                            .font(.system(size: 30))
                            .padding(9)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.selectionModeIndex == 0 ? Theme.accentColor : Theme.onSurface, lineWidth: 3)
                            )
                    }
                    Button{
                        if viewModel.selectionModeIndex == 1 {
                            viewModel.selectionModeIndex = nil
                        } else {
                            viewModel.selectionModeIndex = 1
                        }
                    } label: {
                        Image(systemName: "eraser")
                            .foregroundColor(viewModel.selectionModeIndex == 1 ? Theme.accentColor : Theme.onSurface)
                            .font(.system(size: 27))
                            .padding(9)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.selectionModeIndex == 1 ? Theme.accentColor : Theme.onSurface, lineWidth: 3)
                            )
                    }
                }
            }
            
            Button {
                withAnimation {
                    viewModel.isMenuOpen.toggle()
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(
                        Theme.onSurface)
                    .font(.system(size: 27))
                    .padding(21)
                    .overlay(
                        Circle()
                            .stroke( Theme.onSurface, lineWidth: 3)
                    )
            }
            Spacer()
                .frame(width: 30)
        }
        .opacity(viewModel.isAnimating ? 0 : 1)
        .disabled(viewModel.isAnimating)
    }
}


