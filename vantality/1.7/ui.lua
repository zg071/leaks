-- by swimhub
local v8 = (getgenv and getgenv()) or _G

if v8.VantalityMobileGui then
    local v175 = 0

    while true do
        if (v175 == 0) then
            if v8.VantalityMobileGui.Parent then
                v8.VantalityMobileGui:Destroy()
            end

            v8.VantalityMobileGui = nil

            break
        end
    end
end
if v8.ahkgbs_instance then
    local v176 = 0

    while true do
        if (v176 == 1) then
            if (v8.VantalityChristmas and v8.VantalityChristmas.Maid) then
                local v437 = 0

                while true do
                    if (v437 == 0) then
                        for v479, v480 in pairs(v8.VantalityChristmas.Maid)do
                            pcall(function()
                                v480:Destroy()
                            end)
                        end

                        v8.VantalityChristmas = nil

                        break
                    end
                end
            end

            break
        end
        if (v176 == 0) then
            if ((type(v8.ahkgbs_instance) == 'table') and v8.ahkgbs_instance.Main) then
                v8.ahkgbs_instance.Main:Destroy()
            elseif (typeof(v8.ahkgbs_instance) == 'Instance') then
                v8.ahkgbs_instance:Destroy()
            end

            v8.ahkgbs_instance = nil
            v176 = 1
        end
    end
end

local pcallOk, v10 = pcall(function()
    local v54 = 0
    local v55

    while true do
        if (v54 == 0) then
            v55 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/ui_library?v=]] .. tostring(tick())

            return loadstring(game:HttpGet(v55))()
        end
    end
end)

if not pcallOk then
    warn('VANTALITY: \u{41e}\u{428}\u{418}\u{411}\u{41a}\u{410} \u{417}\u{410}\u{413}\u{420}\u{423}\u{417}\u{41a}\u{418} \u{411}\u{418}\u{411}\u{41b}\u{418}\u{41e}\u{422}\u{415}\u{41a}\u{418}:', v10)

    return
end
if (typeof(v10) ~= 'table') then
    warn('VANTALITY: \u{41e}\u{428}\u{418}\u{411}\u{41a}\u{410}: \u{431}\u{438}\u{431}\u{43b}\u{438}\u{43e}\u{442}\u{435}\u{43a}\u{430} \u{43d}\u{435} \u{44f}\u{432}\u{43b}\u{44f}\u{435}\u{442}\u{441}\u{44f} \u{442}\u{430}\u{431}\u{43b}\u{438}\u{446}\u{435}\u{439}. \u{442}\u{438}\u{43f}:', typeof(v10))

    return
end

local v10 = v10
local createNotifier = v10:CreateNotifier()

task.spawn(function()
    local v56 = 0
    local sound

    while true do
        if (0 == v56) then
            sound = Instance.new('Sound')
            sound.Name = 'VantalityIntroFX'
            v56 = 1
        end
        if (v56 == 3) then
            game:GetService('Debris'):AddItem(sound, 20)

            break
        end
        if (v56 == 2) then
            sound.Parent = game:GetService('SoundService')

            sound:Play()

            v56 = 3
        end
        if (v56 == 1) then
            sound.SoundId = 'rbxassetid://118248543183940'
            sound.Volume = 0
            v56 = 2
        end
    end
end)

local loader = v10:Loader({
    Name = 'VANTALITY',
    Scale = 3,
    Manual = true,
})

createNotifier:Notify({
    Title = 'VANTALITY',
    Content = 'welcome, ' .. game.Players.LocalPlayer.DisplayName,
    Icon = 'loader',
})

local new = v10.new({
    Name = 'VANTALITY',
    Expire = 'never',
    Visible = false,
})

v8.ahkgbs_instance = new

local addConfig = new:AddConfig()

addConfig:Init('Main', 'Vantality')

local pcallOk2, v18 = pcall(function()
    return loadstring(game:HttpGet(
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/themes.luau]]))()
end)

if (not pcallOk2 or (type(v18) ~= 'table')) then
    warn('\u{442}\u{435}\u{43c}\u{44b} \u{43d}\u{435} \u{431}\u{44b}\u{43b}\u{438} \u{437}\u{430}\u{433}\u{440}\u{443}\u{436}\u{435}\u{43d}\u{44b}.')

    v18 = {
        GetThemeNames = function()
            return {
                'Default',
            }
        end,
        Apply = function() end,
    }
end

local addMenu = new:AddMenu({
    Name = 'CAMERA',
    Icon = 'camera',
})
local addMenu2 = new:AddMenu({
    Name = 'WORLD',
    Icon = 'globe',
})
local addMenu3 = new:AddMenu({
    Name = 'PLAYER',
    Icon = 'user',
})
local addMenu4 = new:AddMenu({
    Name = 'FLEX (NO FE)',
    Icon = 'crown',
})
local addMenu5 = new:AddMenu({
    Name = 'MISC',
    Icon = 'more-horizontal',
})
local addMenu6 = new:AddMenu({
    Name = 'LUAU',
    Icon = 'code',
})
local addSection = addMenu:AddSection({
    Position = 'left',
    Name = 'FOV',
})
local addSection2 = addMenu:AddSection({
    Position = 'left',
    Name = 'CAMERA BLUR',
})
local addSection3 = addMenu:AddSection({
    Position = 'left',
    Name = 'CAMERA STRAFE',
})
local addSection4 = addMenu:AddSection({
    Position = 'center',
    Name = 'COLOR CORRECTION',
})
local addSection5 = addMenu:AddSection({
    Position = 'right',
    Name = 'ASPECT RATIO',
})
local addSection6 = addMenu:AddSection({
    Position = 'right',
    Name = 'INF ZOOM',
})

do
    local v58 = 0
    local v59
    local v60
    local pcallOk3

    while true do
        if (v58 == 0) then
            v59 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/FOV.luau]]
            v60, pcallOk3 = pcall(game.HttpGet, game, v59, true)
            v58 = 1
        end
        if (v58 == 1) then
            if (v60 and pcallOk3) then
                local v395 = 0
                local v396
                local loadedFunction

                while true do
                    if (0 == v395) then
                        v396, loadedFunction = loadstring(pcallOk3)

                        if v396 then
                            local pcallOk4, v482 = pcall(v396)

                            if not pcallOk4 then
                                local v512 = 0

                                while true do
                                    if (v512 == 0) then
                                        warn('FOV ERR:', v482)

                                        v8.FOV = nil

                                        break
                                    end
                                end
                            end
                        else
                            warn('FOV COMPILE:', loadedFunction)
                        end

                        break
                    end
                end
            else
                warn('FOV DL ERR')
            end

            addSection:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'Fov_Enabled',
                Callback = function(v268)
                    local v269 = 0

                    while true do
                        if (v269 == 0) then
                            if not v8.FOV then
                                return
                            end
                            if v268 then
                                v8.FOV:Enable()
                            else
                                v8.FOV:Disable()
                            end

                            break
                        end
                    end
                end,
            })

            v58 = 2
        end
        if (v58 == 2) then
            addSection:AddSlider({
                Name = 'FOV Value',
                Default = 90,
                Range = {60, 110},
                Precise = 0,
                Flag = 'Fov_Value',
                Callback = function(v270)
                    if v8.FOV then
                        v8.FOV:UpdateSetting('Value', math.floor(v270 + 0.5))
                    end
                end,
            })
            addSection:AddToggle({
                Name = 'Dynamic FOV',
                Default = false,
                Flag = 'Fov_Dynamic',
                Callback = function(v271)
                    if v8.FOV then
                        v8.FOV:UpdateSetting('Dynamic', v271)
                    end
                end,
            })

            v58 = 3
        end
        if (v58 == 3) then
            addSection:AddSlider({
                Name = 'FOV Boost',
                Default = 22,
                Range = {0, 38},
                Precise = 0,
                Flag = 'Fov_Boost',
                Callback = function(v272)
                    if v8.FOV then
                        v8.FOV:UpdateSetting('SpeedFovBoost', math.floor(v272 + 0.5))
                    end
                end,
            })
            addSection:AddSlider({
                Name = 'Boost Speed',
                Default = 8,
                Range = {1, 25},
                Precise = 0,
                Flag = 'Fov_BoostSpeed',
                Callback = function(v273)
                    if v8.FOV then
                        v8.FOV:UpdateSetting('TransitionSpeed', math.floor(v273 + 0.5))
                    end
                end,
            })

            break
        end
    end
end
do
    local v62 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/Motion%20Blur.luau]]
    local pcallOk3, v64 = pcall(game.HttpGet, game, v62, true)

    if (pcallOk3 and v64) then
        local loadedFunction, v219 = loadstring(v64)

        if loadedFunction then
            local pcallOk4, v275 = pcall(loadedFunction)

            if not pcallOk4 then
                local v438 = 0

                while true do
                    if (v438 == 0) then
                        warn('CAM BLUR ERR:', v275)

                        v8.ExecutorSimulatedMB_CamOnly = nil

                        break
                    end
                end
            end
        else
            warn('CAM BLUR COMPILE:', v219)
        end
    else
        warn('CAM BLUR DL ERR')
    end

    addSection2:AddToggle({
        Name = 'Enable',
        Default = false,
        Flag = 'CamBlur_Enabled',
        Callback = function(v177)
            local v178 = 0

            while true do
                if (0 == v178) then
                    if not v8.ExecutorSimulatedMB_CamOnly then
                        return
                    end
                    if v177 then
                        v8.ExecutorSimulatedMB_CamOnly:Enable()
                    else
                        v8.ExecutorSimulatedMB_CamOnly:Disable()
                    end

                    break
                end
            end
        end,
    })
    addSection2:AddSlider({
        Name = 'Blur Strength',
        Default = 10,
        Range = {0, 28},
        Precise = 0,
        Flag = 'CamBlur_Strength',
        Callback = function(v179)
            if v8.ExecutorSimulatedMB_CamOnly then
                v8.ExecutorSimulatedMB_CamOnly:UpdateSetting('MaxBlurSize', math.floor(v179 + 0.5))
            end
        end,
    })
    addSection2:AddSlider({
        Name = 'Transition',
        Default = 26,
        Range = {1, 60},
        Precise = 0,
        Flag = 'CamBlur_Transition',
        Callback = function(v180)
            if v8.ExecutorSimulatedMB_CamOnly then
                v8.ExecutorSimulatedMB_CamOnly:UpdateSetting('TransitionSpeed', math.floor(v180 + 0.5))
            end
        end,
    })
end
do
    local v65 = 0
    local v66
    local v67
    local pcallOk3

    while true do
        if (v65 == 1) then
            if (v67 and pcallOk3) then
                local v398 = 0
                local v399
                local loadedFunction

                while true do
                    if (v398 == 0) then
                        v399, loadedFunction = loadstring(pcallOk3)

                        if v399 then
                            local v483 = 0
                            local v484
                            local pcallOk4

                            while true do
                                if (0 == v483) then
                                    v484, pcallOk4 = pcall(v399)

                                    if not v484 then
                                        local v529 = 0

                                        while true do
                                            if (v529 == 0) then
                                                warn('TILT ERR:', pcallOk4)

                                                v8.CameraTiltTest = nil

                                                break
                                            end
                                        end
                                    end

                                    break
                                end
                            end
                        else
                            warn('TILT COMPILE:', loadedFunction)
                        end

                        break
                    end
                end
            else
                warn('TILT DL ERR')
            end

            addSection3:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'Tilt_Enabled',
                Callback = function(v276)
                    if not v8.CameraTiltTest then
                        return
                    end
                    if v276 then
                        v8.CameraTiltTest:Enable()
                    else
                        v8.CameraTiltTest:Disable()
                    end
                end,
            })

            v65 = 2
        end
        if (2 == v65) then
            addSection3:AddSlider({
                Name = 'Tilt Angle',
                Default = 1,
                Range = {1, 10},
                Precise = 1,
                Flag = 'Tilt_Angle',
                Callback = function(v277)
                    if v8.CameraTiltTest then
                        v8.CameraTiltTest:UpdateSetting('TiltAngle', v277)
                    end
                end,
            })
            addSection3:AddSlider({
                Name = 'Smoothing',
                Default = 6,
                Range = {1, 20},
                Precise = 1,
                Flag = 'Tilt_Smooth',
                Callback = function(v278)
                    if v8.CameraTiltTest then
                        v8.CameraTiltTest:UpdateSetting('Smoothness', v278)
                    end
                end,
            })

            break
        end
        if (v65 == 0) then
            v66 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/camera_strafe.luau]]
            v67, pcallOk3 = pcall(game.HttpGet, game, v66, true)
            v65 = 1
        end
    end
