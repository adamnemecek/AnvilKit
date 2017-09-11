//
//  main.swift
//  main
//
//  Created by Adam Nemecek on 9/11/17.
//

import Foundation

import MetalKit

struct A {
    let a : Int32 = 5
    let b : Int32 = 10
}

var a : GPUArray<Int> = [1,2,3,4,5]

a.replaceSubrange(0..<2, with: [1])

print(a)

