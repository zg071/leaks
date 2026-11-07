-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local lighting = game:GetService('Lighting')

if (v8.ExecutorAtmosphere and (typeof(v8.ExecutorAtmosphere.Destroy) == 'function')) then
    pcall(function()
        v8.ExecutorAtmosphere:Destroy()
    end)
    task.wait(0.1)
end

v8.ExecutorAtmosphere = {}

local executorAtmosphere = v8.ExecutorAtmosphere

executorAtmosphere.Settings = {
    Density = 0.3,
    Offset = 0.5,
    Haze = 0,
    Glare = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Decay = Color3.fromRGB(106, 112, 125),
}
executorAtmosphere.State = {
    isEnabled = false,
    OriginalAtmosphere = nil,
    CreatedAtmosphere = nil,
}

local function v14()
    local v22 = 0
    local v23
    local createdAtmosphere
    local settings

    while true do
        if (v22 == 1) then
            settings = nil

            while true do
                if (v23 == 4) then
                    createdAtmosphere.Decay = settings.Decay

                    break
                end
                if (0 == v23) then
                    if not executorAtmosphere.State.CreatedAtmosphere then
                        executorAtmosphere.State.CreatedAtmosphere = Instance.new('Atmosphere')
                        executorAtmosphere.State.CreatedAtmosphere.Name = 'ExecutorAtmosphere_Created'
                        executorAtmosphere.State.CreatedAtmosphere.Parent = lighting
                    end

                    createdAtmosphere = executorAtmosphere.State.CreatedAtmosphere
                    v23 = 1
                end
                if (2 == v23) then
                    createdAtmosphere.Offset = settings.Offset
                    createdAtmosphere.Haze = settings.Haze
                    v23 = 3
                end
                if (1 == v23) then
                    local v50 = 0

                    while true do
                        if (v50 == 1) then
                            v23 = 2

                            break
                        end
                        if (v50 == 0) then
                            settings = executorAtmosphere.Settings
                            createdAtmosphere.Density = settings.Density
                            v50 = 1
                        end
                    end
                end
                if (3 == v23) then
                    createdAtmosphere.Glare = settings.Glare
                    createdAtmosphere.Color = settings.Color
                    v23 = 4
                end
            end

            break
        end
        if (v22 == 0) then
            v23 = 0
            createdAtmosphere = nil
            v22 = 1
        end
    end
end

executorAtmosphere.Enable = function(v26)
    local v27 = 0
    local atmosphere

    while true do
        if (v27 == 1) then
            local v39 = 0

            while true do
                if (v39 == 0) then
                    local v55 = 0

                    while true do
                        if (v55 == 0) then
                            atmosphere = lighting:FindFirstChildOfClass('Atmosphere')

                            if (atmosphere and (atmosphere.Name ~= 'ExecutorAtmosphere_Created')) then
                                v26.State.OriginalAtmosphere = atmosphere
                                atmosphere.Parent = nil
                            end

                            v55 = 1
                        end
                        if (1 == v55) then
                            v39 = 1

                            break
                        end
                    end
                end
                if (v39 == 1) then
                    v27 = 2

                    break
                end
            end
        end
        if (2 == v27) then
            v14()

            break
        end
        if (v27 == 0) then
            if v26.State.isEnabled then
                return
            end

            v26.State.isEnabled = true
            v27 = 1
        end
    end
end
executorAtmosphere.Disable = function(v29)
    local v30 = 0
    local v31

    while true do
        if (v30 == 0) then
            v31 = 0

            while true do
                if (v31 == 1) then
                    if v29.State.CreatedAtmosphere then
                        v29.State.CreatedAtmosphere:Destroy()

                        v29.State.CreatedAtmosphere = nil
                    end
                    if v29.State.OriginalAtmosphere then
                        local v61 = 0
                        local v62

                        while true do
                            if (0 == v61) then
                                v62 = 0

                                while true do
                                    if (v62 == 0) then
                                        v29.State.OriginalAtmosphere.Parent = lighting
                                        v29.State.OriginalAtmosphere = nil

                                        break
                                    end
                                end

                                break
                            end
                        end
                    end

                    break
                end
                if (v31 == 0) then
                    if not v29.State.isEnabled then
                        return
                    end

                    v29.State.isEnabled = false
                    v31 = 1
                end
            end

            break
        end
    end
end
executorAtmosphere.UpdateSetting = function(v32, v33, v34)
    local v35 = 0

    while true do
        if (0 == v35) then
            if (v32.Settings[v33] == nil) then
                return
            end

            v32.Settings[v33] = v34
            v35 = 1
        end
        if (v35 == 1) then
            if v32.State.isEnabled then
                v14()
            end

            break
        end
    end
end
executorAtmosphere.Destroy = function(v36)
    local v37 = 0

    while true do
        if (v37 == 0) then
            v36:Disable()

            v8.ExecutorAtmosphere = nil

            break
        end
    end
end

return executorAtmosphere
