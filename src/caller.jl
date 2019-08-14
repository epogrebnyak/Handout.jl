include("trace.jl")
using .Trace

#putting two statement in one line so that linenumer is the same
println("I want: ", Location(@__FILE__, @__LINE__)); 
#println(" I get: ", @trace)

t = @trace
f = @file
#show(f)
# TODO: converting to 


# fieldnames
# methodswith(QuoteNode)
