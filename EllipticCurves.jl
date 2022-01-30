module EllipticCurves

export O, ECAlgebraPoint, ECPoint, +, *

# Types
O = nothing

struct EC
    a::BigInt
    b::BigInt
    p::BigInt
end

Point = Tuple{BigInt, BigInt}

struct ECPoint
    point::Point
    ec::EC
end
   
ECAlgebraPoint = Union{ECPoint, typeof(O)} 

# Constants
const ERR_DIFF_CURVES = "Trying to add points from different curves"

import Base.+, Base.*
using Galois: @expression as @galois

ECPoint(point::Point, (a, b, p)) = ECPoint(point, EC(a, b, p))

function (+)(a::ECAlgebraPoint, b::ECAlgebraPoint)::ECAlgebraPoint
    if a == O return b end
    if b == O return a end
    if a.ec != b.ec throw(ArgumentError(ERR_DIFF_CURVES)) end

    (x₁, y₁) = a.point
    (x₂, y₂) = b.point
    ec = a.ec
    p = ec.p

    if a == b
        if y₁ == 0 return O end

        λ = @galois(p, (3*x₁*x₁ + a.ec.a) / (2y₁))
        x = @galois(p, λ*λ-2*x₁)
        y = @galois(p, (x₁-x)λ-y₁)

        ECPoint((x, y), ec)
    else
        if x₁ == x₂ return O end

        λ = @galois(p, (y₂-y₁) / (x₂-x₁))
        x = @galois(p, λ*λ-x₁-x₂)
        y = @galois(p, (x₁-x)λ-y₁)

        ECPoint((x, y), ec)
    end
end

function (*)(a::ECAlgebraPoint, b::BigInt)::ECAlgebraPoint
    product = O

    while b > 0
        if b%2 == 1 product += a end
        a += a
        b ÷= 2
    end

    product
end

function (*)(a::BigInt, b::ECAlgebraPoint)::ECAlgebraPoint
    (*)(b, a)
end

end
