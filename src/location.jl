struct Location
    file:: String
    line:: Integer
end

macro trace()
    # https://discourse.julialang.org/t/tracing-and-saving-line-number-of-a-funtcion-call/27488
    return Location(String(__source__.file), __source__.line)
end    
