-- by swimhub
local v8 = (getgenv and getgenv()) or _G

if v8.VantalityCleaner then
    v8.VantalityCleaner:Stop()
end

local workspace = game:GetService('Workspace')
local thrown = workspace:WaitForChild('Thrown', 10)
local map = workspace:WaitForChild('Map', 10)

v8.VantalityCleaner = {
    Settings = {
        CleanGarbage = false,
        CleanTrees = false,
        CleanWalls = false,
        CleanGrass = false,
        CleanBenchs = false,
        CleanRailings = false,
        CleanStadium = false,
        CleanSlab = false,
    },
    Connections = {},
    Cache = {
        Trees = {},
        Walls = {},
        Grass = {},
        Benchs = {},
        Railings = {},
        Stadium = {},
        Slab = {},
    },
}

local vantalityCleaner = v8.VantalityCleaner
local v14 = {
    OmniDebris = true,
    Debris = true,
    Emit = true,
    SmokeUp = true,
    SmokeUpTwo = true,
    SmokeFront = true,
    Sneeze = true,
    BodySmokez = true,
    BodySmoke = true,
    DebrisGg = true,
    Part = true,
    SmallDebris = true,
    ['B-Ball'] = true,
    Stadium = true,
    Trashcan = true,
    Bench = true,
    aa = true,
    starterdeb = true,
}

for v27 = 1, 16 do
    v14[tostring(v27)] = true
end

local v15 = {
    breakedmodelUnion = true,
    breakedmodelPart = true,
    breakedmodelMeshPart = true,
    breakedmodelTrashcan = true,
}

local function v16(v29, v30)
    if (v30 and (v30.Parent ~= nil)) then
        local v52 = 0

        while true do
            if (v52 == 0) then
                table.insert(vantalityCleaner.Cache[v29], {
                    Instance = v30,
                    Parent = v30.Parent,
                })

                v30.Parent = nil

                break
            end
        end
    end
end
local function v17(v31)
    for v48, v49 in ipairs(vantalityCleaner.Cache[v31])do
        if v49.Instance then
            pcall(function()
                v49.Instance.Parent = v49.Parent
            end)
        end
    end

    vantalityCleaner.Cache[v31] = {}
end
local function v18(v33)
    local v34 = 0
    local name

    while true do
        if (v34 == 1) then
            if (vantalityCleaner.Settings.CleanGarbage and v14[name]) then
                local v73 = 0

                while true do
                    if (v73 == 0) then
                        task.delay(0.02, function()
                            if v33 then
                                v33:Destroy()
                            end
                        end)

                        return
                    end
                end
            end
            if (name == 'Tree') then
                task.delay(0.02, function()
                    if not v33 then
                        return
                    end
                    if vantalityCleaner.Settings.CleanTrees then
                        local v75 = 0

                        while true do
                            if (v75 == 0) then
                                v33:Destroy()

                                return
                            end
                        end
                    end
                    if vantalityCleaner.Settings.CleanGarbage then
                        local v76 = 0
                        local tree

                        while true do
                            if (0 == v76) then
                                for v82, v83 in ipairs(v33:GetChildren())do
                                    if v15[v83.Name] then
                                        v83:Destroy()
                                    end
                                end

                                tree = v33:FindFirstChild('Tree')
                                v76 = 1
                            end
                            if (1 == v76) then
                                if tree then
                                    for v84, v85 in ipairs(tree:GetChildren())do
                                        if v15[v85.Name] then
                                            v85:Destroy()
                                        end
                                    end
                                end

                                break
                            end
                        end
                    end
                end)
            end

            break
        end
        if (v34 == 0) then
            if not v33 then
                return
            end

            name = v33.Name
            v34 = 1
        end
    end
end
local function v19()
    if not thrown then
        return
    end

    for v50, v51 in ipairs(thrown:GetChildren())do
        v18(v51)
    end
end

vantalityCleaner.UpdateSetting = function(v36, v37, v38)
    local v39 = 0

    while true do
        if (v39 == 0) then
            v36.Settings[v37] = v38

            v36:Refresh()

            break
        end
    end
end
vantalityCleaner.Refresh = function(v40)
    if not map then
        return
    end
    if v40.Settings.CleanTrees then
        local trees = map:FindFirstChild('Trees')

        if trees then
            v16('Trees', trees)
        end

        v19()
    else
        v17('Trees')
    end
    if v40.Settings.CleanWalls then
        for v58, v59 in ipairs(map:GetChildren())do
            local name = v59.Name

            if ((name == 'Walls') or (name == 'GrassTop') or (name == 'Part') or (name == 'Tunnel')) then
                v16('Walls', v59)
            end
        end
    else
        v17('Walls')
    end
    if v40.Settings.CleanGrass then
        for v61, v62 in ipairs(map:GetChildren())do
            local v63 = 0
            local name

            while true do
                if (v63 == 0) then
                    name = v62.Name

                    if ((name == 'GrassBottom') or (name == 'Grass')) then
                        v16('Grass', v62)
                    end

                    break
                end
            end
        end
    else
        v17('Grass')
    end
    if v40.Settings.CleanBenchs then
        for v65, v66 in ipairs(map:GetChildren())do
            if (v66.Name == 'Benchs') then
                v16('Benchs', v66)
            end
        end
    else
        v17('Benchs')
    end

    local v41 = map:FindFirstChild('Floor/Roads')

    if v41 then
        local v54 = 0
        local stadium

        while true do
            if (v54 == 0) then
                if v40.Settings.CleanRailings then
                    for v78, v79 in ipairs(v41:GetChildren())do
                        if (v79.Name == 'Railing') then
                            v16('Railings', v79)
                        end
                    end
                else
                    v17('Railings')
                end

                stadium = v41:FindFirstChild('Stadium')
                v54 = 1
            end
            if (v54 == 1) then
                if stadium then
                    if (v40.Settings.CleanStadium and not v40.Settings.CleanSlab) then
                        local v80 = 0

                        while true do
                            if (v80 == 0) then
                                v17('Slab')
                                v16('Stadium', stadium)

                                break
                            end
                        end
                    else
                        local v81 = 0

                        while true do
                            if (0 == v81) then
                                v17('Stadium')

                                if v40.Settings.CleanSlab then
                                    for v86, v87 in ipairs(stadium:GetChildren())do
                                        if (v87.Name == 'Stadium') then
                                            v16('Slab', v87)
                                        end
                                    end
                                else
                                    v17('Slab')
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
    if v40.Settings.CleanGarbage then
        v19()
    end
end
vantalityCleaner.Init = function(v42)
    local v43 = 0
    local v44

    while true do
        if (v43 == 0) then
            v44 = 0

            while true do
                if (v44 == 0) then
                    if thrown then
                        table.insert(v42.Connections, thrown.ChildAdded:Connect(v18))
                    end

                    v42:Refresh()

                    break
                end
            end

            break
        end
    end
end
vantalityCleaner.Stop = function(v45)
    local v46 = 0

    while true do
        if (v46 == 4) then
            v17('Slab')

            break
        end
        if (v46 == 1) then
            v17('Trees')
            v17('Walls')

            v46 = 2
        end
        if (v46 == 0) then
            for v70, v71 in pairs(v45.Connections)do
                v71:Disconnect()
            end

            v45.Connections = {}
            v46 = 1
        end
        if (v46 == 3) then
            v17('Railings')
            v17('Stadium')

            v46 = 4
        end
        if (v46 == 2) then
            v17('Grass')
            v17('Benchs')

            v46 = 3
        end
    end
end

vantalityCleaner:Init()

return vantalityCleaner
