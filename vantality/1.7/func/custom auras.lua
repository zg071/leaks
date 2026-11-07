-- by swimhub
local v8 = {}
local players = game:GetService('Players')
local collectionService = game:GetService('CollectionService')
local localPlayer = players.LocalPlayer
local v38 = {}
local v13 = {}
local vantalityVFXObject = 'Vantality_VFX_Object'

local function v15(v25, v26)
    if not v26 then
        return
    end

    local tagged = collectionService:GetTagged(vantalityVFXObject)

    for v51, v52 in ipairs(tagged)do
        if (v52:IsDescendantOf(v26) and (v52:GetAttribute('AuraName') == v25)) then
            v52:Destroy()
        end
    end
end
local function v16(v28, v29)
    local v30 = 0
    local v31
    local humanoid
    local v33

    while true do
        if (v30 == 1) then
            humanoid = v29:FindFirstChildOfClass('Humanoid')

            if (not humanoid or (humanoid.RigType ~= Enum.HumanoidRigType.R6)) then
                return
            end

            v30 = 2
        end
        if (v30 == 3) then
            function v33(v61)
                if v61 then
                    local v65 = 0

                    while true do
                        if (0 == v65) then
                            collectionService:AddTag(v61, vantalityVFXObject)
                            v61:SetAttribute('AuraName', v28)

                            break
                        end
                    end
                end

                return v61
            end

            task.spawn(function()
                pcall(function()
                    v31(v29, v33)
                end)
            end)

            break
        end
        if (v30 == 0) then
            v31 = v38[v28]

            if not v31 then
                return
            end

            v30 = 1
        end
        if (v30 == 2) then
            v15(v28, v29)

            v33 = nil
            v30 = 3
        end
    end
end
local function v17(v34)
    local v35 = 0
    local humanoidRootPart

    while true do
        if (v35 == 1) then
            task.wait(0.5)

            for v62, v63 in pairs(v13)do
                if v63 then
                    v16(v62, v34)
                end
            end

            break
        end
        if (v35 == 0) then
            humanoidRootPart = v34:WaitForChild('HumanoidRootPart', 5)

            if not humanoidRootPart then
                return
            end

            v35 = 1
        end
    end
end

v8.Init = function(v37, v38)
    local v39 = 0

    while true do
        if (1 == v39) then
            v37.Connection = localPlayer.CharacterAdded:Connect(v17)

            break
        end
        if (v39 == 0) then
            v38 = v38

            if localPlayer.Character then
                v17(localPlayer.Character)
            end

            v39 = 1
        end
    end
end
v8.ToggleAura = function(v40, v41, v42)
    local v43 = 0
    local character

    while true do
        if (v43 == 1) then
            if character then
                if v42 then
                    v16(v41, character)
                else
                    v15(v41, character)
                end
            end

            break
        end
        if (v43 == 0) then
            v13[v41] = v42
            character = localPlayer.Character
            v43 = 1
        end
    end
end
v8.GetAuraNames = function(v45)
    local v46 = 0
    local v47

    while true do
        local v53 = 0

        while true do
            if (v53 == 0) then
                if (v46 == 0) then
                    v47 = {}

                    for v66, v67 in pairs(v38)do
                        table.insert(v47, v66)
                    end

                    v46 = 1
                end
                if (v46 == 1) then
                    table.sort(v47)

                    return v47
                end

                break
            end
        end
    end
end
v8.Destroy = function(v48)
    if v48.Connection then
        local v56 = 0

        while true do
            if (v56 == 0) then
                v48.Connection:Disconnect()

                v48.Connection = nil

                break
            end
        end
    end

    local tagged = collectionService:GetTagged(vantalityVFXObject)

    for v54, v55 in ipairs(tagged)do
        pcall(function()
            v55:Destroy()
        end)
    end

    v13 = {}
end

return v8
