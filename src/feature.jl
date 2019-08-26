struct Code
    lines:: Vector{String}
end

struct Text
    lines:: Vector{String}
end

struct Html
    lines:: Vector{String}
end

struct Image
    file:: String
    width:: Float16
end

const ScriptBlock = Union{Code,Text}
const UserBlock = Union{Html,Image}
const UserBlocks = Vector{UserBlock}
const TextBlock = Union{Text,Code,Html}
const Block = Union{UserBlock,ScriptBlock}

Base.join(block::TextBlock) = join(block.lines, "\n")
Base.:(==)(a::TextBlock, b::TextBlock) = (a.lines == b.lines) && (a isa typeof(b))

mutable struct Stack
    pending:: UserBlocks 
    registered:: Dict{Int, UserBlocks}
end

function flush(stack::Stack, lineno::Int)
    if haskey(stack.registered, lineno)
        append!(stack.registered[lineno], stack.pending)
    else
        stack.registered[lineno] = stack.pending        
    end
    stack.pending = []
    return stack
end     

function flatten(stack::Stack)
    ix = sort([i for i in keys(stack.registered)])
    return [b for i in sort(ix) for b in stack.registered[i]]
end    

const FilePath = String
const DirectoryPath = String

struct Document # renamed from Handout to avoid conflict with module name
    title:: String
    file:: FilePath 
    directory:: DirectoryPath
    stack:: Stack   
end

macro handout(directory, title="Handout")
    _stack = Stack([],Dict())
    _file = String(__source__.file)
    return Document(title, _file, directory, _stack)
end    

function add_block(doc:: Document, block::UserBlock)
    push!(doc.stack.pending, block)
end     

function add_html(doc:: Document, content) 
    add_block(doc, Html([content]))
end

function add_image(doc:: Document, filename, width=1)
    add_block(doc, Image(filename, width))
    #TODO: counter
    #TODO: create image file
end

function html(block:: Html)
    return join(block) 
end    

function html(block:: Image)
    w = round(100 * block.width, digits=2)
    return "<img src=\"$(block.file)\" width=\"$w\" />"
    # why " />"?
end 

function html(block:: Code)
    return "<pre><code class=\"julia\">" * join(block) * "</code></pre>"
end

function html(block:: Text)
    return "<div class=\"markdown\">" * join(block) * "</div>"
end 

function convert(doc::Document, func)
    return join(map(func, all_blocks(doc)), "\n")
end

function all_blocks(doc::Document) 
    merge(readlines(doc.file), doc.stack.registered)
end    

function merge(lines:: Vector{String}, blocks: Dict{Int, UserBlocks}):: Vector{Block}
    # script_blocks = 
    # user_blocks =
    all_blocks = []
end    

function to_html(doc::Document)::String    
    body = convert(doc, html)
    head ="<html><body>" #can be a constant
    tail ="</body></html>" #can be a constant
    return head * body * tail
end    

function write_to_file(filename, content)
    open(filename, "w") do io
        write(io, content)
    end
end


function display(doc:: Document, lineno::Int)
    flush(doc.stack, lineno)
    content = to_html(doc)
    write_to_file(doc.file, content)
    return content 
end

macro display(doc)
    line = __source__.line
    quote 
      display($doc, $line)     
    end
end     

# == Parts ==
# TODO: html.jl(?)

# == Source script ==
# TODO: merge script blocks (script.jl)

# == Image ==
# TODO: image in julia, which library for imageio?
# TODO: counter for image numbers
# TODO: create image file

# == Usage ==
# TODO: make tests from caller.jl
# TODO: example.jl

# == Simplifications ==
# - no HTML title
# - no CSS 
# - no logging messages
# - no exclude pragmas
# - two types of user blocks - html and image

# == Changes to original python version ==
#- @display vs show()
#- no "\n" at the end of html representation of blocks (we join them with "\n" later anyways)
#- html header and footer are not blocks, but strings (separation of exporter and doc representation)
#- works in REPL by default

# == Questions / maybe ==
#- should data structures inherit from abstract base type?
#- does html has to be multi-line? [] vs String
#- may generate structs below via macros
#- weave reader
