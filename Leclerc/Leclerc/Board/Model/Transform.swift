//
//  Transform.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import Foundation

struct Transform {
    var rotation: Double
    var lastRotation: Double
    
    var scale: Double
    var lastScale: Double
    
    init(rotation: Double = 1.0, scale: Double = 1.0) {
        self.rotation = rotation
        self.lastRotation = rotation
        self.scale = scale
        self.lastScale = scale
    }
}
