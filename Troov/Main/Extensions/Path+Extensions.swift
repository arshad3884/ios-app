//
//  Path+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 30.08.23.
//

import SwiftUI

extension Path {
    
    /// This draws a curved path from a path of points given.
    /// Modified from https://stackoverflow.com/q/13719143/515455
    mutating func quadCurvedPath(from data: [CGPoint]) {
        var prevousPoint: CGPoint = data.first!
        
        self.move(to: prevousPoint)
        
        if (data.count == 2) {
            self.addLine(to: data[1])
            return
        }
        
        var oldControlPoint: CGPoint?
        
        for i in 1..<data.count {
            let currentPoint = data[i]
            var nextPoint: CGPoint?
            if i < data.count - 1 {
                nextPoint = data[i + 1]
            }
            
            let newControlPoint = controlPointForPoints(p1: prevousPoint, p2: currentPoint, next: nextPoint)
            
            self.addCurve(to: currentPoint, control1: oldControlPoint ?? prevousPoint, control2: newControlPoint ?? currentPoint)
            
            prevousPoint = currentPoint
            oldControlPoint = antipodalFor(point: newControlPoint, center: currentPoint)
        }
    }
    
    /// Located on the opposite side from the center point
    func antipodalFor(point: CGPoint?, center: CGPoint?) -> CGPoint? {
        guard let p1 = point, let center = center else {
            return nil
        }
        let newX = 2.0 * center.x - p1.x
        let newY = 2.0 * center.y - p1.y
        
        return CGPoint(x: newX, y: newY)
    }
    
    /// Find the mid point of two points
    func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2);
    }
    
    /// Find control point
    /// - Parameters:
    ///   - p1: first point of curve
    ///   - p2: second point of curve whose control point we are looking for
    ///   - next: predicted next point which will use antipodal control point for finded
    func controlPointForPoints(p1: CGPoint, p2: CGPoint, next p3: CGPoint?) -> CGPoint? {
        guard let p3 = p3 else {
            return nil
        }
        
        let leftMidPoint  = midPointForPoints(p1: p1, p2: p2)
        let rightMidPoint = midPointForPoints(p1: p2, p2: p3)
        
        var controlPoint = midPointForPoints(p1: leftMidPoint, p2: antipodalFor(point: rightMidPoint, center: p2)!)
        
        if p1.y.between(a: p2.y, b: controlPoint.y) {
            controlPoint.y = p1.y
        } else if p2.y.between(a: p1.y, b: controlPoint.y) {
            controlPoint.y = p2.y
        }
        
        let imaginContol = antipodalFor(point: controlPoint, center: p2)!
        if p2.y.between(a: p3.y, b: imaginContol.y) {
            controlPoint.y = p2.y
        }
        if p3.y.between(a: p2.y, b: imaginContol.y) {
            let diffY = abs(p2.y - p3.y)
            controlPoint.y = p2.y + diffY * (p3.y < p2.y ? 1 : -1)
        }
        
        // make lines easier
        controlPoint.x += (p2.x - p1.x) * 0.1
        
        return controlPoint
    }
}

