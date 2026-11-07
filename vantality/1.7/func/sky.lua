-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local lighting = game:GetService('Lighting')
local terrain = workspace:WaitForChild('Terrain')

if v8.SkyManager then
    v8.SkyManager:Disable()
end

local v11 = {}
local fromRGB = {
    OldSky = nil,
    OldClouds = nil,
    OldSunRays = nil,
    OldBrightness = lighting.Brightness,
    ActiveSky = nil,
    ActiveClouds = nil,
    ActiveSunRays = nil,
    Settings = {
        Brightness = 2,
        SunSize = 11,
        SunInt = 0.25,
        SunSpread = 0.1,
        MoonSize = 11,
        Stars = 3000,
        CloudCover = 0.5,
        CloudDensity = 0.7,
        CloudColor = Color3.fromRGB(255, 255, 255),
    },
}

local function v13()
    local v27 = 0
    local sky
    local sky2

    while true do
        if (v27 == 5) then
            local v72 = 0
            local v73

            while true do
                if (v72 == 0) then
                    v73 = 0

                    while true do
                        if (v73 == 0) then
                            local v141 = 0

                            while true do
                                if (v141 == 0) then
                                    fromRGB.ActiveSky = sky2

                                    return sky2
                                end
                            end
                        end
                    end

                    break
                end
            end
        end
        if (2 == v27) then
            sky2.SkyboxDn = (sky and sky.SkyboxDn) or ''
            sky2.SkyboxFt = (sky and sky.SkyboxFt) or ''
            sky2.SkyboxLf = (sky and sky.SkyboxLf) or ''
            v27 = 3
        end
        if (v27 == 1) then
            local v77 = 0

            while true do
                if (0 == v77) then
                    sky2 = Instance.new('Sky')
                    sky2.Name = 'VantalitySky'
                    v77 = 1
                end
                if (1 == v77) then
                    sky2.SkyboxBk = (sky and sky.SkyboxBk) or ''
                    v27 = 2

                    break
                end
            end
        end
        if (v27 == 4) then
            sky2.MoonAngularSize = fromRGB.Settings.MoonSize
            sky2.StarCount = fromRGB.Settings.Stars
            sky2.Parent = lighting
            v27 = 5
        end
        if (v27 == 0) then
            if fromRGB.ActiveSky then
                return fromRGB.ActiveSky
            end

            sky = lighting:FindFirstChildOfClass('Sky')

            if (sky and (sky.Name ~= 'VantalitySky')) then
                local v89 = 0

                while true do
                    if (v89 == 0) then
                        fromRGB.OldSky = sky
                        sky.Parent = nil

                        break
                    end
                end
            end

            v27 = 1
        end
        if (v27 == 3) then
            sky2.SkyboxRt = (sky and sky.SkyboxRt) or ''
            sky2.SkyboxUp = (sky and sky.SkyboxUp) or ''
            sky2.SunAngularSize = fromRGB.Settings.SunSize
            v27 = 4
        end
    end
end
local function v14()
    local v30 = 0
    local clouds
    local clouds2

    while true do
        local v70 = 0

        while true do
            if (v70 == 1) then
                if (1 == v30) then
                    clouds2.Name = 'VantalityClouds'
                    clouds2.Cover = fromRGB.Settings.CloudCover
                    clouds2.Density = fromRGB.Settings.CloudDensity
                    clouds2.Color = fromRGB.Settings.CloudColor
                    v30 = 2
                end

                break
            end
            if (v70 == 0) then
                if (v30 == 0) then
                    if fromRGB.ActiveClouds then
                        return fromRGB.ActiveClouds
                    end

                    clouds = terrain:FindFirstChildOfClass('Clouds') or lighting:FindFirstChildOfClass('Clouds')

                    if (clouds and (clouds.Name ~= 'VantalityClouds')) then
                        local v124 = 0
                        local v125

                        while true do
                            if (v124 == 0) then
                                v125 = 0

                                while true do
                                    if (0 == v125) then
                                        fromRGB.OldClouds = clouds
                                        clouds.Parent = nil

                                        break
                                    end
                                end

                                break
                            end
                        end
                    end

                    clouds2 = Instance.new('Clouds')
                    v30 = 1
                end
                if (v30 == 2) then
                    local v119 = 0

                    while true do
                        if (v119 == 0) then
                            clouds2.Parent = terrain
                            fromRGB.ActiveClouds = clouds2
                            v119 = 1
                        end
                        if (v119 == 1) then
                            return clouds2
                        end
                    end
                end

                v70 = 1
            end
        end
    end
end
local function v15()
    if fromRGB.ActiveSunRays then
        return fromRGB.ActiveSunRays
    end

    local sunRaysEffect = lighting:FindFirstChildOfClass('SunRaysEffect')

    if (sunRaysEffect and (sunRaysEffect.Name ~= 'VantalitySunRays')) then
        local v71 = 0

        while true do
            if (v71 == 0) then
                fromRGB.OldSunRays = sunRaysEffect
                sunRaysEffect.Parent = nil

                break
            end
        end
    end

    local sunRaysEffect2 = Instance.new('SunRaysEffect')

    sunRaysEffect2.Name = 'VantalitySunRays'
    sunRaysEffect2.Intensity = fromRGB.Settings.SunInt
    sunRaysEffect2.Spread = fromRGB.Settings.SunSpread
    sunRaysEffect2.Parent = lighting
    fromRGB.ActiveSunRays = sunRaysEffect2

    return sunRaysEffect2
end

v11.Enable = function(v42)
    local v43 = 0
    local v44

    while true do
        if (v43 == 0) then
            v44 = 0

            while true do
                if (v44 == 1) then
                    v15()
                    pcall(function()
                        lighting.Brightness = fromRGB.Settings.Brightness
                    end)

                    break
                end
                if (v44 == 0) then
                    v13()
                    v14()

                    v44 = 1
                end
            end

            break
        end
    end
