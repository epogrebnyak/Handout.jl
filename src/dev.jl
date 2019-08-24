include("Handout.jl")
using .Handout

function merge(doc:: Document, breaks)
    lines = readlines(doc.script)
    result = Vector{String}[]
    as = [0; breaks]
    bs = [breaks; length(lines)]
    for (a, b) in zip(as,bs)
        push!(result, lines[(a+1):b])
    end    
    return result
end   

doc = @handout(".", "My report")
a = merge(doc, [13, 22])

#=
Something useful to say.
In several lines
=#

struct Code
    lines:: Vector{String}
end    

struct Text
    lines:: Vector{String}
end

function append(xs::Code, x::String)
    return Code([xs.lines; x])
end

function append(xs::Text, x::String)
    return Text([xs.lines; x])
end

lines = a[2]

# TODO: split lines into code and text blocks

blocks = []
current_block = Code([])
for line in lines
    if startswith(line, "#=")
        push!(blocks, current_block)
        current_block = Text([])
        line = line[3:end]
    end    
    if endswith(line, "=#")
        line = line[1:end-2]
    end    
    current_block=append(current_block, line)
end
push!(blocks, current_block)
println(blocks)    
