//
//  Extensions.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/11/17.
//

import MetalKit
import Darwin

extension MTLTexture {
    internal var size : MTLSize {
        return .init(width: width, height: height, depth: depth)
    }
}

extension MTLPixelFormat {
    public static let `default` : MTLPixelFormat = .bgra8Unorm
}

extension MTLViewport {
    var destX : Double {
        return originX + width
    }

    var destY : Double {
        return originY + height
    }
}

extension MTLVertexFormat {

    internal var size : Int {
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


    internal init(type t : Any.Type) {
        switch t {
//        case is simd_char1.Type : self = .char
//        case is simd_uchar1.Type : self = .uchar

        case is simd_int1.Type : self = .int
        case is simd_int2.Type : self = .int2
        case is simd_int3.Type : self = .int3
        case is simd_int4.Type : self = .int4

        case is simd_uint1.Type : self = .uint
        case is simd_uint2.Type : self = .uint2
        case is simd_uint3.Type : self = .uint3
        case is simd_uint4.Type : self = .uint4

        case is simd_float1.Type : self = .float
        case is simd_float2.Type: self = .float2
        case is simd_float3.Type: self = .float3
        case is simd_float4.Type: self = .float4

        default: fatalError("cannot construct a vertex format for type \(t)")
        }
    }
}

extension MTLVertexDescriptor {
    internal convenience init<S: Sequence>(seq : S) where S.Iterator.Element == MTLVertexFormat {
        self.init()
        var total = 0

        for (i,e) in seq.enumerated() {
            attributes[i].offset = total
            attributes[i].format = e
            attributes[i].bufferIndex = 0
            total += e.size
        }

        layouts[0].stepFunction = .perVertex
        layouts[0].stride = total
    }

    public convenience init<T>(reflecting : T) {
        let m = Mirror(reflecting : reflecting).children
        self.init(seq : m.map { MTLVertexFormat(type: type(of: $0.value) ) } )

    }
}

