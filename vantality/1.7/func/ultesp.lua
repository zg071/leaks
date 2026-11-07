-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local players = game:GetService('Players')
local coreGui = (gethui and gethui()) or game:GetService('CoreGui')
local runService = game:GetService('RunService')
local tweenService = game:GetService('TweenService')
local localPlayer = players.LocalPlayer

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if (v8.ExecutorUltESP and (typeof(v8.ExecutorUltESP.Destroy) == 'function')) then
    local v95 = 0

    while true do
        if (v95 == 0) then
            pcall(function()
                v8.ExecutorUltESP:Destroy()
            end)
            task.wait(0.1)

            break
        end
    end
end

v8.ExecutorUltESP = {}

local executorUltESP = v8.ExecutorUltESP
local executorUltESPV8Scaled = 'ExecutorUltESP_v8_Scaled'

executorUltESP.Settings = {
    Enabled = false,
    RenderDistance = 150,
    BarPosition = 'Right',
    BarWidth = 6,
    BarHeight = 4.5,
    BarOffset = 3.5,
    ColorFill = Color3.fromRGB(255, 255, 255),
    ColorBackground = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0,
    TextEnabled = true,
    TextPosition = 'Top',
    TextSize = 12,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextStrokeColor = Color3.fromRGB(0, 0, 0),
    TextStrokeTransparency = 0,
    AttributeName = 'Ultimate',
}

local settings = executorUltESP.Settings

executorUltESP.State = {
    isEnabled = false,
    Cache = {},
    ScreenGui = nil,
    Connection = nil,
}

local state = executorUltESP.State

local function v21()
    local v33 = 0
    local v34
    local screenGui
    local playerGui

    while true do
        if (v33 == 0) then
            v34 = 0
            screenGui = nil
            v33 = 1
        end
        if (v33 == 1) then
            playerGui = nil

            while true do
                if (v34 == 0) then
                    if (state.ScreenGui and state.ScreenGui.Parent) then
                        return state.ScreenGui
                    end

                    screenGui = Instance.new('ScreenGui')
                    screenGui.Name = executorUltESPV8Scaled .. '_Storage'
                    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    v34 = 1
                end
                if (v34 == 2) then
                    if playerGui then
                        screenGui.Parent = playerGui
                    end

                    state.ScreenGui = screenGui

                    return screenGui
                end
                if (v34 == 1) then
                    screenGui.ResetOnSpawn = false
                    screenGui.IgnoreGuiInset = true
                    screenGui.DisplayOrder = 2147483643
                    playerGui = (localPlayer and localPlayer:FindFirstChildOfClass('PlayerGui')) or coreGui
                    v34 = 2
                end
            end

            break
        end
    end
