# Following:
# 
# https://discourse.julialang.org/t/tracing-and-saving-line-number-of-a-funtcion-call/27488
# 
module Trace
export @trace, Location

struct Location
    file:: String
    line:: Integer
end

macro trace()
    return Location(String(__source__.file), __source__.line)
end    

end
