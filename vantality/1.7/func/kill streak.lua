-- by swimhub
-- only tsb
local v8 = (getgenv and getgenv()) or _G
local players = game:GetService('Players')
local workspace = game:GetService('Workspace')
local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')
local localPlayer = players.LocalPlayer

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(0.5)

if (v8.ExecutorKillStreakEffect_Instance and (typeof(v8.ExecutorKillStreakEffect_Instance.Destroy) == 'function')) then
    pcall(v8.ExecutorKillStreakEffect_Instance.Destroy)
    task.wait(0.1)
end

v8.ExecutorKillStreakEffect_Instance = nil
v8.ExecutorKillStreakEffect = v8.ExecutorKillStreakEffect or {}

local executorKillStreakEffect = v8.ExecutorKillStreakEffect
local executorKillStreakEffectAdaptedV5 = 'ExecutorKillStreakEffect_Adapted_v5'

executorKillStreakEffect.Settings = executorKillStreakEffect.Settings or {
    DisplayText = '2',
}

local settings = executorKillStreakEffect.Settings

executorKillStreakEffect.State = executorKillStreakEffect.State or {
    isEnabled = false,
    isInitialized = false,
    isWindowFocused = true,
    connections = {},
    billboard = nil,
    clonedFrame = nil,
    character = nil,
    originalKillstreakFrame = nil,
    originalGameBillboardGui = nil,
    originalBillboardMonitorConn = nil,
}

local state = executorKillStreakEffect.State
local v22 = 0.1
local v23 = 10
local v24 = false

local function v25(v39)
    if v24 then
    end
end
local function v26(v40) end
local function v27()
    v25('Cleanup_Internal START')

    if (state.originalBillboardMonitorConn and state.originalBillboardMonitorConn.Connected) then
        state.originalBillboardMonitorConn:Disconnect()
        v25('\u{41c}\u{43e}\u{43d}\u{438}\u{442}\u{43e}\u{440}\u{438}\u{43d}\u{433} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{43e}\u{433}\u{43e} BillboardGui \u{43e}\u{442}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}.')
    end

    state.originalBillboardMonitorConn = nil

    for v73, v74 in pairs(state.connections)do
        local v75 = 0

        while true do
            if (v75 == 0) then
                if (v74 and v74.Connected) then
                    v74:Disconnect()
                end

                state.connections[v73] = nil

                break
            end
        end
    end

    v25('\u{41f}\u{43e}\u{43b}\u{44c}\u{437}\u{43e}\u{432}\u{430}\u{442}\u{435}\u{43b}\u{44c}\u{441}\u{43a}\u{438}\u{435} \u{441}\u{43e}\u{431}\u{44b}\u{442}\u{438}\u{44f} \u{43e}\u{442}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}\u{44b}.')

    if (state.billboard and state.billboard.Parent) then
        local v83 = 0

        while true do
            if (v83 == 0) then
                state.billboard:Destroy()
                v25('\u{41d}\u{430}\u{448} BillboardGui \u{443}\u{434}\u{430}\u{43b}\u{435}\u{43d}.')

                break
            end
        end
    end

    state.billboard = nil
    state.clonedFrame = nil

    if (state.originalGameBillboardGui and state.originalGameBillboardGui.Parent) then
        v25('\u{41f}\u{43e}\u{43f}\u{44b}\u{442}\u{43a}\u{430} \u{432}\u{43a}\u{43b}\u{44e}\u{447}\u{438}\u{442}\u{44c} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{439} \u{438}\u{433}\u{440}\u{43e}\u{432}\u{43e}\u{439} BillboardGui...')
        pcall(function()
            state.originalGameBillboardGui.Enabled = true
        end)
    end

    state.character = nil

    v25('Cleanup_Internal END')
