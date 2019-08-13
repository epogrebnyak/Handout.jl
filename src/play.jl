struct Pointer
    items :: Vector{String}
end

function add_text(p::Pointer, message::String)
    push!(p.items, message)
    p
end

function filename(p::Pointer)
    # must return a name of the file where p is initiated
end    

#=

# file1.py
# -------- 

def trace_init():
    # The loop walks through the call stack, skips 
    # internal entries in handout.py, and breaks at 
    # the first external Python file. We assume this 
    # is the file is where an instance was created.
    for info in inspect.stack():
        if info.filename == __file__:
                continue
        break    
    return info
   
def filename(info) -> str:
    """Return path to a file where object was created.""" 
    return info.filename

# file2.py
# -------- 
from file1 import trace_init

s = trace_init()
print(s.filename) # file2.py
=#