end
v11.Disable = function(v45)
    local v46 = 0

    while true do
        if (3 == v46) then
            pcall(function()
                lighting.Brightness = fromRGB.OldBrightness
            end)

            break
        end
        if (v46 == 1) then
            if fromRGB.ActiveSunRays then
                local v92 = 0
                local v93

                while true do
                    if (0 == v92) then
                        v93 = 0

                        while true do
                            if (v93 == 0) then
                                fromRGB.ActiveSunRays:Destroy()

                                fromRGB.ActiveSunRays = nil

                                break
                            end
                        end

                        break
                    end
                end
            end
            if fromRGB.OldSky then
                local v94 = 0

                while true do
                    if (v94 == 0) then
                        fromRGB.OldSky.Parent = lighting
                        fromRGB.OldSky = nil

                        break
                    end
                end
            end

            v46 = 2
        end
        if (v46 == 2) then
            if fromRGB.OldClouds then
                local v95 = 0

                while true do
                    if (v95 == 0) then
                        fromRGB.OldClouds.Parent = terrain
                        fromRGB.OldClouds = nil

                        break
                    end
                end
            end
            if fromRGB.OldSunRays then
                local v96 = 0

                while true do
                    if (v96 == 0) then
                        fromRGB.OldSunRays.Parent = lighting
                        fromRGB.OldSunRays = nil

                        break
                    end
                end
            end

            v46 = 3
        end
        if (v46 == 0) then
            if fromRGB.ActiveSky then
                fromRGB.ActiveSky:Destroy()

                fromRGB.ActiveSky = nil
            end
            if fromRGB.ActiveClouds then
                local v98 = 0
                local v99

                while true do
                    if (v98 == 0) then
                        v99 = 0

                        while true do
                            if (v99 == 0) then
                                fromRGB.ActiveClouds:Destroy()

                                fromRGB.ActiveClouds = nil

                                break
                            end
                        end

                        break
                    end
                end
            end

            v46 = 1
        end
    end
end
v11.SetBrightness = function(v47, v48)
    local v49 = 0
    local v50

    while true do
        if (v49 == 0) then
            v50 = 0

            while true do
                if (v50 == 0) then
                    if v48 then
                        fromRGB.Settings.Brightness = v48
                    end
                    if fromRGB.ActiveSky then
                        pcall(function()
                            lighting.Brightness = fromRGB.Settings.Brightness
                        end)
                    end

                    break
                end
            end

            break
        end
    end
end
v11.SetSun = function(v51, v52, v53, v54)
    local v55 = 0

    while true do
        if (v55 == 1) then
            if v54 then
                fromRGB.Settings.SunSpread = v54
            end
            if fromRGB.ActiveSky then
                fromRGB.ActiveSky.SunAngularSize = fromRGB.Settings.SunSize
            end

            v55 = 2
        end
        if (v55 == 2) then
            if fromRGB.ActiveSunRays then
                local v103 = 0
                local v104

                while true do
                    if (v103 == 0) then
                        v104 = 0

                        while true do
                            if (v104 == 0) then
                                fromRGB.ActiveSunRays.Intensity = fromRGB.Settings.SunInt
                                fromRGB.ActiveSunRays.Spread = fromRGB.Settings.SunSpread

                                break
                            end
                        end

                        break
                    end
                end
            end

            break
        end
        if (v55 == 0) then
            if v52 then
                fromRGB.Settings.SunSize = v52
            end
            if v53 then
                fromRGB.Settings.SunInt = v53
            end

            v55 = 1
        end
    end
end
v11.SetMoon = function(v56, v57)
    local v58 = 0

    while true do
        if (v58 == 0) then
            if v57 then
                fromRGB.Settings.MoonSize = v57
            end
            if fromRGB.ActiveSky then
                fromRGB.ActiveSky.MoonAngularSize = fromRGB.Settings.MoonSize
            end

            break
        end
    end
end
v11.SetStars = function(v59, v60)
    local v61 = 0
    local v62

    while true do
        if (v61 == 0) then
            v62 = 0

            while true do
                if (v62 == 0) then
                    if v60 then
                        fromRGB.Settings.Stars = v60
                    end
                    if fromRGB.ActiveSky then
                        fromRGB.ActiveSky.StarCount = fromRGB.Settings.Stars
                    end

                    break
                end
            end

            break
        end
    end
end
v11.SetClouds = function(v63, v64, v65, v66)
    local v67 = 0
    local v68

    while true do
        if (v67 == 0) then
            v68 = 0

            while true do
                if (v68 == 1) then
                    if v66 then
                        fromRGB.Settings.CloudColor = v66
                    end
                    if fromRGB.ActiveClouds then
                        local v137 = 0
                        local v138

                        while true do
                            if (0 == v137) then
                                v138 = 0

                                while true do
                                    if (1 == v138) then
                                        fromRGB.ActiveClouds.Color = fromRGB.Settings.CloudColor

                                        break
                                    end
                                    if (v138 == 0) then
                                        fromRGB.ActiveClouds.Cover = fromRGB.Settings.CloudCover
                                        fromRGB.ActiveClouds.Density = fromRGB.Settings.CloudDensity
                                        v138 = 1
                                    end
                                end

                                break
                            end
                        end
                    end

                    break
                end
                if (v68 == 0) then
                    if v64 then
                        fromRGB.Settings.CloudCover = v64
                    end
                    if v65 then
                        fromRGB.Settings.CloudDensity = v65
                    end

                    v68 = 1
                end
            end

            break
        end
    end
end
v8.SkyManager = v11