end
do
    local v69 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/VHS.luau]]
    local pcallOk3, v71 = pcall(game.HttpGet, game, v69, true)

    if (pcallOk3 and v71) then
        local v220 = 0
        local v221
        local loadedFunction

        while true do
            if (v220 == 0) then
                v221, loadedFunction = loadstring(v71)

                if v221 then
                    local v450 = 0
                    local v451
                    local v452
                    local pcallOk4

                    while true do
                        if (v450 == 1) then
                            pcallOk4 = nil

                            while true do
                                if (0 == v451) then
                                    v452, pcallOk4 = pcall(v221)

                                    if not v452 then
                                        local v530 = 0

                                        while true do
                                            if (v530 == 0) then
                                                warn('VHS ERR:', pcallOk4)

                                                v8.ExecutorVHS_v3 = nil

                                                break
                                            end
                                        end
                                    end

                                    break
                                end
                            end

                            break
                        end
                        if (v450 == 0) then
                            v451 = 0
                            v452 = nil
                            v450 = 1
                        end
                    end
                else
                    warn('VHS COMPILE:', loadedFunction)
                end

                break
            end
        end
    else
        warn('VHS DL ERR')
    end

    addSection4:AddToggle({
        Name = 'Enable',
        Default = false,
        Flag = 'MiscV3_Enabled',
        Callback = function(v181)
            local v182 = 0

            while true do
                if (v182 == 0) then
                    if not v8.ExecutorVHS_v3 then
                        return
                    end
                    if v181 then
                        v8.ExecutorVHS_v3:Enable()
                    else
                        v8.ExecutorVHS_v3:Disable()
                    end

                    break
                end
            end
        end,
    })
    addSection4:AddToggle({
        Name = 'Color Correction',
        Default = true,
        Flag = 'MiscV3_ColorCorrection',
        Callback = function(v183)
            if v8.ExecutorVHS_v3 then
                v8.ExecutorVHS_v3:UpdateSetting('EnableColorCorrection', v183)
            end
        end,
    })
    addSection4:AddSlider({
        Name = 'Brightness',
        Default = 0,
        Range = {
            -0.5,
            0.5,
        },
        Precise = 2,
        Flag = 'MiscV3_Brightness',
        Callback = function(v184)
            if v8.ExecutorVHS_v3 then
                v8.ExecutorVHS_v3:UpdateSetting('Brightness', v184)
            end
        end,
    })
    addSection4:AddSlider({
        Name = 'Saturation',
        Default = 0,
        Range = {
            -0.5,
            1,
        },
        Precise = 2,
        Flag = 'MiscV3_Saturation',
        Callback = function(v185)
            if v8.ExecutorVHS_v3 then
                v8.ExecutorVHS_v3:UpdateSetting('Saturation', v185)
            end
        end,
    })
    addSection4:AddSlider({
        Name = 'Contrast',
        Default = 0,
        Range = {
            -1,
            1,
        },
        Precise = 2,
        Flag = 'MiscV3_Contrast',
        Callback = function(v186)
            if v8.ExecutorVHS_v3 then
                v8.ExecutorVHS_v3:UpdateSetting('Contrast', v186)
            end
        end,
    })
    addSection4:AddToggle({
        Name = 'Vignette',
        Default = true,
        Flag = 'MiscV3_Vignette',
        Callback = function(v187)
            if v8.ExecutorVHS_v3 then
                v8.ExecutorVHS_v3:UpdateSetting('EnableVignette', v187)
            end
        end,
    })
    addSection4:AddSlider({
        Name = 'Intensity',
        Default = 0.5,
        Range = {0, 1},
        Precise = 2,
        Flag = 'MiscV3_VignetteIntensity',
        Callback = function(v188)
            if v8.ExecutorVHS_v3 then
                v8.ExecutorVHS_v3:UpdateSetting('VignetteIntensity', v188)
            end
        end,
    })
end
do
    local v72 = 0
    local v73
    local v74
    local pcallOk3

    while true do
        if (0 == v72) then
            v73 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/Aspect%20Ratio.luau]]
            v74, pcallOk3 = pcall(game.HttpGet, game, v73, true)
            v72 = 1
        end
        if (v72 == 2) then
            addSection5:AddSlider({
                Name = 'Stretch Factor',
                Default = 0.75,
                Range = {0.55, 1},
                Precise = 2,
                Flag = 'Stretch_Factor',
                Callback = function(v279)
                    if v8.ExecutorScreenStretch then
                        v8.ExecutorScreenStretch:UpdateSetting('StretchFactor', v279)
                    end
                end,
            })

            break
        end
        if (v72 == 1) then
            if (v74 and pcallOk3) then
                local v401 = 0
                local v402
                local loadedFunction

                while true do
                    if (0 == v401) then
                        v402, loadedFunction = loadstring(pcallOk3)

                        if v402 then
                            local v486 = 0
                            local v487
                            local pcallOk4

                            while true do
                                if (v486 == 0) then
                                    v487, pcallOk4 = pcall(v402)

                                    if not v487 then
                                        local v531 = 0
                                        local v532

                                        while true do
                                            if (v531 == 0) then
                                                v532 = 0

                                                while true do
                                                    if (v532 == 0) then
                                                        warn('STRETCH ERR:', pcallOk4)

                                                        v8.ExecutorScreenStretch = nil

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
                        else
                            warn('STRETCH COMPILE:', loadedFunction)
                        end

                        break
                    end
                end
            else
                warn('STRETCH DL ERR')
            end

            addSection5:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'Stretch_Enabled',
                Risky = true,
                Callback = function(v280)
                    local v281 = 0

                    while true do
                        if (v281 == 0) then
                            if not v8.ExecutorScreenStretch then
                                return
                            end
                            if v280 then
                                v8.ExecutorScreenStretch:Enable()
                            else
                                v8.ExecutorScreenStretch:Disable()
                            end

                            break
                        end
                    end
                end,
            })

            v72 = 2
        end
    end
end
do
    local v76 = 0
    local v77
    local v78
    local pcallOk3

    while true do
        if (v76 == 0) then
            local v251 = 0

            while true do
                if (1 == v251) then
                    v76 = 1

                    break
                end
                if (v251 == 0) then
                    v77 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/max%20zoom.luau]]
                    v78, pcallOk3 = pcall(game.HttpGet, game, v77, true)
                    v251 = 1
                end
            end
        end
        if (v76 == 1) then
            if (v78 and pcallOk3) then
                local v404 = 0
                local v405
                local loadedFunction

                while true do
                    if (v404 == 0) then
                        v405, loadedFunction = loadstring(pcallOk3)

                        if v405 then
                            local v489 = 0
                            local v490
                            local v491
                            local pcallOk4

                            while true do
                                if (v489 == 1) then
                                    pcallOk4 = nil

                                    while true do
                                        if (v490 == 0) then
                                            v491, pcallOk4 = pcall(v405)

                                            if not v491 then
                                                local v548 = 0

                                                while true do
                                                    if (v548 == 0) then
                                                        warn('ZOOM ERR:', pcallOk4)

                                                        v8.ExecutorZoom = nil

                                                        break
                                                    end
                                                end
                                            end

                                            break
                                        end
                                    end

                                    break
                                end
                                if (v489 == 0) then
                                    v490 = 0
                                    v491 = nil
                                    v489 = 1
                                end
                            end
                        else
                            warn('ZOOM COMPILE:', loadedFunction)
                        end

                        break
                    end
                end
            else
                warn('ZOOM DL ERR')
            end

            addSection6:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'Zoom_Enabled',
                Callback = function(v282)
                    local v283 = 0
                    local v284

                    while true do
                        if (v283 == 0) then
                            v284 = 0

                            while true do
                                if (v284 == 0) then
                                    if not v8.ExecutorZoom then
                                        return
                                    end
                                    if v282 then
                                        v8.ExecutorZoom:Enable()
                                    else
                                        v8.ExecutorZoom:Disable()
                                    end

                                    break
                                end
                            end

                            break
                        end
                    end
                end,
            })

            break
        end
    end
end

local addSection7 = addMenu2:AddSection({
    Position = 'left',
    Name = 'FOG',
})
local addSection8 = addMenu2:AddSection({
    Position = 'center',
    Name = 'SKY',
})
local addSection9 = addMenu2:AddSection({
    Position = 'right',
    Name = 'RENDERING',
})

do
    local v80 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/FOG.luau]]
    local pcallOk3, v82 = pcall(game.HttpGet, game, v80, true)

    if (pcallOk3 and v82) then
        local v223 = 0
        local loadedFunction

        while true do
            if (v223 == 0) then
                loadedFunction = loadstring(v82)

                if loadedFunction then
                    pcall(loadedFunction)
                end

                break
            end
        end
    end

    addSection7:AddToggle({
        Name = 'Enable',
        Flag = 'Fog_Enabled',
        Callback = function(v189)
            if v8.ExecutorAtmosphere then
                if v189 then
                    v8.ExecutorAtmosphere:Enable()
                else
                    v8.ExecutorAtmosphere:Disable()
                end
            end
        end,
    })
    addSection7:AddColorPicker({
        Name = 'Color',
        Default = Color3.fromRGB(255, 255, 255),
        Flag = 'Fog_Color',
        Callback = function(v190)
            if v8.ExecutorAtmosphere then
                v8.ExecutorAtmosphere:UpdateSetting('Color', v190)
            end
        end,
    })
    addSection7:AddColorPicker({
        Name = 'Decay',
        Default = Color3.fromRGB(106, 112, 125),
        Flag = 'Fog_Decay',
        Callback = function(v191)
            if v8.ExecutorAtmosphere then
                v8.ExecutorAtmosphere:UpdateSetting('Decay', v191)
            end
        end,
    })
    addSection7:AddSlider({
        Name = 'Density',
        Default = 0.3,
        Range = {0, 1},
        Precise = 2,
        Flag = 'Fog_Density',
        Callback = function(v192)
            if v8.ExecutorAtmosphere then
                v8.ExecutorAtmosphere:UpdateSetting('Density', v192)
            end
        end,
    })
    addSection7:AddSlider({
        Name = 'Offset',
        Default = 0.5,
        Range = {0, 1},
        Precise = 2,
        Flag = 'Fog_Offset',
        Callback = function(v193)
            if v8.ExecutorAtmosphere then
                v8.ExecutorAtmosphere:UpdateSetting('Offset', v193)
            end
        end,
    })
    addSection7:AddSlider({
        Name = 'Haze',
        Default = 3,
        Range = {0.1, 3},
        Precise = 2,
        Flag = 'Fog_Haze',
        Callback = function(v194)
            if v8.ExecutorAtmosphere then
                v8.ExecutorAtmosphere:UpdateSetting('Haze', v194)
            end
        end,
    })
    addSection7:AddSlider({
        Name = 'Glare',
        Default = 1,
        Range = {0, 5},
        Precise = 2,
        Flag = 'Fog_Glare',
        Callback = function(v195)
            if v8.ExecutorAtmosphere then
                v8.ExecutorAtmosphere:UpdateSetting('Glare', v195)
            end
        end,
    })
