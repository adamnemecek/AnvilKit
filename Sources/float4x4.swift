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
    init(ortho : CGRect, zoom : Range<CGFloat>) {
        assert(MemoryLayout<GLKMatrix4>.size == MemoryLayout<simd_float4x4>.size)
        self = GLKMatrix4MakeOrtho(Float(ortho.minX),
                                   Float(ortho.maxX),
                                   Float(ortho.minY),
                                   Float(ortho.maxY),
                                   Float(zoom.lowerBound),
                                   Float(zoom.upperBound))
    }
}

extension simd_float4x4 : CustomStringConvertible {
    static let identity : simd_float4x4 = matrix_identity_float4x4

    @inline(__always)
    init(look position: float3, center: float3, up: float3) {

        let z = normalize(position - center)
        let x = normalize(cross(up, z))
        let y = cross(z, x)
        let t = vector3(-dot(x, position),
                        -dot(y, position),
                        -dot(z, position))

        self = .init(vector4(x.x, y.x, z.x, 0.0),
                     vector4(x.y, y.y, z.y, 0.0),
                     vector4(x.z, y.z, z.z, 0.0),
                     vector4(t, 1.0))
    }

    @inline(__always)
    init(scale s: Float) {
        self.init(scale : float3(s))
    }

    public var description : String {
        return "\(columns.0)\n\(columns.1)\n\(columns.2)\n\(columns.3)\n"
    }

    public init(ortho : CGRect, zoom : Range<CGFloat>) {
        self = unsafeBitCast(GLKMatrix4(ortho: ortho, zoom : zoom), to: simd_float4x4.self)
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

