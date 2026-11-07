-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local players = game:GetService('Players')
local runService = game:GetService('RunService')

if (v8.ExecutorZoom and (typeof(v8.ExecutorZoom.Destroy) == 'function')) then
    local v42 = 0

    while true do
        if (v42 == 0) then
            pcall(function()
                v8.ExecutorZoom:Destroy()
            end)
            task.wait(0.1)

            break
        end
    end
end

v8.ExecutorZoom = {}

local executorZoom = v8.ExecutorZoom

executorZoom.Settings = {MaxDistance = 10000}
executorZoom.State = {
    isEnabled = false,
    defaultDist = 128,
    Connections = {},
}

local function v15()
    local v24 = 0
    local localPlayer

    while true do
        if (v24 == 0) then
            localPlayer = players.LocalPlayer

            if (localPlayer and (localPlayer.CameraMaxZoomDistance ~= executorZoom.Settings.MaxDistance)) then
                pcall(function()
                    localPlayer.CameraMaxZoomDistance = executorZoom.Settings.MaxDistance
                end)
            end

            break
        end
    end
end

executorZoom.Enable = function(v26)
    if v26.State.isEnabled then
        return
    end

    local localPlayer = players.LocalPlayer

    if localPlayer then
        v26.State.defaultDist = localPlayer.CameraMaxZoomDistance
    end

    v26.State.isEnabled = true
    v26.State.Connections.Render = runService.RenderStepped:Connect(v15)
end
executorZoom.Disable = function(v30)
    local v31 = 0
    local localPlayer

    while true do
        if (v31 == 1) then
            for v49, v50 in pairs(v30.State.Connections)do
                v50:Disconnect()
            end

            v30.State.Connections = {}
            v31 = 2
        end
        if (v31 == 0) then
            if not v30.State.isEnabled then
                return
            end

            v30.State.isEnabled = false
            v31 = 1
        end
        if (v31 == 2) then
            localPlayer = players.LocalPlayer

            if localPlayer then
                pcall(function()
                    localPlayer.CameraMaxZoomDistance = v30.State.defaultDist
                end)
            end

            break
        end
    end
end
executorZoom.UpdateSetting = function(v33, v34, v35)
    local v36 = 0
    local v37

    while true do
        if (v36 == 0) then
            v37 = 0

            while true do
                if (v37 == 0) then
                    if (v33.Settings[v34] == nil) then
                        return
                    end

                    v33.Settings[v34] = v35

                    break
                end
            end

            break
        end
    end
end
executorZoom.Destroy = function(v38)
    v38:Disable()

    v8.ExecutorZoom = nil
    v8.ExecutorZoom_Instance = nil
end
v8.ExecutorZoom_Instance = executorZoom

return executorZoom