end
do
    local v83 = 0
    local v84
    local v85
    local pcallOk3
    local v87

    while true do
        if (v83 == 0) then
            v84 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/sky]]
            v85, pcallOk3 = pcall(game.HttpGet, game, v84, true)

            if (v85 and pcallOk3) then
                local v407 = 0
                local loadedFunction

                while true do
                    if (v407 == 0) then
                        loadedFunction = loadstring(pcallOk3)

                        if loadedFunction then
                            pcall(loadedFunction)
                        end

                        break
                    end
                end
            end

            v83 = 1
        end
        if (v83 == 3) then
            addSection8:AddSlider({
                Name = 'Sun Rays Spread',
                Default = 0.1,
                Range = {0, 1},
                Precise = 2,
                Flag = 'Sky_RaysSpread',
                Callback = function(v285)
                    local v87_2 = v87()

                    if v87_2 then
                        v87_2:SetSun(nil, nil, v285)
                    end
                end,
            })
            addSection8:AddSlider({
                Name = 'Moon Size',
                Default = 9,
                Range = {0, 60},
                Precise = 1,
                Flag = 'Sky_MoonSize',
                Callback = function(v287)
                    local v288 = 0
                    local v87_2

                    while true do
                        if (v288 == 0) then
                            v87_2 = v87()

                            if v87_2 then
                                v87_2:SetMoon(v287)
                            end

                            break
                        end
                    end
                end,
            })
            addSection8:AddSlider({
                Name = 'Stars Count',
                Default = 3000,
                Range = {0, 5000},
                Precise = 0,
                Flag = 'Sky_Stars',
                Callback = function(v290)
                    local v291 = 0
                    local v87_2

                    while true do
                        if (0 == v291) then
                            v87_2 = v87()

                            if v87_2 then
                                v87_2:SetStars(v290)
                            end

                            break
                        end
                    end
                end,
            })

            v83 = 4
        end
        if (2 == v83) then
            addSection8:AddSlider({
                Name = 'Sun Brightness',
                Default = 2,
                Range = {0, 10},
                Precise = 2,
                Flag = 'Sky_Brightness',
                Callback = function(v293)
                    local v294 = 0
                    local v87_2

                    while true do
                        if (v294 == 0) then
                            v87_2 = v87()

                            if v87_2 then
                                v87_2:SetBrightness(v293)
                            end

                            break
                        end
                    end
                end,
            })
            addSection8:AddSlider({
                Name = 'Sun Size',
                Default = 8,
                Range = {0, 60},
                Precise = 1,
                Flag = 'Sky_SunSize',
                Callback = function(v296)
                    local v87_2 = v87()

                    if v87_2 then
                        v87_2:SetSun(v296, nil, nil)
                    end
                end,
            })
            addSection8:AddSlider({
                Name = 'Sun Rays Intensity',
                Default = 0.25,
                Range = {0, 100},
                Precise = 2,
                Flag = 'Sky_SunRays',
                Callback = function(v298)
                    local v299 = 0
                    local v87_2

                    while true do
                        if (0 == v299) then
                            v87_2 = v87()

                            if v87_2 then
                                v87_2:SetSun(nil, v298, nil)
                            end

                            break
                        end
                    end
                end,
            })

            v83 = 3
        end
        if (v83 == 1) then
            v87 = nil

            function v87()
                return v8.SkyManager
            end

            addSection8:AddToggle({
                Name = 'Enable',
                Flag = 'Sky_Enabled',
                Callback = function(v301)
                    local v302 = 0
                    local v87_2

                    while true do
                        if (v302 == 0) then
                            v87_2 = v87()

                            if v87_2 then
                                if v301 then
                                    v87_2:Enable()
                                else
                                    v87_2:Disable()
                                end
                            end

                            break
                        end
                    end
                end,
            })

            v83 = 2
        end
        if (v83 == 4) then
            addSection8:AddSlider({
                Name = 'Cloud Cover',
                Default = 0.5,
                Range = {0, 1},
                Precise = 2,
                Flag = 'Sky_CloudCover',
                Callback = function(v304)
                    local v305 = 0
                    local v87_2

                    while true do
                        if (v305 == 0) then
                            v87_2 = v87()

                            if v87_2 then
                                v87_2:SetClouds(v304, nil, nil)
                            end

                            break
                        end
                    end
                end,
            })
            addSection8:AddSlider({
                Name = 'Cloud Density',
                Default = 0.7,
                Range = {0, 1},
                Precise = 2,
                Flag = 'Sky_CloudDensity',
                Callback = function(v307)
                    local v308 = 0
                    local v87_2

                    while true do
                        if (v308 == 0) then
                            v87_2 = v87()

                            if v87_2 then
                                v87_2:SetClouds(nil, v307, nil)
                            end

                            break
                        end
                    end
                end,
            })
            addSection8:AddColorPicker({
                Name = 'Cloud Color',
                Default = Color3.fromRGB(255, 255, 255),
                Flag = 'Sky_CloudColor',
                Callback = function(v310)
                    local v311 = 0
                    local v87_2

                    while true do
                        if (v311 == 0) then
                            v87_2 = v87()

                            if v87_2 then
                                v87_2:SetClouds(nil, nil, v310)
                            end

                            break
                        end
                    end
                end,
            })

            break
        end
    end
end
do
    local v88 = 0
    local v89
    local v90
    local pcallOk3

    while true do
        if (v88 == 3) then
            addSection9:AddSlider({
                Name = 'Bloom Size',
                Default = 0,
                Range = {0, 100},
                Precise = 0,
                Flag = 'Light_BloomSize',
                Callback = function(v313)
                    if v8.RenderController then
                        v8.RenderController:UpdateBloom(nil, v313, nil)
                    end
                end,
            })
            addSection9:AddSlider({
                Name = 'Bloom Threshold',
                Default = 0,
                Range = {0, 1},
                Precise = 2,
                Flag = 'Light_BloomThresh',
                Callback = function(v314)
                    if v8.RenderController then
                        v8.RenderController:UpdateBloom(nil, nil, v314)
                    end
                end,
            })
            addSection9:AddColorPicker({
                Name = 'Shadow Color',
                Default = Color3.fromRGB(0, 0, 0),
                Flag = 'Light_ShadowColor',
                Callback = function(v315)
                    if v8.RenderController then
                        v8.RenderController:UpdateColors(v315, nil, nil)
                    end
                end,
            })

            v88 = 4
        end
        if (v88 == 1) then
            addSection9:AddToggle({
                Name = 'Enable',
                Flag = 'Render_Enabled',
                Callback = function(v316)
                    if v8.RenderController then
                        v8.RenderController:Toggle(v316)
                    end
                end,
            })
            addSection9:AddDropdown({
                Name = 'Technology',
                Default = 'ShadowMap',
                Values = {
                    'Voxel',
                    'ShadowMap',
                    'Future',
                },
                Flag = 'Render_Tech',
                Callback = function(v317)
                    if v8.RenderController then
                        v8.RenderController:UpdateRender(v317, nil, nil, nil)
                    end
                end,
            })
            addSection9:AddToggle({
                Name = 'Global Shadows',
                Default = true,
                Flag = 'Render_GlobalShadows',
                Callback = function(v318)
                    if v8.RenderController then
                        v8.RenderController:UpdateRender(nil, v318, nil, nil)
                    end
                end,
            })

            v88 = 2
        end
        if (v88 == 2) then
            addSection9:AddToggle({
                Name = 'Force Light Shadows',
                Default = false,
                Flag = 'Render_ForceShadows',
                Callback = function(v319)
                    if v8.RenderController then
                        v8.RenderController:UpdateRender(nil, nil, nil, v319)
                    end
                end,
            })
            addSection9:AddSlider({
                Name = 'PBR Reflections',
                Default = 0,
                Range = {0, 1},
                Precise = 2,
                Flag = 'Render_PBR',
                Callback = function(v320)
                    if v8.RenderController then
                        v8.RenderController:UpdateRender(nil, nil, v320, nil)
                    end
                end,
            })
            addSection9:AddSlider({
                Name = 'Bloom Intensity',
                Default = 0,
                Range = {0, 5},
                Precise = 2,
                Flag = 'Light_BloomInt',
                Callback = function(v321)
                    if v8.RenderController then
                        v8.RenderController:UpdateBloom(v321, nil, nil)
                    end
                end,
            })

            v88 = 3
        end
        if (v88 == 4) then
            addSection9:AddColorPicker({
                Name = 'Environment Color',
                Default = Color3.fromRGB(100, 100, 100),
                Flag = 'Light_EnvColor',
                Callback = function(v322)
                    if v8.RenderController then
                        v8.RenderController:UpdateColors(nil, v322, nil)
                    end
                end,
            })
            addSection9:AddColorPicker({
                Name = 'Tint Color',
                Default = Color3.fromRGB(255, 255, 255),
                Flag = 'Light_TintColor',
                Callback = function(v323)
                    if v8.RenderController then
                        v8.RenderController:UpdateColors(nil, nil, v323)
                    end
                end,
            })

            break
        end
        if (0 == v88) then
            local v252 = 0
            local v253

            while true do
                if (v252 == 0) then
                    v253 = 0

                    while true do
                        if (v253 == 1) then
                            if (v90 and pcallOk3) then
                                local loadedFunction = loadstring(pcallOk3)

                                if loadedFunction then
                                    pcall(loadedFunction)
                                end
                            end

                            v88 = 1

                            break
                        end
                        if (v253 == 0) then
                            v89 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/lighting]]
                            v90, pcallOk3 = pcall(game.HttpGet, game, v89, true)
                            v253 = 1
                        end
                    end

                    break
                end
            end
        end
    end
end

local addSection10 = addMenu3:AddSection({
    Position = 'left',
    Name = 'PLAYER ARROWS',
})

