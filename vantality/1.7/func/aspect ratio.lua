-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local runService = game:GetService('RunService')
local currentCamera = workspace.CurrentCamera

if (v8.ExecutorScreenStretch and (typeof(v8.ExecutorScreenStretch.Destroy) == 'function')) then
    local v36 = 0

    while true do
        if (v36 == 0) then
            pcall(function()
                v8.ExecutorScreenStretch:Destroy()
            end)
            task.wait(0.1)

            break
        end
    end
end

v8.ExecutorScreenStretch = {}

local executorScreenStretch = v8.ExecutorScreenStretch

executorScreenStretch.Settings = {
    StretchFactor = 0.75,
    AutoDisableInCutscenes = true,
}
executorScreenStretch.State = {
    isEnabled = false,
    Connection = nil,
}

local function v15()
    local v23 = 0
    local v24

    while true do
        if (v23 == 0) then
            v24 = 0

            while true do
                if (v24 == 0) then
                    if (not currentCamera or not currentCamera.Parent) then
                        local v46 = 0

                        while true do
                            if (0 == v46) then
                                local v48 = 0

                                while true do
                                    if (v48 == 0) then
                                        currentCamera = workspace.CurrentCamera

                                        return
                                    end
                                end
                            end
                        end
                    end
                    if (executorScreenStretch.Settings.StretchFactor == 1) then
                        return
                    end

                    v24 = 1
                end
                if (v24 == 1) then
                    if (executorScreenStretch.Settings.AutoDisableInCutscenes and (currentCamera.CameraType == Enum.CameraType.Scriptable)) then
                        return
                    end

                    currentCamera.CFrame = currentCamera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, executorScreenStretch.Settings.StretchFactor, 0, 0, 0, 1)

                    break
                end
            end

            break
        end
    end
end

executorScreenStretch.Enable = function(v25)
    local v26 = 0

    while true do
        if (v26 == 1) then
            v25.State.isEnabled = true
            v25.State.Connection = runService.RenderStepped:Connect(v15)

            break
        end
        if (v26 == 0) then
            if v25.State.isEnabled then
                return
            end

            v25.Settings.StretchFactor = math.clamp(v25.Settings.StretchFactor, 0.1, 1.5)
            v26 = 1
        end
    end
end
executorScreenStretch.Disable = function(v27)
    local v28 = 0

    while true do
        if (v28 == 1) then
            if v27.State.Connection then
                local v42 = 0

                while true do
                    if (v42 == 0) then
                        v27.State.Connection:Disconnect()

                        v27.State.Connection = nil

                        break
                    end
                end
            end

            break
        end
        if (v28 == 0) then
            if not v27.State.isEnabled then
                return
            end

            v27.State.isEnabled = false
            v28 = 1
        end
    end
end
executorScreenStretch.UpdateSetting = function(v29, v30, v31)
    local v32 = 0

    while true do
        if (v32 == 0) then
            if (v29.Settings[v30] == nil) then
                return
            end
            if ((v30 == 'StretchFactor') and (type(v31) == 'number')) then
                v29.Settings.StretchFactor = math.clamp(v31, 0.1, 1.5)
            elseif (type(v31) == type(v29.Settings[v30])) then
                v29.Settings[v30] = v31
            end

            break
        end
    end
end
executorScreenStretch.Destroy = function(v33)
    local v34 = 0

    while true do
        if (v34 == 0) then
            v33:Disable()

            v8.ExecutorScreenStretch = nil

            break
        end
    end
end

return executorScreenStretch
