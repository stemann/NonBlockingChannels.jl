"""
    AbstractNonBlockingOnPutChannel{T}

(Buffered) [AbstractChannel{T}](@ref) that does not block on input (e.g., `put!`) if channel is at capacity.
"""
abstract type AbstractNonBlockingOnPutChannel{T} <: AbstractNonBlockingChannel{T} end

function capacity(c::AbstractNonBlockingOnPutChannel)::Int end

function shorten!(c::AbstractNonBlockingOnPutChannel{T}, v::T) where {T} end

function length_ref(::AbstractNonBlockingOnPutChannel)::Base.RefValue{Int} end

function Base.fetch(c::AbstractNonBlockingOnPutChannel{T})::T where {T}
  return fetch(channel(c))
end

function Base.iterate(c::AbstractNonBlockingOnPutChannel{T})::T where {T}
  lock(c) do
    v = iterate(channel(c))
    length_ref(c)[] -= 1
    return v
  end
end

function Base.iterate(c::AbstractNonBlockingOnPutChannel{T}, state)::T where {T}
  lock(c) do
    v = iterate(channel(c), state)
    length_ref(c)[] -= 1
    return v
  end
end

function Base.put!(c::AbstractNonBlockingOnPutChannel{T}, v::T) where {T}
  lock(c) do
    if length_ref(c)[] >= capacity(c)
      shorten!(c, v)
    end
    result = put!(channel(c), v)
    length_ref(c)[] += 1
    return result
  end
end

function Base.take!(c::AbstractNonBlockingOnPutChannel{T})::T where {T}
  lock(c) do
    result = take!(channel(c))
    length_ref(c)[] -= 1
    return result
  end
end

Base.wait(c::AbstractNonBlockingOnPutChannel) = wait(channel(c))
