//
//  Renderable.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import Foundation
import SwiftUI

protocol Renderable {
    associatedtype T
    var type: String { get }
    var resizable: Bool { get }
    var rotatable: Bool { get }
    var draggable: Bool { get }
    func render(_ input: T) -> AnyView
}

struct AnyRenderable: Renderable {
    var type: String
    var resizable: Bool
    var rotatable: Bool
    var draggable: Bool
    
    private let _render: (Any) -> AnyView

    init<R: Renderable>(_ renderable: R) {
        self.type = renderable.type
        self.resizable = renderable.resizable
        self.rotatable = renderable.rotatable
        self.draggable = renderable.draggable
        self._render = { any in
            guard let model = any as? R.T else {
                fatalError("Unexpected type \(Swift.type(of: any)). Expected \(R.T.self)")
            }
            return renderable.render(model)
        }
    }

    func render(_ model: Any) -> AnyView {
        return _render(model)
    }
}