end
local function v22(v37, v38)
    local v39 = 0
    local billboardGui
    local frame
    local uIStroke
    local frame2
    local textLabel

    while true do
        if (v39 == 3) then
            frame.BorderSizePixel = 0
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Position = UDim2.fromScale(0.5, 0.5)
            v39 = 4
        end
        if (v39 == 8) then
            local v110 = 0

            while true do
                if (v110 == 1) then
                    textLabel.Text = '0%'
                    v39 = 9

                    break
                end
                if (0 == v110) then
                    textLabel.Size = UDim2.fromScale(1, 1)
                    textLabel.Font = Enum.Font.GothamBold
                    v110 = 1
                end
            end
        end
        if (v39 == 0) then
            if state.Cache[v37] then
                return state.Cache[v37]
            end

            billboardGui = Instance.new('BillboardGui')
            billboardGui.Name = 'UltBar_' .. v37.Name
            v39 = 1
        end
        if (v39 == 6) then
            frame2.Parent = frame
            frame2.BorderSizePixel = 0
            textLabel = Instance.new('TextLabel')
            v39 = 7
        end
        if (v39 == 7) then
            textLabel.Name = 'Value'
            textLabel.Parent = frame
            textLabel.BackgroundTransparency = 1
            v39 = 8
        end
        if (v39 == 4) then
            uIStroke = Instance.new('UIStroke')
            uIStroke.Parent = frame
            uIStroke.Thickness = 1
            v39 = 5
        end
        if (9 == v39) then
            local v119 = 0

            while true do
                if (v119 == 0) then
                    state.Cache[v37] = {
                        GUI = billboardGui,
                        Fill = frame2,
                        BG = frame,
                        Text = textLabel,
                        Adornee = v38,
                        TargetSize = UDim2.new(),
                        ValueCache = nil,
                    }

                    return state.Cache[v37]
                end
            end
        end
        if (5 == v39) then
            uIStroke.Color = Color3.fromRGB(0, 0, 0)
            frame2 = Instance.new('Frame')
            frame2.Name = 'Fill'
            v39 = 6
        end
        if (v39 == 1) then
            local v122 = 0
            local v123

            while true do
                if (v122 == 0) then
                    v123 = 0

                    while true do
                        if (1 == v123) then
                            billboardGui.Parent = v21()
                            v39 = 2

                            break
                        end
                        if (v123 == 0) then
                            billboardGui.Adornee = v38
                            billboardGui.AlwaysOnTop = true
                            v123 = 1
                        end
                    end

                    break
                end
            end
        end
        if (v39 == 2) then
            frame = Instance.new('Frame')
            frame.Name = 'BG'
            frame.Parent = billboardGui
            v39 = 3
        end
    end
end
local function v23(v45, v46, v47, v48)
    local gUI = v45.GUI
    local bG = v45.BG
    local fill = v45.Fill
    local text = v45.Text
    local mathClamp = math.clamp(40 / v46, 0.4, 1.5)
    local v54 = settings.BarWidth * mathClamp
    local v55 = settings.BarHeight * mathClamp
    local v56 = settings.BarOffset * mathClamp
    local mathMax = math.max(8, settings.TextSize * mathClamp)
    local v58 = (settings.BarPosition == 'Top') or (settings.BarPosition == 'Bottom')

    if (settings.BarPosition == 'Right') then
        gUI.StudsOffset = Vector3.new(v56, 0, 0)
    elseif (settings.BarPosition == 'Left') then
        gUI.StudsOffset = Vector3.new(-v56, 0, 0)
    elseif (settings.BarPosition == 'Top') then
        gUI.StudsOffset = Vector3.new(0, v56, 0)
    elseif (settings.BarPosition == 'Bottom') then
        gUI.StudsOffset = Vector3.new(0, -v56, 0)
    end
    if v58 then
        local v99 = 0
        local v100

        while true do
            if (v99 == 0) then
                v100 = 0

                while true do
                    if (v100 == 0) then
                        gUI.Size = UDim2.new(0, v55 * 20, 0, v54 * 5)
                        bG.Size = UDim2.new(0, v55 * 20, 0, v54)
                        v100 = 1
                    end
                    if (1 == v100) then
                        fill.AnchorPoint = Vector2.new(0, 0)
                        fill.Position = UDim2.fromScale(0, 0)
                        v100 = 2
                    end
                    if (v100 == 2) then
                        v45.TargetSize = UDim2.new(v47, 0, 1, 0)

                        break
                    end
                end

                break
            end
        end
    else
        gUI.Size = UDim2.new(0, v54 * 5, 0, v55 * 20)
        bG.Size = UDim2.new(0, v54, 0, v55 * 20)
        fill.AnchorPoint = Vector2.new(0, 1)
        fill.Position = UDim2.fromScale(0, 1)
        v45.TargetSize = UDim2.new(1, 0, v47, 0)
    end

    bG.BackgroundColor3 = settings.ColorBackground
    bG.BackgroundTransparency = settings.BackgroundTransparency
    fill.BackgroundColor3 = settings.ColorFill
    text.TextColor3 = settings.TextColor
    text.TextSize = mathMax
    text.TextStrokeColor3 = settings.TextStrokeColor
    text.TextStrokeTransparency = settings.TextStrokeTransparency
    text.Visible = settings.TextEnabled

    if settings.TextEnabled then
        text.Text = math.floor(v48) .. '%'

        if (settings.TextPosition == 'Inside') then
            local v137 = 0

            while true do
                if (v137 == 0) then
                    text.AnchorPoint = Vector2.new(0.5, 0.5)
                    text.Position = UDim2.fromScale(0.5, 0.5)

                    break
                end
            end
        elseif (settings.TextPosition == 'Top') then
            local v160 = 0

            while true do
                if (v160 == 0) then
                    text.AnchorPoint = Vector2.new(0.5, 1)
                    text.Position = UDim2.new(0.5, 0, 0, -2)

                    break
                end
            end
        elseif (settings.TextPosition == 'Bottom') then
            local v173 = 0

            while true do
                if (v173 == 0) then
                    text.AnchorPoint = Vector2.new(0.5, 0)
                    text.Position = UDim2.new(0.5, 0, 1, 2)

                    break
                end
            end
        elseif (settings.TextPosition == 'Left') then
            text.AnchorPoint = Vector2.new(1, 0.5)
            text.Position = UDim2.new(0, -2, 0.5, 0)
        elseif (settings.TextPosition == 'Right') then
            local v194 = 0

            while true do
                if (v194 == 0) then
                    text.AnchorPoint = Vector2.new(0, 0.5)
                    text.Position = UDim2.new(1, 2, 0.5, 0)

                    break
                end
            end
        end
    end
