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
    // todo private
    let device : MTLDevice = MTLCreateSystemDefaultDevice()!
    let library : MTLLibrary
    let commandQueue: MTLCommandQueue

    //    private let indexBuffer : MTLBuffer

    static let shared = GPUDevice()

    private init() {
        library = device.makeDefaultLibrary()!
        commandQueue = device.makeCommandQueue()!
        var buf: [UInt16] = (0..<2<<16).map { $0 }


        //        indexBuffer = device.makeBuffer(bytes: &buf, length: buf.count, options: [])!
    }

    func renderPipeline(for config: RenderConfig) -> MTLRenderPipelineDescriptor {
        let v = library.makeFunction(name: config.vertex)
        let f = library.makeFunction(name: config.fragment)
        let d = MTLRenderPipelineDescriptor()
        d.vertexFunction = v
        d.fragmentFunction = f
        d.colorAttachments[0].pixelFormat = config.pixelFormat

        d.colorAttachments[0].isBlendingEnabled = true
        d.colorAttachments[0].rgbBlendOperation = .add
        d.colorAttachments[0].alphaBlendOperation = .add


        // I don't believe this but this is what it is...
        //        d.colorAttachments[0].
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

    //    func makeCommandQueue() -> MTLCommandQueue {
    //        guard let queue = device.makeCommandQueue() else {
    //            fatalError("failed on mtl queue")
    //        }
    //        return queue
    //    }

    func makeBuffer<T>(for content: [T]) -> MTLBuffer {
        var cpy = content
        guard let buffer = device.makeBuffer(bytes: &cpy,
                                             length: content.count * MemoryLayout<T>.size,
                                             options: []) else { fatalError() }
        return buffer
    }
}


