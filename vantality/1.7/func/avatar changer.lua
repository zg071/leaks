-- by swimhub
local v8 = (getgenv and getgenv()) or _G

if (v8.ExecutorAvatarChanger and (typeof(v8.ExecutorAvatarChanger.Destroy) == 'function')) then
    local v105 = 0

    while true do
        if (v105 == 0) then
            pcall(function()
                v8.ExecutorAvatarChanger:Destroy()
            end)
            task.wait(0.1)

            break
        end
    end
end

v8.ExecutorAvatarChanger = {}

local executorAvatarChanger = v8.ExecutorAvatarChanger
local players = game:GetService('Players')
local httpService = game:GetService('HttpService')
local coreGui = game:GetService('CoreGui')
local workspace = game:GetService('Workspace')
local localPlayer = players.LocalPlayer

executorAvatarChanger.Settings = {
    Enabled = false,
    TargetUsername = '',
}

local settings = executorAvatarChanger.Settings

executorAvatarChanger.State = {
    IsBusy = false,
    Connections = {},
    ProcessedImages = {},
    HttpCache = {},
    LastFetchTick = 0,
}

local state = executorAvatarChanger.State
local vANTALITYASSETSCACHERELEASE = 'VANTALITY_ASSETS_CACHE_RELEASE'
local child = coreGui:FindFirstChild(vANTALITYASSETSCACHERELEASE)

if not child then
    local v106 = 0

    while true do
        if (v106 == 0) then
            child = Instance.new('Folder')
            child.Name = vANTALITYASSETSCACHERELEASE
            v106 = 1
        end
        if (v106 == 1) then
            child.Parent = coreGui

            break
        end
    end
end

local v22 = request or http_request or (http and http.request) or (syn and syn.request) or (fluxus and fluxus.request)

local function v23(v41)
    if (v41:IsA('BasePart') or v41:IsA('Decal')) then
        v41.Transparency = 1
    end

    for v107, v108 in pairs(v41:GetDescendants())do
        if (v108:IsA('BasePart') or v108:IsA('Decal')) then
            v108.Transparency = 1
        end
    end
end
local function v24(v42)
    local v43 = 0
    local v44

    while true do
        if (v43 == 0) then
            v44 = 0

            while true do
                if (v44 == 0) then
                    if (v42:IsA('BasePart') or v42:IsA('Decal')) then
                        v42.Transparency = 0
                    end

                    for v208, v209 in pairs(v42:GetDescendants())do
                        if (v209:IsA('BasePart') or v209:IsA('Decal')) then
                            v209.Transparency = 0
                        end
                    end

                    break
                end
            end

            break
        end
    end
