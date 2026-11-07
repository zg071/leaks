local Env = getgenv and getgenv() or _G

local ThemeManager = {}

local Themes = {
    ["Fatality"] = {
        Main       = Color3.fromRGB(255, 106, 133), 
        Background = Color3.fromRGB(19, 19, 19),    
        Container  = Color3.fromRGB(24, 24, 24),    
        Element    = Color3.fromRGB(16, 16, 16),
        Text       = Color3.fromRGB(255, 255, 255),
        TextDark   = Color3.fromRGB(150, 150, 150),
        Stroke     = Color3.fromRGB(29, 29, 29),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
        ["Nord"] = {
        Main       = Color3.fromRGB(136, 192, 208), 
        Background = Color3.fromRGB(46, 52, 64),    
        Container  = Color3.fromRGB(59, 66, 82),    
        Element    = Color3.fromRGB(43, 48, 59),
        Text       = Color3.fromRGB(236, 239, 244),
        TextDark   = Color3.fromRGB(153, 161, 175),
        Stroke     = Color3.fromRGB(76, 86, 106),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
        ["Dracula"] = {
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(189, 147, 249)), 
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 121, 198))
        },
        Background = Color3.fromRGB(40, 42, 54),    
        Container  = Color3.fromRGB(68, 71, 90),    
        Element    = Color3.fromRGB(33, 34, 44),
        Text       = Color3.fromRGB(248, 248, 242),
        TextDark   = Color3.fromRGB(139, 142, 168),
        Stroke     = Color3.fromRGB(98, 114, 164),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
        ["Rose Pine"] = {
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(235, 188, 186)), 
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(196, 167, 231))
        },
        Background = Color3.fromRGB(25, 23, 36),    
        Container  = Color3.fromRGB(31, 29, 46),    
        Element    = Color3.fromRGB(20, 18, 28),
        Text       = Color3.fromRGB(224, 222, 244),
        TextDark   = Color3.fromRGB(144, 140, 170),
        Stroke     = Color3.fromRGB(38, 35, 58),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
        ["Tokyo Night"] = {
        Main       = Color3.fromRGB(122, 162, 247), 
        Background = Color3.fromRGB(26, 27, 38),    
        Container  = Color3.fromRGB(36, 40, 59),    
        Element    = Color3.fromRGB(22, 22, 30),
        Text       = Color3.fromRGB(192, 202, 245),
        TextDark   = Color3.fromRGB(86, 95, 137),
        Stroke     = Color3.fromRGB(41, 46, 66),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
        ["Mocha"] = {
        Main       = Color3.fromRGB(210, 160, 110), 
        Background = Color3.fromRGB(30, 27, 24),    
        Container  = Color3.fromRGB(42, 38, 34),    
        Element    = Color3.fromRGB(25, 22, 20),
        Text       = Color3.fromRGB(235, 225, 215),
        TextDark   = Color3.fromRGB(160, 145, 130),
        Stroke     = Color3.fromRGB(54, 49, 44),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
        ["Matcha"] = {
        Main       = Color3.fromRGB(140, 190, 140), 
        Background = Color3.fromRGB(22, 24, 22),    
        Container  = Color3.fromRGB(32, 36, 32),    
        Element    = Color3.fromRGB(18, 20, 18),
        Text       = Color3.fromRGB(225, 235, 225),
        TextDark   = Color3.fromRGB(130, 150, 130),
        Stroke     = Color3.fromRGB(45, 50, 45),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Ocean Depth"] = {
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(80, 170, 200)), 
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(40, 120, 180))
        },
        Background = Color3.fromRGB(15, 23, 30),    
        Container  = Color3.fromRGB(25, 35, 45),    
        Element    = Color3.fromRGB(10, 18, 24),
        Text       = Color3.fromRGB(210, 230, 245),
        TextDark   = Color3.fromRGB(110, 135, 155),
        Stroke     = Color3.fromRGB(40, 55, 70),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Graphite"] = {
        Main       = Color3.fromRGB(220, 220, 220), 
        Background = Color3.fromRGB(18, 18, 18),    
        Container  = Color3.fromRGB(26, 26, 26),    
        Element    = Color3.fromRGB(14, 14, 14),
        Text       = Color3.fromRGB(240, 240, 240),
        TextDark   = Color3.fromRGB(120, 120, 120),
        Stroke     = Color3.fromRGB(38, 38, 38),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Amethyst"] = {
        Main       = Color3.fromRGB(170, 130, 220), 
        Background = Color3.fromRGB(16, 12, 20),    
        Container  = Color3.fromRGB(24, 18, 30),    
        Element    = Color3.fromRGB(12, 9, 15),
        Text       = Color3.fromRGB(230, 220, 240),
        TextDark   = Color3.fromRGB(130, 110, 150),
        Stroke     = Color3.fromRGB(36, 28, 45),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Christmas"] = {
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 45, 85)), 
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 255, 120))
        }, 
        Background = Color3.fromRGB(13, 15, 20),    
        Container  = Color3.fromRGB(20, 24, 30),    
        Element    = Color3.fromRGB(10, 12, 16),    
        Text       = Color3.fromRGB(240, 245, 255),
        TextDark   = Color3.fromRGB(100, 110, 130),
        Stroke     = Color3.fromRGB(40, 50, 60),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Discord"] = {
        Main       = Color3.fromRGB(88, 101, 242), 
        Background = Color3.fromRGB(49, 51, 56),   
        Container  = Color3.fromRGB(43, 45, 49),   
        Element    = Color3.fromRGB(30, 31, 34),   
        Text       = Color3.fromRGB(220, 221, 222),
        TextDark   = Color3.fromRGB(148, 155, 164),
        Stroke     = Color3.fromRGB(30, 31, 34),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Twitch"] = {
        Main       = Color3.fromRGB(145, 70, 255), 
        Background = Color3.fromRGB(24, 24, 27),   
        Container  = Color3.fromRGB(31, 31, 35),   
        Element    = Color3.fromRGB(14, 14, 16),   
        Text       = Color3.fromRGB(239, 239, 241),
        TextDark   = Color3.fromRGB(173, 173, 184),
        Stroke     = Color3.fromRGB(50, 50, 55),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Steam"] = {
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(6, 182, 212)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(59, 130, 246))
        },
        Background = Color3.fromRGB(23, 26, 33),  
        Container  = Color3.fromRGB(34, 43, 53),   
        Element    = Color3.fromRGB(16, 21, 25),   
        Text       = Color3.fromRGB(197, 195, 192),
        TextDark   = Color3.fromRGB(118, 128, 137),
        Stroke     = Color3.fromRGB(60, 70, 80),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Spotify"] = {
        Main       = Color3.fromRGB(29, 185, 84),
        Background = Color3.fromRGB(18, 18, 18),    
        Container  = Color3.fromRGB(33, 33, 33),    
        Element    = Color3.fromRGB(10, 10, 10),    
        Text       = Color3.fromRGB(255, 255, 255),
        TextDark   = Color3.fromRGB(179, 179, 179),
        Stroke     = Color3.fromRGB(45, 45, 45),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Neverlose"] = {
        Main       = Color3.fromRGB(0, 200, 255), 
        Background = Color3.fromRGB(10, 15, 25),    
        Container  = Color3.fromRGB(15, 20, 35),    
        Element    = Color3.fromRGB(5, 10, 20),    
        Text       = Color3.fromRGB(255, 255, 255),
        TextDark   = Color3.fromRGB(100, 130, 150),
        Stroke     = Color3.fromRGB(25, 40, 60),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Skeet"] = {
        Main       = Color3.fromRGB(168, 255, 0), 
        Background = Color3.fromRGB(18, 18, 18),    
        Container  = Color3.fromRGB(28, 28, 28),    
        Element    = Color3.fromRGB(12, 12, 12),    
        Text       = Color3.fromRGB(220, 220, 220),
        TextDark   = Color3.fromRGB(120, 120, 120),
        Stroke     = Color3.fromRGB(45, 45, 45),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Onetap"] = {
        Main       = Color3.fromRGB(219, 166, 73), 
        Background = Color3.fromRGB(26, 26, 26),    
        Container  = Color3.fromRGB(45, 45, 45), 
        Element    = Color3.fromRGB(35, 35, 35),    
        Text       = Color3.fromRGB(230, 230, 230),
        TextDark   = Color3.fromRGB(150, 150, 150),
        Stroke     = Color3.fromRGB(60, 60, 60),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Deep Purple"] = { 
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(140, 0, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(80, 0, 180))
        },
        Background = Color3.fromRGB(10, 8, 15),     
        Container  = Color3.fromRGB(18, 15, 25),    
        Element    = Color3.fromRGB(10, 8, 15),     
        Text       = Color3.fromRGB(240, 230, 255),
        TextDark   = Color3.fromRGB(140, 130, 160),
        Stroke     = Color3.fromRGB(40, 30, 60),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Cherry"] = { 
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 183, 197)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 105, 180))
        },
        Background = Color3.fromRGB(28, 20, 24),    
        Container  = Color3.fromRGB(40, 28, 34),    
        Element    = Color3.fromRGB(24, 16, 20),    
        Text       = Color3.fromRGB(255, 235, 240),
        TextDark   = Color3.fromRGB(180, 140, 150),
        Stroke     = Color3.fromRGB(60, 40, 50),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Midnight"] = { 
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 120, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 200, 255))
        },
        Background = Color3.fromRGB(10, 12, 18),    
        Container  = Color3.fromRGB(18, 22, 32),    
        Element    = Color3.fromRGB(8, 10, 14),     
        Text       = Color3.fromRGB(230, 240, 255),
        TextDark   = Color3.fromRGB(100, 120, 140),
        Stroke     = Color3.fromRGB(30, 45, 65),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Monochrome"] = { 
        Main       = Color3.fromRGB(255, 255, 255), 
        Background = Color3.fromRGB(0, 0, 0),       
        Container  = Color3.fromRGB(20, 20, 20),    
        Element    = Color3.fromRGB(10, 10, 10),    
        Text       = Color3.fromRGB(255, 255, 255),
        TextDark   = Color3.fromRGB(100, 100, 100),
        Stroke     = Color3.fromRGB(40, 40, 40),    
        Outline    = Color3.fromRGB(255, 255, 255), 
    },
    ["Vaporwave"] = { 
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 113, 206)), 
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(1, 205, 254))  
        },
        Background = Color3.fromRGB(24, 18, 38),    
        Container  = Color3.fromRGB(44, 30, 70),    
        Element    = Color3.fromRGB(20, 12, 30),    
        Text       = Color3.fromRGB(255, 255, 255),
        TextDark   = Color3.fromRGB(160, 140, 190),
        Stroke     = Color3.fromRGB(60, 45, 90),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Acid Green"] = {
        Main       = Color3.fromRGB(57, 255, 20),   
        Background = Color3.fromRGB(5, 15, 5),      
        Container  = Color3.fromRGB(10, 25, 10),    
        Element    = Color3.fromRGB(2, 10, 2),      
        Text       = Color3.fromRGB(200, 255, 200),
        TextDark   = Color3.fromRGB(80, 120, 80),
        Stroke     = Color3.fromRGB(30, 80, 30),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    },
    ["Sunset Gold"] = {
        Main       = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 165, 0)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 215, 0))
        },
        Background = Color3.fromRGB(25, 20, 15),    
        Container  = Color3.fromRGB(35, 30, 25),    
        Element    = Color3.fromRGB(15, 12, 10),    
        Text       = Color3.fromRGB(255, 240, 220),
        TextDark   = Color3.fromRGB(160, 140, 120),
        Stroke     = Color3.fromRGB(60, 50, 40),    
        Outline    = Color3.fromRGB(0, 0, 0),    
    }
}

function ThemeManager:GetThemeNames()
    local names = {}
    for name, _ in pairs(Themes) do
        table.insert(names, name)
    end
    table.sort(names) 
    return names
end

function ThemeManager:Apply(Library, ThemeName)
    local data = Themes[ThemeName]
    if data and Library.SetTheme then
        Library:SetTheme(data)
    end
end

return ThemeManager