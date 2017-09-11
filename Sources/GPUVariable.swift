//
//  GPUVariable.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/10/17.
//

import MetalKit

final class GPUVariable<T> {
    private(set) var buffer : MTLBuffer

    init(value : T, options: MTLResourceOptions = []) {
        buffer = GPUDevice.shared.makeBuffer(for: value)
    }

    deinit {
        buffer.setPurgeableState(.empty)
    }

    var size : Int {
        @inline(__always)
        get {
            return MemoryLayout<T>.size
        }
    }

    var value : T {
        @inline(__always)
        get {
            return buffer.contents().assumingMemoryBound(to: T.self).pointee
        }

        @inline(__always)
        set {
            var v = newValue
            memcpy(buffer.contents(), &v, size)
        }
    }
}

extension MTLComputeCommandEncoder {
    func setVariable<T>(_ variable : GPUVariable<T>, index : Int) {
        setBuffer(variable.buffer, offset : 0, index: index)
    }
}

extension MTLRenderCommandEncoder {
    func setVariable<T>(_ variable : GPUVariable<T>, index : Int) {
        setVertexBuffer(variable.buffer, offset : 0, index: index)
    }
}
