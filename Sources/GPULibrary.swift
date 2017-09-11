//
//  GPULibrary.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/11/17.
//

import MetalKit

public final class GPULibrary {
    public static let shared = GPULibrary()
    internal var library : MTLLibrary

    private init() {
        library = GPUDevice.shared.device.makeDefaultLibrary()!
    }

    public func renderPipeline(vertex: String, frag : String, pixelFormat : MTLPixelFormat = .default) -> MTLRenderPipelineDescriptor {
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