end
local function v28()
    local v45 = 0
    local killstreak

    while true do
        if (v45 == 1) then
            killstreak = pcall(function()
                local v96 = 0
                local cutscenes
                local billboard
                local killstreak2

                while true do
                    if (v96 == 1) then
                        local v149 = 0

                        while true do
                            if (v149 == 1) then
                                v96 = 2

                                break
                            end
                            if (v149 == 0) then
                                killstreak2 = billboard:WaitForChild('Killstreak', v23)
                                state.originalKillstreakFrame = killstreak2:WaitForChild('Frame', v23)
                                v149 = 1
                            end
                        end
                    end
                    if (v96 == 2) then
                        state.originalGameBillboardGui = billboard:FindFirstChild('BillboardGui')

                        if (not state.originalKillstreakFrame or not state.originalKillstreakFrame:IsA('Frame')) then
                            error('\u{41d}\u{435} \u{43d}\u{430}\u{439}\u{434}\u{435}\u{43d} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{439} Frame.')
                        end

                        v96 = 3
                    end
                    if (3 == v96) then
                        v25('\u{41d}\u{430}\u{439}\u{434}\u{435}\u{43d} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{439} Frame: ' .. state.originalKillstreakFrame:GetFullName())

                        if (state.originalGameBillboardGui and state.originalGameBillboardGui:IsA('BillboardGui')) then
                            v25('\u{41d}\u{430}\u{439}\u{434}\u{435}\u{43d} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{439} \u{438}\u{433}\u{440}\u{43e}\u{432}\u{43e}\u{439} BillboardGui: ' .. state.originalGameBillboardGui:GetFullName())
                        else
                            v25('\u{41e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{439} \u{438}\u{433}\u{440}\u{43e}\u{432}\u{43e}\u{439} BillboardGui \u{43d}\u{435} \u{43d}\u{430}\u{439}\u{434}\u{435}\u{43d} (\u{43d}\u{435} \u{43a}\u{440}\u{438}\u{442}\u{438}\u{447}\u{43d}\u{43e}, \u{43d}\u{43e} \u{43d}\u{435} \u{441}\u{43c}\u{43e}\u{436}\u{435}\u{43c} \u{43e}\u{442}\u{43a}\u{43b}\u{44e}\u{447}\u{438}\u{442}\u{44c}).')

                            state.originalGameBillboardGui = nil
                        end

                        break
                    end
                    if (0 == v96) then
                        cutscenes = workspace:WaitForChild('Cutscenes', v23)
                        billboard = cutscenes:WaitForChild('Billboard', v23)
                        v96 = 1
                    end
                end
            end)

            if not killstreak then
                local v110 = 0

                while true do
                    local v135 = 0
                    local v136

                    while true do
                        if (v135 == 0) then
                            v136 = 0

                            while true do
                                if (0 == v136) then
                                    if (v110 == 1) then
                                        state.originalGameBillboardGui = nil

                                        return false
                                    end
                                    if (v110 == 0) then
                                        v26('\u{41e}\u{448}\u{438}\u{431}\u{43a}\u{430} \u{43f}\u{440}\u{438} \u{43f}\u{43e}\u{438}\u{441}\u{43a}\u{435} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{445} UI \u{44d}\u{43b}\u{435}\u{43c}\u{435}\u{43d}\u{442}\u{43e}\u{432}.')

                                        state.originalKillstreakFrame = nil
                                        v110 = 1
                                    end

                                    break
                                end
                            end

                            break
                        end
                    end
                end
            end

            v45 = 2
        end
        if (2 == v45) then
            return true
        end
        if (v45 == 0) then
            if (state.originalKillstreakFrame and state.originalGameBillboardGui) then
                local v111 = 0
                local v112

                while true do
                    if (v111 == 0) then
                        v112 = 0

                        while true do
                            if (v112 == 0) then
                                local v168 = 0

                                while true do
                                    if (v168 == 0) then
                                        v25('\u{41e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{435} \u{44d}\u{43b}\u{435}\u{43c}\u{435}\u{43d}\u{442}\u{44b} \u{443}\u{436}\u{435} \u{43d}\u{430}\u{439}\u{434}\u{435}\u{43d}\u{44b}.')

                                        return true
                                    end
                                end
                            end
                        end

                        break
                    end
                end
            end

            v25('\u{41f}\u{43e}\u{438}\u{441}\u{43a} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{445} UI \u{44d}\u{43b}\u{435}\u{43c}\u{435}\u{43d}\u{442}\u{43e}\u{432}...')

            v45 = 1
        end
    end
end
local function v29(v47)
    local v48 = 0

    while true do
        if (v48 == 1) then
            if (v47:IsA('ParticleEmitter') or v47:IsA('Beam') or v47:IsA('Trail') or v47:IsA('Light')) then
                v47.Enabled = true
            end

            for v100, v101 in ipairs(v47:GetChildren())do
                v29(v101)
            end

            break
        end
        if (v48 == 0) then
            if not v47 then
                return
            end
            if v47:IsA('GuiObject') then
                v47.Visible = true
            end

            v48 = 1
        end
    end