do
    local v92 = 0
    local v93
    local v94
    local pcallOk3

    while true do
        if (0 == v92) then
            v93 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/Arrows.luau]]
            v94, pcallOk3 = pcall(game.HttpGet, game, v93, true)

            if (v94 and pcallOk3) then
                local v409 = 0
                local v410
                local v411
                local loadedFunction

                while true do
                    if (v409 == 1) then
                        loadedFunction = nil

                        while true do
                            if (v410 == 0) then
                                v411, loadedFunction = loadstring(pcallOk3)

                                if v411 then
                                    local v516 = 0
                                    local v517
                                    local pcallOk4

                                    while true do
                                        if (v516 == 0) then
                                            v517, pcallOk4 = pcall(v411)

                                            if not v517 then
                                                local v549 = 0

                                                while true do
                                                    if (v549 == 0) then
                                                        warn('ARROWS ERR:', pcallOk4)

                                                        v8.ExecutorPlayerArrows = nil

                                                        break
                                                    end
                                                end
                                            end

                                            break
                                        end
                                    end
                                else
                                    warn('ARROWS COMPILE:', loadedFunction)
                                end

                                break
                            end
                        end

                        break
                    end
                    if (v409 == 0) then
                        v410 = 0
                        v411 = nil
                        v409 = 1
                    end
                end
            else
                warn('ARROWS DL ERR')
            end

            addSection10:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'Arrows_Enabled',
                Callback = function(v324)
                    local v325 = 0
                    local v326

                    while true do
                        if (v325 == 0) then
                            v326 = 0

                            while true do
                                if (v326 == 0) then
                                    if not v8.ExecutorPlayerArrows then
                                        return
                                    end
                                    if v324 then
                                        v8.ExecutorPlayerArrows:Enable()
                                    else
                                        v8.ExecutorPlayerArrows:Disable()
                                    end

                                    break
                                end
                            end

                            break
                        end
                    end
                end,
            })

            v92 = 1
        end
        if (3 == v92) then
            addSection10:AddSlider({
                Name = 'Near Dist',
                Default = 30,
                Range = {5, 100},
                Precise = 0,
                Flag = 'Arrows_NearDistScale',
                Callback = function(v327)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('NearDistanceForScaling', v327)
                    end
                end,
            })
            addSection10:AddSlider({
                Name = 'Far Dist',
                Default = 150,
                Range = {50, 500},
                Precise = 0,
                Flag = 'Arrows_FarDistScale',
                Callback = function(v328)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('FarDistanceForScaling', v328)
                    end
                end,
            })
            addSection10:AddToggle({
                Name = 'Dynamic Color',
                Default = true,
                Flag = 'Arrows_DynColor',
                Callback = function(v329)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('EnableDynamicColor', v329)
                    end
                end,
            })
            addSection10:AddColorPicker({
                Name = 'Color (Far)',
                Default = Color3.fromRGB(80, 200, 80),
                Flag = 'Arrows_ColorFar',
                Callback = function(v330)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('ArrowColorFar', v330)
                    end
                end,
            })

            v92 = 4
        end
        if (v92 == 4) then
            addSection10:AddColorPicker({
                Name = 'Color (Near)',
                Default = Color3.fromRGB(255, 80, 80),
                Flag = 'Arrows_ColorNear',
                Callback = function(v331)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('ArrowColorNear', v331)
                    end
                end,
            })

            break
        end
        if (v92 == 2) then
            addSection10:AddSlider({
                Name = 'Max Arrows',
                Default = 0,
                Range = {0, 20},
                Precise = 0,
                Flag = 'Arrows_MaxVisible',
                Callback = function(v332)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('MaxVisibleArrows', v332)
                    end
                end,
            })
            addSection10:AddToggle({
                Name = 'Dynamic Size',
                Default = true,
                Flag = 'Arrows_DynSize',
                Callback = function(v333)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('EnableDynamicSize', v333)
                    end
                end,
            })
            addSection10:AddSlider({
                Name = 'Min Scale',
                Default = 0.5,
                Range = {0.1, 1},
                Precise = 2,
                Flag = 'Arrows_MinScale',
                Callback = function(v334)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('MinArrowScale', v334)
                    end
                end,
            })
            addSection10:AddSlider({
                Name = 'Max Scale',
                Default = 1.5,
                Range = {1, 3},
                Precise = 2,
                Flag = 'Arrows_MaxScale',
                Callback = function(v335)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('MaxArrowScale', v335)
                    end
                end,
            })

            v92 = 3
        end
        if (v92 == 1) then
            addSection10:AddSlider({
                Name = 'Render Distance',
                Default = 300,
                Range = {50, 1000},
                Precise = 0,
                Flag = 'Arrows_RenderDist',
                Callback = function(v336)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('RenderDistance', v336)
                    end
                end,
            })
            addSection10:AddSlider({
                Name = 'Ring Radius',
                Default = 120,
                Range = {50, 400},
                Precise = 0,
                Flag = 'Arrows_RingRadius',
                Callback = function(v337)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('RingRadius', v337)
                    end
                end,
            })
            addSection10:AddSlider({
                Name = 'Base Size',
                Default = 32,
                Range = {16, 64},
                Precise = 0,
                Flag = 'Arrows_BaseSize',
                Callback = function(v338)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('ArrowBaseSizeXY', v338)
                    end
                end,
            })
            addSection10:AddSlider({
                Name = 'Transparency',
                Default = 0.1,
                Range = {0, 1},
                Precise = 2,
                Flag = 'Arrows_Transparency',
                Callback = function(v339)
                    if v8.ExecutorPlayerArrows then
                        v8.ExecutorPlayerArrows:UpdateSetting('ArrowTransparency', v339)
                    end
                end,
            })

            v92 = 2
        end
    end
end

local addSection11 = addMenu4:AddSection({
    Position = 'Left',
    Name = 'SPOOF LEADERBOARDS',
})
local addSection12 = addMenu4:AddSection({
    Position = 'left',
    Name = 'FAKE KILLS',
})
local addSection13 = addMenu4:AddSection({
    Position = 'left',
    Name = 'KILL STREAK',
})
local addSection14 = addMenu4:AddSection({
    Position = 'center',
    Name = 'AVATAR CHANGER',
})
local addSection15 = addMenu4:AddSection({
    Position = 'center',
    Name = 'AURAS',
})
local addSection16 = addMenu4:AddSection({
    Position = 'right',
    Name = 'CHINA HAT',
})
local addSection17 = addMenu4:AddSection({
    Position = 'right',
    Name = 'FAKE ACCESSORIES',
})

do
    local v96 = 0
    local v97
    local v98
    local pcallOk3

    while true do
        if (v96 == 1) then
            addSection11:AddToggle({
                Name = 'Spoof Season Kills',
                Default = false,
                Flag = 'Spoofer_LB_SeasonKills',
                Callback = function(v340)
                    if v8.ExecutorSpoofer then
                        v8.ExecutorSpoofer:UpdateSetting('Leaderboards.SpoofTotalKills', v340)
                    end
                end,
            })
            addSection11:AddToggle({
                Name = 'Spoof Total Kills',
                Default = false,
                Flag = 'Spoofer_LB_TotalKills',
                Callback = function(v341)
                    if v8.ExecutorSpoofer then
                        v8.ExecutorSpoofer:UpdateSetting('Leaderboards.SpoofTotalKillsReal', v341)
                    end
                end,
            })
            addSection11:AddToggle({
                Name = 'Spoof Donations',
                Default = false,
                Flag = 'Spoofer_LB_Donations',
                Callback = function(v342)
                    if v8.ExecutorSpoofer then
                        v8.ExecutorSpoofer:UpdateSetting('Leaderboards.SpoofDonations', v342)
                    end
                end,
            })
            addSection12:AddToggle({
                Name = 'Fake Season Kills',
                Default = false,
                Flag = 'Spoofer_Stats_SeasonEnabled',
                Callback = function(v343)
                    if v8.ExecutorSpoofer then
                        v8.ExecutorSpoofer:UpdateSetting('Leaderstats.SpoofKills', v343)
                    end
                end,
            })

            v96 = 2
        end
        if (2 == v96) then
            addSection12:AddInput({
                Name = 'Amount',
                Default = '1337',
                Flag = 'Spoofer_Stats_SeasonAmount',
                Callback = function(v344)
                    if v8.ExecutorSpoofer then
                        local v439 = 0
                        local toNumber

                        while true do
                            if (v439 == 0) then
                                toNumber = tonumber(v344)

                                if toNumber then
                                    v8.ExecutorSpoofer:UpdateSetting('Leaderstats.TargetKills', math.floor(toNumber))
                                end

                                break
                            end
                        end
                    end
                end,
            })
            addSection12:AddToggle({
                Name = 'Fake Total Kills',
                Default = false,
                Flag = 'Spoofer_Stats_TotalEnabled',
                Callback = function(v345)
                    if v8.ExecutorSpoofer then
                        v8.ExecutorSpoofer:UpdateSetting('Leaderstats.SpoofTotalKillsStat', v345)
                    end
                end,
            })
            addSection12:AddInput({
                Name = 'Amount',
                Default = '9001',
                Flag = 'Spoofer_Stats_TotalAmount',
                Callback = function(v346)
                    if v8.ExecutorSpoofer then
                        local v441 = 0
                        local toNumber

                        while true do
                            if (v441 == 0) then
                                toNumber = tonumber(v346)

                                if toNumber then
                                    v8.ExecutorSpoofer:UpdateSetting('Leaderstats.TargetTotalKills', math.floor(toNumber))
                                end

                                break
                            end
                        end
                    end
                end,
            })

            break
        end
        if (v96 == 0) then
            v97 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/FLEX.luau]]
            v98, pcallOk3 = pcall(game.HttpGet, game, v97, true)

            if (v98 and pcallOk3) then
                local v413 = 0
                local v414
                local loadedFunction

                while true do
                    if (v413 == 0) then
                        v414, loadedFunction = loadstring(pcallOk3)

                        if v414 then
                            local v493 = 0
                            local v494
                            local pcallOk4

                            while true do
                                if (0 == v493) then
                                    v494, pcallOk4 = pcall(v414)

                                    if not v494 then
                                        local v533 = 0

                                        while true do
                                            if (v533 == 0) then
                                                warn('SPOOFER ERR:', pcallOk4)

                                                v8.ExecutorSpoofer = nil

                                                break
                                            end
                                        end
                                    end

                                    break
                                end
                            end
                        else
                            warn('SPOOFER COMPILE:', loadedFunction)
                        end

                        break
                    end
                end
            else
                warn('SPOOFER DL ERR')
            end

            addSection11:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'Spoofer_LB_Enabled',
                Callback = function(v347)
                    if not v8.ExecutorSpoofer then
                        return
                    end
                    if v347 then
                        v8.ExecutorSpoofer:EnableLeaderboardSpoof()
                    else
                        v8.ExecutorSpoofer:DisableLeaderboardSpoof()
                    end
                end,
            })

            v96 = 1
        end
    end
end
do
    local v100 = 0
    local v101
    local v102
    local pcallOk3

    while true do
        if (0 == v100) then
            v101 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/Kill%20Streak.luau]]
            v102, pcallOk3 = pcall(game.HttpGet, game, v101, true)
            v100 = 1
        end
        if (v100 == 2) then
            addSection13:AddInput({
                Name = 'Display Text',
                Default = '2',
                Flag = 'KillS_DisplayText',
                Callback = function(v348)
                    if v8.ExecutorKillStreakEffect then
                        v8.ExecutorKillStreakEffect:UpdateSetting('DisplayText', v348)
                    end
                end,
            })

            break
        end
        if (v100 == 1) then
            if (v102 and pcallOk3) then
                local v416 = 0
                local v417
                local loadedFunction

                while true do
                    if (v416 == 0) then
                        v417, loadedFunction = loadstring(pcallOk3)

                        if v417 then
                            local pcallOk4, v497 = pcall(v417)

                            if not pcallOk4 then
                                local v513 = 0
                                local v514

                                while true do
                                    if (0 == v513) then
                                        v514 = 0

                                        while true do
                                            if (v514 == 0) then
                                                warn('KillS ERR:', v497)

                                                v8.ExecutorKillStreakEffect = nil

                                                break
                                            end
                                        end

                                        break
                                    end
                                end
                            end
                        else
                            warn('KillS COMPILE:', loadedFunction)
                        end

                        break
                    end
                end
            else
                warn('KillS DL ERR')
            end

            addSection13:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'KillS_Enabled',
                Callback = function(v349)
                    local v350 = 0

                    while true do
                        if (v350 == 0) then
                            if not v8.ExecutorKillStreakEffect then
                                return
                            end
                            if v349 then
                                v8.ExecutorKillStreakEffect:Enable()
                            else
                                v8.ExecutorKillStreakEffect:Disable()
                            end

                            break
                        end
                    end
                end,
            })

            v100 = 2
        end
    end
