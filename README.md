# Elliptic Curves

This is a repository to study elliptic curves and their applications to cryptography.

# Usage

``` julia
using EllipticCurves: ECPoint

# (a, b) in the Weierstrass elliptic curve form
# p is the prime for defining a GF(p) in which the operations will happen
P = ECPoint((x, y), (a, b, p))
n::BigInt = ...
Q = n*P
```

`ec.jl` contains an example with [secp256r1][secp256r1].

Results were verified with help from [SAGE][sage].

[secp256r1]: https://neuromancer.sk/std/secg/secp256r1
[sage]: https://doc.sagemath.org/

## Galois.jl

Implements a `@expression(n, expr)` macro to compute expressions in `GF(n)`.

## EllipticCurves.jl

Implements point addition and multiplication for elliptic curves in finite prime
fields.
