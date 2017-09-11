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

let q = MTLVertexDescriptor(reflecting: A())


