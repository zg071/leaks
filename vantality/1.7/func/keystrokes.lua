-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local userInputService = game:GetService('UserInputService')
local tweenService = game:GetService('TweenService')
local players = game:GetService('Players')
local localPlayer = players.LocalPlayer

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if (v8.ExecutorKeystrokes and (typeof(v8.ExecutorKeystrokes.Destroy) == 'function')) then
    local v97 = 0
    local v98

    while true do
        if (v97 == 0) then
            v98 = 0

            while true do
                if (v98 == 0) then
                    pcall(function()
                        v8.ExecutorKeystrokes:Destroy()
                    end)
                    task.wait(0.1)

                    break
                end
            end

            break
        end
    end
end

v8.ExecutorKeystrokes = {}

local executorKeystrokes = v8.ExecutorKeystrokes

executorKeystrokes.Settings = {
    Enabled = false,
    Position = 'BottomLeft',
    Scale = 1,
    FadeSpeed = 0.3,
    IdleColor = Color3.fromRGB(24, 24, 24),
    PressedColor = Color3.fromRGB(255, 106, 133),
    TextColor = Color3.fromRGB(255, 255, 255),
    StrokeColor = Color3.fromRGB(29, 29, 29),
    VisibleKeys = {
        ['1'] = true,
        ['2'] = true,
        ['3'] = true,
        ['4'] = true,
        Q = true,
        W = true,
        A = true,
        S = true,
        D = true,
        F = true,
        SPACE = true,
        M1 = true,
    },
}

local settings = executorKeystrokes.Settings

executorKeystrokes.State = {
    GUI = nil,
    Container = nil,
    UIScale = nil,
    Keys = {},
    Connections = {},
}

local state = executorKeystrokes.State
local executorKeystrokesOverlay = 'Executor_Keystrokes_Overlay'
local new = {
    TopLeft = {
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 15, 0, 68),
    },
    TopRight = {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -15, 0, 68),
    },
    TopCenter = {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 68),
    },
    BottomLeft = {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 15, 1, -15),
    },
    BottomRight = {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -15, 1, -15),
    },
}
local v21 = {
    [Enum.KeyCode.One] = '1',
    [Enum.KeyCode.Two] = '2',
    [Enum.KeyCode.Three] = '3',
    [Enum.KeyCode.Four] = '4',
    [Enum.KeyCode.Q] = 'Q',
    [Enum.KeyCode.W] = 'W',
    [Enum.KeyCode.A] = 'A',
    [Enum.KeyCode.S] = 'S',
    [Enum.KeyCode.D] = 'D',
    [Enum.KeyCode.F] = 'F',
    [Enum.KeyCode.Space] = 'SPACE',
    [Enum.UserInputType.MouseButton1] = 'M1',
}
local v22 = {
    ['1'] = {
        c1 = 1,
        c2 = 1,
        r = 1,
    },
    ['2'] = {
        c1 = 2,
        c2 = 2,
        r = 1,
    },
    ['3'] = {
        c1 = 3,
        c2 = 3,
        r = 1,
    },
    ['4'] = {
        c1 = 4,
        c2 = 4,
        r = 1,
    },
    Q = {
        c1 = 1,
        c2 = 1,
        r = 2,
    },
    W = {
        c1 = 2,
        c2 = 2,
        r = 2,
    },
    A = {
        c1 = 1,
        c2 = 1,
        r = 3,
    },
    S = {
        c1 = 2,
        c2 = 2,
        r = 3,
    },
    D = {
        c1 = 3,
        c2 = 3,
        r = 3,
    },
    F = {
        c1 = 4,
        c2 = 4,
        r = 3,
    },
    SPACE = {
        c1 = 1,
        c2 = 2,
        r = 4,
    },
    M1 = {
        c1 = 3,
        c2 = 4,
        r = 4,
    },
}

local function v23()
    local v38 = 0
    local v39
    local pcallOk
    local v41
    local coreGui

    while true do
        if (1 == v38) then
            v41, coreGui = pcall(function()
                return game:GetService('CoreGui')
            end)

            if (v41 and coreGui) then
                return coreGui
            end

            v38 = 2
        end
        if (0 == v38) then
            v39, pcallOk = pcall(function()
                return gethui()
            end)

            if (v39 and pcallOk) then
                return pcallOk
            end

            v38 = 1
        end
        if (v38 == 2) then
            return localPlayer:WaitForChild('PlayerGui', 5)
        end
    end
