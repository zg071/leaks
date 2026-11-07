-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local lighting = game:GetService('Lighting')
local workspace = game:GetService('Workspace')

if (v8.RenderController and (typeof(v8.RenderController.Destroy) == 'function')) then
    pcall(function()
        v8.RenderController:Destroy()
    end)
    task.wait(0.1)
end

v8.RenderController = {}

local renderController = v8.RenderController

renderController.Settings = {
    Bloom = {
        Intensity = 1,
        Size = 24,
        Threshold = 2,
    },
    Colors = {
        Shadows = Color3.fromRGB(0, 0, 0),
        Environment = Color3.fromRGB(120, 120, 120),
        Tint = Color3.fromRGB(255, 255, 255),
    },
    Render = {
        Technology = 'ShadowMap',
        GlobalShadows = true,
        ForceLightShadows = false,
        PBR_Reflections = 0,
    },
}
renderController.State = {
    isEnabled = false,
    Defaults = {},
    BloomEffect = nil,
    Connections = {},
}

local state = renderController.State
local settings = renderController.Settings
local v17 = {
    Voxel = 1,
    ShadowMap = 2,
    Future = 3,
}

local function v18()
    local v32 = 0

    while true do
        if (v32 == 1) then
            pcall(function()
                lighting.EnvironmentDiffuseScale = settings.Render.PBR_Reflections
            end)
            pcall(function()
                lighting.EnvironmentSpecularScale = settings.Render.PBR_Reflections
            end)

            v32 = 2
        end
        if (v32 == 0) then
            if not state.isEnabled then
                return
            end

            pcall(function()
                lighting.GlobalShadows = settings.Render.GlobalShadows
            end)

            v32 = 1
        end
        if (v32 == 2) then
            if sethiddenproperty then
                local v93 = 0
                local v94

                while true do
                    if (0 == v93) then
                        v94 = v17[settings.Render.Technology]

                        if v94 then
                            pcall(function()
                                sethiddenproperty(lighting, 'Technology', v94)
                            end)
                        end

                        break
                    end
                end
            end

            break
        end
    end
end
local function v19()
    local v33 = 0

    while true do
        if (v33 == 0) then
            if state.Connections.DescendantConn then
                local v95 = 0

                while true do
                    if (v95 == 0) then
                        state.Connections.DescendantConn:Disconnect()

                        state.Connections.DescendantConn = nil

                        break
                    end
                end
            end
            if (state.isEnabled and settings.Render.ForceLightShadows) then
                local v96 = 0
                local v97

                while true do
                    if (v96 == 0) then
                        v97 = nil

                        function v97(v123)
                            if v123:IsA('Light') then
                                pcall(function()
                                    v123.Shadows = true
                                end)
                            end
                        end

                        v96 = 1
                    end
                    if (v96 == 1) then
                        for v124, v125 in ipairs(workspace:GetDescendants())do
                            v97(v125)
                        end

                        state.Connections.DescendantConn = workspace.DescendantAdded:Connect(v97)

                        break
                    end
                end
            end

            break
        end
    end
end
local function v20()
    local v34 = 0

    while true do
        if (v34 == 0) then
            if not state.isEnabled then
                return
            end
            if state.BloomEffect then
                local v98 = 0
                local v99

                while true do
                    if (0 == v98) then
                        v99 = 0

                        while true do
                            if (1 == v99) then
                                state.BloomEffect.Threshold = settings.Bloom.Threshold

                                break
                            end
                            if (v99 == 0) then
                                state.BloomEffect.Intensity = settings.Bloom.Intensity
                                state.BloomEffect.Size = settings.Bloom.Size
                                v99 = 1
                            end
                        end

                        break
                    end
                end
            end

            v34 = 1
        end
        if (v34 == 1) then
            pcall(function()
                local v80 = 0

                while true do
                    if (v80 == 0) then
                        lighting.Ambient = settings.Colors.Shadows
                        lighting.OutdoorAmbient = settings.Colors.Environment
                        v80 = 1
                    end
                    if (v80 == 1) then
                        lighting.ColorShift_Top = settings.Colors.Tint

                        break
                    end
                end
            end)
            v18()

            v34 = 2
        end
        if (v34 == 2) then
            v19()

            break
        end
    end
end

