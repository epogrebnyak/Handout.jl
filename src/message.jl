struct Message
    lines:: Vector{String}
end

function add_message(doc::Document, x)
    m = Message([x])
    append!(doc.stack, m)
    return doc
end 

doc = add_message(doc, "It's me!")
