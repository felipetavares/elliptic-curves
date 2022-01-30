push!(LOAD_PATH, pwd())

using Random: RandomDevice
using EllipticCurves: ECPoint

function secp256r1_generator()::ECPoint
    p::BigInt = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff; 
    a::BigInt = 0xffffffff00000001000000000000000000000000fffffffffffffffffffffffc; 
    b::BigInt = 0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b;

    ECPoint(
        (0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296,
         0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5),
        (a, b, p)
    )
end

function ecdh_example()
    G = secp256r1_generator()
    n::BigInt = 0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551;

    rng = RandomDevice()

    alice_secret = rand(rng, 1:n-1)
    bob_secret = rand(rng, 1:n-1)

    alice_public = alice_secret*G
    bob_public = bob_secret*G

    alice_shared = alice_secret*bob_public
    bob_shared = bob_secret*alice_public

   (alice_shared, bob_shared)
end

(sa, sb) = ecdh_example()

println(sa, " = ", sb)