end
do
    local v104 = 0
    local v105
    local v106
    local pcallOk3

    while true do
        if (1 == v104) then
            if (v106 and pcallOk3) then
                local loadedFunction, v420 = loadstring(pcallOk3)

                if loadedFunction then
                    local v454 = 0
                    local v455
                    local v456
                    local pcallOk4

                    while true do
                        if (v454 == 1) then
                            pcallOk4 = nil

                            while true do
                                if (v455 == 0) then
                                    v456, pcallOk4 = pcall(loadedFunction)

                                    if not v456 then
                                        local v534 = 0

                                        while true do
                                            if (0 == v534) then
                                                warn('AVATAR CHANGER ERR:', pcallOk4)

                                                v8.ExecutorAvatarChanger = nil

                                                break
                                            end
                                        end
                                    end

                                    break
                                end
                            end

                            break
                        end
                        if (v454 == 0) then
                            local v498 = 0

                            while true do
                                if (0 == v498) then
                                    v455 = 0
                                    v456 = nil
                                    v498 = 1
                                end
                                if (1 == v498) then
                                    v454 = 1

                                    break
                                end
                            end
                        end
                    end
                else
                    warn('AVATAR CHANGER COMPILE:', v420)
                end
            else
                warn('AVATAR CHANGER DL ERR')
            end

            addSection14:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'AvatarSwap_Enabled',
                Callback = function(v351)
                    local v352 = 0

                    while true do
                        if (0 == v352) then
                            if not v8.ExecutorAvatarChanger then
                                return
                            end
                            if v351 then
                                v8.ExecutorAvatarChanger:Enable()
                            else
                                v8.ExecutorAvatarChanger:Disable()
                            end

                            break
                        end
                    end
                end,
            })

            v104 = 2
        end
        if (v104 == 0) then
            local v254 = 0

            while true do
                if (v254 == 0) then
                    v105 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/avatar_changer]]
                    v106, pcallOk3 = pcall(game.HttpGet, game, v105, true)
                    v254 = 1
                end
                if (v254 == 1) then
                    v104 = 1

                    break
                end
            end
        end
        if (v104 == 2) then
            addSection14:AddInput({
                Name = 'Target Username',
                Default = 'grabisVT',
                Flag = 'AvatarSwap_Username',
                Callback = function(v353)
                    if v8.ExecutorAvatarChanger then
                        v8.ExecutorAvatarChanger:UpdateSetting('TargetUsername', v353)
                    end
                end,
            })

            break
        end
    end
end
do
    local v108 = 0
    local v109
    local v110
    local v111
    local pcallOk3
    local v113
    local pcallOk4

    while true do
        if (v108 == 0) then
            v109 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/custom_auras]]
            v110 = 'https://pastebin.com/raw/TK7Ymzja'
            v108 = 1
        end
        if (v108 == 2) then
            if (v111 and v113 and pcallOk3 and pcallOk4) then
                local v421 = 0
                local v422
                local loadedFunction
                local v424
                local loadedFunction2

                while true do
                    if (v421 == 1) then
                        if (v422 and v424) then
                            local v499 = 0
                            local v500
                            local v422_2
                            local v424_2

                            while true do
                                if (v499 == 1) then
                                    v424_2 = nil

                                    while true do
                                        if (v500 == 0) then
                                            local v543 = 0

                                            while true do
                                                if (v543 == 1) then
                                                    v500 = 1

                                                    break
                                                end
                                                if (v543 == 0) then
                                                    v422_2 = v422()
                                                    v424_2 = v424()
                                                    v543 = 1
                                                end
                                            end
                                        end
                                        if (v500 == 1) then
                                            if (v422_2 and (type(v422_2) == 'table') and v422_2.Init) then
                                                local v553 = 0

                                                while true do
                                                    if (v553 == 0) then
                                                        v422_2:Init(v424_2)

                                                        for v566, v567 in ipairs(v422_2:GetAuraNames())do
                                                            addSection15:AddToggle({
                                                                Name = v567,
                                                                Default = false,
                                                                Flag = 'Aura_' .. string.gsub(v567, ' ', ''),
                                                                Callback = function(
                                                                    v568
                                                                )
                                                                    v422_2:ToggleAura(v567, v568)
                                                                end,
                                                            })
                                                        end

                                                        break
                                                    end
                                                end
                                            else
                                                warn("VANTALITY: \u{43c}\u{43e}\u{434}\u{443}\u{43b}\u{44c} 'AURAS' \u{432}\u{435}\u{440}\u{43d}\u{443}\u{43b} \u{43d}\u{435}\u{43a}\u{43e}\u{440}\u{440}\u{435}\u{43a}\u{442}\u{43d}\u{44b}\u{435} \u{434}\u{430}\u{43d}\u{43d}\u{44b}\u{435}.")
                                            end

                                            break
                                        end
                                    end

                                    break
                                end
                                if (v499 == 0) then
                                    v500 = 0
                                    v422_2 = nil
                                    v499 = 1
                                end
                            end
                        else
                            warn("VANTALITY: \u{41e}\u{448}\u{438}\u{431}\u{43a}\u{430} \u{43a}\u{43e}\u{43c}\u{43f}\u{438}\u{43b}\u{44f}\u{446}\u{438}\u{438} 'AURAS', \u{432}\u{43e}\u{437}\u{43c}\u{43e}\u{436}\u{43d}\u{43e} \u{431}\u{438}\u{442}\u{430}\u{44f} \u{441}\u{441}\u{44b}\u{43b}\u{43a}\u{430}:", loadedFunction or loadedFunction2)
                        end

                        break
                    end
                    if (v421 == 0) then
                        v422, loadedFunction = loadstring(pcallOk3)
                        v424, loadedFunction2 = loadstring(pcallOk4)
                        v421 = 1
                    end
                end
            else
                warn("VANTALITY: \u{41d}\u{435} \u{443}\u{434}\u{430}\u{43b}\u{43e}\u{441}\u{44c} \u{43f}\u{43e}\u{43b}\u{443}\u{447}\u{438}\u{442}\u{44c} \u{434}\u{430}\u{43d}\u{43d}\u{44b}\u{435} 'AURAS' \u{43f}\u{43e} HTTP.")
            end

            break
        end
        if (1 == v108) then
            local v255 = 0

            while true do
                if (v255 == 1) then
                    v108 = 2

                    break
                end
                if (0 == v255) then
                    v111, pcallOk3 = pcall(game.HttpGet, game, v109, true)
                    v113, pcallOk4 = pcall(game.HttpGet, game, v110, true)
                    v255 = 1
                end
            end
        end
    end
end
do
    local v115 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/China_Hat.luau]]
    local pcallOk3, v117 = pcall(game.HttpGet, game, v115, true)

    if (pcallOk3 and v117) then
        local v225 = 0
        local v226
        local loadedFunction

        while true do
            if (v225 == 0) then
                v226, loadedFunction = loadstring(v117)

                if v226 then
                    local v458 = 0
                    local v459
                    local pcallOk4

                    while true do
                        if (v458 == 0) then
                            v459, pcallOk4 = pcall(v226)

                            if not v459 then
                                local v515 = 0

                                while true do
                                    if (v515 == 0) then
                                        warn('HAT ERR:', pcallOk4)

                                        v8.ExecutorChinaHat = nil

                                        break
                                    end
                                end
                            end

                            break
                        end
                    end
                else
                    warn('HAT COMPILE:', loadedFunction)
                end

                break
            end
        end
    else
        warn('HAT DL ERR')
    end

    addSection16:AddToggle({
        Name = 'Enable',
        Default = false,
        Flag = 'ChinaHat_Enabled',
        Callback = function(v196)
            local v197 = 0
            local v198

            while true do
                if (v197 == 0) then
                    v198 = 0

                    while true do
                        if (v198 == 0) then
                            if not v8.ExecutorChinaHat then
                                return
                            end
                            if v196 then
                                v8.ExecutorChinaHat:Enable()
                            else
                                v8.ExecutorChinaHat:Disable()
                            end

                            break
                        end
                    end

                    break
                end
            end
        end,
    })
    addSection16:AddToggle({
        Name = 'Lite Mode (Cone)',
        Default = false,
        Flag = 'ChinaHat_Lite',
        Callback = function(v199)
            if not v8.ExecutorChinaHat then
                return
            end
            if v199 then
                v8.ExecutorChinaHat:SetHatMode('Cone')
            else
                v8.ExecutorChinaHat:SetHatMode('Beam')
            end
        end,
    })
    addSection16:AddColorPicker({
        Name = 'Color',
        Default = Color3.fromRGB(255, 255, 255),
        Flag = 'ChinaHat_Color',
        Callback = function(v200)
            if v8.ExecutorChinaHat then
                v8.ExecutorChinaHat:UpdateSetting('Color', v200)
            end
        end,
    })
    addSection16:AddSlider({
        Name = 'Transparency',
        Default = 0,
        Range = {0, 1},
        Precise = 2,
        Flag = 'ChinaHat_Transparency',
        Callback = function(v201)
            if v8.ExecutorChinaHat then
                v8.ExecutorChinaHat:UpdateSetting('Transparency', v201)
            end
        end,
    })
end
do
    local v118 = 0
    local v119
    local v120
    local pcallOk3

    while true do
        if (v118 == 0) then
            v119 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/korblox_headless.luau]]
            v120, pcallOk3 = pcall(game.HttpGet, game, v119, true)
            v118 = 1
        end
        if (v118 == 2) then
            addSection17:AddToggle({
                Name = 'Fake Korblox',
                Default = false,
                Flag = 'Visuals_Korblox',
                Callback = function(v354)
                    if v8.ExecutorFakeVisuals then
                        v8.ExecutorFakeVisuals:SetKorblox(v354)
                    end
                end,
            })

            break
        end
        if (v118 == 1) then
            if (v120 and pcallOk3) then
                local v426 = 0
                local v427
                local loadedFunction

                while true do
                    if (v426 == 0) then
                        v427, loadedFunction = loadstring(pcallOk3)

                        if v427 then
                            local v503 = 0
                            local v504
                            local pcallOk4

                            while true do
                                if (v503 == 0) then
                                    v504, pcallOk4 = pcall(v427)

                                    if not v504 then
                                        local v536 = 0
                                        local v537

                                        while true do
                                            if (0 == v536) then
                                                v537 = 0

                                                while true do
                                                    if (v537 == 0) then
                                                        warn('VISUALS ERR:', pcallOk4)

                                                        v8.ExecutorFakeVisuals = nil

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
                        else
                            warn('VISUALS COMPILE:', loadedFunction)
                        end

                        break
                    end
                end
            else
                warn('VISUALS DL ERR')
            end

            addSection17:AddToggle({
                Name = 'Fake Headless',
                Default = false,
                Flag = 'Visuals_Headless',
                Callback = function(v355)
                    if v8.ExecutorFakeVisuals then
                        v8.ExecutorFakeVisuals:SetHeadless(v355)
                    end
                end,
            })

            v118 = 2
        end
    end
end

local addSection18 = addMenu5:AddSection({
    Position = 'left',
    Name = 'MENU SETTINGS',
})
local addSection19 = addMenu5:AddSection({
    Position = 'left',
    Name = 'ALT-TAB BLUR',
})
local addSection20 = addMenu5:AddSection({
    Position = 'center',
    Name = 'OVERLAY',
})
local addSection21 = addMenu5:AddSection({
    Position = 'center',
    Name = 'KEYSTROKES',
})
local addSection22 = addMenu5:AddSection({
    Position = 'right',
    Name = 'SERVER',
})
local addSection23 = addMenu5:AddSection({
    Position = 'right',
    Name = 'PLAYER',
})
local addSection24 = addMenu5:AddSection({
    Position = 'right',
    Name = 'CORE',
})
local addSection25 = addMenu5:AddSection({
    Position = 'right',
    Name = 'SERVER HOP',
})
local addSection26 = addMenu5:AddSection({
    Position = 'right',
    Name = 'JOIN BY JOB ID',
})

