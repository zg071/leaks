-- by swimhub
-- only tsb
local v8 = (getgenv and getgenv()) or _G
local players = game:GetService('Players')
local workspace = game:GetService('Workspace')
local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')
local localPlayer = players.LocalPlayer

if not localPlayer then
    return
end

local name = localPlayer.Name
local userId = localPlayer.UserId

v8.ExecutorSpoofer = v8.ExecutorSpoofer or {}

local executorSpoofer = v8.ExecutorSpoofer

executorSpoofer.Settings = executorSpoofer.Settings or {
    Leaderboards = {
        SpoofTotalKills = false,
        SpoofTotalKillsReal = false,
        SpoofDonations = false,
    },
    Leaderstats = {
        SpoofKills = false,
        TargetKills = 1337,
        SpoofTotalKillsStat = false,
        TargetTotalKills = 9001,
    },
}

local settings = executorSpoofer.Settings

executorSpoofer.State = executorSpoofer.State or {
    isLeaderboardSpoofEnabled = true,
    isLeaderstatsSpoofEnabled = true,
    isWindowFocused = true,
    leaderboardOriginalData = {},
    leaderstatsOriginalValues = {},
    leaderboardObjects = {},
    leaderstatsObjects = {},
    updateConnection = nil,
    focusLostConnection = nil,
    focusGainedConnection = nil,
}

local state = executorSpoofer.State
local executorSpooferV1 = 'ExecutorSpoofer_v1'
local v23 = {
    TotalKills = {
        Base = {
            'Map',
            'Total Kills Leaderboard',
            'a',
            'SurfaceGui',
            'Holder',
            'Line',
            'Main',
            'KillFrame',
        },
        TextLabel = {
            'TextLabel',
        },
        ImageLabel1 = {
            'TextLabel',
            'ImageLabel',
        },
        ImageLabel2 = {
            'TextLabel',
            'ImageLabel',
            'ImageLabel',
        },
    },
    TotalKillsReal = {
        Base = {
            'Map',
            'Total Kills Leaderboard Real',
            'a',
            'SurfaceGui',
            'Holder',
            'Line',
            'Main',
            'KillFrame',
        },
        TextLabel = {
            'TextLabel',
        },
        ImageLabel1 = {
            'TextLabel',
            'ImageLabel',
        },
        ImageLabel2 = {
            'TextLabel',
            'ImageLabel',
            'ImageLabel',
        },
    },
    DonationsLine1 = {
        Base = {
            'Thrown',
            'Donation Leaderboard',
            'a',
            'SurfaceGui',
            'Holder',
            'Line',
            'BigMain',
            'KillFrame',
        },
        TextLabel = {
            'TextLabel',
        },
        ImageLabel1 = {
            'TextLabel',
            'ImageLabel',
        },
        ImageLabel2 = {
            'TextLabel',
            'ImageLabel',
            'ImageLabel',
        },
    },
    DonationsLine2 = {
        Base = {
            'Thrown',
            'Donation Leaderboard',
            'a',
            'SurfaceGui',
            'Holder',
            'Line2',
            'BigMain',
            'KillFrame',
        },
        TextLabel = {
            'TextLabel',
        },
        ImageLabel1 = {
            'TextLabel',
            'ImageLabel',
        },
        ImageLabel2 = {
            'TextLabel',
            'ImageLabel',
            'ImageLabel',
        },
    },
}

local function v24()
    if (executorSpoofer.updateConnection and executorSpoofer.updateConnection.Connected) then
        executorSpoofer.updateConnection:Disconnect()
    end
    if (executorSpoofer.focusLostConnection and executorSpoofer.focusLostConnection.Connected) then
        executorSpoofer.focusLostConnection:Disconnect()
    end
    if (executorSpoofer.focusGainedConnection and executorSpoofer.focusGainedConnection.Connected) then
        executorSpoofer.focusGainedConnection:Disconnect()
    end

    executorSpoofer.updateConnection, executorSpoofer.focusLostConnection, executorSpoofer.focusGainedConnection = nil, nil, nil

    if state.isLeaderboardSpoofEnabled then
        pcall(executorSpoofer.DisableLeaderboardSpoof, executorSpoofer)
    end
    if state.isLeaderstatsSpoofEnabled then
        pcall(executorSpoofer.DisableLeaderstatsSpoof, executorSpoofer)
    end

    task.wait(0.1)

    state.leaderboardOriginalData = {}
    state.leaderstatsOriginalValues = {}
    state.leaderboardObjects = {}
    state.leaderstatsObjects = {}
