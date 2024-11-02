//
//  Frame.swift
//  stopmotion
//
//  Created by USER on 01.11.2024.
//

import SwiftUI

struct Frame: Identifiable {
    let id = UUID()
    var lines: [Line] = []
    // var miniature: Image
    
    func miniature(size: CGSize, canvasSize: CGSize) -> Image {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image {context in
            
            let scaleX = size.width / canvasSize.width
            let scaleY = size.height / canvasSize.height
            let scale = min(scaleX, scaleY)
            
            context.cgContext.scaleBy(x: scale, y: scale)
            
            for line in lines {
                context.cgContext.setStrokeColor(UIColor(line.color).cgColor)
                //context.cgContext.setLineWidth(line.lineWidth)
                context.cgContext.setLineWidth(line.lineWidth / scale / 2)
                context.cgContext.setLineCap(.round)
                
                guard let firstPoint = line.points.first else {continue}
                
                context.cgContext.move(to: firstPoint)
                for point in line.points.dropFirst() {
                    context.cgContext.addLine(to: point)
                }
                context.cgContext.strokePath()
            }
        }
        return Image(uiImage: image)
    }
}
