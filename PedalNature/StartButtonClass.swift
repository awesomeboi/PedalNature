//
//  StartButtonClass.swift
//  PedalNature
//
//  Created by Volkan Sahin on 10.07.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import UIKit

class StartButtonClass: UIButton {
    
        @IBInspectable var fillColor: UIColor = .green
        @IBInspectable var isAddButton: Bool = true
        
        private struct Constants {
            static let plusLineWidth: CGFloat = 3.0
            static let plusButtonScale: CGFloat = 0.6
            static let halfPointShift: CGFloat = 0.5
        }
        
        private var halfWidth: CGFloat {
            return bounds.width / 2
        }
        
        private var halfHeight: CGFloat {
            return bounds.height / 2
        }
        
        override func draw(_ rect: CGRect) {
            
            let arcStep = 2 * CGFloat.pi / 360
            let isClockwise = false
            let x = rect.width / 2
            let y = rect.height / 2
            let radius = (min(x, y) / 2) - 1
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.setLineWidth(2 * radius)
            
            for i in 0..<360 {
                let color = UIColor(red: 38.0/255.0, green : 83.0/255.0, blue: 120.0/255.0, alpha: 1)
                let startAngle = CGFloat(i) * arcStep
                let endAngle = startAngle + arcStep + 0.02
                
                ctx?.setStrokeColor(color.cgColor)
                ctx?.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: isClockwise)
                ctx?.strokePath()
            }
            
            let gradient = CGGradient(colorsSpace: UIColor.blue.cgColor.colorSpace,
                                      colors: [
                                        UIColor.white.cgColor,
                                        UIColor.white.withAlphaComponent(0).cgColor,
                                        ] as CFArray,
                                      locations: [
                                        0,
                                        1,
                ]
            )
            ctx?.drawRadialGradient(gradient!, startCenter: CGPoint(x: x, y: y), startRadius: 1.5 * radius, endCenter: CGPoint(x: x, y: y), endRadius: 2 * radius, options: .drawsAfterEndLocation)
            
            //set up the width and height variables
            //for the horizontal stroke
            let plusWidth = min(bounds.width, bounds.height)
                * Constants.plusButtonScale
            let halfPlusWidth = plusWidth / 2
            
            //create the path
            let plusPath = UIBezierPath()
            
            //set the path's line width to the height of the stroke
            plusPath.lineWidth = Constants.plusLineWidth
            
            //move the initial point of the path
            //to the start of the horizontal stroke
            plusPath.move(to: CGPoint(
                x: halfWidth - halfPlusWidth + Constants.halfPointShift,
                y: halfHeight + Constants.halfPointShift))
            
            //add a point to the path at the end of the stroke
            plusPath.addLine(to: CGPoint(
                x: halfWidth + halfPlusWidth + Constants.halfPointShift,
                y: halfHeight + Constants.halfPointShift))
            
            //Vertical Line
            
            plusPath.move(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight - halfPlusWidth + Constants.halfPointShift))
            
            plusPath.addLine(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight + halfPlusWidth + Constants.halfPointShift))
            
            //set the stroke color
            UIColor(red: 217.0/255.0, green : 196.0/255.0, blue: 147.0/255.0, alpha: 1).setStroke()
            //draw the stroke
            plusPath.stroke()
            
            
        }
    }
