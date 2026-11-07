local Env = getgenv and getgenv() or _G

if Env.LuauAPI then
    Env.LuauAPI:UnloadAll()
    Env.LuauAPI = nil
end

local LuauAPI = {}
Env.LuauAPI = LuauAPI

local HttpService = game:GetService("HttpService")

local FileSystem = {
    Root = "Vantality",
    Scripts = "Vantality/scripts",
    Configs = "Vantality/scripts/configs"
}

if not isfolder(FileSystem.Root) then makefolder(FileSystem.Root) end
if not isfolder(FileSystem.Scripts) then makefolder(FileSystem.Scripts) end
if not isfolder(FileSystem.Configs) then makefolder(FileSystem.Configs) end

local State = {
    LoadedScripts = {},
    GUIColumns = {}, 
    Notifier = nil,
    TabRef = nil,
    ListBoxRef = nil,
    ListBoxFrame = nil 
}

local function GetFiles()
    local t = {}
    local dirPath = string.gsub(FileSystem.Scripts, "\\", "/")
    
    if not isfolder(dirPath) then return t end

    local list = listfiles(dirPath)
    
    if type(list) == "table" then
        for _, v in pairs(list) do
            local normPath = string.gsub(v, "\\", "/")
            local file = string.match(normPath, "[^/]+$") or normPath

            if file ~= "configs" and not string.find(normPath, "configs/") and file ~= ".refresh_cache" and file ~= "" then
                table.insert(t, file)
            end
        end
    end
    
    table.sort(t)
    return t
end

local function ForceListBoxSize()
    if State.ListBoxFrame then
        State.ListBoxFrame.Size = UDim2.new(1, 0, 0, 226)
        State.ListBoxFrame.ClipsDescendants = true
        
        local scroll = State.ListBoxFrame:FindFirstChild("ScrollingFrame")
        if scroll then
            scroll.Size = UDim2.new(1, 0, 1, -40)
            scroll.Position = UDim2.new(0, 0, 0, 40)
        end
    end
end

