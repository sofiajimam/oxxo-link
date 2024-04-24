//
//  Board.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import Foundation

struct Board: Identifiable {
    let id: UUID
    var elements: [BoardElement]
    
    init(id: UUID = UUID(), elements: [BoardElement]) {
        self.id = id
        self.elements = elements
    }
}
