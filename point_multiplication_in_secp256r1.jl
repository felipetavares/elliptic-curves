PointAtInfinity = Nothing
Point = Union{Tuple{BigInt, BigInt}, PointAtInfinity}

# The multiplicative inverse of a, when working in mod n arithmetric
# https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Modular_integers
function inverse(a::BigInt, n::BigInt)::BigInt
    t::Tuple{BigInt, BigInt} = (0, 1)
    r::Tuple{BigInt, BigInt} = (n, a)

    while r[2] != 0
        quotient::BigInt = r[1] ÷ r[2]

        t = (t[2], t[1] - quotient * t[2])
        r = (r[2], r[1] - quotient * r[2])
    end

    # FIXME: check if r[1] > 1, if so a is not invertible

    if t[1] < 0
        return t[1] + n
    end

    t[1]
end

# NOTE: Programming trick!
# galois(n) returns a tuple of two *functions*: (K, I)
# when we call K(integer) it puts integer into a galois field of n elements
# when we call I(integer) it returns the multiplicative inverse of integer in a galois field of n elements
galois(n::BigInt) = (int::BigInt -> mod(int, n)::BigInt, int::BigInt -> inverse(int, n))

# The type returned by the above function
GaloisField = Base.return_types(galois, (BigInt,))[1]

# Elliptic Curve point doubling
# Equations from: https://en.wikipedia.org/wiki/Elliptic_curve_multiplication_point
function double(point::Point, a::BigInt, (K, I)::GaloisField)::Point
    (x, y) = point

    λ = (3*x*x + a) * I(K(2y));

    x_doubled = K(λ*λ-2x)

    (x_doubled, K((x-x_doubled)λ-y))
end

# Elliptic Curve point adding
# Equations from: https://en.wikipedia.org/wiki/Elliptic_curve_multiplication_point
function add(u::Point, v::Point, a::BigInt, (K, I)::GaloisField)::Point
    (xᵤ, yᵤ) = u
    (xᵥ, yᵥ) = v

    λ = (yᵥ-yᵤ) * I(K(xᵥ-xᵤ));

    xₑ = K(λ*λ-xᵤ-xᵥ)

    (xₑ, K((xᵤ-xₑ)λ-yᵤ))
end

function multiply(p::Point, n::BigInt, a::BigInt, field::GaloisField)::Point
    if n <= 0 
        return PointAtInfinity
    end

    if n == 1 
        return p
    end

    product = double(p, a, field)

    for i in 3:n
        product = add(p, product, a, field)
    end

    return product
end

function point_multiplication()
    prime::BigInt = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff; 
    (K, I) = galois(prime)

    a::BigInt = K(0xffffffff00000001000000000000000000000000fffffffffffffffffffffffc); 
    b::BigInt = K(0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b);

    G::Point = 
        (K(0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296),
         K(0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5))

    P::Point = G
    n::BigInt = 123918
    Q::Point = multiply(P, n, a, (K, I))

    println("Q = nP: $Q = $n$P")
end

point_multiplication()
