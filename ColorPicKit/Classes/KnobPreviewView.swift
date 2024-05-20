//
//  KnowPreviewView.swift
//  ColorPicKitExample
//
//  Created by DREAMWORLD on 16/05/24.
//  Copyright © 2024 Zakk Hoyt. All rights reserved.
//

import Foundation
import UIKit

//class CircleView: UIView {
//
//    @IBInspectable var fillColor: UIColor = UIColor.blue {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//
//    @IBInspectable var borderWidth: CGFloat = 5.0 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor = UIColor.white {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//
//    override func draw(_ rect: CGRect) {
//        let path = UIBezierPath(ovalIn: rect)
//        borderColor.setStroke()
//        path.lineWidth = borderWidth
//        path.stroke()
//
//        fillColor.setFill()
//        path.fill()
//    }
//}

class CircleView: UIView {
    
    // Color property with a default value
    var color: UIColor = .blue {
        didSet {
            setNeedsDisplay()
        }
    }

    // Initialize with frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Initialize with coder (required for storyboard/xib)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // Common setup code
    private func setup() {
        // Add any setup code here
        self.backgroundColor = .clear
    }

    // Custom drawing code
    override func draw(_ rect: CGRect) {
        // Get the current context
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Clear the context
        context.clear(rect)

        // Set the fill color
        context.setFillColor(color.cgColor)

        // Adjust the radius to fit the view bounds with the pin tail
        let radius = min(rect.width, rect.height) / 2 - 10

        // Draw a filled circle centered horizontally and slightly adjusted vertically to fit the tail
        let center = CGPoint(x: rect.midX, y: rect.midY - radius / 3)
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.fillPath()

        // Optionally, draw an outline around the circle
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(3.8)
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.strokePath()

        // Draw the pin tail
        context.setFillColor(UIColor.white.cgColor)
        let tailPath = UIBezierPath()
        tailPath.move(to: CGPoint(x: rect.midX - 8, y: center.y + radius))
        tailPath.addLine(to: CGPoint(x: rect.midX + 8, y: center.y + radius))
        tailPath.addLine(to: CGPoint(x: rect.midX, y: center.y + radius + 10))  // Adjusted length of tail
        tailPath.close()
        context.addPath(tailPath.cgPath)
        context.fillPath()
    }
}

