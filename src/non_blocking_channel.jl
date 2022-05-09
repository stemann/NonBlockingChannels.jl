"""
    AbstractNonBlockingChannel{T}

[AbstractChannel{T}](@ref) that does not block on input and/or output. Wraps an [AbstractChannel{T}](@ref).
"""
abstract type AbstractNonBlockingChannel{T} <: AbstractChannel{T} end

"""
    channel(c::AbstractNonBlockingChannel{T})

Returns the [AbstractChannel{T}](@ref) backing the [AbstractNonBlockingChannel{T}](@ref).
"""
function channel(::AbstractNonBlockingChannel{T})::AbstractChannel{T} where {T} end

Base.bind(c::AbstractNonBlockingChannel, task::Task) = bind(channel(c), task)

Base.close(c::AbstractNonBlockingChannel) = close(channel(c))

Base.close(c::AbstractNonBlockingChannel, excp::Exception) = close(channel(c), excp)

Base.isempty(c::AbstractNonBlockingChannel) = isempty(channel(c))

Base.isopen(c::AbstractNonBlockingChannel) = isopen(channel(c))

Base.isready(c::AbstractNonBlockingChannel) = isready(channel(c))

function Base.lock(c::AbstractNonBlockingChannel)
  @static if VERSION >= v"1.2"
    lock(channel(c))
  end
end

function Base.lock(f::Function, c::AbstractNonBlockingChannel)
  lock(c)
  try
    f()
  finally
    unlock(c)
  end
end

function Base.show(io::IO, c::AbstractNonBlockingChannel)
  return print(io, typeof(c), "(", channel(c), ")")
end

function Base.trylock(c::AbstractNonBlockingChannel)
  @static if VERSION >= v"1.2"
    trylock(channel(c))
  end
end

function Base.unlock(c::AbstractNonBlockingChannel)
  @static if VERSION >= v"1.2"
    unlock(channel(c))
  end
end
