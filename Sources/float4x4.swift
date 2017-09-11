//
//  float4x4.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/10/17.
//

import simd

import MetalKit
import GLKit

extension simd_float4 : CustomStringConvertible {
    public var description : String {
        return .init(format: "%.3f, %.3f, %.3f, %.3f", x,y,z,w)
    }
}

extension GLKMatrix4 {
    @inline(__always) internal
    init(ortho : CGRect, zoom : Range<CGFloat>) {

        self = GLKMatrix4MakeOrtho(Float(ortho.minX),
                                   Float(ortho.maxX),
                                   Float(ortho.minY),
                                   Float(ortho.maxY),
                                   Float(zoom.lowerBound),
                                   Float(zoom.upperBound))
    }



    @inline(__always) internal
    init(viewport : MTLViewport) {
        self = GLKMatrix4MakeFrustum(Float(viewport.originX),
                                     Float(viewport.destX),
                                     Float(viewport.originY),
                                     Float(viewport.destY),
                                     Float(viewport.znear),
                                     Float(viewport.zfar))
    }
}

extension simd_float3x3 {
    static let identity : simd_float3x3 = matrix_identity_float3x3
}

extension simd_float4x4 : CustomStringConvertible {
    static let identity : simd_float4x4 = matrix_identity_float4x4

    @inline(__always)
    init(eye: float3, center: float3, up: float3) {
        self.init(GLKMatrix4MakeLookAt(eye.x, eye.y, eye.z,
                                       center.x, center.y, center.z,
                                       up.x, up.y, up.z))
    }

    @inline(__always)
    init(x : float2, y: float2, zoom : float2) {
        self.init(GLKMatrix4MakeOrtho(x.x, x.y, y.x, y.y, zoom.x, zoom.y))
    }


    @inline(__always)
    init(scale s: Float) {
        self.init(scale : float3(s))
    }

    public var description : String {
        return "\(columns.0)\n\(columns.1)\n\(columns.2)\n\(columns.3)\n"
    }

    public init(ortho : CGRect, zoom : Range<CGFloat>) {
        self.init(GLKMatrix4(ortho: ortho, zoom : zoom))
    }

    @inline(__always)
    init(_ matrix : GLKMatrix4) {
        assert(MemoryLayout<GLKMatrix4>.size == MemoryLayout<simd_float4x4>.size)
        self = unsafeBitCast(matrix, to: simd_float4x4.self)
    }

    @inline(__always)
    public init(scale s : float3) {
        let x : float4 = [s.x, 0, 0, 0]
        let y : float4 = [0, s.y, 0, 0]
        let z : float4 = [0, 0, s.z, 0]
        let w : float4 = [0, 0, 0, 1]

        self.init(columns: (x,y,z,w))
    }

    @inline(__always)
    public init(translation t: float3) {
        let x : float4 = [1, 0, 0, 0]
        let y : float4 = [0, 1, 0, 0]
        let z : float4 = [0, 0, 1, 0]
        let w : float4 = [t.x,t.y,t.z,1]
        self.init(columns: (x,y,z,w))
    }

    @inline(__always)
    public init(aspect:Float, fovy:Float, near:Float, far:Float) {
        let yScale:Float = 1 / tan(fovy * 0.5)
        let xScale:Float = yScale / aspect
        let zRange:Float = far - near
        let zScale:Float = -(far + near) / zRange
        let wzScale:Float = -2 * far * near / zRange

        let P: float4 = [xScale,0,0,0]
        let Q: float4 = [0,yScale,0,0]
        let R: float4 = [0,0,zScale, -1]
        let S: float4 = [0,0,wzScale,0]
        self.init(columns: (P,Q,R,S))
    }

    @inline(__always)
    init(rotate axis: float3, angle:Float)  {

        let c: Float = cos(angle)
        let s: Float = sin(angle)

        let x: float4 = .init(axis.x * axis.x + (1 - axis.x * axis.x) * c,
                              axis.x * axis.y * (1 - c) - axis.z * s,
                              axis.x * axis.z * (1 - c) + axis.y * s,
                              0)

        let y: float4 = .init(axis.x * axis.y * (1 - c) + axis.z * s,
                              axis.y * axis.y + (1 - axis.y * axis.y) * c,
                              axis.y * axis.z * (1 - c) - axis.x * s,
                              0)

        let z: float4 = .init(axis.x * axis.z * (1 - c) - axis.y * s,
                              axis.y * axis.z * (1 - c) + axis.x * s,
                              axis.z * axis.z + (1 - axis.z * axis.z) * c,
                              0)

        let w: float4 = .init(0,0,0,1)

        self.init(columns: (x,y,z,w))
    }
}

