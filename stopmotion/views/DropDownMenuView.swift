//
//  DropDownMenuView.swift
//  stopmotion
//
//  Created by USER on 04.11.2024.
//

import SwiftUI


struct DropDownMenuView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var generateCount = 1
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            let generateRange = 1...(Int.max - viewModel.frames.count)
            Stepper(value: $generateCount, in: generateRange) {
                Button("Сгенерировать: \(generateCount)") {
                    viewModel.generateRandomFrames(count: generateCount, canvasSize: CGSize(width: 400, height: 450))
                    withAnimation {
                        viewModel.isMenuOpen = false
                    }
                }
                .foregroundColor(Theme.onSurface)
            }
            Stepper(value: $viewModel.animationSpeed, in: 0.25...3.0, step: 0.25) {
                Text("Скорость: \(viewModel.animationSpeed, specifier: "%.2f")")
                    .foregroundColor(Theme.onSurface)
            }
            Button {
                isShowingAlert = true
            } label: {
                HStack {
                    Text("Удалить все кадры")
                        .foregroundColor(.red)
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .font(.headline)
            }
            .alert("Вы уверены, что хотите удалить все кадры?", isPresented: $isShowingAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Удалить", role: .destructive) {
                    viewModel.frames.removeAll()
                    viewModel.frames = [Frame()]
                    withAnimation {
                        viewModel.isMenuOpen = false
                    }
                }
            }
            Button {
                withAnimation {
                    isDarkMode.toggle()
                }
            } label: {
                Text("Изменить тему")
                    .foregroundColor(Theme.accentColor)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8)
            .fill(Theme.backgroundColor)
            .shadow(radius: 4))
        .frame(maxWidth: 350)
        .onChange(of: isDarkMode) {
            viewModel.objectWillChange.send()
        }
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
}
