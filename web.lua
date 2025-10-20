local serverLocation = settings.get("server.path")
if not serverLocation or type(serverLocation) ~= "string" then
    print("ERROR - Server module path not set !")
end
local server = require(serverLocation)
if not server then
    print("ERROR - Could not load server module !")
end

local app = server.new(80)
local directory = "/landfall-social"

function handleFileEndpoint(endpoint)
    local handle = fs.open(directory .. endpoint ..  ".ccml", "r")
    local status = 200
    local body = ""
    if not handle then status = 404 end
    if handle then
        body = handle.readAll()
    end
    
    return {body = body, contentType = "text/plain", status = 200}

end

app:listen("/", "GET", function(pack)
    local handle = fs.open(directory .. "/index.ccml", "r")
    local status = 200
    local body = ""
    if not handle then status = 404 end
    if handle then
        body = handle.readAll()
    end
    
    return {body = body, contentType = "text/plain", status = 200}
end)
app:listen("/login", "GET", function(pack)
    return handleFileEndpoint("/login")
end)
app:listen("/app", "GET", function(pack)
    return handleFileEndpoint("/app")
end)

app:run()