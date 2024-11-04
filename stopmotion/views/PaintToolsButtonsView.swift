//
//  PaintToolsButtonsView.swift
//  stopmotion
//
//  Created by USER on 01.11.2024.
//

import SwiftUI

struct PaintToolsButtonsView: View {
    @ObservedObject var viewModel: CanvasViewModel
    // @State private var isMenuOpen = false
    @State private var selectedOption = ""
    
    var body: some View {
        HStack(spacing:20){
            ColorPicker("", selection: $viewModel.selectedColor)
                .labelsHidden()
            Button{
                viewModel.selectionModeIndex = 0
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(viewModel.selectionModeIndex == 0 ? Theme.accentColor : .black)
                    .font(.system(size: 30))
                    .padding(9)
                    .overlay(
                        Circle()
                            .stroke(viewModel.selectionModeIndex == 0 ? Theme.accentColor : .black, lineWidth: 3)
                    )
            }
            Button{
                viewModel.selectionModeIndex = 1
            } label: {
                Image(systemName: "eraser")
                    .foregroundColor(viewModel.selectionModeIndex == 1 ? Theme.accentColor : .black)
                    .font(.system(size: 27))
                    .padding(9)
                    .overlay(
                        Circle()
                            .stroke(viewModel.selectionModeIndex == 1 ? Theme.accentColor : .black, lineWidth: 3)
                    )
            }
            
            Button{
                withAnimation {
                    viewModel.isMenuOpen.toggle()
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(
                        .black)
                    .font(.system(size: 27))
                    .padding(21)
                    .overlay(
                        Circle()
                            .stroke( .black, lineWidth: 3)
                    )
            }
            //            .overlay(
            //            DropDownMenuView(viewModel: viewModel)
            //            )
            //            Button{
            //                // TODO: добавлять фигуры
            //            } label: {
            //                Image(systemName: "triangle")
            //                    .foregroundColor(viewModel.selectionModeIndex == 1 ? Theme.accentColor : .black)
            //                    .font(.system(size: 27))
            //                    .padding(9)
            //                    .overlay(
            //                        Circle()
            //                            .stroke(viewModel.selectionModeIndex == 1 ? Theme.accentColor : .black, lineWidth: 3)
            //                    )
            //            }
        }
        .opacity(viewModel.isAnimating ? 0 : 1)
        .disabled(viewModel.isAnimating)
    }
}