end
local function v24()
    local v43 = 0
    local v23_2

    while true do
        if (0 == v43) then
            for v159, v160 in pairs(state.Connections)do
                if v160.Connected then
                    v160:Disconnect()
                end
            end

            state.Connections = {}
            v43 = 1
        end
        if (v43 == 2) then
            state.GUI, state.Container, state.UIScale = nil, nil, nil
            v23_2 = v23()
            v43 = 3
        end
        if (v43 == 3) then
            if v23_2 then
                for v178, v179 in ipairs(v23_2:GetChildren())do
                    if (v179.Name == executorKeystrokesOverlay) then
                        v179:Destroy()
                    end
                end
            end

            break
        end
        if (v43 == 1) then
            state.Keys = {}

            if state.GUI then
                state.GUI:Destroy()
            end

            v43 = 2
        end
    end
end
local function v25(v45, v46)
    local v47 = 0
    local frame
    local uICorner
    local uIStroke
    local textLabel

    while true do
        if (v47 == 3) then
            uIStroke.Thickness = 1
            uIStroke.Parent = frame
            textLabel = Instance.new('TextLabel')
            textLabel.Size = UDim2.fromScale(1, 1)
            v47 = 4
        end
        if (v47 == 4) then
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.GothamBold
            textLabel.Text = v46
            textLabel.TextColor3 = settings.TextColor
            v47 = 5
        end
        if (0 == v47) then
            frame = Instance.new('Frame')
            frame.Name = 'Key_' .. v45
            frame.Size = UDim2.fromOffset(40, 40)
            frame.Position = UDim2.fromOffset(0, 0)
            v47 = 1
        end
        if (v47 == 2) then
            uICorner.CornerRadius = UDim.new(0, 4)
            uICorner.Parent = frame
            uIStroke = Instance.new('UIStroke')
            uIStroke.Color = settings.StrokeColor
            v47 = 3
        end
        if (v47 == 1) then
            frame.BackgroundColor3 = settings.IdleColor
            frame.BorderSizePixel = 0
            frame.Visible = settings.VisibleKeys[v45]
            uICorner = Instance.new('UICorner')
            v47 = 2
        end
        if (v47 == 5) then
            textLabel.TextSize = 14
            textLabel.Parent = frame
            frame.Parent = state.Container
            state.Keys[v45] = {
                Frame = frame,
                Label = textLabel,
                Stroke = uIStroke,
                IsPressed = false,
            }

            break
        end
    end
