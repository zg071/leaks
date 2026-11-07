-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local runService = game:GetService('RunService')
local players = game:GetService('Players')
local localPlayer = players.LocalPlayer

if (v8.ExecutorNoCameraShake and (typeof(v8.ExecutorNoCameraShake.Destroy) == 'function')) then
    local v41 = 0
    local v42

    while true do
        if (v41 == 0) then
            v42 = 0

            while true do
                if (v42 == 0) then
                    pcall(function()
                        v8.ExecutorNoCameraShake:Destroy()
                    end)
                    task.wait(0.1)

                    break
                end
            end

            break
        end
    end
end

v8.ExecutorNoCameraShake = {}

local executorNoCameraShake = v8.ExecutorNoCameraShake

executorNoCameraShake.Settings = {Enabled = false}
executorNoCameraShake.State = {
    isEnabled = false,
    Connections = {},
    Cache = {},
}

local function v16()
    local v24 = 0
    local v25
    local character
    local humanoid

    while true do
        if (1 == v24) then
            humanoid = nil

            while true do
                if (v25 == 1) then
                    if not character then
                        return
                    end

                    humanoid = character:FindFirstChildOfClass('Humanoid')
                    v25 = 2
                end
                if (v25 == 0) then
                    if not executorNoCameraShake.State.isEnabled then
                        return
                    end

                    character = localPlayer.Character
                    v25 = 1
                end
                if (2 == v25) then
                    if humanoid then
                        humanoid.CameraOffset = Vector3.zero
                    end

                    break
                end
            end

            break
        end
        if (v24 == 0) then
            v25 = 0
            character = nil
            v24 = 1
        end
    end
end

executorNoCameraShake.Enable = function(v28)
    local v29 = 0
    local v30

    while true do
        if (v29 == 0) then
            v30 = 0

            while true do
                if (v30 == 0) then
                    if v28.State.isEnabled then
                        return
                    end

                    v28.Settings.Enabled = true
                    v30 = 1
                end
                if (v30 == 2) then
                    v28.State.Connections.RenderStepBound = true

                    break
                end
                if (v30 == 1) then
                    v28.State.isEnabled = true

                    runService:BindToRenderStep('Vantality_NoShake', Enum.RenderPriority.Camera.Value + 1, v16)

                    v30 = 2
                end
            end

            break
        end
    end
end
executorNoCameraShake.Disable = function(v31)
    local v32 = 0
    local v33

    while true do
        if (v32 == 0) then
            v33 = 0

            while true do
                if (v33 == 0) then
                    if not v31.State.isEnabled then
                        return
                    end

                    v31.Settings.Enabled = false
                    v33 = 1
                end
                if (v33 == 1) then
                    v31.State.isEnabled = false

                    if v31.State.Connections.RenderStepBound then
                        runService:UnbindFromRenderStep('Vantality_NoShake')

                        v31.State.Connections.RenderStepBound = false
                    end

                    break
                end
            end

            break
        end
    end
end
executorNoCameraShake.UpdateSetting = function(v34, v35, v36)
    if (v34.Settings[v35] == nil) then
        return
    end

    v34.Settings[v35] = v36

    if (v35 == 'Enabled') then
        if v36 then
            v34:Enable()
        else
            v34:Disable()
        end
    end
end
executorNoCameraShake.Destroy = function(v38)
    local v39 = 0

    while true do
        if (v39 == 1) then
            v38.State.Cache = {}
            v8.ExecutorNoCameraShake = nil

            break
        end
        if (v39 == 0) then
            v38:Disable()

            v38.State.Connections = {}
            v39 = 1
        end
    end
end

if executorNoCameraShake.Settings.Enabled then
    executorNoCameraShake:Enable()
end

return executorNoCameraShake