end
local function v30()
    if state.isInitialized then
        return true
    end
    if not localPlayer then
        local v84 = 0

        while true do
            if (v84 == 0) then
                v26('LocalPlayer \u{43d}\u{435} \u{43d}\u{430}\u{439}\u{434}\u{435}\u{43d}.')

                return false
            end
        end
    end

    local playerGui = localPlayer:FindFirstChild('PlayerGui')

    if not playerGui then
        v26('PlayerGui \u{43d}\u{435} \u{43d}\u{430}\u{439}\u{434}\u{435}\u{43d}.')

        return false
    end

    v25('Initialize_Internal START')

    if not v28() then
        local v85 = 0
        local v86

        while true do
            if (v85 == 0) then
                v86 = 0

                while true do
                    if (v86 == 0) then
                        v26('\u{41d}\u{435} \u{443}\u{434}\u{430}\u{43b}\u{43e}\u{441}\u{44c} \u{43d}\u{430}\u{439}\u{442}\u{438} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{435} \u{44d}\u{43b}\u{435}\u{43c}\u{435}\u{43d}\u{442}\u{44b} \u{434}\u{43b}\u{44f} \u{438}\u{43d}\u{438}\u{446}\u{438}\u{430}\u{43b}\u{438}\u{437}\u{430}\u{446}\u{438}\u{438}.')

                        return false
                    end
                end

                break
            end
        end
    end

    local textLabel, v51 = pcall(function()
        local v76 = 0
        local billboardGui
        local ancestor
        local clone
        local textLabel2

        while true do
            if (v76 == 3) then
                v29(clone)

                clone.Parent = billboardGui
                billboardGui.Parent = playerGui

                return billboardGui
            end
            if (0 == v76) then
                billboardGui = Instance.new('BillboardGui')
                billboardGui.Name = executorKillStreakEffectAdaptedV5 .. '_Billboard'
                billboardGui.AlwaysOnTop = true
                billboardGui.LightInfluence = 0
                v76 = 1
            end
            if (v76 == 1) then
                billboardGui.Enabled = false
                billboardGui.ResetOnSpawn = false
                ancestor = state.originalKillstreakFrame:FindFirstAncestorWhichIsA('BillboardGui')

                if ancestor then
                    local v137 = 0
                    local v138

                    while true do
                        if (v137 == 0) then
                            v138 = 0

                            while true do
                                if (v138 == 0) then
                                    billboardGui.Size = ancestor.Size
                                    billboardGui.StudsOffset = ancestor.StudsOffset + (Vector3.yAxis * v22)

                                    break
                                end
                            end

                            break
                        end
                    end
                else
                    local v139 = 0
                    local v140

                    while true do
                        if (v139 == 0) then
                            v140 = 0

                            while true do
                                if (v140 == 0) then
                                    billboardGui.Size = UDim2.new(4, 0, 2, 0)
                                    billboardGui.StudsOffset = Vector3.new(0, v22, 0)

                                    break
                                end
                            end

                            break
                        end
                    end
                end

                v76 = 2
            end
            if (v76 == 2) then
                clone = state.originalKillstreakFrame:Clone()
                clone.Name = executorKillStreakEffectAdaptedV5 .. '_FrameClone'
                textLabel2 = clone:FindFirstChild('TextLabel', true)

                if (textLabel2 and textLabel2:IsA('TextLabel')) then
                    textLabel2.Text = settings.DisplayText
                end

                v76 = 3
            end
        end
    end)

    if (not textLabel or not v51) then
        v26('\u{41d}\u{435} \u{443}\u{434}\u{430}\u{43b}\u{43e}\u{441}\u{44c} \u{441}\u{43e}\u{437}\u{434}\u{430}\u{442}\u{44c} \u{43d}\u{430}\u{448} Billboard/\u{43a}\u{43b}\u{43e}\u{43d}!', v51)

        return false
    end

    state.billboard = v51
    state.clonedFrame = v51:FindFirstChild(executorKillStreakEffectAdaptedV5 .. '_FrameClone')

    v25('\u{41d}\u{430}\u{448} UI \u{443}\u{441}\u{43f}\u{435}\u{448}\u{43d}\u{43e} \u{441}\u{43e}\u{437}\u{434}\u{430}\u{43d}.')

    if (state.originalGameBillboardGui and state.originalGameBillboardGui.Parent) then
        v25('\u{41e}\u{442}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}\u{438}\u{435} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{43e}\u{433}\u{43e} \u{438}\u{433}\u{440}\u{43e}\u{432}\u{43e}\u{433}\u{43e} BillboardGui...')

        state.originalGameBillboardGui.Enabled = false

        local wait = state.originalGameBillboardGui:GetPropertyChangedSignal('Enabled'):Connect(function(
        )
            if (state.originalGameBillboardGui and (state.originalGameBillboardGui.Enabled == true)) then
                v25('\u{41e}\u{431}\u{43d}\u{430}\u{440}\u{443}\u{436}\u{435}\u{43d}\u{43e} \u{432}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}\u{438}\u{435} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{43e}\u{433}\u{43e} BillboardGui. \u{41f}\u{440}\u{438}\u{43d}\u{443}\u{434}\u{438}\u{442}\u{435}\u{43b}\u{44c}\u{43d}\u{43e} \u{43e}\u{442}\u{43a}\u{43b}\u{44e}\u{447}\u{430}\u{435}\u{43c}...')
                task.wait()

                if state.originalGameBillboardGui then
                    state.originalGameBillboardGui.Enabled = false
                end
            end
        end)

        state.originalBillboardMonitorConn = wait

        v25('\u{41c}\u{43e}\u{43d}\u{438}\u{442}\u{43e}\u{440}\u{438}\u{43d}\u{433} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{43e}\u{433}\u{43e} BillboardGui \u{437}\u{430}\u{43f}\u{443}\u{449}\u{435}\u{43d}.')
    else
        v25('\u{41e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{44b}\u{439} \u{438}\u{433}\u{440}\u{43e}\u{432}\u{43e}\u{439} BillboardGui \u{43d}\u{435} \u{43d}\u{430}\u{439}\u{434}\u{435}\u{43d}/\u{43d}\u{435}\u{434}\u{43e}\u{441}\u{442}\u{443}\u{43f}\u{435}\u{43d}, \u{43f}\u{440}\u{43e}\u{43f}\u{443}\u{441}\u{43a}\u{430}\u{435}\u{43c} \u{43e}\u{442}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}\u{438}\u{435}/\u{43c}\u{43e}\u{43d}\u{438}\u{442}\u{43e}\u{440}\u{438}\u{43d}\u{433}.')
    end

    state.isInitialized = true

    v25('Initialize_Internal SUCCESS')

    return true