end
local function v26(v52)
    local v53 = 0
    local v54
    local v55
    local v56
    local v57
    local v58
    local v59
    local v60
    local mathMax
    local mathMax2

    while true do
        if (v53 == 4) then
            mathMax = math.max(0, v57 - 4)
            mathMax2 = math.max(0, v59 - 4)

            if v52 then
                state.Container.Size = UDim2.fromOffset(mathMax, mathMax2)
            else
                tweenService:Create(state.Container, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(mathMax, mathMax2),
                }):Play()
            end

            v53 = 5
        end
        if (3 == v53) then
            for v161 = 1, 4 do
                v58[v161] = v59

                if v54[v161] then
                    v59 = v59 + 44
                end
            end

            v60 = nil

            function v60(v163, v164)
                local v165 = 0
                local v166

                while true do
                    if (v165 == 0) then
                        local v187 = 0

                        while true do
                            if (v187 == 0) then
                                v166 = 0

                                for v202 = v163, v164 do
                                    if v55[v202] then
                                        v166 = v166 + 1
                                    end
                                end

                                v187 = 1
                            end
                            if (v187 == 1) then
                                v165 = 1

                                break
                            end
                        end
                    end
                    if (v165 == 1) then
                        if (v166 == 0) then
                            return 0
                        end

                        return (v166 * 40) + ((v166 - 1) * 4)
                    end
                end
            end

            v53 = 4
        end
        if (v53 == 0) then
            if not state.Container then
                return
            end

            v54 = {
                false,
                false,
                false,
                false,
            }
            v55 = {
                false,
                false,
                false,
                false,
            }
            v53 = 1
        end
        if (v53 == 5) then
            for v167, v168 in pairs(v22)do
                local v169 = 0
                local keys

                while true do
                    if (0 == v169) then
                        keys = state.Keys[v167]

                        if keys then
                            local visibleKeys = settings.VisibleKeys[v167]

                            if visibleKeys then
                                local v203 = 0
                                local v204
                                local v205
                                local v60_2

                                while true do
                                    if (v203 == 0) then
                                        keys.Frame.Visible = true
                                        v204 = v56[v168.c1]
                                        v203 = 1
                                    end
                                    if (v203 == 2) then
                                        if v52 then
                                            local v214 = 0

                                            while true do
                                                if (v214 == 0) then
                                                    keys.Frame.Position = UDim2.fromOffset(v204, v205)
                                                    keys.Frame.Size = UDim2.fromOffset(v60_2, 40)

                                                    break
                                                end
                                            end
                                        else
                                            tweenService:Create(keys.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                                Position = UDim2.fromOffset(v204, v205),
                                                Size = UDim2.fromOffset(v60_2, 40),
                                            }):Play()
                                        end

                                        break
                                    end
                                    if (1 == v203) then
                                        local v213 = 0

                                        while true do
                                            if (v213 == 1) then
                                                v203 = 2

                                                break
                                            end
                                            if (0 == v213) then
                                                v205 = v58[v168.r]
                                                v60_2 = v60(v168.c1, v168.c2)
                                                v213 = 1
                                            end
                                        end
                                    end
                                end
                            else
                                keys.Frame.Visible = false
                            end
                        end

                        break
                    end
                end
            end

            break
        end
        if (v53 == 1) then
            for v171, v172 in pairs(v22)do
                if settings.VisibleKeys[v171] then
                    local v180 = 0
                    local v181

                    while true do
                        if (v180 == 0) then
                            v181 = 0

                            while true do
                                if (v181 == 1) then
                                    v55[v172.c2] = true

                                    break
                                end
                                if (0 == v181) then
                                    v54[v172.r] = true
                                    v55[v172.c1] = true
                                    v181 = 1
                                end
                            end

                            break
                        end
                    end
                end
            end

            v56 = {}
            v57 = 0
            v53 = 2
        end
        if (v53 == 2) then
            for v173 = 1, 4 do
                v56[v173] = v57

                if v55[v173] then
                    v57 = v57 + 44
                end
            end

            v58 = {}
            v59 = 0
            v53 = 3
        end
    end
end
local function v27()
    local v63 = 0
    local v23_2
    local screenGui
    local frame
    local uIScale

    while true do
        if (v63 == 3) then
            frame.BackgroundTransparency = 1
            frame.Parent = screenGui
            uIScale = Instance.new('UIScale')
            uIScale.Scale = settings.Scale
            v63 = 4
        end
        if (v63 == 5) then
            for v175, v176 in pairs(v22)do
                v25(v175, v175)
            end

            v26(true)

            break
        end
        if (v63 == 0) then
            v24()

            v23_2 = v23()

            if not v23_2 then
                return
            end

            screenGui = Instance.new('ScreenGui')
            v63 = 1
        end
        if (v63 == 2) then
            screenGui.DisplayOrder = 2147483646
            screenGui.Parent = v23_2
            frame = Instance.new('Frame')
            frame.Name = 'Container'
            v63 = 3
        end
        if (v63 == 1) then
            screenGui.Name = executorKeystrokesOverlay
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            screenGui.IgnoreGuiInset = true
            v63 = 2
        end
        if (v63 == 4) then
            uIScale.Parent = frame
            state.GUI = screenGui
            state.Container = frame
            state.UIScale = uIScale
            v63 = 5
        end
    end
