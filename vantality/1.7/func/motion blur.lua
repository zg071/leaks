-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local runService = game:GetService('RunService')
local lighting = game:GetService('Lighting')
local userInputService = game:GetService('UserInputService')

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if (v8.ExecutorSimulatedMB_CamOnly and (typeof(v8.ExecutorSimulatedMB_CamOnly.Destroy) == 'function')) then
    local v50 = 0

    while true do
        if (v50 == 0) then
            pcall(function()
                v8.ExecutorSimulatedMB_CamOnly:Destroy()
            end)
            task.wait(0.1)

            break
        end
    end
end

v8.ExecutorSimulatedMB_CamOnly = {}

local executorSimulatedMB_CamOnly = v8.ExecutorSimulatedMB_CamOnly

executorSimulatedMB_CamOnly.Settings = {
    MaxBlurSize = 18,
    CamRotationThresholdStart = 0.006,
    CamRotationThresholdMax = 0.18,
    TransitionSpeed = 16,
}
executorSimulatedMB_CamOnly.State = {
    isEnabled = false,
    isWindowFocused = true,
    currentBlurSize = 0,
    lastCameraCFrame = nil,
    BlurEffect = nil,
    Connections = {},
}

local state = executorSimulatedMB_CamOnly.State
local settings = executorSimulatedMB_CamOnly.Settings
local executorSimulatedMBCamOnlyBlurV4 = 'ExecutorSimulatedMB_CamOnly_Blur_v4'

local function v19(v28, v29, v30)
    return v28 + ((v29 - v28) * v30)
end
local function v20(v31)
    local currentCamera = workspace.CurrentCamera

    if (not state.BlurEffect or not currentCamera) then
        return
    end

    local maxBlurSize = 0

    if (state.isEnabled and state.isWindowFocused) then
        local mathAbs = 0
        local cFrame = currentCamera.CFrame

        if not state.lastCameraCFrame then
            state.lastCameraCFrame = cFrame
        end
        if (cFrame ~= state.lastCameraCFrame) then
            local v63 = 0
            local v64
            local pcallOk

            while true do
                if (v63 == 0) then
                    v64, pcallOk = pcall(function()
                        return state.lastCameraCFrame:ToObjectSpace(cFrame)
                    end)

                    if (v64 and pcallOk) then
                        local toAxisAngle, v81 = pcallOk:ToAxisAngle()

                        mathAbs = math.abs(v81)
                    end

                    v63 = 1
                end
                if (v63 == 1) then
                    state.lastCameraCFrame = cFrame

                    break
                end
            end
        end

        local mathMax = math.max(0.0001, settings.CamRotationThresholdMax - settings.CamRotationThresholdStart)
        local mathClamp = math.clamp((mathAbs - settings.CamRotationThresholdStart) / mathMax, 0, 1)

        maxBlurSize = mathClamp * settings.MaxBlurSize
    end

    local mathMin = math.min(v31 * settings.TransitionSpeed, 1)

    state.currentBlurSize = v19(state.currentBlurSize, maxBlurSize, mathMin)
    state.BlurEffect.Size = math.clamp(state.currentBlurSize, 0, settings.MaxBlurSize)
    state.BlurEffect.Enabled = state.isEnabled and state.isWindowFocused and (state.currentBlurSize > 0.1)
end

executorSimulatedMB_CamOnly.Enable = function(v38)
    local v39 = 0
    local blurEffect

    while true do
        if (v39 == 4) then
            v38.State.Connections.Render = runService.RenderStepped:Connect(v20)

            break
        end
        if (v39 == 3) then
            v38.State.Connections.FocusLost = userInputService.WindowFocusReleased:Connect(function(
            )
                v38.State.isWindowFocused = false
            end)
            v38.State.Connections.FocusGained = userInputService.WindowFocused:Connect(function(
            )
                v38.State.isWindowFocused = true
            end)
            v39 = 4
        end
        if (2 == v39) then
            v38.State.lastCameraCFrame = workspace.CurrentCamera and workspace.CurrentCamera.CFrame
            v38.State.isEnabled = true
            v39 = 3
        end
        if (v39 == 1) then
            if not blurEffect then
                local v68 = 0

                while true do
                    if (1 == v68) then
                        blurEffect.Size = 0
                        blurEffect.Enabled = false
                        v68 = 2
                    end
                    if (v68 == 0) then
                        blurEffect = Instance.new('BlurEffect')
                        blurEffect.Name = executorSimulatedMBCamOnlyBlurV4
                        v68 = 1
                    end
                    if (v68 == 2) then
                        blurEffect.Parent = lighting

                        break
                    end
                end
            end

            v38.State.BlurEffect = blurEffect
            v39 = 2
        end
        if (0 == v39) then
            if v38.State.isEnabled then
                return
            end

            blurEffect = lighting:FindFirstChild(executorSimulatedMBCamOnlyBlurV4)
            v39 = 1
        end
    end
end
executorSimulatedMB_CamOnly.Disable = function(v41)
    local v42 = 0
    local v43

    while true do
        if (v42 == 0) then
            v43 = 0

            while true do
                if (v43 == 1) then
                    for v73, v74 in pairs(v41.State.Connections)do
                        v74:Disconnect()
                    end

                    v41.State.Connections = {}
                    v43 = 2
                end
                if (v43 == 2) then
                    if v41.State.BlurEffect then
                        v41.State.BlurEffect:Destroy()

                        v41.State.BlurEffect = nil
                    end

                    v41.State.currentBlurSize = 0

                    break
                end
                if (v43 == 0) then
                    if not v41.State.isEnabled then
                        return
                    end

                    v41.State.isEnabled = false
                    v43 = 1
                end
            end

            break
        end
    end
end
executorSimulatedMB_CamOnly.UpdateSetting = function(v44, v45, v46)
    if ((v44.Settings[v45] ~= nil) and (type(v46) == 'number')) then
        v44.Settings[v45] = v46
    end
end
executorSimulatedMB_CamOnly.Destroy = function(v47)
    v47:Disable()

    v8.ExecutorSimulatedMB_CamOnly = nil
end

return executorSimulatedMB_CamOnly
