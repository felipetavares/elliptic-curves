push!(LOAD_PATH, "/home/felipe/Development/elliptic-curves/")

using EllipticCurves: ECPoint

function main()
    prime::BigInt = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff; 
    a::BigInt = 0xffffffff00000001000000000000000000000000fffffffffffffffffffffffc; 
    b::BigInt = 0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b;

    G = ECPoint(
        (0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296,
         0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5),
        (a, b, prime)
    )

    P = G
    n::BigInt = 112800364716036024817782712825799106750683064088361941029856336937149668016902
    Q = n * P

    println("Q = nP: $Q = $n$P")
end

main()
