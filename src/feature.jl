# NOT TODO: generate structs below via macros

struct Code
    lines:: Vector{String}
end

struct Text
    lines:: Vector{String}
end

const ScriptBlock=Union{Code, Text}

struct Html
    lines:: Vector{String}
end

struct Image
    file:: String
    width:: Float16
end

const UserBlock = Union{Html, Image}
const UserBlocks = Vector{UserBlock}
const TextBlock = Union{Text,Code,Html}
const Block = Union{UserBlock, TextBlock}


Base.join(block::TextBlock) = join(block.lines, "\n")


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
end     

function flatten(stack::Stack)
    ix = sort([i for i in keys(doc.stack.registered)])
    return [b for i in sort(ix) for b in doc.stack.registered[i]]
end    

s = Stack([],Dict())
println("at init\n", s)
push!(s.pending, Html(["<br>", "<h1>Header 1<h1>"]))
push!(s.pending, Image("boo.png", 1))
a = s.pending
b = s.registered
println("before change")
println(s.pending)
println(s.registered)
flush(s,5)
println("after change")
println(s.pending)
println(s.registered)

using Test
@test s.registered[5] == a


const FilePath = String
const DirectoryPath = String

struct Document # renamed from Handout to avoid conflict with module name
    title:: String
    file:: FilePath # source
    directory:: DirectoryPath # target
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
end

function html(block:: Html)
    return join(block) 
end    

function html(block:: Image)
    w = round(100 * block.width, digits=2)
    return "<img src=\"$(block.file)\" width=\"$w\" />"
end 

function html(block:: Code)
    return "<pre><code class=\"julia\">" * join(block) * "</code></pre>\n"
end

function html(block:: Text)
    return "<div class=\"markdown\">" * join(block) * "</div>\n"
end 

function convert(doc::Document, func)
    return join(map(func, flatten(doc.stack)), "\n")
end

function to_html(doc::Document)::String
    body = convert(doc, html)
    head ="<html><body>"
    tail ="</body></html>"
    return head * body * tail
end    

function save_html(doc::Document)
    # TODO
    error("not implemented")
end    


doc=@handout(".")
add_image(doc, "boo.png", 0.5)
add_html(doc, "<b>This is me!</b>")
flush(doc.stack, 1)

Base.:(==)(a::TextBlock, b::TextBlock) = (a.lines == b.lines) && (a isa typeof(b))
@test doc.stack.registered[1][1] == Image("boo.png", 0.5)
@test doc.stack.registered[1][2] == Html(["<b>This is me!</b>"])

add_html(doc, "<i>Me again!</i>")
flush(doc.stack, 5)

w = flatten(doc.stack)
a = to_html(doc)

# TODO: flush must work know its line, should be a macro
# TODO: must save to file 
# TODO: combine flush() and html()
# TODO: use script to produce literate blocks 
# (*) TODO: image in julia, which library for imageio?
# TODO: move tests
# TODO: make it a module

# Review: 
# - does html has to be multi-line? [] vs String

# Simplifications:
# - no title
# - no CSS 
# - not a module