end
local function v31(v55)
    local v56 = 0

    while true do
        if (v56 == 1) then
            if (state.isEnabled and v55 and v55.Parent) then
                local v115 = 0
                local head

                while true do
                    if (0 == v115) then
                        local v153 = 0

                        while true do
                            if (v153 == 1) then
                                v115 = 1

                                break
                            end
                            if (0 == v153) then
                                head = v55:FindFirstChild('Head')

                                if not head then
                                    local v177 = 0
                                    local v178

                                    while true do
                                        if (v177 == 0) then
                                            v178 = 0

                                            while true do
                                                if (v178 == 0) then
                                                    task.wait(0.1)

                                                    head = v55:FindFirstChild('Head')

                                                    break
                                                end
                                            end

                                            break
                                        end
                                    end
                                end

                                v153 = 1
                            end
                        end
                    end
                    if (v115 == 1) then
                        if head then
                            local v164 = 0

                            while true do
                                if (v164 == 0) then
                                    v25('\u{423}\u{441}\u{442}\u{430}\u{43d}\u{43e}\u{432}\u{43a}\u{430} Adornee \u{43d}\u{430} \u{433}\u{43e}\u{43b}\u{43e}\u{432}\u{443}: ' .. head:GetFullName())

                                    state.billboard.Adornee = head
                                    v164 = 1
                                end
                                if (v164 == 1) then
                                    state.billboard.Enabled = true

                                    break
                                end
                            end
                        else
                            local v165 = 0
                            local v166

                            while true do
                                if (v165 == 0) then
                                    v166 = 0

                                    while true do
                                        if (0 == v166) then
                                            v26('\u{41d}\u{435} \u{43d}\u{430}\u{439}\u{434}\u{435}\u{43d}\u{430} \u{433}\u{43e}\u{43b}\u{43e}\u{432}\u{430} \u{434}\u{43b}\u{44f} ' .. v55.Name .. '. \u{41d}\u{430}\u{448} UI \u{431}\u{443}\u{434}\u{435}\u{442} \u{441}\u{43a}\u{440}\u{44b}\u{442}.')

                                            state.billboard.Adornee = nil
                                            v166 = 1
                                        end
                                        if (v166 == 1) then
                                            state.billboard.Enabled = false

                                            break
                                        end
                                    end

                                    break
                                end
                            end
                        end

                        break
                    end
                end
            else
                local v117 = 0

                while true do
                    if (v117 == 0) then
                        v25('\u{41f}\u{435}\u{440}\u{441}\u{43e}\u{43d}\u{430}\u{436} \u{43e}\u{442}\u{441}\u{443}\u{442}\u{441}\u{442}\u{432}\u{443}\u{435}\u{442} \u{438}\u{43b}\u{438} \u{441}\u{43a}\u{440}\u{438}\u{43f}\u{442} \u{432}\u{44b}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}. \u{421}\u{43a}\u{440}\u{44b}\u{442}\u{438}\u{435} \u{43d}\u{430}\u{448}\u{435}\u{433}\u{43e} UI.')

                        if state.billboard then
                            local v167 = 0

                            while true do
                                if (v167 == 0) then
                                    state.billboard.Adornee = nil
                                    state.billboard.Enabled = false

                                    break
                                end
                            end
                        end

                        break
                    end
                end
            end

            break
        end
        if (v56 == 0) then
            if (not state.isInitialized or not state.billboard) then
                return
            end

            state.character = v55
            v56 = 1
        end
    end
