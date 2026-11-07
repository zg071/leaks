-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local players = game:GetService('Players')

if (v8.ExecutorChinaHat and (typeof(v8.ExecutorChinaHat.Destroy) == 'function')) then
    local v62 = 0

    while true do
        if (v62 == 0) then
            pcall(function()
                v8.ExecutorChinaHat:Destroy()
            end)
            task.wait(0.1)

            break
        end
    end
end

v8.ExecutorChinaHat = {}

local executorChinaHat = v8.ExecutorChinaHat

executorChinaHat.Settings = {
    Color = Color3.fromRGB(255, 255, 255),
    Radius = 2,
    Height = 0.8,
    Transparency = 0,
    HatMode = 'Beam',
}
executorChinaHat.State = {
    isEnabled = false,
    activeObjects = nil,
    Connections = {},
}

local function v14()
    local v24 = 0
    local v25
    local activeObjects
    local settings

    while true do
        if (v24 == 1) then
            settings = nil

            while true do
                if (v25 == 0) then
                    activeObjects = executorChinaHat.State.activeObjects
                    settings = executorChinaHat.Settings
                    v25 = 1
                end
                if (v25 == 1) then
                    if not activeObjects then
                        return
                    end
                    if ((settings.HatMode == 'Beam') and activeObjects.Beams) then
                        for v97, v98 in ipairs(activeObjects.Beams)do
                            local v99 = 0
                            local v100

                            while true do
                                if (v99 == 0) then
                                    v100 = 0

                                    while true do
                                        if (0 == v100) then
                                            v98.Color = ColorSequence.new(settings.Color)
                                            v98.Transparency = NumberSequence.new({
                                                NumberSequenceKeypoint.new(0, settings.Transparency),
                                                NumberSequenceKeypoint.new(1, settings.Transparency * 2),
                                            })

                                            break
                                        end
                                    end

                                    break
                                end
                            end
                        end
                    elseif ((settings.HatMode == 'Cone') and activeObjects.Adornment) then
                        local v109 = 0
                        local v110

                        while true do
                            if (v109 == 0) then
                                v110 = 0

                                while true do
                                    if (v110 == 0) then
                                        activeObjects.Adornment.Color3 = settings.Color
                                        activeObjects.Adornment.Transparency = settings.Transparency

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

            break
        end
        if (v24 == 0) then
            v25 = 0
            activeObjects = nil
            v24 = 1
        end
    end
end
local function v15(v28)
    local head = v28:FindFirstChild('Head')

    if not head then
        return
    end
    if executorChinaHat.State.activeObjects then
        executorChinaHat.State.activeObjects.Anchor:Destroy()
    end

    local part = Instance.new('Part')

    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Transparency = 1
    part.CanCollide = false
    part.Massless = true

    local weldConstraint = Instance.new('WeldConstraint')

    weldConstraint.Part0 = head
    weldConstraint.Part1 = part
    weldConstraint.Parent = part
    part.CFrame = head.CFrame * CFrame.new(0, 0.5, 0)
    part.Parent = workspace.CurrentCamera

    local v42 = {Anchor = part}

    if (executorChinaHat.Settings.HatMode == 'Beam') then
        local v66 = 0
        local attachment

        while true do
            if (v66 == 2) then
                for v77 = 1, 350 do
                    local v78 = 0
                    local v79
                    local attachment2
                    local beam

                    while true do
                        if (v78 == 0) then
                            v79 = (v77 / 350) * math.pi * 2
                            attachment2 = Instance.new('Attachment')
                            attachment2.Position = Vector3.new(executorChinaHat.Settings.Radius * math.cos(v79), 0, executorChinaHat.Settings.Radius * math.sin(v79))
                            v78 = 1
                        end
                        if (v78 == 1) then
                            local v102 = 0

                            while true do
                                if (v102 == 0) then
                                    attachment2.Parent = part
                                    beam = Instance.new('Beam')
                                    v102 = 1
                                end
                                if (v102 == 1) then
                                    beam.Attachment0 = attachment
                                    v78 = 2

                                    break
                                end
                            end
                        end
                        if (v78 == 3) then
                            beam.Width1 = 0.02
                            beam.Segments = 2
                            beam.Parent = part
                            v78 = 4
                        end
                        if (v78 == 4) then
                            table.insert(v42.Beams, beam)

                            break
                        end
                        if (v78 == 2) then
                            beam.Attachment1 = attachment2
                            beam.FaceCamera = true
                            beam.Width0 = 0.05
                            v78 = 3
                        end
                    end
                end

                break
            end
            if (0 == v66) then
                v42.Beams = {}
                attachment = Instance.new('Attachment')
                v66 = 1
            end
            if (v66 == 1) then
                attachment.Position = Vector3.new(0, executorChinaHat.Settings.Height, 0)
                attachment.Parent = part
                v66 = 2
            end
        end
    elseif (executorChinaHat.Settings.HatMode == 'Cone') then
        local v70 = 0
        local coneHandleAdornment

        while true do
            if (v70 == 3) then
                v42.Adornment = coneHandleAdornment

                break
            end
            if (2 == v70) then
                coneHandleAdornment.CFrame = CFrame.Angles(math.rad(90), 0, 0)
                coneHandleAdornment.Parent = part
                v70 = 3
            end
            if (v70 == 1) then
                coneHandleAdornment.Radius = executorChinaHat.Settings.Radius
                coneHandleAdornment.Height = executorChinaHat.Settings.Height
                v70 = 2
            end
            if (v70 == 0) then
                coneHandleAdornment = Instance.new('ConeHandleAdornment')
                coneHandleAdornment.Adornee = part
                v70 = 1
            end
        end
    end

    executorChinaHat.State.activeObjects = v42

    v14()