addMenu5:AddColumnTitle({
    Text = 'MENU',
    Position = 'left',
})
addMenu5:AddColumnTitle({
    Text = 'HUD',
    Position = 'center',
})
addMenu5:AddColumnTitle({
    Text = 'OTHER',
    Position = 'right',
})

do
    local v122 = 0
    local userInputService
    local touchEnabled
    local v125

    while true do
        if (v122 == 3) then
            addSection18:AddKeybind({
                Name = 'Toggle Key',
                Default = Enum.KeyCode.Home,
                Flag = 'UI_Keybind',
                Callback = function(v356)
                    new:SetKeybind(v356)
                end,
            })

            break
        end
        if (v122 == 1) then
            v125 = (touchEnabled and '60') or '100'

            addSection18:AddDropdown({
                Name = 'UI Theme',
                Values = v18:GetThemeNames(),
                Default = 'Fatality (Default)',
                Flag = 'UI_Theme',
                Callback = function(v357)
                    v18:Apply(v10, v357)
                end,
            })

            v122 = 2
        end
        if (0 == v122) then
            local v256 = 0

            while true do
                if (v256 == 0) then
                    userInputService = game:GetService('UserInputService')
                    touchEnabled = userInputService.TouchEnabled
                    v256 = 1
                end
                if (v256 == 1) then
                    v122 = 1

                    break
                end
            end
        end
        if (v122 == 2) then
            addSection18:AddDropdown({
                Name = 'Menu Size',
                Default = '100',
                Values = {
                    '60',
                    '65',
                    '75',
                    '100',
                    '125',
                    '150',
                },
                Multi = false,
                Flag = 'UI_Scale',
                Callback = function(v358)
                    local v359 = 0
                    local toNumber

                    while true do
                        if (v359 == 0) then
                            toNumber = tonumber(v358)

                            if toNumber then
                                new:SetScale(toNumber)
                            end

                            break
                        end
                    end
                end,
            })

            if touchEnabled then
                new:SetScale(60)
            end

            v122 = 3
        end
    end
end
do
    local v126 = 0
    local v127
    local v128
    local pcallOk3

    while true do
        if (0 == v126) then
            local v257 = 0

            while true do
                if (1 == v257) then
                    v126 = 1

                    break
                end
                if (v257 == 0) then
                    v127 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/AT_blur.luau]]
                    v128, pcallOk3 = pcall(game.HttpGet, game, v127, true)
                    v257 = 1
                end
            end
        end
        if (v126 == 2) then
            addSection19:AddSlider({
                Name = 'Strength',
                Default = 14,
                Range = {0, 52},
                Precise = 0,
                Flag = 'AltTabBlur_Strength',
                Callback = function(v361)
                    if v8.ExecutorAltTabBlur then
                        v8.ExecutorAltTabBlur:UpdateSetting('AltTabBlurAmount', math.floor(v361 + 0.5))
                    end
                end,
            })
            addSection19:AddSlider({
                Name = 'Transition',
                Default = 4,
                Range = {1, 30},
                Precise = 0,
                Flag = 'AltTabBlur_Transition',
                Callback = function(v362)
                    if v8.ExecutorAltTabBlur then
                        v8.ExecutorAltTabBlur:UpdateSetting('AltTabTransitionSpeed', v362)
                    end
                end,
            })

            break
        end
        if (v126 == 1) then
            if (v128 and pcallOk3) then
                local v429 = 0
                local v430
                local loadedFunction

                while true do
                    if (0 == v429) then
                        v430, loadedFunction = loadstring(pcallOk3)

                        if v430 then
                            local v506 = 0
                            local v507
                            local v508
                            local pcallOk4

                            while true do
                                if (v506 == 1) then
                                    pcallOk4 = nil

                                    while true do
                                        if (0 == v507) then
                                            v508, pcallOk4 = pcall(v430)

                                            if not v508 then
                                                local v554 = 0
                                                local v555

                                                while true do
                                                    if (v554 == 0) then
                                                        v555 = 0

                                                        while true do
                                                            if (v555 == 0) then
                                                                warn('\u{43e}\u{448}\u{438}\u{431}\u{43a}\u{430} alt-tab blur:', pcallOk4)

                                                                v8.ExecutorAltTabBlur = nil

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
                                if (v506 == 0) then
                                    v507 = 0
                                    v508 = nil
                                    v506 = 1
                                end
                            end
                        else
                            warn('ATB COMPILE:', loadedFunction)
                        end

                        break
                    end
                end
            else
                warn('ATB DL ERR')
            end

            addSection19:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'AltTabBlur_Enabled',
                Callback = function(v363)
                    local v364 = 0

                    while true do
                        if (v364 == 0) then
                            if not v8.ExecutorAltTabBlur then
                                return
                            end
                            if v363 then
                                v8.ExecutorAltTabBlur:Enable()
                            else
                                v8.ExecutorAltTabBlur:Disable()
                            end

                            break
                        end
                    end
                end,
            })

            v126 = 2
        end
    end
end
do
    local v130 = 0
    local v131
    local v132
    local pcallOk3

    while true do
        if (v130 == 3) then
            addSection20:AddDropdown({
                Name = 'Position',
                Default = 'TopLeft',
                Values = {
                    'TopLeft',
                    'TopRight',
                    'BottomLeft',
                    'BottomRight',
                },
                Flag = 'Overlay_Position',
                Callback = function(v365)
                    if v8.ExecutorOverlay then
                        v8.ExecutorOverlay:UpdateSetting('Position', v365)
                    end
                end,
            })
            addSection20:AddSlider({
                Name = 'Scale',
                Default = 24,
                Range = {10, 60},
                Precise = 0,
                Flag = 'Overlay_Scale',
                Callback = function(v366)
                    if v8.ExecutorOverlay then
                        v8.ExecutorOverlay:UpdateSetting('Scale', v366)
                    end
                end,
            })

            v130 = 4
        end
        if (1 == v130) then
            if (v132 and pcallOk3) then
                local v432 = 0
                local v433
                local v434
                local loadedFunction

                while true do
                    if (v432 == 1) then
                        loadedFunction = nil

                        while true do
                            if (v433 == 0) then
                                v434, loadedFunction = loadstring(pcallOk3)

                                if v434 then
                                    local v519 = 0
                                    local v520
                                    local pcallOk4

                                    while true do
                                        if (v519 == 0) then
                                            v520, pcallOk4 = pcall(v434)

                                            if not v520 then
                                                local v556 = 0

                                                while true do
                                                    if (0 == v556) then
                                                        warn('OVERLAY ERR:', pcallOk4)

                                                        v8.ExecutorOverlay = nil

                                                        break
                                                    end
                                                end
                                            end

                                            break
                                        end
                                    end
                                else
                                    warn('OVERLAY COMPILE:', loadedFunction)
                                end

                                break
                            end
                        end

                        break
                    end
                    if (0 == v432) then
                        v433 = 0
                        v434 = nil
                        v432 = 1
                    end
                end
            else
                warn('OVERLAY DL ERR')
            end

            addSection20:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'Overlay_Enabled',
                Callback = function(v367)
                    local v368 = 0

                    while true do
                        if (v368 == 0) then
                            if not v8.ExecutorOverlay then
                                return
                            end
                            if v367 then
                                v8.ExecutorOverlay:Enable()
                            else
                                v8.ExecutorOverlay:Disable()
                            end

                            break
                        end
                    end
                end,
            })

            v130 = 2
        end
        if (0 == v130) then
            local v258 = 0

            while true do
                if (v258 == 1) then
                    v130 = 1

                    break
                end
                if (v258 == 0) then
                    v131 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/OVERLAY.luau]]
                    v132, pcallOk3 = pcall(game.HttpGet, game, v131, true)
                    v258 = 1
                end
            end
        end
        if (v130 == 4) then
            addSection20:AddColorPicker({
                Name = 'Text Color',
                Default = Color3.fromRGB(255, 255, 255),
                Flag = 'Overlay_Color',
                Callback = function(v369)
                    if v8.ExecutorOverlay then
                        v8.ExecutorOverlay:UpdateSetting('TextColor', v369)
                    end
                end,
            })

            break
        end
        if (v130 == 2) then
            addSection20:AddToggle({
                Name = 'Show FPS',
                Default = true,
                Flag = 'Overlay_ShowFPS',
                Callback = function(v370)
                    if v8.ExecutorOverlay then
                        v8.ExecutorOverlay:UpdateSetting('ShowFPS', v370)
                    end
                end,
            })
            addSection20:AddToggle({
                Name = 'Show Ping',
                Default = false,
                Flag = 'Overlay_ShowPing',
                Callback = function(v371)
                    if v8.ExecutorOverlay then
                        v8.ExecutorOverlay:UpdateSetting('ShowPing', v371)
                    end
                end,
            })

            v130 = 3
        end
    end
