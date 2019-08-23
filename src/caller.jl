include("trace.jl")
using .Trace
using Test

#putting two statement in one line so that linenumer is the same
println("I want: ", Location(@__FILE__, @__LINE__)); println(" I get: ", @trace)

t = @trace

println("Performing tests...")
@test t isa Location 
@test t.line == 8
@test endswith(t.file, "caller.jl")
println("Done.")

doc = @handout(".", "My report")
println(doc)

# Note: remember to use
#   fieldnames()
#   methodswith()