end

executorKillStreakEffect.Enable = function(v57)
    local v58 = 0

    while true do
        if (v58 == 4) then
            v31(localPlayer.Character)
            v25('Kill Streak Effect \u{412}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}\u{43e}.')

            break
        end
        if (1 == v58) then
            state.isEnabled = true

            if not v30() then
                local v118 = 0

                while true do
                    if (v118 == 0) then
                        v26('\u{418}\u{43d}\u{438}\u{446}\u{438}\u{430}\u{43b}\u{438}\u{437}\u{430}\u{446}\u{438}\u{44f} \u{43d}\u{435} \u{443}\u{434}\u{430}\u{43b}\u{430}\u{441}\u{44c}. Enable \u{43f}\u{440}\u{435}\u{440}\u{432}\u{430}\u{43d}\u{43e}.')

                        state.isEnabled = false
                        v118 = 1
                    end
                    if (1 == v118) then
                        return
                    end
                end
            end

            v58 = 2
        end
        if (0 == v58) then
            if state.isEnabled then
                return
            end

            v25('\u{41a}\u{43e}\u{43c}\u{430}\u{43d}\u{434}\u{430} Enable...')

            v58 = 1
        end
        if (v58 == 3) then
            if not state.connections.FocusLost then
                state.connections.FocusLost = userInputService.WindowFocusReleased:Connect(function(
                )
                    local v143 = 0

                    while true do
                        if (v143 == 0) then
                            state.isWindowFocused = false

                            v31(state.character)

                            break
                        end
                    end
                end)
            end
            if not state.connections.FocusGained then
                state.connections.FocusGained = userInputService.WindowFocused:Connect(function(
                )
                    local v144 = 0

                    while true do
                        if (0 == v144) then
                            state.isWindowFocused = true

                            v31(state.character)

                            break
                        end
                    end
                end)
            end

            v58 = 4
        end
        if (v58 == 2) then
            if not state.connections.CharacterAdded then
                state.connections.CharacterAdded = localPlayer.CharacterAdded:Connect(function(
                    v145
                )
                    local v146 = 0
                    local v147

                    while true do
                        if (v146 == 0) then
                            v147 = 0

                            while true do
                                if (0 == v147) then
                                    v25('\u{421}\u{43e}\u{431}\u{44b}\u{442}\u{438}\u{435} CharacterAdded: ' .. v145.Name)
                                    v31(v145)

                                    break
                                end
                            end

                            break
                        end
                    end
                end)
            end
            if not state.connections.CharacterRemoving then
                state.connections.CharacterRemoving = localPlayer.CharacterRemoving:Connect(function(
                    v148
                )
                    v25('\u{421}\u{43e}\u{431}\u{44b}\u{442}\u{438}\u{435} CharacterRemoving: ' .. v148.Name)

                    if (state.character == v148) then
                        v31(nil)
                    end
                end)
            end

            v58 = 3
        end
    end
