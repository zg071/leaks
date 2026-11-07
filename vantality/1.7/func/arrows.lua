-- by swimhub
local v8 = (getgenv and getgenv()) or _G

if (v8.ExecutorPlayerArrows and (typeof(v8.ExecutorPlayerArrows.Destroy) == 'function')) then
    local v79 = 0

    while true do
        if (v79 == 0) then
            pcall(function()
                v8.ExecutorPlayerArrows:Destroy()
            end)
            task.wait(0.1)

            break
        end
    end
end

v8.ExecutorPlayerArrows = {}

local executorPlayerArrows = v8.ExecutorPlayerArrows
local executorPlayerArrowsVStandard = 'ExecutorPlayerArrows_vStandard'
local players = game:GetService('Players')
local runService = game:GetService('RunService')
local localPlayer = players.LocalPlayer
local currentCamera = workspace.CurrentCamera

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(0.5)

executorPlayerArrows.Settings = {
    ARROW_IMAGE_ID = 'rbxassetid://4862800922',
    RenderDistance = 300,
    RingRadius = 120,
    ArrowBaseSizeXY = 32,
    ArrowTransparency = 0.1,
    MaxVisibleArrows = 0,
    EnableDynamicSize = true,
    MinArrowScale = 0.5,
    MaxArrowScale = 1.5,
    NearDistanceForScaling = 30,
    FarDistanceForScaling = 150,
    EnableDynamicColor = true,
    ArrowColorFar = Color3.fromRGB(80, 200, 80),
    ArrowColorNear = Color3.fromRGB(255, 80, 80),
    INTERNAL_NEAR_COLOR_DIST = 5,
    INTERNAL_FAR_COLOR_DIST = 100,
}

local settings = executorPlayerArrows.Settings

executorPlayerArrows.State = {
    isEnabled = false,
    screenGui = nil,
    activePlayerArrows = {},
    Connections = {},
}

local state = executorPlayerArrows.State

local function v20(v34)
    local v35 = 0
    local humanoid
    local humanoidRootPart

    while true do
        if (2 == v35) then
            if not humanoidRootPart then
                return false
            end

            return true
        end
        if (v35 == 1) then
            if (not humanoid or (humanoid.Health <= 0)) then
                return false
            end

            humanoidRootPart = v34.Character:FindFirstChild('HumanoidRootPart')
            v35 = 2
        end
        if (v35 == 0) then
            if (not v34 or (v34 == localPlayer) or not v34.Character) then
                return false
            end

            humanoid = v34.Character:FindFirstChildOfClass('Humanoid')
            v35 = 1
        end
    end
end
local function v21(v38, v39, v40)
    return v38 + ((v39 - v38) * v40)
end
local function v22(v41, v42, v43)
    local v44 = 0

    while true do
        if (v44 == 0) then
            if ((v42 - v41) == 0) then
                return 0
            end

            return (v43 - v41) / (v42 - v41)
        end
    end
end

executorPlayerArrows.CreateScreenGui_Internal = function(v45)
    if (state.screenGui and state.screenGui.Parent) then
        return state.screenGui
    end

    local screenGui = Instance.new('ScreenGui')

    screenGui.Name = executorPlayerArrowsVStandard .. '_ScreenGui'
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false

    local coreGui = (localPlayer and localPlayer:FindFirstChildOfClass('PlayerGui')) or game:GetService('CoreGui')

    if coreGui then
        screenGui.Parent = coreGui
        state.screenGui = screenGui
    end

    return screenGui
