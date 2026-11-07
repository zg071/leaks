--[[
    Fatality: Marketplace UI
	Modded by: grab1s
    Author: 4lpaca
    Github: https://github.com/4lpaca-pin/Fatality
--]]

export type Window = {
	Name: string,
	Keybind: string | Enum.KeyCode,
	Scale: UDim2,
	Expire: string
}

export type Loader = {
	Name: string,
	Duration: number,
	Scale: number
}

export type Menu = {
	Name: string,
	Icon: string,
	AutoFill: boolean
}

export type Section = {
	Name: string,
	Position: string,
	Height: number,
}

export type Listbox = {
	Name: string,
	Option: boolean,
	Multi: boolean,
	Position: string,
	Flag: string | nil,
	Height: number,
	Default: ValueBase,
	Values: {ValueBase},
	Callback: (values: {ValueBase}) -> any
}

export type Elements = {
	AddToggle: (self,Config: Toggle) -> { Option: Elements },
	AddSlider: (self,Config: Slider) -> { Option: Elements },
	AddButton: (self,Config: Button) -> {},
	AddColorPicker: (self,Config: ColorPicker) -> { Option: Elements },
	AddDropdown: (self,Config: Dropdown) -> { Option: Elements },
	AddKeybind: (self,Config: Keybind) -> { Option: Elements },
}

export type Preview = {
	Position: string,
	Height: number
}

export type Toggle = {
	Name: string,
	Default: boolean,
	Callback: (boolean) -> any,
	Risky: boolean,
	Option: boolean,
	Flag: string | nil,
}

export type Slider = {
    Name: string,
    Default: number,
    Range: {number}, 
    Precise: boolean, 
    Step: number,    
    Type: string,
    Callback: (number) -> any,
    Risky: boolean,
    Flag: string | nil,
    Option: boolean
}

export type Button = {
	Name: string,
	Callback: (number) -> any,
	Risky: boolean,
}

export type ColorPicker = {
	Name: string,
	Default: Color3,
	Transparency: number,
	Callback: (number) -> any,
	Flag: string | nil,
	Option: boolean
}

export type Dropdown = {
	Name: string,
	Default: string | {string},
	Values: {string},
	Callback: (string | {string}) -> any,
	Option: boolean,
	Multi: boolean,
	Flag: string | nil,
	AutoUpdate: boolean
}

export type Keybind = {
	Name: string,
	Default: string | Enum.KeyCode,
	Callback: (string) -> any,
	Flag: string | nil,
	Option: boolean,
}

export type Notify = {
	Title: string,
	Content: string,
	Duration: number,
	Flag: string | nil,
	Icon: string
}

export type Notifier = {
	Notify: (self, Config: Notify) -> nil
}

cloneref = cloneref or function(i) return i; end;
clonefunction = clonefunction or function(...) return ...; end;
hookfunction = hookfunction or function(a,b) return a; end;
getgenv = getgenv or getfenv;
protect_gui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;
getgenv().LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(f) return f end;

if game:GetService('RunService'):IsStudio() then
	local BaseWorkspace = Instance.new('Folder',game:GetService("ReplicatedFirst"));
	BaseWorkspace.Name = "WORKSPACE";

	local __get_path_c = function(path)
		return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
	end
	local __get_path = function(path)
		local main = __get_path_c(path);
		local block = BaseWorkspace;
		for i,v in next , main do
			block = block[v];
		end;
		return block;
	end;

	getgenv().readfile = function(path) return __get_path(path).Value; end;
	getgenv().isfile = function(path)
		local success , message = pcall(function() return __get_path(path); end);
		if success and not message:IsA("Folder") then return true; end;
		return false;
	end;
	getgenv().isfolder = function(path)
		local success , message = pcall(function() return __get_path(path); end);
		if success and message:IsA("Folder") then return true; end;
		return false;
	end;
	getgenv().writefile = function(path,content)
		local main = __get_path_c(path);
		local block = BaseWorkspace;
		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('StringValue',block);
				c.Name = tostring(v);
				c.Value = content;
			else
				if item:IsA('StringValue') and tostring(item) == v then
					item.Name = tostring(v);
					item.Value = content;
				end;
				block = item;
			end;
		end;
	end;
	getgenv().listfiles = function(path)
		local fold = __get_path(path);
		local pa = {};
		for i,v in next , fold:GetChildren() do
			if v:IsA('StringValue') then table.insert(pa,path..'/'..tostring(v)); end;
		end;
		return pa;
	end;
	getgenv().makefolder = function(path)
		local main = __get_path_c(path);
		local block = BaseWorkspace;
		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('Folder',block);
				c.Name = tostring(v);
			else
				block = item;
			end;
		end;
	end;
	getgenv().delfile = function(path)
		local main = __get_path_c(path);
		local block = BaseWorkspace;
		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if item and item:IsA('StringValue') then
				item:Destroy();
			else
				block = item;
			end;
		end;
	end;
end;

local TextService = cloneref(game:GetService('TextService'));
local TweenService = cloneref(game:GetService('TweenService'));
local RunService = cloneref(game:GetService('RunService'));
local Players = cloneref(game:GetService('Players'));
local UserInputService = cloneref(game:GetService('UserInputService'));
local Client = Players.LocalPlayer;
local Mouse = Client:GetMouse();
local CurrentCamera = workspace.CurrentCamera;
local _,CoreGui = xpcall(function() return (gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui"); end,function() return Client.PlayerGui; end);

-- Fatality --
local Fatality = {};
Fatality.Scale = 1
Fatality.Ascii = "qwertyuiopasdfghjklzxcvbnmQWRTYUIOPASDFGHJKLZXCVBNM";
Fatality.GLOBAL_ENVIRONMENT = {};
Fatality.Windows = {};
Fatality.Fonts = {
	Regular = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	Medium = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal),
	SemiBold = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
	Bold = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal),
	Black = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
}
Fatality.FontSemiBold = Fatality.Fonts.SemiBold; 
Fatality.DragBlacklist = {};
Fatality.Version = '1.7 - Theme Engine';
Fatality.ScalesRegistry = {}; 

-- THEME SYSTEM --
Fatality.CurrentTheme = {
	Main       = Color3.fromRGB(255, 106, 133), 
	Background = Color3.fromRGB(19, 19, 19),    
	Container  = Color3.fromRGB(24, 24, 24),    
	Element    = Color3.fromRGB(16, 16, 16),
	Hover      = Color3.fromRGB(25, 25, 25), 
	TabActive  = Color3.fromRGB(44, 44, 44), 
	Black      = Color3.fromRGB(16, 16, 16), 
	Text       = Color3.fromRGB(255, 255, 255),
	TextDark   = Color3.fromRGB(150, 150, 150),
	Stroke     = Color3.fromRGB(29, 29, 29),    
	Outline    = Color3.fromRGB(0, 0, 0),      
};

Fatality.Colors = Fatality.CurrentTheme; 
Fatality.ThemeRegistry = {}; 
Fatality.ThemeEvent = Instance.new("BindableEvent") 

function Fatality:GetColor(Category)
	local val = self.CurrentTheme[Category] or Color3.fromRGB(255, 255, 255)
	if typeof(val) == "ColorSequence" then return val.Keypoints[1].Value end
	return val
end

local function LightenColor(color, amount)
	local h, s, v = color:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(v + amount, 0, 1))
end

function Fatality:Register(Object, Category, Property)
	if not Object then return end
	Property = Property or "BackgroundColor3"
	
	table.insert(Fatality.ThemeRegistry, { Object = Object, Category = Category, Property = Property })
	
	local val = Fatality.CurrentTheme[Category]
	if val then
		if typeof(val) == "ColorSequence" then
			local grad = Object:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", Object)
			grad.Color = val
			Object[Property] = Color3.fromRGB(255,255,255)
		else
			Object[Property] = val
			local grad = Object:FindFirstChildOfClass("UIGradient")
			if grad then grad.Enabled = false end
		end
	end
	
	if Object:IsA("UIStroke") and Category == "Stroke" then
		Object.Transparency = 0.65
	end
end

function Fatality:SetTheme(NewTheme) 
	for i = #Fatality.ThemeRegistry, 1, -1 do
		local item = Fatality.ThemeRegistry[i]
		if not item.Object or not item.Object.Parent then
			table.remove(Fatality.ThemeRegistry, i)
		end
	end

	for key, val in pairs(NewTheme) do
		Fatality.CurrentTheme[key] = val
	end

	if not NewTheme.Hover then Fatality.CurrentTheme.Hover = LightenColor(Fatality:GetColor("Element"), 0.05) end
	if not NewTheme.TabActive then Fatality.CurrentTheme.TabActive = LightenColor(Fatality:GetColor("Container"), 0.08) end

	Fatality.Colors = Fatality.CurrentTheme
	
	local Sequence = { "Background", "Container", "Element", "Stroke", "Outline", "Text", "TextDark", "Main", "Hover", "TabActive" }
	local TS = game:GetService("TweenService")
	
	task.spawn(function()
		for i, phaseCategory in ipairs(Sequence) do
			for _, item in pairs(Fatality.ThemeRegistry) do
				if item.Object and item.Object.Parent and (item.Category == phaseCategory or (phaseCategory == "Container" and (item.Category == "Element" or item.Category == "Stroke"))) then
					local newVal = Fatality.CurrentTheme[item.Category]
					if typeof(newVal) == "Color3" then
						TS:Create(item.Object, TweenInfo.new(0.3), {[item.Property] = newVal}):Play()
						local grad = item.Object:FindFirstChildOfClass("UIGradient")
						if grad then grad.Enabled = false end
					elseif typeof(newVal) == "ColorSequence" then
						local grad = item.Object:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", item.Object)
						grad.Enabled = true
						grad.Color = newVal
						item.Object[item.Property] = Color3.fromRGB(255,255,255)
					end
				end
			end
			task.wait(0.05)
		end
	end)

	Fatality.ThemeEvent:Fire()
end

Fatality.Lucide = {
	["lucide-air-vent"] = "rbxassetid://10709752131",
	["lucide-airplay"] = "rbxassetid://10709752254",
	["lucide-alarm-check"] = "rbxassetid://10709752405",
	["lucide-alarm-minus"] = "rbxassetid://10709752732",
	["lucide-alarm-plus"] = "rbxassetid://10709752825",
	["lucide-alert-circle"] = "rbxassetid://10709752996",
	["lucide-alert-octagon"] = "rbxassetid://10709753064",
	["lucide-alert-triangle"] = "rbxassetid://10709753149",
	["lucide-align-center"] = "rbxassetid://10709753570",
	["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
	["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
	["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
	["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
	["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
	["lucide-align-justify"] = "rbxassetid://10709759610",
	["lucide-align-left"] = "rbxassetid://10709759764",
	["lucide-align-right"] = "rbxassetid://10709759895",
	["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
	["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
	["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
	["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
	["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
	["lucide-apple"] = "rbxassetid://10709761889",
	["lucide-archive-restore"] = "rbxassetid://10709762058",
	["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
	["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
	["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
	["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
	["lucide-bar-chart"] = "rbxassetid://10709773755",
	["lucide-bar-chart-2"] = "rbxassetid://10709770317",
	["lucide-bar-chart-3"] = "rbxassetid://10709770431",
	["lucide-bar-chart-4"] = "rbxassetid://10709770560",
	["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
	["lucide-battery-full"] = "rbxassetid://10709774206",
	["lucide-battery-medium"] = "rbxassetid://10709774513",
	["lucide-bell-ring"] = "rbxassetid://10709775560",
	["lucide-bluetooth"] = "rbxassetid://10709776655",
	["lucide-book-open"] = "rbxassetid://10709781717",
	["lucide-box-select"] = "rbxassetid://10709782342",
	["lucide-briefcase"] = "rbxassetid://10709782662",
	["lucide-calendar-check"] = "rbxassetid://10709783474",
	["lucide-calendar-clock"] = "rbxassetid://10709783577",
	["lucide-calendar-days"] = "rbxassetid://10709783673",
	["lucide-calendar-heart"] = "rbxassetid://10709783835",
	["lucide-calendar-minus"] = "rbxassetid://10709783959",
	["lucide-calendar-off"] = "rbxassetid://10709788784",
	["lucide-calendar-plus"] = "rbxassetid://10709788937",
	["lucide-calendar-range"] = "rbxassetid://10709789053",
	["lucide-calendar-search"] = "rbxassetid://10709789200",
	["lucide-calendar-x"] = "rbxassetid://10709789407",
	["lucide-charge"] = "rbxassetid://10709790202",
	["lucide-check-circle"] = "rbxassetid://10709790387",
	["lucide-check-circle-2"] = "rbxassetid://10709790298",
	["lucide-check-square"] = "rbxassetid://10709790537",
	["lucide-chevrons-down"] = "rbxassetid://10709796864",
	["lucide-chevrons-left"] = "rbxassetid://10709797151",
	["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
	["lucide-chevrons-right"] = "rbxassetid://10709797382",
	["lucide-chevrons-up"] = "rbxassetid://10709797622",
	["lucide-chrome"] = "rbxassetid://10709797725",
	["lucide-circle-dot"] = "rbxassetid://10709797837",
	["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
	["lucide-circle-slashed"] = "rbxassetid://10709798100",
	["lucide-clipboard-check"] = "rbxassetid://10709798443",
	["lucide-clipboard-copy"] = "rbxassetid://10709798574",
	["lucide-clipboard-edit"] = "rbxassetid://10709798682",
	["lucide-clipboard-list"] = "rbxassetid://10709798792",
	["lucide-clipboard-signature"] = "rbxassetid://10709798890",
	["lucide-clipboard-type"] = "rbxassetid://10709798999",
	["lucide-clipboard-x"] = "rbxassetid://10709799124",
	["lucide-clock-1"] = "rbxassetid://10709799535",
	["lucide-clock-10"] = "rbxassetid://10709799718",
	["lucide-clock-11"] = "rbxassetid://10709799818",
	["lucide-clock-12"] = "rbxassetid://10709799962",
	["lucide-clock-2"] = "rbxassetid://10709803876",
	["lucide-clock-3"] = "rbxassetid://10709803989",
	["lucide-clock-4"] = "rbxassetid://10709804164",
	["lucide-clock-5"] = "rbxassetid://10709804291",
	["lucide-clock-6"] = "rbxassetid://10709804435",
	["lucide-clock-7"] = "rbxassetid://10709804599",
	["lucide-clock-8"] = "rbxassetid://10709804784",
	["lucide-clock-9"] = "rbxassetid://10709804996",
	["lucide-cloud-cog"] = "rbxassetid://10709805262",
	["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
	["lucide-cloud-fog"] = "rbxassetid://10709805477",
	["lucide-cloud-hail"] = "rbxassetid://10709805596",
	["lucide-cloud-lightning"] = "rbxassetid://10709805727",
	["lucide-cloud-moon"] = "rbxassetid://10709805942",
	["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
	["lucide-cloud-off"] = "rbxassetid://10709806060",
	["lucide-cloud-rain"] = "rbxassetid://10709806277",
	["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
	["lucide-cloud-snow"] = "rbxassetid://10709806374",
	["lucide-cloud-sun"] = "rbxassetid://10709806631",
	["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
	["lucide-cloudy"] = "rbxassetid://10709806859",
	["lucide-code-2"] = "rbxassetid://10709807111",
	["lucide-columns"] = "rbxassetid://10709811261",
	["lucide-connection"] = "rbxassetid://10747361219",
	["lucide-contact"] = "rbxassetid://10709811834",
	["lucide-corner-down-left"] = "rbxassetid://10709812396",
	["lucide-corner-down-right"] = "rbxassetid://10709812485",
	["lucide-corner-left-down"] = "rbxassetid://10709812632",
	["lucide-corner-left-up"] = "rbxassetid://10709812784",
	["lucide-corner-right-down"] = "rbxassetid://10709812939",
	["lucide-corner-right-up"] = "rbxassetid://10709813094",
	["lucide-corner-up-left"] = "rbxassetid://10709813185",
	["lucide-corner-up-right"] = "rbxassetid://10709813281",
	["lucide-crosshair"] = "rbxassetid://10709818534",
	["lucide-curly-braces"] = "rbxassetid://10709818847",
	["lucide-divide-circle"] = "rbxassetid://10723343636",
	["lucide-divide-square"] = "rbxassetid://10723343737",
	["lucide-download-cloud"] = "rbxassetid://10723344088",
	["lucide-edit-2"] = "rbxassetid://10723344885",
	["lucide-edit-3"] = "rbxassetid://10723345088",
	["lucide-electricity"] = "rbxassetid://10723345749",
	["lucide-electricity-off"] = "rbxassetid://10723345643",
	["lucide-file-audio"] = "rbxassetid://10723355148",
	["lucide-file-audio-2"] = "rbxassetid://10723355026",
	["lucide-file-badge-2"] = "rbxassetid://10723355451",
	["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
	["lucide-file-check-2"] = "rbxassetid://10723356100",
	["lucide-file-cog-2"] = "rbxassetid://10723356676",
	["lucide-file-json"] = "rbxassetid://10723364435",
	["lucide-file-json-2"] = "rbxassetid://10723364361",
	["lucide-file-key-2"] = "rbxassetid://10723364515",
	["lucide-file-lock-2"] = "rbxassetid://10723364861",
	["lucide-file-minus-2"] = "rbxassetid://10723365086",
	["lucide-file-plus-2"] = "rbxassetid://10723365766",
	["lucide-file-question"] = "rbxassetid://10723365987",
	["lucide-file-search-2"] = "rbxassetid://1072336340",
	["lucide-file-type-2"] = "rbxassetid://10723367509",
	["lucide-file-video-2"] = "rbxassetid://10723367834",
	["lucide-file-volume-2"] = "rbxassetid://10723374030",
	["lucide-file-x-2"] = "rbxassetid://10723374378",
	["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
	["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
	["lucide-flip-horizontal"] = "rbxassetid://10723376884",
	["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
	["lucide-flip-vertical"] = "rbxassetid://10723377138",
	["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
	["lucide-folder-cog-2"] = "rbxassetid://10723385036",
	["lucide-folder-search-2"] = "rbxassetid://10723386674",
	["lucide-form-input"] = "rbxassetid://10723387841",
	["lucide-function-square"] = "rbxassetid://10723395041",
	["lucide-gift-card"] = "rbxassetid://10723396225",
	["lucide-git-branch-plus"] = "rbxassetid://10723396542",
	["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
	["lucide-glass"] = "rbxassetid://10723397788",
	["lucide-glass-2"] = "rbxassetid://10723397529",
	["lucide-globe-2"] = "rbxassetid://10723398002",
	["lucide-grab"] = "rbxassetid://10723404472",
	["lucide-heart-handshake"] = "rbxassetid://10723406480",
	["lucide-help-circle"] = "rbxassetid://10723406988",
	["lucide-ice-cream"] = "rbxassetid://10723414308",
	["lucide-inspect"] = "rbxassetid://10723416057",
	["lucide-laptop-2"] = "rbxassetid://10723417797",
	["lucide-layout"] = "rbxassetid://10723425376",
	["lucide-layout-grid"] = "rbxassetid://10723424838",
	["lucide-layout-list"] = "rbxassetid://10723424963",
	["lucide-link-2-off"] = "rbxassetid://10723426513",
	["lucide-list-checks"] = "rbxassetid://10734884548",
	["lucide-loader"] = "rbxassetid://10723434070",
	["lucide-loader-2"] = "rbxassetid://10723433935",
	["lucide-mail-question"] = "rbxassetid://10723435515",
	["lucide-mail-search"] = "rbxassetid://10734884739",
	["lucide-mail-warning"] = "rbxassetid://10734885015",
	["lucide-mail-x"] = "rbxassetid://10734885247",
	["lucide-maximize"] = "rbxassetid://10734886735",
	["lucide-mic-2"] = "rbxassetid://10734888430",
	["lucide-mic-off"] = "rbxassetid://10734888646",
	["lucide-minimize"] = "rbxassetid://10734895698",
	["lucide-minus-circle"] = "rbxassetid://10734895856",
	["lucide-minus-square"] = "rbxassetid://10734896029",
	["lucide-monitor-speaker"] = "rbxassetid://10734896512",
	["lucide-more-horizontal"] = "rbxassetid://10734897250",
	["lucide-more-vertical"] = "rbxassetid://10734897387",
	["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
	["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
	["lucide-move-diagonal"] = "rbxassetid://10734899164",
	["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
	["lucide-music-3"] = "rbxassetid://10734905665",
	["lucide-music-4"] = "rbxassetid://10734905823",
	["lucide-navigation-2"] = "rbxassetid://10734906332",
	["lucide-navigation-2-off"] = "rbxassetid://10734906144",
	["lucide-navigation-off"] = "rbxassetid://10734906580",
	["lucide-package-2"] = "rbxassetid://10734908151",
	["lucide-paintbrush-2"] = "rbxassetid://10734910030",
	["lucide-palmtree"] = "rbxassetid://10734910680",
	["lucide-pause-circle"] = "rbxassetid://10735024209",
	["lucide-pause-octagon"] = "rbxassetid://10734919143",
	["lucide-phone-missed"] = "rbxassetid://10734920845",
	["lucide-pie-chart"] = "rbxassetid://10734921727",
	["lucide-play-circle"] = "rbxassetid://10734923214",
	["lucide-plus-circle"] = "rbxassetid://10734923868",
	["lucide-plus-square"] = "rbxassetid://10734924219",
	["lucide-power-off"] = "rbxassetid://10734930257",
	["lucide-redo-2"] = "rbxassetid://10734932586",
	["lucide-refresh-ccw"] = "rbxassetid://10734933056",
	["lucide-refresh-cw"] = "rbxassetid://10734933222",
	["lucide-repeat-1"] = "rbxassetid://10734933826",
	["lucide-reply-all"] = "rbxassetid://10734934132",
	["lucide-rotate-3d"] = "rbxassetid://10734940107",
	["lucide-scale-3d"] = "rbxassetid://10734941739",
	["lucide-screen-share-off"] = "rbxassetid://10734942967",
	["lucide-sidebar"] = "rbxassetid://10734954301",
	["lucide-sidebar-close"] = "rbxassetid://10734953715",
	["lucide-sidebar-open"] = "rbxassetid://10734954000",
	["lucide-signal-high"] = "rbxassetid://10734954807",
	["lucide-signal-low"] = "rbxassetid://10734955080",
	["lucide-signal-medium"] = "rbxassetid://10734955336",
	["lucide-signal-zero"] = "rbxassetid://10734960878",
	["lucide-sliders"] = "rbxassetid://10734963400",
	["lucide-smile-plus"] = "rbxassetid://10734964188",
	["lucide-sort-asc"] = "rbxassetid://10734965115",
	["lucide-sort-desc"] = "rbxassetid://10734965287",
	["lucide-star-half"] = "rbxassetid://10734965897",
	["lucide-stop-circle"] = "rbxassetid://10734972621",
	["lucide-sun-dim"] = "rbxassetid://10734973645",
	["lucide-sun-medium"] = "rbxassetid://10734973778",
	["lucide-sun-moon"] = "rbxassetid://10734973999",
	["lucide-sun-snow"] = "rbxassetid://10734974130",
	["lucide-table-2"] = "rbxassetid://10734976097",
	["lucide-terminal-square"] = "rbxassetid://10734981995",
	["lucide-text-cursor-input"] = "rbxassetid://10734982297",
	["lucide-timer-off"] = "rbxassetid://10734984138",
	["lucide-timer-reset"] = "rbxassetid://10734984355",
	["lucide-trash-2"] = "rbxassetid://10747362241",
	["lucide-tv-2"] = "rbxassetid://10747364302",
	["lucide-undo-2"] = "rbxassetid://10747365359",
	["lucide-unlink-2"] = "rbxassetid://10747397871",
	["lucide-upload-cloud"] = "rbxassetid://10747366266",
	["lucide-user-check"] = "rbxassetid://10747371901",
	["lucide-user-cog"] = "rbxassetid://10747372167",
	["lucide-user-minus"] = "rbxassetid://10747372346",
	["lucide-user-plus"] = "rbxassetid://10747372702",
	["lucide-user-x"] = "rbxassetid://10747372992",
	["lucide-utensils-crossed"] = "rbxassetid://10747373629",
	["lucide-verified"] = "rbxassetid://10747374131",
	["lucide-vibrate-off"] = "rbxassetid://10747374269",
	["lucide-video-off"] = "rbxassetid://10747374721",
	["lucide-volume-x"] = "rbxassetid://10747375880",
	["lucide-wand-2"] = "rbxassetid://10747376349",
	["lucide-wrap-text"] = "rbxassetid://10747383065",
	["lucide-x-circle"] = "rbxassetid://10747383819",
	["lucide-x-octagon"] = "rbxassetid://10747384037",
	["lucide-x-square"] = "rbxassetid://10747384217",
	["lucide-a-arrow-down"] = "rbxassetid://92867583610071",
	["lucide-a-arrow-up"] = "rbxassetid://132318504999733",
	["lucide-a-large-small"] = "rbxassetid://111491496660216",
	["lucide-accessibility"] = "rbxassetid://114029945302017",
	["lucide-activity"] = "rbxassetid://94212016861936",
	["lucide-air-vent"] = "rbxassetid://81517226012329",
	["lucide-airplay"] = "rbxassetid://115020759309179",
	["lucide-alarm-clock-check"] = "rbxassetid://76437352099157",
	["lucide-alarm-clock-minus"] = "rbxassetid://77364179863205",
	["lucide-alarm-clock-off"] = "rbxassetid://97904885874823",
	["lucide-alarm-clock-plus"] = "rbxassetid://80468822979214",
	["lucide-alarm-clock"] = "rbxassetid://126259032907535",
	["lucide-alarm-smoke"] = "rbxassetid://96965448419685",
	["lucide-album"] = "rbxassetid://127358331163602",
	["lucide-align-center-horizontal"] = "rbxassetid://81570549209434",
	["lucide-align-center-vertical"] = "rbxassetid://118470463752466",
	["lucide-align-end-horizontal"] = "rbxassetid://139502909745427",
	["lucide-align-end-vertical"] = "rbxassetid://96528869059554",
	["lucide-align-horizontal-distribute-center"] = "rbxassetid://97220086126656",
	["lucide-align-horizontal-distribute-end"] = "rbxassetid://106128590702022",
	["lucide-align-horizontal-distribute-start"] = "rbxassetid://76074660002997",
	["lucide-align-horizontal-justify-center"] = "rbxassetid://75732302772427",
	["lucide-align-horizontal-justify-end"] = "rbxassetid://129167626402283",
	["lucide-align-horizontal-justify-start"] = "rbxassetid://130161830325281",
	["lucide-align-horizontal-space-around"] = "rbxassetid://91646106782950",
	["lucide-align-horizontal-space-between"] = "rbxassetid://103886093046990",
	["lucide-align-start-horizontal"] = "rbxassetid://125674804697729",
	["lucide-align-start-vertical"] = "rbxassetid://105020230154823",
	["lucide-align-vertical-distribute-center"] = "rbxassetid://93791183635525",
	["lucide-align-vertical-distribute-end"] = "rbxassetid://139354223511433",
	["lucide-align-vertical-distribute-start"] = "rbxassetid://74961997822126",
	["lucide-align-vertical-justify-center"] = "rbxassetid://134754696166569",
	["lucide-align-vertical-justify-end"] = "rbxassetid://92569381441969",
	["lucide-align-vertical-justify-start"] = "rbxassetid://99692844572718",
	["lucide-align-vertical-space-around"] = "rbxassetid://96206012459190",
	["lucide-align-vertical-space-between"] = "rbxassetid://124998077349706",
	["lucide-ambulance"] = "rbxassetid://78599995190651",
	["lucide-ampersand"] = "rbxassetid://75272915739209",
	["lucide-ampersands"] = "rbxassetid://126947193455996",
	["lucide-amphora"] = "rbxassetid://137370389604364",
	["lucide-anchor"] = "rbxassetid://92181172123618",
	["lucide-angry"] = "rbxassetid://74237056000103",
	["lucide-annoyed"] = "rbxassetid://80064369052011",
	["lucide-antenna"] = "rbxassetid://99628923540956",
	["lucide-anvil"] = "rbxassetid://100203029845919",
	["lucide-aperture"] = "rbxassetid://83396154449972",
	["lucide-app-window-mac"] = "rbxassetid://79587216113811",
	["lucide-app-window"] = "rbxassetid://93142176757189",
	["lucide-apple"] = "rbxassetid://104349242902442",
	["lucide-archive-restore"] = "rbxassetid://78956681942188",
	["lucide-archive-x"] = "rbxassetid://75830115088395",
	["lucide-archive"] = "rbxassetid://122180020814574",
	["lucide-armchair"] = "rbxassetid://105384358373973",
	["lucide-arrow-big-down-dash"] = "rbxassetid://137987229582002",
	["lucide-arrow-big-down"] = "rbxassetid://81081164158885",
	["lucide-arrow-big-left-dash"] = "rbxassetid://97827621354677",
	["lucide-arrow-big-left"] = "rbxassetid://85973092492641",
	["lucide-arrow-big-right-dash"] = "rbxassetid://117825834972403",
	["lucide-arrow-big-right"] = "rbxassetid://82960676755590",
	["lucide-arrow-big-up-dash"] = "rbxassetid://99260194327483",
	["lucide-arrow-big-up"] = "rbxassetid://93136954756149",
	["lucide-arrow-down-0-1"] = "rbxassetid://120961896217875",
	["lucide-arrow-down-1-0"] = "rbxassetid://93474255891850",
	["lucide-arrow-down-a-z"] = "rbxassetid://99554596207900",
	["lucide-arrow-down-from-line"] = "rbxassetid://132045845807798",
	["lucide-arrow-down-left"] = "rbxassetid://102899325237364",
	["lucide-arrow-down-narrow-wide"] = "rbxassetid://129105261655061",
	["lucide-arrow-down-right"] = "rbxassetid://123109928624974",
	["lucide-arrow-down-to-dot"] = "rbxassetid://101675355931221",
	["lucide-arrow-down-to-line"] = "rbxassetid://87050478931254",
	["lucide-arrow-down-up"] = "rbxassetid://85780258549577",
	["lucide-arrow-down-wide-narrow"] = "rbxassetid://88461733425991",
	["lucide-arrow-down-z-a"] = "rbxassetid://76115279362232",
	["lucide-arrow-down"] = "rbxassetid://98764963621439",
	["lucide-arrow-left-from-line"] = "rbxassetid://87857914437603",
	["lucide-arrow-left-right"] = "rbxassetid://131324733048447",
	["lucide-arrow-left-to-line"] = "rbxassetid://118645136026970",
	["lucide-arrow-left"] = "rbxassetid://102531941843733",
	["lucide-arrow-right-from-line"] = "rbxassetid://74073639809355",
	["lucide-arrow-right-left"] = "rbxassetid://77015754304300",
	["lucide-arrow-right-to-line"] = "rbxassetid://78632510329852",
	["lucide-arrow-right"] = "rbxassetid://113692007244654",
	["lucide-arrow-up-0-1"] = "rbxassetid://105257823943016",
	["lucide-arrow-up-1-0"] = "rbxassetid://134175521693798",
	["lucide-arrow-up-a-z"] = "rbxassetid://77763416595160",
	["lucide-arrow-up-down"] = "rbxassetid://81019887641527",
	["lucide-arrow-up-from-dot"] = "rbxassetid://124408496673275",
	["lucide-arrow-up-from-line"] = "rbxassetid://95777664626453",
	["lucide-arrow-up-left"] = "rbxassetid://123490598231261",
	["lucide-arrow-up-narrow-wide"] = "rbxassetid://73006024672636",
	["lucide-arrow-up-right"] = "rbxassetid://129280608535523",
	["lucide-arrow-up-to-line"] = "rbxassetid://108818207813537",
	["lucide-arrow-up-wide-narrow"] = "rbxassetid://87437426951568",
	["lucide-arrow-up-z-a"] = "rbxassetid://107546173611884",
	["lucide-arrow-up"] = "rbxassetid://89282378235317",
	["lucide-arrows-up-from-line"] = "rbxassetid://133710016938621",
	["lucide-asterisk"] = "rbxassetid://88552752106723",
	["lucide-at-sign"] = "rbxassetid://79059152889146",
	["lucide-atom"] = "rbxassetid://73167696981648",
	["lucide-audio-lines"] = "rbxassetid://70930641819242",
	["lucide-audio-waveform"] = "rbxassetid://86462036665209",
	["lucide-award"] = "rbxassetid://132740088158419",
	["lucide-axe"] = "rbxassetid://132405197863294",
	["lucide-axis-3d"] = "rbxassetid://122438676546804",
	["lucide-baby"] = "rbxassetid://93472926933440",
	["lucide-backpack"] = "rbxassetid://140420225386018",
	["lucide-badge-alert"] = "rbxassetid://101829200081951",
	["lucide-badge-cent"] = "rbxassetid://133345018873154",
	["lucide-badge-check"] = "rbxassetid://76078495178149",
	["lucide-badge-dollar-sign"] = "rbxassetid://127139803581141",
	["lucide-badge-euro"] = "rbxassetid://120016477674659",
	["lucide-badge-indian-rupee"] = "rbxassetid://75659682309981",
	["lucide-badge-info"] = "rbxassetid://131995373201472",
	["lucide-badge-japanese-yen"] = "rbxassetid://99081574588615",
	["lucide-badge-minus"] = "rbxassetid://140321561183881",
	["lucide-badge-percent"] = "rbxassetid://121359224294885",
	["lucide-badge-plus"] = "rbxassetid://100325578561866",
	["lucide-badge-pound-sterling"] = "rbxassetid://119688217279444",
	["lucide-badge-question-mark"] = "rbxassetid://121464963737502",
	["lucide-badge-russian-ruble"] = "rbxassetid://108839463659864",
	["lucide-badge-swiss-franc"] = "rbxassetid://91447608372740",
	["lucide-badge-turkish-lira"] = "rbxassetid://137839965873529",
	["lucide-badge-x"] = "rbxassetid://122931434733842",
	["lucide-badge"] = "rbxassetid://116620312917084",
	["lucide-baggage-claim"] = "rbxassetid://86922213051957",
	["lucide-ban"] = "rbxassetid://90767043015246",
	["lucide-banana"] = "rbxassetid://140713420056179",
	["lucide-bandage"] = "rbxassetid://129660129590770",
	["lucide-banknote-arrow-down"] = "rbxassetid://139366449345199",
	["lucide-banknote-arrow-up"] = "rbxassetid://133758343082529",
	["lucide-banknote-x"] = "rbxassetid://95348701438065",
	["lucide-banknote"] = "rbxassetid://104840231536668",
	["lucide-barcode"] = "rbxassetid://118473018143689",
	["lucide-barrel"] = "rbxassetid://130647115622774",
	["lucide-baseline"] = "rbxassetid://124677132511270",
	["lucide-bath"] = "rbxassetid://76031400297942",
	["lucide-battery-charging"] = "rbxassetid://80139357470047",
	["lucide-battery-full"] = "rbxassetid://70906718268972",
	["lucide-battery-low"] = "rbxassetid://139659256984314",
	["lucide-battery-medium"] = "rbxassetid://105934079398915",
	["lucide-battery-plus"] = "rbxassetid://91931341486966",
	["lucide-battery-warning"] = "rbxassetid://115230083817257",
	["lucide-battery"] = "rbxassetid://70765800346189",
	["lucide-beaker"] = "rbxassetid://80902539995520",
	["lucide-bean-off"] = "rbxassetid://98164436608714",
	["lucide-bean"] = "rbxassetid://89491967076869",
	["lucide-bed-double"] = "rbxassetid://73820193212911",
	["lucide-bed-single"] = "rbxassetid://113423940880634",
	["lucide-bed"] = "rbxassetid://97726529032925",
	["lucide-beef"] = "rbxassetid://105850162318915",
	["lucide-beer-off"] = "rbxassetid://120333134736361",
	["lucide-beer"] = "rbxassetid://116404978807744",
	["lucide-bell-dot"] = "rbxassetid://93161277118810",
	["lucide-bell-electric"] = "rbxassetid://100277767266983",
	["lucide-bell-minus"] = "rbxassetid://126334890449727",
	["lucide-bell-off"] = "rbxassetid://78560046118930",
	["lucide-bell-plus"] = "rbxassetid://77014333795836",
	["lucide-bell-ring"] = "rbxassetid://94612128913941",
	["lucide-bell"] = "rbxassetid://97392696311902",
	["lucide-between-horizontal-end"] = "rbxassetid://81602774794322",
	["lucide-between-horizontal-start"] = "rbxassetid://76112384929846",
	["lucide-between-vertical-end"] = "rbxassetid://72817612571631",
	["lucide-between-vertical-start"] = "rbxassetid://85278312190301",
	["lucide-biceps-flexed"] = "rbxassetid://82004462003936",
	["lucide-bike"] = "rbxassetid://102930322246035",
	["lucide-binary"] = "rbxassetid://91751953950088",
	["lucide-binoculars"] = "rbxassetid://101460003267896",
	["lucide-biohazard"] = "rbxassetid://95956532900432",
	["lucide-bird"] = "rbxassetid://132284145117371",
	["lucide-birdhouse"] = "rbxassetid://83999157401433",
	["lucide-bitcoin"] = "rbxassetid://95459240442938",
	["lucide-blend"] = "rbxassetid://111679612185257",
	["lucide-blinds"] = "rbxassetid://71164165283925",
	["lucide-blocks"] = "rbxassetid://72212693357737",
	["lucide-bluetooth-connected"] = "rbxassetid://96315134002985",
	["lucide-bluetooth-off"] = "rbxassetid://80600044218117",
	["lucide-bluetooth-searching"] = "rbxassetid://100673019606426",
	["lucide-bluetooth"] = "rbxassetid://90506573139443",
	["lucide-bold"] = "rbxassetid://116141470019166",
	["lucide-bolt"] = "rbxassetid://102881251417484",
	["lucide-bomb"] = "rbxassetid://139223800924636",
	["lucide-bone"] = "rbxassetid://111242153474115",
	["lucide-book-a"] = "rbxassetid://104067275658465",
	["lucide-book-alert"] = "rbxassetid://124159928044853",
	["lucide-book-audio"] = "rbxassetid://109208148317037",
	["lucide-book-check"] = "rbxassetid://115999656081696",
	["lucide-book-copy"] = "rbxassetid://108543407492005",
	["lucide-book-dashed"] = "rbxassetid://127430784795958",
	["lucide-book-down"] = "rbxassetid://101011730128222",
	["lucide-book-headphones"] = "rbxassetid://108670200799574",
	["lucide-book-heart"] = "rbxassetid://112788845135284",
	["lucide-book-image"] = "rbxassetid://80808285757226",
	["lucide-book-key"] = "rbxassetid://116024426170705",
	["lucide-book-lock"] = "rbxassetid://118765061220571",
	["lucide-book-marked"] = "rbxassetid://73211024251780",
	["lucide-book-minus"] = "rbxassetid://112724962046282",
	["lucide-book-open-check"] = "rbxassetid://130848362492667",
	["lucide-book-open-text"] = "rbxassetid://100629528672195",
	["lucide-book-open"] = "rbxassetid://129845326810392",
	["lucide-book-plus"] = "rbxassetid://140267785051233",
	["lucide-book-text"] = "rbxassetid://94011772484232",
	["lucide-book-type"] = "rbxassetid://97817304725443",
	["lucide-book-up-2"] = "rbxassetid://130161620853665",
	["lucide-book-up"] = "rbxassetid://98640174079190",
	["lucide-book-user"] = "rbxassetid://128489189240523",
	["lucide-book-x"] = "rbxassetid://118754548186537",
	["lucide-book"] = "rbxassetid://125383279695672",
	["lucide-bookmark-check"] = "rbxassetid://93940443347986",
	["lucide-bookmark-minus"] = "rbxassetid://96807096039910",
	["lucide-bookmark-plus"] = "rbxassetid://121469724491615",
	["lucide-bookmark"] = "rbxassetid://121093149326239",
	["lucide-boom-box"] = "rbxassetid://99901322535868",
	["lucide-bot-message-square"] = "rbxassetid://96145330292478",
	["lucide-bot-off"] = "rbxassetid://140417690560013",
	["lucide-bot"] = "rbxassetid://80451686744860",
	["lucide-bottle-wine"] = "rbxassetid://131675403196921",
	["lucide-bow-arrow"] = "rbxassetid://124089655150375",
	["lucide-box"] = "rbxassetid://101768155599700",
	["lucide-boxes"] = "rbxassetid://136372617578355",
	["lucide-braces"] = "rbxassetid://117761094704041",
	["lucide-brackets"] = "rbxassetid://74368995728099",
	["lucide-brain-circuit"] = "rbxassetid://70547962410202",
	["lucide-brain-cog"] = "rbxassetid://132039205501538",
	["lucide-brain"] = "rbxassetid://92424107303177",
	["lucide-brick-wall-fire"] = "rbxassetid://92980588705520",
	["lucide-brick-wall-shield"] = "rbxassetid://75954432775071",
	["lucide-brick-wall"] = "rbxassetid://112878522258821",
	["lucide-briefcase-business"] = "rbxassetid://129135125207283",
	["lucide-briefcase-conveyor-belt"] = "rbxassetid://108665725653714",
	["lucide-briefcase-medical"] = "rbxassetid://119917756334087",
	["lucide-briefcase"] = "rbxassetid://96754188164225",
	["lucide-bring-to-front"] = "rbxassetid://132975903553748",
	["lucide-brush-cleaning"] = "rbxassetid://71728977448805",
	["lucide-brush"] = "rbxassetid://127035535799640",
	["lucide-bubbles"] = "rbxassetid://106183424168227",
	["lucide-bug-off"] = "rbxassetid://88020025049245",
	["lucide-bug-play"] = "rbxassetid://80107955888092",
	["lucide-bug"] = "rbxassetid://83626408925438",
	["lucide-building-2"] = "rbxassetid://77873775611951",
	["lucide-building"] = "rbxassetid://110616258983082",
	["lucide-bus-front"] = "rbxassetid://89863432456045",
	["lucide-bus"] = "rbxassetid://133798469717463",
	["lucide-cable-car"] = "rbxassetid://128643682205596",
	["lucide-cable"] = "rbxassetid://128449944504901",
	["lucide-cake-slice"] = "rbxassetid://136769828413242",
	["lucide-cake"] = "rbxassetid://103131590503275",
	["lucide-calculator"] = "rbxassetid://74915716529646",
	["lucide-calendar-1"] = "rbxassetid://98458364171044",
	["lucide-calendar-arrow-down"] = "rbxassetid://108415736543437",
	["lucide-calendar-arrow-up"] = "rbxassetid://70574654109118",
	["lucide-calendar-check-2"] = "rbxassetid://120231170248276",
	["lucide-calendar-check"] = "rbxassetid://71551019465748",
	["lucide-calendar-clock"] = "rbxassetid://119132152594595",
	["lucide-calendar-cog"] = "rbxassetid://122402172360287",
	["lucide-calendar-days"] = "rbxassetid://99072017568595",
	["lucide-calendar-fold"] = "rbxassetid://117368871270394",
	["lucide-calendar-heart"] = "rbxassetid://88839008103676",
	["lucide-calendar-minus-2"] = "rbxassetid://98846170279891",
	["lucide-calendar-minus"] = "rbxassetid://137354318924383",
	["lucide-calendar-off"] = "rbxassetid://109726151749217",
	["lucide-calendar-plus-2"] = "rbxassetid://112264562093883",
	["lucide-calendar-plus"] = "rbxassetid://125266115249843",
	["lucide-calendar-range"] = "rbxassetid://103641849247576",
	["lucide-calendar-search"] = "rbxassetid://92010083223634",
	["lucide-calendar-sync"] = "rbxassetid://78082218499697",
	["lucide-calendar-x-2"] = "rbxassetid://107518051061147",
	["lucide-calendar-x"] = "rbxassetid://106703374806500",
	["lucide-calendar"] = "rbxassetid://114792700814035",
	["lucide-camera-off"] = "rbxassetid://81057636835256",
	["lucide-camera"] = "rbxassetid://79950339943067",
	["lucide-candy-cane"] = "rbxassetid://71689468772492",
	["lucide-candy-off"] = "rbxassetid://110232752314832",
	["lucide-candy"] = "rbxassetid://107812129154678",
	["lucide-cannabis"] = "rbxassetid://98792006538601",
	["lucide-captions-off"] = "rbxassetid://105223545364193",
	["lucide-captions"] = "rbxassetid://104960225031445",
	["lucide-car-front"] = "rbxassetid://87380942739063",
	["lucide-car-taxi-front"] = "rbxassetid://122455403384057",
	["lucide-car"] = "rbxassetid://121065933462582",
	["lucide-caravan"] = "rbxassetid://120070979471783",
	["lucide-card-sim"] = "rbxassetid://134490550095771",
	["lucide-carrot"] = "rbxassetid://119118221444304",
	["lucide-case-lower"] = "rbxassetid://129303130603241",
	["lucide-case-sensitive"] = "rbxassetid://125410273293056",
	["lucide-case-upper"] = "rbxassetid://111633433531325",
	["lucide-cassette-tape"] = "rbxassetid://137065788934157",
	["lucide-cast"] = "rbxassetid://98202245922071",
	["lucide-castle"] = "rbxassetid://119275077187784",
	["lucide-cat"] = "rbxassetid://124252153404931",
	["lucide-cctv"] = "rbxassetid://99979894766624",
	["lucide-chart-area"] = "rbxassetid://123446436762366",
	["lucide-chart-bar-big"] = "rbxassetid://72336824986044",
	["lucide-chart-bar-decreasing"] = "rbxassetid://107217459044963",
	["lucide-chart-bar-increasing"] = "rbxassetid://88268905998571",
	["lucide-chart-bar-stacked"] = "rbxassetid://98478751113024",
	["lucide-chart-bar"] = "rbxassetid://105389816384108",
	["lucide-chart-candlestick"] = "rbxassetid://125676898615697",
	["lucide-chart-column-big"] = "rbxassetid://98598733210787",
	["lucide-chart-column-decreasing"] = "rbxassetid://73586137373563",
	["lucide-chart-column-increasing"] = "rbxassetid://120421615068601",
	["lucide-chart-column-stacked"] = "rbxassetid://86031449675105",
	["lucide-chart-column"] = "rbxassetid://97915995538580",
	["lucide-chart-gantt"] = "rbxassetid://88811660555940",
	["lucide-chart-line"] = "rbxassetid://101833156055618",
	["lucide-chart-network"] = "rbxassetid://104027882693561",
	["lucide-chart-no-axes-column-decreasing"] = "rbxassetid://123371717192542",
	["lucide-chart-no-axes-column-increasing"] = "rbxassetid://140383830943049",
	["lucide-chart-no-axes-column"] = "rbxassetid://94078751170351",
	["lucide-chart-no-axes-combined"] = "rbxassetid://121424233161912",
	["lucide-chart-no-axes-gantt"] = "rbxassetid://131936541106368",
	["lucide-chart-pie"] = "rbxassetid://113412261630136",
	["lucide-chart-scatter"] = "rbxassetid://108217585014571",
	["lucide-chart-spline"] = "rbxassetid://90307460742494",
	["lucide-check-check"] = "rbxassetid://95183312173858",
	["lucide-check-line"] = "rbxassetid://115122343485290",
	["lucide-check"] = "rbxassetid://93898873302694",
	["lucide-chef-hat"] = "rbxassetid://121744015002573",
	["lucide-cherry"] = "rbxassetid://139519182403183",
	["lucide-chess-bishop"] = "rbxassetid://121701705580238",
	["lucide-chess-king"] = "rbxassetid://90885687223462",
	["lucide-chess-knight"] = "rbxassetid://96467707042169",
	["lucide-chess-pawn"] = "rbxassetid://111318574652751",
	["lucide-chess-queen"] = "rbxassetid://98304702099749",
	["lucide-chess-rook"] = "rbxassetid://76223925830262",
	["lucide-chevron-down"] = "rbxassetid://134243273101015",
	["lucide-chevron-first"] = "rbxassetid://105243363790238",
	["lucide-chevron-last"] = "rbxassetid://89268452603731",
	["lucide-chevron-left"] = "rbxassetid://73780377692148",
	["lucide-chevron-right"] = "rbxassetid://92473583511724",
	["lucide-chevron-up"] = "rbxassetid://122444883127455",
	["lucide-chevrons-down-up"] = "rbxassetid://139404716013205",
	["lucide-chevrons-down"] = "rbxassetid://100524612205956",
	["lucide-chevrons-left-right-ellipsis"] = "rbxassetid://125035817741526",
	["lucide-chevrons-left-right"] = "rbxassetid://87910685945204",
	["lucide-chevrons-left"] = "rbxassetid://82617201744347",
	["lucide-chevrons-right-left"] = "rbxassetid://87149546686569",
	["lucide-chevrons-right"] = "rbxassetid://139121276490483",
	["lucide-chevrons-up-down"] = "rbxassetid://131833120209646",
	["lucide-chevrons-up"] = "rbxassetid://100467452364672",
	["lucide-chromium"] = "rbxassetid://128165143739006",
	["lucide-church"] = "rbxassetid://113714744350666",
	["lucide-cigarette-off"] = "rbxassetid://77797883078452",
	["lucide-circle-alert"] = "rbxassetid://83898160590116",
	["lucide-circle-arrow-down"] = "rbxassetid://95901860261344",
	["lucide-circle-arrow-left"] = "rbxassetid://102148876968988",
	["lucide-circle-arrow-out-down-left"] = "rbxassetid://140598097856694",
	["lucide-circle-arrow-out-down-right"] = "rbxassetid://119952801379305",
	["lucide-circle-arrow-out-up-left"] = "rbxassetid://132858212688303",
	["lucide-circle-arrow-out-up-right"] = "rbxassetid://81783743753173",
	["lucide-circle-arrow-right"] = "rbxassetid://70786767999559",
	["lucide-circle-arrow-up"] = "rbxassetid://84395128546494",
	["lucide-circle-check-big"] = "rbxassetid://93202927221730",
	["lucide-circle-check"] = "rbxassetid://85262178816537",
	["lucide-circle-chevron-down"] = "rbxassetid://137069490345718",
	["lucide-circle-chevron-left"] = "rbxassetid://130250009740827",
	["lucide-circle-chevron-right"] = "rbxassetid://125943696958495",
	["lucide-circle-chevron-up"] = "rbxassetid://111223574026321",
	["lucide-circle-dashed"] = "rbxassetid://126799443883746",
	["lucide-circle-divide"] = "rbxassetid://106398997754208",
	["lucide-circle-dollar-sign"] = "rbxassetid://91106238890387",
	["lucide-circle-dot-dashed"] = "rbxassetid://111451232827180",
	["lucide-circle-dot"] = "rbxassetid://82947033619201",
	["lucide-circle-ellipsis"] = "rbxassetid://91687150884779",
	["lucide-circle-equal"] = "rbxassetid://95133963751438",
	["lucide-circle-fading-arrow-up"] = "rbxassetid://104648212910336",
	["lucide-circle-fading-plus"] = "rbxassetid://91847890443490",
	["lucide-circle-gauge"] = "rbxassetid://108157549473765",
	["lucide-circle-minus"] = "rbxassetid://133556159576809",
	["lucide-circle-off"] = "rbxassetid://97923456918886",
	["lucide-circle-parking-off"] = "rbxassetid://128369410981252",
	["lucide-circle-parking"] = "rbxassetid://124034962915196",
	["lucide-circle-pause"] = "rbxassetid://139337739700879",
	["lucide-circle-percent"] = "rbxassetid://133311912860256",
	["lucide-circle-play"] = "rbxassetid://120408917249739",
	["lucide-circle-plus"] = "rbxassetid://113157136350384",
	["lucide-circle-pound-sterling"] = "rbxassetid://105476153083828",
	["lucide-circle-power"] = "rbxassetid://140676030155098",
	["lucide-circle-question-mark"] = "rbxassetid://97516698664325",
	["lucide-circle-slash-2"] = "rbxassetid://136766902186549",
	["lucide-circle-slash"] = "rbxassetid://125206439913049",
	["lucide-circle-small"] = "rbxassetid://73685402843600",
	["lucide-circle-star"] = "rbxassetid://120318414957104",
	["lucide-circle-stop"] = "rbxassetid://87400503942659",
	["lucide-circle-user-round"] = "rbxassetid://95489465399880",
	["lucide-circle-user"] = "rbxassetid://136220511671311",
	["lucide-circle-x"] = "rbxassetid://76821953846248",
	["lucide-circle"] = "rbxassetid://130359823580534",
	["lucide-circuit-board"] = "rbxassetid://107695264369312",
	["lucide-citrus"] = "rbxassetid://139018222976433",
	["lucide-clapperboard"] = "rbxassetid://132660667070200",
	["lucide-clipboard-check"] = "rbxassetid://92649798577170",
	["lucide-clipboard-clock"] = "rbxassetid://123957515687745",
	["lucide-clipboard-copy"] = "rbxassetid://125851897718493",
	["lucide-clipboard-list"] = "rbxassetid://96460215958908",
	["lucide-clipboard-minus"] = "rbxassetid://107968008485671",
	["lucide-clipboard-paste"] = "rbxassetid://74382068849983",
	["lucide-clipboard-pen-line"] = "rbxassetid://77711589791615",
	["lucide-clipboard-pen"] = "rbxassetid://75290966822953",
	["lucide-clipboard-plus"] = "rbxassetid://134285318675662",
	["lucide-clipboard-type"] = "rbxassetid://89949374318028",
	["lucide-clipboard-x"] = "rbxassetid://102222456890103",
	["lucide-clipboard"] = "rbxassetid://89601995828423",
	["lucide-clock-1"] = "rbxassetid://129363225422045",
	["lucide-clock-10"] = "rbxassetid://104332695855541",
	["lucide-clock-11"] = "rbxassetid://119023205186105",
	["lucide-clock-12"] = "rbxassetid://117789618723068",
	["lucide-clock-2"] = "rbxassetid://134710777209413",
	["lucide-clock-3"] = "rbxassetid://136385631189327",
	["lucide-clock-4"] = "rbxassetid://121808839832144",
	["lucide-clock-5"] = "rbxassetid://85082019959457",
	["lucide-clock-6"] = "rbxassetid://71009733505593",
	["lucide-clock-7"] = "rbxassetid://103111188546225",
	["lucide-clock-8"] = "rbxassetid://110059272125337",
	["lucide-clock-9"] = "rbxassetid://77610027126437",
	["lucide-clock-alert"] = "rbxassetid://97157344465162",
	["lucide-clock-arrow-down"] = "rbxassetid://92349314416042",
	["lucide-clock-arrow-up"] = "rbxassetid://111484286332629",
	["lucide-clock-check"] = "rbxassetid://85231630218857",
	["lucide-clock-fading"] = "rbxassetid://93205297285245",
	["lucide-clock-plus"] = "rbxassetid://93367709263150",
	["lucide-clock"] = "rbxassetid://121808839832144",
	["lucide-closed-caption"] = "rbxassetid://99832644030788",
	["lucide-cloud-alert"] = "rbxassetid://91967273658626",
	["lucide-cloud-check"] = "rbxassetid://97318598202432",
	["lucide-cloud-cog"] = "rbxassetid://96497764065749",
	["lucide-cloud-download"] = "rbxassetid://121435581993566",
	["lucide-cloud-drizzle"] = "rbxassetid://139525315752605",
	["lucide-cloud-fog"] = "rbxassetid://76650233148776",
	["lucide-cloud-hail"] = "rbxassetid://72320462748242",
	["lucide-cloud-lightning"] = "rbxassetid://133517088924849",
	["lucide-cloud-moon-rain"] = "rbxassetid://127667837827018",
	["lucide-cloud-moon"] = "rbxassetid://71938114737914",
	["lucide-cloud-off"] = "rbxassetid://131907154501444",
	["lucide-cloud-rain-wind"] = "rbxassetid://107414583736721",
	["lucide-cloud-rain"] = "rbxassetid://105547081967408",
	["lucide-cloud-snow"] = "rbxassetid://72307126270226",
	["lucide-cloud-sun-rain"] = "rbxassetid://99041604425705",
	["lucide-cloud-sun"] = "rbxassetid://86114208148727",
	["lucide-cloud-upload"] = "rbxassetid://93307473217005",
	["lucide-cloud"] = "rbxassetid://121226497050352",
	["lucide-cloudy"] = "rbxassetid://105360479023346",
	["lucide-clover"] = "rbxassetid://74925550436750",
	["lucide-club"] = "rbxassetid://108490365816628",
	["lucide-code-xml"] = "rbxassetid://130150477351734",
	["lucide-code"] = "rbxassetid://107380207681249",
	["lucide-codepen"] = "rbxassetid://135643965971885",
	["lucide-codesandbox"] = "rbxassetid://106911852964823",
	["lucide-coffee"] = "rbxassetid://106864403231093",
	["lucide-cog"] = "rbxassetid://116544501716299",
	["lucide-coins"] = "rbxassetid://116510979641930",
	["lucide-columns-2"] = "rbxassetid://113004100221850",
	["lucide-columns-3-cog"] = "rbxassetid://121589691981064",
	["lucide-columns-3"] = "rbxassetid://115223357399375",
	["lucide-columns-4"] = "rbxassetid://130807991968419",
	["lucide-combine"] = "rbxassetid://79908476334048",
	["lucide-command"] = "rbxassetid://93648221906330",
	["lucide-compass"] = "rbxassetid://115123411028382",
	["lucide-component"] = "rbxassetid://110027788875080",
	["lucide-computer"] = "rbxassetid://77480056459407",
	["lucide-concierge-bell"] = "rbxassetid://140384259310436",
	["lucide-cone"] = "rbxassetid://97759550688437",
	["lucide-construction"] = "rbxassetid://106539489968173",
	["lucide-contact-round"] = "rbxassetid://71907624112229",
	["lucide-contact"] = "rbxassetid://75868297719012",
	["lucide-container"] = "rbxassetid://91507237573499",
	["lucide-contrast"] = "rbxassetid://112796643981497",
	["lucide-cookie"] = "rbxassetid://73159504540002",
	["lucide-cooking-pot"] = "rbxassetid://94959783129799",
	["lucide-copy-check"] = "rbxassetid://91177247988892",
	["lucide-copy-minus"] = "rbxassetid://109524509933035",
	["lucide-copy-plus"] = "rbxassetid://113618379616952",
	["lucide-copy-slash"] = "rbxassetid://93805787810390",
	["lucide-copy-x"] = "rbxassetid://106557557978061",
	["lucide-copy"] = "rbxassetid://78979572434545",
	["lucide-copyleft"] = "rbxassetid://78559055698593",
	["lucide-copyright"] = "rbxassetid://129433635747111",
	["lucide-corner-down-left"] = "rbxassetid://90473561177832",
	["lucide-corner-down-right"] = "rbxassetid://86512767702085",
	["lucide-corner-left-down"] = "rbxassetid://139876989150630",
	["lucide-corner-left-up"] = "rbxassetid://126228268096099",
	["lucide-corner-right-down"] = "rbxassetid://89237035551302",
	["lucide-corner-right-up"] = "rbxassetid://112851237026705",
	["lucide-corner-up-left"] = "rbxassetid://84669279763024",
	["lucide-corner-up-right"] = "rbxassetid://115099889693145",
	["lucide-cpu"] = "rbxassetid://77549309870247",
	["lucide-creative-commons"] = "rbxassetid://90408210735312",
	["lucide-credit-card"] = "rbxassetid://99163352872346",
	["lucide-croissant"] = "rbxassetid://130710485559420",
	["lucide-crop"] = "rbxassetid://116344601101413",
	["lucide-cross"] = "rbxassetid://101833377863588",
	["lucide-crosshair"] = "rbxassetid://134242818164054",
	["lucide-crown"] = "rbxassetid://127843403295538",
	["lucide-cuboid"] = "rbxassetid://75618807946111",
	["lucide-cup-soda"] = "rbxassetid://121098640829562",
	["lucide-currency"] = "rbxassetid://90551250119972",
	["lucide-cylinder"] = "rbxassetid://90569677179169",
	["lucide-dam"] = "rbxassetid://76874486231393",
	["lucide-database-backup"] = "rbxassetid://103403210984699",
	["lucide-database-zap"] = "rbxassetid://131199921258418",
	["lucide-database"] = "rbxassetid://126791525623846",
	["lucide-decimals-arrow-left"] = "rbxassetid://120198500638749",
	["lucide-decimals-arrow-right"] = "rbxassetid://118263047146797",
	["lucide-delete"] = "rbxassetid://126279426372342",
	["lucide-dessert"] = "rbxassetid://71508133278830",
	["lucide-diameter"] = "rbxassetid://97429051503783",
	["lucide-diamond-minus"] = "rbxassetid://128989071438290",
	["lucide-diamond-percent"] = "rbxassetid://107717860105959",
	["lucide-diamond-plus"] = "rbxassetid://134701163723675",
	["lucide-diamond"] = "rbxassetid://105846996304890",
	["lucide-dice-1"] = "rbxassetid://112650149591038",
	["lucide-dice-2"] = "rbxassetid://112278274566793",
	["lucide-dice-3"] = "rbxassetid://118526270626312",
	["lucide-dice-4"] = "rbxassetid://113365650364004",
	["lucide-dice-5"] = "rbxassetid://72768312430593",
	["lucide-dice-6"] = "rbxassetid://85376239182543",
	["lucide-dices"] = "rbxassetid://81268120302865",
	["lucide-diff"] = "rbxassetid://135052708609715",
	["lucide-disc-2"] = "rbxassetid://91419420404185",
	["lucide-disc-3"] = "rbxassetid://135470554736048",
	["lucide-disc-album"] = "rbxassetid://74693460404344",
	["lucide-disc"] = "rbxassetid://101908120120777",
	["lucide-divide"] = "rbxassetid://136678191878278",
	["lucide-dna-off"] = "rbxassetid://89612426361540",
	["lucide-dna"] = "rbxassetid://74007982981741",
	["lucide-dock"] = "rbxassetid://121997427160252",
	["lucide-dog"] = "rbxassetid://71920105558570",
	["lucide-dollar-sign"] = "rbxassetid://127320961224019",
	["lucide-donut"] = "rbxassetid://72204922742657",
	["lucide-door-closed-locked"] = "rbxassetid://74027613267551",
	["lucide-door-closed"] = "rbxassetid://136249099949073",
	["lucide-door-open"] = "rbxassetid://91306356501736",
	["lucide-dot"] = "rbxassetid://137321056643916",
	["lucide-download"] = "rbxassetid://134814648082393",
	["lucide-drafting-compass"] = "rbxassetid://99701976182841",
	["lucide-drama"] = "rbxassetid://110297795801577",
	["lucide-dribbble"] = "rbxassetid://80231809663849",
	["lucide-drill"] = "rbxassetid://108644821412796",
	["lucide-drone"] = "rbxassetid://117299095794783",
	["lucide-droplet-off"] = "rbxassetid://119365002225172",
	["lucide-droplet"] = "rbxassetid://100597455015098",
	["lucide-droplets"] = "rbxassetid://140111846025180",
	["lucide-drum"] = "rbxassetid://136979060344890",
	["lucide-drumstick"] = "rbxassetid://104662462521709",
	["lucide-dumbbell"] = "rbxassetid://80277236776212",
	["lucide-ear-off"] = "rbxassetid://87421916192807",
	["lucide-ear"] = "rbxassetid://121894949934209",
	["lucide-earth-lock"] = "rbxassetid://88814147073745",
	["lucide-earth"] = "rbxassetid://76231597751076",
	["lucide-eclipse"] = "rbxassetid://114829622118222",
	["lucide-egg-fried"] = "rbxassetid://90622538210545",
	["lucide-egg-off"] = "rbxassetid://92288321309285",
	["lucide-egg"] = "rbxassetid://117851493400222",
	["lucide-ellipsis-vertical"] = "rbxassetid://117978708573781",
	["lucide-ellipsis"] = "rbxassetid://140019550645825",
	["lucide-equal-approximately"] = "rbxassetid://105382689698323",
	["lucide-equal-not"] = "rbxassetid://76864449458032",
	["lucide-equal"] = "rbxassetid://123467780715624",
	["lucide-eraser"] = "rbxassetid://133957773112410",
	["lucide-ethernet-port"] = "rbxassetid://75391715149314",
	["lucide-euro"] = "rbxassetid://72229646524456",
	["lucide-ev-charger"] = "rbxassetid://97906158859623",
	["lucide-expand"] = "rbxassetid://137492887754537",
	["lucide-external-link"] = "rbxassetid://129331830773832",
	["lucide-eye-closed"] = "rbxassetid://111063268625789",
	["lucide-eye-off"] = "rbxassetid://135928786788378",
	["lucide-eye"] = "rbxassetid://100033680381365",
	["lucide-facebook"] = "rbxassetid://72098528632192",
	["lucide-factory"] = "rbxassetid://102170024318039",
	["lucide-fan"] = "rbxassetid://78391400440696",
	["lucide-fast-forward"] = "rbxassetid://121615540167909",
	["lucide-feather"] = "rbxassetid://91872927606406",
	["lucide-fence"] = "rbxassetid://123451565578029",
	["lucide-ferris-wheel"] = "rbxassetid://79729205796176",
	["lucide-figma"] = "rbxassetid://134182122852301",
	["lucide-file-archive"] = "rbxassetid://77018106869967",
	["lucide-file-axis-3d"] = "rbxassetid://133912328009885",
	["lucide-file-badge"] = "rbxassetid://74564895394477",
	["lucide-file-box"] = "rbxassetid://119264004071690",
	["lucide-file-braces-corner"] = "rbxassetid://77253337986109",
	["lucide-file-braces"] = "rbxassetid://95314128621234",
	["lucide-file-chart-column-increasing"] = "rbxassetid://134449481172067",
	["lucide-file-chart-column"] = "rbxassetid://82048481252560",
	["lucide-file-chart-line"] = "rbxassetid://71954360551345",
	["lucide-file-chart-pie"] = "rbxassetid://81072193564497",
	["lucide-file-check-corner"] = "rbxassetid://76295552859171",
	["lucide-file-check"] = "rbxassetid://82604001452455",
	["lucide-file-clock"] = "rbxassetid://102325208830990",
	["lucide-file-code-corner"] = "rbxassetid://78293841184371",
	["lucide-file-code"] = "rbxassetid://130978036895504",
	["lucide-file-cog"] = "rbxassetid://101385347151368",
	["lucide-file-diff"] = "rbxassetid://96147216772241",
	["lucide-file-digit"] = "rbxassetid://89220220354580",
	["lucide-file-down"] = "rbxassetid://120650154178290",
	["lucide-file-exclamation-point"] = "rbxassetid://102821865889635",
	["lucide-file-headphone"] = "rbxassetid://100533735901986",
	["lucide-file-heart"] = "rbxassetid://132214916401696",
	["lucide-file-image"] = "rbxassetid://123334057511782",
	["lucide-file-input"] = "rbxassetid://124728604166044",
	["lucide-file-key"] = "rbxassetid://118790255921100",
	["lucide-file-lock"] = "rbxassetid://72170228691242",
	["lucide-file-minus-corner"] = "rbxassetid://119263271735124",
	["lucide-file-minus"] = "rbxassetid://111014798459222",
	["lucide-file-music"] = "rbxassetid://134948051536671",
	["lucide-file-output"] = "rbxassetid://92146832572911",
	["lucide-file-pen-line"] = "rbxassetid://104622936345006",
	["lucide-file-pen"] = "rbxassetid://79556179730240",
	["lucide-file-play"] = "rbxassetid://89006821567838",
	["lucide-file-plus-corner"] = "rbxassetid://76544604043974",
	["lucide-file-plus"] = "rbxassetid://78881710800060",
	["lucide-file-question-mark"] = "rbxassetid://127617422859576",
	["lucide-file-scan"] = "rbxassetid://129480105228213",
	["lucide-file-search-corner"] = "rbxassetid://90974165234008",
	["lucide-file-search"] = "rbxassetid://97780235974933",
	["lucide-file-signal"] = "rbxassetid://122070252538165",
	["lucide-file-sliders"] = "rbxassetid://85787771732439",
	["lucide-file-spreadsheet"] = "rbxassetid://134501869359270",
	["lucide-file-stack"] = "rbxassetid://138929929862605",
	["lucide-file-symlink"] = "rbxassetid://91865722036510",
	["lucide-file-terminal"] = "rbxassetid://116757454755476",
	["lucide-file-text"] = "rbxassetid://90496405707281",
	["lucide-file-type-corner"] = "rbxassetid://124902230275209",
	["lucide-file-type"] = "rbxassetid://115272552799361",
	["lucide-file-up"] = "rbxassetid://131173039312748",
	["lucide-file-user"] = "rbxassetid://99552018455009",
	["lucide-file-video-camera"] = "rbxassetid://81719056173960",
	["lucide-file-volume"] = "rbxassetid://111264764438958",
	["lucide-file-x-corner"] = "rbxassetid://87554136773609",
	["lucide-file-x"] = "rbxassetid://107333775515154",
	["lucide-file"] = "rbxassetid://74748492079329",
	["lucide-files"] = "rbxassetid://102806336233202",
	["lucide-film"] = "rbxassetid://120978945609706",
	["lucide-fingerprint"] = "rbxassetid://112173305232811",
	["lucide-fire-extinguisher"] = "rbxassetid://111643493006960",
	["lucide-fish-off"] = "rbxassetid://89756724887508",
	["lucide-fish-symbol"] = "rbxassetid://118475177681618",
	["lucide-fish"] = "rbxassetid://124360663785796",
	["lucide-flag-off"] = "rbxassetid://112944528856799",
	["lucide-flag"] = "rbxassetid://78183383236196",
	["lucide-flame-kindling"] = "rbxassetid://139728976917928",
	["lucide-flame"] = "rbxassetid://98218034436456",
	["lucide-flashlight-off"] = "rbxassetid://79780362871740",
	["lucide-flashlight"] = "rbxassetid://100286985600444",
	["lucide-flask-conical-off"] = "rbxassetid://112597970025298",
	["lucide-flask-conical"] = "rbxassetid://128406680901165",
	["lucide-flask-round"] = "rbxassetid://127508287324940",
	["lucide-flower-2"] = "rbxassetid://72934574245145",
	["lucide-flower"] = "rbxassetid://86129438272762",
	["lucide-focus"] = "rbxassetid://87493973153317",
	["lucide-fold-horizontal"] = "rbxassetid://92835712442240",
	["lucide-fold-vertical"] = "rbxassetid://108873727253656",
	["lucide-folder-archive"] = "rbxassetid://97312009460206",
	["lucide-folder-check"] = "rbxassetid://128492920904557",
	["lucide-folder-clock"] = "rbxassetid://111964836738545",
	["lucide-folder-closed"] = "rbxassetid://118286209350843",
	["lucide-folder-code"] = "rbxassetid://70624096349370",
	["lucide-folder-cog"] = "rbxassetid://85299519462846",
	["lucide-folder-dot"] = "rbxassetid://138687772725278",
	["lucide-folder-down"] = "rbxassetid://118044108459225",
	["lucide-folder-git-2"] = "rbxassetid://101394054141166",
	["lucide-folder-git"] = "rbxassetid://121885778095158",
	["lucide-folder-heart"] = "rbxassetid://79104747211105",
	["lucide-folder-input"] = "rbxassetid://90699920697871",
	["lucide-folder-kanban"] = "rbxassetid://78313285104072",
	["lucide-folder-key"] = "rbxassetid://85270407596791",
	["lucide-folder-lock"] = "rbxassetid://119201572260567",
	["lucide-folder-minus"] = "rbxassetid://85648718999010",
	["lucide-folder-open-dot"] = "rbxassetid://74741494767354",
	["lucide-folder-open"] = "rbxassetid://76018996254888",
	["lucide-folder-output"] = "rbxassetid://101532447937612",
	["lucide-folder-pen"] = "rbxassetid://112770491173911",
	["lucide-folder-plus"] = "rbxassetid://91865663406119",
	["lucide-folder-root"] = "rbxassetid://103333751154693",
	["lucide-folder-search"] = "rbxassetid://110568075123861",
	["lucide-folder-symlink"] = "rbxassetid://127485747227189",
	["lucide-folder-sync"] = "rbxassetid://91544602659796",
	["lucide-folder-tree"] = "rbxassetid://85577554337861",
	["lucide-folder-up"] = "rbxassetid://72008269765857",
	["lucide-folder-x"] = "rbxassetid://91699618247635",
	["lucide-folder"] = "rbxassetid://80846616596607",
	["lucide-folders"] = "rbxassetid://110351216219061",
	["lucide-footprints"] = "rbxassetid://139192589041315",
	["lucide-forklift"] = "rbxassetid://72030930983101",
	["lucide-forward"] = "rbxassetid://97545944739523",
	["lucide-frame"] = "rbxassetid://109080612832751",
	["lucide-framer"] = "rbxassetid://108384807262391",
	["lucide-frown"] = "rbxassetid://124407301067982",
	["lucide-fuel"] = "rbxassetid://106447647274511",
	["lucide-fullscreen"] = "rbxassetid://77793665526178",
	["lucide-funnel-plus"] = "rbxassetid://100780233821928",
	["lucide-funnel-x"] = "rbxassetid://70984385812555",
	["lucide-funnel"] = "rbxassetid://108829540827529",
	["lucide-gallery-horizontal-end"] = "rbxassetid://74672430161161",
	["lucide-gallery-horizontal"] = "rbxassetid://80004001442122",
	["lucide-gallery-thumbnails"] = "rbxassetid://136219289862706",
	["lucide-gallery-vertical-end"] = "rbxassetid://106461402088317",
	["lucide-gallery-vertical"] = "rbxassetid://119299431466725",
	["lucide-gamepad-2"] = "rbxassetid://92483947987410",
	["lucide-gamepad-directional"] = "rbxassetid://84342305212226",
	["lucide-gamepad"] = "rbxassetid://121607283959010",
	["lucide-gauge"] = "rbxassetid://110273524101447",
	["lucide-gavel"] = "rbxassetid://78952298198456",
	["lucide-gem"] = "rbxassetid://112904952151156",
	["lucide-georgian-lari"] = "rbxassetid://98084432591687",
	["lucide-ghost"] = "rbxassetid://113822048130017",
	["lucide-gift"] = "rbxassetid://109855212076373",
	["lucide-git-branch-minus"] = "rbxassetid://97385010649411",
	["lucide-git-branch-plus"] = "rbxassetid://125944221134316",
	["lucide-git-branch"] = "rbxassetid://90490195516649",
	["lucide-git-commit-horizontal"] = "rbxassetid://133646041800147",
	["lucide-git-commit-vertical"] = "rbxassetid://122098032990350",
	["lucide-git-compare-arrows"] = "rbxassetid://84874426520216",
	["lucide-git-compare"] = "rbxassetid://91945124438792",
	["lucide-git-fork"] = "rbxassetid://89954992404765",
	["lucide-git-graph"] = "rbxassetid://86166832019304",
	["lucide-git-merge"] = "rbxassetid://131833355158059",
	["lucide-git-pull-request-arrow"] = "rbxassetid://94507974577439",
	["lucide-git-pull-request-closed"] = "rbxassetid://78070600389091",
	["lucide-git-pull-request-create-arrow"] = "rbxassetid://127422677061091",
	["lucide-git-pull-request-create"] = "rbxassetid://105929577383926",
	["lucide-git-pull-request-draft"] = "rbxassetid://76173459869943",
	["lucide-git-pull-request"] = "rbxassetid://138463010991471",
	["lucide-github"] = "rbxassetid://120349554354380",
	["lucide-gitlab"] = "rbxassetid://114054627192933",
	["lucide-glass-water"] = "rbxassetid://115526102400988",
	["lucide-glasses"] = "rbxassetid://87936407455373",
	["lucide-globe-lock"] = "rbxassetid://134065526704402",
	["lucide-globe"] = "rbxassetid://114238209622913",
	["lucide-goal"] = "rbxassetid://120517954878160",
	["lucide-gpu"] = "rbxassetid://95577823614219",
	["lucide-graduation-cap"] = "rbxassetid://93771896340220",
	["lucide-grape"] = "rbxassetid://134760640415561",
	["lucide-grid-2x2-check"] = "rbxassetid://138468840220821",
	["lucide-grid-2x2-plus"] = "rbxassetid://91811610580247",
	["lucide-grid-2x2-x"] = "rbxassetid://72407303981388",
	["lucide-grid-2x2"] = "rbxassetid://99050491897640",
	["lucide-grid-3x2"] = "rbxassetid://95528684210010",
	["lucide-grid-3x3"] = "rbxassetid://70419024781206",
	["lucide-grip-horizontal"] = "rbxassetid://136255899715930",
	["lucide-grip-vertical"] = "rbxassetid://137183678565296",
	["lucide-grip"] = "rbxassetid://109058783556768",
	["lucide-group"] = "rbxassetid://107643418926671",
	["lucide-guitar"] = "rbxassetid://75915531867926",
	["lucide-ham"] = "rbxassetid://74465607934635",
	["lucide-hamburger"] = "rbxassetid://93086916815495",
	["lucide-hammer"] = "rbxassetid://83545120140895",
	["lucide-hand-coins"] = "rbxassetid://126990543175462",
	["lucide-hand-fist"] = "rbxassetid://83341608917591",
	["lucide-hand-grab"] = "rbxassetid://88867162163985",
	["lucide-hand-heart"] = "rbxassetid://117507367668412",
	["lucide-hand-helping"] = "rbxassetid://89897738419446",
	["lucide-hand-metal"] = "rbxassetid://113619498548713",
	["lucide-hand-platter"] = "rbxassetid://88594727743168",
	["lucide-hand"] = "rbxassetid://130703864968637",
	["lucide-handbag"] = "rbxassetid://135675846264061",
	["lucide-handshake"] = "rbxassetid://78442115255814",
	["lucide-hard-drive-download"] = "rbxassetid://73913801230614",
	["lucide-hard-drive-upload"] = "rbxassetid://85762133615118",
	["lucide-hard-drive"] = "rbxassetid://88183305858463",
	["lucide-hard-hat"] = "rbxassetid://128050846767382",
	["lucide-hash"] = "rbxassetid://82890331678520",
	["lucide-hat-glasses"] = "rbxassetid://101165538224815",
	["lucide-haze"] = "rbxassetid://108857561768901",
	["lucide-hdmi-port"] = "rbxassetid://103693661037020",
	["lucide-heading-1"] = "rbxassetid://118129315662110",
	["lucide-heading-2"] = "rbxassetid://110209069670094",
	["lucide-heading-3"] = "rbxassetid://90267885237062",
	["lucide-heading-4"] = "rbxassetid://129625620307602",
	["lucide-heading-5"] = "rbxassetid://120386663181267",
	["lucide-heading-6"] = "rbxassetid://90959079775093",
	["lucide-heading"] = "rbxassetid://129254312067735",
	["lucide-headphone-off"] = "rbxassetid://85038251615641",
	["lucide-headphones"] = "rbxassetid://118833729589183",
	["lucide-headset"] = "rbxassetid://129269236787694",
	["lucide-heart-crack"] = "rbxassetid://110987638564119",
	["lucide-heart-minus"] = "rbxassetid://96827380163326",
	["lucide-heart-off"] = "rbxassetid://89748414415617",
	["lucide-heart-plus"] = "rbxassetid://94877796283249",
	["lucide-heart-pulse"] = "rbxassetid://129352925579546",
	["lucide-heart"] = "rbxassetid://116559368303288",
	["lucide-heater"] = "rbxassetid://140478466880916",
	["lucide-helicopter"] = "rbxassetid://111557171735930",
	["lucide-hexagon"] = "rbxassetid://127592089339199",
	["lucide-highlighter"] = "rbxassetid://77411555641113",
	["lucide-history"] = "rbxassetid://123980022019922",
	["lucide-hop-off"] = "rbxassetid://103386036934034",
	["lucide-hop"] = "rbxassetid://82778923997672",
	["lucide-hospital"] = "rbxassetid://105868763850707",
	["lucide-hotel"] = "rbxassetid://132283390859718",
	["lucide-hourglass"] = "rbxassetid://86160434939203",
	["lucide-home"] = "rbxassetid://98755624629571",
	["lucide-house-heart"] = "rbxassetid://136054771868597",
	["lucide-house-plug"] = "rbxassetid://71438263712075",
	["lucide-house-plus"] = "rbxassetid://118495165208309",
	["lucide-house-wifi"] = "rbxassetid://126495519725698",
	["lucide-ice-cream-bowl"] = "rbxassetid://124867218454386",
	["lucide-ice-cream-cone"] = "rbxassetid://90751397288639",
	["lucide-id-card-lanyard"] = "rbxassetid://90761480469224",
	["lucide-id-card"] = "rbxassetid://75354294622640",
	["lucide-image-down"] = "rbxassetid://78972295741235",
	["lucide-image-minus"] = "rbxassetid://101066016918565",
	["lucide-image-off"] = "rbxassetid://81934811700938",
	["lucide-image-play"] = "rbxassetid://129501806784210",
	["lucide-image-plus"] = "rbxassetid://70391970623917",
	["lucide-image-up"] = "rbxassetid://126610009605241",
	["lucide-image-upscale"] = "rbxassetid://106963545024679",
	["lucide-images"] = "rbxassetid://79350649395557",
	["lucide-import"] = "rbxassetid://116545008906029",
	["lucide-inbox"] = "rbxassetid://112591360302868",
	["lucide-indian-rupee"] = "rbxassetid://113038778381805",
	["lucide-infinity"] = "rbxassetid://98083086936965",
	["lucide-info"] = "rbxassetid://124560466474914",
	["lucide-inspection-panel"] = "rbxassetid://70905313146088",
	["lucide-instagram"] = "rbxassetid://119864798614855",
	["lucide-italic"] = "rbxassetid://96220378864282",
	["lucide-iteration-ccw"] = "rbxassetid://140221832794083",
	["lucide-iteration-cw"] = "rbxassetid://95534489554662",
	["lucide-japanese-yen"] = "rbxassetid://106362863465813",
	["lucide-joystick"] = "rbxassetid://99416790224739",
	["lucide-kanban"] = "rbxassetid://125934100055431",
	["lucide-kayak"] = "rbxassetid://136107544609389",
	["lucide-key-round"] = "rbxassetid://83619031955390",
	["lucide-key-square"] = "rbxassetid://94621420033649",
	["lucide-key"] = "rbxassetid://96510194465420",
	["lucide-keyboard-music"] = "rbxassetid://121058541758636",
	["lucide-keyboard-off"] = "rbxassetid://92466375369772",
	["lucide-keyboard"] = "rbxassetid://121474456068237",
	["lucide-lamp-ceiling"] = "rbxassetid://80032758469141",
	["lucide-lamp-desk"] = "rbxassetid://85290686983238",
	["lucide-lamp-floor"] = "rbxassetid://104585881375892",
	["lucide-lamp-wall-down"] = "rbxassetid://91271394132073",
	["lucide-lamp-wall-up"] = "rbxassetid://132141464337445",
	["lucide-lamp"] = "rbxassetid://110730830653382",
	["lucide-land-plot"] = "rbxassetid://96449039620294",
	["lucide-landmark"] = "rbxassetid://76885079756393",
	["lucide-languages"] = "rbxassetid://90816903776498",
	["lucide-laptop-minimal-check"] = "rbxassetid://114352019833865",
	["lucide-laptop-minimal"] = "rbxassetid://136705765566068",
	["lucide-laptop"] = "rbxassetid://111387063244975",
	["lucide-lasso-select"] = "rbxassetid://105609719912753",
	["lucide-lasso"] = "rbxassetid://121072936884007",
	["lucide-laugh"] = "rbxassetid://104491311361166",
	["lucide-layers-2"] = "rbxassetid://70536710516357",
	["lucide-layers"] = "rbxassetid://81973586053257",
	["lucide-layout-dashboard"] = "rbxassetid://139929981863901",
	["lucide-layout-grid"] = "rbxassetid://81344910161871",
	["lucide-layout-list"] = "rbxassetid://87462136296578",
	["lucide-layout-panel-left"] = "rbxassetid://125092469751491",
	["lucide-layout-panel-top"] = "rbxassetid://91943941515944",
	["lucide-layout-template"] = "rbxassetid://115564446417985",
	["lucide-leaf"] = "rbxassetid://119951075637174",
	["lucide-leafy-green"] = "rbxassetid://105146290493154",
	["lucide-lectern"] = "rbxassetid://106166425183862",
	["lucide-library-big"] = "rbxassetid://106794530191412",
	["lucide-library"] = "rbxassetid://114334671982047",
	["lucide-life-buoy"] = "rbxassetid://81168450671956",
	["lucide-ligature"] = "rbxassetid://111397873269411",
	["lucide-lightbulb-off"] = "rbxassetid://83795722296178",
	["lucide-lightbulb"] = "rbxassetid://103871245626488",
	["lucide-line-squiggle"] = "rbxassetid://109555164424447",
	["lucide-link-2-off"] = "rbxassetid://76885956296867",
	["lucide-link-2"] = "rbxassetid://86072351557466",
	["lucide-link"] = "rbxassetid://131607023382430",
	["lucide-linkedin"] = "rbxassetid://132842789255788",
	["lucide-list-check"] = "rbxassetid://72374358471156",
	["lucide-list-checks"] = "rbxassetid://99809353635593",
	["lucide-list-chevrons-down-up"] = "rbxassetid://137409641500711",
	["lucide-list-chevrons-up-down"] = "rbxassetid://81825351389084",
	["lucide-list-collapse"] = "rbxassetid://124505247702401",
	["lucide-list-end"] = "rbxassetid://77650610048119",
	["lucide-list-filter-plus"] = "rbxassetid://96385120752336",
	["lucide-list-filter"] = "rbxassetid://103321376129527",
	["lucide-list-indent-decrease"] = "rbxassetid://137879979228193",
	["lucide-list-indent-increase"] = "rbxassetid://79051053161201",
	["lucide-list-minus"] = "rbxassetid://138507965142671",
	["lucide-list-music"] = "rbxassetid://126380635781840",
	["lucide-list-ordered"] = "rbxassetid://83212528113913",
	["lucide-list-plus"] = "rbxassetid://112384738137814",
	["lucide-list-restart"] = "rbxassetid://91703153577421",
	["lucide-list-start"] = "rbxassetid://84828348299727",
	["lucide-list-todo"] = "rbxassetid://132980603752108",
	["lucide-list-tree"] = "rbxassetid://97685396239010",
	["lucide-list-video"] = "rbxassetid://93648525452489",
	["lucide-list-x"] = "rbxassetid://113025303988861",
	["lucide-list"] = "rbxassetid://113179976918783",
	["lucide-loader-circle"] = "rbxassetid://116535712789945",
	["lucide-loader-pinwheel"] = "rbxassetid://108513357940900",
	["lucide-loader"] = "rbxassetid://78408734580845",
	["lucide-locate-fixed"] = "rbxassetid://137367361548433",
	["lucide-locate-off"] = "rbxassetid://73729216338137",
	["lucide-locate"] = "rbxassetid://84467676590391",
	["lucide-lock-keyhole-open"] = "rbxassetid://110863509313073",
	["lucide-lock-keyhole"] = "rbxassetid://78672912777756",
	["lucide-lock-open"] = "rbxassetid://93597915325122",
	["lucide-lock"] = "rbxassetid://134724289526879",
	["lucide-log-in"] = "rbxassetid://103768533135201",
	["lucide-log-out"] = "rbxassetid://84895399304975",
	["lucide-logs"] = "rbxassetid://89772091251787",
	["lucide-lollipop"] = "rbxassetid://84681611583044",
	["lucide-luggage"] = "rbxassetid://76619236486400",
	["lucide-magnet"] = "rbxassetid://135162361226972",
	["lucide-mail-check"] = "rbxassetid://86921536259917",
	["lucide-mail-minus"] = "rbxassetid://81989813236553",
	["lucide-mail-open"] = "rbxassetid://122785416858638",
	["lucide-mail-plus"] = "rbxassetid://104886401588341",
	["lucide-mail-question-mark"] = "rbxassetid://126540170949819",
	["lucide-mail-search"] = "rbxassetid://135616173775287",
	["lucide-mail-warning"] = "rbxassetid://81495303676089",
	["lucide-mail-x"] = "rbxassetid://74607841705644",
	["lucide-mail"] = "rbxassetid://103945161245599",
	["lucide-mailbox"] = "rbxassetid://82765503320335",
	["lucide-mails"] = "rbxassetid://90673453450080",
	["lucide-map-minus"] = "rbxassetid://129525760577747",
	["lucide-map-pin-check-inside"] = "rbxassetid://107130529843809",
	["lucide-map-pin-check"] = "rbxassetid://118110914690154",
	["lucide-map-pin-house"] = "rbxassetid://80546885029816",
	["lucide-map-pin-minus-inside"] = "rbxassetid://79005529692964",
	["lucide-map-pin-minus"] = "rbxassetid://74518762643623",
	["lucide-map-pin-off"] = "rbxassetid://82474689391020",
	["lucide-map-pin-pen"] = "rbxassetid://113515395277504",
	["lucide-map-pin-plus-inside"] = "rbxassetid://134639656514430",
	["lucide-map-pin-plus"] = "rbxassetid://91875228967029",
	["lucide-map-pin-x-inside"] = "rbxassetid://126235934252379",
	["lucide-map-pin-x"] = "rbxassetid://101085273547316",
	["lucide-map-pin"] = "rbxassetid://84279202219901",
	["lucide-map-pinned"] = "rbxassetid://103963788475034",
	["lucide-map-plus"] = "rbxassetid://129388826743495",
	["lucide-map"] = "rbxassetid://95107167260947",
	["lucide-mars-stroke"] = "rbxassetid://131973193186828",
	["lucide-mars"] = "rbxassetid://111287112372511",
	["lucide-martini"] = "rbxassetid://82977695401058",
	["lucide-maximize-2"] = "rbxassetid://73085922906397",
	["lucide-maximize"] = "rbxassetid://76045941763188",
	["lucide-medal"] = "rbxassetid://79016002264450",
	["lucide-megaphone-off"] = "rbxassetid://124280774193935",
	["lucide-megaphone"] = "rbxassetid://118759541854879",
	["lucide-meh"] = "rbxassetid://132197867028557",
	["lucide-memory-stick"] = "rbxassetid://93212591343119",
	["lucide-menu"] = "rbxassetid://77021539815611",
	["lucide-merge"] = "rbxassetid://126201866476775",
	["lucide-message-circle-code"] = "rbxassetid://112865244991651",
	["lucide-message-circle-dashed"] = "rbxassetid://81525157881897",
	["lucide-message-circle-heart"] = "rbxassetid://101990756073677",
	["lucide-message-circle-more"] = "rbxassetid://92856823884663",
	["lucide-message-circle-off"] = "rbxassetid://134955643890328",
	["lucide-message-circle-plus"] = "rbxassetid://106562979649273",
	["lucide-message-circle-question-mark"] = "rbxassetid://107700302759934",
	["lucide-message-circle-reply"] = "rbxassetid://137071749508334",
	["lucide-message-circle-warning"] = "rbxassetid://119020096067894",
	["lucide-message-circle-x"] = "rbxassetid://126843387725536",
	["lucide-message-circle"] = "rbxassetid://127255077587058",
	["lucide-message-square-code"] = "rbxassetid://110968863152123",
	["lucide-message-square-dashed"] = "rbxassetid://107653455516238",
	["lucide-message-square-diff"] = "rbxassetid://75472190472625",
	["lucide-message-square-dot"] = "rbxassetid://127806382463916",
	["lucide-message-square-heart"] = "rbxassetid://75612811742074",
	["lucide-message-square-lock"] = "rbxassetid://81268215619563",
	["lucide-message-square-more"] = "rbxassetid://120139782405970",
	["lucide-message-square-off"] = "rbxassetid://99961019005789",
	["lucide-message-square-plus"] = "rbxassetid://76934450256199",
	["lucide-message-square-quote"] = "rbxassetid://116670768629340",
	["lucide-message-square-reply"] = "rbxassetid://130985622754637",
	["lucide-message-square-share"] = "rbxassetid://131017005324026",
	["lucide-message-square-text"] = "rbxassetid://94899503194205",
	["lucide-message-square-warning"] = "rbxassetid://138432903962261",
	["lucide-message-square-x"] = "rbxassetid://137285463279462",
	["lucide-message-square"] = "rbxassetid://83881670383280",
	["lucide-messages-square"] = "rbxassetid://97532166733358",
	["lucide-mic-off"] = "rbxassetid://82123034444822",
	["lucide-mic-vocal"] = "rbxassetid://99082286164362",
	["lucide-mic"] = "rbxassetid://89640799126523",
	["lucide-microchip"] = "rbxassetid://73937907669903",
	["lucide-microscope"] = "rbxassetid://116875530102782",
	["lucide-microwave"] = "rbxassetid://108411735353008",
	["lucide-milestone"] = "rbxassetid://101618292325920",
	["lucide-milk-off"] = "rbxassetid://72388480962742",
	["lucide-milk"] = "rbxassetid://96221903896918",
	["lucide-minimize-2"] = "rbxassetid://116269596042539",
	["lucide-minimize"] = "rbxassetid://121304296213645",
	["lucide-minus"] = "rbxassetid://118026365011536",
	["lucide-monitor-check"] = "rbxassetid://86651948439229",
	["lucide-monitor-cloud"] = "rbxassetid://85931096038318",
	["lucide-monitor-cog"] = "rbxassetid://94345128715799",
	["lucide-monitor-dot"] = "rbxassetid://130394010063680",
	["lucide-monitor-down"] = "rbxassetid://97466933743423",
	["lucide-monitor-off"] = "rbxassetid://74395526657953",
	["lucide-monitor-pause"] = "rbxassetid://76002184067562",
	["lucide-monitor-play"] = "rbxassetid://133018824306217",
	["lucide-monitor-smartphone"] = "rbxassetid://84335680433378",
	["lucide-monitor-speaker"] = "rbxassetid://81744810060380",
	["lucide-monitor-stop"] = "rbxassetid://98708958984757",
	["lucide-monitor-up"] = "rbxassetid://96035360858377",
	["lucide-monitor-x"] = "rbxassetid://126265210441423",
	["lucide-monitor"] = "rbxassetid://72664649203050",
	["lucide-moon-star"] = "rbxassetid://82782200506348",
	["lucide-moon"] = "rbxassetid://83380517901735",
	["lucide-motorbike"] = "rbxassetid://94580787368233",
	["lucide-mountain-snow"] = "rbxassetid://105315495740588",
	["lucide-mountain"] = "rbxassetid://73269957566415",
	["lucide-mouse-off"] = "rbxassetid://75267871697595",
	["lucide-mouse-pointer-2-off"] = "rbxassetid://104701076865632",
	["lucide-mouse-pointer-2"] = "rbxassetid://117093892862228",
	["lucide-mouse-pointer-ban"] = "rbxassetid://106849413057133",
	["lucide-mouse-pointer-click"] = "rbxassetid://107150227368485",
	["lucide-mouse-pointer"] = "rbxassetid://72322454962935",
	["lucide-mouse"] = "rbxassetid://73096068864710",
	["lucide-move-3d"] = "rbxassetid://103365982054003",
	["lucide-move-diagonal-2"] = "rbxassetid://117298577948096",
	["lucide-move-diagonal"] = "rbxassetid://101433481954184",
	["lucide-move-down-left"] = "rbxassetid://102819433534567",
	["lucide-move-down-right"] = "rbxassetid://101479760041877",
	["lucide-move-down"] = "rbxassetid://70510115135583",
	["lucide-move-horizontal"] = "rbxassetid://88513523439149",
	["lucide-move-left"] = "rbxassetid://137614740247980",
	["lucide-move-right"] = "rbxassetid://132455779472989",
	["lucide-move-up-left"] = "rbxassetid://139079815540148",
	["lucide-move-up-right"] = "rbxassetid://105885140592646",
	["lucide-move-up"] = "rbxassetid://84505444262658",
	["lucide-move-vertical"] = "rbxassetid://86234730730899",
	["lucide-move"] = "rbxassetid://116138709011735",
	["lucide-music-2"] = "rbxassetid://134397426600888",
	["lucide-music-3"] = "rbxassetid://94466120066498",
	["lucide-music-4"] = "rbxassetid://132459323665838",
	["lucide-music"] = "rbxassetid://113343203848535",
	["lucide-navigation-2-off"] = "rbxassetid://116569611780763",
	["lucide-navigation-2"] = "rbxassetid://81889066747907",
	["lucide-navigation-off"] = "rbxassetid://87003270290777",
	["lucide-navigation"] = "rbxassetid://79308213542922",
	["lucide-network"] = "rbxassetid://127410729922644",
	["lucide-newspaper"] = "rbxassetid://123479530460544",
	["lucide-nfc"] = "rbxassetid://76822396542242",
	["lucide-non-binary"] = "rbxassetid://78442360386235",
	["lucide-notebook-pen"] = "rbxassetid://140380614761023",
	["lucide-notebook-tabs"] = "rbxassetid://127371085570083",
	["lucide-notebook-text"] = "rbxassetid://93061585217270",
	["lucide-notebook"] = "rbxassetid://136132108664987",
	["lucide-notepad-text-dashed"] = "rbxassetid://135793446376219",
	["lucide-notepad-text"] = "rbxassetid://93404682958966",
	["lucide-nut-off"] = "rbxassetid://78795397311573",
	["lucide-nut"] = "rbxassetid://127146410705656",
	["lucide-octagon-alert"] = "rbxassetid://140438367956051",
	["lucide-octagon-minus"] = "rbxassetid://74720436795421",
	["lucide-octagon-pause"] = "rbxassetid://103161463909039",
	["lucide-octagon-x"] = "rbxassetid://90498161006311",
	["lucide-octagon"] = "rbxassetid://120803515514852",
	["lucide-omega"] = "rbxassetid://70414080018786",
	["lucide-option"] = "rbxassetid://100776883894054",
	["lucide-orbit"] = "rbxassetid://108926136860562",
	["lucide-origami"] = "rbxassetid://136020626667101",
	["lucide-package-2"] = "rbxassetid://70394974762575",
	["lucide-package-check"] = "rbxassetid://102374216055130",
	["lucide-package-minus"] = "rbxassetid://114492858789692",
	["lucide-package-open"] = "rbxassetid://132890233237818",
	["lucide-package-plus"] = "rbxassetid://129261988138366",
	["lucide-package-search"] = "rbxassetid://95465120894145",
	["lucide-package-x"] = "rbxassetid://70818501607442",
	["lucide-package"] = "rbxassetid://97261141732706",
	["lucide-paint-bucket"] = "rbxassetid://124275586663284",
	["lucide-paint-roller"] = "rbxassetid://115248074358348",
	["lucide-paintbrush-vertical"] = "rbxassetid://105151296591292",
	["lucide-paintbrush"] = "rbxassetid://125572663700289",
	["lucide-palette"] = "rbxassetid://86350350950064",
	["lucide-panda"] = "rbxassetid://132509022802512",
	["lucide-panel-bottom-close"] = "rbxassetid://74287004071159",
	["lucide-panel-bottom-dashed"] = "rbxassetid://131084651621603",
	["lucide-panel-bottom-open"] = "rbxassetid://107768659586540",
	["lucide-panel-bottom"] = "rbxassetid://132127145048511",
	["lucide-panel-left-close"] = "rbxassetid://126579818823552",
	["lucide-panel-left-dashed"] = "rbxassetid://75536606374585",
	["lucide-panel-left-open"] = "rbxassetid://111075816195767",
	["lucide-panel-left-right-dashed"] = "rbxassetid://110100707973959",
	["lucide-panel-left"] = "rbxassetid://97419752870313",
	["lucide-panel-right-close"] = "rbxassetid://139528655524132",
	["lucide-panel-right-dashed"] = "rbxassetid://94959793877311",
	["lucide-panel-right-open"] = "rbxassetid://118114419142794",
	["lucide-panel-right"] = "rbxassetid://116365035443156",
	["lucide-panel-top-bottom-dashed"] = "rbxassetid://134737235653344",
	["lucide-panel-top-close"] = "rbxassetid://83578325777808",
	["lucide-panel-top-dashed"] = "rbxassetid://70522913169237",
	["lucide-panel-top-open"] = "rbxassetid://137959875507454",
	["lucide-panel-top"] = "rbxassetid://75838479462875",
	["lucide-panels-left-bottom"] = "rbxassetid://72996856149149",
	["lucide-panels-right-bottom"] = "rbxassetid://90659068960726",
	["lucide-panels-top-left"] = "rbxassetid://79858853850600",
	["lucide-paperclip"] = "rbxassetid://92088291163453",
	["lucide-parentheses"] = "rbxassetid://78950955173096",
	["lucide-parking-meter"] = "rbxassetid://84652733960568",
	["lucide-party-popper"] = "rbxassetid://111626795712193",
	["lucide-pause"] = "rbxassetid://74873705394436",
	["lucide-paw-print"] = "rbxassetid://112218825427601",
	["lucide-pc-case"] = "rbxassetid://122978648019101",
	["lucide-pen-line"] = "rbxassetid://109108135755303",
	["lucide-pen-off"] = "rbxassetid://84807123119438",
	["lucide-pen-tool"] = "rbxassetid://106145404953445",
	["lucide-pen"] = "rbxassetid://72037878096321",
	["lucide-pencil-line"] = "rbxassetid://88392917053533",
	["lucide-pencil-off"] = "rbxassetid://103330927652832",
	["lucide-pencil-ruler"] = "rbxassetid://110120288284597",
	["lucide-pencil"] = "rbxassetid://137986121120732",
	["lucide-pentagon"] = "rbxassetid://79184802179890",
	["lucide-percent"] = "rbxassetid://130155041032013",
	["lucide-person-standing"] = "rbxassetid://125020872044147",
	["lucide-philippine-peso"] = "rbxassetid://91173798254675",
	["lucide-phone-call"] = "rbxassetid://70555587592860",
	["lucide-phone-forwarded"] = "rbxassetid://113269614319737",
	["lucide-phone-incoming"] = "rbxassetid://82863576359288",
	["lucide-phone-missed"] = "rbxassetid://130156165198376",
	["lucide-phone-off"] = "rbxassetid://133318623553383",
	["lucide-phone-outgoing"] = "rbxassetid://104576478735825",
	["lucide-phone"] = "rbxassetid://128804946640049",
	["lucide-pi"] = "rbxassetid://74936036243146",
	["lucide-piano"] = "rbxassetid://85008880789520",
	["lucide-pickaxe"] = "rbxassetid://105888023317688",
	["lucide-picture-in-picture-2"] = "rbxassetid://112803319544468",
	["lucide-picture-in-picture"] = "rbxassetid://80579597835123",
	["lucide-piggy-bank"] = "rbxassetid://79498575790721",
	["lucide-pilcrow-left"] = "rbxassetid://103803000849583",
	["lucide-pilcrow-right"] = "rbxassetid://104881733911870",
	["lucide-pilcrow"] = "rbxassetid://139512780392871",
	["lucide-pill-bottle"] = "rbxassetid://118394692404597",
	["lucide-pill"] = "rbxassetid://73280534813448",
	["lucide-pin-off"] = "rbxassetid://127696372451750",
	["lucide-pin"] = "rbxassetid://120978111007514",
	["lucide-pipette"] = "rbxassetid://133167932934404",
	["lucide-pizza"] = "rbxassetid://126964453193501",
	["lucide-plane-landing"] = "rbxassetid://122555692211889",
	["lucide-plane-takeoff"] = "rbxassetid://117179478829575",
	["lucide-plane"] = "rbxassetid://126985561580989",
	["lucide-play"] = "rbxassetid://135609604299893",
	["lucide-plug-2"] = "rbxassetid://97912386476366",
	["lucide-plug-zap"] = "rbxassetid://74506269884055",
	["lucide-plug"] = "rbxassetid://99782373064495",
	["lucide-plus"] = "rbxassetid://111774323017047",
	["lucide-pocket-knife"] = "rbxassetid://134075428063965",
	["lucide-pocket"] = "rbxassetid://136686762542964",
	["lucide-podcast"] = "rbxassetid://109577075549215",
	["lucide-pointer-off"] = "rbxassetid://95488389312794",
	["lucide-pointer"] = "rbxassetid://92615117311099",
	["lucide-popcorn"] = "rbxassetid://139446511232750",
	["lucide-popsicle"] = "rbxassetid://112696318077073",
	["lucide-pound-sterling"] = "rbxassetid://127482649469130",
	["lucide-power-off"] = "rbxassetid://118768311012214",
	["lucide-power"] = "rbxassetid://96479131758775",
	["lucide-presentation"] = "rbxassetid://106134583757890",
	["lucide-printer-check"] = "rbxassetid://130273549443689",
	["lucide-printer"] = "rbxassetid://76080649734247",
	["lucide-projector"] = "rbxassetid://103281856385283",
	["lucide-proportions"] = "rbxassetid://130046855997237",
	["lucide-puzzle"] = "rbxassetid://136837798892463",
	["lucide-pyramid"] = "rbxassetid://107811442374127",
	["lucide-qr-code"] = "rbxassetid://105329945723350",
	["lucide-quote"] = "rbxassetid://103271711590001",
	["lucide-rabbit"] = "rbxassetid://98580518804206",
	["lucide-radar"] = "rbxassetid://138528222906635",
	["lucide-radiation"] = "rbxassetid://104499586848433",
	["lucide-radical"] = "rbxassetid://132758286926047",
	["lucide-radio-receiver"] = "rbxassetid://129598303378835",
	["lucide-radio-tower"] = "rbxassetid://93958663130054",
	["lucide-radio"] = "rbxassetid://85611589536956",
	["lucide-radius"] = "rbxassetid://89814505307129",
	["lucide-rail-symbol"] = "rbxassetid://134295386306962",
	["lucide-rainbow"] = "rbxassetid://132488862841895",
	["lucide-rat"] = "rbxassetid://127400975953159",
	["lucide-ratio"] = "rbxassetid://126369423897295",
	["lucide-receipt-cent"] = "rbxassetid://91557573925201",
	["lucide-receipt-euro"] = "rbxassetid://94015722210295",
	["lucide-receipt-indian-rupee"] = "rbxassetid://89718170439990",
	["lucide-receipt-japanese-yen"] = "rbxassetid://132472560758851",
	["lucide-receipt-pound-sterling"] = "rbxassetid://73934967569625",
	["lucide-receipt-russian-ruble"] = "rbxassetid://105164576936853",
	["lucide-receipt-swiss-franc"] = "rbxassetid://72503668620116",
	["lucide-receipt-text"] = "rbxassetid://138483536013737",
	["lucide-receipt-turkish-lira"] = "rbxassetid://91950765836342",
	["lucide-receipt"] = "rbxassetid://77877895901792",
	["lucide-rectangle-circle"] = "rbxassetid://100642423153903",
	["lucide-rectangle-ellipsis"] = "rbxassetid://112919953980965",
	["lucide-rectangle-goggles"] = "rbxassetid://98605436666727",
	["lucide-rectangle-horizontal"] = "rbxassetid://90224199814966",
	["lucide-rectangle-vertical"] = "rbxassetid://117277050590967",
	["lucide-recycle"] = "rbxassetid://140417023381961",
	["lucide-redo-2"] = "rbxassetid://70451039017914",
	["lucide-redo-dot"] = "rbxassetid://94252981719732",
	["lucide-redo"] = "rbxassetid://116150342119054",
	["lucide-refresh-ccw-dot"] = "rbxassetid://106702246753270",
	["lucide-refresh-ccw"] = "rbxassetid://117913330389477",
	["lucide-refresh-cw-off"] = "rbxassetid://140179498843054",
	["lucide-refresh-cw"] = "rbxassetid://138133190015277",
	["lucide-refrigerator"] = "rbxassetid://102614042652753",
	["lucide-regex"] = "rbxassetid://100727200791841",
	["lucide-remove-formatting"] = "rbxassetid://112833162022628",
	["lucide-repeat-1"] = "rbxassetid://130144534857095",
	["lucide-repeat-2"] = "rbxassetid://85927537182704",
	["lucide-repeat"] = "rbxassetid://121886242955173",
	["lucide-replace-all"] = "rbxassetid://127862728198635",
	["lucide-replace"] = "rbxassetid://128404082279430",
	["lucide-reply-all"] = "rbxassetid://71723137343562",
	["lucide-reply"] = "rbxassetid://109788633497028",
	["lucide-rewind"] = "rbxassetid://95205297521988",
	["lucide-ribbon"] = "rbxassetid://94265331526851",
	["lucide-rocket"] = "rbxassetid://87412317685854",
	["lucide-rocking-chair"] = "rbxassetid://110420269495360",
	["lucide-roller-coaster"] = "rbxassetid://112426178972099",
	["lucide-rose"] = "rbxassetid://126336840238769",
	["lucide-rotate-3d"] = "rbxassetid://76300551576392",
	["lucide-rotate-ccw-key"] = "rbxassetid://74976035240976",
	["lucide-rotate-ccw-square"] = "rbxassetid://90515853170424",
	["lucide-rotate-ccw"] = "rbxassetid://110116685948665",
	["lucide-rotate-cw-square"] = "rbxassetid://77095448159303",
	["lucide-rotate-cw"] = "rbxassetid://84183336178654",
	["lucide-route-off"] = "rbxassetid://106350402024079",
	["lucide-route"] = "rbxassetid://89968303228953",
	["lucide-router"] = "rbxassetid://102130331994471",
	["lucide-rows-2"] = "rbxassetid://112556185960101",
	["lucide-rows-3"] = "rbxassetid://117215586961375",
	["lucide-rows-4"] = "rbxassetid://125646021959055",
	["lucide-rss"] = "rbxassetid://131789058984793",
	["lucide-ruler-dimension-line"] = "rbxassetid://70673861371412",
	["lucide-ruler"] = "rbxassetid://81432445547423",
	["lucide-russian-ruble"] = "rbxassetid://126357936542156",
	["lucide-sailboat"] = "rbxassetid://87110567187540",
	["lucide-salad"] = "rbxassetid://128864507821603",
	["lucide-sandwich"] = "rbxassetid://104573187458917",
	["lucide-satellite-dish"] = "rbxassetid://136742443888305",
	["lucide-satellite"] = "rbxassetid://134967053164645",
	["lucide-saudi-riyal"] = "rbxassetid://102282769104635",
	["lucide-save-all"] = "rbxassetid://116946975799440",
	["lucide-save-off"] = "rbxassetid://87085435778560",
	["lucide-save"] = "rbxassetid://126116963775616",
	["lucide-scale-3d"] = "rbxassetid://72414199620352",
	["lucide-scale"] = "rbxassetid://108203682317477",
	["lucide-scaling"] = "rbxassetid://122360365318466",
	["lucide-scan-barcode"] = "rbxassetid://96889457154761",
	["lucide-scan-eye"] = "rbxassetid://99244790601968",
	["lucide-scan-face"] = "rbxassetid://109959345069668",
	["lucide-scan-heart"] = "rbxassetid://106280819776142",
	["lucide-scan-line"] = "rbxassetid://126544908146540",
	["lucide-scan-qr-code"] = "rbxassetid://105409149549927",
	["lucide-scan-search"] = "rbxassetid://80009010551347",
	["lucide-scan-text"] = "rbxassetid://73702396787766",
	["lucide-scan"] = "rbxassetid://123104789658180",
	["lucide-school"] = "rbxassetid://76351530290068",
	["lucide-scissors-line-dashed"] = "rbxassetid://122237447974173",
	["lucide-scissors"] = "rbxassetid://118665510911274",
	["lucide-screen-share-off"] = "rbxassetid://107677572669805",
	["lucide-screen-share"] = "rbxassetid://85137895705653",
	["lucide-scroll-text"] = "rbxassetid://97321022666868",
	["lucide-scroll"] = "rbxassetid://74072101474951",
	["lucide-search-check"] = "rbxassetid://75442076191356",
	["lucide-search-code"] = "rbxassetid://117114794592802",
	["lucide-search-slash"] = "rbxassetid://96483932261041",
	["lucide-search-x"] = "rbxassetid://137319957522951",
	["lucide-search"] = "rbxassetid://121018724060431",
	["lucide-section"] = "rbxassetid://91732188298948",
	["lucide-send-horizontal"] = "rbxassetid://111734392411664",
	["lucide-send-to-back"] = "rbxassetid://75340312862253",
	["lucide-send"] = "rbxassetid://127751956873796",
	["lucide-separator-horizontal"] = "rbxassetid://84864453699927",
	["lucide-separator-vertical"] = "rbxassetid://84031801478581",
	["lucide-server-cog"] = "rbxassetid://138470287250966",
	["lucide-server-crash"] = "rbxassetid://132810618000212",
	["lucide-server-off"] = "rbxassetid://114048751507723",
	["lucide-server"] = "rbxassetid://92188766517878",
	["lucide-settings-2"] = "rbxassetid://135684703553372",
	["lucide-settings"] = "rbxassetid://80758916183665",
	["lucide-shapes"] = "rbxassetid://129989433311409",
	["lucide-share-2"] = "rbxassetid://71210767962065",
	["lucide-share"] = "rbxassetid://87340985053299",
	["lucide-sheet"] = "rbxassetid://134902122480171",
	["lucide-shell"] = "rbxassetid://140212943563599",
	["lucide-shield-alert"] = "rbxassetid://114995877719925",
	["lucide-shield-ban"] = "rbxassetid://108765041044649",
	["lucide-shield-check"] = "rbxassetid://87354736164608",
	["lucide-shield-ellipsis"] = "rbxassetid://114794739892123",
	["lucide-shield-half"] = "rbxassetid://117842634172647",
	["lucide-shield-minus"] = "rbxassetid://89965059528921",
	["lucide-shield-off"] = "rbxassetid://133426959132690",
	["lucide-shield-plus"] = "rbxassetid://100664857995498",
	["lucide-shield-question-mark"] = "rbxassetid://135722075265150",
	["lucide-shield-user"] = "rbxassetid://124832775645347",
	["lucide-shield-x"] = "rbxassetid://73370117343811",
	["lucide-shield"] = "rbxassetid://110987169760162",
	["lucide-ship-wheel"] = "rbxassetid://130797795829448",
	["lucide-ship"] = "rbxassetid://83995100553930",
	["lucide-shirt"] = "rbxassetid://106579555405966",
	["lucide-shopping-bag"] = "rbxassetid://71885477293226",
	["lucide-shopping-basket"] = "rbxassetid://138646411956433",
	["lucide-shopping-cart"] = "rbxassetid://128420521375441",
	["lucide-shovel"] = "rbxassetid://102465000512056",
	["lucide-shower-head"] = "rbxassetid://75884944024117",
	["lucide-shredder"] = "rbxassetid://122125164414463",
	["lucide-shrimp"] = "rbxassetid://102625900815307",
	["lucide-shrink"] = "rbxassetid://90953687918880",
	["lucide-shrub"] = "rbxassetid://127326280714343",
	["lucide-shuffle"] = "rbxassetid://132382786975101",
	["lucide-sigma"] = "rbxassetid://126884244870899",
	["lucide-signal-high"] = "rbxassetid://130436670012270",
	["lucide-signal-low"] = "rbxassetid://73674683500458",
	["lucide-signal-medium"] = "rbxassetid://125003021367019",
	["lucide-signal-zero"] = "rbxassetid://130045332414754",
	["lucide-signal"] = "rbxassetid://78424889355261",
	["lucide-signature"] = "rbxassetid://114402748013000",
	["lucide-signpost-big"] = "rbxassetid://115780185675001",
	["lucide-signpost"] = "rbxassetid://106584743791433",
	["lucide-siren"] = "rbxassetid://134210267818039",
	["lucide-skip-back"] = "rbxassetid://70466132711334",
	["lucide-skip-forward"] = "rbxassetid://124844823753990",
	["lucide-skull"] = "rbxassetid://137726256442333",
	["lucide-slack"] = "rbxassetid://96089719516736",
	["lucide-slash"] = "rbxassetid://117792185664263",
	["lucide-slice"] = "rbxassetid://95810504278179",
	["lucide-sliders-horizontal"] = "rbxassetid://85538382643347",
	["lucide-sliders-vertical"] = "rbxassetid://101190569086853",
	["lucide-smartphone-charging"] = "rbxassetid://102837532613995",
	["lucide-smartphone-nfc"] = "rbxassetid://82326425754446",
	["lucide-smartphone"] = "rbxassetid://96623008834511",
	["lucide-smile-plus"] = "rbxassetid://131981881472144",
	["lucide-smile"] = "rbxassetid://105880397565283",
	["lucide-snail"] = "rbxassetid://70904536548363",
	["lucide-snowflake"] = "rbxassetid://101235206534566",
	["lucide-soap-dispenser-droplet"] = "rbxassetid://77258480479465",
	["lucide-sofa"] = "rbxassetid://114427687218324",
	["lucide-solar-panel"] = "rbxassetid://132448188047921",
	["lucide-soup"] = "rbxassetid://115092551871618",
	["lucide-space"] = "rbxassetid://87072088914178",
	["lucide-spade"] = "rbxassetid://131444449466462",
	["lucide-sparkle"] = "rbxassetid://111044800239623",
	["lucide-sparkles"] = "rbxassetid://138635884129147",
	["lucide-speaker"] = "rbxassetid://96227183003618",
	["lucide-speech"] = "rbxassetid://87013139446349",
	["lucide-spell-check-2"] = "rbxassetid://81556731785534",
	["lucide-spell-check"] = "rbxassetid://91913483031334",
	["lucide-spline-pointer"] = "rbxassetid://84842840956804",
	["lucide-spline"] = "rbxassetid://129406685807412",
	["lucide-split"] = "rbxassetid://105112438805988",
	["lucide-spool"] = "rbxassetid://124541981347743",
	["lucide-spotlight"] = "rbxassetid://77571742539344",
	["lucide-spray-can"] = "rbxassetid://128372039366326",
	["lucide-sprout"] = "rbxassetid://100091687832508",
	["lucide-square-activity"] = "rbxassetid://89496630185293",
	["lucide-square-arrow-down-left"] = "rbxassetid://108194680296901",
	["lucide-square-arrow-down-right"] = "rbxassetid://99403846801050",
	["lucide-square-arrow-down"] = "rbxassetid://135962519626588",
	["lucide-square-arrow-left"] = "rbxassetid://111671474549238",
	["lucide-square-arrow-out-down-left"] = "rbxassetid://125714881756353",
	["lucide-square-arrow-out-down-right"] = "rbxassetid://89971003001390",
	["lucide-square-arrow-out-up-left"] = "rbxassetid://103759986579087",
	["lucide-square-arrow-out-up-right"] = "rbxassetid://91221896066807",
	["lucide-square-arrow-right"] = "rbxassetid://113920471701361",
	["lucide-square-arrow-up-left"] = "rbxassetid://112424670290693",
	["lucide-square-arrow-up-right"] = "rbxassetid://76602291406940",
	["lucide-square-arrow-up"] = "rbxassetid://106998604646718",
	["lucide-square-asterisk"] = "rbxassetid://89186832353625",
	["lucide-square-bottom-dashed-scissors"] = "rbxassetid://79076980104803",
	["lucide-square-chart-gantt"] = "rbxassetid://104034017316411",
    ["lucide-square-check-big"] = "rbxassetid://115320390907184",
	["lucide-square-check"] = "rbxassetid://134682053539509",
	["lucide-square-chevron-down"] = "rbxassetid://91032307924592",
	["lucide-square-chevron-left"] = "rbxassetid://73143404829510",
	["lucide-square-chevron-right"] = "rbxassetid://90612077729930",
	["lucide-square-chevron-up"] = "rbxassetid://85565910197337",
	["lucide-square-code"] = "rbxassetid://81604576616881",
	["lucide-square-dashed-bottom-code"] = "rbxassetid://100354801563230",
	["lucide-square-dashed-bottom"] = "rbxassetid://101102319625624",
	["lucide-square-dashed-kanban"] = "rbxassetid://90388067649847",
	["lucide-square-dashed-mouse-pointer"] = "rbxassetid://121016142178467",
	["lucide-square-dashed-top-solid"] = "rbxassetid://117157577548540",
	["lucide-square-dashed"] = "rbxassetid://136905537847606",
	["lucide-square-divide"] = "rbxassetid://99894657101970",
	["lucide-square-dot"] = "rbxassetid://116613421354866",
	["lucide-square-equal"] = "rbxassetid://110283363706707",
	["lucide-square-function"] = "rbxassetid://86075219551088",
	["lucide-square-kanban"] = "rbxassetid://114537101260131",
	["lucide-square-library"] = "rbxassetid://73810931222081",
	["lucide-square-m"] = "rbxassetid://117662700410577",
	["lucide-square-menu"] = "rbxassetid://104067089444415",
	["lucide-square-minus"] = "rbxassetid://116764432015770",
	["lucide-square-mouse-pointer"] = "rbxassetid://76141850603920",
	["lucide-square-parking-off"] = "rbxassetid://100857293535141",
	["lucide-square-parking"] = "rbxassetid://133116656122387",
	["lucide-square-pause"] = "rbxassetid://86608552787615",
	["lucide-square-pen"] = "rbxassetid://120239476110475",
	["lucide-square-percent"] = "rbxassetid://87111930314567",
	["lucide-square-pi"] = "rbxassetid://75383328781618",
	["lucide-square-pilcrow"] = "rbxassetid://131854284699367",
	["lucide-square-play"] = "rbxassetid://108186325238481",
	["lucide-square-plus"] = "rbxassetid://114713264461873",
	["lucide-square-power"] = "rbxassetid://129240437805187",
	["lucide-square-radical"] = "rbxassetid://132645931868292",
	["lucide-square-round-corner"] = "rbxassetid://104592745113567",
	["lucide-square-scissors"] = "rbxassetid://110601255612411",
	["lucide-square-sigma"] = "rbxassetid://113231244246816",
	["lucide-square-slash"] = "rbxassetid://105477013908757",
	["lucide-square-split-horizontal"] = "rbxassetid://76095370148660",
	["lucide-square-split-vertical"] = "rbxassetid://88589192032058",
	["lucide-square-square"] = "rbxassetid://136555087357875",
	["lucide-square-stack"] = "rbxassetid://100463396619394",
	["lucide-square-star"] = "rbxassetid://94506958703720",
	["lucide-square-stop"] = "rbxassetid://80018708472943",
	["lucide-square-terminal"] = "rbxassetid://83969264476798",
	["lucide-square-user-round"] = "rbxassetid://86484997229302",
	["lucide-square-user"] = "rbxassetid://70771214183445",
	["lucide-square-x"] = "rbxassetid://125136183850190",
	["lucide-square"] = "rbxassetid://86304921356806",
	["lucide-squares-exclude"] = "rbxassetid://102345385822324",
	["lucide-squares-intersect"] = "rbxassetid://120869602570119",
	["lucide-squares-subtract"] = "rbxassetid://131484650948795",
	["lucide-squares-unite"] = "rbxassetid://96673080107843",
	["lucide-squircle-dashed"] = "rbxassetid://129936702532522",
	["lucide-squircle"] = "rbxassetid://82426632573807",
	["lucide-squirrel"] = "rbxassetid://112864252085343",
	["lucide-stamp"] = "rbxassetid://92370779813368",
	["lucide-star-half"] = "rbxassetid://117449275562979",
	["lucide-star-off"] = "rbxassetid://75742832732503",
	["lucide-star"] = "rbxassetid://136141469398409",
	["lucide-step-back"] = "rbxassetid://108672750005121",
	["lucide-step-forward"] = "rbxassetid://126131872136145",
	["lucide-stethoscope"] = "rbxassetid://122331031702148",
	["lucide-sticker"] = "rbxassetid://79938203791608",
	["lucide-sticky-note"] = "rbxassetid://111894074643919",
	["lucide-store"] = "rbxassetid://90338129673705",
	["lucide-stretch-horizontal"] = "rbxassetid://87665042192343",
	["lucide-stretch-vertical"] = "rbxassetid://95265463417122",
	["lucide-strikethrough"] = "rbxassetid://103417324549613",
	["lucide-subscript"] = "rbxassetid://74553514785183",
	["lucide-sun-dim"] = "rbxassetid://129141645592715",
	["lucide-sun-medium"] = "rbxassetid://130278807964710",
	["lucide-sun-moon"] = "rbxassetid://75752898854559",
	["lucide-sun-snow"] = "rbxassetid://112791898014579",
	["lucide-sun"] = "rbxassetid://110150589884127",
	["lucide-sunrise"] = "rbxassetid://134705665494098",
	["lucide-sunset"] = "rbxassetid://75904872203588",
	["lucide-superscript"] = "rbxassetid://96887696590118",
	["lucide-swatch-book"] = "rbxassetid://126786244872453",
	["lucide-swiss-franc"] = "rbxassetid://113497920041625",
	["lucide-switch-camera"] = "rbxassetid://76841154349737",
	["lucide-sword"] = "rbxassetid://124448418211665",
	["lucide-swords"] = "rbxassetid://81872698913435",
	["lucide-syringe"] = "rbxassetid://123891270479254",
	["lucide-table-2"] = "rbxassetid://95751552281545",
	["lucide-table-cells-merge"] = "rbxassetid://95363715175258",
	["lucide-table-cells-split"] = "rbxassetid://114799086088649",
	["lucide-table-columns-split"] = "rbxassetid://111011625447949",
	["lucide-table-of-contents"] = "rbxassetid://135044763275414",
	["lucide-table-properties"] = "rbxassetid://125062886015372",
	["lucide-table-rows-split"] = "rbxassetid://96443733673997",
	["lucide-table"] = "rbxassetid://109109148250737",
	["lucide-tablet-smartphone"] = "rbxassetid://133680859813404",
	["lucide-tablet"] = "rbxassetid://128403991264386",
	["lucide-tablets"] = "rbxassetid://80835787970735",
	["lucide-tag"] = "rbxassetid://129104970103940",
	["lucide-tags"] = "rbxassetid://107179263080798",
	["lucide-tally-1"] = "rbxassetid://115301298241643",
	["lucide-tally-2"] = "rbxassetid://110363186864027",
	["lucide-tally-3"] = "rbxassetid://97655344572540",
	["lucide-tally-4"] = "rbxassetid://102633494371890",
	["lucide-tally-5"] = "rbxassetid://88031817475886",
	["lucide-tangent"] = "rbxassetid://123263132981724",
	["lucide-target"] = "rbxassetid://87563802520297",
	["lucide-telescope"] = "rbxassetid://91755049143647",
	["lucide-tent-tree"] = "rbxassetid://76698322463977",
	["lucide-tent"] = "rbxassetid://109779587826330",
	["lucide-terminal"] = "rbxassetid://106783148545356",
	["lucide-test-tube-diagonal"] = "rbxassetid://75662704378840",
	["lucide-test-tube"] = "rbxassetid://98801015650164",
	["lucide-test-tubes"] = "rbxassetid://92555361447433",
	["lucide-text-align-center"] = "rbxassetid://84051028246390",
	["lucide-text-align-end"] = "rbxassetid://130041738343555",
	["lucide-text-align-justify"] = "rbxassetid://80279880143030",
	["lucide-text-align-start"] = "rbxassetid://134489585487649",
	["lucide-text-cursor-input"] = "rbxassetid://107551944047171",
	["lucide-text-cursor"] = "rbxassetid://115984654447300",
	["lucide-text-initial"] = "rbxassetid://129458097472087",
	["lucide-text-quote"] = "rbxassetid://139278366448736",
	["lucide-text-search"] = "rbxassetid://92345384671606",
	["lucide-text-select"] = "rbxassetid://117087320884956",
	["lucide-text-wrap"] = "rbxassetid://114804318314018",
	["lucide-theater"] = "rbxassetid://108558145549163",
	["lucide-thermometer-snowflake"] = "rbxassetid://121876188028425",
	["lucide-thermometer-sun"] = "rbxassetid://106693240074310",
	["lucide-thermometer"] = "rbxassetid://106546011492311",
	["lucide-thumbs-down"] = "rbxassetid://87794009914015",
	["lucide-thumbs-up"] = "rbxassetid://111137070767020",
	["lucide-ticket-check"] = "rbxassetid://105428777212507",
	["lucide-ticket-minus"] = "rbxassetid://78966299769328",
	["lucide-ticket-percent"] = "rbxassetid://80834774406405",
	["lucide-ticket-plus"] = "rbxassetid://110086734392189",
	["lucide-ticket-slash"] = "rbxassetid://89045681172265",
	["lucide-ticket-x"] = "rbxassetid://88674114109926",
	["lucide-ticket"] = "rbxassetid://126527071492145",
	["lucide-tickets-plane"] = "rbxassetid://100367018248695",
	["lucide-tickets"] = "rbxassetid://135268612687833",
	["lucide-timer-off"] = "rbxassetid://110916370767271",
	["lucide-timer-reset"] = "rbxassetid://110052125369932",
	["lucide-timer"] = "rbxassetid://85473888890506",
	["lucide-toggle-left"] = "rbxassetid://85887872573050",
	["lucide-toggle-right"] = "rbxassetid://90411952142550",
	["lucide-toilet"] = "rbxassetid://80930782432931",
	["lucide-tool-case"] = "rbxassetid://87533537832522",
	["lucide-tornado"] = "rbxassetid://88358291515768",
	["lucide-torus"] = "rbxassetid://70855707283051",
	["lucide-touchpad-off"] = "rbxassetid://78784008075456",
	["lucide-touchpad"] = "rbxassetid://74882354908014",
	["lucide-tower-control"] = "rbxassetid://95937619060532",
	["lucide-toy-brick"] = "rbxassetid://86293483924633",
	["lucide-tractor"] = "rbxassetid://103376704722051",
	["lucide-traffic-cone"] = "rbxassetid://74110220470369",
	["lucide-train-front-tunnel"] = "rbxassetid://105194827005114",
	["lucide-train-front"] = "rbxassetid://125237934215370",
	["lucide-train-track"] = "rbxassetid://77451032453723",
	["lucide-tram-front"] = "rbxassetid://93315182364998",
	["lucide-transgender"] = "rbxassetid://135530817673639",
	["lucide-trash-2"] = "rbxassetid://109843431391323",
	["lucide-trash"] = "rbxassetid://106723740584310",
	["lucide-tree-deciduous"] = "rbxassetid://123124389219004",
	["lucide-tree-palm"] = "rbxassetid://103846705893963",
	["lucide-tree-pine"] = "rbxassetid://124662547202594",
	["lucide-trees"] = "rbxassetid://121203841375919",
	["lucide-trello"] = "rbxassetid://130987241149527",
	["lucide-trending-down"] = "rbxassetid://139309232226438",
	["lucide-trending-up-down"] = "rbxassetid://85083293981691",
	["lucide-trending-up"] = "rbxassetid://81819858538839",
	["lucide-triangle-alert"] = "rbxassetid://125920361880643",
	["lucide-triangle-dashed"] = "rbxassetid://124324079103935",
	["lucide-triangle-right"] = "rbxassetid://116930791412791",
	["lucide-triangle"] = "rbxassetid://126330486745540",
	["lucide-trophy"] = "rbxassetid://131545003268773",
	["lucide-truck-electric"] = "rbxassetid://111873446387359",
	["lucide-truck"] = "rbxassetid://86662707764771",
	["lucide-turkish-lira"] = "rbxassetid://114589876174070",
	["lucide-turntable"] = "rbxassetid://129870346487856",
	["lucide-turtle"] = "rbxassetid://118295081560334",
	["lucide-tv-minimal-play"] = "rbxassetid://99201833426972",
	["lucide-tv-minimal"] = "rbxassetid://100382201729427",
	["lucide-tv"] = "rbxassetid://135687724791776",
	["lucide-twitch"] = "rbxassetid://71383308134888",
	["lucide-twitter"] = "rbxassetid://88791703276842",
	["lucide-type-outline"] = "rbxassetid://80108627791690",
	["lucide-type"] = "rbxassetid://133543553793564",
	["lucide-umbrella-off"] = "rbxassetid://72395143739955",
	["lucide-umbrella"] = "rbxassetid://127502210274589",
	["lucide-underline"] = "rbxassetid://123709229216544",
	["lucide-undo-2"] = "rbxassetid://113885292059932",
	["lucide-undo-dot"] = "rbxassetid://132055277744844",
	["lucide-undo"] = "rbxassetid://111258459077271",
	["lucide-unfold-horizontal"] = "rbxassetid://117128358526398",
	["lucide-unfold-vertical"] = "rbxassetid://116593025265499",
	["lucide-ungroup"] = "rbxassetid://106674800451003",
	["lucide-university"] = "rbxassetid://84652528263642",
	["lucide-unlink-2"] = "rbxassetid://128131898892572",
	["lucide-unlink"] = "rbxassetid://139835795227752",
	["lucide-unplug"] = "rbxassetid://90171381619874",
	["lucide-upload"] = "rbxassetid://138212042425501",
	["lucide-usb"] = "rbxassetid://117230058949613",
	["lucide-user-check"] = "rbxassetid://81775205032725",
	["lucide-user-cog"] = "rbxassetid://92795491530865",
	["lucide-user-lock"] = "rbxassetid://78892639693821",
	["lucide-user-minus"] = "rbxassetid://126976941957511",
	["lucide-user-pen"] = "rbxassetid://87445472574836",
	["lucide-user-plus"] = "rbxassetid://118514469915884",
	["lucide-user-round-check"] = "rbxassetid://118794737621941",
	["lucide-user-round-cog"] = "rbxassetid://78239503290053",
	["lucide-user-round-minus"] = "rbxassetid://98944176636447",
	["lucide-user-round-pen"] = "rbxassetid://108155244324878",
	["lucide-user-round-plus"] = "rbxassetid://113301899567470",
	["lucide-user-round-search"] = "rbxassetid://71565774381870",
	["lucide-user-round-x"] = "rbxassetid://122367980560930",
	["lucide-user-round"] = "rbxassetid://136485052187963",
	["lucide-user-search"] = "rbxassetid://101335649828115",
	["lucide-user-star"] = "rbxassetid://98777846316000",
	["lucide-user-x"] = "rbxassetid://139748155894754",
	["lucide-user"] = "rbxassetid://81589895647169",
	["lucide-users-round"] = "rbxassetid://103005444008339",
	["lucide-users"] = "rbxassetid://115398113982385",
	["lucide-utensils-crossed"] = "rbxassetid://109520762270383",
	["lucide-utensils"] = "rbxassetid://139952569804235",
	["lucide-utility-pole"] = "rbxassetid://101965541238242",
	["lucide-variable"] = "rbxassetid://104743088438151",
	["lucide-vault"] = "rbxassetid://108049164599845",
	["lucide-vector-square"] = "rbxassetid://86713728565344",
	["lucide-vegan"] = "rbxassetid://119489190688082",
	["lucide-venetian-mask"] = "rbxassetid://102636443033920",
	["lucide-venus-and-mars"] = "rbxassetid://120227752103771",
	["lucide-venus"] = "rbxassetid://82891342220859",
	["lucide-vibrate-off"] = "rbxassetid://113446447326246",
	["lucide-vibrate"] = "rbxassetid://108330910738733",
	["lucide-video-off"] = "rbxassetid://132239189859305",
	["lucide-video"] = "rbxassetid://107587444636945",
	["lucide-videotape"] = "rbxassetid://114816894323398",
	["lucide-view"] = "rbxassetid://118717253976805",
	["lucide-voicemail"] = "rbxassetid://134313454010227",
	["lucide-volleyball"] = "rbxassetid://83889351124153",
	["lucide-volume-1"] = "rbxassetid://98514588731639",
	["lucide-volume-2"] = "rbxassetid://89344380902620",
	["lucide-volume-off"] = "rbxassetid://103047478058767",
	["lucide-volume-x"] = "rbxassetid://139252359189540",
	["lucide-volume"] = "rbxassetid://103236289817396",
	["lucide-vote"] = "rbxassetid://89409762851246",
	["lucide-wallet-cards"] = "rbxassetid://129728715308337",
	["lucide-wallet-minimal"] = "rbxassetid://137800448816116",
	["lucide-wallet"] = "rbxassetid://132331555762628",
	["lucide-wallpaper"] = "rbxassetid://74682121235494",
	["lucide-wand-sparkles"] = "rbxassetid://82546429942392",
	["lucide-wand"] = "rbxassetid://114580617777835",
	["lucide-warehouse"] = "rbxassetid://78388887451080",
	["lucide-washing-machine"] = "rbxassetid://104194127573858",
	["lucide-watch"] = "rbxassetid://130544621618405",
	["lucide-waves-ladder"] = "rbxassetid://101808619355514",
	["lucide-waves"] = "rbxassetid://96340135183647",
	["lucide-waypoints"] = "rbxassetid://102450133666017",
	["lucide-webcam"] = "rbxassetid://104148487911129",
	["lucide-webhook-off"] = "rbxassetid://96370548093471",
	["lucide-webhook"] = "rbxassetid://112812457747322",
	["lucide-weight"] = "rbxassetid://103860559844854",
	["lucide-wheat-off"] = "rbxassetid://133294844612307",
	["lucide-wheat"] = "rbxassetid://85261952080359",
	["lucide-whole-word"] = "rbxassetid://90111083954485",
	["lucide-wifi-cog"] = "rbxassetid://110500263326209",
	["lucide-wifi-high"] = "rbxassetid://81954601342139",
	["lucide-wifi-low"] = "rbxassetid://138217335635913",
	["lucide-wifi-off"] = "rbxassetid://74113634330106",
	["lucide-wifi-pen"] = "rbxassetid://91290205064712",
	["lucide-wifi-sync"] = "rbxassetid://84043971055177",
	["lucide-wifi-zero"] = "rbxassetid://124286465246123",
	["lucide-wifi"] = "rbxassetid://104669375183960",
	["lucide-wind-arrow-down"] = "rbxassetid://127753987414870",
	["lucide-wind"] = "rbxassetid://114551690399915",
	["lucide-wine-off"] = "rbxassetid://108294164302317",
	["lucide-wine"] = "rbxassetid://115743721332829",
	["lucide-workflow"] = "rbxassetid://99186544029189",
	["lucide-worm"] = "rbxassetid://115752311548091",
	["lucide-wrench"] = "rbxassetid://112148279212860",
	["lucide-x"] = "rbxassetid://110786993356448",
	["lucide-youtube"] = "rbxassetid://123663668456341",
	["lucide-zap-off"] = "rbxassetid://81385483183652",
	["lucide-zap"] = "rbxassetid://130551565616516",
	["lucide-zoom-in"] = "rbxassetid://127956924984803",
	["lucide-zoom-out"] = "rbxassetid://108334162607319",
	["lucide-balloon"] = "rbxassetid://97489111621526",
	["lucide-beef-off"] = "rbxassetid://99869959725200",
	["lucide-book-search"] = "rbxassetid://132585409504950",
	["lucide-calendars"] = "rbxassetid://130944763042289",
	["lucide-cannabis-off"] = "rbxassetid://101938500363812",
	["lucide-cctv-off"] = "rbxassetid://75925370187295",
	["lucide-cigarette"] = "rbxassetid://137149549886852",
	["lucide-circle-pile"] = "rbxassetid://116353155251541",
	["lucide-cloud-backup"] = "rbxassetid://111649579696132",
	["lucide-cloud-sync"] = "rbxassetid://79393911188593",
	["lucide-database-search"] = "rbxassetid://92017137080138",
	["lucide-ellipse"] = "rbxassetid://71559658267482",
	["lucide-fingerprint-pattern"] = "rbxassetid://80934710831288",
	["lucide-fishing-hook"] = "rbxassetid://121038780855899",
	["lucide-fishing-rod"] = "rbxassetid://71754848048049",
	["lucide-form"] = "rbxassetid://72999643971000",
	["lucide-git-merge-conflict"] = "rbxassetid://85677801675703",
	["lucide-globe-off"] = "rbxassetid://77775243585824",
	["lucide-globe-x"] = "rbxassetid://109268097029296",
	["lucide-hd"] = "rbxassetid://71682790698278",
	["lucide-image"] = "rbxassetid://112751259236831",
	["lucide-layers-plus"] = "rbxassetid://77587765623057",
	["lucide-lens-concave"] = "rbxassetid://94819631937027",
	["lucide-lens-convex"] = "rbxassetid://74736504195474",
	["lucide-line-dot-right-horizontal"] = "rbxassetid://104718593155221",
	["lucide-line-style"] = "rbxassetid://90176717785772",
	["lucide-map-pin-search"] = "rbxassetid://89065012915078",
	["lucide-message-circle-check"] = "rbxassetid://132772297689418",
	["lucide-message-square-check"] = "rbxassetid://125789987055668",
	["lucide-metronome"] = "rbxassetid://101991829345965",
	["lucide-mirror-rectangular"] = "rbxassetid://109046769760336",
	["lucide-mirror-round"] = "rbxassetid://121534049429097",
	["lucide-mouse-left"] = "rbxassetid://99144293708743",
	["lucide-mouse-right"] = "rbxassetid://88331710212594",
	["lucide-printer-x"] = "rbxassetid://103002721801548",
	["lucide-radio-off"] = "rbxassetid://80359258046586",
	["lucide-road"] = "rbxassetid://120251329173530",
	["lucide-scooter"] = "rbxassetid://100035452787934",
	["lucide-search-alert"] = "rbxassetid://127597984617505",
	["lucide-shelving-unit"] = "rbxassetid://80116568514793",
	["lucide-shield-cog-corner"] = "rbxassetid://111694066132698",
	["lucide-shield-cog"] = "rbxassetid://129235695057857",
	["lucide-sport-shoe"] = "rbxassetid://120495992692630",
	["lucide-square-arrow-right-enter"] = "rbxassetid://138867831495334",
	["lucide-square-arrow-right-exit"] = "rbxassetid://133688575845430",
	["lucide-square-centerline-dashed-horizontal"] = "rbxassetid://77780104374341",
	["lucide-square-centerline-dashed-vertical"] = "rbxassetid://107878435803525",
	["lucide-stone"] = "rbxassetid://135161057497830",
	["lucide-toolbox"] = "rbxassetid://85341033903792",
	["lucide-towel-rack"] = "rbxassetid://125223915620991",
	["lucide-user-key"] = "rbxassetid://105403041782190",
	["lucide-user-round-key"] = "rbxassetid://124547549008939",
	["lucide-van"] = "rbxassetid://122066377022942",
	["lucide-waves-arrow-down"] = "rbxassetid://129215220911792",
	["lucide-waves-arrow-up"] = "rbxassetid://102314705716217",
	["lucide-weight-tilde"] = "rbxassetid://112081212176951",
	["lucide-x-line-top"] = "rbxassetid://140592656289509",
	["lucide-zodiac-aquarius"] = "rbxassetid://74560047770362",
	["lucide-zodiac-aries"] = "rbxassetid://73255859670234",
	["lucide-zodiac-cancer"] = "rbxassetid://131985162532947",
	["lucide-zodiac-capricorn"] = "rbxassetid://97859568140652",
	["lucide-zodiac-gemini"] = "rbxassetid://80997588122992",
	["lucide-zodiac-leo"] = "rbxassetid://75509406718106",
	["lucide-zodiac-libra"] = "rbxassetid://113222735060218",
	["lucide-zodiac-ophiuchus"] = "rbxassetid://129180108892480",
	["lucide-zodiac-pisces"] = "rbxassetid://95845819440327",
	["lucide-zodiac-sagittarius"] = "rbxassetid://82651026742181",
	["lucide-zodiac-scorpio"] = "rbxassetid://113640924054631",
	["lucide-zodiac-taurus"] = "rbxassetid://123053219704400",
	["lucide-zodiac-virgo"] = "rbxassetid://99462994613661",
};

Fatality.IsPC = not UserInputService.TouchEnabled;

Fatality.Dummy = {}
local function GetDummy() return Fatality.Dummy end

setmetatable(Fatality.Dummy, {
	__index = function(self, key) return function() return self end end,
    __newindex = function() end
})
Fatality.Dummy.Option = Fatality.Dummy 
Fatality.Dummy.Set = function() end
Fatality.Dummy.Refresh = function() end
Fatality.Dummy.SetValue = function() end
Fatality.Dummy.GetValue = function() return nil end

function Fatality:CanShow(Config)
    if Config and Config.OnlyPC and not Fatality.IsPC then return false end
    return true
end

Fatality.WindowFlags = {};

function Fatality:IsMobile() : boolean return UserInputService.TouchEnabled; end;

function Fatality:RandomString() : string
	return string.char(math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102));	
end;

function Fatality:GetTextSize(Text : TextLabel,CustomFont: Enum.Font) : Vector2
	return TextService:GetTextSize(Text.Text,Text.TextSize,(Text.Font ~= Enum.Font.Unknown and Text.Font) or (CustomFont or Enum.Font.GothamMedium),Vector2.new(math.huge,math.huge));
end;

function Fatality:IsMouseOverFrame(Frame : Frame) : boolean
	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;
	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

function Fatality:GetCalculatePosition(planePos: number, planeNormal: Vector3, rayOrigin: number, rayDirection: Vector3) : number
	local n: Vector3 = planeNormal;
	local d: Vector3 = rayDirection;
	local v: Vector3 = rayOrigin - planePos;

	local num: number = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den: number = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a: number = -num / den;

	return rayOrigin + (a * rayDirection);
end;

function Fatality:CreateHover(Element : Frame,Callback : (boolean) -> any)
	Element.MouseEnter:Connect(function() Callback(true); end);
	Element.MouseLeave:Connect(function() Callback(false); end);
end;

function Fatality:GetIcon(name : string) : string
	return Fatality.Lucide['lucide-'..tostring(name)] or Fatality.Lucide[name] or Fatality.Lucide[tostring(name)] or "";
end;

function Fatality:SetIcon(name : string, value : string)
	Fatality.Lucide[name] = value;
end;

function Fatality:Rounding(num: number, numDecimalPlaces: number) : number
	local mult: number = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end;

function Fatality:CreateAnimation(Instance: Instance , Time: number , Style : Enum.EasingStyle , Property : {[string] : any}) : Tween
	if not Property then
		if typeof(Style) == 'table' then Property = Style; Style = nil; end;
	end;

	if Instance:IsA("UIStroke") and Property.Transparency ~= nil then
		if Property.Transparency < 0.65 then Property.Transparency = 0.65 end
	end

	for key, value in pairs(Property) do
		if typeof(value) == "ColorSequence" then
			if value.Keypoints and value.Keypoints[1] then
				Property[key] = value.Keypoints[1].Value
			end
		end
	end

	local Tween: Tween = TweenService:Create(Instance,TweenInfo.new(Time or 1 , Style or Enum.EasingStyle.Quint),Property);
	Tween:Play();
	return Tween;
end;

function Fatality:NewInput(Frame : Frame , Callback : () -> ()) : TextButton
	local Button = Instance.new('TextButton',Frame);
	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.TextTransparency = 1;
	if Callback then Button.MouseButton1Click:Connect(Callback); end;
	return Button;
end;

function Fatality:Drag(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;

	local function updateInput(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
		Fatality:CreateAnimation(MoveFrame,Speed,nil,{ Position = position });
	end;

	InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and #Fatality.DragBlacklist <= 0 then 
			dragToggle = true
			dragStart = input.Position
			startPos = MoveFrame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch and #Fatality.DragBlacklist <= 0 then
			if dragToggle then updateInput(input) end
		else
			if #Fatality.DragBlacklist > 0 then dragToggle = false end
		end
	end);
end;

function Fatality:ScrollSignal(Scroll: ScrollingFrame,UIListLayout: UIListLayout,Type:string)
	Scroll.ScrollBarThickness = 0
	Scroll.ScrollBarImageTransparency = 1
	Scroll.AutomaticCanvasSize = Enum.AutomaticSize.None

	if Type == 'X' then
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Scroll.CanvasSize = UDim2.fromOffset(math.round(UIListLayout.AbsoluteContentSize.X / Fatality.Scale), 0)
		end)
	else
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Scroll.CanvasSize = UDim2.fromOffset(0, math.round(UIListLayout.AbsoluteContentSize.Y / Fatality.Scale))
		end)
	end;
end;

function Fatality:CreateResponse(args: {[string] : (any) -> any})
	local main = {};
	for i,v in next , args do
		if typeof(v) == 'function' then main[i] = function(self , ...) return v(...); end;
		else main[i] = v; end;
	end;
	return main;
end;

function Fatality:GetWindowFromElement(Element: GuiObject)
	for i,v in next , Fatality.Windows do
		if Element:IsDescendantOf(v) then return v; end;
	end;
end;

function Fatality:CreateOption(OptionButton: ImageButton): Elements
	Fatality:CreateHover(OptionButton,function(bool)
		if bool then Fatality:CreateAnimation(OptionButton,0.5,{ ImageTransparency = 0.3 })
		else Fatality:CreateAnimation(OptionButton,0.5,{ ImageTransparency = 0.600 }) end;
	end);

	local Bindable = Instance.new('BindableEvent');
	local OwnWindow = Fatality:GetWindowFromElement(OptionButton);
	local ExtElementFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local SpaceBox = Instance.new("Frame")

	Fatality:ScrollSignal(ScrollingFrame,UIListLayout,'Y');

	ExtElementFrame.Active = true;
	ExtElementFrame.Name = Fatality:RandomString()
	ExtElementFrame.Parent = OwnWindow
	ExtElementFrame.AnchorPoint = Vector2.new(0.5, 0)
	Fatality:Register(ExtElementFrame, "Container") 
	ExtElementFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExtElementFrame.BorderSizePixel = 0
	ExtElementFrame.ClipsDescendants = true
	ExtElementFrame.Position = UDim2.new(2, 0, 2, 0)
	ExtElementFrame.Size = UDim2.new(0, 200, 0, 0)
	ExtElementFrame.ZIndex = 100
	local OptScale = Instance.new("UIScale", ExtElementFrame) 
	OptScale.Scale = Fatality.Scale
	table.insert(Fatality.ScalesRegistry, OptScale)

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ExtElementFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	Fatality:Register(UIStroke, "Stroke", "Color")
	UIStroke.Parent = ExtElementFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = ExtElementFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 99
	DropShadow.Image = "rbxassetid://6014261993"
	Fatality:Register(DropShadow, "Outline", "ImageColor3") 
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = ExtElementFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ClipsDescendants = false
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, 0, 1, -5)
	ScrollingFrame.ZIndex = 109
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	SpaceBox.Name = Fatality:RandomString()
	SpaceBox.Parent = ScrollingFrame
	SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SpaceBox.BorderSizePixel = 0
	SpaceBox.Size = UDim2.new(0, 0, 0, 3)

	local SPAWN_THREAD;
	local isOpen = false; 

	local ToggleExt = function(bool)
		isOpen = bool; 
		if bool then
			Bindable:SetAttribute('V',true); Bindable:Fire(true);

			local size = math.clamp(UIListLayout.AbsoluteContentSize.Y + 15,0,200)
			ExtElementFrame.Position = UDim2.fromOffset(OptionButton.AbsolutePosition.X + 100, OptionButton.AbsolutePosition.Y + (size / 2))

			Fatality:CreateAnimation(ExtElementFrame,0.45,{ Size = UDim2.new(0, 200, 0, size) })
			Fatality:CreateAnimation(DropShadow,0.45,{ ImageTransparency = 0.750 })
			Fatality:CreateAnimation(UIStroke,0.45,{ Transparency = 0 })

			if SPAWN_THREAD then task.cancel(SPAWN_THREAD); SPAWN_THREAD = nil; end;

			SPAWN_THREAD = task.spawn(function()
				while true do task.wait(0.1)
					local size = math.clamp(UIListLayout.AbsoluteContentSize.Y + 15,0,200)
					local ud = UDim2.fromOffset(OptionButton.AbsolutePosition.X + 100, OptionButton.AbsolutePosition.Y + (size / 2));
					Fatality:CreateAnimation(ExtElementFrame,0.35,{ Position = ud });
				end;
			end)
		else
			if SPAWN_THREAD then task.cancel(SPAWN_THREAD); SPAWN_THREAD = nil; end;

			Bindable:SetAttribute('V',false); Bindable:Fire(false);

			Fatality:CreateAnimation(ExtElementFrame,0.45,{ Size = UDim2.new(0, 200, 0, 0) })
			Fatality:CreateAnimation(DropShadow,0.45,{ ImageTransparency = 1 })
			Fatality:CreateAnimation(UIStroke,0.45,{ Transparency = 1 })
		end;
	end;

	Bindable:SetAttribute('V',false);
	ToggleExt(false);

	OptionButton.MouseButton1Click:Connect(function() ToggleExt(true); end);

	UserInputService.InputBegan:Connect(function(input) 
		if isOpen and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
			if not Fatality:IsMouseOverFrame(ExtElementFrame) and not Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER then ToggleExt(false); end;
		end;
	end);

	local UIElements: Elements = Fatality:CreateElements(ScrollingFrame,ScrollingFrame.ZIndex,Bindable);
	return UIElements;
end;

function Fatality:CreateColorPicker(ColorBox: Frame,Transparency, Callback)
	Transparency = Transparency or 0;
	Callback = Callback or function() end;

	local OwnWindow = Fatality:GetWindowFromElement(ColorBox);
	local ColorPickerFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ColorPickBox = Instance.new("ImageLabel")
	local MouseMovement = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorRedGreenBlue = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_3 = Instance.new("UICorner")
	local ColorRGBSlide = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local ColorOpc = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local ColorOptSlide = Instance.new("Frame")
	local UIStroke_4 = Instance.new("UIStroke")
	local UIGradient_2 = Instance.new("UIGradient")
	local UIStroke_5 = Instance.new("UIStroke")
	local ColorOpt = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local PasteButton = Instance.new("ImageButton")
	local CopyButton = Instance.new("ImageButton")
	local hexCode = Instance.new("Frame")
	local UICorner_6 = Instance.new("UICorner")
	local HexCodeText = Instance.new("TextLabel")

	local OldCode = 0;
	local CodeH,CodeV = 1, 1;
	local IsPressM1 = false;
	local UI_SPAWN_THREAD;
	local isOpen = false; 

	local updateColor = function()
		local H , S , V = ColorBox.BackgroundColor3:ToHSV();
		OldCode = H; CodeH = S; CodeV = V;
	end;

	local VisibleToggle = function(value)
		isOpen = value; 
		if value then
			ColorPickBox.BackgroundColor3 = Color3.fromHSV(OldCode,1,1);
			ColorOpc.BackgroundColor3 = ColorBox.BackgroundColor3;
			HexCodeText.Text = "#" .. tostring(ColorPickBox.BackgroundColor3:ToHex())

			ColorPickerFrame.Position = UDim2.fromOffset(ColorBox.AbsolutePosition.X + (ColorPickerFrame.AbsoluteSize.X / 1.5),ColorBox.AbsolutePosition.Y);
			updateColor();

			if UI_SPAWN_THREAD then task.cancel(UI_SPAWN_THREAD); UI_SPAWN_THREAD = nil; end;

			UI_SPAWN_THREAD = task.spawn(function()
				while true do task.wait()
					Fatality:CreateAnimation(ColorPickerFrame,0.35,{
						Position = UDim2.fromOffset(ColorBox.AbsolutePosition.X + (ColorPickerFrame.AbsoluteSize.X / 1.5),ColorBox.AbsolutePosition.Y);
					});
				end;
			end);

			Fatality:CreateAnimation(ColorRGBSlide,0.35,{ Position = UDim2.new(0.5, 0, OldCode, 0) });
			Fatality:CreateAnimation(MouseMovement,0.35,{ Position = UDim2.new(CodeH, 0, 1 - CodeV, 0) })
			Fatality:CreateAnimation(ColorOptSlide,0.35,{ Position = UDim2.new(1- Transparency, 0, 0.5, 0) })
			Fatality:CreateAnimation(ColorPickerFrame,0.45,{ Size = UDim2.new(0, 175, 0, 195) });
			Fatality:CreateAnimation(UIStroke,0.45,{ Transparency = 0 });
			Fatality:CreateAnimation(DropShadow,0.45,{ ImageTransparency = 0.75 });
			Fatality:CreateAnimation(ColorPickBox,0.45,{ ImageTransparency = 0, BackgroundTransparency = 0 });
			Fatality:CreateAnimation(MouseMovement,0.45,{ ImageTransparency = 0 });
			Fatality:CreateAnimation(UIStroke_2,0.45,{ Transparency = 0 });
			Fatality:CreateAnimation(ColorRedGreenBlue,0.45,{ BackgroundTransparency = 0 });
			Fatality:CreateAnimation(ColorRGBSlide,0.45,{ BackgroundTransparency = 0 });
			Fatality:CreateAnimation(UIStroke_3,0.45,{ Transparency = 0.75 });
			Fatality:CreateAnimation(ColorOpc,0.45,{ BackgroundTransparency = 0 });
			Fatality:CreateAnimation(ColorOptSlide,0.45,{ BackgroundTransparency = 0 });
			Fatality:CreateAnimation(UIStroke_4,0.45,{ Transparency = 0.75 });
			Fatality:CreateAnimation(UIStroke_5,0.45,{ Transparency = 0 });
			Fatality:CreateAnimation(PasteButton,0.45,{ ImageTransparency = 0.45 });
			Fatality:CreateAnimation(CopyButton,0.45,{ ImageTransparency = 0.45 });
			Fatality:CreateAnimation(hexCode,0.45,{ BackgroundTransparency = 0.4 });
			Fatality:CreateAnimation(HexCodeText,0.45,{ TextTransparency = 0.45 });
		else
			if UI_SPAWN_THREAD then task.cancel(UI_SPAWN_THREAD); UI_SPAWN_THREAD = nil; end;

			Fatality:CreateAnimation(ColorPickerFrame,0.45,{ Size = UDim2.new(0, 175, 0, 0) });
			Fatality:CreateAnimation(UIStroke,0.45,{ Transparency = 1 });
			Fatality:CreateAnimation(DropShadow,0.45,{ ImageTransparency = 1 });
			Fatality:CreateAnimation(ColorPickBox,0.45,{ ImageTransparency = 1, BackgroundTransparency = 1 });
			Fatality:CreateAnimation(MouseMovement,0.45,{ ImageTransparency = 1 });
			Fatality:CreateAnimation(UIStroke_2,0.45,{ Transparency = 1 });
			Fatality:CreateAnimation(ColorRedGreenBlue,0.45,{ BackgroundTransparency = 1 });
			Fatality:CreateAnimation(ColorRGBSlide,0.45,{ BackgroundTransparency = 1 });
			Fatality:CreateAnimation(UIStroke_3,0.45,{ Transparency = 1 });
			Fatality:CreateAnimation(ColorOpc,0.45,{ BackgroundTransparency = 1 });
			Fatality:CreateAnimation(ColorOptSlide,0.45,{ BackgroundTransparency = 1 });
			Fatality:CreateAnimation(UIStroke_4,0.45,{ Transparency = 1 });
			Fatality:CreateAnimation(UIStroke_5,0.45,{ Transparency = 1 });
			Fatality:CreateAnimation(PasteButton,0.45,{ ImageTransparency = 1 });
			Fatality:CreateAnimation(CopyButton,0.45,{ ImageTransparency = 1 });
			Fatality:CreateAnimation(hexCode,0.45,{ BackgroundTransparency = 1 });
			Fatality:CreateAnimation(HexCodeText,0.45,{ TextTransparency = 1 });
		end;
	end;

	ColorPickerFrame.Active = true;
	ColorPickerFrame.Name = Fatality:RandomString()
	ColorPickerFrame.Parent = OwnWindow
	ColorPickerFrame.AnchorPoint = Vector2.new(0.5, 0)
	Fatality:Register(ColorPickerFrame, "Background") 
	ColorPickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerFrame.BorderSizePixel = 0
	ColorPickerFrame.ClipsDescendants = true
	ColorPickerFrame.Position = UDim2.new(4,0,4,0)
	ColorPickerFrame.Size = UDim2.new(0, 175, 0, 195)
	ColorPickerFrame.ZIndex = 200
	local CPScale = Instance.new("UIScale", ColorPickerFrame) 
	CPScale.Scale = Fatality.Scale
	table.insert(Fatality.ScalesRegistry, CPScale)
	Fatality:AddDragBlacklist(ColorPickerFrame);

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ColorPickerFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	Fatality:Register(UIStroke, "Stroke", "Color")
	UIStroke.Parent = ColorPickerFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = ColorPickerFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 199
	DropShadow.Image = "rbxassetid://6014261993"
	Fatality:Register(DropShadow, "Outline", "ImageColor3") 
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ColorPickBox.Name = Fatality:RandomString()
	ColorPickBox.Parent = ColorPickerFrame
	ColorPickBox.BackgroundColor3 = Color3.fromRGB(39, 255, 35)
	ColorPickBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickBox.BorderSizePixel = 0
	ColorPickBox.Position = UDim2.new(0, 7, 0, 7)
	ColorPickBox.Size = UDim2.new(0, 135, 0, 135)
	ColorPickBox.ZIndex = 201
	ColorPickBox.Image = "http://www.roblox.com/asset/?id=112554223509763"

	MouseMovement.Name = Fatality:RandomString()
	MouseMovement.Parent = ColorPickBox
	MouseMovement.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MouseMovement.BackgroundTransparency = 1.000
	MouseMovement.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MouseMovement.BorderSizePixel = 0
	MouseMovement.Position = UDim2.new(0.822222233, 0, 0.0592592582, 0)
	MouseMovement.Size = UDim2.new(0, 12, 0, 12)
	MouseMovement.ZIndex = 205
	MouseMovement.Image = "rbxassetid://4805639000"
	MouseMovement.AnchorPoint = Vector2.new(0.5,0.5)

	UICorner_2.CornerRadius = UDim.new(0, 2)
	UICorner_2.Parent = ColorPickBox

	UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
	Fatality:Register(UIStroke_2, "Stroke", "Color") 
	UIStroke_2.Parent = ColorPickBox

	ColorRedGreenBlue.Name = Fatality:RandomString()
	ColorRedGreenBlue.Parent = ColorPickerFrame
	ColorRedGreenBlue.AnchorPoint = Vector2.new(1, 0)
	ColorRedGreenBlue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRedGreenBlue.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRedGreenBlue.BorderSizePixel = 0
	ColorRedGreenBlue.Position = UDim2.new(1, -7, 0, 7)
	ColorRedGreenBlue.Size = UDim2.new(0, 20, 0, 135)
	ColorRedGreenBlue.ZIndex = 206

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Rotation = 90
	UIGradient.Parent = ColorRedGreenBlue

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = ColorRedGreenBlue

	ColorRGBSlide.Name = Fatality:RandomString()
	ColorRGBSlide.Parent = ColorRedGreenBlue
	ColorRGBSlide.AnchorPoint = Vector2.new(0.5, 0)
	ColorRGBSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRGBSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRGBSlide.BorderSizePixel = 0
	ColorRGBSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorRGBSlide.Size = UDim2.new(1, 5, 0, 2)
	ColorRGBSlide.ZIndex = 207

	UIStroke_3.Transparency = 0.750
	UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
	Fatality:Register(UIStroke_3, "Stroke", "Color")
	UIStroke_3.Parent = ColorRGBSlide

	ColorOpc.Name = Fatality:RandomString()
	ColorOpc.Parent = ColorPickerFrame
	ColorOpc.AnchorPoint = Vector2.new(0.5, 0)
	ColorOpc.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpc.BorderSizePixel = 0
	ColorOpc.Position = UDim2.new(0.5, 0, 0, 149)
	ColorOpc.Size = UDim2.new(1, -15, 0, 12)
	ColorOpc.ZIndex = 206

	UICorner_4.CornerRadius = UDim.new(0, 2)
	UICorner_4.Parent = ColorOpc

	ColorOptSlide.Name = Fatality:RandomString()
	ColorOptSlide.Parent = ColorOpc
	ColorOptSlide.AnchorPoint = Vector2.new(0, 0.5)
	ColorOptSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorOptSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOptSlide.BorderSizePixel = 0
	ColorOptSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorOptSlide.Size = UDim2.new(0, 2, 1, 5)
	ColorOptSlide.ZIndex = 207

	UIStroke_4.Transparency = 0.750
	UIStroke_4.Color = Color3.fromRGB(29, 29, 29)
	Fatality:Register(UIStroke_4, "Stroke", "Color") 
	UIStroke_4.Parent = ColorOptSlide

	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient_2.Parent = ColorOpc

	UIStroke_5.Color = Color3.fromRGB(29, 29, 29)
	Fatality:Register(UIStroke_5, "Stroke", "Color")
	UIStroke_5.Parent = ColorOpc

	ColorOpt.Name = Fatality:RandomString()
	ColorOpt.Parent = ColorPickerFrame
	ColorOpt.AnchorPoint = Vector2.new(0.5, 0)
	ColorOpt.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpt.BackgroundTransparency = 1.000
	ColorOpt.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpt.BorderSizePixel = 0
	ColorOpt.Position = UDim2.new(0.5, 0, 0, 169)
	ColorOpt.Size = UDim2.new(1, -15, 0, 18)
	ColorOpt.ZIndex = 206

	UICorner_5.CornerRadius = UDim.new(0, 2)
	UICorner_5.Parent = ColorOpt

	PasteButton.Name = Fatality:RandomString()
	PasteButton.Parent = ColorOpt
	PasteButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PasteButton.BackgroundTransparency = 1.000
	PasteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PasteButton.BorderSizePixel = 0
	PasteButton.Size = UDim2.new(1, 0, 1, 0)
	PasteButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	PasteButton.ZIndex = 209
	PasteButton.Image = "rbxassetid://10709799288"
	PasteButton.ImageTransparency = 0.450
	Fatality:Register(PasteButton, "Text", "ImageColor3") 

	CopyButton.Name = Fatality:RandomString()
	CopyButton.Parent = ColorOpt
	CopyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CopyButton.BackgroundTransparency = 1.000
	CopyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CopyButton.BorderSizePixel = 0
	CopyButton.Position = UDim2.new(0, 20, 0, 0)
	CopyButton.Size = UDim2.new(1, 0, 1, 0)
	CopyButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	CopyButton.ZIndex = 209
	CopyButton.Image = "rbxassetid://10709798682"
	CopyButton.ImageTransparency = 0.450
	Fatality:Register(CopyButton, "Text", "ImageColor3") 

	hexCode.Name = Fatality:RandomString()
	hexCode.Parent = ColorOpt
	Fatality:Register(hexCode, "Element") 
	hexCode.BackgroundTransparency = 0.400
	hexCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
	hexCode.BorderSizePixel = 0
	hexCode.Position = UDim2.new(0, 43, 0, 0)
	hexCode.Size = UDim2.new(1, -43, 1, 0)
	hexCode.ZIndex = 209

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = hexCode

	HexCodeText.Name = Fatality:RandomString()
	HexCodeText.Parent = hexCode
	HexCodeText.AnchorPoint = Vector2.new(0, 0.5)
	HexCodeText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HexCodeText.BackgroundTransparency = 1.000
	HexCodeText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HexCodeText.BorderSizePixel = 0
	HexCodeText.Position = UDim2.new(0, 3, 0.5, 0)
	HexCodeText.Size = UDim2.new(1, 0, 0.800000012, 0)
	HexCodeText.ZIndex = 209
	HexCodeText.FontFace = Fatality.FontSemiBold
	HexCodeText.Text = "#fff"
	Fatality:Register(HexCodeText, "Text", "TextColor3") 
	HexCodeText.TextSize = 13.000
	HexCodeText.TextTransparency = 0.450
	HexCodeText.TextXAlignment = Enum.TextXAlignment.Left;

	Fatality:CreateHover(CopyButton,function(bool)
		if bool then Fatality:CreateAnimation(CopyButton,0.45,{ ImageTransparency = 0.1 })
		else Fatality:CreateAnimation(CopyButton,0.45,{ ImageTransparency = 0.45 }) end
	end)	

	Fatality:CreateHover(PasteButton,function(bool)
		if bool then Fatality:CreateAnimation(PasteButton,0.45,{ ImageTransparency = 0.1 })
		else Fatality:CreateAnimation(PasteButton,0.45,{ ImageTransparency = 0.45 }) end
	end)

	PasteButton.MouseButton1Click:Connect(function()
		if Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY then
			local h,s,v = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB:ToHSV();
			Transparency = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.OPC;
			OldCode = h; CodeH = s; CodeV = v;
			HexCodeText.Text = "#" .. tostring(Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB:ToHex());
			Fatality:CreateAnimation(ColorRGBSlide,0.35,{ Position = UDim2.new(0.5, 0, OldCode, 0) });
			Fatality:CreateAnimation(MouseMovement,0.35,{ Position = UDim2.new(CodeH, 0, 1 - CodeV, 0) })
			Fatality:CreateAnimation(ColorOptSlide,0.35,{ Position = UDim2.new(1- Transparency, 0, 0.5, 0) })
			Fatality:CreateAnimation(ColorPickerFrame,0.45,{ Size = UDim2.new(0, 175, 0, 195), });
			ColorPickBox.BackgroundColor3 = Color3.fromHSV(h,1,1);
			ColorOpc.BackgroundColor3 = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB;
			Callback(Color3.fromHSV(OldCode,CodeH,CodeV),Transparency);
		end;
	end);

	CopyButton.MouseButton1Click:Connect(function()
		Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY = {
			RGB = Color3.fromHSV(OldCode,CodeH,CodeV),
			OPC = Transparency,
		};
	end)

	VisibleToggle(false);

	Fatality:NewInput(ColorBox,function() VisibleToggle(true); end);

	do
		local SPAWN_THREAD;
		ColorPickerFrame.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;
				Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = true;
				if SPAWN_THREAD then task.cancel(SPAWN_THREAD); SPAWN_THREAD = nil; end;
				SPAWN_THREAD = task.spawn(function()
					while IsPressM1 do task.wait(0) Callback(Color3.fromHSV(OldCode,CodeH,CodeV),Transparency); end;
				end);
			end;
		end)

		ColorPickerFrame.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = false;
				Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = false;
				if SPAWN_THREAD then task.cancel(SPAWN_THREAD); SPAWN_THREAD = nil; end;
			end;
		end)

	UserInputService.InputBegan:Connect(function(Input) 
			if isOpen and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
				if not Fatality:IsMouseOverFrame(ColorPickerFrame) then VisibleToggle(false); end;
			end;
		end)

		ColorRedGreenBlue.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;
				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local ColorY = ColorRedGreenBlue.AbsolutePosition.Y
					local ColorYM = ColorY + ColorRedGreenBlue.AbsoluteSize.Y;
					local Value = math.clamp(Mouse.Y, ColorY, ColorYM)
					local Code = ((Value - ColorY) / (ColorYM - ColorY));
					local Color = Color3.fromHSV(Code, CodeH, CodeV);

					Fatality:CreateAnimation(ColorRGBSlide,0.35,{ Position = UDim2.new(0.5, 0, Code, 0) });
					Fatality:CreateAnimation(ColorBox,0.5,{ BackgroundColor3 = Color });
					Fatality:CreateAnimation(ColorOpc,0.35,{ BackgroundColor3 = Color });
					Fatality:CreateAnimation(ColorPickBox,0.5,{ BackgroundColor3 = Color3.fromHSV(Code, 1, 1) });

					HexCodeText.Text = "#" .. tostring(Color:ToHex())
					OldCode = Code;
				end;
			end;
		end);

		ColorOpc.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;
				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local transparency = math.clamp((((Mouse.X) - ColorOpc.AbsolutePosition.X) / ColorOpc.AbsoluteSize.X), 0, 1);
					Fatality:CreateAnimation(ColorOptSlide,0.35,{ Position = UDim2.new(transparency, 0, 0.5, 0) });
					HexCodeText.Text = "#" .. tostring(ColorBox.BackgroundColor3:ToHex())
					Transparency = (1 - transparency);
				end;
			end;
		end);

		ColorPickBox.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;
				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait();
					local PosX = ColorPickBox.AbsolutePosition.X
					local ScaleX = PosX + ColorPickBox.AbsoluteSize.X
					local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), ColorPickBox.AbsolutePosition.Y
					local ScaleY = PosY + ColorPickBox.AbsoluteSize.Y
					local Vals = math.clamp(Mouse.Y, PosY, ScaleY)

					CodeH = (Value - PosX) / (ScaleX - PosX);
					CodeV = (1 - ((Vals - PosY) / (ScaleY - PosY)));

					Fatality:CreateAnimation(ColorBox,0.5,{ BackgroundColor3 = Color3.fromHSV(OldCode, CodeH, CodeV) });
					Fatality:CreateAnimation(ColorOpc,0.35,{ BackgroundColor3 = Color3.fromHSV(OldCode, CodeH, CodeV) });
					HexCodeText.Text = "#" .. tostring(Color3.fromHSV(OldCode, CodeH, CodeV):ToHex())
					Fatality:CreateAnimation(MouseMovement,0.2,nil,{ Position = UDim2.new(CodeH, 0, 1 - CodeV, 0) })
				end
			end
		end)
	end;

	return { set_opc = function(v) Transparency = v; end, }
end;

function Fatality:RandomStr(len: number): string
	local main = "";
	for i = 1 , len do
		local max = #Fatality.Ascii;
		local rand = math.random(1,max);
		main = main .. Fatality.Ascii:sub(rand,rand);
	end;
	return main;
end;

function Fatality:AddDragBlacklist(Frame: Frame) 
	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			local finder = table.find(Fatality.DragBlacklist , Frame);
			if not finder then table.insert(Fatality.DragBlacklist , Frame); end;
		end;
	end);
	Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			local finder = table.find(Fatality.DragBlacklist , Frame);
			if finder then table.remove(Fatality.DragBlacklist , finder); end;
		end;
	end);
end;

function Fatality:ProtectText(Label: TextLabel,Text: string)
	Label.RichText = true;
	local MainText = string.gsub(Text,'.',function(t)
		if not string.find(t,"[<>()\"']") then return string.format('<font %s="%s">%s</font>',Fatality:RandomStr(5),Fatality:RandomStr(5),t) end;
		return t;
	end);
	Label.Text = MainText;
end;

function Fatality:CreateDropdown(Parent: Frame, Default: string | {[string]: boolean}, Multiplier: boolean, AutoUpdate: boolean,Callback: (data: any) -> any)
	local ScreenGui = Parent:FindFirstAncestorWhichIsA("ScreenGui")
	local Window = Fatality:GetWindowFromElement(Parent)
	local Data = {};
	local Selected = (Multiplier and {}) or nil;
	local isOpen = false;
    local GuiService = game:GetService("GuiService") 

	local function GetSafeColor(val)
		if typeof(val) == "ColorSequence" then return val.Keypoints[1].Value end
		return val
	end

	local DropdownItemFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local SPAWN_THREAD;

	Fatality:AddDragBlacklist(DropdownItemFrame);

	local Toggle = function(value)
		isOpen = value;
		Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = value;

		if value then
			DropdownItemFrame.Visible = true
			if SPAWN_THREAD then SPAWN_THREAD:Disconnect() end

			SPAWN_THREAD = game:GetService("RunService").RenderStepped:Connect(function()
				if not Parent or not Parent.Parent or not Parent.Visible or not isOpen then 
					if SPAWN_THREAD then SPAWN_THREAD:Disconnect() end
					DropdownItemFrame.Visible = false
					return 
				end
				
				local unscaledHeight = UIListLayout.AbsoluteContentSize.Y / Fatality.Scale
				local baseSize = unscaledHeight + 10;
				
				local btnPos = Parent.AbsolutePosition
				local btnSize = Parent.AbsoluteSize
                local topBarOffset = GuiService:GetGuiInset().Y
				
				local targetY = btnPos.Y + btnSize.Y + 3 + topBarOffset
				local targetX = (btnPos.X + btnSize.X) - 175

				DropdownItemFrame.Position = UDim2.fromOffset(targetX, targetY)

				Fatality:CreateAnimation(DropdownItemFrame,0.35,{ Size = UDim2.new(0, 175, 0, math.clamp(baseSize,0,200)) })
			end)

			Fatality:CreateAnimation(UIStroke,0.35,{ Transparency = 0 })
			Fatality:CreateAnimation(DropShadow,0.35,{ ImageTransparency = 0.75 })
		else
			if SPAWN_THREAD then SPAWN_THREAD:Disconnect(); SPAWN_THREAD = nil; end;

			Fatality:CreateAnimation(DropdownItemFrame,0.35,{ Size = UDim2.new(0, 175, 0, 0) })
			Fatality:CreateAnimation(UIStroke,0.35,{ Transparency = 1 })
			Fatality:CreateAnimation(DropShadow,0.35,{ ImageTransparency = 1 })
			
			task.delay(0.35, function() if not isOpen then DropdownItemFrame.Visible = false end end)
		end;
	end;

	DropdownItemFrame.Name = Fatality:RandomString()
	DropdownItemFrame.Parent = ScreenGui 
	
	DropdownItemFrame.AnchorPoint = Vector2.new(0, 0) 
	Fatality:Register(DropdownItemFrame, "Container") 
	DropdownItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownItemFrame.BorderSizePixel = 0
	DropdownItemFrame.ClipsDescendants = true
	DropdownItemFrame.Position = UDim2.fromOffset(0, 0)
	DropdownItemFrame.Size = UDim2.new(0, 175, 0, 0)
	DropdownItemFrame.Visible = false
	DropdownItemFrame.ZIndex = 10000 
	DropdownItemFrame.Active = true
	local DDScale = Instance.new("UIScale", DropdownItemFrame)
	DDScale.Scale = Fatality.Scale
	table.insert(Fatality.ScalesRegistry, DDScale)

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = DropdownItemFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	Fatality:Register(UIStroke, "Stroke", "Color") 
	UIStroke.Parent = DropdownItemFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = DropdownItemFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 9999
	DropShadow.Image = "rbxassetid://6014261993"
	Fatality:Register(DropShadow, "Outline", "ImageColor3")
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = DropdownItemFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ClipsDescendants = false
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, -5, 1, -5)
	ScrollingFrame.ZIndex = 10005
	ScrollingFrame.ScrollBarThickness = 0
	ScrollingFrame.ScrollBarImageTransparency = 1
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.fromOffset(0, math.round(UIListLayout.AbsoluteContentSize.Y / Fatality.Scale) + 4)
	end)

local new_button = function()
		local db_selected = Instance.new("TextButton")
		db_selected.Name = Fatality:RandomString()
		db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		db_selected.BackgroundTransparency = 1.000
		db_selected.BorderSizePixel = 0
		db_selected.Size = UDim2.new(1, 0, 0, 10)
		db_selected.ZIndex = 10010
		db_selected.FontFace = Fatality.FontSemiBold
		db_selected.TextColor3 = Fatality:GetColor("Main") 
		db_selected.TextSize = 12.000
		db_selected.TextXAlignment = Enum.TextXAlignment.Left
		return db_selected;
	end;

	local func;
	local DropdownButtons = {}; 

	local res = Fatality:CreateResponse({
		set_data = function(v) Data = v; end,
		on_toggle = function(cb) func = cb; end,
		change_default = function(v) Default = v; end,
		refresh = function()
			for i,v in next , ScrollingFrame:GetChildren() do if v:IsA('TextButton') then v:Destroy(); end; end;
			table.clear(DropdownButtons);

			local selectedmem;

			for i,v in next , Data do
				local bth = new_button();
				bth.Text = tostring(v);
				bth.Parent = ScrollingFrame;
				table.insert(DropdownButtons, {Btn = bth, Value = v})

				if Multiplier then
					if (typeof(Default) == 'table' and (Default[v] or table.find(Default,v))) or Default == v then
						Selected[v] = true
						bth.TextColor3 = Fatality:GetColor("Main");
					else
						bth.TextColor3 = Fatality:GetColor("Text");
						Selected[v] = false
					end

					bth.MouseButton1Click:Connect(function()
						Selected[v] = not Selected[v];
						bth.TextColor3 = Selected[v] and Fatality:GetColor("Main") or Fatality:GetColor("Text");
						Callback(Selected);
					end)
				else
					if v == Default then
						selectedmem = bth; Selected = v;
						bth.TextColor3 = Fatality:GetColor("Main");
					else
						bth.TextColor3 = Fatality:GetColor("Text");
					end

					bth.MouseButton1Click:Connect(function()
						if selectedmem then selectedmem.TextColor3 = Fatality:GetColor("Text"); end;
						bth.TextColor3 = Fatality:GetColor("Main");
						selectedmem = bth; Selected = v;
						Callback(v);
						if not Multiplier then isOpen = false; func(false); Toggle(false); end
					end)
				end;
			end;
			Callback(Selected);
		end,
	});

	Fatality.ThemeEvent.Event:Connect(function()
		for _, data in pairs(DropdownButtons) do
			if data.Btn and data.Btn.Parent then
				local isSelected = false
				if Multiplier then isSelected = Selected[data.Value] == true else isSelected = (Selected == data.Value) end
				game:GetService("TweenService"):Create(data.Btn, TweenInfo.new(0.3), {TextColor3 = isSelected and Fatality:GetColor("Main") or Fatality:GetColor("Text")}):Play()
			end
		end
	end)

	Fatality:NewInput(Parent,function()
		if isOpen then isOpen = false; func(false); Toggle(false);
		else if AutoUpdate then res:refresh(); end; isOpen = true; func(true); Toggle(true); end
	end);

	UserInputService.InputBegan:Connect(function(Input)
		if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and isOpen then
			if not Fatality:IsMouseOverFrame(DropdownItemFrame) and not Fatality:IsMouseOverFrame(Parent) then
				isOpen = false; func(false); Toggle(false);
			end;
		end;
	end);

	return res;
end;

function Fatality:CreateElements(Parent : Frame , ZIndex : number , Event : BindableEvent,SearchAPI: {Path: string,Memory : (name:string) -> any}) : Elements
	local elements = {};
	local FatalWindow = Fatality:GetWindowFromElement(Parent);

	local function GetDummyElement()
		return { Option = Fatality.Dummy, SetValue = function() end, GetValue = function() return nil end, Set = function() end, Refresh = function() end, Rename = function() end, Signal = { Disconnect = function() end }, Fire = function() end }
	end

	function elements:AddToggle(Config: Toggle)
		Config = Config or {};
		if not Fatality:CanShow(Config) then return GetDummyElement() end

		Config.Name = Config.Name or "Toggle"; Config.Default = Config.Default or false; Config.Risky = Config.Risky or false; Config.Option = Config.Option or false; Config.Callback = Config.Callback or function(bool) end; Config.Flag = Config.Flag or nil;

		local Toggle = Instance.new("Frame")
		local Toggle_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ValueIcon = Instance.new("ImageLabel")
		local OptionButton = Instance.new("ImageButton")

		if SearchAPI then SearchAPI.Memory(Config.Name); end;

		Toggle.Name = Fatality:RandomString()
		Toggle.Parent = Parent
		Fatality:Register(Toggle, "Element")
		Toggle.BackgroundTransparency = 1.000
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.Size = UDim2.new(1, -25, 0, 17)
		Toggle.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Toggle);

		Toggle_Name.Name = Fatality:RandomString()
		Toggle_Name.Parent = Toggle
		Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
		Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Toggle_Name.BackgroundTransparency = 1.000
		Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle_Name.BorderSizePixel = 0
		Toggle_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Toggle_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Toggle_Name.ZIndex = ZIndex + 2
		Toggle_Name.FontFace = Fatality.FontSemiBold;
		
		if Config.Risky then Toggle_Name.TextColor3 = Color3.fromRGB(255, 160, 92) else Fatality:Register(Toggle_Name, "Text", "TextColor3") end
		
		Toggle_Name.TextSize = 13.000
		Toggle_Name.TextTransparency = 1
		Toggle_Name.TextXAlignment = Enum.TextXAlignment.Left;
		Fatality:ProtectText(Toggle_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Toggle
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		Fatality:Register(ValueFrame, "Element")
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		ValueFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
		ValueFrame.ZIndex = ZIndex + 2
		ValueFrame.BackgroundTransparency = 1;

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		ValueIcon.Name = Fatality:RandomString()
		ValueIcon.Parent = ValueFrame
		ValueIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueIcon.BackgroundTransparency = 1.000
		ValueIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueIcon.BorderSizePixel = 0
		ValueIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueIcon.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
		ValueIcon.ZIndex = ZIndex + 2
		ValueIcon.Image = "rbxassetid://10709790644"
		ValueIcon.ImageTransparency = 1;
		Fatality:Register(ValueIcon, "Main", "ImageColor3")

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = Toggle
		OptionButton.AnchorPoint = Vector2.new(1, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(1, -25, 0.5, 0)
		OptionButton.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 1
		OptionButton.ZIndex = ZIndex + 4
		OptionButton.Visible = Config.Option;
		Fatality:Register(OptionButton, "Text", "ImageColor3")

		local toggleImg = function(value)
			if value then
				Fatality:CreateAnimation(ValueIcon,0.45,{ ImageTransparency = 0, ImageColor3 = Fatality.CurrentTheme.Main, Size = UDim2.new(0.8, 0, 0.8, 0), Rotation = 0, })
			else
				Fatality:CreateAnimation(ValueIcon,0.45,{ ImageTransparency = 1, ImageColor3 = Fatality.CurrentTheme.Text, Size = UDim2.new(0.699999988, 0, 0.699999988, 0), Rotation = 15 })
			end;
		end;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(ValueIcon,0.45,{ ImageTransparency = 1, })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = (Config.Option and 0.600) or 1 })
				toggleImg(Config.Default)
				Fatality:CreateAnimation(ValueFrame,0.45,{ BackgroundTransparency = 0, })
				Fatality:CreateAnimation(Toggle_Name,0.45,{ TextTransparency = 0.200 })
			else
				Fatality:CreateAnimation(Toggle_Name,0.45,{ TextTransparency = 1 })
				Fatality:CreateAnimation(ValueFrame,0.45,{ BackgroundTransparency = 1, })
				Fatality:CreateAnimation(ValueIcon,0.45,{ ImageTransparency = 1, })
				Fatality:CreateAnimation(ValueIcon,0.45,{ ImageTransparency = 1, })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = 1 })
			end;
		end;

		OpcToggle(Event:GetAttribute('V'))
		toggleImg(Config.Default);

		Fatality:CreateHover(ValueFrame,function(b)
			if not Config.Default then
				if b then Fatality:CreateAnimation(ValueIcon,0.45,{ ImageTransparency = 0.5, ImageColor3 = Fatality.CurrentTheme.Text, Size = UDim2.new(0.7, 0, 0.7, 0), Rotation = 0 })
				else Fatality:CreateAnimation(ValueIcon,0.45,{ ImageTransparency = 1, ImageColor3 = Fatality.CurrentTheme.Text, Size = UDim2.new(0.699999988, 0, 0.699999988, 0), Rotation = 15 }) end;
			end;
		end)

		Fatality:NewInput(ValueFrame,function() Config.Default = not Config.Default; toggleImg(Config.Default); Config.Callback(Config.Default) end);

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name) Toggle_Name.Text = new_name; Fatality:ProtectText(Toggle_Name,new_name); end,
			GetValue = function() return Config.Default; end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v, force)
				local IsSame = v == Config.Default; Config.Default = v; toggleImg(Config.Default);
				if not IsSame or force then Config.Callback(Config.Default); end;
			end,
			Flag = Config.Flag and (Config.Flag.."Toggle"),
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then Fatality.WindowFlags[FatalWindow][Config.Flag.."Toggle"] = Respons; end;
		if Config.Default then Config.Callback(Config.Default) end

		return Respons;
	end;

	function elements:AddSlider(Config)
		Config = Config or {};
		if not Fatality:CanShow(Config) then return GetDummyElement() end

		Config.Name = Config.Name or "Slider"; Config.Type = Config.Type or ""; Config.Range = Config.Range or {0, 100}; Config.Default = Config.Default or Config.Range[1]; Config.Precise = Config.Precise or false; Config.Step = Config.Step or nil; Config.Risky = Config.Risky or false; Config.Option = Config.Option or false; Config.Callback = Config.Callback or function(number) end; Config.Flag = Config.Flag or nil;

		local min, max = Config.Range[1], Config.Range[2];
		local Slider = Instance.new("Frame")
		local Slider_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local boxli = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local ValueText = Instance.new("TextLabel")

		if SearchAPI then SearchAPI.Memory(Config.Name); end;

		Slider.Name = Fatality:RandomString()
		Slider.Parent = Parent
		Fatality:Register(Slider, "Element")
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.Size = UDim2.new(1, -25, 0, 17)
		Slider.ZIndex = ZIndex + 1

		Fatality:AddDragBlacklist(Slider);

		Slider_Name.Name = Fatality:RandomString()
		Slider_Name.Parent = Slider
		Slider_Name.AnchorPoint = Vector2.new(0, 0.5)
		Slider_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Slider_Name.BackgroundTransparency = 1.000
		Slider_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider_Name.BorderSizePixel = 0
		Slider_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Slider_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Slider_Name.ZIndex = ZIndex + 2
		Slider_Name.FontFace = Fatality.FontSemiBold
		Slider_Name.Text = Config.Name
		
		if Config.Risky then Slider_Name.TextColor3 = Color3.fromRGB(255, 160, 92) else Fatality:Register(Slider_Name, "Text", "TextColor3") end
		
		Slider_Name.TextSize = 13.000
		Slider_Name.TextTransparency = 0.200
		Slider_Name.TextXAlignment = Enum.TextXAlignment.Left

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Slider
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		Fatality:Register(ValueFrame, "Element")
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 85, 0.600000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option;
		OptionButton.ZIndex = ZIndex + 1;
		Fatality:Register(OptionButton, "Text", "ImageColor3")

		local initialAlpha = (Config.Default - min) / (max - min)
		boxli.Name = Fatality:RandomString()
		boxli.Parent = ValueFrame
		Fatality:Register(boxli, "Main")
		boxli.BorderColor3 = Color3.fromRGB(0, 0, 0)
		boxli.BorderSizePixel = 0
		boxli.Size = UDim2.new(initialAlpha, 0, 1, 0)
		boxli.ZIndex = ZIndex + 3

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = boxli

		ValueText.Name = "Information"
		ValueText.Parent = ValueFrame
		ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Size = UDim2.new(1, 0, 1, 0)
		ValueText.ZIndex = ZIndex + 4
		ValueText.FontFace = Fatality.FontSemiBold
		ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));
		ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.TextSize = 9.000
		ValueText.TextStrokeTransparency = 0.850;
		ValueText.TextTransparency = 0;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(boxli,0.45,{ BackgroundTransparency = 0, })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = (Config.Option and 0.600) or 1 })
				Fatality:CreateAnimation(ValueFrame,0.45,{ BackgroundTransparency = 0, })
				Fatality:CreateAnimation(Slider_Name,0.45,{ TextTransparency = 0.200 })
				Fatality:CreateAnimation(ValueText,0.45,{ TextStrokeTransparency = 0.850, TextTransparency = 0; })
			else
				Fatality:CreateAnimation(ValueText,0.45,{ TextStrokeTransparency = 1, TextTransparency = 1; })
				Fatality:CreateAnimation(Slider_Name,0.45,{ TextTransparency = 1 })
				Fatality:CreateAnimation(ValueFrame,0.45,{ BackgroundTransparency = 1, })
				Fatality:CreateAnimation(boxli,0.45,{ BackgroundTransparency = 1, })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = 1 })
			end;
		end;

		OpcToggle(Event:GetAttribute('V'))

		local IsHold = false;
		local function update(Input)
			local alpha = math.clamp((Input.Position.X - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X, 0, 1)
			local Value = min + alpha * (max - min)

			if Config.Step then Value = math.floor(Value / Config.Step + 0.5) * Config.Step
			elseif typeof(Config.Precise) == "number" and Config.Precise > 0 then Value = Fatality:Rounding(Value, Config.Precise) 
			elseif not Config.Precise or Config.Precise == 0 then Value = math.round(Value) end
			
			Value = math.clamp(Value, min, max)
			local normalizedAlpha = (Value - min) / (max - min)

			TweenService:Create(boxli, TweenInfo.new(0.2), { Size = UDim2.new(normalizedAlpha, 0, 1, 0) }):Play()
			Config.Default = Value
			ValueText.Text = string.format('%s%s', tostring(Value), tostring(Config.Type))
			Config.Callback(Value)
		end;

		do
			ValueFrame.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then IsHold = true; update(Input) end
			end)
			ValueFrame.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then IsHold = false end
			end)
			UserInputService.InputChanged:Connect(function(Input)
				if IsHold and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then update(Input) end
			end);
		end;

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name) Slider_Name.Text = new_name end,
			GetValue = function() return Config.Default; end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v, force)
				local IsSame = v == Config.Default;
				v = math.clamp(v, min, max)
				Config.Default = v;
				local normalizedAlpha = (v - min) / (max - min)
				TweenService:Create(boxli, TweenInfo.new(0.2), { Size = UDim2.new(normalizedAlpha, 0, 1, 0) }):Play()
				ValueText.Text = string.format('%s%s', tostring(v), tostring(Config.Type))
				if not IsSame or force then Config.Callback(v); end;
			end,
			Flag = Config.Flag and Config.Flag.."Slider",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then Fatality.WindowFlags[FatalWindow][Config.Flag.."Slider"] = Respons; end;
		Config.Callback(Config.Default)

		return Respons;
	end;

	function elements:AddButton(Config: Button)
		Config = Config or {};
		if not Fatality:CanShow(Config) then return GetDummyElement() end

		Config.Name = Config.Name or "Slider"; Config.Risky = Config.Risky or false; Config.Callback = Config.Callback or function() end;

		local Button = Instance.new("Frame")
		local Button_Name = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")

		if SearchAPI then SearchAPI.Memory(Config.Name); end;

		Button.Name = Fatality:RandomString()
		Button.Parent = Parent
		Fatality:Register(Button, "Element")
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.BorderSizePixel = 0
		Button.Size = UDim2.new(1, -25, 0, 25)
		Button.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Button);

		Button_Name.Name = Fatality:RandomString()
		Button_Name.Parent = Button
		Button_Name.AnchorPoint = Vector2.new(0, 0.5)
		Button_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Button_Name.BackgroundTransparency = 1.000
		Button_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button_Name.BorderSizePixel = 0
		Button_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Button_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Button_Name.ZIndex = ZIndex + 2
		Button_Name.FontFace = Fatality.FontSemiBold
		Button_Name.Text = Config.Name
		
		if Config.Risky then Button_Name.TextColor3 = Color3.fromRGB(255, 160, 92) else Fatality:Register(Button_Name, "Text", "TextColor3") end
		
		Button_Name.TextSize = 12.000
		Button_Name.TextTransparency = 0.400
		Fatality:ProtectText(Button_Name,Config.Name);

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = Button;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Button_Name,0.45,{ TextTransparency = 0.4, })
				Fatality:CreateAnimation(Button,0.45,{ BackgroundTransparency = 0, })
			else
				Fatality:CreateAnimation(Button_Name,0.45,{ TextTransparency = 1, })
				Fatality:CreateAnimation(Button,0.45,{ BackgroundTransparency = 1, })
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		Fatality:CreateHover(Button,function(value)
			if value then Fatality:CreateAnimation(Button,0.25,{ BackgroundColor3 = Fatality:GetColor("Hover") })
			else Fatality:CreateAnimation(Button,0.45,{ BackgroundColor3 = Fatality:GetColor("Element") }) end;
		end)

		Fatality:NewInput(Button,function() Config.Callback(); end)

		return Fatality:CreateResponse({
			Rename = function(new_name) Button_Name.Text = new_name; Fatality:ProtectText(Button_Name,new_name); end,
			GetValue = function() return Config.Default; end,
			Signal = Event.Event:Connect(OpcToggle),
			Fire = Config.Callback,
		})
	end;

	function elements:AddColorPicker(Config: ColorPicker)
		Config = Config or {};
		if not Fatality:CanShow(Config) then return GetDummyElement() end

		Config.Name = Config.Name or "Color Picker"; Config.Option = Config.Option or false; Config.Default = Config.Default or Color3.fromRGB(255, 255, 255); Config.Callback = Config.Callback or function(number) end; Config.Transparency = Config.Transparency or 0; Config.Flag = Config.Flag or nil;

		local ColorPicker = Instance.new("Frame")
		local ColorPicker_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")

		if SearchAPI then SearchAPI.Memory(Config.Name); end;

		ColorPicker.Name = Fatality:RandomString()
		ColorPicker.Parent = Parent
		Fatality:Register(ColorPicker, "Element")
		ColorPicker.BackgroundTransparency = 1.000
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.Size = UDim2.new(1, -25, 0, 17)
		ColorPicker.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(ColorPicker);

		ColorPicker_Name.Name = Fatality:RandomString()
		ColorPicker_Name.Parent = ColorPicker
		ColorPicker_Name.AnchorPoint = Vector2.new(0, 0.5)
		ColorPicker_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker_Name.BackgroundTransparency = 1.000
		ColorPicker_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker_Name.BorderSizePixel = 0
		ColorPicker_Name.Position = UDim2.new(0, 0, 0.5, 0)
		ColorPicker_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		ColorPicker_Name.ZIndex = ZIndex + 2
		ColorPicker_Name.FontFace = Fatality.FontSemiBold
		ColorPicker_Name.Text = Config.Name
		Fatality:Register(ColorPicker_Name, "Text", "TextColor3")
		ColorPicker_Name.TextSize = 13.000
		ColorPicker_Name.TextTransparency = 0.200
		ColorPicker_Name.TextXAlignment = Enum.TextXAlignment.Left
		ColorPicker_Name.ZIndex = ZIndex + 2

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = ColorPicker
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Config.Default
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 35, 0.699999988, 0)
		ValueFrame.ZIndex = ZIndex + 3

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.ZIndex = 7;
		Fatality:Register(OptionButton, "Text", "ImageColor3")

		local res = Fatality:CreateColorPicker(ValueFrame,Config.Transparency,function(rgb,opc)
			ValueFrame.BackgroundColor3 = rgb;
			ValueFrame.BackgroundTransparency = opc;
			task.spawn(Config.Callback,rgb,opc)
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(ColorPicker_Name,0.45,{ TextTransparency = 0.2, })
				Fatality:CreateAnimation(ValueFrame,0.45,{ Size = UDim2.new(0, 35, 0.7, 0) })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = (Config.Option and 0.6) or 1, })
			else
				Fatality:CreateAnimation(ColorPicker_Name,0.45,{ TextTransparency = 1, })
				Fatality:CreateAnimation(ValueFrame,0.45,{ Size = UDim2.new(0, 35, 0, 0) })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = 1, })
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name) ColorPicker.Text = new_name end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(rgb,opc,force)
				local IsSame = ValueFrame.BackgroundColor3 == rgb or ValueFrame.BackgroundTransparency == opc;
				ValueFrame.BackgroundColor3 = rgb; 
				ValueFrame.BackgroundTransparency = opc;
				res.set_opc(opc);
				if not IsSame or force then task.spawn(Config.Callback,rgb,opc) end;
			end,
			GetValue = function() return { Color = ValueFrame.BackgroundColor3, Transparency = ValueFrame.BackgroundTransparency }; end,
			Flag = Config.Flag and Config.Flag.."ColorPicker",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then Fatality.WindowFlags[FatalWindow][Config.Flag.."ColorPicker"] = Respons; end;
		if Config.Default then task.spawn(Config.Callback, Config.Default, Config.Transparency) end

		return Respons;
	end;

	function elements:AddDropdown(Config: Dropdown)
		Config = Config or {};
		if not Fatality:CanShow(Config) then return GetDummyElement() end

		Config.Name = Config.Name or "Dropdown";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or nil;
		Config.Callback = Config.Callback or function(any) end;
		Config.Values = Config.Values or {};
		Config.Multi = Config.Multi or false;

		local DataParser = function(value)
			if not value then return 'None'; end;
			local Out;
			if typeof(value) == 'table' then
				if #value > 0 then
					local x = {};
					for i,v in next , value do table.insert(x , tostring(v)) end;
					Out = table.concat(x,' , ');
				else
					local x = {};
					for i,v in next , value do if v == true then table.insert(x , tostring(i)); end end;
					Out = table.concat(x,' , ');
				end;
			else
				Out = tostring(value);
			end;
			return Out;
		end;

		local Dropdown = Instance.new("Frame")
		local Dropdown_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local icon = Instance.new("ImageLabel")
		local Value_Text = Instance.new("TextLabel")

		if SearchAPI then SearchAPI.Memory(Config.Name); end;

		Dropdown.Name = Fatality:RandomString()
		Dropdown.Parent = Parent
		Fatality:Register(Dropdown, "Element")
		Dropdown.BackgroundTransparency = 1.000
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.Size = UDim2.new(1, -25, 0, 17)
		Dropdown.ZIndex = ZIndex + 3
		Fatality:AddDragBlacklist(Dropdown);

		Dropdown_Name.Name = Fatality:RandomString()
		Dropdown_Name.Parent = Dropdown
		Dropdown_Name.AnchorPoint = Vector2.new(0, 0.5)
		Dropdown_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown_Name.BackgroundTransparency = 1.000
		Dropdown_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown_Name.BorderSizePixel = 0
		Dropdown_Name.Position = UDim2.new(0, 0, 0, 8)
		Dropdown_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Dropdown_Name.ZIndex = 7
		Dropdown_Name.FontFace = Fatality.FontSemiBold
		Dropdown_Name.Text = Config.Name
		Fatality:Register(Dropdown_Name, "Text", "TextColor3")
		Dropdown_Name.TextSize = 13.000
		Dropdown_Name.TextTransparency = 0.200
		Dropdown_Name.TextXAlignment = Enum.TextXAlignment.Left
		Dropdown_Name.ZIndex = ZIndex + 4
		Fatality:ProtectText(Dropdown_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Dropdown
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		Fatality:Register(ValueFrame, "Element")
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.925000012, 0)
		ValueFrame.ZIndex = ZIndex + 4

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0, 7)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.ZIndex = 8
		OptionButton.Visible = Config.Option;
		Fatality:Register(OptionButton, "Text", "ImageColor3")

		icon.Name = Fatality:RandomString()
		icon.Parent = ValueFrame
		icon.AnchorPoint = Vector2.new(1, 0)
		icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		icon.BackgroundTransparency = 1.000
		icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		icon.BorderSizePixel = 0
		icon.Position = UDim2.new(1, 0, 0, 0)
		icon.Size = UDim2.new(0,15,0,15)
		icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		icon.ZIndex = ZIndex + 5
		icon.Image = "rbxassetid://10709790948"
		Fatality:Register(icon, "Text", "ImageColor3")

		Value_Text.Name = Fatality:RandomString()
		Value_Text.Parent = ValueFrame
		Value_Text.AnchorPoint = Vector2.new(0, 0.5)
		Value_Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Value_Text.BackgroundTransparency = 1.000
		Value_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Value_Text.BorderSizePixel = 0
		Value_Text.Position = UDim2.new(0, 3, 0.5, 0)
		Value_Text.Size = UDim2.new(1, -18, 0.800000012, 0)
		Value_Text.ZIndex = ZIndex + 5
		Value_Text.FontFace = Fatality.FontSemiBold
		Value_Text.Text = DataParser(Config.Default)
		Fatality:Register(Value_Text, "Text", "TextColor3") 
		Value_Text.TextSize = 10.000
		Value_Text.TextTransparency = 0.500
		Value_Text.TextXAlignment = Enum.TextXAlignment.Left
		Value_Text.TextYAlignment = Enum.TextYAlignment.Top
		Value_Text.TextWrapped = true
		Value_Text.TextTruncate = Enum.TextTruncate.SplitWord

		local res;
		res = Fatality:CreateDropdown(ValueFrame, Config.Default, Config.Multi, Config.AutoUpdate, function(args)
			Config.Default = args;
			Value_Text.Text = DataParser(Config.Default);
			res:change_default(Config.Default);
			Config.Callback(args);
		end);

		res:set_data(Config.Values);
		res:refresh();

		res:on_toggle(function(b)
			if b then
				Fatality:CreateAnimation(icon,0.35,{ Rotation = -180, ImageColor3 = Fatality:GetColor("Main") })
			else
				Fatality:CreateAnimation(icon,0.35,{ Rotation = 0, ImageColor3 = Fatality:GetColor("Text") })
			end;
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Dropdown_Name,0.45,{ TextTransparency = 0.2, })
				Fatality:CreateAnimation(ValueFrame,0.45,{ BackgroundTransparency = 0 })
				Fatality:CreateAnimation(icon,0.45,{ ImageTransparency = 0 })
				Fatality:CreateAnimation(Value_Text,0.45,{ TextTransparency = 0.5 })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = (Config.Option and 0.6) or 1, })
			else
				Fatality:CreateAnimation(Dropdown_Name,0.45,{ TextTransparency = 1, })
				Fatality:CreateAnimation(ValueFrame,0.45,{ BackgroundTransparency = 1 })
				Fatality:CreateAnimation(icon,0.45,{ ImageTransparency = 1 })
				Fatality:CreateAnimation(Value_Text,0.45,{ TextTransparency = 1 })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = 1 })
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Dropdown_Name.Text = new_name
				Fatality:ProtectText(Dropdown_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def, force)
				Config.Default = def;
				Value_Text.Text = DataParser(Config.Default);
				res:change_default(Config.Default);
				if force then Config.Callback(def) end
			end,
			SetData = function(def)
				Config.Values = def;
				res:set_data(Config.Values);
				if not Config.AutoUpdate then res:refresh(); end
			end,
			Flag = Config.Flag and Config.Flag.."Dropdown",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Dropdown"] = Respons;
		end;
		
		if Config.Default then Config.Callback(Config.Default) end

		return Respons;
	end;

	function elements:AddKeybind(Config: Keybind)
		Config = Config or {};
		if not Fatality:CanShow(Config) then return GetDummyElement() end

		Config.Name = Config.Name or "Keybind";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or nil;
		Config.Callback = Config.Callback or function(any) end;

		local Keys = {
			One = '1', Two = '2', Three = '3', Four = '4', Five = '5', Six = '6', Seven = '7', Eight = '8', Nine = '9', Zero = '0',
			['Minus'] = "-", ['Plus'] = "+", BackSlash = "\\", Slash = "/", Period = '.', Semicolon = ';', Colon = ":",
			LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift", Return = "Enter",
			LeftBracket = "[", RightBracket = "]", Quote = "'", Comma = ",", Equals = "=", LeftSuper = "Super", RightSuper = "Super"
		};

		local GetItem = function(item)
			if item then
				if typeof(item) == 'EnumItem' then
					return Keys[item.Name] or item.Name;
				else
					return Keys[tostring(item)] or tostring(item);
				end;
			else
				return 'None';
			end;
		end;

		local Keybind = Instance.new("Frame")
		local Keybind_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local ValueText = Instance.new("TextLabel")

		if SearchAPI then SearchAPI.Memory(Config.Name); end;

		Keybind.Name = Fatality:RandomString()
		Keybind.Parent = Parent
		Fatality:Register(Keybind, "Element")
		Keybind.BackgroundTransparency = 1.000
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.Size = UDim2.new(1, -25, 0, 17)
		Keybind.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Keybind);

		Keybind_Name.Name = Fatality:RandomString()
		Keybind_Name.Parent = Keybind
		Keybind_Name.AnchorPoint = Vector2.new(0, 0.5)
		Keybind_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Keybind_Name.BackgroundTransparency = 1.000
		Keybind_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind_Name.BorderSizePixel = 0
		Keybind_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Keybind_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Keybind_Name.ZIndex = ZIndex + 2
		Keybind_Name.FontFace = Fatality.FontSemiBold
		Keybind_Name.Text = Config.Name
		Fatality:Register(Keybind_Name, "Text", "TextColor3")
		Keybind_Name.TextSize = 13.000
		Keybind_Name.TextTransparency = 0.200
		Keybind_Name.TextXAlignment = Enum.TextXAlignment.Left
		Fatality:ProtectText(Keybind_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Keybind
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		Fatality:Register(ValueFrame, "Element")
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.850000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option or false;
		Fatality:Register(OptionButton, "Text", "ImageColor3")

		ValueText.Name = Fatality:RandomString()
		ValueText.Parent = ValueFrame
		ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Size = UDim2.new(1, 0, 1, 0)
		ValueText.ZIndex = ZIndex + 3
		ValueText.FontFace = Fatality.FontSemiBold
		ValueText.Text = GetItem(Config.Default)
		Fatality:Register(ValueText, "Text", "TextColor3")
		ValueText.TextSize = 9.000
		ValueText.TextStrokeTransparency = 0.850
		ValueText.TextTransparency = 0.400

		local IsBinding = false;
		Fatality:NewInput(ValueFrame,function()
			if IsBinding then return; end;
			ValueText.Text = "...";
			local Selected = nil;
			while not Selected do
				local Key = UserInputService.InputBegan:Wait();
				if Key.KeyCode ~= Enum.KeyCode.Unknown then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 then Selected = "MouseLeft";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 then Selected = "MouseRight"; end;
				end;
			end;
			Config.Default = Selected;
			ValueText.Text = GetItem(Selected);
			IsBinding = false;
			Config.Callback(typeof(Selected) == "string" and Selected or Selected.Name);
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Keybind_Name,0.45,{ TextTransparency = 0.2, })
				Fatality:CreateAnimation(ValueFrame,0.45,{ BackgroundTransparency = 0 })
				Fatality:CreateAnimation(ValueText,0.45,{ TextStrokeTransparency = 0.850, TextTransparency = 0.400 })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = (Config.Option and 0.6) or 1, })
			else
				Fatality:CreateAnimation(Keybind_Name,0.45,{ TextTransparency = 1, })
				Fatality:CreateAnimation(ValueFrame,0.45,{ BackgroundTransparency = 1 })
				Fatality:CreateAnimation(ValueText,0.45,{ TextStrokeTransparency = 1, TextTransparency = 1 })
				Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = 1, })
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Keybind_Name.Text = new_name
				Fatality:ProtectText(Keybind_Name,new_name);
			end,
			GetValue = function() return Config.Default; end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def, force)
				local IsSame = Config.Default == def;
				Config.Default = def;
				ValueText.Text = GetItem(Config.Default);
				if not IsSame or force then Config.Callback(Config.Default); end;
			end,
			Flag = Config.Flag and Config.Flag.."Keybind",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Keybind"] = Respons;
		end;
		
		if Config.Default then Config.Callback(Config.Default) end

		return Respons;
	end;

	function elements:AddParagraph(settings)
		settings = settings or {}
		if not Fatality:CanShow(settings) then return GetDummyElement() end

		settings.Title = settings.Title or "Paragraph"
		settings.Content = settings.Content or "This is some default content."

		local Paragraph = Instance.new("Frame")
		Paragraph.Name = Fatality:RandomString()
		Paragraph.Parent = Parent
		Fatality:Register(Paragraph, "Element")
		Paragraph.BackgroundTransparency = 1.000
		Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Paragraph.BorderSizePixel = 0
		Paragraph.Size = UDim2.new(1, -25, 0, 0) 
		Paragraph.ZIndex = ZIndex + 1
		Paragraph.ClipsDescendants = true
		Paragraph.AutomaticSize = Enum.AutomaticSize.Y

		local listLayout = Instance.new("UIListLayout")
		listLayout.Parent = Paragraph
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Padding = UDim.new(0, 3)

		local TitleLabel = Instance.new("TextLabel")
		TitleLabel.Name = "Title"
		TitleLabel.Parent = Paragraph
		TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TitleLabel.BackgroundTransparency = 1.000
		TitleLabel.Size = UDim2.new(1, 0, 0, 15)
		TitleLabel.ZIndex = ZIndex + 2
		TitleLabel.FontFace = Fatality.FontSemiBold
		TitleLabel.Text = settings.Title
		Fatality:Register(TitleLabel, "Text", "TextColor3")
		TitleLabel.TextSize = 13.000
		TitleLabel.TextTransparency = 1
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

		local ContentLabel = Instance.new("TextLabel")
		ContentLabel.Name = "Content"
		ContentLabel.Parent = Paragraph
		ContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ContentLabel.BackgroundTransparency = 1.000
		ContentLabel.Size = UDim2.new(1, 0, 0, 0)
		ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
		ContentLabel.ZIndex = ZIndex + 2
		ContentLabel.FontFace = Fatality.FontSemiBold
		ContentLabel.Text = settings.Content
		Fatality:Register(ContentLabel, "TextDark", "TextColor3")
		ContentLabel.TextSize = 12.000
		ContentLabel.TextTransparency = 1
		ContentLabel.TextWrapped = true
		ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
		ContentLabel.TextYAlignment = Enum.TextYAlignment.Top

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(TitleLabel, 0.45, { TextTransparency = 0.200 })
				Fatality:CreateAnimation(ContentLabel, 0.45, { TextTransparency = 0.400 })
			else
				Fatality:CreateAnimation(TitleLabel, 0.45, { TextTransparency = 1 })
				Fatality:CreateAnimation(ContentLabel, 0.45, { TextTransparency = 1 })
			end
		end

		OpcToggle(Event:GetAttribute('V'))
		Event.Event:Connect(OpcToggle)
		return {}
	end;

	function elements:AddInput(settings)
		settings = settings or {}
		if not Fatality:CanShow(settings) then return GetDummyElement() end

		settings.Name = settings.Name or "Input"
		settings.PlaceholderText = settings.PlaceholderText or "..."
		settings.Default = settings.Default or ""
		settings.Callback = settings.Callback or function(text) end

		local InputFrame = Instance.new("Frame")
		local NameLabel = Instance.new("TextLabel")
		local TextBoxFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local TextBox = Instance.new("TextBox")

		InputFrame.Name = Fatality:RandomString()
		InputFrame.Parent = Parent
		Fatality:Register(InputFrame, "Element")
		InputFrame.BackgroundTransparency = 1.000
		InputFrame.Size = UDim2.new(1, -25, 0, 17)
		InputFrame.ZIndex = ZIndex + 1

		NameLabel.Name = "NameLabel"
		NameLabel.Parent = InputFrame
		NameLabel.AnchorPoint = Vector2.new(0, 0.5)
		NameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NameLabel.BackgroundTransparency = 1.000
		NameLabel.Position = UDim2.new(0, 0, 0.5, 0)
		NameLabel.Size = UDim2.new(0.5, 0, 0.8, 0)
		NameLabel.ZIndex = ZIndex + 2
		NameLabel.FontFace = Fatality.FontSemiBold
		NameLabel.Text = settings.Name
		Fatality:Register(NameLabel, "Text", "TextColor3")
		NameLabel.TextSize = 13.000
		NameLabel.TextTransparency = 1
		NameLabel.TextXAlignment = Enum.TextXAlignment.Left

		TextBoxFrame.Name = "TextBoxFrame"
		TextBoxFrame.Parent = InputFrame
		TextBoxFrame.AnchorPoint = Vector2.new(1, 0.5)
		Fatality:Register(TextBoxFrame, "Element")
		TextBoxFrame.Position = UDim2.new(1, -3, 0.5, 0)
		TextBoxFrame.Size = UDim2.new(0, 85, 0.85, 0)
		TextBoxFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = TextBoxFrame

		TextBox.Name = "InputTextBox"
		TextBox.Parent = TextBoxFrame
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.Size = UDim2.new(1, -10, 1, 0)
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.ZIndex = ZIndex + 3
		TextBox.FontFace = Fatality.FontSemiBold
		TextBox.Text = settings.Default
		TextBox.PlaceholderText = settings.PlaceholderText
		Fatality:Register(TextBox, "Text", "TextColor3")
		TextBox.PlaceholderColor3 = Color3.fromRGB(128, 128, 128)
		TextBox.TextSize = 11.000
		TextBox.TextXAlignment = Enum.TextXAlignment.Left
		TextBox.ClearTextOnFocus = false
		TextBox.TextTransparency = 1

		TextBox.FocusLost:Connect(function(enterPressed) settings.Callback(TextBox.Text) end)

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(NameLabel, 0.45, { TextTransparency = 0.200 })
				Fatality:CreateAnimation(TextBoxFrame, 0.45, { BackgroundTransparency = 0 })
				Fatality:CreateAnimation(TextBox, 0.45, { TextTransparency = 0.400 })
			else
				Fatality:CreateAnimation(NameLabel, 0.45, { TextTransparency = 1 })
				Fatality:CreateAnimation(TextBoxFrame, 0.45, { BackgroundTransparency = 1 })
				Fatality:CreateAnimation(TextBox, 0.45, { TextTransparency = 1 })
			end
		end

		OpcToggle(Event:GetAttribute('V'))
		Event.Event:Connect(OpcToggle)

		local Response = { Set = function(text) TextBox.Text = tostring(text) end }
		if settings.Default ~= "" then settings.Callback(settings.Default) end
		
		return Response
	end;

	function elements:AddMetric(Config)
		Config = Config or {}
		if not Fatality:CanShow(Config) then return GetDummyElement() end

		Config.Name = Config.Name or "Metric"
		Config.Default = Config.Default or "..."
		Config.ButtonIcon = Config.ButtonIcon or nil
		Config.Callback = Config.Callback or nil

		local MetricFrame = Instance.new("Frame")
		local NameLabel = Instance.new("TextLabel")
		local ValueLabel = Instance.new("TextLabel")
		local ActionButton = nil
		local UICornerBtn = nil

		MetricFrame.Name = Fatality:RandomString()
		MetricFrame.Parent = Parent
		Fatality:Register(MetricFrame, "Element")
		MetricFrame.BackgroundTransparency = 1.000
		MetricFrame.BorderSizePixel = 0
		MetricFrame.Size = UDim2.new(1, -25, 0, 17)
		MetricFrame.ZIndex = ZIndex + 1

		NameLabel.Name = "MetricName"
		NameLabel.Parent = MetricFrame
		NameLabel.AnchorPoint = Vector2.new(0, 0.5)
		NameLabel.BackgroundTransparency = 1.000
		NameLabel.Position = UDim2.new(0, 0, 0.5, 0)
		NameLabel.Size = UDim2.new(0.5, 0, 0.8, 0)
		NameLabel.ZIndex = ZIndex + 2
		NameLabel.FontFace = Fatality.FontSemiBold
		NameLabel.Text = Config.Name
		Fatality:Register(NameLabel, "TextDark", "TextColor3") 
		NameLabel.TextSize = 12.000
		NameLabel.TextXAlignment = Enum.TextXAlignment.Left

		local valueOffset = Config.ButtonIcon and -22 or 0 
		
		ValueLabel.Name = "MetricValue"
		ValueLabel.Parent = MetricFrame
		ValueLabel.AnchorPoint = Vector2.new(1, 0.5)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.Position = UDim2.new(1, valueOffset, 0.5, 0)
		ValueLabel.Size = UDim2.new(0.5, 0, 0.8, 0)
		ValueLabel.ZIndex = ZIndex + 2
		ValueLabel.FontFace = Fatality.FontSemiBold
		ValueLabel.Text = tostring(Config.Default)
		Fatality:Register(ValueLabel, "Text", "TextColor3") 
		ValueLabel.TextSize = 12.000
		ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

		if Config.ButtonIcon and Config.Callback then
			ActionButton = Instance.new("ImageButton")
			ActionButton.Name = "MetricAction"
			ActionButton.Parent = MetricFrame
			ActionButton.AnchorPoint = Vector2.new(1, 0.5)
			ActionButton.BackgroundTransparency = 1.000
			ActionButton.Position = UDim2.new(1, 0, 0.5, 0)
			ActionButton.Size = UDim2.new(0, 14, 0, 14)
			ActionButton.ZIndex = ZIndex + 3
			ActionButton.Image = Fatality:GetIcon(Config.ButtonIcon)
			ActionButton.ImageTransparency = 0.4
			Fatality:Register(ActionButton, "Text", "ImageColor3")

			Fatality:CreateHover(ActionButton, function(bool)
				if bool then Fatality:CreateAnimation(ActionButton, 0.2, { ImageTransparency = 0 })
				else Fatality:CreateAnimation(ActionButton, 0.2, { ImageTransparency = 0.4 }) end
			end)

			ActionButton.MouseButton1Click:Connect(function()
				Fatality:CreateAnimation(ActionButton, 0.1, { Size = UDim2.new(0, 11, 0, 11) })
				task.delay(0.1, function() Fatality:CreateAnimation(ActionButton, 0.1, { Size = UDim2.new(0, 14, 0, 14) }) end)
				Config.Callback(ValueLabel.Text)
			end)
		end

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(NameLabel, 0.45, { TextTransparency = 0 })
				Fatality:CreateAnimation(ValueLabel, 0.45, { TextTransparency = 0 })
				if ActionButton then Fatality:CreateAnimation(ActionButton, 0.45, { ImageTransparency = 0.4 }) end
			else
				Fatality:CreateAnimation(NameLabel, 0.45, { TextTransparency = 1 })
				Fatality:CreateAnimation(ValueLabel, 0.45, { TextTransparency = 1 })
				if ActionButton then Fatality:CreateAnimation(ActionButton, 0.45, { ImageTransparency = 1 }) end
			end
		end

		OpcToggle(Event:GetAttribute('V'))
		Event.Event:Connect(OpcToggle)

		local Response = {
			Set = function(self, newText)
				local strText = tostring(newText)
				if ValueLabel.Text == strText then return end
				ValueLabel.Text = strText
			end,
			SetName = function(self, newName) NameLabel.Text = tostring(newName) end,
			Get = function(self) return ValueLabel.Text end
		}
		
		return Response
	end; 

	return elements;
end;

function Fatality.new(Window: Window)
	Window = Window or {};
	Window.Name = Window.Name or "FATALITY";
	Window.Scale = Window.Scale or UDim2.new(0, 750, 0, 500);
	Window.Keybind = Window.Keybind or "Insert";
	Window.Expire = Window.Expire or "never";

	local OriginalSize = Window.Scale
	local CurrentKeybind = Window.Keybind

	local Fatal = {
		Menus = {},
		ElementContents = {},
		MenuSelected = nil,
		Toggle = true,
		Signal = Instance.new('BindableEvent');
	};

	Fatal.Notifier = Fatality.__NOTIFIER_CACHE or Fatality:CreateNotifier();

	local function GetSafeColor(val)
		if typeof(val) == "ColorSequence" then return val.Keypoints[1].Value end
		return val
	end

	local Fatalitywin = Instance.new("ScreenGui")
	Fatalitywin.Enabled = false 
	Fatal.Main = Fatalitywin 
	
	local FatalFrame = Instance.new("Frame")
	local MainScale = Instance.new("UIScale")
	MainScale.Parent = FatalFrame
	MainScale.Scale = 1 

	local UICorner = Instance.new("UICorner")
	local DropShadow = Instance.new("ImageLabel")
	local Header = Instance.new("Frame")
	local HeaderLine = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local HeaderText = Instance.new("TextLabel")
	local MenuButtonCont = Instance.new("Frame")
	local tbc = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local UserProfle = Instance.new("Frame")
	local UserIcon = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local User_name = Instance.new("TextLabel")
	local expire_days = Instance.new("TextLabel")
	local HeaderLineShadow = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local MenuFrame = Instance.new("Frame")
	local Bottom = Instance.new("Frame")
	local HeaderLine_2 = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local HeaderLineShadow_2 = Instance.new("Frame")
	local UIGradient_2 = Instance.new("UIGradient")
	local UICorner_6 = Instance.new("UICorner")
	local InfoButton = Instance.new("ImageButton")
	local SearchButton = Instance.new("ImageButton")
	local SaveButton = Instance.new("ImageButton")

	Fatality.WindowFlags[Fatalitywin] = {};
	Fatality:ScrollSignal(tbc,UIListLayout,'X');

	FatalFrame:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
		if FatalFrame.BackgroundTransparency >= 0.99 then Fatalitywin.Enabled = false;
		else Fatalitywin.Enabled = true; end;
	end);

	local ToggleUI = function(bool)
		Fatal.Signal:Fire(bool);

		if bool then
			for i,v in next , Fatal.Menus do v.ValueSelect(false); end;
			if Fatal.MenuSelected then Fatal.MenuSelected.ValueSelect(true) end

			Fatality:CreateAnimation(FatalFrame,0.15,{ Size = Window.Scale, BackgroundTransparency = 0 })
			Fatality:CreateAnimation(Header,0.5,{ BackgroundTransparency = 0 })
			Fatality:CreateAnimation(HeaderLine,0.5,{ BackgroundTransparency = 0 })
			Fatality:CreateAnimation(Bottom,0.5,{ BackgroundTransparency = 0 })
			Fatality:CreateAnimation(HeaderLine_2,0.5,{ BackgroundTransparency = 0 })
			Fatality:CreateAnimation(HeaderLineShadow,0.5,{ BackgroundTransparency = 0.5 })
			Fatality:CreateAnimation(HeaderLineShadow_2,0.5,{ BackgroundTransparency = 0.5 })
			Fatality:CreateAnimation(InfoButton,0.25,{ ImageTransparency = 0.5 })
			Fatality:CreateAnimation(SearchButton,0.25,{ ImageTransparency = 0.5 })
			Fatality:CreateAnimation(SaveButton,0.25,{ ImageTransparency = 0.5 })
			Fatality:CreateAnimation(HeaderText,0.35,{ TextStrokeTransparency = 0.640, TextTransparency = 0 })
			Fatality:CreateAnimation(UserIcon,0.45,{ ImageTransparency = 0, Position = UDim2.new(1, -10,0.5, 0) })
			Fatality:CreateAnimation(User_name,0.35,{ TextTransparency = 0, Position = UDim2.new(1, -40,0, 3) })
			Fatality:CreateAnimation(expire_days,0.5,{ TextTransparency = 0, Position = UDim2.new(1, -40,0, 16) })
			Fatality:CreateAnimation(UIStroke,0.35,{ Thickness = 2.500, Transparency = 0.900 })
			Fatality:CreateAnimation(InfoButton,0.1,Enum.EasingStyle.Back,{ Position = UDim2.new(1, -5,0.5, 0) })
			Fatality:CreateAnimation(SearchButton,0.1,Enum.EasingStyle.Back,{ Position = UDim2.new(0,10,0.5, 0) })
			Fatality:CreateAnimation(SaveButton,0.1,Enum.EasingStyle.Back,{ Position = UDim2.new(0,35,0.5, 0) })
			Fatality:CreateAnimation(DropShadow,0.35,{ ImageTransparency = 0.75 })
		else
			table.clear(Fatality.DragBlacklist);
			for i,v in next , Fatal.Menus do v.ValueSelect(false); end;

			SaveButton.Position = UDim2.new(0,35,1, 20)
			SearchButton.Position = UDim2.new(0,10,1, 20)
			InfoButton.Position = UDim2.new(1, -5,1, 20)
			UIStroke.Thickness = 0
			UIStroke.Transparency = 1
			UserIcon.ImageTransparency = 1
			UserIcon.Position = UDim2.new(1, -10,0.5, 0)
			User_name.TextTransparency = 1
			User_name.Position = UDim2.new(1, -40,0, 3)
			expire_days.TextTransparency = 1
			expire_days.Position = UDim2.new(1, -40,0, 16)
			HeaderText.TextStrokeTransparency = 1
			HeaderText.TextTransparency = 1
			HeaderLineShadow_2.BackgroundTransparency = 1
			InfoButton.ImageTransparency = 1
			SearchButton.ImageTransparency = 1
			SaveButton.ImageTransparency = 1
			HeaderLineShadow.BackgroundTransparency = 1
			FatalFrame.BackgroundTransparency = 1
			Header.BackgroundTransparency = 1
			HeaderLine.BackgroundTransparency = 1
			Bottom.BackgroundTransparency = 1
			HeaderLine_2.BackgroundTransparency = 1
			DropShadow.ImageTransparency = 1
		end
	end

	Fatalitywin.Name = Fatality:RandomString();
	Fatalitywin.Parent = CoreGui;
	Fatalitywin.ResetOnSpawn = false;
	Fatalitywin.IgnoreGuiInset = true;
	Fatalitywin.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	table.insert(Fatality.Windows,Fatalitywin)
	protect_gui(Fatalitywin);

	FatalFrame.Active = true;
	FatalFrame.Name = Fatality:RandomString()
	FatalFrame.Parent = Fatalitywin
	FatalFrame.AnchorPoint = Vector2.new(0.5, 0)
	Fatality:Register(FatalFrame, "Background")
	FatalFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FatalFrame.BorderSizePixel = 0
	FatalFrame.Position = UDim2.new(0.5, 0, 0.2);
	FatalFrame.Size = Window.Scale;
	FatalFrame.ClipsDescendants = true
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = FatalFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = FatalFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = -1
	DropShadow.Image = "rbxassetid://6014261993"
	Fatality:Register(DropShadow, "Outline", "ImageColor3")
	DropShadow.ImageTransparency = 1
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.Rotation = 0.001

	Header.Name = Fatality:RandomString()
	Header.Parent = FatalFrame
	Header.Active = true
	Fatality:Register(Header, "Container")
	Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Header.BorderSizePixel = 0
	Header.Size = UDim2.new(1, 0, 0, 40)
	Header.ZIndex = 2
	HeaderLine.Name = Fatality:RandomString()
	HeaderLine.Parent = Header
	HeaderLine.AnchorPoint = Vector2.new(0, 1)
	Fatality:Register(HeaderLine, "Stroke")
	HeaderLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLine.BorderSizePixel = 0
	HeaderLine.Position = UDim2.new(0, 0, 1, 0)
	HeaderLine.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine.ZIndex = 3
	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = Header

	HeaderText.Name = Fatality:RandomString()
	HeaderText.Parent = Header
	HeaderText.AnchorPoint = Vector2.new(0, 0.5)
	HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeaderText.BackgroundTransparency = 1.000
	HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderText.BorderSizePixel = 0
	HeaderText.Position = UDim2.new(0, 5, 0.5, 0)
	HeaderText.Size = UDim2.new(0, 100, 0.699999988, 0)
	HeaderText.ZIndex = 4
	HeaderText.FontFace = Fatality.Fonts.Bold
	HeaderText.Text = Window.Name
	Fatality:Register(HeaderText, "Text", "TextColor3")
	HeaderText.TextSize = 21.000
	HeaderText.TextStrokeColor3 = Color3.fromRGB(205, 67, 218)
	HeaderText.TextStrokeTransparency = 0.640

	MenuButtonCont.Name = Fatality:RandomString()
	MenuButtonCont.Parent = Header
	MenuButtonCont.AnchorPoint = Vector2.new(0, 0.5)
	MenuButtonCont.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuButtonCont.BackgroundTransparency = 1.000
	MenuButtonCont.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuButtonCont.BorderSizePixel = 0
	MenuButtonCont.ClipsDescendants = true
	MenuButtonCont.Position = UDim2.new(0, 115, 0.5, 0)
	MenuButtonCont.Size = UDim2.new(1, -275, 0.75, 0)
	MenuButtonCont.ZIndex = 4
	tbc.Name = Fatality:RandomString()
	tbc.Parent = MenuButtonCont
	tbc.Active = true
	tbc.AnchorPoint = Vector2.new(0.5, 0.5)
	tbc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tbc.BackgroundTransparency = 1.000
	tbc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tbc.BorderSizePixel = 0
	tbc.ClipsDescendants = false
	tbc.Position = UDim2.new(0.5, 0, 0.5, 0)
	tbc.Size = UDim2.new(1, -2, 1, 0)
	tbc.ZIndex = 4
	tbc.CanvasSize = UDim2.new(2, 0, 0, 0)
	tbc.ScrollBarThickness = 0
	UIListLayout.Parent = tbc
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 4)

	UserProfle.Name = Fatality:RandomString()
	UserProfle.Parent = Header
	UserProfle.AnchorPoint = Vector2.new(1, 0.5)
	UserProfle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserProfle.BackgroundTransparency = 1.000
	UserProfle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserProfle.BorderSizePixel = 0
	UserProfle.Position = UDim2.new(1, -5, 0.5, 0)
	UserProfle.Size = UDim2.new(0, 150, 0.75, 0)
	UserProfle.ZIndex = 4
	UserIcon.Name = Fatality:RandomString()
	UserIcon.Parent = UserProfle
	UserIcon.AnchorPoint = Vector2.new(1, 0.5)
	UserIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserIcon.BackgroundTransparency = 1.000
	UserIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserIcon.BorderSizePixel = 0
	UserIcon.Position = UDim2.new(1, -10, 0.5, 0)
	UserIcon.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
	UserIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
	UserIcon.ZIndex = 5
	UserIcon.Image = Players:GetUserThumbnailAsync(Client.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180);
	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = UserIcon
	UIStroke.Thickness = 2.500
	UIStroke.Transparency = 0.900
	UIStroke.Parent = UserIcon
	User_name.Name = Fatality:RandomString()
	User_name.Parent = UserProfle
	User_name.AnchorPoint = Vector2.new(1, 0)
	User_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	User_name.BackgroundTransparency = 1.000
	User_name.BorderColor3 = Color3.fromRGB(0, 0, 0)
	User_name.BorderSizePixel = 0
	User_name.Position = UDim2.new(1, -40, 0, 3)
	User_name.Size = UDim2.new(0, 200, 0, 15)
	User_name.ZIndex = 4
	User_name.FontFace = Fatality.Fonts.Medium	
	User_name.Text = Client.DisplayName;
	Fatality:Register(User_name, "Text", "TextColor3")
	User_name.TextSize = 13.000
	User_name.TextStrokeTransparency = 0.700
	User_name.TextXAlignment = Enum.TextXAlignment.Right
	expire_days.Name = Fatality:RandomString()
	expire_days.Parent = UserProfle
	expire_days.AnchorPoint = Vector2.new(1, 0)
	expire_days.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	expire_days.BackgroundTransparency = 1.000
	expire_days.BorderColor3 = Color3.fromRGB(0, 0, 0)
	expire_days.BorderSizePixel = 0
	expire_days.Position = UDim2.new(1, -40, 0, 16)
	expire_days.Size = UDim2.new(0, 200, 0, 15)
	expire_days.ZIndex = 4
	expire_days.FontFace = Fatality.Fonts.Medium
	Fatality:Register(expire_days, "Text", "TextColor3")
	expire_days.Text = string.format("<font transparency=\"0.5\">expires:</font> <font color=\"#f53174\">%s</font>",Window.Expire)
	expire_days.TextSize = 12.000
	expire_days.TextStrokeTransparency = 0.700
	expire_days.TextXAlignment = Enum.TextXAlignment.Right
	expire_days.RichText = true;

	HeaderLineShadow.Name = Fatality:RandomString()
	HeaderLineShadow.Parent = Header
	HeaderLineShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow.BorderSizePixel = 0
	HeaderLineShadow.Size = UDim2.new(1, 0, 1, 10)
	UIGradient.Rotation = 90
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient.Parent = HeaderLineShadow
	UICorner_4.CornerRadius = UDim.new(0, 5)
	UICorner_4.Parent = HeaderLineShadow

	MenuFrame.Name = Fatality:RandomString()
	MenuFrame.Parent = FatalFrame
	MenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuFrame.BackgroundTransparency = 1.000
	MenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuFrame.BorderSizePixel = 0
	MenuFrame.Position = UDim2.new(0, 0, 0, 50)
	MenuFrame.Size = UDim2.new(1, 0, 1, -82)

	Bottom.Name = Fatality:RandomString()
	Bottom.Parent = FatalFrame
	Bottom.Active = true
	Bottom.AnchorPoint = Vector2.new(0, 1)
	Fatality:Register(Bottom, "Container")
	Bottom.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Bottom.BorderSizePixel = 0
	Bottom.Position = UDim2.new(0, 0, 1, 0)
	Bottom.Size = UDim2.new(1, 0, 0, 25)
	Bottom.ZIndex = 2
	HeaderLine_2.Name = Fatality:RandomString()
	HeaderLine_2.Parent = Bottom
	Fatality:Register(HeaderLine_2, "Stroke")
	HeaderLine_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLine_2.BorderSizePixel = 0
	HeaderLine_2.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine_2.ZIndex = 3
	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = Bottom
	HeaderLineShadow_2.Name = Fatality:RandomString()
	HeaderLineShadow_2.Parent = Bottom
	HeaderLineShadow_2.AnchorPoint = Vector2.new(0, 1)
	HeaderLineShadow_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow_2.BackgroundTransparency = 0.500
	HeaderLineShadow_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow_2.BorderSizePixel = 0
	HeaderLineShadow_2.Position = UDim2.new(0, 0, 1, 0)
	HeaderLineShadow_2.Size = UDim2.new(1, 0, 1, 5)
	UIGradient_2.Rotation = -90
	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient_2.Parent = HeaderLineShadow_2
	UICorner_6.CornerRadius = UDim.new(0, 5)
	UICorner_6.Parent = HeaderLineShadow_2

	
	InfoButton.Name = Fatality:RandomString()
	InfoButton.Parent = Bottom
	InfoButton.AnchorPoint = Vector2.new(1, 0.5)
	InfoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	InfoButton.BackgroundTransparency = 1.000
	InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	InfoButton.BorderSizePixel = 0
	InfoButton.Position = UDim2.new(1, -5, 0.5, 0)
	InfoButton.Size = UDim2.new(0, 16, 0, 16)
	InfoButton.ZIndex = 4
	InfoButton.Image = "rbxassetid://10723415903"
	InfoButton.ImageTransparency = 0.500
	Fatality:Register(InfoButton, "Text", "ImageColor3")

	SearchButton.Name = Fatality:RandomString()
	SearchButton.Parent = Bottom
	SearchButton.AnchorPoint = Vector2.new(0, 0.5)
	SearchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchButton.BackgroundTransparency = 1.000
	SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchButton.BorderSizePixel = 0
	SearchButton.Position = UDim2.new(0, 10, 0.5, 0)
	SearchButton.Size = UDim2.new(0, 16, 0, 16)
	SearchButton.ZIndex = 4
	SearchButton.Image = "rbxassetid://10734943674"
	SearchButton.ImageTransparency = 0.500
	Fatality:Register(SearchButton, "Text", "ImageColor3")

	Fatality:CreateHover(SaveButton,function(bool) if bool then Fatality:CreateAnimation(SaveButton,0.5,{ ImageTransparency = 0.1 }) else Fatality:CreateAnimation(SaveButton,0.5,{ ImageTransparency = 0.5 }) end	end);
	Fatality:CreateHover(InfoButton,function(bool) if bool then Fatality:CreateAnimation(InfoButton,0.5,{ ImageTransparency = 0.1 }) else Fatality:CreateAnimation(InfoButton,0.5,{ ImageTransparency = 0.5 }) end	end);
	Fatality:CreateHover(SearchButton,function(bool) if bool then Fatality:CreateAnimation(SearchButton,0.5,{ ImageTransparency = 0.1 }) else Fatality:CreateAnimation(SearchButton,0.5,{ ImageTransparency = 0.5 }) end	end);

	function Fatal:AddSave(callback) SaveButton.MouseButton1Click:Connect(callback); end;

	Fatality:Drag(FatalFrame,FatalFrame,0.1);
	Fatality:Drag(Header, FatalFrame, 0.1)
	Fatality:Drag(Bottom, FatalFrame, 0.1)
	Fatality:Drag(MenuFrame, FatalFrame, 0.1)

	UserInputService.InputBegan:Connect(function(input,istyping)
		if not istyping then
			local keyPressed = input.KeyCode
			local isMatch = false
			if typeof(CurrentKeybind) == "string" then
				if keyPressed.Name == CurrentKeybind or tostring(keyPressed) == CurrentKeybind then isMatch = true end
			elseif typeof(CurrentKeybind) == "EnumItem" then
				if keyPressed == CurrentKeybind then isMatch = true end
			end
			if isMatch then
				Fatal.Toggle = not Fatal.Toggle;
				ToggleUI(Fatal.Toggle);
			end;
		end
	end)

	function Fatal:SetUsername(name: string) User_name.Text = name or Client.DisplayName; end;
	function Fatal:SetProfile(icon: string) UserIcon.Image = icon or Players:GetUserThumbnailAsync(Client.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180); end;
	function Fatal:SetExpire(str: string) expire_days.Text = string.format("<font transparency=\"0.5\">expires:</font> <font color=\"#f53174\">%s</font>",str) end;
	
	function Fatal:SetScale(percent: number) 
		Fatality.Scale = percent / 100 
		MainScale.Scale = Fatality.Scale 
		for _, scaleObj in pairs(Fatality.ScalesRegistry) do
			if scaleObj and scaleObj.Parent then
				scaleObj.Scale = Fatality.Scale
			end
		end
	end
	
	function Fatal:SetKeybind(key) CurrentKeybind = key end
	function Fatal:GetFlags() return Fatality.WindowFlags[Fatalitywin]; end;

	function Fatal:AddMenu(Menu : Menu) 
		Menu = Menu or {};
        if not Fatality:CanShow(Menu) then return { AddSection = function() return Fatality.Dummy end, AddPreview = function() return Fatality.Dummy end, AddProduct = function() return {SetButton=function()end, SetStatus=function()end, SetVisible=function()end, GetButton=function() return Instance.new("TextButton") end} end, AddColumnTitle = function() end } end
		Menu.Name = Menu.Name or "EXAMPLE";
		Menu.Icon = Menu.Icon or "eye";
		Menu.AutoFill = false; 

		local MenuLib = {};
		local MenuButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Icon = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local menu_name = Instance.new("TextLabel")

		MenuButton.Name = Fatality:RandomString()
		MenuButton.Parent = tbc;
		Fatality:Register(MenuButton, "TabActive") 
		MenuButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuButton.BorderSizePixel = 0
		MenuButton.Size = UDim2.new(0, 90, 0.85, 0)
		MenuButton.ZIndex = 5
		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = MenuButton
		UIStroke.Transparency = 0.950
		UIStroke.Parent = MenuButton
		Icon.Name = Fatality:RandomString()
		Icon.Parent = MenuButton
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 5, 0.5, 0)
		Icon.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		Icon.ZIndex = 5
		Icon.Image = Fatality:GetIcon(Menu.Icon);
		Fatality:Register(Icon, "Text", "ImageColor3")
		Icon.ScaleType = Enum.ScaleType.Crop
		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Icon
		menu_name.Name = Fatality:RandomString()
		menu_name.Parent = MenuButton
		menu_name.AnchorPoint = Vector2.new(0, 0.5)
		menu_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		menu_name.BackgroundTransparency = 1.000
		menu_name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		menu_name.BorderSizePixel = 0
		menu_name.Position = UDim2.new(0, 28, 0.5, 0)
		menu_name.Size = UDim2.new(1, 0, 1, 0)
		menu_name.ZIndex = 5
		menu_name.FontFace = Fatality.Fonts.Bold
		menu_name.Text = Menu.Name
		Fatality:Register(menu_name, "Text", "TextColor3") 
		menu_name.TextSize = 13.000
		menu_name.TextStrokeTransparency = 0.900
		menu_name.TextTransparency = 0.150
		menu_name.TextXAlignment = Enum.TextXAlignment.Left
		local text_size = Fatality:GetTextSize(menu_name);
		MenuButton.Size = UDim2.new(0, text_size.X + 33, 0.85, 0)

		local MenuLiber = Instance.new("Frame")
		local Left = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local Center = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local Right = Instance.new("ScrollingFrame")
		local UIListLayout_3 = Instance.new("UIListLayout")

		MenuLiber.Name = Fatality:RandomString()
		MenuLiber.Parent = MenuFrame
		MenuLiber.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MenuLiber.BackgroundTransparency = 1.000
		MenuLiber.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuLiber.BorderSizePixel = 0
		MenuLiber.ClipsDescendants = true
		MenuLiber.Size = UDim2.new(1, 0, 1, 0)
		MenuLiber.ZIndex = 7
		
		Left.Name = "Left" 
		Left.Parent = MenuLiber
		Left.Active = true
		Left.AnchorPoint = Vector2.new(0.5, 0.5)
		Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Left.BackgroundTransparency = 1.000
		Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Left.BorderSizePixel = 0
		Left.ClipsDescendants = false
		Left.Position = UDim2.new(0.175, 0, 0.5, 0)
		Left.Size = UDim2.new(0.32, 0, 1, -5)
		Left.ScrollBarThickness = 0
		UIListLayout.Parent = Left
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.VerticalFlex = Enum.UIFlexAlignment.None; 

		Center.Name = "Center"
		Center.Parent = MenuLiber
		Center.Active = true
		Center.AnchorPoint = Vector2.new(0.5, 0.5)
		Center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Center.BackgroundTransparency = 1.000
		Center.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Center.BorderSizePixel = 0
		Center.ClipsDescendants = false
		Center.Position = UDim2.new(0.5, 0, 0.5, 0)
		Center.Size = UDim2.new(0.32, 0, 1, -5)
		Center.ScrollBarThickness = 0
		UIListLayout_2.Parent = Center
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)
		UIListLayout_2.VerticalFlex = Enum.UIFlexAlignment.None;

		Right.Name = "Right"
		Right.Parent = MenuLiber
		Right.Active = true
		Right.AnchorPoint = Vector2.new(0.5, 0.5)
		Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Right.BackgroundTransparency = 1.000
		Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Right.BorderSizePixel = 0
		Right.ClipsDescendants = false
		Right.Position = UDim2.new(0.825, 0, 0.5, 0)
		Right.Size = UDim2.new(0.32, 0, 1, -5)
		Right.ScrollBarThickness = 0
		UIListLayout_3.Parent = Right
		UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.Padding = UDim.new(0, 5)
		UIListLayout_3.VerticalFlex = Enum.UIFlexAlignment.None;

		local BindEvent = Instance.new('BindableEvent',MenuLiber);
		BindEvent.Name = Fatality:RandomString();
		
        Fatality:ScrollSignal(Right,UIListLayout_3,'Y'); 
        Fatality:ScrollSignal(Center,UIListLayout_2,'Y'); 
        Fatality:ScrollSignal(Left,UIListLayout,'Y'); 

		Fatal.Signal.Event:Connect(function(Bool)
			if Bool then
				Fatality:CreateAnimation(MenuButton,0.5,{ BackgroundTransparency = (MenuLiber.Visible and 0) or 1 })
				Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 0.950 })
				Fatality:CreateAnimation(Left,0.3,{ Position = UDim2.new(0.175, 0, 0.5, 0) })
				Fatality:CreateAnimation(Center,0.4,{ Position = UDim2.new(0.5, 0, 0.5, 0) })
				Fatality:CreateAnimation(Right,0.5,{ Position = UDim2.new(0.825, 0, 0.5, 0) })
				Fatality:CreateAnimation(Icon,0.5,{ ImageTransparency = (MenuLiber.Visible and 0.15) or 0.5 })
				Fatality:CreateAnimation(menu_name,0.5,{ TextStrokeTransparency = 0.900, TextTransparency = (MenuLiber.Visible and 0.15) or 0.5 })
			else
				Fatality:CreateAnimation(Left,0.5,{ Position = UDim2.new(0.175, 0, 0.5, 1) })
				Fatality:CreateAnimation(Center,0.5,{ Position = UDim2.new(0.5, 0, 0.5, 2) })
				Fatality:CreateAnimation(Right,0.5,{ Position = UDim2.new(0.825, 0, 0.5, 3) })
				Fatality:CreateAnimation(MenuButton,0.5,{ BackgroundTransparency = 1 })
				Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 1 })
				Fatality:CreateAnimation(Icon,0.5,{ ImageTransparency = 1 })
				Fatality:CreateAnimation(menu_name,0.5,{ TextStrokeTransparency = 1, TextTransparency = 1 })
			end;
		end)

		local ValueSelect = function(val)
			if val then
				MenuLiber.Visible = true;
				Fatality:CreateAnimation(Icon,0.5,{ ImageTransparency = 0.15, ImageColor3 = Fatality:GetColor("Main") });
				Fatality:CreateAnimation(menu_name,0.5,{ TextTransparency = 0.15 });
				Fatality:CreateAnimation(MenuButton,0.5,{ BackgroundTransparency = 0 })
				BindEvent:SetAttribute('V',true); BindEvent:Fire(true);
			else
				BindEvent:SetAttribute('V',false); BindEvent:Fire(false);
				MenuLiber.Visible = false;
				Fatality:CreateAnimation(Icon,0.5,{ ImageTransparency = 0.5, ImageColor3 = Fatality:GetColor("Text") });
				Fatality:CreateAnimation(MenuButton,0.5,{ BackgroundTransparency = 1 })
				Fatality:CreateAnimation(menu_name,0.5,{ TextTransparency = 0.5 });
			end;
		end;

		local _B = { Root = MenuLiber, ValueSelect = ValueSelect, Bindable = BindEvent, };
		if not Fatal.MenuSelected then Fatal.MenuSelected = _B; ValueSelect(true); else ValueSelect(false); end;
		table.insert(Fatal.Menus,_B)
		Fatality:CreateHover(MenuButton,function(bool)
			if Fatal.MenuSelected.Root ~= MenuLiber then
				if bool then Fatality:CreateAnimation(Icon,0.5,{ ImageTransparency = 0.2, ImageColor3 = Fatality:GetColor("Text") }); Fatality:CreateAnimation(MenuButton,0.5,{ BackgroundTransparency = 1 }) Fatality:CreateAnimation(menu_name,0.5,{ TextTransparency = 0.2 });
				else Fatality:CreateAnimation(Icon,0.5,{ ImageTransparency = 0.5, ImageColor3 = Fatality:GetColor("Text") }); Fatality:CreateAnimation(MenuButton,0.5,{ BackgroundTransparency = 1 }) Fatality:CreateAnimation(menu_name,0.5,{ TextTransparency = 0.5 }); end
			end;
		end)
		Fatality:NewInput(MenuButton, function() 
			if Fatal.MenuSelected and Fatal.MenuSelected.Root == MenuLiber then return end 
			
			for i, v in next, Fatal.Menus do 
				if v.Root == MenuLiber then 
					Fatal.MenuSelected = v; 
					v.ValueSelect(true) 
				else 
					v.ValueSelect(false) 
				end; 
			end; 
		end);

		function MenuLib:AddPreview(Config: Preview)
			Config = Config or {}; Config.Name = Config.Name or "PREVIEW"; Config.Position = Config.Position or "left"; Config.Height = Config.Height or 0;
			local Preview = Instance.new("Frame")
			local PreviewName = Instance.new("TextLabel")
			local Main = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local MainBlock = Instance.new("Frame")
			Preview.Name = "Preview"
			Preview.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Fatality:Register(Preview, "Background")
			Preview.BackgroundTransparency = 1
			Preview.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Preview.BorderSizePixel = 0
			Preview.ClipsDescendants = true
			Preview.ZIndex = 15;
			Preview.Size = UDim2.new(1, 0, 0, 25 + Config.Height)
			PreviewName.Name = "PreviewName"
			PreviewName.Parent = Preview
			PreviewName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PreviewName.BackgroundTransparency = 1.000
			PreviewName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PreviewName.BorderSizePixel = 0
			PreviewName.Position = UDim2.new(0, 10, 0, 0)
			PreviewName.Size = UDim2.new(1, 0, 0, 15)
			PreviewName.ZIndex = 19
			PreviewName.FontFace = Fatality.FontSemiBold
			PreviewName.Text = Config.Name
			Fatality:Register(PreviewName, "Text", "TextColor3")
			PreviewName.TextSize = 15.000
			PreviewName.TextStrokeTransparency = 0.750
			PreviewName.TextXAlignment = Enum.TextXAlignment.Left
			Main.Name = "Main"
			Main.Parent = Preview
			Main.AnchorPoint = Vector2.new(0.5, 1)
			Fatality:Register(Main, "Container")
			Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Main.BorderSizePixel = 0
			Main.Position = UDim2.new(0.5, 0, 1, -1)
			Main.Size = UDim2.new(1, -5, 1, -10)
			Main.ZIndex = 17
			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			Fatality:Register(UIStroke, "Stroke", "Color")
			UIStroke.Parent = Main
			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Main
			MainBlock.Name = "MainBlock"
			MainBlock.Parent = Main
			MainBlock.AnchorPoint = Vector2.new(0.5, 0.5)
			MainBlock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainBlock.BackgroundTransparency = 1.000
			MainBlock.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainBlock.BorderSizePixel = 0
			MainBlock.Position = UDim2.new(0.5, 0, 0.5, 0)
			MainBlock.Size = UDim2.new(1, -5, 1, -5)
			MainBlock.ZIndex = 18
			local Toggle = function(v)
				if v then Fatality:CreateAnimation(Preview,0.5,{ BackgroundTransparency = 0 }) Fatality:CreateAnimation(PreviewName,0.5,{ TextStrokeTransparency = 0.750, TextTransparency = 0 }) Fatality:CreateAnimation(Main,0.5,{ BackgroundTransparency = 0 }) Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 0 }) Fatality:CreateAnimation(MainBlock,0.5,{ Size = UDim2.new(1, -5, 1, -5) })
				else Fatality:CreateAnimation(Preview,0.5,{ BackgroundTransparency = 1 }) Fatality:CreateAnimation(PreviewName,0.5,{ TextStrokeTransparency = 1, TextTransparency = 1 }) Fatality:CreateAnimation(Main,0.5,{ BackgroundTransparency = 1 }) Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 1 }) Fatality:CreateAnimation(MainBlock,0.5,{ Size = UDim2.new(0,0,0,0) }) end
			end;
			Toggle(BindEvent:GetAttribute('V'));
			BindEvent.Event:Connect(Toggle);
			return MainBlock;
		end;

		function MenuLib:AddListBox(Config : Listbox)
			Config = Config or {}; Config.Name = Config.Name or "LIST BOX"; Config.Position = Config.Position or "left"; Config.Height = Config.Height or 0; Config.Values = Config.Values or {}; Config.Multi = Config.Multi or false; Config.Default = Config.Default or ((Config.Multi and nil) or {}); Config.Callback = Config.Callback or function() end;
			table.insert(Fatal.ElementContents,{ Name = Config.Name, Path = Menu.Name .. " > ".. Config.Name, _TAB = _B });
			local ListBox = Instance.new("Frame")
			local Elements = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local SearchBox = Instance.new("Frame")
			local TextBox = Instance.new("TextBox")
			local UICorner_2 = Instance.new("UICorner")
			local UIStroke_2 = Instance.new("UIStroke")
			local OptionButton = Instance.new("ImageButton")
			local ScrollingFrame = Instance.new("ScrollingFrame")
			local UICorner_3 = Instance.new("UICorner")
			local UIStroke_3 = Instance.new("UIStroke")
			local UIListLayout = Instance.new("UIListLayout")
			local SpaceBox = Instance.new("Frame")
			local ListName = Instance.new("TextLabel")
			ListBox.Name = Fatality:RandomString()
			ListBox.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Fatality:Register(ListBox, "Background")
			ListBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListBox.BorderSizePixel = 0
			ListBox.ClipsDescendants = true
			ListBox.Size = UDim2.new(1, 0, 0, 350)
			ListBox.ZIndex = 10
			Fatality:AddDragBlacklist(ScrollingFrame);
			Elements.Name = Fatality:RandomString()
			Elements.Parent = ListBox
			Elements.AnchorPoint = Vector2.new(0.5, 1)
			Fatality:Register(Elements, "Container")
			Elements.BackgroundTransparency = 0
			Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Elements.BorderSizePixel = 0
			Elements.Position = UDim2.new(0.5, 0, 1, -1)
			Elements.Size = UDim2.new(1, -5, 1, -10)
			Elements.ZIndex = 10
			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			Fatality:Register(UIStroke, "Stroke", "Color")
			UIStroke.Parent = Elements
			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Elements
			SearchBox.Name = Fatality:RandomString()
			SearchBox.Parent = Elements
			Fatality:Register(SearchBox, "Element")
			SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SearchBox.BorderSizePixel = 0
			SearchBox.ClipsDescendants = true
			SearchBox.Position = UDim2.new(0, 10, 0, 15)
			SearchBox.Size = UDim2.new(0, 195, 0, 16)
			SearchBox.ZIndex = 10
			TextBox.Parent = SearchBox
			Fatality:Register(TextBox, "Element")
			TextBox.BackgroundTransparency = 1.000
			TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextBox.BorderSizePixel = 0
			TextBox.Position = UDim2.new(0, 5, 0, 0)
			TextBox.Size = UDim2.new(1, -10, 0, 16)
			TextBox.ZIndex = 11
			TextBox.ClearTextOnFocus = false
			TextBox.FontFace = Fatality.FontSemiBold
			TextBox.PlaceholderText = "Start typing..."
			TextBox.Text = ""
			Fatality:Register(TextBox, "Text", "TextColor3")
			TextBox.TextSize = 11.000
			TextBox.TextXAlignment = Enum.TextXAlignment.Left
			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = SearchBox
			UIStroke_2.Transparency = 0.750
			UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
			Fatality:Register(UIStroke_2, "Stroke", "Color")
			UIStroke_2.Parent = SearchBox
			OptionButton.Name = Fatality:RandomString()
			OptionButton.Parent = Elements
			OptionButton.AnchorPoint = Vector2.new(1, 0)
			OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OptionButton.BackgroundTransparency = 1.000
			OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OptionButton.BorderSizePixel = 0
			OptionButton.Position = UDim2.new(1, -10, 0, 16)
			OptionButton.Size = UDim2.new(0, 13, 0, 13)
			OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
			OptionButton.ZIndex = 11
			OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
			OptionButton.ImageTransparency = 0.600
			OptionButton.Visible = Config.Option or false;
			ScrollingFrame.Parent = Elements
			ScrollingFrame.Active = true
			ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
			Fatality:Register(ScrollingFrame, "Element")
			ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 40)
			ScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
			ScrollingFrame.ZIndex = 11
			ScrollingFrame.ScrollBarThickness = 0
			ScrollingFrame.ScrollBarImageTransparency = 1
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
			UICorner_3.CornerRadius = UDim.new(0, 3)
			UICorner_3.Parent = ScrollingFrame
			UIStroke_3.Transparency = 0.750
			UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
			Fatality:Register(UIStroke_3, "Stroke", "Color")
			UIStroke_3.Parent = ScrollingFrame
			UIListLayout.Parent = ScrollingFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)
			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local all = (#ScrollingFrame:GetChildren() - 1);
				local unscaledSize = math.clamp((all * (10 + UIListLayout.Padding.Offset)) + (Config.Height + UIListLayout.Padding.Offset), 25, 400);
				
				if Menu.AutoFill then 
					ListBox.Size = UDim2.new(1, 0, 0, unscaledSize / 2.5); 
				else 
					ListBox.Size = UDim2.new(1, 0, 0, unscaledSize); 
				end;
				
				ScrollingFrame.CanvasSize = UDim2.fromOffset(0, math.round(UIListLayout.AbsoluteContentSize.Y / Fatality.Scale));
			end)
			SpaceBox.Name = Fatality:RandomString()
			SpaceBox.Parent = ScrollingFrame
			SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SpaceBox.BorderSizePixel = 0
			SpaceBox.Size = UDim2.new(0, 0, 0, 1)
			ListName.Name = Fatality:RandomString()
			ListName.Parent = ListBox
			ListName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ListName.BackgroundTransparency = 1.000
			ListName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListName.BorderSizePixel = 0
			ListName.Position = UDim2.new(0, 10, 0, 0)
			ListName.Size = UDim2.new(1, 0, 0, 15)
			ListName.ZIndex = 10
			ListName.FontFace = Fatality.FontSemiBold
			ListName.Text = Config.Name
			Fatality:Register(ListName, "Text", "TextColor3")
			ListName.TextSize = 15.000
			ListName.TextStrokeTransparency = 0.750
			ListName.TextXAlignment = Enum.TextXAlignment.Left
			
			local new_button = function()
				local db_selected = Instance.new("TextButton")
				db_selected.Name = Fatality:RandomString()
				db_selected.BackgroundTransparency = 1.000
				db_selected.Size = UDim2.new(1, 0, 0, 10)
				db_selected.ZIndex = 15
				db_selected.FontFace = Fatality.FontSemiBold
				db_selected.TextColor3 = Fatality:GetColor("Main")
				db_selected.TextSize = 12.000
				db_selected.TextTransparency = 0.5;
				db_selected.TextXAlignment = Enum.TextXAlignment.Left
				return db_selected;
			end;

			local Toggle = function(v)
				if v then
					Fatality:CreateAnimation(ListBox,0.5,{ BackgroundTransparency = 0 }) Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 0 }) Fatality:CreateAnimation(UIStroke_2,0.5,{ Transparency = 0.75 }) Fatality:CreateAnimation(UIStroke_3,0.5,{ Transparency = 0.75 }) Fatality:CreateAnimation(SearchBox,0.5,{ BackgroundTransparency = 0 }) Fatality:CreateAnimation(TextBox,0.5,{ TextTransparency = 0 }) Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = (Config.Option and 0.6) or 1, }) Fatality:CreateAnimation(ScrollingFrame,0.45,{ BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0, 40) }) table.foreach(ScrollingFrame:GetChildren(),function(i,v) if v:IsA('TextButton') then Fatality:CreateAnimation(v,0.45,{ TextTransparency = 0.5 }); end; end); Fatality:CreateAnimation(ListName,0.5,{ TextStrokeTransparency = 0.75, TextTransparency = 0 })
				else
					table.foreach(ScrollingFrame:GetChildren(),function(i,v) if v:IsA('TextButton') then Fatality:CreateAnimation(v,0.45,{ TextTransparency = 1 }); end; end); Fatality:CreateAnimation(ListBox,0.5,{ BackgroundTransparency = 1 }) Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 1 }) Fatality:CreateAnimation(UIStroke_2,0.5,{ Transparency = 1 }) Fatality:CreateAnimation(UIStroke_3,0.5,{ Transparency = 1 }) Fatality:CreateAnimation(SearchBox,0.5,{ BackgroundTransparency = 1 }) Fatality:CreateAnimation(TextBox,0.5,{ TextTransparency = 1 }) Fatality:CreateAnimation(OptionButton,0.45,{ ImageTransparency = 1 }) Fatality:CreateAnimation(ScrollingFrame,0.45,{ BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0, 40) }) Fatality:CreateAnimation(ListName,0.5,{ TextStrokeTransparency = 1, TextTransparency = 1 })
				end
			end;
			Toggle(BindEvent:GetAttribute('V'));
			BindEvent.Event:Connect(Toggle);
			
			local DearchDelay = tick();
			TextBox:GetPropertyChangedSignal('Text'):Connect(function()
				DearchDelay = tick();
				if not TextBox.Text:byte() then for i,v in next , ScrollingFrame:GetChildren() do if v:IsA('TextButton') then v.Visible = true; end; end; return; end;
				task.delay(0.25,function() if (tick() - DearchDelay) > 0.25 then for i,v in next , ScrollingFrame:GetChildren() do if v:IsA('TextButton') then if string.find(string.lower(v.Text),string.lower(TextBox.Text),1,true) then v.Visible = true; else v.Visible = false; end; end; end; end; end)
			end);
			
			local res;
			local ListBoxButtons = {};

			res = Fatality:CreateResponse({
				Refresh = function()
					for i,v in next , ScrollingFrame:GetChildren() do if v:IsA('TextButton') then v:Destroy(); end; end;
					table.clear(ListBoxButtons)
					local selectedmem;
					for i,v in next , Config.Values do
						local bth = new_button();
						bth.Text = string.rep(" ",2)..tostring(v);
						bth.Parent = ScrollingFrame;
						table.insert(ListBoxButtons, {Btn = bth, Value = v})

						if Config.Multi then
							if (typeof(Config.Default) == 'table' and (Config.Default[v] or table.find(Config.Default,v))) or Config.Default == v then Config.Default[v] = true; bth.TextColor3 = Fatality:GetColor("Main"); bth.TextTransparency = 0; else bth.TextColor3 = Fatality:GetColor("Text"); bth.TextTransparency = 0.5; Config.Default[v] = false end;
							Fatality:CreateHover(bth,function(bool) if not Config.Default[v] then if bool then Fatality:CreateAnimation(bth,0.25,{ TextTransparency = 0; }) else Fatality:CreateAnimation(bth,0.25,{ TextTransparency = 0.5; }) end; end; end)
							bth.MouseButton1Click:Connect(function() Config.Default[v] = not Config.Default[v]; if Config.Default[v] then bth.TextColor3 = Fatality:GetColor("Main"); bth.TextTransparency = 0; else bth.TextColor3 = Fatality:GetColor("Text"); bth.TextTransparency = 0.5; end; Config.Callback(Config.Default); end)
						else
							if v == Config.Default then selectedmem = bth; Config.Default = v; bth.TextColor3 = Fatality:GetColor("Main"); bth.TextTransparency = 0; else bth.TextColor3 = Fatality:GetColor("Text"); bth.TextTransparency = 0.5; end;
							Fatality:CreateHover(bth,function(bool) if Config.Default ~= v then if bool then Fatality:CreateAnimation(bth,0.25,{ TextTransparency = 0; }) else Fatality:CreateAnimation(bth,0.25,{ TextTransparency = 0.5; }) end; end; end)
							bth.MouseButton1Click:Connect(function() if selectedmem then selectedmem.TextColor3 = Fatality:GetColor("Text"); selectedmem.TextTransparency = 0.5; end; bth.TextTransparency = 0; bth.TextColor3 = Fatality:GetColor("Main"); selectedmem = bth; Config.Default = v; Config.Callback(v); end)
						end;
					end;
					Config.Callback(Config.Default);
				end,
				SetValues = function(value) Config.Values = value; end,
				SetDefault = function(value) Config.Default = value; end,
				GetValue = function() return Config.Default; end,
				Flag = Config.Flag and Config.Flag.."ListBox",
				SetValue = function(a) Config.Default = a; res:Refresh(); Config.Callback(Config.Default); end,
				Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
			});

			Fatality.ThemeEvent.Event:Connect(function()
				for _, data in pairs(ListBoxButtons) do
					if data.Btn and data.Btn.Parent then
						local isSelected = false
						if Config.Multi then isSelected = Config.Default[data.Value] == true else isSelected = (Config.Default == data.Value) end
						game:GetService("TweenService"):Create(data.Btn, TweenInfo.new(0.3), {TextColor3 = isSelected and Fatality:GetColor("Main") or Fatality:GetColor("Text")}):Play()
					end
				end
			end)

			res:Refresh();
			if Config.Flag then Fatality.WindowFlags[Fatalitywin][Config.Flag.."ListBox"] = res; end;
			return res;
		end;

		function MenuLib:AddSection(Config : Section)
			Config = Config or {};
			if not Fatality:CanShow(Config) then return Fatality.Dummy end
			Config.Name = Config.Name or "SECTION"; Config.Position = Config.Position or "center"; Config.Height = Config.Height or 0;
			table.insert(Fatal.ElementContents,{ Name = Config.Name, Path = Menu.Name .. " > ".. Config.Name, _TAB = _B });
			local Section = Instance.new("Frame")
			local Elements = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")
			local SpaceBox = Instance.new("Frame")
			local SectionName = Instance.new("TextLabel")
			local Toggle = function(v)
				if v then Fatality:CreateAnimation(Section,0.5,{ BackgroundTransparency = 0 }) Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 0 }) Fatality:CreateAnimation(SectionName,0.5,{ TextStrokeTransparency = 0.750, TextTransparency = 0 })
				else Fatality:CreateAnimation(Section,0.5,{ BackgroundTransparency = 1 }) Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 1 }) Fatality:CreateAnimation(SectionName,0.5,{ TextStrokeTransparency = 1, TextTransparency = 1 }) end
			end;
			Section.Name = Fatality:RandomString()
			Section.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Fatality:Register(Section, "Background")
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(1, 0, 0, 0)
			Elements.Name = Fatality:RandomString()
			Elements.Parent = Section
			Elements.AnchorPoint = Vector2.new(0.5, 1)
			Fatality:Register(Elements, "Container")
			Elements.BackgroundTransparency = 0
			Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Elements.BorderSizePixel = 0
			Elements.Position = UDim2.new(0.5, 0, 1, -1)
			Elements.Size = UDim2.new(1, -5, 1, -10)
			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			Fatality:Register(UIStroke, "Stroke", "Color")
			UIStroke.Parent = Elements
			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Elements
			UIListLayout.Parent = Elements
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)
			SpaceBox.Name = Fatality:RandomString()
			SpaceBox.Parent = Elements
			SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SpaceBox.BorderSizePixel = 0
			SpaceBox.Size = UDim2.new(0, 0, 0, 10)
			SectionName.Name = Fatality:RandomString()
			SectionName.Parent = Section
			SectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.BackgroundTransparency = 1.000
			SectionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionName.BorderSizePixel = 0
			SectionName.Position = UDim2.new(0, 10, 0, 0)
			SectionName.Size = UDim2.new(1, 0, 0, 15)
			SectionName.FontFace = Fatality.FontSemiBold;
			SectionName.Text = Config.Name
			Fatality:Register(SectionName, "Text", "TextColor3")
			SectionName.TextSize = 15.000
			SectionName.TextStrokeTransparency = 0.750
			SectionName.TextXAlignment = Enum.TextXAlignment.Left
			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() 
				local unscaledHeight = UIListLayout.AbsoluteContentSize.Y / Fatality.Scale
				local targetHeight = unscaledHeight + 20 + Config.Height
				
				if not Menu.AutoFill then 
					Fatality:CreateAnimation(Section, 0.25, { Size = UDim2.new(1, 0, 0, targetHeight) }) 
				else 
					Section.Size = UDim2.new(1, 0, 0, targetHeight / 2.5); 
				end;
			end);
			Toggle(BindEvent:GetAttribute('V'));
			BindEvent.Event:Connect(Toggle);
			return Fatality:CreateElements(Elements,Elements.ZIndex,BindEvent,{
				Path = Menu.Name .. " > ".. Config.Name,
				Memory = function(Name) table.insert(Fatal.ElementContents,{ Name = Name, Path = Menu.Name .. " > ".. Config.Name .. " > " .. Name, _TAB = _B }); end,
			});
		end;

		function MenuLib:AddColumnTitle(Config)
			Config = Config or {}
			Config.Text = Config.Text or "TITLE"
			Config.Position = Config.Position or "center"

			local Parent = (Config.Position == 'left' and Left) or (Config.Position == 'center' and Center) or Right

			local Container = Instance.new("Frame")
			Container.Name = "ColTitle_" .. Config.Text
			Container.Parent = Parent
			Container.BackgroundTransparency = 1
			Container.Size = UDim2.new(1, 0, 0, 25) 
			Container.LayoutOrder = -999 
			Container.ZIndex = 10

			local Label = Instance.new("TextLabel")
			Label.Parent = Container
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, 0, 1, -2) 
			Label.Position = UDim2.new(0, 0, 0, 2)
			Label.FontFace = Fatality.Fonts.Bold
			Label.Text = string.upper(Config.Text)
			Fatality:Register(Label, "TextDark", "TextColor3")
			Label.TextSize = 15
			Label.TextXAlignment = Enum.TextXAlignment.Center
			Label.ZIndex = 11

			local Toggle = function(v)
				if v then Fatality:CreateAnimation(Label, 0.5, {TextTransparency = 0})
				else Fatality:CreateAnimation(Label, 0.5, {TextTransparency = 1}) end
			end
			Toggle(BindEvent:GetAttribute('V'))
			BindEvent.Event:Connect(Toggle)

			return Container
		end
		
		function MenuLib:AddProduct(Config)
			Config = Config or {};
			if not Fatality:CanShow(Config) then return Fatality.Dummy end
			
			Config.Name = Config.Name or "SCRIPT";
			Config.Version = Config.Version or "1.0";
			Config.Author = Config.Author or "Unknown";
			Config.Status = Config.Status or "Working";
			Config.Description = Config.Description or "No desc";
			Config.Tags = Config.Tags or {};
			Config.DateCreate = Config.DateCreate or "-";
			Config.DateUpdate = Config.DateUpdate or "-";
			
			Config.Likes = Config.Likes or 0
			Config.Dislikes = Config.Dislikes or 0
			Config.Downloads = Config.Downloads or 0
			Config.UserVote = Config.UserVote or 0
			Config.IsFavorite = Config.IsFavorite or false
			Config.IsOfficial = Config.IsOfficial or false
			
			Config.ButtonText = Config.ButtonText or "Install";
			Config.Callback = Config.Callback or function() end;
			Config.FavCallback = Config.FavCallback or function(v) end;
			Config.VoteCallback = Config.VoteCallback or function(v) end;
			Config.Position = Config.Position or "center";

			table.insert(Fatal.ElementContents, {
				Name = Config.Name, Path = Menu.Name.." > "..Config.Name, _TAB = _B,
				MenuName = Menu.Name, Author = Config.Author, Description = Config.Description, Tags = table.concat(Config.Tags," "), IsProduct = true
			});

			local function GetTimeAgo(d)
				if not d or d=="-" or d=="N/A" then return d end
				local D,M,Y,H,Min = d:match("(%d+)%.(%d+)%.(%d+)%s+(%d+):(%d+)")
				if not D then D,M,Y = d:match("(%d+)%.(%d+)%.(%d+)") H,Min=0,0 end
				if not D then return d end
				local diff = os.time() - os.time({year=Y,month=M,day=D,hour=H,min=Min})
				if diff<60 then return "now" end
				if diff<3600 then return math.floor(diff/60).."m ago" end
				if diff<86400 then return math.floor(diff/3600).."h ago" end
				if diff<604800 then return math.floor(diff/86400).."d ago" end
				return math.floor(diff/604800).."w ago"
			end

			local StatusColors = { Working=Color3.fromRGB(100,255,100), Updating=Color3.fromRGB(255,220,80), Patched=Color3.fromRGB(255,80,80) }

			local Product = Instance.new("Frame")
			local P_Corner = Instance.new("UICorner")
			local P_Stroke = Instance.new("UIStroke")
			local P_Pad = Instance.new("UIPadding")
			local P_List = Instance.new("UIListLayout")

			Product.Name = Fatality:RandomString()
			Product.Parent = (Config.Position=='left' and Left) or (Config.Position=='center' and Center) or Right
			Fatality:Register(Product, "Container")
			Product.BorderColor3 = Color3.new(0,0,0)
			Product.BorderSizePixel = 0
			Product.Size = UDim2.new(1,0,0,0)
			Product.AutomaticSize = Enum.AutomaticSize.Y
			Product.ZIndex = 15

			P_Corner.CornerRadius = UDim.new(0,4); P_Corner.Parent = Product
			P_Stroke.Color = Color3.fromRGB(29,29,29); Fatality:Register(P_Stroke, "Stroke", "Color"); P_Stroke.Parent = Product
			P_Pad.PaddingTop = UDim.new(0,8); P_Pad.PaddingBottom = UDim.new(0,8); P_Pad.PaddingLeft = UDim.new(0,8); P_Pad.PaddingRight = UDim.new(0,8); P_Pad.Parent = Product
			P_List.SortOrder = Enum.SortOrder.LayoutOrder; P_List.Padding = UDim.new(0,4); P_List.Parent = Product

			local Head = Instance.new("Frame", Product); Head.BackgroundTransparency=1; Head.Size=UDim2.new(1,0,0,16); Head.LayoutOrder=1; Head.ZIndex=20
			local Title = Instance.new("TextLabel", Head); Title.BackgroundTransparency=1; Title.Size=UDim2.new(0.7,0,1,0); Title.Font=Enum.Font.GothamBold; Title.Text=Config.Name; Title.TextColor3=Fatality:GetColor("Text"); Title.TextSize=13; Title.TextXAlignment=Enum.TextXAlignment.Left; Title.TextTruncate=Enum.TextTruncate.AtEnd; Title.ZIndex=20; Fatality:Register(Title,"Text","TextColor3")
			local Ver = Instance.new("TextLabel", Head); Ver.BackgroundTransparency=1; Ver.Size=UDim2.new(0.3,0,1,0); Ver.Position=UDim2.new(0.7,0,0,0); Ver.Font=Enum.Font.Gotham; Ver.Text=Config.Version; Ver.TextColor3=Fatality:GetColor("TextDark"); Ver.TextSize=11; Ver.TextXAlignment=Enum.TextXAlignment.Right; Ver.ZIndex=20; Fatality:Register(Ver,"TextDark","TextColor3")
			
			local StatDot = Instance.new("Frame", Head); 
			StatDot.BackgroundTransparency=0; 
			StatDot.Size=UDim2.new(0,6,0,6); 
			StatDot.AnchorPoint = Vector2.new(1, 0)
			StatDot.Position=UDim2.new(1, 0, 1, 2); 
			StatDot.BackgroundColor3=StatusColors[Config.Status] or StatusColors.Working; 
			StatDot.ZIndex=21
			Instance.new("UICorner", StatDot).CornerRadius = UDim.new(1,0)

			local Sub = Instance.new("Frame", Product); Sub.BackgroundTransparency=1; Sub.Size=UDim2.new(1,0,0,14); Sub.LayoutOrder=2; Sub.ZIndex=20
			local SL = Instance.new("UIListLayout", Sub); SL.SortOrder=Enum.SortOrder.LayoutOrder; SL.FillDirection=Enum.FillDirection.Horizontal; SL.Padding=UDim.new(0,4); SL.VerticalAlignment=Enum.VerticalAlignment.Center
			
			local By = Instance.new("TextLabel", Sub); By.LayoutOrder=1; By.BackgroundTransparency=1; By.AutomaticSize=Enum.AutomaticSize.X; By.Size=UDim2.new(0,0,1,0); By.Font=Enum.Font.Gotham; By.Text="by"; By.TextColor3=Fatality:GetColor("TextDark"); By.TextSize=10; By.ZIndex=20; Fatality:Register(By,"TextDark","TextColor3")
			
			local Auth = Instance.new("TextLabel", Sub); Auth.LayoutOrder=2; Auth.BackgroundTransparency=1; Auth.AutomaticSize=Enum.AutomaticSize.X; Auth.Size=UDim2.new(0,0,1,0); Auth.Font=Enum.Font.Gotham; Auth.Text=Config.Author; Auth.TextSize=10; Auth.ZIndex=20
			
			Auth.TextColor3 = Fatality:GetColor("Main")
			Fatality:Register(Auth,"Main","TextColor3")
			
			if Config.IsOfficial then
				local Crown = Instance.new("ImageLabel", Sub); Crown.LayoutOrder=3; Crown.BackgroundTransparency=1; Crown.Size=UDim2.new(0,10,0,10); Crown.Image=Fatality:GetIcon("crown"); Crown.ImageColor3=Color3.fromRGB(255,215,0); Crown.ZIndex=20
			end

			local Desc = Instance.new("TextLabel", Product); Desc.BackgroundTransparency=1; Desc.Size=UDim2.new(1,0,0,0); Desc.AutomaticSize=Enum.AutomaticSize.Y; Desc.Font=Enum.Font.GothamMedium; Desc.Text=Config.Description; Desc.TextColor3=Color3.fromRGB(200,200,200); Desc.TextSize=11; Desc.TextWrapped=true; Desc.TextXAlignment=Enum.TextXAlignment.Left; Desc.LayoutOrder=3; Desc.ZIndex=20

			local TagBox = Instance.new("Frame", Product); TagBox.BackgroundTransparency=1; TagBox.Size=UDim2.new(1,0,0,16); TagBox.AutomaticSize=Enum.AutomaticSize.Y; TagBox.LayoutOrder=4; TagBox.ZIndex=20
			local TL = Instance.new("UIListLayout", TagBox); TL.FillDirection=Enum.FillDirection.Horizontal; TL.Padding=UDim.new(0,4); TL.Wraps=true
			for _, t in ipairs(Config.Tags) do
				local Ch = Instance.new("Frame", TagBox); Ch.BackgroundColor3=Fatality:GetColor("TabActive"); Ch.Size=UDim2.new(0,0,0,14); Ch.AutomaticSize=Enum.AutomaticSize.X; Ch.ZIndex=21; Fatality:Register(Ch, "TabActive")
				Instance.new("UICorner", Ch).CornerRadius=UDim.new(0,3); 
				local S=Instance.new("UIStroke", Ch); S.Color=Fatality:GetColor("Stroke"); Fatality:Register(S, "Stroke", "Color")
				local P=Instance.new("UIPadding", Ch); P.PaddingLeft=UDim.new(0,4); P.PaddingRight=UDim.new(0,4)
				local L = Instance.new("TextLabel", Ch); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,1,0); L.Font=Enum.Font.Gotham; L.TextSize=9; L.TextColor3=Fatality:GetColor("TextDark"); Fatality:Register(L, "TextDark", "TextColor3"); L.Text=string.lower(t); L.ZIndex=22
			end
			if #Config.Tags == 0 then TagBox.Visible=false end

			local StatRow = Instance.new("Frame", Product); StatRow.BackgroundTransparency=1; StatRow.Size=UDim2.new(1,0,0,16); StatRow.LayoutOrder=5; StatRow.ZIndex=20
			
			local LkBtn = Instance.new("ImageButton", StatRow); LkBtn.BackgroundTransparency=1; LkBtn.Size=UDim2.new(0,14,0,14); LkBtn.Position=UDim2.new(0,0,0.5,-7); LkBtn.Image=Fatality:GetIcon("chevron-up"); LkBtn.ImageColor3=(Config.UserVote==1 and Color3.fromRGB(100,255,100) or Fatality:GetColor("TextDark")); LkBtn.ZIndex=21
			local LkCnt = Instance.new("TextLabel", StatRow); LkCnt.BackgroundTransparency=1; LkCnt.Position=UDim2.new(0,16,0,0); LkCnt.Size=UDim2.new(0,20,1,0); LkCnt.Font=Enum.Font.GothamBold; LkCnt.TextSize=10; LkCnt.TextColor3=Color3.fromRGB(100,255,100); LkCnt.TextXAlignment=Enum.TextXAlignment.Left; LkCnt.Text=tostring(Config.Likes); LkCnt.ZIndex=21
			
			local DkBtn = Instance.new("ImageButton", StatRow); DkBtn.BackgroundTransparency=1; DkBtn.Size=UDim2.new(0,14,0,14); DkBtn.Position=UDim2.new(0,35,0.5,-7); DkBtn.Image=Fatality:GetIcon("chevron-down"); DkBtn.ImageColor3=(Config.UserVote==-1 and Color3.fromRGB(255,100,100) or Fatality:GetColor("TextDark")); DkBtn.ZIndex=21
			local DkCnt = Instance.new("TextLabel", StatRow); DkCnt.BackgroundTransparency=1; DkCnt.Position=UDim2.new(0,51,0,0); DkCnt.Size=UDim2.new(0,20,1,0); DkCnt.Font=Enum.Font.GothamBold; DkCnt.TextSize=10; DkCnt.TextColor3=Color3.fromRGB(255,100,100); DkCnt.TextXAlignment=Enum.TextXAlignment.Left; DkCnt.Text=tostring(Config.Dislikes); DkCnt.ZIndex=21

			local FavBtn = Instance.new("ImageButton", StatRow); FavBtn.BackgroundTransparency=1; FavBtn.Size=UDim2.new(0,16,0,16); FavBtn.AnchorPoint=Vector2.new(1,0.5); FavBtn.Position=UDim2.new(1,0,0.5,0); FavBtn.Image=Fatality:GetIcon("star"); FavBtn.ImageColor3=(Config.IsFavorite and Color3.fromRGB(255,220,80) or Fatality:GetColor("TextDark")); FavBtn.ZIndex=21

			local BtnCont = Instance.new("Frame", Product); BtnCont.BackgroundTransparency=1; BtnCont.Size=UDim2.new(1,0,0,22); BtnCont.LayoutOrder=6; BtnCont.ZIndex=20
			
			local InstBtn = Instance.new("TextButton", BtnCont); InstBtn.BackgroundColor3=Fatality:GetColor("Element"); InstBtn.Size=UDim2.new(1,-35,1,0); InstBtn.Font=Enum.Font.GothamBold; InstBtn.Text=Config.ButtonText; InstBtn.TextColor3=Fatality:GetColor("Text"); InstBtn.TextSize=11; InstBtn.AutoButtonColor=false; InstBtn.ZIndex=25; Fatality:Register(InstBtn,"Element"); Fatality:Register(InstBtn,"Text","TextColor3"); Instance.new("UICorner", InstBtn).CornerRadius=UDim.new(0,4); local IBS=Instance.new("UIStroke", InstBtn); IBS.Color=Fatality:GetColor("Stroke"); Fatality:Register(IBS,"Stroke","Color")
			
			local DLCont = Instance.new("Frame", BtnCont); DLCont.BackgroundTransparency=1; DLCont.Size=UDim2.new(0,30,1,0); DLCont.Position=UDim2.new(1,-30,0,0); DLCont.ZIndex=21
			local DLL = Instance.new("UIListLayout", DLCont); DLL.FillDirection=Enum.FillDirection.Horizontal; DLL.HorizontalAlignment=Enum.HorizontalAlignment.Right; DLL.VerticalAlignment=Enum.VerticalAlignment.Center; DLL.Padding=UDim.new(0,3)
			
			local DLCnt = Instance.new("TextLabel", DLCont); DLCnt.BackgroundTransparency=1; DLCnt.AutomaticSize=Enum.AutomaticSize.X; DLCnt.Size=UDim2.new(0,0,1,0); DLCnt.Font=Enum.Font.Gotham; DLCnt.TextSize=10; DLCnt.TextColor3=Fatality:GetColor("TextDark"); DLCnt.LayoutOrder=2; DLCnt.Text=tostring(Config.Downloads); DLCnt.ZIndex=21; Fatality:Register(DLCnt,"TextDark","TextColor3")
			local DLIcon = Instance.new("ImageLabel", DLCont); DLIcon.BackgroundTransparency=1; DLIcon.Size=UDim2.new(0,12,0,12); DLIcon.Image=Fatality:GetIcon("download"); DLIcon.ImageColor3=Fatality:GetColor("TextDark"); DLIcon.LayoutOrder=1; DLIcon.ZIndex=21; Fatality:Register(DLIcon,"TextDark","ImageColor3")

			local DateRow = Instance.new("Frame", Product); DateRow.BackgroundTransparency=1; DateRow.Size=UDim2.new(1,0,0,12); DateRow.LayoutOrder=7; DateRow.ZIndex=20
			local D1 = Instance.new("TextLabel", DateRow); D1.BackgroundTransparency=1; D1.Size=UDim2.new(0.5,0,1,0); D1.Font=Enum.Font.Gotham; D1.TextColor3=Color3.fromRGB(80,80,80); D1.TextSize=9; D1.TextXAlignment=Enum.TextXAlignment.Left; D1.Text="added: "..GetTimeAgo(Config.DateCreate); D1.ZIndex=20
			local D2 = Instance.new("TextLabel", DateRow); D2.BackgroundTransparency=1; D2.Size=UDim2.new(0.5,0,1,0); D2.Position=UDim2.new(0.5,0,0,0); D2.Font=Enum.Font.Gotham; D2.TextColor3=Color3.fromRGB(80,80,80); D2.TextSize=9; D2.TextXAlignment=Enum.TextXAlignment.Right; D2.Text="updated: "..GetTimeAgo(Config.DateUpdate); D2.ZIndex=20

			local Sp = Instance.new("Frame", Product); Sp.BackgroundTransparency=1; Sp.Size=UDim2.new(1,0,0,2); Sp.LayoutOrder=8

			Fatality:CreateHover(InstBtn, function(h)
				if h then 
					local c = InstBtn.BackgroundColor3
					local h_color, s, v = c:ToHSV()
					Fatality:CreateAnimation(InstBtn, 0.2, {BackgroundColor3 = Color3.fromHSV(h_color, s, math.clamp(v + 0.15, 0, 1))})
				else
					Fatality:CreateAnimation(InstBtn, 0.2, {BackgroundColor3 = Fatality:GetColor("Element")})
				end
			end)
			
			Fatality:CreateHover(FavBtn, function(h) Fatality:CreateAnimation(FavBtn, 0.2, {ImageTransparency = h and 0 or 0.3}) end)

			InstBtn.MouseButton1Click:Connect(Config.Callback)
			FavBtn.MouseButton1Click:Connect(function()
				Config.IsFavorite = not Config.IsFavorite
				FavBtn.ImageColor3 = Config.IsFavorite and Color3.fromRGB(255,220,80) or Fatality:GetColor("TextDark")
				Config.FavCallback(Config.IsFavorite)
			end)
			
			local function Vote(v)
				local nv = (Config.UserVote == v) and 0 or v
				Config.VoteCallback(nv)
			end
			LkBtn.MouseButton1Click:Connect(function() Vote(1) end)
			DkBtn.MouseButton1Click:Connect(function() Vote(-1) end)

			local Toggle = function(v)
				local t = v and 0 or 1
				Fatality:CreateAnimation(Product, 0.5, {BackgroundTransparency=t})
				Fatality:CreateAnimation(P_Stroke, 0.5, {Transparency=t})
				Fatality:CreateAnimation(InstBtn, 0.5, {BackgroundTransparency=t})
				Fatality:CreateAnimation(IBS, 0.5, {Transparency=t})
				Fatality:CreateAnimation(StatDot, 0.5, {BackgroundTransparency=t})
				
				for _, obj in pairs(Product:GetDescendants()) do
					if obj:IsA("TextLabel") or obj:IsA("TextButton") then
						Fatality:CreateAnimation(obj, 0.5, {TextTransparency=t})
					elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
						if obj == FavBtn then Fatality:CreateAnimation(obj, 0.5, {ImageTransparency = v and 0.3 or 1})
						else Fatality:CreateAnimation(obj, 0.5, {ImageTransparency=t}) end
					elseif obj:IsA("UIStroke") and obj.Parent ~= Product and obj.Parent ~= InstBtn then
						Fatality:CreateAnimation(obj, 0.5, {Transparency=t})
					elseif obj:IsA("Frame") and obj.Parent.Name == "TagsContainer" then 
						Fatality:CreateAnimation(obj, 0.5, {BackgroundTransparency=t})
					end
				end
			end
			Toggle(BindEvent:GetAttribute('V'))
			BindEvent.Event:Connect(Toggle)

			Fatality.ThemeEvent.Event:Connect(function()
				if LkBtn and LkBtn.Parent then
					if Config.UserVote ~= 1 then game:GetService("TweenService"):Create(LkBtn, TweenInfo.new(0.3), {ImageColor3 = Fatality:GetColor("TextDark")}):Play() end
					if Config.UserVote ~= -1 then game:GetService("TweenService"):Create(DkBtn, TweenInfo.new(0.3), {ImageColor3 = Fatality:GetColor("TextDark")}):Play() end
					if not Config.IsFavorite then game:GetService("TweenService"):Create(FavBtn, TweenInfo.new(0.3), {ImageColor3 = Fatality:GetColor("TextDark")}):Play() end
				end
			end)

			return {
				SetStatus = function(self, s) if StatusColors[s] then Fatality:CreateAnimation(StatDot, 0.3, {BackgroundColor3=StatusColors[s]}) end end,
				SetButton = function(self, t) 
					InstBtn.Text = t
					InstBtn.TextColor3 = Fatality:GetColor("Text")
					InstBtn.BackgroundColor3 = Fatality:GetColor("Element")
				end,
				SetVisuals = function(self, data)
					if data.Likes ~= nil then LkCnt.Text=tostring(data.Likes) end
					if data.Dislikes ~= nil then DkCnt.Text=tostring(data.Dislikes) end
					if data.Downloads ~= nil then DLCnt.Text=tostring(data.Downloads) end
					
					if data.Vote ~= nil then
						Config.UserVote = data.Vote
						LkBtn.ImageColor3 = (data.Vote==1) and Color3.fromRGB(100,255,100) or Fatality:GetColor("TextDark")
						DkBtn.ImageColor3 = (data.Vote==-1) and Color3.fromRGB(255,100,100) or Fatality:GetColor("TextDark")
					end
					
					if data.Fav ~= nil then
						Config.IsFavorite = data.Fav
						FavBtn.ImageColor3 = data.Fav and Color3.fromRGB(255,220,80) or Fatality:GetColor("TextDark")
					end
				end,
				Destroy = function(self) Product:Destroy() end,
				SetVisible = function(self, b) Product.Visible = b end,
				GetButton = function() return InstBtn end
			}
		end;

		return MenuLib; 
	end;

	do
		local SearchFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local DropShadow = Instance.new("ImageLabel")
		local SearchBox = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local EmptyLabel = Instance.new("TextLabel") 
		local searchScale = UDim2.new(0, 295, 0, 295);
		
		Fatality:AddDragBlacklist(SearchFrame);
		
		local SearchToggle = function(value)
			if value then
				SearchFrame.Position = UDim2.fromOffset(SearchButton.AbsolutePosition.X - 5,SearchButton.AbsolutePosition.Y + (SearchButton.AbsoluteSize.Y * 3))
				Fatality:CreateAnimation(SearchFrame,0.35,{ Size = searchScale }) 
				Fatality:CreateAnimation(DropShadow,0.35,{ ImageTransparency = 0.750 }) 
				Fatality:CreateAnimation(SearchBox,0.35,{ BackgroundTransparency = 0 }) 
				Fatality:CreateAnimation(UIStroke_2,0.5,{ Transparency = 0.650 }) 
				Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 0 }) 
				Fatality:CreateAnimation(TextBox,0.5,{ TextTransparency = 0 })
			else
				Fatality:CreateAnimation(UIStroke,0.5,{ Transparency = 1 }) 
				Fatality:CreateAnimation(SearchFrame,0.35,{ Size = UDim2.new(searchScale.X.Scale, searchScale.X.Offset, 0, 0) }) 
				Fatality:CreateAnimation(DropShadow,0.35,{ ImageTransparency = 1 }) 
				Fatality:CreateAnimation(SearchBox,0.5,{ BackgroundTransparency = 1 }) 
				Fatality:CreateAnimation(UIStroke_2,0.5,{ Transparency = 1 }) 
				Fatality:CreateAnimation(TextBox,0.5,{ TextTransparency = 1 }) 
				for i,v in next , ScrollingFrame:GetChildren() do 
					if v:IsA('Frame') then v:Destroy(); end; 
				end;
				EmptyLabel.Visible = false
			end;
		end;
		
		SearchFrame.Name = Fatality:RandomString()
		SearchFrame.Parent = Fatalitywin;
		SearchFrame.AnchorPoint = Vector2.new(0, 1)
		Fatality:Register(SearchFrame, "Background")
		SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchFrame.BorderSizePixel = 0
		SearchFrame.Position = UDim2.new(4,0,4,0)
		SearchFrame.Size = searchScale
		SearchFrame.ZIndex = 100
		SearchFrame.ClipsDescendants = true
		
		UIStroke.Color = Color3.fromRGB(29, 29, 29)
		Fatality:Register(UIStroke, "Stroke", "Color")
		UIStroke.Parent = SearchFrame
		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = SearchFrame
		
		DropShadow.Name = Fatality:RandomString()
		DropShadow.Parent = SearchFrame
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1.000
		DropShadow.BorderSizePixel = 0
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Rotation = 0.010
		DropShadow.Size = UDim2.new(1, 47, 1, 47)
		DropShadow.ZIndex = 99
		DropShadow.Image = "rbxassetid://6014261993"
		Fatality:Register(DropShadow, "Outline", "ImageColor3")
		DropShadow.ImageTransparency = 0.750
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
		
		SearchBox.Name = Fatality:RandomString()
		SearchBox.Parent = SearchFrame
		SearchBox.AnchorPoint = Vector2.new(0.5, 0)
		Fatality:Register(SearchBox, "Element")
		SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchBox.BorderSizePixel = 0
		SearchBox.Position = UDim2.new(0.5, 0, 0, 9)
		SearchBox.Size = UDim2.new(1, -15, 0, 25)
		SearchBox.ZIndex = 101
		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = SearchBox
		
		UIStroke_2.Transparency = 0.650
		UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
		Fatality:Register(UIStroke_2, "Stroke", "Color")
		UIStroke_2.Parent = SearchBox
		
		TextBox.Parent = SearchBox
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.Size = UDim2.new(1, -15, 1, -5)
		TextBox.ZIndex = 102
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = Fatality.FontSemiBold;
		TextBox.PlaceholderText = "Search by name, author or tags..."
		TextBox.Text = ""
		Fatality:Register(TextBox, "Text", "TextColor3")
		TextBox.TextSize = 12.000
		TextBox.TextXAlignment = Enum.TextXAlignment.Left
		
		ScrollingFrame.Parent = SearchFrame
		ScrollingFrame.Active = true
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
		Fatality:Register(ScrollingFrame, "Background")
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 40)
		ScrollingFrame.Size = UDim2.new(1, -15, 1, -45)
		ScrollingFrame.ZIndex = 102
		ScrollingFrame.ScrollBarThickness = 0
		
		EmptyLabel.Name = "EmptyLabel"
		EmptyLabel.Parent = SearchFrame
		EmptyLabel.BackgroundTransparency = 1
		EmptyLabel.Size = UDim2.new(1, 0, 0, 20)
		EmptyLabel.Position = UDim2.new(0, 0, 0.5, 0)
		EmptyLabel.ZIndex = 105
		EmptyLabel.Font = Enum.Font.GothamBold
		EmptyLabel.Text = "No results found"
		Fatality:Register(EmptyLabel, "TextDark", "TextColor3")
		EmptyLabel.TextSize = 14
		EmptyLabel.Visible = false
		
		UIListLayout.Parent = ScrollingFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y) end)
		
		SearchToggle(false);
		Fatality:CreateHover(SearchButton,function(bool) if bool then Fatality:CreateAnimation(SearchButton,0.5,{ ImageTransparency = 0.1 }) else Fatality:CreateAnimation(SearchButton,0.5,{ ImageTransparency = 0.5 }) end	end);
		
		local SearchInformation = {};
		
		local function GetTypeIcon(tabName)
			if tabName == "SCRIPTS" then return "rbxassetid://10709810463" end 
			if tabName == "CONFIGS" then return "rbxassetid://10734950309" end 
			return "rbxassetid://10709752906" 
		end
		
		local get_button = function(Name, Path, TAB_WARP, TabType)
			local ResultFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local TypeIcon = Instance.new("ImageLabel") 
			local FeatureName = Instance.new("TextLabel")
			local FeaturePath = Instance.new("TextLabel")
			
			ResultFrame.Name = Fatality:RandomString()
			ResultFrame.Parent = ScrollingFrame;
			Fatality:Register(ResultFrame, "Element")
			ResultFrame.BackgroundTransparency = 1.000
			ResultFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ResultFrame.BorderSizePixel = 0
			ResultFrame.Size = UDim2.new(1, 0, 0, 42)
			ResultFrame.ZIndex = 103
			
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = ResultFrame
			
			TypeIcon.Parent = ResultFrame
			TypeIcon.BackgroundTransparency = 1
			TypeIcon.Position = UDim2.new(0, 8, 0.5, -8) 
			TypeIcon.Size = UDim2.new(0, 16, 0, 16)
			TypeIcon.Image = GetTypeIcon(TabType)
			TypeIcon.ImageColor3 = Fatality:GetColor("TextDark")
			Fatality:Register(TypeIcon, "TextDark", "ImageColor3")
			TypeIcon.ZIndex = 104
			
			FeatureName.Name = Fatality:RandomString()
			FeatureName.Parent = ResultFrame
			FeatureName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureName.BackgroundTransparency = 1.000
			FeatureName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureName.BorderSizePixel = 0
			FeatureName.Position = UDim2.new(0, 32, 0, 5) 
			FeatureName.Size = UDim2.new(1, -35, 0, 15)
			FeatureName.ZIndex = 104
			FeatureName.FontFace = Fatality.FontSemiBold
			FeatureName.Text = Name
			Fatality:Register(FeatureName, "Text", "TextColor3")
			FeatureName.TextSize = 14.000
			FeatureName.TextXAlignment = Enum.TextXAlignment.Left
			FeatureName.TextTruncate = Enum.TextTruncate.AtEnd
			
			FeaturePath.Name = Fatality:RandomString()
			FeaturePath.Parent = ResultFrame
			FeaturePath.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeaturePath.BackgroundTransparency = 1.000
			FeaturePath.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeaturePath.BorderSizePixel = 0
			FeaturePath.Position = UDim2.new(0, 32, 0, 22) 
			FeaturePath.Size = UDim2.new(1, -35, 0, 15)
			FeaturePath.ZIndex = 104
			FeaturePath.FontFace = Fatality.FontSemiBold
			FeaturePath.Text = Path
			Fatality:Register(FeaturePath, "Text", "TextColor3")
			FeaturePath.TextSize = 12.000
			FeaturePath.TextTransparency = 0.500
			FeaturePath.TextXAlignment = Enum.TextXAlignment.Left
			FeaturePath.TextTruncate = Enum.TextTruncate.AtEnd
			
			local button = Fatality:NewInput(ResultFrame);
			
			Fatality:CreateHover(button,function(bool) 
				if bool then 
					Fatality:CreateAnimation(ResultFrame,0.5,{ BackgroundTransparency = 0 }) 
					Fatality:CreateAnimation(TypeIcon, 0.5, { ImageColor3 = Fatality:GetColor("Main") })
				else 
					Fatality:CreateAnimation(ResultFrame,0.5,{ BackgroundTransparency = 1 }) 
					Fatality:CreateAnimation(TypeIcon, 0.5, { ImageColor3 = Fatality:GetColor("TextDark") })
				end	
			end);
			
			button.MouseButton1Click:Connect(function() 
				if TAB_WARP then 
					for i,v in next , Fatal.Menus do 
						if v.Root == TAB_WARP.Root then 
							Fatal.MenuSelected = v; 
							v.ValueSelect(true) 
						else 
							v.ValueSelect(false) 
						end; 
					end; 
				end; 
			end);
			return ResultFrame;
		end
		
		SearchButton.MouseButton1Click:Connect(function() 
			TextBox.Text = ""; 
			SearchToggle(true); 
			table.clear(SearchInformation); 
			EmptyLabel.Visible = false
			
			for i,v in next , ScrollingFrame:GetChildren() do 
				if v:IsA('Frame') then v:Destroy(); end; 
			end; 
			
			for i, v in pairs(Fatal.ElementContents) do
				local rootTab = ""
				if v.MenuName then rootTab = v.MenuName else local parts = string.split(v.Path, " > "); rootTab = parts[1] or "" end
				rootTab = string.upper(rootTab)

				if rootTab ~= "CONFIGS" and rootTab ~= "SCRIPTS" then continue end
				
				local searchString = string.lower(v.Name)
				if v.Author then searchString = searchString .. " " .. string.lower(v.Author) end
				if v.Description then searchString = searchString .. " " .. string.lower(v.Description) end
				if v.Tags then searchString = searchString .. " " .. string.lower(v.Tags) end
				
				local displayPath = v.Path
				if v.IsProduct then displayPath = "Click to view product page" end
				
				local button = get_button(v.Name, displayPath, v._TAB, rootTab);
				
				table.insert(SearchInformation, {
					root = button,
					searchData = searchString
				})
			end
		end)
		
		local DearchDelay = tick();
		TextBox:GetPropertyChangedSignal('Text'):Connect(function()
			DearchDelay = tick();
			local currentText = TextBox.Text
			
			if not currentText:byte() then 
				for i,v in next , SearchInformation do v.root.Visible = true; end; 
				EmptyLabel.Visible = false
				return; 
			end;
			
			task.delay(0.5, function() 
				if (tick() - DearchDelay) > 0.5 and TextBox.Text == currentText then 
					local queryParts = string.split(string.lower(currentText), " ")
					local visibleCount = 0
					
					for i, v in next, SearchInformation do 
						local match = true
						for _, word in ipairs(queryParts) do
							if word ~= "" and not string.find(v.searchData, word, 1, true) then
								match = false
								break
							end
						end
						
						if match then 
							v.root.Visible = true; 
							visibleCount = visibleCount + 1
						else 
							v.root.Visible = false; 
						end; 
					end; 
					
					EmptyLabel.Visible = (visibleCount == 0)
				end; 
			end)
		end);
		
		UserInputService.InputBegan:Connect(function(input) 
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
				if not Fatality:IsMouseOverFrame(SearchFrame) then SearchToggle(false); end 
			end 
		end)
	end;

	do
		local AboutFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local DropShadow = Instance.new("ImageLabel")
		local HeaderText = Instance.new("TextLabel")
		local CloseButton = Instance.new("TextButton")
		local ContentFrame = Instance.new("Frame")
		local LogoContainer = Instance.new("Frame")
		local LogoRed = Instance.new("TextLabel")
		local LogoBlue = Instance.new("TextLabel")
		local LogoWhite = Instance.new("TextLabel")
		local CreditsText = Instance.new("TextLabel")
		local LinkButton = Instance.new("TextButton")
		local UICorner_Btn = Instance.new("UICorner")
		local UIStroke_Btn = Instance.new("UIStroke")

		AboutFrame.Name = "AboutWindow"
		AboutFrame.Parent = Fatalitywin
		AboutFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		AboutFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		AboutFrame.Size = UDim2.new(0, 220, 0, 260)
		Fatality:Register(AboutFrame, "Background") 
		AboutFrame.BorderSizePixel = 0
		AboutFrame.Visible = false
		AboutFrame.ZIndex = 200
		AboutFrame.Active = true 
		
		local AboutScale = Instance.new("UIScale", AboutFrame)
		AboutScale.Scale = Fatality.Scale
		table.insert(Fatality.ScalesRegistry, AboutScale)
		
		Fatality:AddDragBlacklist(AboutFrame)
		Fatality:Drag(AboutFrame, AboutFrame, 0.1)

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = AboutFrame

		UIStroke.Color = Color3.fromRGB(29, 29, 29)
		Fatality:Register(UIStroke, "Stroke", "Color")
		UIStroke.Parent = AboutFrame

		DropShadow.Name = "Shadow"
		DropShadow.Parent = AboutFrame
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Size = UDim2.new(1, 60, 1, 60)
		DropShadow.ZIndex = 199
		DropShadow.Image = "rbxassetid://6014261993"
		DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow.ImageTransparency = 0.5
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

		HeaderText.Name = "Title"
		HeaderText.Parent = AboutFrame
		HeaderText.BackgroundTransparency = 1
		HeaderText.Position = UDim2.new(0, 10, 0, 8)
		HeaderText.Size = UDim2.new(1, -20, 0, 20)
		HeaderText.ZIndex = 201
		HeaderText.Font = Enum.Font.GothamBold
		HeaderText.Text = "About"
		Fatality:Register(HeaderText, "Main", "TextColor3") 
		HeaderText.TextSize = 14
		HeaderText.TextXAlignment = Enum.TextXAlignment.Left

		CloseButton.Name = "Close"
		CloseButton.Parent = AboutFrame
		CloseButton.BackgroundTransparency = 1
		CloseButton.Position = UDim2.new(1, -25, 0, 8)
		CloseButton.Size = UDim2.new(0, 15, 0, 15)
		CloseButton.ZIndex = 202
		CloseButton.Font = Enum.Font.GothamBold
		CloseButton.Text = "x"
		CloseButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		CloseButton.TextSize = 14
		
		CloseButton.MouseEnter:Connect(function() game:GetService("TweenService"):Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
		CloseButton.MouseLeave:Connect(function() game:GetService("TweenService"):Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150,150,150)}):Play() end)
		CloseButton.MouseButton1Click:Connect(function() AboutFrame.Visible = false end)

		ContentFrame.Name = "Content"
		ContentFrame.Parent = AboutFrame
		ContentFrame.BackgroundTransparency = 1
		ContentFrame.Position = UDim2.new(0, 10, 0, 35)
		ContentFrame.Size = UDim2.new(1, -20, 1, -45)
		ContentFrame.ZIndex = 201

		LogoContainer.Name = "Logo"
		LogoContainer.Parent = ContentFrame
		LogoContainer.BackgroundTransparency = 1
		LogoContainer.Size = UDim2.new(1, 0, 0, 30)
		LogoContainer.ZIndex = 202

		local function createGlitchText(color, offset, z)
			local l = Instance.new("TextLabel")
			l.Parent = LogoContainer
			l.BackgroundTransparency = 1
			l.Size = UDim2.new(1, 0, 1, 0)
			l.Position = UDim2.new(0, offset, 0, 0)
			l.Font = Enum.Font.GothamBlack
			l.Text = "Marketplace"
			l.TextColor3 = color
			l.TextSize = 22
			l.ZIndex = 202 + z
			return l
		end

		LogoRed = createGlitchText(Color3.fromRGB(255, 0, 0), -2, 0)
		LogoBlue = createGlitchText(Color3.fromRGB(0, 255, 255), 2, 0)
		LogoWhite = createGlitchText(Color3.fromRGB(255, 255, 255), 0, 1)

		CreditsText.Name = "Credits"
		CreditsText.Parent = ContentFrame
		CreditsText.BackgroundTransparency = 1
		CreditsText.Position = UDim2.new(0, 0, 0, 40)
		CreditsText.Size = UDim2.new(1, 0, 0, 120)
		CreditsText.ZIndex = 202
		CreditsText.Font = Enum.Font.GothamMedium
		CreditsText.TextSize = 11
		CreditsText.TextColor3 = Color3.fromRGB(200, 200, 200)
		CreditsText.TextXAlignment = Enum.TextXAlignment.Left
		CreditsText.TextYAlignment = Enum.TextYAlignment.Top
		CreditsText.RichText = true
		
		CreditsText.Text = table.concat({
			'<font color="#666666">// developed by</font>',
			'<b>grabis</b>', 
			' ',
			'<font color="#666666">// ui base by</font>',
			'<b>4lpaca</b>',
			' ',
			'<font color="#666666">// special thanks</font>',
			'<b>Mepilok, Tetraquark, ahk_lzt</b>',
			' ',
			'<font color="#666666">// 2026</font> <font color="#ff4a68">MARKETPLACE</font>'
		}, "<br />")

		LinkButton.Name = "LinkButton"
		LinkButton.Parent = ContentFrame
		LinkButton.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
		LinkButton.Position = UDim2.new(0, 0, 1, -25)
		LinkButton.Size = UDim2.new(1, 0, 0, 25)
		LinkButton.ZIndex = 202
		LinkButton.AutoButtonColor = false
		LinkButton.Font = Enum.Font.GothamBold
		LinkButton.Text = "Public Software"
		LinkButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		LinkButton.TextSize = 12
		
		UICorner_Btn.CornerRadius = UDim.new(0, 4)
		UICorner_Btn.Parent = LinkButton
		
		UIStroke_Btn.Color = Color3.fromRGB(29, 29, 29)
		UIStroke_Btn.Parent = LinkButton
		Fatality:Register(UIStroke_Btn, "Stroke", "Color")

		Fatality:CreateHover(LinkButton, function(hover) 
			local TS = game:GetService("TweenService")
			if hover then
				TS:Create(LinkButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255,255,255), BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
			else
				TS:Create(LinkButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150,150,150), BackgroundColor3 = Color3.fromRGB(12,12,12)}):Play()
			end
		end)

		InfoButton.MouseButton1Click:Connect(function()
			AboutFrame.Visible = not AboutFrame.Visible
			if AboutFrame.Visible then
				AboutFrame.Size = UDim2.new(0, 220, 0, 240)
				AboutFrame.BackgroundTransparency = 1
				for _, v in pairs(AboutFrame:GetDescendants()) do
					if v:IsA("TextLabel") or v:IsA("TextButton") then v.TextTransparency = 1 end
					if v:IsA("UIStroke") then v.Transparency = 1 end
				end
				
				local TS = game:GetService("TweenService")
				local info = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				
				TS:Create(AboutFrame, info, {Size = UDim2.new(0, 220, 0, 260), BackgroundTransparency = 0}):Play()
				TS:Create(UIStroke, info, {Transparency = 0}):Play()
				
				task.wait(0.1)
				for _, v in pairs(AboutFrame:GetDescendants()) do
					if v:IsA("TextLabel") or v:IsA("TextButton") then 
						TS:Create(v, TweenInfo.new(0.3), {TextTransparency = 0}):Play() 
					end
					if v:IsA("UIStroke") then TS:Create(v, TweenInfo.new(0.3), {Transparency = 0}):Play() end
				end
			end
		end)

		function Fatal:AddInfo(callback)
			LinkButton.MouseButton1Click:Connect(function()
				LinkButton.TextSize = 11
				task.wait(0.05)
				LinkButton.TextSize = 12
				callback()
			end)
		end;
	end

	function Fatal:GetButton()
		local backpack = Instance.new("TextButton")
		backpack.Name = "FATALITY_MOBILE_TOGGLE"
		backpack.BackgroundColor3 = Fatality:GetColor("Container")
		Fatality:Register(backpack, "Container")
		backpack.BorderSizePixel = 0
		backpack.Size = UDim2.new(0, 50, 0, 50) 
		backpack.AutoButtonColor = false
		backpack.Text = "" 

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = backpack

		local stroke = Instance.new("UIStroke")
		stroke.Color = Fatality:GetColor("Stroke")
		Fatality:Register(stroke, "Stroke", "Color")
		stroke.Parent = backpack
		
		local icon = Instance.new("TextLabel")
		icon.Name = "Icon"
		icon.Parent = backpack
		icon.BackgroundTransparency = 1
		icon.Size = UDim2.new(1, 0, 1, 0)
		icon.Font = Enum.Font.GothamBold
		icon.Text = "V"
		icon.TextColor3 = Fatality:GetColor("Main")
		Fatality:Register(icon, "Main", "TextColor3")
		icon.TextSize = 24

		backpack.MouseButton1Click:Connect(function()
			Fatal.Toggle = not Fatal.Toggle
			ToggleUI(Fatal.Toggle)
		end)

		return backpack
	end

	function Fatal:SetVisible(b)
		Fatal.Toggle = b;
		ToggleUI(b);
		if b then Fatalitywin.Enabled = true elseif FatalFrame.BackgroundTransparency >= 0.99 then Fatalitywin.Enabled = false end
	end;

	if Window.Visible == false then
		Fatal.Toggle = false
		SaveButton.Position = UDim2.new(0,35,1, 20) SearchButton.Position = UDim2.new(0,10,1, 20) InfoButton.Position = UDim2.new(1, -5,1, 20) UIStroke.Thickness = 0 UIStroke.Transparency = 1 UserIcon.ImageTransparency = 1 UserIcon.Position = UDim2.new(1, -10,0.5, 0) User_name.TextTransparency = 1 User_name.Position = UDim2.new(1, -40,0, 3) expire_days.TextTransparency = 1 expire_days.Position = UDim2.new(1, -40,0, 16) HeaderText.TextStrokeTransparency = 1 HeaderText.TextTransparency = 1 HeaderLineShadow_2.BackgroundTransparency = 1 InfoButton.ImageTransparency = 1 SearchButton.ImageTransparency = 1 SaveButton.ImageTransparency = 1 HeaderLineShadow.BackgroundTransparency = 1 FatalFrame.BackgroundTransparency = 1 Header.BackgroundTransparency = 1 HeaderLine.BackgroundTransparency = 1 Bottom.BackgroundTransparency = 1 HeaderLine_2.BackgroundTransparency = 1 DropShadow.ImageTransparency = 1
		Fatalitywin.Enabled = false
	else
		Fatalitywin.Enabled = true 
		ToggleUI(true);
	end

	-- Holiday Mascot
	local oldHoliday = CoreGui:FindFirstChild("Fatality_HolidayParticles")
	if oldHoliday then oldHoliday:Destroy() end

	local HolidayGUI = Instance.new("ScreenGui")
	HolidayGUI.Name = "Fatality_HolidayParticles"
	HolidayGUI.IgnoreGuiInset = true
	HolidayGUI.DisplayOrder = Fatalitywin.DisplayOrder - 1
	HolidayGUI.Parent = CoreGui
	HolidayGUI.Enabled = false

	local ParticlesContainer = Instance.new("Frame")
	ParticlesContainer.Size = UDim2.fromScale(1, 1)
	ParticlesContainer.BackgroundTransparency = 1
	ParticlesContainer.Parent = HolidayGUI

	local MascotContainer = Instance.new("Frame")
	MascotContainer.Name = "MascotContainer"
	MascotContainer.BackgroundTransparency = 1
	MascotContainer.Size = Window.Scale
	MascotContainer.Position = FatalFrame.Position
	MascotContainer.AnchorPoint = FatalFrame.AnchorPoint
	MascotContainer.ZIndex = 1000
	MascotContainer.Parent = Fatalitywin
	
	local MascotScale = Instance.new("UIScale", MascotContainer)
	MascotScale.Scale = Fatality.Scale
	table.insert(Fatality.ScalesRegistry, MascotScale)

	FatalFrame:GetPropertyChangedSignal("Position"):Connect(function() MascotContainer.Position = FatalFrame.Position end)

	local MascotImg = Instance.new("ImageLabel")
	MascotImg.Name = "HolidayMascot"
	MascotImg.BackgroundTransparency = 1
	MascotImg.ZIndex = 1000 
	MascotImg.AnchorPoint = Vector2.new(0, 1)
	MascotImg.Position = UDim2.new(0, 10, 0, 15)
	MascotImg.Size = UDim2.fromOffset(120, 120)
	MascotImg.Parent = MascotContainer
	MascotImg.Visible = true

	Fatal.HolidayState = {
		MainEnabled = true, 
		Mascot = { Enabled = true, Position = "Left", Size = 120 },
		Particles = { Enabled = false, Count = 0, Speed = 40, Size = 15, Index = 0, Images = {}, Colors = {} },
		ActiveParticles = {}
	}

	local function ResetParticle(p)
		p.Pos = Vector2.new(math.random(0, CurrentCamera.ViewportSize.X), math.random(-CurrentCamera.ViewportSize.Y, -20))
		p.Vel = Vector2.new(0, 0)
		p.BaseSpeed = math.random(Fatal.HolidayState.Particles.Speed * 0.5, Fatal.HolidayState.Particles.Speed * 1.5)
		p.Sway = math.random() * 6.28
		p.RotSpeed = math.random(-100, 100) / 100
		p.TargetTrans = math.random(10, 50) / 100
		p.Size = Fatal.HolidayState.Particles.Size + math.random(-4, 4)
		
		local imgs = Fatal.HolidayState.Particles.Images
		local idx = Fatal.HolidayState.Particles.Index
		if idx == 0 or idx > #imgs then idx = math.random(1, math.max(1, #imgs)) end
		p.Obj.Image = imgs[idx] or ""
		
		local cols = Fatal.HolidayState.Particles.Colors
		p.Obj.ImageColor3 = cols[math.random(1, math.max(1, #cols))] or Color3.new(1,1,1)
	end

	local function SpawnParticle()
		local img = Instance.new("ImageLabel")
		img.BackgroundTransparency = 1
		img.Parent = ParticlesContainer
		local p = { Obj = img }
		ResetParticle(p)
		p.Pos = Vector2.new(math.random(0, CurrentCamera.ViewportSize.X), math.random(0, CurrentCamera.ViewportSize.Y))
		return p
	end

	local HolidayRenderConn
	HolidayRenderConn = RunService.RenderStepped:Connect(function(dt)
		if not FatalFrame or not FatalFrame.Parent then
			if HolidayRenderConn then HolidayRenderConn:Disconnect() end
			if HolidayGUI then HolidayGUI:Destroy() end
			return
		end

		local state = Fatal.HolidayState
		if not Fatal.Toggle or not state.MainEnabled or not state.Particles.Enabled then
			HolidayGUI.Enabled = false
			return
		end
		HolidayGUI.Enabled = true

		while #state.ActiveParticles < state.Particles.Count do table.insert(state.ActiveParticles, SpawnParticle()) end
		while #state.ActiveParticles > state.Particles.Count do
			local p = table.remove(state.ActiveParticles)
			if p and p.Obj then p.Obj:Destroy() end
		end

		local mousePos = UserInputService:GetMouseLocation()
		local vpSize = CurrentCamera.ViewportSize
		local time = os.clock()

		for i, p in ipairs(state.ActiveParticles) do
			local sway = math.sin((time * 2) + p.Sway) * 20
			local dir = p.Pos - mousePos
			local dist = dir.Magnitude
			
			if dist < 90 then
				local force = (1 - (dist / 90)) * 700
				p.Vel = p.Vel + (dir.Unit * force * dt)
			end
			
			p.Pos = p.Pos + (Vector2.new(sway, p.BaseSpeed) * dt) + (p.Vel * dt)
			p.Vel = p.Vel * 0.98
			p.Obj.Rotation = p.Obj.Rotation + p.RotSpeed
			p.Obj.Position = UDim2.fromOffset(p.Pos.X, p.Pos.Y)
			p.Obj.Size = UDim2.fromOffset(p.Size, p.Size)
			p.Obj.ImageTransparency = p.TargetTrans

			if p.Pos.Y > vpSize.Y + p.Size then ResetParticle(p) end
		end
	end)

	function Fatal:InitHoliday(Config)
		Config = Config or {}
		MascotImg.Image = Config.MascotImage or "rbxassetid://79279979693699"
		Fatal.HolidayState.Particles.Images = Config.ParticleImages or {"rbxassetid://80131833917905", "rbxassetid://125571352815581", "rbxassetid://102097359445566", "rbxassetid://131567563653537"}
		Fatal.HolidayState.Particles.Colors = Config.ParticleColors or {Color3.new(1,1,1)}
		Fatal.HolidayState.MainEnabled = true
	end

	function Fatal:UpdateHoliday(Category, Setting, Value)
		local state = Fatal.HolidayState
		if Category == "Main" and Setting == "Enabled" then
			state.MainEnabled = Value
			MascotImg.Visible = Value and state.Mascot.Enabled
		elseif state[Category] then
			state[Category][Setting] = Value
			
			if Category == "Mascot" then
				if Setting == "Enabled" then MascotImg.Visible = state.MainEnabled and Value end
				if Setting == "Size" then MascotImg.Size = UDim2.fromOffset(Value, Value) end
				if Setting == "Position" then
					if Value == "Left" then MascotImg.AnchorPoint = Vector2.new(0, 1); MascotImg.Position = UDim2.new(0, 10, 0, 15)
					elseif Value == "Center" then MascotImg.AnchorPoint = Vector2.new(0.5, 1); MascotImg.Position = UDim2.new(0.5, 0, 0, 15)
					elseif Value == "Right" then MascotImg.AnchorPoint = Vector2.new(1, 1); MascotImg.Position = UDim2.new(1, -20, 0, 15) end
				end
			elseif Category == "Particles" then
				if Setting == "Index" then
					for _, p in ipairs(state.ActiveParticles) do
						local imgs = state.Particles.Images
						p.Obj.Image = (Value == 0) and (imgs[math.random(1, #imgs)] or "") or (imgs[Value] or "")
					end
				end
			end
		end
	end

	return Fatal;
end;

function Fatality:Loader(Config: Loader)
	Config = Config or {}
	Config.Name = Config.Name or "FATALITY"
	Config.Duration = Config.Duration or 3.5
	Config.Scale = Config.Scale or 3
	Config.Manual = Config.Manual or false

	local Blur = Instance.new('BlurEffect')
	local Loader = Instance.new("ScreenGui")
	local center = Instance.new("Frame")
	local texts = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local BlackFrame = Instance.new("Frame")

	Loader.Name = Fatality:RandomString()
	Loader.Parent = CoreGui
	Loader.IgnoreGuiInset = true
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global

	center.Parent = Loader
	center.AnchorPoint = Vector2.new(0.5, 0.5)
	center.BackgroundTransparency = 1
	center.Position = UDim2.new(0.5, 0, 0.5, 0)

	texts.Parent = Loader
	texts.AnchorPoint = Vector2.new(0.5, 0.5)
	texts.BackgroundTransparency = 1
	texts.Position = UDim2.new(0.5, 0, 0.5, 0)
	texts.Size = UDim2.new(1, 0, 0, 200)

	UIListLayout.Parent = texts
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, Config.Scale * 5)

	BlackFrame.Parent = Loader
	BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BlackFrame.BackgroundTransparency = 1
	BlackFrame.Size = UDim2.new(1, 0, 1, 0)
	BlackFrame.ZIndex = -1

	Blur.Size = 0
	Blur.Parent = game:GetService('Lighting')

	Fatality:CreateAnimation(Blur,1,{ Size = 60 })
	Fatality:CreateAnimation(BlackFrame,0.5,{ BackgroundTransparency = 0.7 })

	local UText = { Y = 14 }
	local PosText = {}
	local IsFirst = true

	local function createText(TEXT)
		local LIT = Instance.new("Frame")
		local ASCII = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local UIScale = Instance.new("UIScale")

		LIT.BackgroundTransparency = 1
		LIT.Size = UDim2.new(0, 56, 0, 100)
		LIT.ZIndex = 8

		ASCII.Parent = LIT
		ASCII.AnchorPoint = Vector2.new(0.5, 0.5)
		ASCII.BackgroundTransparency = 1
		ASCII.Position = UDim2.new(0.5, 0, 0.5, 0)
		ASCII.Size = UDim2.new(0, 28, 0, 50)
		ASCII.ZIndex = 8
		ASCII.Font = Enum.Font.GothamBold
		ASCII.Text = TEXT
		ASCII.TextColor3 = Color3.fromRGB(255, 255, 255)
		ASCII.TextSize = 50.000
		ASCII.TextWrapped = true

		local textsize = Fatality:GetTextSize(ASCII)
		ASCII.Size = UDim2.new(0, textsize.X + 100, 0, 50)
		LIT.Size = UDim2.new(0, (textsize.X * 2.5) + (UText[TEXT] or 0), 0, 100)

		UIGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 116, 116)), 
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(132, 58, 58))
		}
		UIGradient.Rotation = 88
		UIGradient.Parent = ASCII

		UIScale.Parent = ASCII
		UIScale.Scale = Config.Scale

		return LIT, ASCII
	end

	for i = 1, #Config.Name do
		local char = Config.Name:sub(i,i)
		local L, A = createText(char)
		L.Parent = texts
		A.TextTransparency = 1
		
		if i > 1 then
			A.Position = UDim2.new(0.5,0,0.5,200)
		end
		
		table.insert(PosText,{ Frame = L, Text = A })
	end

	task.spawn(function()
		local FirstChar = PosText[1].Text
		local FirstScale = FirstChar:FindFirstChild("UIScale")
		
		FirstScale.Scale = Config.Scale * 4
		Fatality:CreateAnimation(FirstChar, 0.45, { TextTransparency = 0 })
		Fatality:CreateAnimation(FirstScale, 0.5, { Scale = Config.Scale })
		
		task.wait(0.45)
		
		for i,v in next , PosText do
			if i > 1 then
				Fatality:CreateAnimation(v.Text,0.65,{
					Position = UDim2.new(0.5,0,0.5,0),
					TextTransparency = 0
				})
			end
		end
	end)

	local Controller = {
		IsFinished = false,
		Finish = function(self)
			if self.IsFinished then return end
			self.IsFinished = true
			
			for i,v in next , PosText do
				Fatality:CreateAnimation(v.Text, 1.0, { TextTransparency = 1 })
			end
			Fatality:CreateAnimation(Blur, 1.0, { Size = 0 })
			Fatality:CreateAnimation(BlackFrame, 1.0, { BackgroundTransparency = 1 })
			
			task.wait(1.1)
			Loader:Destroy()
			Blur:Destroy()
		end
	}

	if not Config.Manual then
		task.wait(Config.Duration or 3.5)
		Controller:Finish()
	end

	return Controller
end

function Fatality:CreateNotifier(): Notifier
	if Fatality.__NOTIFIER_CACHE then return Fatality.__NOTIFIER_CACHE end

	local Notify = Instance.new("ScreenGui")
	local layout = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notify.Name = Fatality:RandomString()
	Notify.Parent = CoreGui
	Notify.ResetOnSpawn = false
	Notify.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Notify.IgnoreGuiInset = true

	layout.Name = Fatality:RandomString()
	layout.Parent = Notify
	layout.AnchorPoint = Vector2.new(1, 0)
	layout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	layout.BackgroundTransparency = 1.000
	layout.BorderColor3 = Color3.fromRGB(0, 0, 0)
	layout.BorderSizePixel = 0
	layout.Position = UDim2.new(1, -5, 0, 5)
	layout.Size = UDim2.new(0, 150, 0, 50)
	
	local NotifyScale = Instance.new("UIScale", layout) 
	NotifyScale.Scale = Fatality.Scale
	table.insert(Fatality.ScalesRegistry, NotifyScale)

	UIListLayout.Parent = layout
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local res = Fatality:CreateResponse({
		Notify = function(Config: Notify)
			Config = Config or {}
			Config.Icon = Config.Icon or "settings"
			Config.Content = Config.Content or nil
			Config.Title = Config.Title or "Notification"
			Config.Duration = Config.Duration or 5

			local notify = Instance.new("Frame")
			local notify_block = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Icon = Instance.new("ImageLabel")
			local HeaderText = Instance.new("TextLabel")
			local BodyText = Instance.new("TextLabel")

			notify.Name = Fatality:RandomString()
			notify.Parent = layout
			notify.BackgroundColor3 = Fatality:GetColor("Background")
			notify.BackgroundTransparency = 1.000
			notify.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notify.BorderSizePixel = 0
			notify.Size = UDim2.new(0, 0, 0, 0)

			notify_block.Name = Fatality:RandomString()
			notify_block.Parent = notify
			notify_block.AnchorPoint = Vector2.new(0.5, 0)
			Fatality:Register(notify_block, "Container")
			notify_block.BackgroundTransparency = 1
			notify_block.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notify_block.BorderSizePixel = 0
			notify_block.Position = UDim2.new(0.5, 0, -1, 0)
			notify_block.Size = UDim2.new(1, 0, 1, -12)
			notify_block.ClipsDescendants = true
			notify_block.ZIndex = 54

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = notify_block

			UIStroke.Thickness = 1
			UIStroke.Transparency = 1
			Fatality:Register(UIStroke, "Stroke", "Color") 
			UIStroke.Parent = notify_block

			Icon.Name = Fatality:RandomString()
			Icon.Parent = notify_block
			Fatality:Register(Icon, "Main", "ImageColor3")
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 7, 0, 7)
			Icon.Size = UDim2.new(0, 18, 0, 18)
			Icon.Image = Fatality:GetIcon(Config.Icon)
			Icon.ImageTransparency = 1
			Icon.ZIndex = 55

			HeaderText.Name = Fatality:RandomString()
			HeaderText.Parent = notify_block
			HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HeaderText.BackgroundTransparency = 1.000
			HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HeaderText.BorderSizePixel = 0
			HeaderText.Position = UDim2.new(0, 30, 0, 7)
			HeaderText.Size = UDim2.new(1, 0, 0, 15)
			HeaderText.ZIndex = 55
			HeaderText.FontFace = Fatality.FontSemiBold
			HeaderText.Text = Config.Title
			Fatality:Register(HeaderText, "Main", "TextColor3") 
			HeaderText.TextSize = 13.000
			HeaderText.TextTransparency = 1
			HeaderText.TextXAlignment = Enum.TextXAlignment.Left

			BodyText.Name = Fatality:RandomString()
			BodyText.Parent = notify_block
			BodyText.AnchorPoint = Vector2.new(0, 1)
			BodyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			BodyText.BackgroundTransparency = 1.000
			BodyText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			BodyText.BorderSizePixel = 0
			BodyText.Position = UDim2.new(0, 10, 1, 0)
			BodyText.Size = UDim2.new(1, -15, 1, -29)
			BodyText.ZIndex = 55
			BodyText.FontFace = Fatality.FontSemiBold
			BodyText.Text = Config.Content or ""
			Fatality:Register(BodyText, "Text", "TextColor3")
			BodyText.TextSize = 12.000
			BodyText.TextTransparency = 1
			BodyText.TextWrapped = true
			BodyText.TextXAlignment = Enum.TextXAlignment.Left
			BodyText.TextYAlignment = Enum.TextYAlignment.Top

			local updateScale = function()
				local TitleScale = Fatality:GetTextSize(HeaderText,Enum.Font.GothamBold)
				local ContentScale = Fatality:GetTextSize(BodyText,Enum.Font.GothamMedium)

				local XScale = (TitleScale.X > ContentScale.X and TitleScale.X) or ContentScale.X
				local YScale = (TitleScale.Y > ContentScale.Y and TitleScale.Y) or ContentScale.Y

				notify.Size = UDim2.new(0, XScale + 25, 0, YScale + 50)

				Fatality:CreateAnimation(notify_block,0.35,{
					Position = UDim2.new(0.5, 0, 0, 0)
				})
			end

			task.delay(0.1,function()
				Fatality:CreateAnimation(notify_block,0.25,{
					BackgroundTransparency = 0.1
				})

				Fatality:CreateAnimation(UIStroke,0.25,{
					Thickness = 2.500,
					Transparency = 0.900
				})

				Fatality:CreateAnimation(Icon,0.25,{
					ImageTransparency = 0
				})

				Fatality:CreateAnimation(HeaderText,0.25,{
					TextTransparency = 0.200
				})

				Fatality:CreateAnimation(BodyText,0.25,{
					TextTransparency = 0.3
				})
			end)

			updateScale()

			task.delay(Config.Duration + 0.25,function()
				Fatality:CreateAnimation(notify_block,0.35,{
					Position = UDim2.new(0.5, 0, 1, 0)
				})

				Fatality:CreateAnimation(notify_block,0.25,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(UIStroke,0.25,{
					Thickness = 1,
					Transparency = 1
				})

				Fatality:CreateAnimation(Icon,0.25,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(HeaderText,0.25,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(BodyText,0.25,{
					TextTransparency = 1
				})

				task.delay(0.35,function()
					Fatality:CreateAnimation(notify,0.5,{
						Size = UDim2.new(0,0,0,0)
					})
					task.wait(0.5)
					notify:Destroy()
				end)
			end)
		end,
	})

	Fatality.__NOTIFIER_CACHE = res

	return res
end

Fatality.FATALITY_PID = Fatality:RandomString()

return Fatality
