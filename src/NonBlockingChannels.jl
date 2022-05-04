module NonBlockingChannels

export LeakingChannel,
  bind, close, fetch, isopen, isready, iterate, popfirst!, push!, put!, take!, wait

include("leakingchannel.jl")

end # module