end
local function v25(v54, v55)
    local v56 = 0
    local v54

    while true do
        if (v56 == 0) then
            v54 = v54

            for v126, v127 in ipairs(v55)do
                local v128 = 0

                while true do
                    if (v128 == 0) then
                        if not v54 then
                            return nil
                        end

                        v54 = v54:FindFirstChild(v127)

                        break
                    end
                end
            end

            v56 = 1
        end
        if (1 == v56) then
            return v54
        end
    end
end
local function v26(v58, v59)
    local v60 = 0
    local concat
    local base
    local v25_2
    local v25_3

    while true do
        if (0 == v60) then
            concat = v58 .. table.concat(v59)

            if (state.leaderboardObjects[concat] and state.leaderboardObjects[concat].Parent) then
                return state.leaderboardObjects[concat]
            end

            v60 = 1
        end
        if (v60 == 1) then
            base = v23[v58] and v23[v58].Base

            if not base then
                return nil
            end

            v60 = 2
        end
        if (2 == v60) then
            v25_2 = v25(workspace, base)

            if not v25_2 then
                return nil
            end

            v60 = 3
        end
        if (4 == v60) then
            return v25_3
        end
        if (v60 == 3) then
            local v119 = 0

            while true do
                if (v119 == 1) then
                    v60 = 4

                    break
                end
                if (v119 == 0) then
                    v25_3 = v25(v25_2, v59)

                    if v25_3 then
                        state.leaderboardObjects[concat] = v25_3
                    end

                    v119 = 1
                end
            end
        end
    end
end
local function v27(v65, v66)
    local v67 = 0

    while true do
        if (v67 == 0) then
            if (not v65 or state.leaderboardOriginalData[v65]) then
                return
            end

            state.leaderboardOriginalData[v65] = {
                Text = (v65:IsA('TextLabel') and v65.Text) or nil,
                Image = (v65:IsA('ImageLabel') and v65.Image) or nil,
            }

            break
        end
    end
end
local function v28(v68, v69)
    local v70 = 0
    local v71
    local leaderboardOriginalData
    local v73

    while true do
        if (v70 == 1) then
            v73 = nil

            while true do
                if (v71 == 0) then
                    if (not v68 or not state.leaderboardOriginalData[v68]) then
                        return
                    end

                    leaderboardOriginalData = state.leaderboardOriginalData[v68]
                    v71 = 1
                end
                if (v71 == 1) then
                    local v145 = 0

                    while true do
                        if (v145 == 0) then
                            v73 = false

                            if (v68:IsA('TextLabel') and leaderboardOriginalData.Text and (v68.Text ~= leaderboardOriginalData.Text)) then
                                local v173 = 0

                                while true do
                                    if (v173 == 0) then
                                        pcall(function()
                                            v68.Text = leaderboardOriginalData.Text
                                        end)

                                        v73 = true

                                        break
                                    end
                                end
                            end

                            v145 = 1
                        end
                        if (v145 == 1) then
                            v71 = 2

                            break
                        end
                    end
                end
                if (v71 == 2) then
                    if (v68:IsA('ImageLabel') and leaderboardOriginalData.Image and (v68.Image ~= leaderboardOriginalData.Image)) then
                        local v149 = 0

                        while true do
                            if (v149 == 0) then
                                pcall(function()
                                    v68.Image = leaderboardOriginalData.Image
                                end)

                                v73 = true

                                break
                            end
                        end
                    end

                    state.leaderboardOriginalData[v68] = nil

                    break
                end
            end

            break
        end
        if (v70 == 0) then
            v71 = 0
            leaderboardOriginalData = nil
            v70 = 1
        end
    end
