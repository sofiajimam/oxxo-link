//
//  Element.swift
//  LeclercCore
//
//  Created by Sofía Jimémez Martínez on 24/04/24.
//

import Foundation

public struct Element {
    var id: String
    var description: String
    var type: String
    var position: Position
}

struct Position {
    var x: Int
    var y: Int
    var z: Int
}
