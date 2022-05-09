using NonBlockingChannels
using Test

@testset "DropFirstNonBlockingOnPutChannel" begin
  @testset "Drops first input when full" begin
    c = DropFirstNonBlockingOnPutChannel{Int}(2)
    put!(c, 1)
    put!(c, 2)
    put!(c, 3)

    @test take!(c) == 2
    @test take!(c) == 3
  end
end
