# Learn julia:
# - http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/
# - can use macros to propagate methods in julia 
# - append can change inline

using Test 

struct Code
    lines:: Vector{String}
end    

struct Text
    lines:: Vector{String}
end

function append(block::Code, x::String)
    return Code([block.lines; x])
end

function append(block::Text, x::String)
    return Text([block.lines; x])
end

@test append(Code(["abc"]), "def").lines == Code(["abc", "def"]).lines

function to_blocks(lines) 
    blocks = [] # TODO: change to union type
    block = Code([])
    for line in lines
        # option 1: started comment
        if startswith(line,"#=")
            block.lines == [] || blocks = [blocks; block]
            line = line[3:end]
            block = Text([line])
            continue
        # option 2: ending comment
        elseif endswith(line, "=#")
            line = line[1:end-2]
            blocks = [blocks; append(block, line)]
            block = Code([])
            continue
        # option 3: continue previous block    
        else   
            block = append(block, line) 
        end
    end    
    return blocks  
end  

lines =  ["", "doc = @handout(\".\", \"My report\")", "a = merge(doc, [13, 22])", "", "#=", "Something useful to say.", "In several lines", "=#", ""]
show(to_blocks(lines))
