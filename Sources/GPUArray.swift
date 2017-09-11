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

struct MetalBuffer<Element> : MutableCollection {
    typealias Index = Int

    private var content : MTLBuffer

//    private(set) var count : Int

    init(capacity : IndexDistance) {
        /// page align
        let length = MemoryLayout<Element>.size * capacity
        content = GPUDevice.shared.device.makeBuffer(length: length, options: [])!
    }

    // note that this is really capacity
    var count : IndexDistance {
        return content.length / MemoryLayout<Element>.size
    }

    //private let content : [Element]

    var startIndex : Index {
        return 0
    }

    var endIndex : Index {
        return count
    }

    fileprivate var ptr : UnsafeMutableBufferPointer<Element> {
        @inline(__always)
        get {
            return .init(mtlBuffer: content)
        }
    }

//    func makeIterator() -> AnyIterator<Element> {
//        var i = ptr.makeIterator()
//        return .init {
//            fatalError()
//        }
//    }
    func _deinit() {
        content.setPurgeableState(.empty)
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

extension MemoryLayout {
    // TODO: page aligned allocations
    func pageAlignedCount(for count : Int) -> Int {
        return count
    }
}

public final class GPUArray<Element> : RangeReplaceableCollection,
                                       MutableCollection,
                                       RandomAccessCollection,
                                       ExpressibleByArrayLiteral {
    public typealias Index = Int
    private var content : MetalBuffer<Element>
    public private(set) var count : IndexDistance

    public init(arrayLiteral elements: Element...) {
        count = elements.count

        content = .init(capacity : elements.count)
        _ = content.ptr.initialize(from: elements)
    }

    public init() {
        fatalError()
    }

    public var startIndex : Index {
        return 0
    }

    public var capacity : IndexDistance {
        return content.count
    }

    public var endIndex : Index {
        return content.endIndex
    }

    public subscript(index: Index) -> Element {
        get {
            return content[index]
        }
        set {
            content[index] = newValue
        }
    }

    deinit {
        content._deinit()
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