local function ResolveContainers()
    local MainGui = Env.ahkgbs_instance and Env.ahkgbs_instance.Main
    if not MainGui then return false end

    for _, obj in pairs(MainGui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Text == "SCRIPTS" and obj.Visible then
            local ListBoxFrame = obj.Parent
            
            if ListBoxFrame then
                State.ListBoxFrame = ListBoxFrame
                
                ForceListBoxSize()
                ListBoxFrame:GetPropertyChangedSignal("Size"):Connect(ForceListBoxSize)
                
                local CurrentColumn = ListBoxFrame.Parent
                if CurrentColumn then
                    local MenuContainer = CurrentColumn.Parent
                    if MenuContainer then
                        for _, col in pairs(MenuContainer:GetChildren()) do
                            if col:IsA("ScrollingFrame") then
                                local x = col.Position.X.Scale
                                if math.abs(x - 0.5) < 0.05 then
                                    State.GUIColumns["Center"] = col
                                elseif math.abs(x - 0.825) < 0.05 then
                                    State.GUIColumns["Right"] = col
                                end
                            end
                        end
                    end
                end
            end
            
            if State.GUIColumns["Center"] and State.GUIColumns["Right"] then
                return true
            end
        end
    end
    return false
end

local function GetOptimalColumn()
    local cCol = State.GUIColumns["Center"]
    local rCol = State.GUIColumns["Right"]
    if not cCol or not rCol then return "Center" end

    local function count(container)
        local c = 0
        for _, child in pairs(container:GetChildren()) do
            if child:IsA("Frame") and child.Visible then c = c + 1 end
        end
        return c
    end

    return count(cCol) <= count(rCol) and "Center" or "Right"
end

local function SaveScriptConfig(name)
    local data = State.LoadedScripts[name]
    if not data or not data.ConfigRegistry then return end

    local cfgToSave = {}
    for key, element in pairs(data.ConfigRegistry) do
        if element.GetValue then
            local val = element:GetValue()
            if typeof(val) == "table" and val.Color and val.Transparency then
                cfgToSave[key] = {
                    __type = "ColorPicker",
                    R = val.Color.R, G = val.Color.G, B = val.Color.B,
                    Transparency = val.Transparency
                }
            elseif typeof(val) == "Color3" then
                cfgToSave[key] = { __type = "Color3", R = val.R, G = val.G, B = val.B }
            elseif typeof(val) == "EnumItem" then
                cfgToSave[key] = { __type = "Enum", Name = val.Name }
            else
                cfgToSave[key] = val
            end
        end
    end

    local success, json = pcall(HttpService.JSONEncode, HttpService, cfgToSave)
    if success then 
        local path = string.gsub(FileSystem.Configs .. "/" .. name .. ".json", "\\", "/")
        if type(writefile) == "function" then
            writefile(path, json)
        elseif type(appendfile) == "function" then
            if isfile(path) then delfile(path) end
            appendfile(path, json)
        end
    end
end

local function LoadScriptConfig(name)
    local pathWithExt = string.gsub(FileSystem.Configs .. "/" .. name .. ".json", "\\", "/")
    local pathNoExt = string.gsub(FileSystem.Configs .. "/" .. name, "\\", "/")
    local targetPath = isfile(pathWithExt) and pathWithExt or pathNoExt
    
    if targetPath and isfile(targetPath) then
        local content = readfile(targetPath)
        if type(content) == "string" and content ~= "" then
            local success, decoded = pcall(HttpService.JSONDecode, HttpService, content)
            if success and type(decoded) == "table" then return decoded end
        end
    end
    return {}
end

local function CreateSandboxedEnv(apiObject)
    local envTable = {
        Vantality = apiObject,
        script = { Name = "VantalityScript" }
    }
    local UserEnv = setmetatable(envTable, {
        __index = function(self, key) return Env[key] or getfenv()[key] end,
        __newindex = function(self, key, value) getfenv()[key] = value end
    })
    return UserEnv
end

function LuauAPI:UnloadScript(name)
    local data = State.LoadedScripts[name]
    if not data then return end

    pcall(SaveScriptConfig, name)

    if data.Connections then
        for _, conn in pairs(data.Connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
    end

    if data.SectionFrame and data.SectionFrame.Parent then
        data.SectionFrame:Destroy()
    end

    if data.Env and data.Env.OnUnload and type(data.Env.OnUnload) == "function" then
        pcall(data.Env.OnUnload)
    end

    State.LoadedScripts[name] = nil
    if State.ListBoxRef and State.ListBoxRef.Refresh then State.ListBoxRef:Refresh() end
end

function LuauAPI:UnloadAll()
    for name, _ in pairs(State.LoadedScripts) do self:UnloadScript(name) end
end

function LuauAPI:Execute(name, code)
    if State.LoadedScripts[name] then
        if State.Notifier then State.Notifier:Notify({Title="Luau", Content="Script already running!", Icon="alert-circle"}) end
        return
    end

    local LoadedConfig = LoadScriptConfig(name)
    local ScriptData = { Connections = {}, SectionFrame = nil, ConfigRegistry = {}, Env = nil }
    local API_Proxy = {}
    
    local function CreateContainerProxy(RealContainer)
        local Proxy = {}
        local function WrapElement(funcName, config)
            local key = config.Flag or config.Name
            local savedVal = LoadedConfig[key]
            if savedVal ~= nil then
                if type(savedVal) == "table" and savedVal.__type == "ColorPicker" then
                    config.Default = Color3.new(savedVal.R, savedVal.G, savedVal.B)
                    config.Transparency = savedVal.Transparency
                elseif type(savedVal) == "table" and savedVal.__type == "Color3" then
                    config.Default = Color3.new(savedVal.R, savedVal.G, savedVal.B)
                elseif type(savedVal) == "table" and savedVal.__type == "Enum" then
                    config.Default = savedVal.Name 
                else
                    config.Default = savedVal
                end
            end
            local Element = RealContainer[funcName](RealContainer, config)
            if Element and key then ScriptData.ConfigRegistry[key] = Element end
            
            return setmetatable({}, {
                __index = function(_, k)
                    local v = Element[k]
                    if k == "Option" and v then return CreateContainerProxy(v) end
                    return v
                end,
                __newindex = function(_, k, v) Element[k] = v end
            })
        end
        function Proxy:AddToggle(cfg) return WrapElement("AddToggle", cfg) end
        function Proxy:AddSlider(cfg) return WrapElement("AddSlider", cfg) end
        function Proxy:AddDropdown(cfg) return WrapElement("AddDropdown", cfg) end
        function Proxy:AddColorPicker(cfg) return WrapElement("AddColorPicker", cfg) end
        function Proxy:AddKeybind(cfg) return WrapElement("AddKeybind", cfg) end
        function Proxy:AddInput(cfg) return WrapElement("AddInput", cfg) end
        function Proxy:AddButton(cfg) return RealContainer:AddButton(cfg) end
        function Proxy:AddParagraph(cfg) return RealContainer:AddParagraph(cfg) end
        return Proxy
    end
    
    function API_Proxy.CreateSection(title)
        local colKey = GetOptimalColumn()
        local guiContainer = State.GUIColumns[colKey]
        if not guiContainer then
            ResolveContainers()
            guiContainer = State.GUIColumns[colKey]
            if not guiContainer then return nil end
        end
        
        local oldChildren = guiContainer:GetChildren()
        local RealSection = State.TabRef:AddSection({ Name = tostring(title), Position = colKey:lower() })
        local newChildren = guiContainer:GetChildren()
        
        for _, child in pairs(newChildren) do
            local isNew = true
            for _, old in pairs(oldChildren) do if old == child then isNew = false break end end
            if isNew then ScriptData.SectionFrame = child break end
        end
        return CreateContainerProxy(RealSection)
    end

    function API_Proxy.Bind(signal, callback)
        local conn = signal:Connect(callback)
        table.insert(ScriptData.Connections, conn)
        return conn
    end

    function API_Proxy.Notify(cfg) if State.Notifier then State.Notifier:Notify(cfg) end end

    State.LoadedScripts[name] = ScriptData
    local func, err = loadstring(code, name)
    if not func then
        warn("[Vantality Luau] Syntax Error:", err)
        if State.Notifier then State.Notifier:Notify({Title="Error", Content="Syntax Error", Icon="alert-triangle"}) end
        State.LoadedScripts[name] = nil
        return
    end

    local Sandbox = CreateSandboxedEnv(API_Proxy)
    setfenv(func, Sandbox)
    ScriptData.Env = Sandbox

    local s, r = pcall(func)
    if not s then
        warn("[Vantality Luau] Runtime Error:", r)
        if State.Notifier then State.Notifier:Notify({Title="Error", Content="Runtime Error (F9)", Icon="alert-circle"}) end
        self:UnloadScript(name)
    else
        if State.Notifier then State.Notifier:Notify({Title="Luau", Content="Loaded: "..name, Icon="check"}) end
    end
end

function LuauAPI:Init(Tab, IgnoredSection, NotifierObj)
    State.TabRef = Tab
    State.Notifier = NotifierObj
    
    if Tab.Root then
        State.GUIColumns["Center"] = Tab.Root:FindFirstChild("Center")
        State.GUIColumns["Right"]  = Tab.Root:FindFirstChild("Right")
    end
    
    local SelectedFile = nil

    State.ListBoxRef = Tab:AddListBox({
        Name = "SCRIPTS",
        Position = "left",
        Height = 226, 
        Values = GetFiles(),
        Multi = false,
        Callback = function(val) SelectedFile = val end
    })

    task.delay(0.5, function() ResolveContainers() end)

    local ControlSection = Tab:AddSection({ Name = " ", Position = "left" })

    ControlSection:AddButton({
        Name = "Load",
        Callback = function()
            if not SelectedFile then return end
            local path = string.gsub(FileSystem.Scripts .. "/" .. SelectedFile, "\\", "/")
            if isfile(path) then
                LuauAPI:Execute(SelectedFile, readfile(path))
            else
                if State.Notifier then State.Notifier:Notify({Title="Error", Content="File not found", Icon="x"}) end
                State.ListBoxRef:SetValues(GetFiles())
                State.ListBoxRef:Refresh()
                SelectedFile = nil
            end
        end
    })

    ControlSection:AddButton({
        Name = "Unload",
        Callback = function()
            if not SelectedFile then return end
            if State.LoadedScripts[SelectedFile] then
                LuauAPI:UnloadScript(SelectedFile)
                if State.Notifier then State.Notifier:Notify({Title="Luau", Content="Unloaded: "..SelectedFile, Icon="trash"}) end
            else
                if State.Notifier then State.Notifier:Notify({Title="Luau", Content="Script is not loaded", Icon="info"}) end
            end
        end
    })

    ControlSection:AddButton({
        Name = "Refresh List",
        Callback = function()
            State.ListBoxRef:SetValues(GetFiles())
            State.ListBoxRef:Refresh()
            SelectedFile = nil
            if State.Notifier then State.Notifier:Notify({Title="Luau", Content="List Refreshed", Icon="refresh-cw"}) end
        end
    })

    ControlSection:AddButton({
        Name = "Delete File",
        Risky = true,
        Callback = function()
            if SelectedFile then
                local cachedName = SelectedFile
                local path = string.gsub(FileSystem.Scripts .. "/" .. cachedName, "\\", "/")
                
                LuauAPI:UnloadScript(cachedName)
                
                if isfile(path) then
                    delfile(path)
                end
                
                local files = GetFiles()
                local newList = {}
                
                for _, v in pairs(files) do
                    if v ~= cachedName then 
                        table.insert(newList, v) 
                    end
                end
                
                State.ListBoxRef:SetValues(newList)
                State.ListBoxRef:Refresh()
                
                SelectedFile = nil
                if State.Notifier then State.Notifier:Notify({Title="Luau", Content="Deleted: "..cachedName, Icon="trash-2"}) end
            end
        end
    })

    ControlSection:AddButton({
        Name = "Marketplace",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/jMNZdARm"))()
        end
    })
end

return LuauAPI