end
executorPlayerArrows.CreateArrowImage_Internal = function(v52)
    local v53 = 0
    local imageLabel

    while true do
        if (v53 == 0) then
            if not state.screenGui then
                v52:CreateScreenGui_Internal()
            end
            if not state.screenGui then
                return nil
            end

            imageLabel = Instance.new('ImageLabel')
            v53 = 1
        end
        if (v53 == 1) then
            imageLabel.Name = 'DirectionArrow'
            imageLabel.Image = settings.ARROW_IMAGE_ID
            imageLabel.Size = UDim2.fromOffset(settings.ArrowBaseSizeXY, settings.ArrowBaseSizeXY)
            v53 = 2
        end
        if (v53 == 3) then
            imageLabel.Visible = false
            imageLabel.Parent = state.screenGui

            return imageLabel
        end
        if (v53 == 2) then
            imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            imageLabel.BackgroundTransparency = 1
            imageLabel.ImageTransparency = settings.ArrowTransparency
            v53 = 3
        end
    end
end
executorPlayerArrows.UpdateArrows_Internal = function(v55)
    if not state.isEnabled then
        local v102 = 0

        while true do
            if (v102 == 0) then
                for v145, v146 in pairs(state.activePlayerArrows)do
                    if v146.ArrowImageLabel then
                        v146.ArrowImageLabel.Visible = false
                    end
                end

                return
            end
        end
    end
    if (not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild('HumanoidRootPart')) then
        local v103 = 0

        while true do
            if (0 == v103) then
                for v147, v148 in pairs(state.activePlayerArrows)do
                    if v148.ArrowImageLabel then
                        v148.ArrowImageLabel.Visible = false
                    end
                end

                return
            end
        end
    end
    if (not currentCamera or not currentCamera.Parent) then
        local v104 = 0
        local v105

        while true do
            if (v104 == 0) then
                v105 = 0

                while true do
                    if (0 == v105) then
                        currentCamera = workspace.CurrentCamera

                        if not currentCamera then
                            return
                        end

                        break
                    end
                end

                break
            end
        end
    end

    local position = localPlayer.Character.HumanoidRootPart.Position
    local cFrame = currentCamera.CFrame
    local viewportSize = currentCamera.ViewportSize
    local vector2_2 = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local v60 = {}

    for v80, v81 in ipairs(players:GetPlayers())do
        if v20(v81) then
            local v121 = 0
            local humanoidRootPart

            while true do
                if (v121 == 0) then
                    humanoidRootPart = v81.Character:FindFirstChild('HumanoidRootPart')

                    if humanoidRootPart then
                        local v166 = 0
                        local magnitude

                        while true do
                            if (v166 == 0) then
                                magnitude = (position - humanoidRootPart.Position).Magnitude

                                if (magnitude <= settings.RenderDistance) then
                                    table.insert(v60, {
                                        Player = v81,
                                        HRP_Pos = humanoidRootPart.Position,
                                        Distance = magnitude,
                                    })
                                end

                                break
                            end
                        end
                    end

                    break
                end
            end
        end
    end

    if ((settings.MaxVisibleArrows > 0) and (#v60 > settings.MaxVisibleArrows)) then
        table.sort(v60, function(v123, v124)
            return v123.Distance < v124.Distance
        end)
    end

    local v61 = {}
    local min = ((settings.MaxVisibleArrows > 0) and math.min(#v60, settings.MaxVisibleArrows)) or #v60

    for v82 = 1, min do
        v61[v60[v82].Player] = true
    end

    for v84, v85 in pairs(state.activePlayerArrows)do
        if (not v61[v84] or not v84.Parent) then
            if v85.ArrowImageLabel then
                v85.ArrowImageLabel.Visible = false
            end
        end
    end

    for v86 = 1, min do
        local v87 = v60[v86]
        local player = v87.Player
        local hRP_Pos = v87.HRP_Pos
        local distance = v87.Distance
        local activePlayerArrows = state.activePlayerArrows[player]

        if (not activePlayerArrows or not activePlayerArrows.ArrowImageLabel or not activePlayerArrows.ArrowImageLabel.Parent) then
            local v125 = 0
            local createArrowImageInternal

            while true do
                if (v125 == 0) then
                    createArrowImageInternal = v55:CreateArrowImage_Internal()

                    if createArrowImageInternal then
                        local v168 = 0
                        local v169

                        while true do
                            if (v168 == 0) then
                                v169 = 0

                                while true do
                                    if (v169 == 0) then
                                        activePlayerArrows = {ArrowImageLabel = createArrowImageInternal}
                                        state.activePlayerArrows[player] = activePlayerArrows

                                        break
                                    end
                                end

                                break
                            end
                        end
                    else
                        continue
                    end

                    break
                end
            end
        end

        local arrowImageLabel = activePlayerArrows.ArrowImageLabel

        arrowImageLabel.Image = settings.ARROW_IMAGE_ID
        arrowImageLabel.ImageTransparency = settings.ArrowTransparency

        local position2 = hRP_Pos - cFrame.Position

        if (position2.Magnitude < 0.1) then
            arrowImageLabel.Visible = false
        else
            local v128 = 0
            local lookVector
            local rightVector
            local dot
            local dot2
            local mathAtan2
            local sin
            local cos

            while true do
                if (v128 == 0) then
                    position2 = position2.Unit
                    lookVector = cFrame.LookVector
                    rightVector = cFrame.RightVector
                    dot = position2:Dot(rightVector)
                    v128 = 1
                end
                if (v128 == 3) then
                    arrowImageLabel.Visible = true

                    break
                end
                if (v128 == 1) then
                    dot2 = position2:Dot(lookVector)
                    mathAtan2 = math.atan2(dot, dot2)
                    sin = vector2_2.X + (math.sin(mathAtan2) * settings.RingRadius)
                    cos = vector2_2.Y - (math.cos(mathAtan2) * settings.RingRadius)
                    v128 = 2
                end
                if (v128 == 2) then
                    arrowImageLabel.Position = UDim2.fromOffset(sin, cos)
                    arrowImageLabel.Rotation = math.deg(mathAtan2)

                    if settings.EnableDynamicColor then
                        local v170 = 0
                        local mathClamp

                        while true do
                            if (v170 == 0) then
                                mathClamp = math.clamp(v22(settings.INTERNAL_FAR_COLOR_DIST, settings.INTERNAL_NEAR_COLOR_DIST, distance), 0, 1)
                                arrowImageLabel.ImageColor3 = settings.ArrowColorFar:Lerp(settings.ArrowColorNear, mathClamp)

                                break
                            end
                        end
                    else
                        arrowImageLabel.ImageColor3 = settings.ArrowColorFar
                    end
                    if settings.EnableDynamicSize then
                        local v174 = 0
                        local v175
                        local mathClamp
                        local v21_2

                        while true do
                            if (v174 == 1) then
                                v21_2 = nil

                                while true do
                                    if (0 == v175) then
                                        mathClamp = math.clamp(v22(settings.FarDistanceForScaling, settings.NearDistanceForScaling, distance), 0, 1)
                                        v21_2 = v21(settings.MinArrowScale, settings.MaxArrowScale, mathClamp)
                                        v175 = 1
                                    end
                                    if (v175 == 1) then
                                        arrowImageLabel.Size = UDim2.fromOffset(settings.ArrowBaseSizeXY * v21_2, settings.ArrowBaseSizeXY * v21_2)

                                        break
                                    end
                                end

                                break
                            end
                            if (v174 == 0) then
                                v175 = 0
                                mathClamp = nil
                                v174 = 1
                            end
                        end
                    else
                        arrowImageLabel.Size = UDim2.fromOffset(settings.ArrowBaseSizeXY, settings.ArrowBaseSizeXY)
                    end

                    v128 = 3
                end
            end
        end
    end
end
executorPlayerArrows.ManagePlayer_Internal = function(v63, v64, v65)
    if v65 then
        if (state.activePlayerArrows[v64] and (not state.activePlayerArrows[v64].ArrowImageLabel or not state.activePlayerArrows[v64].ArrowImageLabel.Parent)) then
            state.activePlayerArrows[v64] = nil
        end
    else
        local activePlayerArrows = state.activePlayerArrows[v64]

        if (activePlayerArrows and activePlayerArrows.ArrowImageLabel) then
            activePlayerArrows.ArrowImageLabel:Destroy()
        end

        state.activePlayerArrows[v64] = nil
    end
end
executorPlayerArrows.Enable = function(v66)
    local v67 = 0
    local v68

    while true do
        if (0 == v67) then
            v68 = 0

            while true do
                if (v68 == 3) then
                    state.Connections.PlayerRemoving = players.PlayerRemoving:Connect(function(
                        v159
                    )
                        v66:ManagePlayer_Internal(v159, false)
                    end)
                    state.Connections.RenderStepped = runService.RenderStepped:Connect(function(
                    )
                        v66:UpdateArrows_Internal()
                    end)
                    v68 = 4
                end
                if (v68 == 2) then
                    for v160, v161 in ipairs(players:GetPlayers())do
                        v66:ManagePlayer_Internal(v161, true)
                    end

                    state.Connections.PlayerAdded = players.PlayerAdded:Connect(function(
                        v162
                    )
                        v66:ManagePlayer_Internal(v162, true)
                    end)
                    v68 = 3
                end
                if (v68 == 0) then
                    if state.isEnabled then
                        return
                    end

                    state.isEnabled = true
                    v68 = 1
                end
                if (v68 == 4) then
                    if state.screenGui then
                        state.screenGui.Enabled = true
                    end

                    break
                end
                if (v68 == 1) then
                    if not currentCamera then
                        currentCamera = workspace.CurrentCamera
                    end

                    v66:CreateScreenGui_Internal()

                    v68 = 2
                end
            end

            break
        end
    end
end
executorPlayerArrows.Disable = function(v69)
    local v70 = 0

    while true do
        if (v70 == 3) then
            if state.screenGui then
                state.screenGui.Enabled = false
            end

            break
        end
        if (v70 == 0) then
            if not state.isEnabled then
                return
            end

            state.isEnabled = false
            v70 = 1
        end
        if (v70 == 2) then
            if state.Connections.PlayerRemoving then
                state.Connections.PlayerRemoving:Disconnect()
            end

            state.Connections = {}
            v70 = 3
        end
        if (v70 == 1) then
            if state.Connections.RenderStepped then
                state.Connections.RenderStepped:Disconnect()
            end
            if state.Connections.PlayerAdded then
                state.Connections.PlayerAdded:Disconnect()
            end

            v70 = 2
        end
    end
end
executorPlayerArrows.UpdateSetting = function(v71, v72, v73)
    if (settings[v72] == nil) then
        return
    end

    settings[v72] = v73

    if (state.isEnabled and ((v72 == 'ArrowBaseSizeXY') or (v72 == 'ArrowTransparency') or (v72 == 'ARROW_IMAGE_ID'))) then
        for v138, v139 in pairs(state.activePlayerArrows)do
            if (v139.ArrowImageLabel and v139.ArrowImageLabel.Visible) then
                local v143 = 0
                local v144

                while true do
                    if (0 == v143) then
                        v144 = 0

                        while true do
                            if (v144 == 0) then
                                if (v72 == 'ArrowTransparency') then
                                    v139.ArrowImageLabel.ImageTransparency = settings.ArrowTransparency
                                end
                                if (v72 == 'ARROW_IMAGE_ID') then
                                    v139.ArrowImageLabel.Image = settings.ARROW_IMAGE_ID
                                end

                                break
                            end
                        end

                        break
                    end
                end
            end
        end
    end
end
executorPlayerArrows.Destroy = function(v75)
    v75:Disable()

    for v98, v99 in pairs(state.activePlayerArrows)do
        if v99.ArrowImageLabel then
            v99.ArrowImageLabel:Destroy()
        end
    end

    state.activePlayerArrows = {}

    if state.screenGui then
        local v108 = 0
        local v109

        while true do
            if (v108 == 0) then
                v109 = 0

                while true do
                    if (0 == v109) then
                        state.screenGui:Destroy()

                        state.screenGui = nil

                        break
                    end
                end

                break
            end
        end
    end

    v8.ExecutorPlayerArrows = nil
end

return executorPlayerArrows
