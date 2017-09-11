//
//  GPUDevice.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/10/17.
//

import MetalKit



final class GPULibrary {
    static let shared = GPULibrary()
    fileprivate var library : MTLLibrary

    private init() {
        library = GPUDevice.shared.device.makeDefaultLibrary()!
    }

    func renderPipeline(vertex: String, frag : String, pixelFormat : MTLPixelFormat = .default) -> MTLRenderPipelineDescriptor {
        let v = library.makeFunction(name: vertex)
        let f = library.makeFunction(name: frag)
        let d = MTLRenderPipelineDescriptor()
        d.vertexFunction = v
        d.fragmentFunction = f
        d.colorAttachments[0].pixelFormat = pixelFormat

        d.colorAttachments[0].isBlendingEnabled = true
        d.colorAttachments[0].rgbBlendOperation = .add
        d.colorAttachments[0].alphaBlendOperation = .add

        d.colorAttachments[0].sourceRGBBlendFactor = .one
        d.colorAttachments[0].sourceAlphaBlendFactor = .one
        d.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        d.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha

        return d
    }
}

final class GPUDevice {

    let device : MTLDevice = MTLCreateSystemDefaultDevice()!

    let commandQueue: MTLCommandQueue

    static let shared = GPUDevice()

    private init() {
        commandQueue = device.makeCommandQueue()!
    }

    func makeCommandBuffer() -> MTLCommandBuffer {
        return commandQueue.makeCommandBuffer()!
    }

    func computePipeline(name : String) -> MTLComputePipelineState {
        let f = GPULibrary.shared.library.makeFunction(name: name)!
        return try! device.makeComputePipelineState(function: f)
    }

    func makeBuffer<T>(for content: [T]) -> MTLBuffer {
        let length = content.count * MemoryLayout<T>.size
        var cpy = content
        guard let buffer = device.makeBuffer(bytes: &cpy,
                                             length: length,
                                             options: []) else { fatalError() }
        return buffer
    }

    func makeBuffer<T>(for value : T) -> MTLBuffer {
        let length = MemoryLayout<T>.size
        var cpy = value
        guard let buffer = device.makeBuffer(bytes: &cpy,
                                             length: length,
                                             options: []) else { fatalError() }
        return buffer
    }
}


