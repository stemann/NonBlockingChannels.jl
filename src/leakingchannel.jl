import Base: bind, close, fetch, isopen, isready, iterate, popfirst!, push!, put!, take!, wait

mutable struct LeakingChannel <: AbstractChannel{Any}
  channel::AbstractChannel{Any}
  capacity::Int
  size::Int

  function LeakingChannel(capacity::Int, channel::AbstractChannel{Any})
    return new(channel, capacity, 0)
  end

  function LeakingChannel(capacity::Int)
    return new(Channel(capacity), capacity, 0)
  end
end

function bind(c::LeakingChannel, task::Task)
  return bind(c.channel, task)
end
function close(c::LeakingChannel)
  return close(c.channel)
end
function fetch(c::LeakingChannel)
  return fetch(c.channel)
end
function isopen(c::LeakingChannel)
  return isopen(c.channel)
end
function isready(c::LeakingChannel)
  return isready(c.channel)
end
function iterate(c::LeakingChannel)
  result = iterate(c.channel)
  c.size -= 1
  return result
end
function iterate(c::LeakingChannel, state)
  result = iterate(c.channel, state)
  c.size -= 1
  return result
end
function popfirst!(c::LeakingChannel)
  result = popfirst(c.channel)
  c.size -= 1
  return result
end

function put!(c::LeakingChannel, v)
  if c.size >= c.capacity
    @info "LeakingChannel Dropping element"
    take!(c)
  end
  result = put!(c.channel, v)
  c.size += 1
  return result
end
function push!(c::LeakingChannel, v)
  return put!(c, v)
end
function take!(c::LeakingChannel)
  result = take!(c.channel)
  c.size -= 1
  return result
end
function wait(c::LeakingChannel)
  return wait(c.channel)
end
