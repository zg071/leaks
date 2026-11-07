-- by swimhub
local v8 = (getgenv and getgenv()) or _G
local lighting = game:GetService('Lighting')
local players = game:GetService('Players')

if (v8.ExecutorColorCorrection and (typeof(v8.ExecutorColorCorrection.Destroy) == 'function')) then
    local v43 = 0
    local v44

    while true do
        if (v43 == 0) then
            v44 = 0

            while true do
                if (v44 == 0) then
                    pcall(function()
                        v8.ExecutorColorCorrection:Destroy()
                    end)
                    task.wait(0.1)

                    break
                end
            end

            break
        end
    end
end

v8.ExecutorColorCorrection = {}

local executorColorCorrection = v8.ExecutorColorCorrection

executorColorCorrection.Settings = {
    EnableColorCorrection = false,
    EnableVignette = false,
    Brightness = 0,
    Saturation = 0,
    Contrast = 0,
    TintColor = Color3.fromRGB(255, 255, 255),
    VignetteIntensity = 0.5,
}
executorColorCorrection.State = {
    isEnabled = false,
    originalLighting = nil,
    Effect = nil,
    VignetteGui = nil,
    VignetteImg = nil,
}

local v15 = 'rbxassetid://4576475446'

local function v16()
    local v25 = 0
    local state
    local settings

    while true do
        if (1 == v25) then
            if state.Effect then
                state.Effect.Enabled = settings.EnableColorCorrection and state.isEnabled

                if state.Effect.Enabled then
                    local v75 = 0

                    while true do
                        if (v75 == 1) then
                            state.Effect.Contrast = settings.Contrast
                            state.Effect.TintColor = settings.TintColor

                            break
                        end
                        if (v75 == 0) then
                            state.Effect.Brightness = settings.Brightness
                            state.Effect.Saturation = settings.Saturation
                            v75 = 1
                        end
                    end
                end
            end
            if (state.VignetteGui and state.VignetteImg) then
                state.VignetteGui.Enabled = settings.EnableVignette and state.isEnabled

                if state.VignetteGui.Enabled then
                    state.VignetteImg.ImageTransparency = 1 - settings.VignetteIntensity
                end
            end

            break
        end
        if (v25 == 0) then
            state = executorColorCorrection.State
            settings = executorColorCorrection.Settings
            v25 = 1
        end
    end
end

executorColorCorrection.Enable = function(v28)
    local v29 = 0
    local colorCorrection
    local vantalityCC
    local playerGui
    local vantalityVignette

    while true do
        if (v29 == 1) then
            vantalityCC = lighting:FindFirstChild('Vantality_CC')

            if not vantalityCC then
                local v55 = 0

                while true do
                    if (v55 == 0) then
                        vantalityCC = Instance.new('ColorCorrectionEffect')
                        vantalityCC.Name = 'Vantality_CC'
                        v55 = 1
                    end
                    if (v55 == 1) then
                        vantalityCC.Parent = lighting

                        break
                    end
                end
            end

            v28.State.Effect = vantalityCC
            playerGui = players.LocalPlayer:WaitForChild('PlayerGui')
            v29 = 2
        end
        if (v29 == 2) then
            vantalityVignette = playerGui:FindFirstChild('Vantality_Vignette')

            if not vantalityVignette then
                vantalityVignette = Instance.new('ScreenGui')
                vantalityVignette.Name = 'Vantality_Vignette'
                vantalityVignette.IgnoreGuiInset = true
                vantalityVignette.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                vantalityVignette.DisplayOrder = 100
                vantalityVignette.Parent = playerGui

                local imageLabel = Instance.new('ImageLabel')

                imageLabel.Name = 'Img'
                imageLabel.Size = UDim2.fromScale(1, 1)
                imageLabel.BackgroundTransparency = 1
                imageLabel.Image = v15
                imageLabel.ScaleType = Enum.ScaleType.Stretch
                imageLabel.Parent = vantalityVignette
                v28.State.VignetteImg = imageLabel
            else
                v28.State.VignetteImg = vantalityVignette:FindFirstChild('Img')
            end

            v28.State.VignetteGui = vantalityVignette

            v16()

            break
        end
        if (v29 == 0) then
            if v28.State.isEnabled then
                return
            end

            v28.State.isEnabled = true
            colorCorrection = lighting:FindFirstChild('ColorCorrection')

            if not v28.State.originalLighting then
                v28.State.originalLighting = {
                    B = lighting.Brightness,
                    S = (colorCorrection and colorCorrection:IsA('ColorCorrectionEffect') and colorCorrection.Saturation) or 0,
                    C = (colorCorrection and colorCorrection:IsA('ColorCorrectionEffect') and colorCorrection.Contrast) or 0,
                    T = (colorCorrection and colorCorrection:IsA('ColorCorrectionEffect') and colorCorrection.TintColor) or Color3.fromRGB(255, 255, 255),
                }
            end

            v29 = 1
        end
    end
end
executorColorCorrection.Disable = function(v34)
    local v35 = 0

    while true do
        if (v35 == 1) then
            v16()

            break
        end
        if (v35 == 0) then
            if not v34.State.isEnabled then
                return
            end

            v34.State.isEnabled = false
            v35 = 1
        end
    end
end
executorColorCorrection.UpdateSetting = function(v36, v37, v38)
    if (v36.Settings[v37] == nil) then
        return
    end

    v36.Settings[v37] = v38

    if v36.State.isEnabled then
        v16()
    end
end
executorColorCorrection.Destroy = function(v40)
    local v41 = 0

    while true do
        if (v41 == 0) then
            v40:Disable()

            if v40.State.Effect then
                v40.State.Effect:Destroy()
            end

            v41 = 1
        end
        if (1 == v41) then
            if v40.State.VignetteGui then
                v40.State.VignetteGui:Destroy()
            end
            if v40.State.originalLighting then
                local v73 = 0
                local colorCorrection

                while true do
                    if (v73 == 1) then
                        if (colorCorrection and colorCorrection:IsA('ColorCorrectionEffect')) then
                            local v89 = 0

                            while true do
                                if (v89 == 0) then
                                    colorCorrection.Saturation = v40.State.originalLighting.S
                                    colorCorrection.Contrast = v40.State.originalLighting.C
                                    v89 = 1
                                end
                                if (v89 == 1) then
                                    colorCorrection.TintColor = v40.State.originalLighting.T

                                    break
                                end
                            end
                        end

                        break
                    end
                    if (v73 == 0) then
                        pcall(function()
                            lighting.Brightness = v40.State.originalLighting.B
                        end)

                        colorCorrection = lighting:FindFirstChild('ColorCorrection')
                        v73 = 1
                    end
                end
            end

            v41 = 2
        end
        if (v41 == 2) then
            v8.ExecutorColorCorrection = nil
            v8.ExecutorVHS_v3 = nil

            break
        end
    end
end
v8.ExecutorVHS_v3 = executorColorCorrection

return executorColorCorrection