end
local function v29()
    local v74 = 0
    local v75

    while true do
        if (1 == v74) then
            v75('TotalKills', v23.TotalKills.ImageLabel1, settings.Leaderboards.SpoofTotalKills)
            v75('TotalKills', v23.TotalKills.ImageLabel2, settings.Leaderboards.SpoofTotalKills)
            v75('TotalKillsReal', v23.TotalKillsReal.TextLabel, settings.Leaderboards.SpoofTotalKillsReal)
            v75('TotalKillsReal', v23.TotalKillsReal.ImageLabel1, settings.Leaderboards.SpoofTotalKillsReal)

            v74 = 2
        end
        if (v74 == 2) then
            v75('TotalKillsReal', v23.TotalKillsReal.ImageLabel2, settings.Leaderboards.SpoofTotalKillsReal)
            v75('DonationsLine1', v23.DonationsLine1.TextLabel, settings.Leaderboards.SpoofDonations)
            v75('DonationsLine1', v23.DonationsLine1.ImageLabel1, settings.Leaderboards.SpoofDonations)
            v75('DonationsLine1', v23.DonationsLine1.ImageLabel2, settings.Leaderboards.SpoofDonations)

            v74 = 3
        end
        if (v74 == 0) then
            if (not state.isLeaderboardSpoofEnabled or not state.isWindowFocused) then
                return
            end

            v75 = nil

            function v75(v129, v130, v131)
                local v132 = 0
                local v26_2

                while true do
                    if (v132 == 0) then
                        v26_2 = v26(v129, v130)

                        if not v26_2 then
                            return
                        end

                        v132 = 1
                    end
                    if (v132 == 1) then
                        v27(v26_2, v129 .. table.concat(v130))

                        if v131 then
                            if v26_2:IsA('TextLabel') then
                                local v174 = 0
                                local v175
                                local text
                                local gsub

                                while true do
                                    if (v174 == 1) then
                                        gsub = nil

                                        while true do
                                            if (v175 == 0) then
                                                text = v26_2.Text
                                                gsub = text:gsub('%s%S+$', ' ' .. name)
                                                v175 = 1
                                            end
                                            if (v175 == 1) then
                                                if (gsub ~= text) then
                                                    pcall(function()
                                                        v26_2.Text = gsub
                                                    end)
                                                end

                                                break
                                            end
                                        end

                                        break
                                    end
                                    if (0 == v174) then
                                        v175 = 0
                                        text = nil
                                        v174 = 1
                                    end
                                end
                            elseif v26_2:IsA('ImageLabel') then
                                local v186 = 0
                                local image
                                local v188
                                local tostring

                                while true do
                                    if (v186 == 1) then
                                        if (tostring > 0) then
                                            pcall(function()
                                                v26_2.Image = v188
                                            end)
                                        end

                                        break
                                    end
                                    if (0 == v186) then
                                        image = v26_2.Image
                                        v188, tostring = image:gsub('(id=)%d+(&?)', '%1' .. tostring(userId) .. '%2')
                                        v186 = 1
                                    end
                                end
                            end
                        else
                            v28(v26_2, v129 .. table.concat(v130))
                        end

                        break
                    end
                end
            end

            v75('TotalKills', v23.TotalKills.TextLabel, settings.Leaderboards.SpoofTotalKills)

            v74 = 1
        end
        if (3 == v74) then
            v75('DonationsLine2', v23.DonationsLine2.TextLabel, settings.Leaderboards.SpoofDonations)
            v75('DonationsLine2', v23.DonationsLine2.ImageLabel1, settings.Leaderboards.SpoofDonations)
            v75('DonationsLine2', v23.DonationsLine2.ImageLabel2, settings.Leaderboards.SpoofDonations)

            break
        end
    end