end
local function v25(v45, v46)
    local v47 = 0
    local toString
    local child2
    local pcallOk
    local v51
    local v52

    while true do
        if (v47 == 2) then
            local v111 = 0
            local v112

            while true do
                if (0 == v111) then
                    v112 = 0

                    while true do
                        if (v112 == 1) then
                            v47 = 3

                            break
                        end
                        if (v112 == 0) then
                            v51 = false
                            v52 = 0
                            v112 = 1
                        end
                    end

                    break
                end
            end
        end
        if (1 == v47) then
            if child2 then
                return child2:Clone()
            end

            pcallOk = nil
            v47 = 2
        end
        if (v47 == 0) then
            local v113 = 0

            while true do
                if (0 == v113) then
                    toString = tostring(v45) .. '_' .. tostring(v46)
                    child2 = child:FindFirstChild(toString)
                    v113 = 1
                end
                if (v113 == 1) then
                    v47 = 1

                    break
                end
            end
        end
        if (v47 == 3) then
            while not v51 and (v52 < 3) do
                local v138 = 0

                while true do
                    if (v138 == 0) then
                        v51, pcallOk = pcall(function()
                            return game:GetObjects('rbxassetid://' .. v45)
                        end)

                        if (not v51 or not pcallOk) then
                            local v230 = 0

                            while true do
                                if (v230 == 0) then
                                    v52 = v52 + 1

                                    task.wait(0.2)

                                    break
                                end
                            end
                        end

                        break
                    end
                end
            end

            if (pcallOk and (#pcallOk > 0)) then
                local v210 = pcallOk[1]

                if v210:IsA('Model') then
                    local accessory = v210:FindFirstChildWhichIsA('Accessory') or v210:FindFirstChildWhichIsA('Clothing') or v210:FindFirstChildWhichIsA('ShirtGraphic') or v210:FindFirstChildWhichIsA('Decal')

                    if accessory then
                        v210 = accessory
                    end
                end

                v210.Name = toString
                v210.Parent = child

                return v210:Clone()
            end

            v47 = 4
        end
        if (v47 == 4) then
            return nil
        end
    end
end

local new = {
    HatAttachment = {
        Part = 'Head',
        C0 = CFrame.new(0, 0.6, 0),
    },
    HairAttachment = {
        Part = 'Head',
        C0 = CFrame.new(0, 0.6, 0),
    },
    FaceFrontAttachment = {
        Part = 'Head',
        C0 = CFrame.new(0, 0, -0.6),
    },
    FaceCenterAttachment = {
        Part = 'Head',
        C0 = CFrame.new(0, 0, 0),
    },
    NeckAttachment = {
        Part = 'Torso',
        C0 = CFrame.new(0, 1, 0),
    },
    BodyFrontAttachment = {
        Part = 'Torso',
        C0 = CFrame.new(0, 0, -0.5),
    },
    BodyBackAttachment = {
        Part = 'Torso',
        C0 = CFrame.new(0, 0, 0.5),
    },
    WaistBackAttachment = {
        Part = 'Torso',
        C0 = CFrame.new(0, -0.5, 0.5),
    },
    WaistFrontAttachment = {
        Part = 'Torso',
        C0 = CFrame.new(0, -0.5, -0.5),
    },
    WaistCenterAttachment = {
        Part = 'Torso',
        C0 = CFrame.new(0, -1, 0),
    },
    RightShoulderAttachment = {
        Part = 'Torso',
        C0 = CFrame.new(1, 0.5, 0),
    },
    LeftShoulderAttachment = {
        Part = 'Torso',
        C0 = CFrame.new(-1, 0.5, 0),
    },
    RightGripAttachment = {
        Part = 'Right Arm',
        C0 = CFrame.new(0, -1, 0),
    },
}

local function v27(v53, v54)
    local v55 = 0
    local handle
    local attachment
    local weld
    local bodyBackAttachment

    while true do
        if (v55 == 3) then
            bodyBackAttachment = nil

            if (attachment and new[attachment.Name]) then
                bodyBackAttachment = new[attachment.Name]
            elseif (attachment and (attachment.Name:find('Back') or attachment.Name:find('Wing'))) then
                bodyBackAttachment = new.BodyBackAttachment
            end
            if bodyBackAttachment then
                local v159 = 0
                local torso

                while true do
                    if (v159 == 0) then
                        torso = v53:FindFirstChild(bodyBackAttachment.Part) or v53:FindFirstChild('Torso') or v53:FindFirstChild('Head')

                        if torso then
                            weld.Part0 = torso
                            weld.C0 = bodyBackAttachment.C0

                            if attachment then
                                weld.C1 = attachment.CFrame
                            end
                        end

                        break
                    end
                end
            else
                local fakeHead = v53:FindFirstChild('FakeHead') or v53:FindFirstChild('Head')

                if fakeHead then
                    local v212 = 0

                    while true do
                        if (v212 == 0) then
                            weld.Part0 = fakeHead
                            weld.C0 = CFrame.new(0, 0.5, 0)

                            break
                        end
                    end
                end
            end

            v55 = 4
        end
        if (v55 == 4) then
            if weld.Part0 then
                local v162 = 0
                local v163

                while true do
                    if (v162 == 0) then
                        v163 = 0

                        while true do
                            if (v163 == 0) then
                                weld.Part1 = handle
                                weld.Parent = weld.Part0

                                break
                            end
                        end

                        break
                    end
                end
            else
                local v164 = 0
                local head

                while true do
                    if (v164 == 0) then
                        head = v53:FindFirstChild('Head')

                        if head then
                            local v243 = 0
                            local v244

                            while true do
                                if (v243 == 0) then
                                    v244 = 0

                                    while true do
                                        if (v244 == 1) then
                                            weld.C0 = CFrame.new(0, 0.5, 0)
                                            weld.Parent = head

                                            break
                                        end
                                        if (v244 == 0) then
                                            weld.Part0 = head
                                            weld.Part1 = handle
                                            v244 = 1
                                        end
                                    end

                                    break
                                end
                            end
                        end

                        break
                    end
                end
            end

            break
        end
        if (v55 == 2) then
            local v114 = 0

            while true do
                if (0 == v114) then
                    attachment = handle:FindFirstChildOfClass('Attachment')
                    weld = Instance.new('Weld')
                    v114 = 1
                end
                if (v114 == 1) then
                    weld.Name = 'VantalityWeld'
                    v55 = 3

                    break
                end
            end
        end
        if (v55 == 0) then
            handle = v54:FindFirstChild('Handle')

            if not handle then
                return
            end

            for v139, v140 in pairs(v54:GetDescendants())do
                if (v140:IsA('Script') or v140:IsA('LocalScript')) then
                    v140:Destroy()
                end
            end

            v55 = 1
        end
        if (v55 == 1) then
            handle.Anchored = false
            handle.CanCollide = false
            v54.Parent = v53
            v55 = 2
        end
    end
end
local function v28(v60)
    local v61 = 0
    local folder
    local v63
    local v64
    local v65
    local head
    local v67
    local fakeHead

    while true do
        if (v61 == 4) then
            v67 = nil

            function v67(v141, v142)
                local v143 = 0

                while true do
                    if (v143 == 1) then
                        v141.Parent = folder

                        v23(v141)

                        break
                    end
                    if (v143 == 0) then
                        if not v141 then
                            return
                        end
                        if v142 then
                            v141:SetAttribute('VantalityOrigin', v142)
                        end

                        v143 = 1
                    end
                end
            end

            for v144, v145 in pairs(v60:GetChildren())do
                if (v145:IsA('Accessory') or v145:IsA('Clothing') or v145:IsA('BodyColors') or v145:IsA('ShirtGraphic')) then
                    v67(v145, 'Character')
                end
            end

            v61 = 5
        end
        if (3 == v61) then
            head = v60:FindFirstChild('Head')

            if head then
                local v166 = 0
                local mesh

                while true do
                    if (v166 == 0) then
                        mesh = head:FindFirstChild('Mesh')

                        if (mesh and (mesh:IsA('SpecialMesh') or mesh:IsA('BlockMesh'))) then
                            v63.OriginalFace = mesh.TextureId
                        end

                        break
                    end
                end
            end

            state[v60] = v63
            v61 = 4
        end
        if (v61 == 2) then
            local v119 = 0

            while true do
                if (v119 == 1) then
                    v63.OriginalColors = v64
                    v61 = 3

                    break
                end
                if (v119 == 0) then
                    v65 = {
                        'Head',
                        'FakeHead',
                        'Torso',
                        'Left Arm',
                        'Right Arm',
                        'Left Leg',
                        'Right Leg',
                    }

                    for v214, v215 in pairs(v65)do
                        local v216 = 0
                        local child2

                        while true do
                            if (v216 == 0) then
                                child2 = v60:FindFirstChild(v215)

                                if (child2 and child2:IsA('BasePart')) then
                                    v64[v215] = child2.Color
                                end

                                break
                            end
                        end
                    end

                    v119 = 1
                end
            end
        end
        if (v61 == 1) then
            folder.Parent = v60
            v63 = {}
            v64 = {}
            v61 = 2
        end
        if (0 == v61) then
            local v121 = 0

            while true do
                if (v121 == 1) then
                    folder.Name = 'Vantality_Backup'
                    v61 = 1

                    break
                end
                if (v121 == 0) then
                    if v60:FindFirstChild('Vantality_Backup') then
                        return
                    end

                    folder = Instance.new('Folder')
                    v121 = 1
                end
            end
        end
        if (v61 == 5) then
            fakeHead = v60:FindFirstChild('FakeHead')

            if fakeHead then
                if fakeHead:IsA('MeshPart') then
                    state[v60].OriginalFakeHeadTex = fakeHead.TextureID
                    fakeHead.TextureID = ''
                end

                for v189, v190 in pairs(fakeHead:GetChildren())do
                    local v191 = 0
                    local v192
                    local name
                    local lower

                    while true do
                        if (v191 == 1) then
                            lower = nil

                            while true do
                                if (v192 == 1) then
                                    if (name:find('#ACCESSORY') or name:find('Pal Hair') or lower:find('hair') or lower:find('hat') or v190:IsA('Accessory') or v190:IsA('Decal')) then
                                        v67(v190, 'FakeHead')
                                    end

                                    break
                                end
                                if (v192 == 0) then
                                    name = v190.Name
                                    lower = name:lower()
                                    v192 = 1
                                end
                            end

                            break
                        end
                        if (v191 == 0) then
                            v192 = 0
                            name = nil
                            v191 = 1
                        end
                    end
                end
            end
            if head then
                for v195, v196 in pairs(head:GetChildren())do
                    if v196:IsA('Decal') then
                        v67(v196, 'Head')
                    end
                end
            end

            break
        end
    end
end
local function v29(v69)
    local v70 = 0
    local vantalityBackup
    local v72
    local humanoid

    while true do
        if (v70 == 3) then
            humanoid = v69:FindFirstChild('Humanoid')

            if humanoid then
                humanoid.DisplayName = localPlayer.DisplayName
            end

            break
        end
        if (v70 == 0) then
            if not v69 then
                return
            end

            for v146, v147 in pairs(v69:GetDescendants())do
                if v147:GetAttribute('VantalityItem') then
                    v147:Destroy()
                end
            end

            v70 = 1
        end
        if (v70 == 1) then
            local v122 = 0

            while true do
                if (v122 == 1) then
                    v70 = 2

                    break
                end
                if (v122 == 0) then
                    vantalityBackup = v69:FindFirstChild('Vantality_Backup')

                    if vantalityBackup then
                        local v223 = 0

                        while true do
                            if (0 == v223) then
                                for v275, v276 in pairs(vantalityBackup:GetChildren())do
                                    local v277 = 0
                                    local value

                                    while true do
                                        if (1 == v277) then
                                            if (value == 'FakeHead') then
                                                local fakeHead = v69:FindFirstChild('FakeHead')

                                                if fakeHead then
                                                    v276.Parent = fakeHead
                                                end
                                            elseif (value == 'Head') then
                                                local head = v69:FindFirstChild('Head')

                                                if head then
                                                    v276.Parent = head
                                                end
                                            else
                                                v276.Parent = v69
                                            end

                                            break
                                        end
                                        if (v277 == 0) then
                                            local v290 = 0

                                            while true do
                                                if (0 == v290) then
                                                    value = v276:GetAttribute('VantalityOrigin')

                                                    v24(v276)

                                                    v290 = 1
                                                end
                                                if (v290 == 1) then
                                                    v277 = 1

                                                    break
                                                end
                                            end
                                        end
                                    end
                                end

                                vantalityBackup:Destroy()

                                break
                            end
                        end
                    end

                    v122 = 1
                end
            end
        end
        if (v70 == 2) then
            local v123 = 0

            while true do
                if (v123 == 0) then
                    v72 = state[v69]

                    if v72 then
                        if v72.OriginalColors then
                            for v259, v260 in pairs(v72.OriginalColors)do
                                local v261 = 0
                                local child2

                                while true do
                                    if (0 == v261) then
                                        child2 = v69:FindFirstChild(v259)

                                        if (child2 and child2:IsA('BasePart')) then
                                            child2.Color = v260
                                        end

                                        break
                                    end
                                end
                            end
                        end
                        if v72.OriginalFace then
                            local v247 = 0
                            local head

                            while true do
                                if (v247 == 0) then
                                    head = v69:FindFirstChild('Head')

                                    if (head and head:FindFirstChild('Mesh')) then
                                        head.Mesh.TextureId = v72.OriginalFace
                                    end

                                    break
                                end
                            end
                        end
                        if v72.OriginalFakeHeadTex then
                            local v249 = 0
                            local fakeHead

                            while true do
                                if (v249 == 0) then
                                    fakeHead = v69:FindFirstChild('FakeHead')

                                    if (fakeHead and fakeHead:IsA('MeshPart')) then
                                        fakeHead.TextureID = v72.OriginalFakeHeadTex
                                    end

                                    break
                                end
                            end
                        end
                    end

                    v123 = 1
                end
                if (v123 == 1) then
                    v70 = 3

                    break
                end
            end
        end
    end
end
local function v30(v74)
    local v75 = 0
    local targetUsername
    local humanoid
    local v78
    local v79
    local pcallOk
    local httpCache
    local decoded

    while true do
        if (0 == v75) then
            if not settings.Enabled then
                return
            end
            if state.IsBusy then
                return
            end

            state.IsBusy = true
            targetUsername = settings.TargetUsername
            v75 = 1
        end
        if (v75 == 3) then
            if (not v79 or not pcallOk) then
                local v170 = 0

                while true do
                    if (v170 == 0) then
                        local v224 = 0

                        while true do
                            if (0 == v224) then
                                state.IsBusy = false

                                return
                            end
                        end
                    end
                end
            end

            httpCache = state.HttpCache[pcallOk]

            if not httpCache then
                local v171 = 0
                local tick
                local v22_2
                local v174
                local v175

                while true do
                    if (v171 == 0) then
                        tick = tick()

                        if ((tick - state.LastFetchTick) < 1) then
                            task.wait(1 - (tick - state.LastFetchTick))
                        end

                        v171 = 1
                    end
                    if (v171 == 2) then
                        v175 = 0

                        while not v174 and (v175 < 3) do
                            v22_2 = v22({
                                Url = 'https://avatar.roblox.com/v1/users/' .. pcallOk .. '/avatar',
                                Method = 'GET',
                            })

                            if (v22_2 and (v22_2.StatusCode == 200)) then
                                local v264 = 0

                                while true do
                                    if (v264 == 0) then
                                        v174 = true
                                        httpCache = v22_2.Body
                                        v264 = 1
                                    end
                                    if (v264 == 1) then
                                        state.HttpCache[pcallOk] = httpCache
                                        state.LastFetchTick = tick()

                                        break
                                    end
                                end
                            else
                                local v265 = 0

                                while true do
                                    if (v265 == 0) then
                                        v175 = v175 + 1

                                        task.wait(0.5)

                                        break
                                    end
                                end
                            end
                        end

                        v171 = 3
                    end
                    if (1 == v171) then
                        local v225 = 0

                        while true do
                            if (v225 == 1) then
                                v171 = 2

                                break
                            end
                            if (v225 == 0) then
                                v22_2 = nil
                                v174 = false
                                v225 = 1
                            end
                        end
                    end
                    if (v171 == 3) then
                        if not v174 then
                            local v251 = 0

                            while true do
                                if (v251 == 0) then
                                    warn('[Vantality] Failed to fetch avatar data for ' .. targetUsername)

                                    state.IsBusy = false
                                    v251 = 1
                                end
                                if (v251 == 1) then
                                    return
                                end
                            end
                        end

                        break
                    end
                end
            end

            decoded = httpService:JSONDecode(httpCache)
            v75 = 4
        end
        if (v75 == 2) then
            v78 = state[v74]

            if (v78 and v78.OriginalFace) then
                local v176 = 0
                local head

                while true do
                    if (v176 == 0) then
                        head = v74:FindFirstChild('Head')

                        if (head and head:FindFirstChild('Mesh')) then
                            head.Mesh.TextureId = v78.OriginalFace
                        end

                        break
                    end
                end
            end

            for v148, v149 in pairs(v74:GetDescendants())do
                if v149:GetAttribute('VantalityItem') then
                    v149:Destroy()
                end
            end

            v79, pcallOk = pcall(function()
                return players:GetUserIdFromNameAsync(targetUsername)
            end)
            v75 = 3
        end
        if (1 == v75) then
            if (targetUsername == '') then
                local v178 = 0

                while true do
                    if (v178 == 0) then
                        local v226 = 0

                        while true do
                            if (v226 == 0) then
                                state.IsBusy = false

                                return
                            end
                        end
                    end
                end
            end

            humanoid = v74:WaitForChild('Humanoid', 10)

            if not humanoid then
                local v179 = 0

                while true do
                    if (v179 == 0) then
                        state.IsBusy = false

                        return
                    end
                end
            end

            v28(v74)

            v75 = 2
        end
        if (v75 == 4) then
            if decoded.bodyColors then
                local v180 = 0
                local v181
                local v182
                local v183

                while true do
                    if (2 == v180) then
                        for v231, v232 in pairs(v183)do
                            local child2 = v74:FindFirstChild(v231)

                            if (child2 and child2:IsA('BasePart')) then
                                child2.Color = v232

                                if child2:IsA('MeshPart') then
                                    child2.TextureID = ''
                                end
                            end
                        end

                        break
                    end
                    if (v180 == 1) then
                        v182 = {
                            Head = v181(decoded.bodyColors.headColorId),
                            Torso = v181(decoded.bodyColors.torsoColorId),
                            LeftArm = v181(decoded.bodyColors.leftArmColorId),
                            RightArm = v181(decoded.bodyColors.rightArmColorId),
                            LeftLeg = v181(decoded.bodyColors.leftLegColorId),
                            RightLeg = v181(decoded.bodyColors.rightLegColorId),
                        }
                        v183 = {
                            Head = v182.Head,
                            FakeHead = v182.Head,
                            Torso = v182.Torso,
                            ['Left Arm'] = v182.LeftArm,
                            ['Right Arm'] = v182.RightArm,
                            ['Left Leg'] = v182.LeftLeg,
                            ['Right Leg'] = v182.RightLeg,
                        }
                        v180 = 2
                    end
                    if (v180 == 0) then
                        v181 = nil

                        function v181(v234)
                            return BrickColor.new(v234).Color
                        end

                        v180 = 1
                    end
                end
            end
            if decoded.assets then
                for v198, v199 in pairs(decoded.assets)do
                    local v200 = 0
                    local id
                    local toString

                    while true do
                        if (v200 == 1) then
                            task.spawn(function()
                                local v254 = 0
                                local v25_2

                                while true do
                                    if (v254 == 1) then
                                        if ((toString == 'Shirt') or (toString == 'Pants') or (toString == 'TShirt')) then
                                            local v295 = 0

                                            while true do
                                                if (v295 == 0) then
                                                    v25_2 = v25(id, toString)

                                                    if v25_2 then
                                                        v25_2.Parent = v74
                                                    end

                                                    break
                                                end
                                            end
                                        elseif not (toString:find('Jacket') or toString:find('Sweater') or toString:find('Shoe') or toString:find('Dress') or toString:find('Skirt') or toString:find('Shorts')) then
                                            local v303 = 0

                                            while true do
                                                if (v303 == 0) then
                                                    v25_2 = v25(id, toString)

                                                    if (v25_2 and v25_2:IsA('Accessory')) then
                                                        v27(v74, v25_2)
                                                    end

                                                    break
                                                end
                                            end
                                        end
                                        if v25_2 then
                                            v25_2:SetAttribute('VantalityItem', true)
                                        end

                                        break
                                    end
                                    if (v254 == 0) then
                                        local v283 = 0

                                        while true do
                                            if (v283 == 1) then
                                                v254 = 1

                                                break
                                            end
                                            if (v283 == 0) then
                                                v25_2 = nil

                                                if (toString == 'Face') then
                                                    local v304 = 0
                                                    local v25_3

                                                    while true do
                                                        if (0 == v304) then
                                                            v25_3 = v25(id, 'Face')

                                                            if v25_3 then
                                                                local v311 = 0
                                                                local head

                                                                while true do
                                                                    if (0 == v311) then
                                                                        head = v74:FindFirstChild('Head')

                                                                        if (head and head:FindFirstChild('Mesh')) then
                                                                            head.Mesh.TextureId = v25_3.Texture
                                                                        end

                                                                        break
                                                                    end
                                                                end
                                                            end

                                                            v304 = 1
                                                        end
                                                        if (1 == v304) then
                                                            return
                                                        end
                                                    end
                                                end

                                                v283 = 1
                                            end
                                        end
                                    end
                                end
                            end)

                            break
                        end
                        if (v200 == 0) then
                            local v235 = 0

                            while true do
                                if (v235 == 1) then
                                    v200 = 1

                                    break
                                end
                                if (v235 == 0) then
                                    id = v199.id
                                    toString = tostring(v199.assetType.name)
                                    v235 = 1
                                end
                            end
                        end
                    end
                end
            end

            humanoid.DisplayName = targetUsername
            state.IsBusy = false

            break
        end
    end
end
local function v31()
    local v83 = 0
    local v84
    local playerGui

    while true do
        if (v83 == 0) then
            if state.AvatarReplacerInit then
                return
            end

            state.AvatarReplacerInit = true
            v83 = 1
        end
        if (1 == v83) then
            v84 = nil

            function v84(v150)
                local v151 = 0
                local toString

                while true do
                    if (v151 == 2) then
                        if (toString:find('Avatar') or toString:find('HeadShot') or toString:find('rbxthumb')) then
                            local toString2 = tostring(localPlayer.UserId)
                            local toString3 = nil

                            pcall(function()
                                toString3 = tostring(players:GetUserIdFromNameAsync(settings.TargetUsername))
                            end)

                            if (toString3 and (toString:find(toString2) or toString:find(toString3))) then
                                local v268 = 0
                                local v269

                                while true do
                                    if (v268 == 0) then
                                        v269 = 'rbxthumb://type=AvatarHeadShot&id=' .. toString3 .. '&w=420&h=420&isCircular=false'

                                        if (v150.Image ~= v269) then
                                            v150.Image = v269
                                        end

                                        break
                                    end
                                end
                            end
                        end

                        break
                    end
                    if (v151 == 0) then
                        if (not v150:IsA('ImageLabel') and not v150:IsA('ImageButton')) then
                            return
                        end
                        if (not settings.Enabled or (settings.TargetUsername == '')) then
                            return
                        end

                        v151 = 1
                    end
                    if (v151 == 1) then
                        toString = tostring(v150.Image)

                        if (toString:find('420&h=420') and toString:find('AvatarHeadShot')) then
                            return
                        end

                        v151 = 2
                    end
                end
            end

            v83 = 2
        end
        if (v83 == 2) then
            playerGui = {
                coreGui,
                localPlayer:FindFirstChild('PlayerGui'),
            }

            for v153, v154 in pairs(playerGui)do
                if v154 then
                    local v203 = 0
                    local v204

                    while true do
                        if (v203 == 0) then
                            v204 = 0

                            while true do
                                if (v204 == 0) then
                                    for v284, v285 in pairs(v154:GetDescendants())do
                                        if (v285:IsA('ImageLabel') or v285:IsA('ImageButton')) then
                                            task.spawn(v84, v285)
                                        end
                                    end

                                    state.Connections['DescAdded_' .. v154.Name] = v154.DescendantAdded:Connect(function(
                                        v286
                                    )
                                        if (v286:IsA('ImageLabel') or v286:IsA('ImageButton')) then
                                            v84(v286)
                                        end
                                    end)

                                    break
                                end
                            end

                            break
                        end
                    end
                end
            end

            break
        end
    end
end
local function v32(v86)
    local v87 = 0
    local v88
    local humanoidRootPart
    local v90

    while true do
        if (v87 == 1) then
            v90 = nil

            while true do
                if (v88 == 0) then
                    if not settings.Enabled then
                        return
                    end

                    humanoidRootPart = v86:WaitForChild('HumanoidRootPart', 10)
                    v88 = 1
                end
                if (v88 == 1) then
                    v90 = 0

                    while v90 < 5 do
                        if (workspace:FindFirstChild('Live') and v86:IsDescendantOf(workspace.Live)) then
                            break
                        end

                        v90 = v90 + 0.2

                        task.wait(0.2)
                    end

                    v88 = 2
                end
                if (2 == v88) then
                    task.wait(0.5)
                    v30(v86)

                    break
                end
            end

            break
        end
        if (v87 == 0) then
            v88 = 0
            humanoidRootPart = nil
            v87 = 1
        end
    end
end

executorAvatarChanger.Enable = function(v91)
    local v92 = 0
    local character

    while true do
        if (v92 == 2) then
            if character then
                v30(character)
            end

            break
        end
        if (v92 == 0) then
            if settings.Enabled then
                return
            end

            settings.Enabled = true
            v92 = 1
        end
        if (v92 == 1) then
            v31()

            character = localPlayer.Character
            v92 = 2
        end
    end
end
executorAvatarChanger.Disable = function(v94)
    local v95 = 0
    local character

    while true do
        if (v95 == 1) then
            character = localPlayer.Character

            if character then
                v29(character)
            end

            break
        end
        if (v95 == 0) then
            if not settings.Enabled then
                return
            end

            settings.Enabled = false
            v95 = 1
        end
    end
end
executorAvatarChanger.UpdateSetting = function(v97, v98, v99)
    local v100 = 0

    while true do
        if (v100 == 1) then
            if ((v98 == 'TargetUsername') and settings.Enabled) then
                local v184 = 0
                local character

                while true do
                    if (v184 == 0) then
                        character = localPlayer.Character

                        if character then
                            v30(character)
                        end

                        break
                    end
                end
            end

            break
        end
        if (v100 == 0) then
            if (settings[v98] == nil) then
                return
            end

            settings[v98] = v99
            v100 = 1
        end
    end
end
executorAvatarChanger.Destroy = function(v101)
    local v102 = 0
    local v103

    while true do
        if (v102 == 0) then
            v103 = 0

            while true do
                if (0 == v103) then
                    v101:Disable()

                    for v220, v221 in pairs(state.Connections)do
                        v221:Disconnect()
                    end

                    v103 = 1
                end
                if (v103 == 2) then
                    v8.ExecutorAvatarChanger = nil

                    break
                end
                if (v103 == 1) then
                    state.Connections = {}
                    state.HttpCache = {}
                    v103 = 2
                end
            end

            break
        end
    end
end
state.Connections.CharAdded = localPlayer.CharacterAdded:Connect(v32)

if (localPlayer.Character and settings.Enabled) then
    v32(localPlayer.Character)
end

return executorAvatarChanger
