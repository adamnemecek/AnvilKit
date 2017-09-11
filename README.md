# AnvilKit
AnvilKit tames Metal. It's a collection of code that seems to come up in just about every project that everyone seems to roll themselves.

## GPUDevice
Object that wraps `MTLDevice` and makes it into a singleton so that you don't need to pass it around.


## GPUVariable

```
class GPUVariable<T> {
    var value : T { get set }
}

```

You can now do

```
let variable = GPUVariable<Int>(value : 1)
variable.value = 2
computeEncoder.setVariable(variable, index: 0)
```

## float4x4 algebra
* a collection of extensions that wrap ```GLKMatrix4``` projection functions 

```
extension float4x4 {
	init(eye : float3, center : float3, up: float3)
	//....
}
```



## GPUArray

A reference object that resembles `Array`. Unlike `Array`, it has reference semantics, not value semantics. This is due to the fact that `MTLBuffer` itself has reference semantics and Metal application are more likely to have one shared array as opposed to many. 

```
class GPUArray<Element>: RangeReplaceableCollection,
    MutableCollection,
    RandomAccessCollection,
    ExpressibleByArrayLiteral,
    CustomStringConvertible  {
    /// ...
}
```



## Metal extensions

```
extension MTLVertexDescriptor {
	init<T>(reflecting : T)
}
```

You can initialize a new vertex descriptor by just passing in an instance of said type and ```MTLVertexDescriptor``` will figure it out. Relies on ```Swift.Mirror```. 