end
local function v24(v74, v75, v76)
    local v77 = 0
    local value
    local value2
    local child

    while true do
        if (v77 == 2) then
            if value2 then
                return value2
            end

            child = v75:FindFirstChild(settings.AttributeName)
            v77 = 3
        end
        if (v77 == 1) then
            if value then
                return value
            end

            value2 = v74:GetAttribute(settings.AttributeName)
            v77 = 2
        end
        if (v77 == 3) then
            if (child and child:IsA('ValueBase')) then
                local v142 = 0

                while true do
                    if (v142 == 0) then
                        local v174 = 0
                        local v175

                        while true do
                            if (0 == v174) then
                                v175 = 0

                                while true do
                                    if (v175 == 0) then
                                        v76.ValueCache = child

                                        return child.Value
                                    end
                                end

                                break
                            end
                        end
                    end
                end
            end

            return 0
        end
        if (v77 == 0) then
            if (v76.ValueCache and v76.ValueCache.Parent) then
                return v76.ValueCache.Value
            end

            value = v75:GetAttribute(settings.AttributeName)
            v77 = 1
        end
    end
end
local function v25()
    if not state.isEnabled then
        return
    end

    local currentCamera = workspace.CurrentCamera

    if not currentCamera then
        return
    end

    local position = currentCamera.CFrame.Position

    for v96, v97 in ipairs(players:GetPlayers())do
        if (v97 ~= localPlayer) then
            local character = v97.Character
            local humanoidRootPart = character and character:FindFirstChild('HumanoidRootPart')
            local humanoid = character and character:FindFirstChildOfClass('Humanoid')

            if (character and humanoidRootPart and humanoid and (humanoid.Health > 0)) then
                local v143 = 0
                local magnitude

                while true do
                    if (v143 == 0) then
                        magnitude = (humanoidRootPart.Position - position).Magnitude

                        if (magnitude <= settings.RenderDistance) then
                            local v186 = 0
                            local v187
                            local v22_2
                            local v24_2
                            local toNumber
                            local mathClamp

                            while true do
                                if (2 == v186) then
                                    mathClamp = nil

                                    while true do
                                        if (0 == v187) then
                                            v22_2 = v22(v97, humanoidRootPart)

                                            if (v22_2.Adornee ~= humanoidRootPart) then
                                                local v200 = 0

                                                while true do
                                                    if (v200 == 1) then
                                                        v22_2.ValueCache = nil

                                                        break
                                                    end
                                                    if (0 == v200) then
                                                        v22_2.GUI.Adornee = humanoidRootPart
                                                        v22_2.Adornee = humanoidRootPart
                                                        v200 = 1
                                                    end
                                                end
                                            end

                                            v187 = 1
                                        end
                                        if (2 == v187) then
                                            mathClamp = math.clamp(toNumber, 0, 100) / 100

                                            v23(v22_2, magnitude, mathClamp, toNumber)

                                            v187 = 3
                                        end
                                        if (v187 == 1) then
                                            v24_2 = v24(v97, character, v22_2)
                                            toNumber = tonumber(v24_2) or 0
                                            v187 = 2
                                        end
                                        if (v187 == 3) then
                                            tweenService:Create(v22_2.Fill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                                                Size = v22_2.TargetSize,
                                            }):Play()

                                            v22_2.GUI.Enabled = true

                                            break
                                        end
                                    end

                                    break
                                end
                                if (v186 == 0) then
                                    v187 = 0
                                    v22_2 = nil
                                    v186 = 1
                                end
                                if (v186 == 1) then
                                    v24_2 = nil
                                    toNumber = nil
                                    v186 = 2
                                end
                            end
                        elseif state.Cache[v97] then
                            state.Cache[v97].GUI.Enabled = false
                        end

                        break
                    end
                end
            elseif state.Cache[v97] then
                state.Cache[v97].GUI.Enabled = false
            end
        end
    end
