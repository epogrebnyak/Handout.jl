module Trace
export @trace, @file, Location

struct Location
    file:: String
    line:: Integer
end

macro trace()
    return Location(abspath(PROGRAM_FILE), __source__.line)
end  

macro file()
  return QuoteNode(__source__.file)
end

end
# https://discourse.julialang.org/t/tracing-and-saving-line-number-of-a-funtcion-call/27488