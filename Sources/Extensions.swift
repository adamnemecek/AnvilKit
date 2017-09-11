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
