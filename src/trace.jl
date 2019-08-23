# Following:
# 
# https://discourse.julialang.org/t/tracing-and-saving-line-number-of-a-funtcion-call/27488
# 
module Trace
export @trace, Location, Handout, @handout

struct Location
    file:: String
    line:: Integer
end

macro trace()
    return Location(String(__source__.file), __source__.line)
end    

# TODO: passing a directory to Handout as parameter

const FilePath = String
const DirectoryPath = String

struct Handout
    script:: FilePath
    directory:: DirectoryPath
    title:: String
end

macro handout(directory, title="Handout")
    return Handout(String(__source__.file), directory, title)
end    


end
