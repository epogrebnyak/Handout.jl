module Handout
export @trace, Location, Document, @handout

# julia learning space: 
# greet() = print("Hello World!")
# remember to use fieldnames(), methodswith()

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

macro show(doc::Document)
   error(NotImplemented)
end


#TODO: add_html block
#TODO: read script and convert to blocks (can do line by line)
#TODO: merge script and user blocks

end # module