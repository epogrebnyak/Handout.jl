# Convert source file contents to code and text blocks and merge them with user blocks.

struct Code
    lines:: Vector{String}
end

struct Text
    lines:: Vector{String}
end

const ScriptBlock = Union{Code,Text}

append(block::ScriptBlock, x)= typeof(block)([block.lines; x])
is_empty(block::ScriptBlock) = block.lines == [] 

function to_blocks(text:: String) 
    blocks = ScriptBlock[]
    block = Code([])
    for line in split(text, "\n")
        # option: started comment
        if startswith(line,"#=")
            is_empty(block) || push!(blocks, block)
            line = line[3:end]
            block = Text([])
        end    
        # option: ended comment, can be same line as started comment
        if endswith(line, "=#")
            line = line[1:end-2]
            push!(blocks, append(block, line))
            block = Code([])
            continue
        end    
        # option: continue previous block    
        block = append(block, line) 
    end
    is_empty(block) || push!(blocks, block) # add last block after loop   
    return blocks          
end  

# prototype for merging script and text
function get_segments(lines: Vector{String}, breaks:: Vector{Int})
    result = Vector{String}[]
    as = [0; breaks]
    bs = [breaks; length(lines)]
    for (a, b) in zip(as,bs)
        text = join(lines[(a+1):b], "\n")
        print(text)
        push!(result, text)
    end    
    return result
end   

using Test

lines = "doc = @handout(\".\")
a = merge(doc, [10, 22])

#=
Something useful to say.
In several lines.
=#
"
println(lines)
for (i, b) in enumerate(to_blocks(lines))
    println(i, ": ", b)
end

a = get_segments(split(lines), [15, 22])

@test append(Code(["abc"]), "def") == Code(["abc", "def"])
@test append(Text(["abc"]), "def") == Text(["abc", "def"])

@test to_blocks(lines)[1] == Code(["doc = @handout(\".\")", 
                                   "a = merge(doc, [10, 22])", 
                                   ""])
@test to_blocks(lines)[2] == Text(["", 
                                   "Something useful to say.", 
                                   "In several lines.", 
                                   ""])
@test to_blocks(lines)[3] == Code([""])

@test to_blocks("#= It is just one line. =#") == [Text([" It is just one line. "])]
