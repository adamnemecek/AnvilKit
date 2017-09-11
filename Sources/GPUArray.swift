//
//  GPUArray.swift
//  AnvilKit
//
//  Created by Adam Nemecek on 9/11/17.
//

import MetalKit


public final class GPUArray<Element> : RangeReplaceableCollection, RandomAccessCollection {
    public typealias Index = Int

    public init() {
        fatalError()
    }
    //private let content : [Element]

    public var startIndex : Index {
        fatalError()
    }

    public var count : IndexDistance {
        fatalError()
    }

    public var endIndex : Index {
        fatalError()
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



