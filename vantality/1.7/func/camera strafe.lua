-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')
local workspace = game:GetService('Workspace')

if (v8.CameraTiltTest and (typeof(v8.CameraTiltTest.Destroy) == 'function')) then
    local v55 = 0

    while true do
        if (v55 == 0) then
            pcall(function()
                v8.CameraTiltTest:Destroy()
            end)
            task.wait(0.1)

            break
        end
    end
end

v8.CameraTiltTest = {}

local cameraTiltTest = v8.CameraTiltTest
local vantalityCameraTiltEffect = 'Vantality_CameraTiltEffect'

cameraTiltTest.State = {
    isEnabled = false,
    CurrentTilt = 0,
    isBound = false,
}

local v16 = {
    TiltAngle = 3,
    Smoothness = 6,
}

cameraTiltTest.Settings = setmetatable({}, {
    __index = function(v28, v29)
        if (v29 == 'Enabled') then
            return cameraTiltTest.State.isEnabled
        end

        return v16[v29]
    end,
    __newindex = function(v30, v31, v32)
        if (v31 == 'Enabled') then
            if v32 then
                cameraTiltTest:Enable()
            else
                cameraTiltTest:Disable()
            end
        else
            v16[v31] = v32
        end
    end,
})

local mathRad = math.rad
local v19 = function(v33, v34, v35)
    return v33 + ((v34 - v33) * v35)
end

local function v20(v36)
    local v37 = 0
    local currentCamera
    local tiltAngle
    local isKeyDown
    local isKeyDown2
    local mathMin

    while true do
        if (3 == v37) then
            mathMin = math.min(v36 * cameraTiltTest.Settings.Smoothness, 1)
            cameraTiltTest.State.CurrentTilt = v19(cameraTiltTest.State.CurrentTilt, tiltAngle, mathMin)
            v37 = 4
        end
        if (v37 == 0) then
            currentCamera = workspace.CurrentCamera

            if not currentCamera then
                return
            end

            v37 = 1
        end
        if (4 == v37) then
            if (math.abs(cameraTiltTest.State.CurrentTilt) > 0.01) then
                currentCamera.CFrame = currentCamera.CFrame * CFrame.Angles(0, 0, mathRad(cameraTiltTest.State.CurrentTilt))
            end

            break
        end
        if (1 == v37) then
            tiltAngle = 0
            isKeyDown = userInputService:IsKeyDown(Enum.KeyCode.A)
            v37 = 2
        end
        if (2 == v37) then
            isKeyDown2 = userInputService:IsKeyDown(Enum.KeyCode.D)

            if (isKeyDown and not isKeyDown2) then
                tiltAngle = cameraTiltTest.Settings.TiltAngle
            elseif (isKeyDown2 and not isKeyDown) then
                tiltAngle = -cameraTiltTest.Settings.TiltAngle
            end

            v37 = 3
        end
    end
end

cameraTiltTest.Enable = function(v43)
    local v44 = 0

    while true do
        if (v44 == 0) then
            if v43.State.isEnabled then
                return
            end

            v43.State.isEnabled = true
            v44 = 1
        end
        if (v44 == 1) then
            if not v43.State.isBound then
                runService:BindToRenderStep(vantalityCameraTiltEffect, Enum.RenderPriority.Camera.Value + 1, v20)

                v43.State.isBound = true
            end

            break
        end
    end
end
cameraTiltTest.Disable = function(v45)
    local v46 = 0

    while true do
        if (v46 == 1) then
            if v45.State.isBound then
                local v66 = 0

                while true do
                    if (v66 == 0) then
                        runService:UnbindFromRenderStep(vantalityCameraTiltEffect)

                        v45.State.isBound = false

                        break
                    end
                end
            end

            v45.State.CurrentTilt = 0

            break
        end
        if (v46 == 0) then
            if not v45.State.isEnabled then
                return
            end

            v45.State.isEnabled = false
            v46 = 1
        end
    end
end
cameraTiltTest.UpdateSetting = function(v47, v48, v49)
    local v50 = 0
    local v51

    while true do
        if (v50 == 0) then
            v51 = 0

            while true do
                if (v51 == 0) then
                    if (v16[v48] == nil) then
                        return
                    end

                    v16[v48] = v49

                    break
                end
            end

            break
        end
    end
end
cameraTiltTest.Destroy = function(v52)
    local v53 = 0

    while true do
        if (0 == v53) then
            v52:Disable()

            v8.CameraTiltTest = nil

            break
        end
    end
end

return cameraTiltTest