end
do
    local v134 = 0
    local v135
    local v136
    local pcallOk3
    local disable
    local v139
    local v383
    local v385
    local v380
    local color3_2

    while true do
        if (v134 == 1) then
            disable = addSection21:AddToggle({
                Name = 'Enable',
                Default = false,
                Flag = 'KS_Enabled',
                Option = true,
                OnlyPC = true,
                Callback = function(v372)
                    local v373 = 0

                    while true do
                        if (0 == v373) then
                            if not v8.ExecutorKeystrokes then
                                return
                            end
                            if v372 then
                                v8.ExecutorKeystrokes:Enable()
                            else
                                v8.ExecutorKeystrokes:Disable()
                            end

                            break
                        end
                    end
                end,
            })
            v139 = {
                '1',
                '2',
                '3',
                '4',
                'Q',
                'W',
                'A',
                'S',
                'D',
                'F',
                'SPACE',
                'M1',
            }

            for v374, v375 in ipairs(v139)do
                disable.Option:AddToggle({
                    Name = v375,
                    Default = true,
                    Flag = 'KS_Show_' .. v375,
                    OnlyPC = true,
                    Callback = function(v436)
                        if v8.ExecutorKeystrokes then
                            v8.ExecutorKeystrokes:UpdateKeyVisibility(v375, v436)
                        end
                    end,
                })
            end

            v134 = 2
        end
        if (v134 == 6) then
            addSection21:AddSlider({
                Name = 'Scale',
                Default = 1,
                Range = {0.5, 2},
                Precise = 2,
                Flag = 'KS_Scale',
                OnlyPC = true,
                Callback = function(v376)
                    if v8.ExecutorKeystrokes then
                        v8.ExecutorKeystrokes:UpdateSetting('Scale', v376)
                    end
                end,
            })
            addSection21:AddSlider({
                Name = 'Fade Speed',
                Default = 0.3,
                Range = {0.1, 1},
                Precise = 2,
                Flag = 'KS_FadeSpeed',
                OnlyPC = true,
                Callback = function(v377)
                    if v8.ExecutorKeystrokes then
                        v8.ExecutorKeystrokes:UpdateSetting('FadeSpeed', v377)
                    end
                end,
            })

            break
        end
        if (v134 == 3) then
            local v259 = 0

            while true do
                if (v259 == 0) then
                    color3_2 = Color3.fromRGB(255, 255, 255)
                    v8.Vantality_KS_Sync = true
                    v259 = 1
                end
                if (v259 == 1) then
                    addSection21:AddToggle({
                        Name = 'Sync with UI Theme',
                        Default = true,
                        Flag = 'KS_SyncTheme',
                        OnlyPC = true,
                        Callback = function(v461)
                            local v462 = 0

                            while true do
                                if (v462 == 0) then
                                    v8.Vantality_KS_Sync = v461

                                    if v8.ExecutorKeystrokes then
                                        if v461 then
                                            local v527 = 0

                                            while true do
                                                if (v527 == 0) then
                                                    v8.ExecutorKeystrokes:UpdateSetting('IdleColor', v10:GetColor('Container'))
                                                    v8.ExecutorKeystrokes:UpdateSetting('PressedColor', v10:GetColor('Main'))

                                                    v527 = 1
                                                end
                                                if (v527 == 1) then
                                                    v8.ExecutorKeystrokes:UpdateSetting('TextColor', v10:GetColor('Text'))
                                                    v8.ExecutorKeystrokes:UpdateSetting('StrokeColor', v10:GetColor('Stroke'))

                                                    break
                                                end
                                            end
                                        else
                                            v8.ExecutorKeystrokes:UpdateSetting('IdleColor', v383)
                                            v8.ExecutorKeystrokes:UpdateSetting('PressedColor', v385)
                                            v8.ExecutorKeystrokes:UpdateSetting('StrokeColor', v380)
                                            v8.ExecutorKeystrokes:UpdateSetting('TextColor', color3_2)
                                        end
                                    end

                                    break
                                end
                            end
                        end,
                    })

                    v134 = 4

                    break
                end
            end
        end
        if (v134 == 5) then
            addSection21:AddColorPicker({
                Name = 'Text Color',
                Default = color3_2,
                Flag = 'KS_TextColor',
                OnlyPC = true,
                Callback = function(v378)
                    local v379 = 0

                    while true do
                        if (v379 == 0) then
                            color3_2 = v378

                            if (not v8.Vantality_KS_Sync and v8.ExecutorKeystrokes) then
                                v8.ExecutorKeystrokes:UpdateSetting('TextColor', v378)
                            end

                            break
                        end
                    end
                end,
            })
            addSection21:AddColorPicker({
                Name = 'Stroke Color',
                Default = v380,
                Flag = 'KS_StrokeColor',
                OnlyPC = true,
                Callback = function(v380)
                    local v381 = 0

                    while true do
                        if (v381 == 0) then
                            v380 = v380

                            if (not v8.Vantality_KS_Sync and v8.ExecutorKeystrokes) then
                                v8.ExecutorKeystrokes:UpdateSetting('StrokeColor', v380)
                            end

                            break
                        end
                    end
                end,
            })
            addSection21:AddDropdown({
                Name = 'Position',
                Default = 'BottomLeft',
                Values = {
                    'TopLeft',
                    'TopRight',
                    'TopCenter',
                    'BottomLeft',
                    'BottomRight',
                },
                Flag = 'KS_Position',
                OnlyPC = true,
                Callback = function(v382)
                    if v8.ExecutorKeystrokes then
                        v8.ExecutorKeystrokes:UpdateSetting('Position', v382)
                    end
                end,
            })

            v134 = 6
        end
        if (v134 == 0) then
            local v260 = 0

            while true do
                if (v260 == 0) then
                    v135 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/Keystrokes]]
                    v136, pcallOk3 = pcall(game.HttpGet, game, v135, true)
                    v260 = 1
                end
                if (v260 == 1) then
                    if (v136 and pcallOk3) then
                        local v473 = 0
                        local v474
                        local loadedFunction

                        while true do
                            if (v473 == 0) then
                                v474, loadedFunction = loadstring(pcallOk3)

                                if v474 then
                                    local v522 = 0
                                    local v523
                                    local pcallOk4

                                    while true do
                                        if (v522 == 0) then
                                            v523, pcallOk4 = pcall(v474)

                                            if not v523 then
                                                local v557 = 0

                                                while true do
                                                    if (v557 == 0) then
                                                        warn('KEYSTROKES ERR:', pcallOk4)

                                                        v8.ExecutorKeystrokes = nil

                                                        break
                                                    end
                                                end
                                            end

                                            break
                                        end
                                    end
                                else
                                    warn('KEYSTROKES COMPILE:', loadedFunction)
                                end

                                break
                            end
                        end
                    else
                        warn('KEYSTROKES DL ERR')
                    end

                    v134 = 1

                    break
                end
            end
        end
        if (v134 == 4) then
            v10.ThemeEvent.Event:Connect(function()
                if (v8.Vantality_KS_Sync and v8.ExecutorKeystrokes) then
                    local v445 = 0

                    while true do
                        if (v445 == 1) then
                            v8.ExecutorKeystrokes:UpdateSetting('TextColor', v10:GetColor('Text'))
                            v8.ExecutorKeystrokes:UpdateSetting('StrokeColor', v10:GetColor('Stroke'))

                            break
                        end
                        if (v445 == 0) then
                            v8.ExecutorKeystrokes:UpdateSetting('IdleColor', v10:GetColor('Container'))
                            v8.ExecutorKeystrokes:UpdateSetting('PressedColor', v10:GetColor('Main'))

                            v445 = 1
                        end
                    end
                end
            end)
            addSection21:AddColorPicker({
                Name = 'Idle Color',
                Default = v383,
                Flag = 'KS_IdleColor',
                OnlyPC = true,
                Callback = function(v383)
                    local v384 = 0

                    while true do
                        if (v384 == 0) then
                            v383 = v383

                            if (not v8.Vantality_KS_Sync and v8.ExecutorKeystrokes) then
                                v8.ExecutorKeystrokes:UpdateSetting('IdleColor', v383)
                            end

                            break
                        end
                    end
                end,
            })
            addSection21:AddColorPicker({
                Name = 'Pressed Color',
                Default = v385,
                Flag = 'KS_PressedColor',
                OnlyPC = true,
                Callback = function(v385)
                    local v386 = 0

                    while true do
                        if (0 == v386) then
                            v385 = v385

                            if (not v8.Vantality_KS_Sync and v8.ExecutorKeystrokes) then
                                v8.ExecutorKeystrokes:UpdateSetting('PressedColor', v385)
                            end

                            break
                        end
                    end
                end,
            })

            v134 = 5
        end
        if (v134 == 2) then
            v383 = Color3.fromRGB(24, 24, 24)
            v385 = Color3.fromRGB(255, 106, 133)
            v380 = Color3.fromRGB(29, 29, 29)
            v134 = 3
        end
    end
end
do
    local marketplaceService = game:GetService('MarketplaceService')
    local teleportService = game:GetService('TeleportService')
    local httpService = game:GetService('HttpService')
    local guiService = game:GetService('GuiService')
    local stats = game:GetService('Stats')
    local players = game:GetService('Players')
    local localPlayer = players.LocalPlayer
    local v151 = 
