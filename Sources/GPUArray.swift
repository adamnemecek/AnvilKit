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

    fileprivate mutating
    func isUniqueRef() -> Bool {
        return isKnownUniquelyReferenced(&content)
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

    public private(set) var count : IndexDistance
    private var content : MetalBuffer<Element>

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
        /// adapted from https://github.com/apple/swift/blob/ea2f64cad218bb64a79afee41b77fe7bfc96cfd2/stdlib/public/core/ArrayBufferProtocol.swift#L140

        //        let oldCount = count
        //        let eraseCount = subrange.count
        //        let insertCount = Int(newElements.count)
        //        let growth = insertCount - eraseCount
        
        //        internal mutating func replaceSubrange<C>(
        //            _ subrange: Range<Int>,
        //            with newCount: Int,
        //            elementsOf newValues: C
        //            ) where C : Collection, C.Element == Element {
        //            _sanityCheck(startIndex == 0, "_SliceBuffer should override this function.")
        let newCount = Int(newElements.count)

        let oldCount = self.count
        let eraseCount = subrange.count

        let growth = newCount - eraseCount
        self.count = oldCount + growth

        var elements = content.ptr.baseAddress!
        let oldTailIndex = subrange.upperBound
        let oldTailStart = elements + oldTailIndex
        let newTailIndex = oldTailIndex + growth
        let newTailStart = oldTailStart + growth
        let tailCount = oldCount - subrange.upperBound

        if growth > 0 {
            // Slide the tail part of the buffer forwards, in reverse order
            // so as not to self-clobber.
            newTailStart.moveInitialize(from: oldTailStart, count: tailCount)

            // Assign over the original subrange
            var i = newElements.startIndex
            for j in CountableRange(subrange) {
                elements[j] = newElements[i]
                newElements.formIndex(after: &i)
            }
            // Initialize the hole left by sliding the tail forward
            for j in oldTailIndex..<newTailIndex {
                (elements + j).initialize(to: newElements[i])
                newElements.formIndex(after: &i)
            }

        }
        else { // We're not growing the buffer
            // Assign all the new elements into the start of the subrange
            var i = subrange.lowerBound
            var j = newElements.startIndex
            for _ in 0..<newCount {
                elements[i] = newElements[j]
                i += 1
                newElements.formIndex(after: &j)
            }
            
            
            // If the size didn't change, we're done.
            if growth == 0 {
                return
            }
            
            // Move the tail backward to cover the shrinkage.
            let shrinkage = -growth
            if tailCount > shrinkage {   // If the tail length exceeds the shrinkage
                // Assign over the rest of the replaced range with the first
                // part of the tail.
                newTailStart.moveAssign(from: oldTailStart, count: shrinkage)
                
                // Slide the rest of the tail back
                oldTailStart.moveInitialize(
                    from: oldTailStart + shrinkage, count: tailCount - shrinkage)
            }
            else {                      // Tail fits within erased elements
                // Assign over the start of the replaced range with the tail
                newTailStart.moveAssign(from: oldTailStart, count: tailCount)
                
                // Destroy elements remaining after the tail in subrange
                (newTailStart + tailCount).deinitialize(
                    count: shrinkage - tailCount)
            }
        }
    }
    
}



