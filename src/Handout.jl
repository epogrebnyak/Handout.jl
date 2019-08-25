module Handout
export @trace, Location, Document, @handout, render

const NotImplemented = "Not Implemented"

struct Location
    file:: String
    line:: Integer
end

macro trace()
    # https://discourse.julialang.org/t/tracing-and-saving-line-number-of-a-funtcion-call/27488
    return Location(String(__source__.file), __source__.line)
end    

const FilePath = String
const DirectoryPath = String

struct Document # renamed from Handout because of conflict with module name
    script:: FilePath
    directory:: DirectoryPath
    title:: String    
end

macro handout(directory, title="Handout")
    return Document(String(__source__.file), directory, title)
end    

function render(doc::Document)
    println(doc.title)
    println(read(doc.script, String)[1:50], "...")
end


#TODO: add_html block
#DONE: read script and convert to blocks (can do line by line)
#TODO: merge script and user blocks
#TODO: render html

end # module