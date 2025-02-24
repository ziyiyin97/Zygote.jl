"""
    dropgrad(x) -> x

Drop the gradient of `x`.

    julia> gradient(2, 3) do a, b
         dropgrad(a)*b
       end
    (nothing, 2)
"""
function dropgrad end

@adjoint dropgrad(x) = dropgrad(x), _ -> nothing

Base.@deprecate dropgrad(x) ChainRulesCore.ignore_derivatives(x)


"""
    ignore() do
      ...
    end

Tell Zygote to ignore a block of code. Everything inside the `do` block will run
on the forward pass as normal, but Zygote won't try to differentiate it at all.
This can be useful for e.g. code that does logging of the forward pass.

Obviously, you run the risk of incorrect gradients if you use this incorrectly.
"""
function ignore end

@adjoint ignore(f) = ignore(f), _ -> nothing

Base.@deprecate ignore(f) ChainRulesCore.ignore_derivatives(f)

"""
    @ignore (...)

Tell Zygote to ignore an expression. Equivalent to `ignore() do (...) end`.
Example:

```julia-repl
julia> f(x) = (y = Zygote.@ignore x; x * y);
julia> f'(1)
1
```
"""
macro ignore(ex)
    return :(Zygote.ignore() do
        $(esc(ex))
    end)
end
