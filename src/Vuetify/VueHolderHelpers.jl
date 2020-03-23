
function tabs(ts::Array;cols=nothing,kwargs...)
   names=[]
   elements=[]
   for t in ts
        @assert t isa Pair "tabs should use Pair of String (name of Tab) and Elements"
        push!(names,t[1])
        push!(elements,t[2])
   end
   attrs=Dict{String,Any}("names"=>names)
    for (k,v) in kwargs
       attrs[string(k)]=v 
    end
   return VueHolder("v-tabs",attrs,elements,cols,nothing)
    
end

bar(;kwargs...)=bar([];kwargs...)
function bar(elements::Vector;kwargs...)
    elements=elements==[] ? Vector{VueElement}() : elements
    @assert elements isa Vector "Elements should be vector of VueElement's/HtmlElement/String!"
    
    real_attrs=Dict(string(k)=>v for (k,v) in kwargs)
        
    ## Defaults and merge with real
    attrs=Dict("color"=>"dark-v accent-4","dense"=>true,"dark"=>true,"clipped-left"=>true)
    merge!(attrs,real_attrs)
    
   return VueHolder("v-app-bar",attrs,elements,nothing,nothing)
    
end

card(text::htmlTypes;cols=3,kwargs...)=card(text=[text],cols=cols;kwargs...) 
card(text::Vector;cols=3,kwargs...)=card(text=text,cols=cols;kwargs...) 
function card(;title=nothing,subtitle=nothing,text=nothing,actions::htmlTypes=nothing,cols=3,kwargs...)
    #elements=>title,subtitle,text,actions

    real_attrs=Dict(string(k)=>v for (k,v) in kwargs)
    ## Defaults and merge with real
    attrs=Dict()
    merge!(attrs,real_attrs)
    
    elements=[]
    names=[]
    for (k,v) in [title=>"v-card-title",subtitle=>"v-card-subtitle",text=>"v-card-text",actions=>"v-card-actions"]
       if k!=nothing
       assert_html_types(k)
       push!(elements,k)
       push!(names,v) 
       end
    end
    elements
    attrs["names"]=names
    
   return VueJS.VueHolder("v-card",attrs,elements,cols,nothing)
    
end

dialog(id::String,element;kwargs...)=dialog(id,[element];kwargs...)
function dialog(id::String,elements::Vector;kwargs...)
    
    real_attrs=Dict(string(k)=>v for (k,v) in kwargs)
        
    haskey(real_attrs,"value") ? (@assert real_attrs["value"] isa Bool "Value Attr in Dialog must be a Bool") : nothing
    haskey(real_attrs,"value") ? nothing : real_attrs["value"]=false
    
    ## Defaults and merge with real
    dial_attrs=Dict("persistent"=>true,"max-width"=>"600")
    merge!(dial_attrs,real_attrs)
    
    vs_dial=VueStruct(id,elements)
    vs_dial.def_data["value"]=dial_attrs["value"]    
    dial_attrs[":value"]=id*".value"
    
    vs_dial.render_func=(x)->begin
        
        child_dom=VueJS.dom(x.grid,rows=true)
        [HtmlElement("v-dialog",dial_attrs,12,HtmlElement("v-card",Dict(),12,HtmlElement("v-container",Dict(),12,child_dom)))]
    end
    
    return vs_dial
end