end
local function v30()
    if (state.leaderstatsObjects.Kills and state.leaderstatsObjects['Total Kills']) then
        return true
    end

    local leaderstats = localPlayer:FindFirstChild('leaderstats')

    if not leaderstats then
        return false
    end

    local kills = leaderstats:FindFirstChild('Kills')
    local totalKills = leaderstats:FindFirstChild('Total Kills')

    if (kills and kills:IsA('IntValue')) then
        state.leaderstatsObjects.Kills = kills
    end
    if (totalKills and totalKills:IsA('IntValue')) then
        state.leaderstatsObjects['Total Kills'] = totalKills
    end

    return state.leaderstatsObjects.Kills and state.leaderstatsObjects['Total Kills']
end
local function v31()
    local v79 = 0
    local v80

    while true do
        if (0 == v79) then
            v80 = 0

            while true do
                if (0 == v80) then
                    if not v30() then
                        return
                    end
                    if (state.leaderstatsObjects.Kills and (state.leaderstatsOriginalValues.Kills == nil)) then
                        state.leaderstatsOriginalValues.Kills = state.leaderstatsObjects.Kills.Value
                    end

                    v80 = 1
                end
                if (v80 == 1) then
                    if (state.leaderstatsObjects['Total Kills'] and (state.leaderstatsOriginalValues['Total Kills'] == nil)) then
                        state.leaderstatsOriginalValues['Total Kills'] = state.leaderstatsObjects['Total Kills'].Value
                    end

                    break
                end
            end

            break
        end
    end
end
local function v32()
    if not v30() then
        return
    end
    if (state.leaderstatsObjects.Kills and (state.leaderstatsOriginalValues.Kills ~= nil)) then
        local v111 = 0
        local v112

        while true do
            if (0 == v111) then
                v112 = 0

                while true do
                    if (v112 == 0) then
                        pcall(function()
                            state.leaderstatsObjects.Kills.Value = state.leaderstatsOriginalValues.Kills
                        end)

                        state.leaderstatsOriginalValues.Kills = nil

                        break
                    end
                end

                break
            end
        end
    end
    if (state.leaderstatsObjects['Total Kills'] and (state.leaderstatsOriginalValues['Total Kills'] ~= nil)) then
        local v113 = 0
        local v114

        while true do
            if (0 == v113) then
                v114 = 0

                while true do
                    if (v114 == 0) then
                        pcall(function()
                            state.leaderstatsObjects['Total Kills'].Value = state.leaderstatsOriginalValues['Total Kills']
                        end)

                        state.leaderstatsOriginalValues['Total Kills'] = nil

                        break
                    end
                end

                break
            end
        end
    end
end
local function v33()
    local v81 = 0
    local v82

    while true do
        if (v81 == 0) then
            v82 = 0

            while true do
                if (v82 == 2) then
                    if state.leaderstatsObjects['Total Kills'] then
                        if settings.Leaderstats.SpoofTotalKillsStat then
                            pcall(function()
                                state.leaderstatsObjects['Total Kills'].Value = settings.Leaderstats.TargetTotalKills
                            end)
                        elseif (state.leaderstatsOriginalValues['Total Kills'] ~= nil) then
                            pcall(function()
                                state.leaderstatsObjects['Total Kills'].Value = state.leaderstatsOriginalValues['Total Kills']
                            end)
                        end
                    end

                    break
                end
                if (v82 == 1) then
                    v31()

                    if state.leaderstatsObjects.Kills then
                        if settings.Leaderstats.SpoofKills then
                            pcall(function()
                                state.leaderstatsObjects.Kills.Value = settings.Leaderstats.TargetKills
                            end)
                        elseif (state.leaderstatsOriginalValues.Kills ~= nil) then
                            pcall(function()
                                state.leaderstatsObjects.Kills.Value = state.leaderstatsOriginalValues.Kills
                            end)
                        end
                    end

                    v82 = 2
                end
                if (v82 == 0) then
                    if (not state.isLeaderstatsSpoofEnabled or not state.isWindowFocused) then
                        return
                    end
                    if not v30() then
                        return
                    end

                    v82 = 1
                end
            end

            break
        end
    end
