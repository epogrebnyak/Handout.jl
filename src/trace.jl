function trace()
    # do something
    stacktrace() # this is line 3
end

a = trace() # this is line 6

for x in a
    println(x)
end   

#trace() at trace.jl:3
#top-level scope at none:0

# https://discourse.julialang.org/t/tracing-and-saving-line-number-of-a-funtcion-call/27488