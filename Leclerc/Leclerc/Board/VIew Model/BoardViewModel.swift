//
//  BoardViewController.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import Foundation
import SwiftUI

class BoardViewModel: ObservableObject {
    let renderables: [AnyRenderable]
    @Published var greatestZ: Double = 1.0
    @Published var board: Board
    
    init(renderables: [AnyRenderable] = [], board: Board = .init(elements: [])) {
        self.renderables = renderables
        self.board = board
    }
    
    func printBoardElements() {
        print((board.elements.first?.content as! TextInput as TextInput).text)
    }
    
    func render() -> [AnyView] {
        return board.elements.map { element in
            let renderable = renderables.first { $0.type == element.type }
            guard renderable != nil else {
                return AnyView(EmptyView())
            }
            return renderElement(element: element, renderable: renderable!)
        }
    }
    
    func renderElement(element: Element, renderable: AnyRenderable) -> AnyView {
        guard element.type == renderable.type else {
            return AnyView(EmptyView())
        }
        
        if greatestZ < element.position.z {
            greatestZ = element.position.z
        } else if greatestZ == element.position.z{
            greatestZ += 1
        }
        
        return AnyView(
            renderable.render(element.content)
                .scaleEffect(1 * element.transform.scale, anchor: .center)
                .rotationEffect(.init(degrees: element.transform.rotation))
                .position(x: element.position.x, y: element.position.y)
                .zIndex(element.position.z)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            guard renderable.draggable else {
                                return
                            }
                            self.handleElementDrag(element: element, position: value.location)
                        }
                )
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { scale in
                            guard renderable.resizable else {
                                return
                            }
                            self.handleElementPinch(element: element, scale: scale)
                        }
                        .onEnded { scale in
                            guard let index = self.board.elements.firstIndex(where: { $0.id == element.id }) else {
                                return
                            }
                            self.board.elements[index].transform.lastScale = scale
                        }
                )
                .simultaneousGesture(
                    RotationGesture()
                        .onChanged { value in
                            guard renderable.rotatable else {
                                return
                            }
                            self.handleElementRotation(element: element, angle: value)
                        }
                        .onEnded { value in
                            guard let index = self.board.elements.firstIndex(where: { $0.id == element.id }) else {
                                return
                            }
                            self.board.elements[index].transform.lastRotation = self.board.elements[index].transform.rotation
                        }
                )
                .onLongPressGesture(minimumDuration: .infinity) {
                      
                } onPressingChanged: { starting in
                    if starting {
                        guard let index = self.board.elements.firstIndex(where: { $0.id == element.id }) else {
                            return
                        }
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                            self.board.elements[index].tapping = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
                            do {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                                    self.board.elements[index].tapping = false
                                }
                            }
                        }
                    }
                }
                .scaleEffect(element.tapping ? 0.97 : 1.0)
            )
    }
    
    func handleElementPinch(element: Element, scale: CGFloat) {
        guard let index = board.elements.firstIndex(where: { $0.id == element.id }) else {
            return
        }

        withAnimation {
            board.elements[index].transform.scale = scale + board.elements[index].transform.lastScale
        }
    }
    
    func handleElementDrag(element: Element, position: CGPoint) {
        guard let index = board.elements.firstIndex(where: { $0.id == element.id }) else {
            return
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
            board.elements[index].position.x = position.x
            board.elements[index].position.y = position.y
            board.elements[index].position.z = greatestZ
        }
    }
    
    private func handleElementRotation(element: Element, angle: Angle) {
        guard let index = board.elements.firstIndex(where: { $0.id == element.id }) else {
            return
        }

        board.elements[index].transform.rotation = board.elements[index].transform.lastRotation + angle.degrees
        
    }
    
    public func addElement(type: String, content: Any) {
        let element = Element(
            position: .init(x: 150, y: 150, z: greatestZ + 1),
            transform: .init(rotation: 0),
            content: content,
            type: type
        )
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
            board.elements.append(element)
        }
    }
}

class TextInput: ObservableObject {
    @Published var text: String

    init(text: String) {
        self.text = text
    }
}

struct TextRenderable: Renderable {
    typealias T = TextInput
    
    var type: String = "Text"
    var resizable: Bool = true
    var draggable: Bool = true
    var rotatable: Bool = true
    
    func render(_ input: TextInput) -> AnyView {
        return AnyView(
            TextView(text: Binding<String>(
                get: { input.text },
                set: { newValue in input.text = newValue }
            ))
        )
    }
}

enum Sticker {
    case coke;
    case person;
    case coffee;
}

class SticketInput: ObservableObject {
    @Published var identifier: Sticker
    
    init(identifier: Sticker) {
        self.identifier = identifier
    }
}

struct StickerRenderable: Renderable {
    typealias T = SticketInput
    
    var type: String = "Sticker"
    var resizable: Bool = true
    var draggable: Bool = true
    var rotatable: Bool = true
    
    func render(_ input: SticketInput) -> AnyView {
        return AnyView(
            StickerView(identifier: Binding<Sticker>(
                get: { input.identifier },
                set: { newValue in input.identifier = newValue }
            ))
        )
    }
}

class ImageInput: ObservableObject {
    @Published var url: String
    
    init(url: String) {
        self.url = url
    }
}

struct ImageRenderable: Renderable {
    typealias T = ImageInput
    
    var type: String = "Image"
    var resizable: Bool = true
    var draggable: Bool = true
    var rotatable: Bool = true
    
    func render(_ input: ImageInput) -> AnyView {
        return AnyView(
            ImageView(url: Binding<String>(
                get: { input.url },
                set: { newValue in input.url = newValue }
            ))
        )
    }
}

let renderables: [AnyRenderable] = [
    AnyRenderable(TextRenderable.init()),
    AnyRenderable(StickerRenderable.init()),
    AnyRenderable(ImageRenderable.init())
]

let sampleViewModel = BoardViewModel(renderables: renderables, board: .init(elements: []))
