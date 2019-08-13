module Trace
export Location, @point, @find_source
struct Location
    file:: String
    line:: Integer
end

macro point()
    return Location(__source__.filename, __source__.line)
end

macro find_source()
    return __source__
end

end
# https://discourse.julialang.org/t/tracing-and-saving-line-number-of-a-funtcion-call/27488