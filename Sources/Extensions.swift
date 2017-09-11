//
//  Extensions.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/11/17.
//

import MetalKit

extension MTLTexture {
    var size : MTLSize {
        return .init(width: width, height: height, depth: depth)
    }
}

extension MTLPixelFormat {
    static let `default` : MTLPixelFormat = .bgra8Unorm
}

extension MTLViewport {
    var destX : Double {
        return originX + width
    }

    var destY : Double {
        return originY + height
    }
}

extension MemoryLayout {
    static func size(of type : T.Type) -> Int {
        return size
    }
}

extension Mirror {

}

extension MTLVertexFormat {
    init(type : Any.Type) {
        switch type {
        default:
            fatalError()
        }
    }
}

extension MTLVertexDescriptor {

}
