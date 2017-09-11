//
//  GPUDevice.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/10/17.
//

import MetalKit

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


