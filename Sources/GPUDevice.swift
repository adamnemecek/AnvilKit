//
//  GPUDevice.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/10/17.
//

import Cocoa
import MetalKit


struct RenderConfig {
    let vertex, fragment : String
    let pixelFormat : MTLPixelFormat
}

final class GPUDevice {

    let device : MTLDevice = MTLCreateSystemDefaultDevice()!
    let library : MTLLibrary
    let commandQueue: MTLCommandQueue

    static let shared = GPUDevice()

    private init() {
        library = device.makeDefaultLibrary()!
        commandQueue = device.makeCommandQueue()!
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

    func computePipeline(name : String) -> MTLComputePipelineState {
        let f = library.makeFunction(name: name)!
        return try! device.makeComputePipelineState(function: f)
    }

    func makeBuffer<T>(for content: [T]) -> MTLBuffer {
        var cpy = content
        guard let buffer = device.makeBuffer(bytes: &cpy,
                                             length: content.count * MemoryLayout<T>.size,
                                             options: []) else { fatalError() }
        return buffer
    }
}