end

executorUltESP.Enable = function(v83)
    local v84 = 0

    while true do
        if (1 == v84) then
            state.isEnabled = true

            v21()

            v84 = 2
        end
        if (v84 == 0) then
            if state.isEnabled then
                return
            end

            settings.Enabled = true
            v84 = 1
        end
        if (v84 == 2) then
            state.Connection = runService.RenderStepped:Connect(v25)

            break
        end
    end
end
executorUltESP.Disable = function(v85)
    local v86 = 0

    while true do
        if (v86 == 2) then
            for v138, v139 in pairs(state.Cache)do
                if v139.GUI then
                    v139.GUI.Enabled = false
                end
            end

            break
        end
        if (0 == v86) then
            if not state.isEnabled then
                return
            end

            settings.Enabled = false
            v86 = 1
        end
        if (v86 == 1) then
            state.isEnabled = false

            if state.Connection then
                local v145 = 0

                while true do
                    if (v145 == 0) then
                        state.Connection:Disconnect()

                        state.Connection = nil

                        break
                    end
                end
            end

            v86 = 2
        end
    end
end
executorUltESP.UpdateSetting = function(v87, v88, v89)
    local v90 = 0
    local v91

    while true do
        if (v90 == 0) then
            v91 = 0

            while true do
                if (v91 == 0) then
                    if (settings[v88] == nil) then
                        return
                    end

                    settings[v88] = v89

                    break
                end
            end

            break
        end
    end
end
executorUltESP.Destroy = function(v92)
    local v93 = 0

    while true do
        if (v93 == 1) then
            state.Cache = {}

            if state.ScreenGui then
                local v146 = 0

                while true do
                    if (v146 == 0) then
                        state.ScreenGui:Destroy()

                        state.ScreenGui = nil

                        break
                    end
                end
            end

            v93 = 2
        end
        if (v93 == 0) then
            v92:Disable()

            for v140, v141 in pairs(state.Cache)do
                if v141.GUI then
                    v141.GUI:Destroy()
                end
            end

            v93 = 1
        end
        if (v93 == 2) then
            v8.ExecutorUltESP = nil

            break
        end
    end
end

if settings.Enabled then
    executorUltESP:Enable()
end

return executorUltESP