end

executorChinaHat.SetHatMode = function(v44, v45)
    v44:UpdateSetting('HatMode', v45)
end
executorChinaHat.Enable = function(v46)
    if v46.State.isEnabled then
        return
    end

    v46.State.isEnabled = true

    local localPlayer = players.LocalPlayer

    v46.State.Connections.Added = localPlayer.CharacterAdded:Connect(function(v63)
        local v64 = 0
        local v65

        while true do
            if (v64 == 0) then
                v65 = 0

                while true do
                    if (v65 == 0) then
                        task.wait(0.2)

                        if v46.State.isEnabled then
                            v15(v63)
                        end

                        break
                    end
                end

                break
            end
        end
    end)
    v46.State.Connections.Removing = localPlayer.CharacterRemoving:Connect(function()
        if v46.State.activeObjects then
            local v68 = 0

            while true do
                if (v68 == 0) then
                    v46.State.activeObjects.Anchor:Destroy()

                    v46.State.activeObjects = nil

                    break
                end
            end
        end
    end)

    if localPlayer.Character then
        v15(localPlayer.Character)
    end
end
executorChinaHat.Disable = function(v51)
    local v52 = 0
    local v53

    while true do
        if (0 == v52) then
            v53 = 0

            while true do
                if (v53 == 0) then
                    if not v51.State.isEnabled then
                        return
                    end

                    v51.State.isEnabled = false
                    v53 = 1
                end
                if (1 == v53) then
                    for v94, v95 in pairs(v51.State.Connections)do
                        v95:Disconnect()
                    end

                    v51.State.Connections = {}
                    v53 = 2
                end
                if (v53 == 2) then
                    if v51.State.activeObjects then
                        local v96 = 0

                        while true do
                            if (0 == v96) then
                                v51.State.activeObjects.Anchor:Destroy()

                                v51.State.activeObjects = nil

                                break
                            end
                        end
                    end

                    break
                end
            end

            break
        end
    end
end
executorChinaHat.UpdateSetting = function(v54, v55, v56)
    local v57 = 0
    local v58

    while true do
        if (v57 == 0) then
            v58 = 0

            while true do
                if (v58 == 0) then
                    if (v54.Settings[v55] == nil) then
                        return
                    end

                    v54.Settings[v55] = v56
                    v58 = 1
                end
                if (v58 == 1) then
                    if v54.State.isEnabled then
                        if ((v55 == 'Radius') or (v55 == 'Height') or (v55 == 'HatMode')) then
                            if players.LocalPlayer.Character then
                                v15(players.LocalPlayer.Character)
                            end
                        else
                            v14()
                        end
                    end

                    break
                end
            end

            break
        end
    end
end
executorChinaHat.Destroy = function(v59)
    local v60 = 0

    while true do
        if (v60 == 0) then
            v59:Disable()

            v8.ExecutorChinaHat = nil

            break
        end
    end
end

return executorChinaHat
