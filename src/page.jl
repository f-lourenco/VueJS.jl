function page(garr::Array;binds=Dict{String,String}(),kwargs...)
    
    args=Dict(string(k)=>v for (k,v) in kwargs)
    
    data=haskey(args,"data") ? args["data"] : Dict()
    
    comp=VueComponent("app",garr,data=data,binds=binds)
        
    scripts=haskey(args,"scripts") ? args["scripts"] : []
    
    push!(scripts,"const app_state = $(JSON.json(comp.def_data))")
    
    ## component script
    comp_script=[]
    push!(comp_script,"el: '#app'")
    push!(comp_script,"vuetify: new Vuetify()")
    push!(comp_script,"data: app_state")
    comp_script="var app = new Vue({"*join(comp_script,",")*"})"
    push!(scripts,comp_script)
    
    arr_dom=grid(comp.grid)
    body=htmlElement("body",Dict(),htmlElement("div",Dict("id"=>"app"),htmlElement("v-app",Dict(),htmlElement("v-container",Dict("fluid"=>true),arr_dom))))
    
    page_inst=VueJS.page(deepcopy(VueJS.HEAD),VueJS.INCLUDE_SCRIPTS,VueJS.INCLUDE_STYLES,body,join(scripts,"\n"))
    
    include_scripts=map(x->htmlElement("script",Dict("src"=>x),""),page_inst.include_scripts)
    include_styles=map(x->htmlElement("link",Dict("rel"=>"stylesheet","type"=>"text/css","href"=>x),nothing),page_inst.include_styles)
    
    append!(page_inst.head.value,include_scripts)
    append!(page_inst.head.value,include_styles)
    
    htmlpage=htmlElement("html",Dict(),[page_inst.head,page_inst.body])
    
    return htmlString(htmlpage)*"<script>$(page_inst.scripts)</script>"
end 