end
local function v34(v83)
    local v84 = 0
    local v85

    while true do
        if (0 == v84) then
            v85 = 0

            while true do
                if (v85 == 1) then
                    pcall(v29)
                    pcall(v33)

                    break
                end
                if (0 == v85) then
                    if (not executorSpoofer or not state or not settings) then
                        return
                    end
                    if not state.isWindowFocused then
                        return
                    end

                    v85 = 1
                end
            end

            break
        end
    end
end
local function v35()
    if (executorSpoofer and state) then
        state.isWindowFocused = false
    end
end
local function v36()
    if (executorSpoofer and state) then
        state.isWindowFocused = true
    end
end

executorSpoofer.EnableLeaderboardSpoof = function(v86)
    local v87 = 0

    while true do
        if (v87 == 0) then
            if not state then
                return
            end
            if not state.isLeaderboardSpoofEnabled then
                local v140 = 0
                local v141

                while true do
                    if (v140 == 0) then
                        v141 = 0

                        while true do
                            if (v141 == 0) then
                                state.isLeaderboardSpoofEnabled = true

                                v29()

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
end
executorSpoofer.DisableLeaderboardSpoof = function(v88)
    local v89 = 0

    while true do
        if (0 == v89) then
            if not state then
                return
            end
            if state.isLeaderboardSpoofEnabled then
                local v142 = 0
                local v143

                while true do
                    if (v142 == 1) then
                        v143('TotalKills', v23.TotalKills.TextLabel)
                        v143('TotalKills', v23.TotalKills.ImageLabel1)
                        v143('TotalKills', v23.TotalKills.ImageLabel2)

                        v142 = 2
                    end
                    if (v142 == 3) then
                        local v156 = 0

                        while true do
                            if (v156 == 0) then
                                v143('DonationsLine1', v23.DonationsLine1.TextLabel)
                                v143('DonationsLine1', v23.DonationsLine1.ImageLabel1)

                                v156 = 1
                            end
                            if (v156 == 1) then
                                v143('DonationsLine1', v23.DonationsLine1.ImageLabel2)

                                v142 = 4

                                break
                            end
                        end
                    end
                    if (v142 == 0) then
                        state.isLeaderboardSpoofEnabled = false
                        v143 = nil

                        function v143(v166, v167)
                            local v168 = 0
                            local v26_2

                            while true do
                                if (v168 == 0) then
                                    v26_2 = v26(v166, v167)

                                    v28(v26_2, v166 .. table.concat(v167))

                                    break
                                end
                            end
                        end

                        v142 = 1
                    end
                    if (v142 == 4) then
                        v143('DonationsLine2', v23.DonationsLine2.TextLabel)
                        v143('DonationsLine2', v23.DonationsLine2.ImageLabel1)
                        v143('DonationsLine2', v23.DonationsLine2.ImageLabel2)

                        break
                    end
                    if (v142 == 2) then
                        local v158 = 0
                        local v159

                        while true do
                            if (v158 == 0) then
                                v159 = 0

                                while true do
                                    if (1 == v159) then
                                        v143('TotalKillsReal', v23.TotalKillsReal.ImageLabel2)

                                        v142 = 3

                                        break
                                    end
                                    if (0 == v159) then
                                        v143('TotalKillsReal', v23.TotalKillsReal.TextLabel)
                                        v143('TotalKillsReal', v23.TotalKillsReal.ImageLabel1)

                                        v159 = 1
                                    end
                                end

                                break
                            end
                        end
                    end
                end
            end

            break
        end
    end
end
executorSpoofer.EnableLeaderstatsSpoof = function(v90)
    local v91 = 0
    local v92

    while true do
        if (v91 == 0) then
            v92 = 0

            while true do
                if (v92 == 0) then
                    if not state then
                        return
                    end
                    if not state.isLeaderstatsSpoofEnabled then
                        local v160 = 0

                        while true do
                            if (v160 == 0) then
                                state.isLeaderstatsSpoofEnabled = true

                                v31()

                                v160 = 1
                            end
                            if (v160 == 1) then
                                v33()

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
executorSpoofer.DisableLeaderstatsSpoof = function(v93)
    if not state then
        return
    end
    if state.isLeaderstatsSpoofEnabled then
        local v117 = 0
        local v118

        while true do
            if (v117 == 0) then
                v118 = 0

                while true do
                    if (v118 == 0) then
                        state.isLeaderstatsSpoofEnabled = false

                        v32()

                        break
                    end
                end

                break
            end
        end
    end
