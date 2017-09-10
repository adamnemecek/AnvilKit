# AnvilKit
AnvilKit tames Metal. It's a collection of code that seems to come up in just about every project that everyone seems to roll themselves.

## GPUVariable

```
class GPUVariable<T> {
    var value : T { get set }
}

```

You can now do

```
let variable : GPUVariable<Int> = GPUVariable(device : ..., value : 1)
variable.value = 2
computeEncoder.setVariable(variable, index: 0)
```

## float4x4 algebra






