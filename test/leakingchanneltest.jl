using NonBlockingChannels
using Test

@testset "LeakingChannelTests" begin
  @testset "Drops oldest input when full" begin
    leakingchannel = LeakingChannel(2)
    put!(leakingchannel, 1)
    put!(leakingchannel, 2)
    put!(leakingchannel, 3)

    @test take!(leakingchannel) == 2
    @test take!(leakingchannel) == 3
  end
end