end
local function v28()
    if not state.Container then
        return
    end

    local buttomLeft = new[settings.Position] or new.ButtomLeft

    state.Container.AnchorPoint = buttomLeft.AnchorPoint
    state.Container.Position = buttomLeft.Position

    if state.UIScale then
        state.UIScale.Scale = settings.Scale
    end

    for v99, v100 in pairs(state.Keys)do
        local v101 = 0
        local v102

        while true do
            if (v101 == 0) then
                v102 = 0

                while true do
                    if (v102 == 1) then
                        if not v100.IsPressed then
                            v100.Frame.BackgroundColor3 = settings.IdleColor
                        else
                            v100.Frame.BackgroundColor3 = settings.PressedColor
                        end

                        break
                    end
                    if (v102 == 0) then
                        v100.Stroke.Color = settings.StrokeColor
                        v100.Label.TextColor3 = settings.TextColor
                        v102 = 1
                    end
                end

                break
            end
        end
    end
end
local function v29(v73, v74)
    local v75 = 0
    local v76
    local keys
    local idleColor
    local fadeSpeed

    while true do
        if (v75 == 4) then
            fadeSpeed = (v74 and 0.05) or settings.FadeSpeed

            tweenService:Create(keys.Frame, TweenInfo.new(fadeSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = idleColor}):Play()

            break
        end
        if (v75 == 3) then
            keys.IsPressed = v74
            idleColor = (v74 and settings.PressedColor) or settings.IdleColor
            v75 = 4
        end
        if (v75 == 1) then
            local v153 = 0

            while true do
                if (v153 == 1) then
                    v75 = 2

                    break
                end
                if (v153 == 0) then
                    v76 = nil

                    if (v73.UserInputType == Enum.UserInputType.Keyboard) then
                        v76 = v21[v73.KeyCode]
                    else
                        v76 = v21[v73.UserInputType]
                    end

                    v153 = 1
                end
            end
        end
        if (v75 == 0) then
            if not state.isEnabled then
                return
            end
            if userInputService:GetFocusedTextBox() then
                return
            end

            v75 = 1
        end
        if (v75 == 2) then
            if (not v76 or not state.Keys[v76]) then
                return
            end

            keys = state.Keys[v76]
            v75 = 3
        end
    end
end

executorKeystrokes.Enable = function(v80)
    local v81 = 0
    local v82

    while true do
        if (v81 == 0) then
            v82 = 0

            while true do
                if (v82 == 0) then
                    if state.isEnabled then
                        return
                    end

                    settings.Enabled = true
                    v82 = 1
                end
                if (v82 == 3) then
                    state.Connections.InputEnded = userInputService.InputEnded:Connect(function(
                        v193
                    )
                        v29(v193, false)
                    end)

                    break
                end
                if (v82 == 1) then
                    state.isEnabled = true

                    v27()

                    v82 = 2
                end
                if (v82 == 2) then
                    v28()

                    state.Connections.InputBegan = userInputService.InputBegan:Connect(function(
                        v194
                    )
                        v29(v194, true)
                    end)
                    v82 = 3
                end
            end

            break
        end
    end
end
executorKeystrokes.Disable = function(v83)
    local v84 = 0

    while true do
        if (0 == v84) then
            if not state.isEnabled then
                return
            end

            settings.Enabled = false
            v84 = 1
        end
        if (1 == v84) then
            state.isEnabled = false

            v24()

            break
        end
    end
end
executorKeystrokes.UpdateKeyVisibility = function(v85, v86, v87)
    local v88 = 0
    local v89

    while true do
        if (v88 == 0) then
            v89 = 0

            while true do
                if (v89 == 0) then
                    settings.VisibleKeys[v86] = v87

                    if state.isEnabled then
                        v26(false)
                    end

                    break
                end
            end

            break
        end
    end
end
executorKeystrokes.UpdateSetting = function(v90, v91, v92)
    local v93 = 0

    while true do
        if (1 == v93) then
            if state.isEnabled then
                v28()
            end

            break
        end
        if (v93 == 0) then
            if (settings[v91] == nil) then
                return
            end

            settings[v91] = v92
            v93 = 1
        end
    end
end
executorKeystrokes.Destroy = function(v94)
    local v95 = 0

    while true do
        if (v95 == 0) then
            v94:Disable()

            v8.ExecutorKeystrokes = nil

            break
        end
    end
end

if settings.Enabled then
    executorKeystrokes:Enable()
end

return true
