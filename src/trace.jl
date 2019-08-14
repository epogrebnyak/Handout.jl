macro file1()
  return QuoteNode(__source__.file)
end

f = @file1
g = String(@file1)

# todo: use embedded macro


macro file2()
  x = QuoteNode(__source__.file)
  return String(x)
end

h = @file2

#==
D:\github\Handout.jl\src>julia trace.jl
ERROR: LoadError: LoadError: MethodError: no method matching String(::QuoteNode)
Closest candidates are:
  String(!Matched::String) at boot.jl:318
  String(!Matched::Array{UInt8,1}) at strings/string.jl:39
  String(!Matched::Base.CodeUnits{UInt8,String}) at strings/string.jl:77
  ...
Stacktrace:
 [1] @file2(::LineNumberNode, ::Module) at D:\github\Handout.jl\src\trace.jl:13
in expression starting at D:\github\Handout.jl\src\trace.jl:16
in expression starting at D:\github\Handout.jl\src\trace.jl:16

=#

#end
# https://discourse.julialang.org/t/tracing-and-saving-line-number-of-a-funtcion-call/27488