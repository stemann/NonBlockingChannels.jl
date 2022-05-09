mutable struct DropFirstNonBlockingOnPutChannel{T} <: AbstractNonBlockingOnPutChannel{T}
  channel::AbstractChannel{T}
  capacity::Int
  length_ref::Ref{Int}

  function DropFirstNonBlockingOnPutChannel{T}(
    channel::AbstractChannel{T}, capacity::Int, length::Int
  ) where {T}
    @assert capacity > 0
    return new(channel, capacity, Ref(length))
  end
end

function DropFirstNonBlockingOnPutChannel{T}(
  capacity::Int, channel::AbstractChannel{T}
) where {T}
  return DropFirstNonBlockingOnPutChannel{T}(channel, capacity, 0)
end

function DropFirstNonBlockingOnPutChannel{T}(capacity::Int) where {T}
  return DropFirstNonBlockingOnPutChannel{T}(Channel{T}(capacity), capacity, 0)
end

capacity(c::DropFirstNonBlockingOnPutChannel) = c.capacity

channel(c::DropFirstNonBlockingOnPutChannel) = c.channel

length_ref(c::DropFirstNonBlockingOnPutChannel)::Base.RefValue{Int} = c.length_ref

function shorten!(c::DropFirstNonBlockingOnPutChannel{T}, v::T) where {T}
  w = take!(c)
  @info "$c dropped value"
end

function Base.show(io::IO, c::DropFirstNonBlockingOnPutChannel)
  return print(io, typeof(c), "(", channel(c), ", ", c.capacity, ", ", c.length_ref[], ")")
end
