-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local players = game:GetService('Players')
local runService = game:GetService('RunService')
local stats = game:GetService('Stats')
local localPlayer = players.LocalPlayer

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if (v8.ExecutorOverlay and (typeof(v8.ExecutorOverlay.Destroy) == 'function')) then
    pcall(function()
        v8.ExecutorOverlay:Destroy()
    end)
    task.wait(0.1)
end

v8.ExecutorOverlay = {}

local executorOverlay = v8.ExecutorOverlay

executorOverlay.Settings = {
    Enabled = false,
    ShowFPS = true,
    ShowPing = false,
    Position = 'TopLeft',
    Scale = 24,
    TextColor = Color3.fromRGB(255, 255, 255),
}
executorOverlay.State = {
    isEnabled = false,
    frameCount = 0,
    lastTime = 0,
    GUI = nil,
    Container = nil,
    FpsLabel = nil,
    PingLabel = nil,
    Connections = {},
}

local state = executorOverlay.State
local settings = executorOverlay.Settings
local executorOverlayStatsV2 = 'Executor_Overlay_Stats_v2'
local new = {
    TopLeft = {
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 15, 0, 68),
        TextAlign = Enum.TextXAlignment.Left,
        ListAlign = Enum.HorizontalAlignment.Left,
        VertAlign = Enum.VerticalAlignment.Top,
    },
    TopRight = {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -15, 0, 68),
        TextAlign = Enum.TextXAlignment.Right,
        ListAlign = Enum.HorizontalAlignment.Right,
        VertAlign = Enum.VerticalAlignment.Top,
    },
    BottomLeft = {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 15, 1, -15),
        TextAlign = Enum.TextXAlignment.Left,
        ListAlign = Enum.HorizontalAlignment.Left,
        VertAlign = Enum.VerticalAlignment.Bottom,
    },
    BottomRight = {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -15, 1, -15),
        TextAlign = Enum.TextXAlignment.Right,
        ListAlign = Enum.HorizontalAlignment.Right,
        VertAlign = Enum.VerticalAlignment.Bottom,
    },
}

local function v21()
    local pcallOk, v34 = pcall(function()
        return gethui()
    end)

    if (pcallOk and v34) then
        return v34
    end

    local coreGui, v36 = pcall(function()
        return game:GetService('CoreGui')
    end)

    if (coreGui and v36) then
        return v36
    end

    return localPlayer:WaitForChild('PlayerGui', 5)
end
local function v22(v37, v38)
    local v39 = 0
    local textLabel

    while true do
        if (v39 == 4) then
            local v66 = 0

            while true do
                if (v66 == 0) then
                    textLabel.Parent = v38

                    return textLabel
                end
            end
        end
        if (v39 == 1) then
            textLabel.BackgroundTransparency = 1
            textLabel.AutomaticSize = Enum.AutomaticSize.XY
            v39 = 2
        end
        if (2 == v39) then
            textLabel.Font = Enum.Font.GothamBold
            textLabel.Text = 'Waiting...'
            v39 = 3
        end
        if (3 == v39) then
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            v39 = 4
        end
        if (v39 == 0) then
            textLabel = Instance.new('TextLabel')
            textLabel.Name = v37
            v39 = 1
        end
    end
end
local function v23()
    local v41 = 0
    local topLeft
    local uIListLayout
    local v44

    while true do
        if (v41 == 1) then
            local v76 = 0

            while true do
                if (v76 == 2) then
                    v41 = 2

                    break
                end
                if (v76 == 0) then
                    uIListLayout = state.Container:FindFirstChildOfClass('UIListLayout')

                    if uIListLayout then
                        local v127 = 0
                        local v128

                        while true do
                            if (v127 == 0) then
                                v128 = 0

                                while true do
                                    if (v128 == 0) then
                                        uIListLayout.HorizontalAlignment = topLeft.ListAlign
                                        uIListLayout.VerticalAlignment = topLeft.VertAlign

                                        break
                                    end
                                end

                                break
                            end
                        end
                    end

                    v76 = 1
                end
                if (v76 == 1) then
                    v44 = nil

                    function v44(v126)
                        if v126 then
                            v126.TextSize = settings.Scale
                            v126.TextColor3 = settings.TextColor
                            v126.TextXAlignment = topLeft.TextAlign
                        end
                    end

                    v76 = 2
                end
            end
        end
        if (v41 == 2) then
            v44(state.FpsLabel)
            v44(state.PingLabel)

            if state.FpsLabel then
                state.FpsLabel.Visible = settings.ShowFPS
            end
            if state.PingLabel then
                state.PingLabel.Visible = settings.ShowPing
            end

            break
        end
        if (0 == v41) then
            if not state.Container then
                return
            end

            topLeft = new[settings.Position] or new.TopLeft
            state.Container.AnchorPoint = topLeft.AnchorPoint
            state.Container.Position = topLeft.Position
            v41 = 1
        end
    end