end
executorSpoofer.UpdateSetting = function(v94, v95, v96)
    local v97 = 0
    local v98
    local settings2
    local v100
    local typeName
    local typeName2

    while true do
        if (v97 == 4) then
            if (state.isLeaderboardSpoofEnabled and (v98[1] == 'Leaderboards')) then
                v29()
            elseif (state.isLeaderstatsSpoofEnabled and (v98[1] == 'Leaderstats')) then
                v33()
            end

            break
        end
        if (v97 == 0) then
            if not settings then
                return
            end

            v98 = {}

            for v134 in v95:gmatch('[^%.]+')do
                table.insert(v98, v134)
            end

            v97 = 1
        end
        if (1 == v97) then
            settings2 = settings
            v100 = v98[#v98]

            for v135 = 1, #v98 - 1 do
                local v136 = v98[v135]

                if (not settings2[v136] or (type(settings2[v136]) ~= 'table')) then
                    return
                end

                settings2 = settings2[v136]
            end

            v97 = 2
        end
        if (v97 == 2) then
            if (settings2[v100] == nil) then
                return
            end

            typeName = type(settings2[v100])
            typeName2 = type(v96)
            v97 = 3
        end
        if (v97 == 3) then
            local v122 = 0

            while true do
                if (v122 == 0) then
                    if ((typeName ~= typeName2) and not ((typeName == 'number') and (typeName2 == 'number')) and (typeName ~= 'boolean')) then
                        return
                    end
                    if ((typeName == 'boolean') and (typeName2 ~= 'boolean')) then
                        return
                    end

                    v122 = 1
                end
                if (v122 == 1) then
                    settings2[v100] = v96
                    v97 = 4

                    break
                end
            end
        end
    end
end
executorSpoofer.Destroy = function(v103)
    local v104 = 0

    while true do
        if (v104 == 0) then
            v24()

            v8.ExecutorSpoofer = nil

            break
        end
    end
end

local function v43()
    local v105 = 0
    local v106
    local pcallOk

    while true do
        if (v105 == 0) then
            if state.isInitialized then
                return true
            end

            pcall(v30)

            v105 = 1
        end
        if (v105 == 1) then
            if (executorSpoofer.updateConnection and executorSpoofer.updateConnection.Connected) then
                executorSpoofer.updateConnection:Disconnect()
            end
            if (executorSpoofer.focusLostConnection and executorSpoofer.focusLostConnection.Connected) then
                executorSpoofer.focusLostConnection:Disconnect()
            end

            v105 = 2
        end
        if (3 == v105) then
            if not v106 then
                v24()

                return false
            end

            state.isInitialized = true
            v105 = 4
        end
        if (v105 == 4) then
            local v125 = 0

            while true do
                if (v125 == 0) then
                    if state.isLeaderstatsSpoofEnabled then
                        v31()
                    end

                    return true
                end
            end
        end
        if (v105 == 2) then
            if (executorSpoofer.focusGainedConnection and executorSpoofer.focusGainedConnection.Connected) then
                executorSpoofer.focusGainedConnection:Disconnect()
            end

            v106, pcallOk = pcall(function()
                local v138 = 0
                local v139

                while true do
                    if (0 == v138) then
                        v139 = 0

                        while true do
                            if (v139 == 0) then
                                executorSpoofer.focusLostConnection = userInputService.WindowFocusReleased:Connect(v35)
                                executorSpoofer.focusGainedConnection = userInputService.WindowFocused:Connect(v36)
                                v139 = 1
                            end
                            if (1 == v139) then
                                executorSpoofer.updateConnection = runService.Heartbeat:Connect(v34)

                                break
                            end
                        end

                        break
                    end
                end
            end)
            v105 = 3
        end
    end
end

v43()

return true