[[task.spawn(function()pcall(function()local ts=game:GetService("TeleportService")if ts:GetTeleportSetting("Vantality_Teleport_Flag")==true then
    ts:SetTeleportSetting("Vantality_Teleport_Flag", false)loadstring(game:HttpGet("https://pastebin.com/raw/BeQktd9u"))()end
  end
  )end
  )]]

    v8.VantalityTeleportQueued = v8.VantalityTeleportQueued or false

    local v153 = false

    local function v154(v202, v203)
        if setclipboard then
            setclipboard(tostring(v202))
            createNotifier:Notify({
                Title = 'Copied!',
                Content = v203 .. ' saved.',
                Icon = 'clipboard-check',
                Duration = 3,
            })
        else
            createNotifier:Notify({
                Title = 'Error',
                Content = 'Clipboard not supported.',
                Icon = 'alert-circle',
                Duration = 3,
            })
        end
    end
    local function v155()
        local v204 = 0
        local v205

        while true do
            if (v204 == 0) then
                if v8.VantalityTeleportQueued then
                    return
                end

                pcall(function()
                    teleportService:SetTeleportSetting('Vantality_Teleport_Flag', true)
                end)

                v204 = 1
            end
            if (v204 == 1) then
                v205 = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

                if v205 then
                    local v446 = 0

                    while true do
                        if (v446 == 0) then
                            pcall(function()
                                v205(v151)
                            end)

                            v8.VantalityTeleportQueued = true

                            break
                        end
                    end
                end

                break
            end
        end
    end

    local addMetric = addSection22:AddMetric({
        Name = 'Game Name',
        Default = 'Loading...',
    })
    local v157 = ((game.JobId ~= '') and 'Multiplayer') or 'Singleplayer / Studio'

    addSection22:AddMetric({
        Name = 'Server Type',
        Default = v157,
    })

    local addMetric2 = addSection22:AddMetric({
        Name = 'Place ID',
        Default = tostring(game.PlaceId),
        ButtonIcon = 'clipboard-copy',
        Callback = function()
            v154(game.PlaceId, 'Place ID')
        end,
    })
    local addMetric3 = addSection22:AddMetric({
        Name = 'Job ID',
        Default = ((game.JobId ~= '') and 'Click to Copy') or 'Singleplayer',
        ButtonIcon = 'clipboard-copy',
        Callback = function()
            v154(game.JobId, 'Job ID')
        end,
    })
    local addMetric4 = addSection22:AddMetric({
        Name = 'Players',
        Default = '0 / 0',
    })

    task.spawn(function()
        local v206 = 0
        local v207
        local pcallOk3

        while true do
            if (v206 == 0) then
                v207, pcallOk3 = pcall(function()
                    return marketplaceService:GetProductInfo(game.PlaceId)
                end)

                if (v207 and pcallOk3 and pcallOk3.Name) then
                    local len = pcallOk3.Name:sub(1, 24) .. (((pcallOk3.Name:len() > 24) and '...') or '')

                    addMetric:Set(len)
                else
                    addMetric:Set('Unknown Place')
                end

                break
            end
        end
    end)

    local addMetric5 = addSection23:AddMetric({
        Name = 'Account',
        Default = localPlayer.Name,
    })
    local addMetric6 = addSection23:AddMetric({
        Name = 'Account Age',
        Default = tostring(localPlayer.AccountAge) .. ' days',
    })
    local addMetric7 = addSection23:AddMetric({
        Name = 'Playtime',
        Default = '00:00:00',
    })
    local humanoidRootPart = addSection23:AddMetric({
        Name = 'Position',
        Default = '0, 0, 0',
        ButtonIcon = 'clipboard-copy',
        Callback = function()
            if (localPlayer.Character and localPlayer.Character:FindFirstChild('HumanoidRootPart')) then
                local v261 = 0
                local position
                local stringFormat

                while true do
                    if (v261 == 0) then
                        position = localPlayer.Character.HumanoidRootPart.Position
                        stringFormat = string.format('%.1f, %.1f, %.1f', position.X, position.Y, position.Z)
                        v261 = 1
                    end
                    if (v261 == 1) then
                        v154(stringFormat, 'Coordinates')

                        break
                    end
                end
            end
        end,
    })
    local v165 = (identifyexecutor and identifyexecutor()) or 'Unknown Executor'

    addSection24:AddMetric({
        Name = 'Executor',
        Default = v165,
    })

    local addMetric8 = addSection24:AddMetric({
        Name = 'Memory (RAM)',
        Default = '0 MB',
    })
    local addMetric9 = addSection24:AddMetric({
        Name = 'FPS',
        Default = '0',
    })
    local addMetric10 = addSection24:AddMetric({
        Name = 'Ping',
        Default = '0 ms',
    })
    local mathFloor, v170, osClock = 0, 0, os.clock()

    game:GetService('RunService').RenderStepped:Connect(function()
        v170 = v170 + 1

        local osClock2 = os.clock()

        if ((osClock2 - osClock) >= 1) then
            local v264 = 0

            while true do
                if (v264 == 0) then
                    mathFloor = math.floor(v170 / (osClock2 - osClock))
                    v170, osClock = 0, osClock2

                    break
                end
            end
        end
    end)

    v8.VantalityAutoRejoin = false

    addSection25:AddToggle({
        Name = 'Auto-Rejoin on Kick',
        Flag = 'Server_AutoRejoin',
        Callback = function(v210)
            v8.VantalityAutoRejoin = v210
        end,
    })
    guiService.ErrorMessageChanged:Connect(function()
        if v8.VantalityAutoRejoin then
            local v265 = 0

            while true do
                if (v265 == 0) then
                    v155()
                    teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)

                    break
                end
            end
        end
    end)
    addSection25:AddButton({
        Name = 'Rejoin',
        Callback = function()
            local v212 = 0

            while true do
                if (v212 == 1) then
                    createNotifier:Notify({
                        Title = 'Teleporting',
                        Content = 'Rejoining server...',
                        Icon = 'loader',
                        Duration = 3,
                    })
                    v155()

                    v212 = 2
                end
                if (v212 == 2) then
                    teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
                    task.delay(5, function()
                        v153 = false
                    end)

                    break
                end
                if (v212 == 0) then
                    if v153 then
                        return
                    end

                    v153 = true
                    v212 = 1
                end
            end
        end,
    })
    addSection25:AddButton({
        Name = 'Random Server',
        Callback = function()
            if v153 then
                return
            end

            v153 = true

            createNotifier:Notify({
                Title = 'Searching',
                Content = 'Finding new server...',
                Icon = 'search',
                Duration = 3,
            })
            task.spawn(function()
                local v228 = 0
                local v229
                local v230
                local pcallOk3

                while true do
                    if (v228 == 1) then
                        if v230 then
                            local v463 = 0
                            local v464
                            local decoded
                            local v466

                            while true do
                                if (v463 == 0) then
                                    v464 = 0
                                    decoded = nil
                                    v463 = 1
                                end
                                if (1 == v463) then
                                    v466 = nil

                                    while true do
                                        if (v464 == 0) then
                                            decoded = httpService:JSONDecode(pcallOk3)
                                            v466 = {}
                                            v464 = 1
                                        end
                                        if (1 == v464) then
                                            if (decoded and decoded.data) then
                                                for v544, v545 in ipairs(decoded.data)do
                                                    if ((v545.id ~= game.JobId) and (v545.playing < (v545.maxPlayers - 2))) then
                                                        table.insert(v466, v545.id)
                                                    end
                                                end
                                            end
                                            if (#v466 > 0) then
                                                local v538 = 0
                                                local random

                                                while true do
                                                    if (v538 == 0) then
                                                        random = v466[math.random(1, #v466)]

                                                        v155()

                                                        v538 = 1
                                                    end
                                                    if (v538 == 1) then
                                                        teleportService:TeleportToPlaceInstance(game.PlaceId, random, localPlayer)

                                                        break
                                                    end
                                                end
                                            else
                                                local v540 = 0

                                                while true do
                                                    if (v540 == 0) then
                                                        createNotifier:Notify({
                                                            Title = 'Failed',
                                                            Content = 'No valid servers found.',
                                                            Icon = 'alert-circle',
                                                            Duration = 3,
                                                        })

                                                        v153 = false

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
                        else
                            createNotifier:Notify({
                                Title = 'Error',
                                Content = 'Failed to fetch servers.',
                                Icon = 'x',
                                Duration = 3,
                            })

                            v153 = false
                        end

                        break
                    end
                    if (0 == v228) then
                        v229 = 'https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Desc&limit=100'
                        v230, pcallOk3 = pcall(function()
                            return game:HttpGet(v229)
                        end)
                        v228 = 1
                    end
                end
            end)
            task.delay(10, function()
                v153 = false
            end)
        end,
    })
    addSection25:AddButton({
        Name = 'Smallest Server',
        Callback = function()
            if v153 then
                return
            end

            v153 = true

            createNotifier:Notify({
                Title = 'Searching',
                Content = 'Finding empty server...',
                Icon = 'search',
                Duration = 3,
            })
            task.spawn(function()
                local v232 = 0
                local v233
                local v234
                local pcallOk3

                while true do
                    if (0 == v232) then
                        v233 = 'https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'
                        v234, pcallOk3 = pcall(function()
                            return game:HttpGet(v233)
                        end)
                        v232 = 1
                    end
                    if (1 == v232) then
                        if v234 then
                            local v467 = 0
                            local decoded

                            while true do
                                if (v467 == 0) then
                                    decoded = httpService:JSONDecode(pcallOk3)

                                    if (decoded and decoded.data) then
                                        for v525, v526 in ipairs(decoded.data)do
                                            if ((v526.id ~= game.JobId) and (v526.playing > 0) and (v526.playing < v526.maxPlayers)) then
                                                local v541 = 0
                                                local v542

                                                while true do
                                                    if (v541 == 0) then
                                                        v542 = 0

                                                        while true do
                                                            local v559 = 0

                                                            while true do
                                                                if (v559 == 0) then
                                                                    if (v542 == 0) then
                                                                        v155()
                                                                        teleportService:TeleportToPlaceInstance(game.PlaceId, v526.id, localPlayer)

                                                                        v542 = 1
                                                                    end
                                                                    if (1 == v542) then
                                                                        task.delay(5, function(
                                                                        )
                                                                            v153 = false
                                                                        end)

                                                                        return
                                                                    end

                                                                    break
                                                                end
                                                            end
                                                        end

                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    v467 = 1
                                end
                                if (v467 == 1) then
                                    createNotifier:Notify({
                                        Title = 'Failed',
                                        Content = 'No small servers found.',
                                        Icon = 'alert-circle',
                                        Duration = 3,
                                    })

                                    v153 = false

                                    break
                                end
                            end
                        else
                            local v469 = 0
                            local v470

                            while true do
                                if (v469 == 0) then
                                    v470 = 0

                                    while true do
                                        if (v470 == 0) then
                                            createNotifier:Notify({
                                                Title = 'Error',
                                                Content = 'Failed to fetch servers.',
                                                Icon = 'x',
                                                Duration = 3,
                                            })

                                            v153 = false

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
            end)
        end,
    })
    addSection25:AddButton({
        Name = 'Leave',
        Risky = true,
        Callback = function()
            localPlayer:Kick('Disconnected by Vantality')
        end,
    })

    local v213 = ''

    addSection26:AddInput({
        Name = 'Target Job ID',
        PlaceholderText = 'Job ID here',
        Callback = function(v213)
            v213 = v213
        end,
    })
    addSection26:AddButton({
        Name = 'Join',
        Callback = function()
            local v214 = 0

            while true do
                if (0 == v214) then
                    if v153 then
                        return
                    end
                    if (v213 and (v213 ~= '') and (v213:len() > 10)) then
                        local v449 = 0

                        while true do
                            if (v449 == 2) then
                                task.delay(5, function()
                                    v153 = false
                                end)

                                break
                            end
                            if (0 == v449) then
                                v153 = true

                                createNotifier:Notify({
                                    Title = 'Teleporting',
                                    Content = 'Joining target server...',
                                    Icon = 'loader',
                                    Duration = 3,
                                })

                                v449 = 1
                            end
                            if (v449 == 1) then
                                v155()
                                teleportService:TeleportToPlaceInstance(game.PlaceId, v213, localPlayer)

                                v449 = 2
                            end
                        end
                    else
                        createNotifier:Notify({
                            Title = 'Error',
                            Content = 'Invalid Job ID.',
                            Icon = 'x',
                            Duration = 3,
                        })
                    end

                    break
                end
            end
        end,
    })
    task.spawn(function()
        while task.wait(0.5) do
            if not v8.ahkgbs_instance then
                break
            end

            local mathFloor2 = math.floor(workspace.DistributedGameTime)
            local mathFloor3 = math.floor(mathFloor2 / 3600)
            local mathFloor4 = math.floor((mathFloor2 % 3600) / 60)
            local v239 = mathFloor2 % 60

            addMetric7:Set(string.format('%02d:%02d:%02d', mathFloor3, mathFloor4, v239))
            addMetric4:Set(tostring(#players:GetPlayers()) .. ' / ' .. tostring(players.MaxPlayers))

            local character = localPlayer.Character

            if character then
                local v387 = 0
                local humanoidRootPart2

                while true do
                    if (0 == v387) then
                        humanoidRootPart2 = character:FindFirstChild('HumanoidRootPart')

                        if humanoidRootPart2 then
                            humanoidRootPart:Set(string.format('%.1f, %.1f, %.1f', humanoidRootPart2.Position.X, humanoidRootPart2.Position.Y, humanoidRootPart2.Position.Z))
                        else
                            humanoidRootPart:Set('Dead / No HRP')
                        end

                        break
                    end
                end
            else
                humanoidRootPart:Set('Dead')
            end

            local mathFloor5 = math.floor(stats:GetTotalMemoryUsageMb())

            addMetric8:Set(tostring(mathFloor5) .. ' MB')
            addMetric9:Set(tostring(mathFloor))

            local mathFloor6 = 0

            pcall(function()
                mathFloor6 = math.floor(stats.Network.ServerStatsItem['Data Ping']:GetValue())
            end)
            addMetric10:Set(tostring(mathFloor6) .. ' ms')
        end
    end)
end

if addMenu6 then
    do
        local v243 = 0
        local v244
        local v245
        local pcallOk3

        while true do
            if (v243 == 0) then
                v244 = 
[[https://raw.githubusercontent.com/grab1s/VANTALITY/refs/heads/main/main/LuauAPI]]
                v245, pcallOk3 = pcall(function()
                    return loadstring(game:HttpGet(v244))()
                end)
                v243 = 1
            end
            if (v243 == 1) then
                if (v245 and v8.LuauAPI) then
                    v8.LuauAPI:Init(addMenu6, nil, createNotifier)
                else
                    warn('\u{41e}\u{428}\u{418}\u{411}\u{41a}\u{410}: \u{41d}\u{415} \u{423}\u{414}\u{410}\u{41b}\u{41e}\u{421}\u{42c} \u{417}\u{410}\u{413}\u{420}\u{423}\u{417}\u{418}\u{422}\u{42c} LUAU API', pcallOk3)

                    local addSection27 = addMenu6:AddSection({
                        Position = 'left',
                        Name = 'ERROR',
                    })

                    addSection27:AddButton({
                        Name = '\u{41e}\u{428}\u{418}\u{411}\u{41a}\u{410} LUAU API',
                        Callback = function() end,
                    })
                end

                break
            end
        end
    end
end

task.wait(0.2)
loader:Finish()
task.wait(0.1)
new:SetVisible(true)
new:AddInfo(function()
    createNotifier:Notify({
        Title = 'INFO',
        Content = 'Project: AHK-GBS',
        Duration = 5,
        Icon = 'info',
    })
end)
createNotifier:Notify({
    Title = 'Ready',
    Content = 'Vantality loaded!',
    Icon = 'check',
    Duration = 3,
})

if not v10.IsPC then
    local v215 = 0
    local screenGui
    local getButton

    while true do
        if (v215 == 2) then
            getButton = new:GetButton()
            getButton.Parent = screenGui
            v215 = 3
        end
        if (v215 == 3) then
            getButton.Position = UDim2.new(0.5, -25, 0, 5)
            getButton.Size = UDim2.new(0, 50, 0, 50)

            break
        end
        if (v215 == 1) then
            screenGui.Parent = (gethui and gethui()) or game:GetService('CoreGui')
            v8.VantalityMobileGui = screenGui
            v215 = 2
        end
        if (v215 == 0) then
            local v394 = 0

            while true do
                if (v394 == 0) then
                    screenGui = Instance.new('ScreenGui')
                    screenGui.Name = 'VantalityMobile'
                    v394 = 1
                end
                if (v394 == 1) then
                    v215 = 1

                    break
                end
            end
        end
    end
end
