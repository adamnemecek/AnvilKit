//
//  Extensions.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/11/17.
//

import MetalKit
import Darwin

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

    var size : Int {
        switch self {
        /// 8-bit types
        case .uchar, .char, .charNormalized, .ucharNormalized:
            return 1
        case .uchar2, .char2, .char2Normalized, .uchar2Normalized:
            return 2
        case .uchar3, .char3, .char3Normalized, .uchar3Normalized:
            return 3
        case .uchar4, .char4, .char4Normalized, .uchar4Normalized:
            return 4

        /// 16-bit types
        case .short, .ushort, .shortNormalized, .ushortNormalized, .half:
            return 2
        case .short2, .ushort2, .short2Normalized, .ushort2Normalized, .half2:
            return 4
        case .short3, .ushort3, .short3Normalized, .ushort3Normalized, .half3:
            return 6
        case .short4, .ushort4, .short4Normalized, .ushort4Normalized, .half4:
            return 8

        /// 32-bit types
        case .int, .uint, .float, .int1010102Normalized, .uint1010102Normalized, .uchar4Normalized_bgra:
            return 4
        case .int2, .uint2, .float2:
            return 8
        case .int3, .uint3, .float3:
            return 12
        case .int4, .uint4, .float4:
            return 16

        case .invalid:
            fatalError()
        }
    }


    init<T>(type : T.Type) {

        switch T.self {
        case is Float.Type : self = .float
        case is simd_float2.Type: self = .float2
        case is simd_float3.Type: self = .float3
        case is simd_float4.Type: self = .float4

        case is Int32.Type : self = .int
        case is simd_int2.Type: self = .int2
        case is simd_int3.Type: self = .int3
        case is simd_int4.Type: self = .int4

        



        default:
            fatalError()
        }


    }
}


