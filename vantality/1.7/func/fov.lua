-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local runService = game:GetService('RunService')
local players = game:GetService('Players')

if (v8.FOV and (typeof(v8.FOV.Destroy) == 'function')) then
    local v67 = 0
    local v68

    while true do
        if (v67 == 0) then
            v68 = 0

            while true do
                if (v68 == 0) then
                    pcall(function()
                        v8.FOV:Destroy()
                    end)
                    task.wait(0.1)

                    break
                end
            end

            break
        end
    end
end

v8.FOV = {}

local fOV = v8.FOV

fOV.Settings = {
    Value = 90,
    Dynamic = false,
    SpeedFovBoost = 18,
    TransitionSpeed = 6,
}
fOV.State = {
    isEnabled = false,
    originalFov = 70,
    currentFovOffset = 0,
    Connections = {},
}

local v15 = 18
local v16 = 60

local function v17(v32, v33, v34)
    return v32 + ((v33 - v32) * v34)
end
local function v18(v35)
    local currentCamera = workspace.CurrentCamera

    if not currentCamera then
        return
    end

    local localPlayer = players.LocalPlayer
    local humanoidRootPart = localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild('HumanoidRootPart')
    local speedFovBoost = 0

    if (fOV.Settings.Dynamic and humanoidRootPart) then
        local v71 = 0
        local magnitude
        local v73
        local mathClamp

        while true do
            if (0 == v71) then
                magnitude = humanoidRootPart.Velocity.Magnitude
                v73 = v16 - v15
                v71 = 1
            end
            if (v71 == 1) then
                mathClamp = math.clamp((magnitude - v15) / math.max(0.1, v73), 0, 1)
                speedFovBoost = mathClamp * fOV.Settings.SpeedFovBoost

                break
            end
        end
    end

    fOV.State.currentFovOffset = v17(fOV.State.currentFovOffset, speedFovBoost, math.min(v35 * fOV.Settings.TransitionSpeed, 1))

    local currentFovOffset = fOV.Settings.Value + fOV.State.currentFovOffset

    if (math.abs(currentCamera.FieldOfView - currentFovOffset) > 0.1) then
        currentCamera.FieldOfView = v17(currentCamera.FieldOfView, currentFovOffset, math.min(v35 * fOV.Settings.TransitionSpeed * 2, 1))
    end
end

fOV.Enable = function(v42)
    if v42.State.isEnabled then
        return
    end

    local currentCamera = workspace.CurrentCamera

    if currentCamera then
        v42.State.originalFov = currentCamera.FieldOfView
    end

    v42.State.isEnabled = true
    v42.State.Connections.Render = runService.RenderStepped:Connect(v18)
end
fOV.Disable = function(v46)
    if not v46.State.isEnabled then
        return
    end

    v46.State.isEnabled = false

    for v69, v70 in pairs(v46.State.Connections)do
        v70:Disconnect()
    end

    v46.State.Connections = {}

    local currentCamera = workspace.CurrentCamera

    if currentCamera then
        currentCamera.FieldOfView = v46.State.originalFov
    end

    v46.State.currentFovOffset = 0
end
fOV.UpdateSetting = function(v51, v52, v53)
    local v54 = 0

    while true do
        if (v54 == 0) then
            if (v51.Settings[v52] == nil) then
                return
            end

            v51.Settings[v52] = v53

            break
        end
    end
end
fOV.Destroy = function(v55)
    local v56 = 0

    while true do
        if (v56 == 1) then
            v8.FOV_SCRIPT_INSTANCE = nil

            break
        end
        if (v56 == 0) then
            v55:Disable()

            v8.FOV = nil
            v56 = 1
        end
    end
end
fOV.enable = function(v57)
    v57:Enable()
end
fOV.disable = function(v58)
    v58:Disable()
end
fOV.setBase = function(v59, v60)
    v59:UpdateSetting('Value', v60)
end
fOV.setDynamicSpeedEnabled = function(v61, v62)
    v61:UpdateSetting('Dynamic', v62)
end
fOV.updateSetting = function(v63, v64, v65)
    v63:UpdateSetting(v64, v65)
end
v8.FOV_SCRIPT_INSTANCE = fOV

return fOV
