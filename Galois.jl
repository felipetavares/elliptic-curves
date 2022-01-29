module Galois

export expression

function mod_power(number, power, prime)
    result::BigInt = 1

    while power > 0
        if power%2 == 1
            result = mod(result*number, prime)
        end

        number = mod(number*number, prime)

        power = power ÷ 2
    end

    result
end

function inverse(number::BigInt, prime::BigInt)
    mod_power(mod(number, prime), prime-2, prime)
end

function galois_arithmetric(order, leaf::Any)
    :(mod($(esc(leaf)), $(esc(order))))
end

function galois_arithmetric(order, expression::Expr)
    if expression.head == :call
        if length(expression.args) == 3
            operation = expression.args[1]
            a = expression.args[2]
            b = expression.args[3]

            if operation == :+
                quote
                    mod($(galois_arithmetric(order, a)) + $(galois_arithmetric(order, b)), $(esc(order)))
                end
            elseif operation == :-
                quote
                    mod($(galois_arithmetric(order, a)) - $(galois_arithmetric(order, b)), $(esc(order)))
                end
            elseif operation == :*
                quote
                    mod($(galois_arithmetric(order, a)) * $(galois_arithmetric(order, b)), $(esc(order)))
                end
            elseif operation == :/
                quote
                    mod($(galois_arithmetric(order, a)) * inverse($(galois_arithmetric(order, b)), $(esc(order))), $(esc(order)))
                end
            else
                :($(esc(expression)))
            end
        else
            :($(esc(expression)))
        end
    else
        :($(esc(expression)))
    end
end

macro expression(order, expression::Union{Expr, Number, Symbol})
    galois_arithmetric(order, expression)
end

end
