-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local runService = game:GetService('RunService')
local players = game:GetService('Players')
local localPlayer = players.LocalPlayer

if (v8.ExecutorFakeVisuals and (typeof(v8.ExecutorFakeVisuals.Destroy) == 'function')) then
    local v60 = 0
    local v61

    while true do
        if (0 == v60) then
            v61 = 0

            while true do
                if (v61 == 0) then
                    pcall(function()
                        v8.ExecutorFakeVisuals:Destroy()
                    end)
                    task.wait(0.1)

                    break
                end
            end

            break
        end
    end
end

v8.ExecutorFakeVisuals = {}

local executorFakeVisuals = v8.ExecutorFakeVisuals

executorFakeVisuals.Settings = {
    Headless = false,
    Korblox = false,
}
executorFakeVisuals.State = {
    isEnabled = false,
    Connection = nil,
}

local v16 = 'rbxassetid://14331410389'
local v17 = 'rbxassetid://14331410470'
local cFrame2 = CFrame.new(0, 0.9, 0) * CFrame.Angles(0, math.pi, 0)
local vector3_2 = Vector3.new(1, 2, 1)
local vector3_3 = Vector3.new(1, 1, 1)

local function v21()
    local v32 = 0
    local character
    local head
    local rightLeg

    while true do
        if (v32 == 2) then
            rightLeg = character:FindFirstChild('Right Leg')

            if rightLeg then
                if (rightLeg.Transparency == 1) then
                    rightLeg.Transparency = 0
                end

                local fakeKorbloxLeg = rightLeg:FindFirstChild('FakeKorbloxLeg')

                if fakeKorbloxLeg then
                    fakeKorbloxLeg:Destroy()
                end
            end

            break
        end
        if (v32 == 1) then
            head = character:FindFirstChild('Head')

            if head then
                local v69 = 0
                local decal

                while true do
                    if (v69 == 1) then
                        if (decal and (decal.Transparency == 1)) then
                            decal.Transparency = 0
                        end

                        break
                    end
                    if (v69 == 0) then
                        if (head.Transparency == 1) then
                            head.Transparency = 0
                        end

                        decal = head:FindFirstChildOfClass('Decal')
                        v69 = 1
                    end
                end
            end

            v32 = 2
        end
        if (v32 == 0) then
            character = localPlayer and localPlayer.Character

            if not character then
                return
            end

            v32 = 1
        end
    end
end
local function v22()
    local v36 = 0
    local character
    local settings
    local head
    local rightLeg

    while true do
        if (v36 == 0) then
            character = localPlayer.Character

            if not character then
                return
            end

            v36 = 1
        end
        if (v36 == 3) then
            if rightLeg then
                local v71 = 0
                local fakeKorbloxLeg

                while true do
                    if (v71 == 0) then
                        fakeKorbloxLeg = rightLeg:FindFirstChild('FakeKorbloxLeg')

                        if settings.Korblox then
                            local v82 = 0

                            while true do
                                if (v82 == 0) then
                                    if (rightLeg.Transparency ~= 1) then
                                        rightLeg.Transparency = 1
                                    end
                                    if not fakeKorbloxLeg then
                                        local v89 = 0
                                        local specialMesh
                                        local weld

                                        while true do
                                            if (v89 == 3) then
                                                specialMesh.Offset = Vector3.zero
                                                weld = Instance.new('Weld')
                                                weld.Parent = fakeKorbloxLeg
                                                weld.Part0 = rightLeg
                                                v89 = 4
                                            end
                                            if (v89 == 0) then
                                                fakeKorbloxLeg = Instance.new('Part')
                                                fakeKorbloxLeg.Name = 'FakeKorbloxLeg'
                                                fakeKorbloxLeg.Parent = rightLeg
                                                fakeKorbloxLeg.Size = vector3_2
                                                v89 = 1
                                            end
                                            if (v89 == 2) then
                                                specialMesh.Parent = fakeKorbloxLeg
                                                specialMesh.MeshId = v16
                                                specialMesh.TextureId = v17
                                                specialMesh.Scale = vector3_3
                                                v89 = 3
                                            end
                                            if (v89 == 1) then
                                                fakeKorbloxLeg.CanCollide = false
                                                fakeKorbloxLeg.Massless = true
                                                fakeKorbloxLeg.Transparency = 0
                                                specialMesh = Instance.new('SpecialMesh')
                                                v89 = 2
                                            end
                                            if (v89 == 4) then
                                                weld.Part1 = fakeKorbloxLeg
                                                weld.C0 = cFrame2

                                                break
                                            end
                                        end
                                    end

                                    break
                                end
                            end
                        else
                            if (rightLeg.Transparency == 1) then
                                rightLeg.Transparency = 0
                            end
                            if fakeKorbloxLeg then
                                fakeKorbloxLeg:Destroy()
                            end
                        end

                        break
                    end
                end
            end

            break
        end
        if (v36 == 1) then
            settings = executorFakeVisuals.Settings
            head = character:FindFirstChild('Head')
            v36 = 2
        end
        if (v36 == 2) then
            if head then
                if settings.Headless then
                    local v75 = 0
                    local decal

                    while true do
                        if (1 == v75) then
                            if (decal and (decal.Transparency ~= 1)) then
                                decal.Transparency = 1
                            end

                            break
                        end
                        if (0 == v75) then
                            if (head.Transparency ~= 1) then
                                head.Transparency = 1
                            end

                            decal = head:FindFirstChildOfClass('Decal')
                            v75 = 1
                        end
                    end
                else
                    local v77 = 0
                    local decal

                    while true do
                        if (v77 == 1) then
                            if (decal and (decal.Transparency == 1)) then
                                decal.Transparency = 0
                            end

                            break
                        end
                        if (0 == v77) then
                            if (head.Transparency == 1) then
                                head.Transparency = 0
                            end

                            decal = head:FindFirstChildOfClass('Decal')
                            v77 = 1
                        end
                    end
                end
            end

            rightLeg = character:FindFirstChild('Right Leg')
            v36 = 3
        end
    end
