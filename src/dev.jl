# MAYBE: structs below can be generated via macros

struct Message
    lines:: Vector{String}
end

struct Code
    lines:: Vector{String}
end

struct Text
    lines:: Vector{String}
end

# end MAYBE

function html(block:: Message)
    return "<pre class=\"message\">" * join(block) * "</pre>\n"
end    

function html(block:: Code)
    return "<pre><code class=\"julia\">" * join(block) * "</code></pre>\n"
end

function html(block:: Text)
    return "<div class=\"markdown\">" + join(block) + "</div>\n"
end    

# TODO: add more types

# QUESTION: should inherit from abstract base type?
const ScriptBlock = Union{Text,Code}
const UserBlock = Union{Message}
const UserBlocks = Vector{UserBlock}
const TextBlock = Union{Text,Code,Message}

Base.join(block::TextBlock) = join(block.lines, "\n")
Base.:(==)(a::TextBlock, b::TextBlock) = (a.lines == b.lines) && (a isa typeof(b))
append(block::ScriptBlock, x)= typeof(block)([block.lines; x])
is_empty(block::ScriptBlock) = block.lines == [] 




function to_blocks(script_text:: String) 
    blocks = ScriptBlock[]
    block = Code([])
    for line in split(script_text, "\n")
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

const FilePath = String
const DirectoryPath = String

struct Document # renamed from Handout because of conflict with module name
    title:: String
    file:: FilePath # source
    directory:: DirectoryPath # target
    stack:: Stack   
end

macro handout(directory, title="Handout")
    return Document(title, String(__source__.file), directory, empty_stack())
end    

function render(doc::Document)
    stack = flush(doc.stack)
    html = join(map(html, stack.accepted), "\n")
    return html, Document(doc.title, doc.file, doc.directory, stack)
end

function merge(doc:: Document, breaks:: Vector{Int})
    lines = readlines(doc.file)
    result = Vector{String}[]
    as = [0; breaks]
    bs = [breaks; length(lines)]
    for (a, b) in zip(as,bs)
        text = join(lines[(a+1):b], "\n")
        print(text)
        #push!(result, text)
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

doc = @handout(".", "My report")
a = merge(doc, [15, 22])

#=
Something useful to say.
In several lines
=#

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


#Simplified:
#- one user block (Message)
#- no merging yet 

# TODO:

function add_message(doc::Document, x)
    m =  Message([x])
    append!(doc.stack, m)
    return doc
end 

#doc = add_message(doc, "It's me!")

# TODO:
# show(render(doc))
