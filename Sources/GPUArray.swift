//
//  GPUArray.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/11/17.
//

import MetalKit

extension UnsafeMutablePointer {
    @inline(__always)
    init(mtlBuffer : MTLBuffer) {
        self.init(OpaquePointer(mtlBuffer.contents()))
    }
}

extension UnsafeMutableBufferPointer {
    @inline(__always)
    init(mtlBuffer : MTLBuffer) {
        let count = mtlBuffer.length / MemoryLayout<Element>.size

        self.init(start: .init(mtlBuffer : mtlBuffer), count: count)

    }
}

struct MetalStorage<Element> : MutableCollection {
    typealias Index = Int

    private var content : MTLBuffer

    private(set) var count : Int

    init(capacity : Int) {
        count = 0
        fatalError()
    }


    var capacity : Int {
        return content.length / MemoryLayout<Element>.size
    }

    //private let content : [Element]

    var startIndex : Index {
        fatalError()
    }

    var endIndex : Index {
        fatalError()
    }

    private var ptr : UnsafeMutableBufferPointer<Element> {
        @inline(__always)
        get {
            return .init(mtlBuffer: content)
        }
    }

    subscript(index: Index) -> Element {
        get {
            return ptr[index]
        }
        set {
            ptr[index] = newValue
        }
    }

    func index(after i: Index) -> Index {
        return i + 1
    }
}

public final class GPUArray<Element> : RangeReplaceableCollection, RandomAccessCollection {
    public typealias Index = Int
    private var content : MetalStorage<Element>

    public init() {
        fatalError()
    }

    //private let content : [Element]

    public var startIndex : Index {
        return 0
    }

    public var count : IndexDistance {
        return content.count
    }

    public var endIndex : Index {
        return content.endIndex
    }

    public subscript(index: Index) -> Element {
        //return content[index]
        fatalError()
    }

    public func index(after i: Index) -> Index {
        return i + 1
    }

    public func index(before i: Index) -> Index {
        return i - 1
    }

    public func replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        fatalError()
    }
}



