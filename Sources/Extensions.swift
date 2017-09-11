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


extension MTLVertexFormat {
    init<T>(type : T.Type) {
        switch T.self {
        case is Float.Type : self = .float
        case is simd_float2.Type: self = .float2
        case is simd_float3.Type: self = .float3
        case is simd_float4.Type: self = .float4

        default:
            fatalError()
        }
    }
}

extension MTLVertexDescriptor {

}


