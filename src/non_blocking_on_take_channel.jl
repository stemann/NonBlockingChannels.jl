"""
    AbstractNonBlockingOnTakeChannel{T}

[AbstractChannel{T}](@ref) that does not block on output (e.g., `take!`) if channel is empty.
"""
abstract type AbstractNonBlockingOnTakeChannel{T} <: AbstractNonBlockingChannel{T} end

function ensure_non_empty!(c::AbstractNonBlockingOnTakeChannel{T}) where {T} end

function Base.iterate(c::AbstractNonBlockingOnTakeChannel{T})::T where {T}
  lock(c) do
    if isempty(c)
      ensure_non_empty!(c)
      @assert isready(c)
    end
    return iterate(channel(c))
  end
end

function Base.iterate(c::AbstractNonBlockingOnTakeChannel{T}, state)::T where {T}
  lock(c) do
    if isempty(c)
      ensure_non_empty!(c)
      @assert isready(c)
    end
    return iterate(channel(c), state)
  end
end

function Base.put!(c::AbstractNonBlockingOnTakeChannel{T}, v::T) where {T}
  return put!(channel(c), v)
end

function Base.fetch(c::AbstractNonBlockingOnTakeChannel{T})::T where {T}
  lock(c) do
    if isempty(c)
      ensure_non_empty!(c)
      @assert isready(c)
    end
    return fetch(channel(c))
  end
end

function Base.take!(c::AbstractNonBlockingOnTakeChannel{T})::T where {T}
  lock(c) do
    if isempty(c)
      ensure_non_empty!(c)
      @assert isready(c)
    end
    return take!(channel(c))
  end
end

function Base.wait(c::AbstractNonBlockingOnTakeChannel)
  lock(c) do
    if isempty(c)
      ensure_non_empty!(c)
      @assert isready(c)
    end
    return wait(channel(c))
  end
end
