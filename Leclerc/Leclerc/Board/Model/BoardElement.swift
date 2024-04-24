//
//  Element.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import Foundation

struct BoardElement: Identifiable {
    let id: UUID
    var type: String
    var position: ScreenPosition
    var transform: Transform
    var content: Any
    var tapping: Bool
    
    init(id: UUID = UUID(), position: ScreenPosition, transform: Transform, content: Any, type: String) {
        self.id = id
        self.position = position
        self.transform = transform
        self.content = content
        self.type = type
        self.tapping = false
    }
}
