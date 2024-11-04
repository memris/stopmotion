//
//  DropDownMenuView.swift
//  stopmotion
//
//  Created by USER on 04.11.2024.
//

import SwiftUI

struct DropDownMenuView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State private var generateCount = 1
    
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            let generateRange = 1...(Int.max - viewModel.frames.count)
            Stepper(value: $generateCount, in: generateRange) {
                Button("Сгенерировать: \(generateCount)") {
                    viewModel.generateRandomFrames(count: generateCount, canvasSize: CGSize(width: 400, height: 450))
                    viewModel.isMenuOpen = false
                }.foregroundColor(Theme.accentColor)
            }
            Stepper(value: $viewModel.animationSpeed, in: 0.25...3.0, step: 0.25) {
                Text("Скорость: \(viewModel.animationSpeed, specifier: "%.2f")")
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
                    viewModel.isMenuOpen = false
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white).shadow(radius: 4))
        .frame(maxWidth: 350)
    }
}

extension Stepper {
    init<T: BinaryFloatingPoint>(
        value: Binding<T>,
        in range: ClosedRange<T>,
        step: T,
        label: () -> Label
    ) {
        self.init(
            onIncrement: {
                let newValue = min(value.wrappedValue + step, range.upperBound)
                if newValue <= range.upperBound {
                    value.wrappedValue = newValue
                }
            },
            onDecrement: {
                let newValue = max(value.wrappedValue - step, range.lowerBound)
                if newValue >= range.lowerBound {
                    value.wrappedValue = newValue
                }
            },
            onEditingChanged: { _ in },
            label: label
        )
    }
}