end
executorKillStreakEffect.Disable = function(v59)
    local v60 = 0

    while true do
        if (2 == v60) then
            if (state.originalBillboardMonitorConn and state.originalBillboardMonitorConn.Connected) then
                local v123 = 0
                local v124

                while true do
                    if (v123 == 0) then
                        v124 = 0

                        while true do
                            if (0 == v124) then
                                state.originalBillboardMonitorConn:Disconnect()
                                v25('\u{41c}\u{43e}\u{43d}\u{438}\u{442}\u{43e}\u{440}\u{438}\u{43d}\u{433} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b}\u{44c}\u{43d}\u{43e}\u{433}\u{43e} BillboardGui \u{43e}\u{441}\u{442}\u{430}\u{43d}\u{43e}\u{432}\u{43b}\u{435}\u{43d} (\u{43d}\u{43e} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b} \u{43e}\u{441}\u{442}\u{430}\u{435}\u{442}\u{441}\u{44f} \u{432}\u{44b}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}\u{43d}\u{44b}\u{43c}).')

                                break
                            end
                        end

                        break
                    end
                end
            end

            state.originalBillboardMonitorConn = nil

            v25('Kill Streak Effect \u{412}\u{44b}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}\u{43e} (UI \u{438} \u{43e}\u{440}\u{438}\u{433}\u{438}\u{43d}\u{430}\u{43b} \u{43d}\u{435} \u{442}\u{440}\u{43e}\u{43d}\u{443}\u{442}\u{44b}, \u{442}\u{43e}\u{43b}\u{44c}\u{43a}\u{43e} \u{441}\u{43a}\u{440}\u{44b}\u{442}\u{44b}/\u{43e}\u{442}\u{43a}\u{43b}\u{44e}\u{447}\u{435}\u{43d}\u{44b} \u{441}\u{43e}\u{431}\u{44b}\u{442}\u{438}\u{44f}).')

            break
        end
        if (v60 == 1) then
            if state.connections.CharacterRemoving then
                local v125 = 0

                while true do
                    if (v125 == 0) then
                        state.connections.CharacterRemoving:Disconnect()

                        state.connections.CharacterRemoving = nil

                        break
                    end
                end
            end
            if state.connections.FocusLost then
                state.connections.FocusLost:Disconnect()

                state.connections.FocusLost = nil
            end
            if state.connections.FocusGained then
                local v127 = 0

                while true do
                    if (0 == v127) then
                        state.connections.FocusGained:Disconnect()

                        state.connections.FocusGained = nil

                        break
                    end
                end
            end
            if state.billboard then
                local v128 = 0
                local v129

                while true do
                    if (v128 == 0) then
                        v129 = 0

                        while true do
                            if (v129 == 0) then
                                state.billboard.Enabled = false
                                state.billboard.Adornee = nil

                                break
                            end
                        end

                        break
                    end
                end
            end

            v60 = 2
        end
        if (v60 == 0) then
            if not state.isEnabled then
                return
            end

            v25('\u{41a}\u{43e}\u{43c}\u{430}\u{43d}\u{434}\u{430} Disable...')

            state.isEnabled = false

            if state.connections.CharacterAdded then
                local v130 = 0
                local v131

                while true do
                    if (v130 == 0) then
                        v131 = 0

                        while true do
                            if (v131 == 0) then
                                state.connections.CharacterAdded:Disconnect()

                                state.connections.CharacterAdded = nil

                                break
                            end
                        end

                        break
                    end
                end
            end

            v60 = 1
        end
    end
