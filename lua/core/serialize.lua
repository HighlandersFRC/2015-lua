local function defaultTreeWriter(level, key, value)
    local indent = string.rep("  ", level)
    local formatString = "%s"
    if type(key) == "string" then
        formatString = formatString .. "%q"
    else
        formatString = formatString .. "%s"
    end
    formatString = formatString .. " : "
    if type(value) == "string" then
        formatString = formatString .. "%q"
    else
        formatString = formatString .. "%s"
    end
    print(string.format(formatString, indent, key, value))
end

local function tree(tab, writer, path)
    if writer == nil then
        writer = defaultTreeWriter
    end
    if path == nil then
        path = {}
    end
    table.insert(path, tab)
    local level = #path
    for k, v in pairs(tab) do
        writer(level, k, v)
        if type(v) == "table" then
	    local seen = false
	    for n = 1, #path do
	        if path[n] == v then
		    seen = true
		end
	    end
	    if seen then
	        writer(level+1, "...", "...")
	    else
	        tree(v, writer, path)
	    end
	end
    end
    table.remove(path)
end

local ser = {}

ser.tree = tree

return ser