end
local function v24()
    local v45 = 0
    local v21_2
    local screenGui
    local frame
    local uIListLayout

    while true do
        if (v45 == 2) then
            local v81 = 0

            while true do
                if (v81 == 1) then
                    screenGui.DisplayOrder = 2147483647
                    v45 = 3

                    break
                end
                if (v81 == 0) then
                    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
                    screenGui.IgnoreGuiInset = true
                    v81 = 1
                end
            end
        end
        if (v45 == 4) then
            local v82 = 0

            while true do
                if (v82 == 1) then
                    frame.Parent = screenGui
                    v45 = 5

                    break
                end
                if (v82 == 0) then
                    frame.BackgroundTransparency = 1
                    frame.AutomaticSize = Enum.AutomaticSize.XY
                    v82 = 1
                end
            end
        end
        if (v45 == 1) then
            local v83 = 0

            while true do
                if (1 == v83) then
                    screenGui.ResetOnSpawn = false
                    v45 = 2

                    break
                end
                if (v83 == 0) then
                    screenGui = Instance.new('ScreenGui')
                    screenGui.Name = executorOverlayStatsV2
                    v83 = 1
                end
            end
        end
        if (v45 == 3) then
            local v84 = 0

            while true do
                if (v84 == 0) then
                    screenGui.Parent = v21_2
                    frame = Instance.new('Frame')
                    v84 = 1
                end
                if (v84 == 1) then
                    frame.Name = 'Container'
                    v45 = 4

                    break
                end
            end
        end
        if (v45 == 8) then
            state.Container = frame

            v23()

            break
        end
        if (v45 == 6) then
            uIListLayout.Parent = frame
            state.FpsLabel = v22('FPS_Label', frame)
            state.FpsLabel.LayoutOrder = 1
            v45 = 7
        end
        if (0 == v45) then
            if (state.GUI and state.GUI.Parent) then
                return
            end

            v21_2 = v21()

            if not v21_2 then
                return
            end

            v45 = 1
        end
        if (7 == v45) then
            state.PingLabel = v22('Ping_Label', frame)
            state.PingLabel.LayoutOrder = 2
            state.GUI = screenGui
            v45 = 8
        end
        if (v45 == 5) then
            uIListLayout = Instance.new('UIListLayout')
            uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uIListLayout.Padding = UDim.new(0, 2)
            v45 = 6
        end
    end
end
local function v25()
    local v50 = 0
    local osClock
    local lastTime

    while true do
        if (v50 == 0) then
            state.frameCount = state.frameCount + 1
            osClock = os.clock()
            v50 = 1
        end
        if (1 == v50) then
            lastTime = osClock - state.lastTime

            if (lastTime >= 1) then
                local v109 = 0

                while true do
                    if (v109 == 0) then
                        if (state.FpsLabel and settings.ShowFPS) then
                            state.FpsLabel.Text = string.format('FPS: %.1f', state.frameCount / lastTime)
                        end
                        if (state.PingLabel and settings.ShowPing) then
                            local toNumber = 0

                            pcall(function()
                                toNumber = tonumber(stats.Network.ServerStatsItem['Data Ping']:GetValue()) or 0
                            end)

                            state.PingLabel.Text = string.format('Ping: %d ms', toNumber)
                        end

                        v109 = 1
                    end
                    if (v109 == 1) then
                        state.frameCount = 0
                        state.lastTime = osClock

                        break
                    end
                end
            end

            break
        end
    end
end

executorOverlay.Enable = function(v53)
    local v54 = 0

    while true do
        if (v54 == 3) then
            v53.State.Connections.Loop = runService.Heartbeat:Connect(v25)

            break
        end
        if (v54 == 0) then
            if v53.State.isEnabled then
                return
            end

            v53.State.isEnabled = true
            v54 = 1
        end
        if (v54 == 2) then
            v53.State.lastTime = os.clock()
            v53.State.frameCount = 0
            v54 = 3
        end
        if (v54 == 1) then
            v24()

            v53.State.GUI.Enabled = true
            v54 = 2
        end
    end
end
executorOverlay.Disable = function(v55)
    local v56 = 0

    while true do
        if (v56 == 0) then
            if not v55.State.isEnabled then
                return
            end

            v55.State.isEnabled = false
            v56 = 1
        end
        if (v56 == 1) then
            for v103, v104 in pairs(v55.State.Connections)do
                v104:Disconnect()
            end

            v55.State.Connections = {}
            v56 = 2
        end
        if (v56 == 2) then
            if v55.State.GUI then
                v55.State.GUI.Enabled = false
            end

            break
        end
    end
end
executorOverlay.UpdateSetting = function(v57, v58, v59)
    local v60 = 0
    local v61

    while true do
        if (v60 == 0) then
            v61 = 0

            while true do
                if (v61 == 1) then
                    v57.Settings[v58] = v59

                    if v57.State.isEnabled then
                        v23()
                    end

                    break
                end
                if (v61 == 0) then
                    if (v57.Settings[v58] == nil) then
                        return
                    end
                    if ((v58 == 'TextColor') and (typeof(v59) ~= 'Color3')) then
                        return
                    end

                    v61 = 1
                end
            end

            break
        end
    end
end
executorOverlay.Destroy = function(v62)
    local v63 = 0
    local v64

    while true do
        if (v63 == 0) then
            v64 = 0

            while true do
                if (v64 == 1) then
                    v8.ExecutorOverlay = nil

                    break
                end
                if (0 == v64) then
                    v62:Disable()

                    if v62.State.GUI then
                        v62.State.GUI:Destroy()
                    end

                    v64 = 1
                end
            end

            break
        end
    end
end

return executorOverlay
