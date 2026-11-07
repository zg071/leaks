-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local runService = game:GetService('RunService')
local lighting = game:GetService('Lighting')
local userInputService = game:GetService('UserInputService')

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if (v8.ExecutorAltTabBlur and (typeof(v8.ExecutorAltTabBlur.Destroy) == 'function')) then
    pcall(function()
        v8.ExecutorAltTabBlur:Destroy()
    end)
    task.wait(0.1)
end

v8.ExecutorAltTabBlur = {}

local executorAltTabBlur = v8.ExecutorAltTabBlur
local executorAltTabBlurEffect = 'ExecutorAltTabBlur_Effect'

executorAltTabBlur.Settings = {
    AltTabBlurAmount = 16,
    AltTabTransitionSpeed = 8,
}
executorAltTabBlur.State = {
    isEnabled = false,
    isWindowFocused = true,
    currentAltTabBlurSize = 0,
    Effect = nil,
    Connections = {},
}

local function v17(v26, v27, v28)
    return v26 + ((v27 - v26) * v28)
end
local function v18(v29)
    local v30 = 0
    local state
    local settings
    local v33
    local v34

    while true do
        if (v30 == 2) then
            v34 = settings.AltTabTransitionSpeed or 6
            state.currentAltTabBlurSize = v17(state.currentAltTabBlurSize, v33, math.min(v29 * v34, 1))
            v30 = 3
        end
        if (v30 == 0) then
            state = executorAltTabBlur.State
            settings = executorAltTabBlur.Settings
            v30 = 1
        end
        if (v30 == 1) then
            if not state.Effect then
                return
            end

            v33 = (state.isEnabled and not state.isWindowFocused and settings.AltTabBlurAmount) or 0
            v30 = 2
        end
        if (v30 == 3) then
            state.Effect.Size = math.clamp(state.currentAltTabBlurSize, 0, 56)
            state.Effect.Enabled = state.currentAltTabBlurSize > 0.1

            break
        end
    end
end

executorAltTabBlur.Enable = function(v35)
    local v36 = 0
    local child

    while true do
        if (v36 == 3) then
            v35.State.Connections.FocusGained = userInputService.WindowFocused:Connect(function(
            )
                v35.State.isWindowFocused = true
            end)
            v35.State.Connections.Render = runService.RenderStepped:Connect(v18)

            break
        end
        if (0 == v36) then
            if v35.State.isEnabled then
                return
            end

            v35.State.isEnabled = true
            v36 = 1
        end
        if (v36 == 2) then
            v35.State.Effect = child
            v35.State.Connections.FocusLost = userInputService.WindowFocusReleased:Connect(function(
            )
                v35.State.isWindowFocused = false
            end)
            v36 = 3
        end
        if (v36 == 1) then
            child = lighting:FindFirstChild(executorAltTabBlurEffect)

            if not child then
                local v62 = 0

                while true do
                    if (1 == v62) then
                        child.Size = 0
                        child.Enabled = false
                        v62 = 2
                    end
                    if (v62 == 0) then
                        child = Instance.new('BlurEffect')
                        child.Name = executorAltTabBlurEffect
                        v62 = 1
                    end
                    if (v62 == 2) then
                        child.Parent = lighting

                        break
                    end
                end
            end

            v36 = 2
        end
    end
end
executorAltTabBlur.Disable = function(v38)
    local v39 = 0
    local v40

    while true do
        if (v39 == 0) then
            v40 = 0

            while true do
                if (1 == v40) then
                    for v66, v67 in pairs(v38.State.Connections)do
                        v67:Disconnect()
                    end

                    v38.State.Connections = {}
                    v40 = 2
                end
                if (v40 == 0) then
                    if not v38.State.isEnabled then
                        return
                    end

                    v38.State.isEnabled = false
                    v40 = 1
                end
                if (v40 == 2) then
                    if v38.State.Effect then
                        local v72 = 0

                        while true do
                            if (v72 == 0) then
                                v38.State.Effect:Destroy()

                                v38.State.Effect = nil

                                break
                            end
                        end
                    end

                    v38.State.currentAltTabBlurSize = 0

                    break
                end
            end

            break
        end
    end
end
executorAltTabBlur.UpdateSetting = function(v41, v42, v43)
    local v44 = 0

    while true do
        if (v44 == 0) then
            if (v41.Settings[v42] == nil) then
                return
            end

            v41.Settings[v42] = v43

            break
        end
    end
end
executorAltTabBlur.Destroy = function(v45)
    local v46 = 0

    while true do
        if (v46 == 0) then
            v45:Disable()

            v8.ExecutorAltTabBlur = nil

            break
        end
    end
end

return executorAltTabBlur