end

executorFakeVisuals.Enable = function(v41)
    local v42 = 0

    while true do
        if (v42 == 0) then
            if v41.State.isEnabled then
                return
            end

            v41.State.isEnabled = true
            v42 = 1
        end
        if (1 == v42) then
            v41.State.Connection = runService.RenderStepped:Connect(v22)

            break
        end
    end
end
executorFakeVisuals.Disable = function(v43)
    local v44 = 0
    local v45

    while true do
        if (v44 == 0) then
            v45 = 0

            while true do
                if (v45 == 0) then
                    if not v43.State.isEnabled then
                        return
                    end

                    v43.State.isEnabled = false
                    v45 = 1
                end
                if (v45 == 1) then
                    if v43.State.Connection then
                        v43.State.Connection:Disconnect()

                        v43.State.Connection = nil
                    end

                    v21()

                    break
                end
            end

            break
        end
    end
end
executorFakeVisuals.UpdateSetting = function(v46, v47, v48)
    local v49 = 0

    while true do
        if (0 == v49) then
            if (v46.Settings[v47] == nil) then
                return
            end

            v46.Settings[v47] = v48
            v49 = 1
        end
        if (v49 == 1) then
            if v46.State.isEnabled then
                v22()
            end

            break
        end
    end
end
executorFakeVisuals.Destroy = function(v50)
    local v51 = 0

    while true do
        if (v51 == 0) then
            v50:Disable()

            v8.ExecutorFakeVisuals = nil

            break
        end
    end
end
executorFakeVisuals.SetHeadless = function(v52, v53)
    local v54 = 0
    local v55

    while true do
        if (v54 == 0) then
            v55 = 0

            while true do
                if (v55 == 0) then
                    v52:UpdateSetting('Headless', v53)

                    if (v53 and not v52.State.isEnabled) then
                        v52:Enable()
                    end

                    v55 = 1
                end
                if (v55 == 1) then
                    if (not v52.Settings.Headless and not v52.Settings.Korblox) then
                        v52:Disable()
                    end

                    break
                end
            end

            break
        end
    end
end
executorFakeVisuals.SetKorblox = function(v56, v57)
    local v58 = 0

    while true do
        if (1 == v58) then
            if (not v56.Settings.Headless and not v56.Settings.Korblox) then
                v56:Disable()
            end

            break
        end
        if (v58 == 0) then
            v56:UpdateSetting('Korblox', v57)

            if (v57 and not v56.State.isEnabled) then
                v56:Enable()
            end

            v58 = 1
        end
    end
end

return executorFakeVisuals