end
executorKillStreakEffect.UpdateSetting = function(v61, v62, v63)
    local v64 = 0

    while true do
        if (0 == v64) then
            if (settings[v62] == nil) then
                local v132 = 0

                while true do
                    if (v132 == 0) then
                        local v157 = 0

                        while true do
                            if (0 == v157) then
                                v26('\u{41f}\u{43e}\u{43f}\u{44b}\u{442}\u{43a}\u{430} \u{43e}\u{431}\u{43d}\u{43e}\u{432}\u{438}\u{442}\u{44c} \u{43d}\u{435}\u{438}\u{437}\u{432}\u{435}\u{441}\u{442}\u{43d}\u{443}\u{44e} \u{43d}\u{430}\u{441}\u{442}\u{440}\u{43e}\u{439}\u{43a}\u{443}: ' .. v62)

                                return
                            end
                        end
                    end
                end
            end
            if (v62 == 'DisplayText') then
                if (type(v63) == 'string') then
                    settings.DisplayText = v63

                    v25("\u{41d}\u{430}\u{441}\u{442}\u{440}\u{43e}\u{439}\u{43a}\u{430} DisplayText \u{43e}\u{431}\u{43d}\u{43e}\u{432}\u{43b}\u{435}\u{43d}\u{430} \u{43d}\u{430}: '" .. v63 .. "'")

                    if (state.clonedFrame and state.clonedFrame.Parent) then
                        local v161 = 0
                        local textLabel

                        while true do
                            if (v161 == 0) then
                                textLabel = state.clonedFrame:FindFirstChild('TextLabel', true)

                                if (textLabel and textLabel:IsA('TextLabel')) then
                                    local v185 = 0

                                    while true do
                                        if (v185 == 0) then
                                            textLabel.Text = settings.DisplayText

                                            v25('\u{422}\u{435}\u{43a}\u{441}\u{442} \u{432} \u{430}\u{43a}\u{442}\u{438}\u{432}\u{43d}\u{43e}\u{43c} UI \u{43e}\u{431}\u{43d}\u{43e}\u{432}\u{43b}\u{435}\u{43d}.')

                                            break
                                        end
                                    end
                                end

                                break
                            end
                        end
                    end
                else
                    v26('\u{41d}\u{435}\u{432}\u{435}\u{440}\u{43d}\u{44b}\u{439} \u{442}\u{438}\u{43f} \u{434}\u{43b}\u{44f} DisplayText, \u{43e}\u{436}\u{438}\u{434}\u{430}\u{43b}\u{430}\u{441}\u{44c} \u{441}\u{442}\u{440}\u{43e}\u{43a}\u{430}, \u{43f}\u{43e}\u{43b}\u{443}\u{447}\u{435}\u{43d}: ' .. type(v63))
                end
            else
                v26('\u{41f}\u{43e}\u{43f}\u{44b}\u{442}\u{43a}\u{430} \u{438}\u{437}\u{43c}\u{435}\u{43d}\u{438}\u{442}\u{44c} \u{43d}\u{435}\u{440}\u{435}\u{434}\u{430}\u{43a}\u{442}\u{438}\u{440}\u{443}\u{435}\u{43c}\u{443}\u{44e} \u{43d}\u{430}\u{441}\u{442}\u{440}\u{43e}\u{439}\u{43a}\u{443}: ' .. v62)
            end

            break
        end
    end
end
executorKillStreakEffect.Destroy = function(v65)
    v25('\u{41a}\u{43e}\u{43c}\u{430}\u{43d}\u{434}\u{430} Destroy...')
    v27()

    state.isEnabled = false
    state.isInitialized = false
    state.originalKillstreakFrame = nil
    state.originalGameBillboardGui = nil
    v8.ExecutorKillStreakEffect = nil
    v8.ExecutorKillStreakEffect_Instance = nil

    v25('\u{41f}\u{43e}\u{43b}\u{43d}\u{43e}\u{441}\u{442}\u{44c}\u{44e} \u{43e}\u{441}\u{442}\u{430}\u{43d}\u{43e}\u{432}\u{43b}\u{435}\u{43d} \u{438} \u{443}\u{434}\u{430}\u{43b}\u{435}\u{43d}.')
end
v8.ExecutorKillStreakEffect_Instance = executorKillStreakEffect

if not localPlayer then
    local v81 = 0
    local v82

    while true do
        if (v81 == 0) then
            v82 = 0

            while true do
                local v133 = 0
                local v134

                while true do
                    if (v133 == 0) then
                        v134 = 0

                        while true do
                            if (v134 == 0) then
                                if (v82 == 0) then
                                    v26('\u{41d}\u{435} \u{443}\u{434}\u{430}\u{43b}\u{43e}\u{441}\u{44c} \u{43f}\u{43e}\u{43b}\u{443}\u{447}\u{438}\u{442}\u{44c} LocalPlayer \u{43f}\u{440}\u{438} \u{438}\u{43d}\u{438}\u{446}\u{438}\u{430}\u{43b}\u{438}\u{437}\u{430}\u{446}\u{438}\u{438} \u{441}\u{43a}\u{440}\u{438}\u{43f}\u{442}\u{430}. Destroy().')
                                    executorKillStreakEffect:Destroy()

                                    v82 = 1
                                end
                                if (v82 == 1) then
                                    return
                                end

                                break
                            end
                        end

                        break
                    end
                end
            end

            break
        end
    end
end
