//
//  Board.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import Foundation

struct Board: Identifiable {
    let id: UUID
    var elements: [Element]
    
    init(id: UUID = UUID(), elements: [Element]) {
        self.id = id
        self.elements = elements
    }
}
