#TODO: needs new imports
include("Handout.jl")
using .Handout
using Test

#putting two statement in one line so that linenumer is the same
println("I want: ", Location(@__FILE__, @__LINE__)); println(" I get: ", @trace)

t = @trace

println("Performing tests...")
@test t isa Location 
@test t.line == 8
@test endswith(t.file, "caller.jl")
println("Done.")

doc = @handout(".", "My report")
println(doc)
@test doc isa Document 
@test doc.directory == "."
@test doc.title == "My report"


doc=@handout(".")
add_image(doc, "boo.png", 0.5)
add_html(doc, "<b>This is me!</b>")
flush(doc.stack, 1)

@test doc.stack.registered[1][1] == Image("boo.png", 0.5)
@test doc.stack.registered[1][2] == Html(["<b>This is me!</b>"])

add_html(doc, "<i>Me again!</i>")
flush(doc.stack, 5)

w = flatten(doc.stack)
a = to_html(doc)

println(@display doc)

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