renderController.Enable = function(v35)
    local v36 = 0

    while true do
        if (2 == v36) then
            v20()

            break
        end
        if (0 == v36) then
            if v35.State.isEnabled then
                return
            end

            v35.State.Defaults = {
                Ambient = lighting.Ambient,
                OutdoorAmbient = lighting.OutdoorAmbient,
                ColorShift_Top = lighting.ColorShift_Top,
                GlobalShadows = lighting.GlobalShadows,
                EnvDiffuse = lighting.EnvironmentDiffuseScale,
                EnvSpecular = lighting.EnvironmentSpecularScale,
            }
            v36 = 1
        end
        if (v36 == 1) then
            if not v35.State.BloomEffect then
                local bloomEffect = Instance.new('BloomEffect')

                bloomEffect.Name = 'VantalityBloom'
                bloomEffect.Parent = lighting
                v35.State.BloomEffect = bloomEffect
            end

            v35.State.isEnabled = true
            v36 = 2
        end
    end
end
renderController.Disable = function(v37)
    if not v37.State.isEnabled then
        return
    end

    v37.State.isEnabled = false

    if v37.State.BloomEffect then
        v37.State.BloomEffect:Destroy()

        v37.State.BloomEffect = nil
    end

    for v67, v68 in pairs(v37.State.Connections)do
        v68:Disconnect()
    end

    v37.State.Connections = {}

    local defaults = v37.State.Defaults

    pcall(function()
        local v69 = 0

        while true do
            if (2 == v69) then
                lighting.EnvironmentDiffuseScale = defaults.EnvDiffuse
                lighting.EnvironmentSpecularScale = defaults.EnvSpecular

                break
            end
            if (0 == v69) then
                lighting.Ambient = defaults.Ambient
                lighting.OutdoorAmbient = defaults.OutdoorAmbient
                v69 = 1
            end
            if (v69 == 1) then
                lighting.ColorShift_Top = defaults.ColorShift_Top
                lighting.GlobalShadows = defaults.GlobalShadows
                v69 = 2
            end
        end
    end)
end
renderController.UpdateSetting = function(v41, v42, v43) end
renderController.UpdateBloom = function(v44, v45, v46, v47)
    local v48 = 0
    local v49

    while true do
        if (v48 == 0) then
            v49 = 0

            while true do
                if (v49 == 1) then
                    if v47 then
                        v44.Settings.Bloom.Threshold = v47
                    end

                    v20()

                    break
                end
                if (v49 == 0) then
                    if v45 then
                        v44.Settings.Bloom.Intensity = v45
                    end
                    if v46 then
                        v44.Settings.Bloom.Size = v46
                    end

                    v49 = 1
                end
            end

            break
        end
    end
end
renderController.UpdateColors = function(v50, v51, v52, v53)
    local v54 = 0

    while true do
        if (v54 == 1) then
            if v53 then
                v50.Settings.Colors.Tint = v53
            end

            v20()

            break
        end
        if (v54 == 0) then
            if v51 then
                v50.Settings.Colors.Shadows = v51
            end
            if v52 then
                v50.Settings.Colors.Environment = v52
            end

            v54 = 1
        end
    end
end
renderController.UpdateRender = function(v55, v56, v57, v58, v59)
    local v60 = 0
    local v61

    while true do
        if (v60 == 0) then
            v61 = 0

            while true do
                if (v61 == 2) then
                    v20()

                    break
                end
                if (v61 == 1) then
                    if (v58 ~= nil) then
                        v55.Settings.Render.PBR_Reflections = v58
                    end
                    if (v59 ~= nil) then
                        v55.Settings.Render.ForceLightShadows = v59
                    end

                    v61 = 2
                end
                if (v61 == 0) then
                    if (v56 ~= nil) then
                        v55.Settings.Render.Technology = v56
                    end
                    if (v57 ~= nil) then
                        v55.Settings.Render.GlobalShadows = v57
                    end

                    v61 = 1
                end
            end

            break
        end
    end
end
renderController.Toggle = function(v62, v63)
    if v63 then
        v62:Enable()
    else
        v62:Disable()
    end
end
renderController.Destroy = function(v64)
    local v65 = 0

    while true do
        if (v65 == 0) then
            v64:Disable()

            v8.RenderController = nil

            break
        end
    end
end

return renderController
