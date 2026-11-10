--!nonstrict
--[[
	Spectra.wtf — ThemeManager  (v2.0.0)
	Temas prontos + temas personalizados (salvar/carregar/excluir/padrão) com aplicação em tempo real:
	cores, transparência, escala, fonte, arredondamento e animações.

	Persistência: arquivos quando writefile/readfile etc. existirem; senão memória da sessão.
	Os arquivos são apenas JSON; nenhum código importado é executado.

	Uso:
	  local ThemeManager = loadstring(game:HttpGet("URL/addons/ThemeManager.lua"))()
	  ThemeManager:SetLibrary(UI)
	  ThemeManager:SetFolder("MeuHub/MeuJogo")
	  ThemeManager:ApplyToTab(Tab)           -- Tab ou Groupbox
	  ThemeManager:LoadDefault()
]]

local HttpService = game:GetService("HttpService")

local function getEnv()
	if type(getgenv) == "function" then
		local ok, env = pcall(getgenv)
		if ok and type(env) == "table" then
			return env
		end
	end
	return nil
end

local ThemeManager = { Folder = "SpectraWTF", SubFolder = "", Library = nil, Version = "2.0.0" }

local sessionEnv = getEnv()
local Memory
if sessionEnv then
	sessionEnv.__SpectraThemeMemory = sessionEnv.__SpectraThemeMemory or {}
	Memory = sessionEnv.__SpectraThemeMemory
else
	Memory = {}
end

local hasFS = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
	and type(isfolder) == "function" and type(makefolder) == "function"
	and type(listfiles) == "function" and type(delfile) == "function"
if hasFS then
	hasFS = pcall(function()
		if not isfolder("SpectraWTF") then
			makefolder("SpectraWTF")
		end
	end)
end
ThemeManager.PersistentStorage = hasFS

local COLOR_KEYS = { "Background", "Sidebar", "Surface", "Element", "Hover", "Border", "Text", "Muted", "Accent" }
local STATUS_KEYS = { "Success", "Error", "Warning", "Info" }
local NUMBER_KEYS = { "Transparency", "Scale", "Rounding", "AnimSpeed" }

local function c(r, g, b)
	return Color3.fromRGB(r, g, b)
end

ThemeManager.Presets = {
	["Spectra"] = {
		Background = c(10, 10, 10), Sidebar = c(13, 13, 13), Surface = c(18, 18, 18), Element = c(25, 25, 25),
		Hover = c(34, 34, 34), Border = c(39, 39, 39), Text = c(245, 245, 245), Muted = c(125, 125, 125), Accent = c(255, 255, 255),
	},
	["Carbon"] = {
		Background = c(14, 14, 16), Sidebar = c(18, 18, 21), Surface = c(23, 23, 27), Element = c(31, 31, 36),
		Hover = c(42, 42, 49), Border = c(48, 48, 56), Text = c(236, 236, 240), Muted = c(130, 130, 142), Accent = c(200, 200, 215),
	},
	["Midnight"] = {
		Background = c(6, 8, 14), Sidebar = c(9, 12, 20), Surface = c(13, 17, 28), Element = c(20, 26, 41),
		Hover = c(28, 36, 56), Border = c(34, 44, 68), Text = c(232, 238, 250), Muted = c(112, 126, 156), Accent = c(150, 175, 255),
	},
	["Graphite"] = {
		Background = c(28, 28, 28), Sidebar = c(33, 33, 33), Surface = c(40, 40, 40), Element = c(49, 49, 49),
		Hover = c(60, 60, 60), Border = c(70, 70, 70), Text = c(240, 240, 240), Muted = c(150, 150, 150), Accent = c(225, 225, 225),
	},
	["Ash"] = {
		Background = c(20, 20, 20), Sidebar = c(26, 26, 26), Surface = c(33, 33, 33), Element = c(42, 42, 42),
		Hover = c(54, 54, 54), Border = c(64, 64, 64), Text = c(230, 230, 230), Muted = c(140, 140, 140), Accent = c(170, 170, 170),
	},
	["Paper"] = {
		Background = c(238, 238, 238), Sidebar = c(226, 226, 226), Surface = c(246, 246, 246), Element = c(232, 232, 232),
		Hover = c(218, 218, 218), Border = c(200, 200, 200), Text = c(24, 24, 24), Muted = c(110, 110, 110), Accent = c(20, 20, 20),
	},
}
ThemeManager.PresetOrder = { "Spectra", "Carbon", "Midnight", "Graphite", "Ash", "Paper" }

----------------------------------------------------------------------------------------
-- Armazenamento
----------------------------------------------------------------------------------------
function ThemeManager:_Base()
	return self.Folder .. (self.SubFolder ~= "" and ("/" .. self.SubFolder) or "")
end
function ThemeManager:_Dir()
	return self:_Base() .. "/themes"
end
function ThemeManager:_Key(name)
	return self:_Dir() .. "/" .. name .. ".json"
end

local function sanitize(name)
	name = tostring(name or ""):gsub("[^%w _%-%.]", ""):gsub("^%s+", ""):gsub("%s+$", "")
	name = name:sub(1, 48)
	if name == "" or name:find("^%.") then
		return nil
	end
	return name
end

local function ensure(self)
	if not hasFS then
		return
	end
	local parts = {}
	for segment in self:_Dir():gmatch("[^/\\]+") do
		table.insert(parts, segment)
		local path = table.concat(parts, "/")
		if not isfolder(path) then
			pcall(makefolder, path)
		end
	end
end

function ThemeManager:SetLibrary(library)
	self.Library = library
end

function ThemeManager:SetFolder(folder, sub)
	self.Folder = tostring(folder or "SpectraWTF"):gsub("\\", "/")
	self.SubFolder = tostring(sub or ""):gsub("\\", "/")
	ensure(self)
	if self.RefreshUI then
		self.RefreshUI()
	end
end

local function toHex(col)
	return string.format("%02X%02X%02X", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5))
end

local function fromHex(hex)
	hex = tostring(hex or ""):gsub("#", "")
	if #hex ~= 6 or hex:find("%X") then
		return nil
	end
	local n = tonumber(hex, 16)
	return Color3.fromRGB(math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256)
end

function ThemeManager:_Notify(text, kind)
	if self.Library and self.Library.Notify then
		self.Library:Notify({ Title = "Theme", Description = text, Type = kind or "Information", Duration = 2.5 })
	end
end

----------------------------------------------------------------------------------------
-- Aplicar / serializar
----------------------------------------------------------------------------------------
function ThemeManager:GetCurrent()
	local lib = assert(self.Library, "ThemeManager: chame SetLibrary(UI) antes")
	return lib:GetTheme()
end

function ThemeManager:Serialize()
	local theme = self:GetCurrent()
	local data = { version = 2, colors = {}, numbers = {} }
	for _, key in ipairs(COLOR_KEYS) do
		data.colors[key] = toHex(theme[key])
	end
	for _, key in ipairs(STATUS_KEYS) do
		data.colors[key] = toHex(theme[key])
	end
	for _, key in ipairs(NUMBER_KEYS) do
		data.numbers[key] = theme[key]
	end
	data.animations = theme.Animations
	data.font = theme.FontFamily
	return HttpService:JSONEncode(data)
end

-- aceita nome de preset, tabela {Background=Color3,...} ou JSON decodificado
function ThemeManager:ApplyTheme(source)
	local lib = assert(self.Library, "ThemeManager: chame SetLibrary(UI) antes")
	local patch = {}
	if type(source) == "string" then
		source = self.Presets[source]
		if not source then
			return false, "Tema não encontrado"
		end
	end
	if type(source) ~= "table" then
		return false, "Tema inválido"
	end
	for key, value in pairs(source) do
		if typeof(value) == "Color3" or type(value) == "number" or type(value) == "boolean" or type(value) == "string" then
			patch[key] = value
		end
	end
	lib:SetTheme(patch)
	self:SyncUI()
	return true
end

function ThemeManager:ApplyData(data)
	if type(data) ~= "table" then
		return false
	end
	local patch = {}
	if type(data.colors) == "table" then
		for key, hex in pairs(data.colors) do
			local color = fromHex(hex)
			if color and (table.find(COLOR_KEYS, key) or table.find(STATUS_KEYS, key)) then
				patch[key] = color
			end
		end
	end
	if type(data.numbers) == "table" then
		for _, key in ipairs(NUMBER_KEYS) do
			if type(data.numbers[key]) == "number" then
				patch[key] = data.numbers[key]
			end
		end
	end
	if type(data.animations) == "boolean" then
		patch.Animations = data.animations
	end
	if type(data.font) == "string" then
		patch.FontFamily = data.font
	end
	return self:ApplyTheme(patch)
end

function ThemeManager:SaveCustom(name)
	name = sanitize(name)
	if not name then
		return false, "Nome inválido"
	end
	local json = self:Serialize()
	if hasFS then
		ensure(self)
		local ok, err = pcall(writefile, self:_Key(name), json)
		return ok, err
	end
	Memory[self:_Key(name)] = json
	return true
end

function ThemeManager:_Read(name)
	if hasFS then
		local ok, exists = pcall(isfile, self:_Key(name))
		if ok and exists then
			local ok2, data = pcall(readfile, self:_Key(name))
			return ok2 and data or nil
		end
		return nil
	end
	return Memory[self:_Key(name)]
end

function ThemeManager:LoadCustom(name)
	name = sanitize(name)
	if not name then
		return false, "Nome inválido"
	end
	local json = self:_Read(name)
	if not json then
		return false, "Tema não encontrado"
	end
	local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
	if not ok then
		return false, "JSON inválido"
	end
	return self:ApplyData(data)
end

function ThemeManager:DeleteCustom(name)
	name = sanitize(name)
	if not name or not self:_Read(name) then
		return false, "Tema não encontrado"
	end
	if hasFS then
		return pcall(delfile, self:_Key(name))
	end
	Memory[self:_Key(name)] = nil
	return true
end

function ThemeManager:ListCustom()
	local names = {}
	if hasFS then
		ensure(self)
		local ok, files = pcall(listfiles, self:_Dir())
		if ok and type(files) == "table" then
			for _, path in ipairs(files) do
				local name = tostring(path):gsub("\\", "/"):match("([^/]+)%.json$")
				if name then
					table.insert(names, name)
				end
			end
		end
	else
		local prefix = self:_Dir() .. "/"
		for key in pairs(Memory) do
			if key:sub(1, #prefix) == prefix then
				local name = key:sub(#prefix + 1):match("^(.+)%.json$")
				if name then
					table.insert(names, name)
				end
			end
		end
	end
	table.sort(names, function(a, b) return a:lower() < b:lower() end)
	return names
end

function ThemeManager:Export()
	return self:Serialize()
end

function ThemeManager:Import(json)
	local ok, data = pcall(HttpService.JSONDecode, HttpService, tostring(json))
	if not ok then
		return false, "JSON inválido"
	end
	return self:ApplyData(data)
end

-- tema padrão (carregado por LoadDefault) --------------------------------------------------
function ThemeManager:_DefaultKey()
	return self:_Base() .. "/themes_default.txt"
end

function ThemeManager:SetDefault(name)
	name = tostring(name or "")
	if not self.Presets[name] and not self:_Read(sanitize(name) or "") then
		return false, "Tema não encontrado"
	end
	if hasFS then
		ensure(self)
		return pcall(writefile, self:_DefaultKey(), name)
	end
	Memory[self:_DefaultKey()] = name
	return true
end

function ThemeManager:GetDefault()
	if hasFS then
		local ok, exists = pcall(isfile, self:_DefaultKey())
		if ok and exists then
			local ok2, data = pcall(readfile, self:_DefaultKey())
			return ok2 and data or nil
		end
		return nil
	end
	return Memory[self:_DefaultKey()]
end

function ThemeManager:LoadDefault()
	local name = self:GetDefault()
	if not name or name == "" then
		return false
	end
	if self.Presets[name] then
		return self:ApplyTheme(name)
	end
	return self:LoadCustom(name)
end

----------------------------------------------------------------------------------------
-- Interface
----------------------------------------------------------------------------------------
function ThemeManager:SyncUI()
	local lib = self.Library
	if not lib or not self.Controls then
		return
	end
	local theme = lib.Theme
	for key, control in pairs(self.Controls) do
		local value = theme[key]
		if value ~= nil and not control.Destroyed then
			control:SetValue(value, true)
		end
	end
end

function ThemeManager:ApplyToTab(target)
	local lib = assert(self.Library, "ThemeManager: chame SetLibrary(UI) antes")
	local colors, general, custom = target, target, target
	if target.AddLeftGroupbox then
		colors = target:AddLeftGroupbox("Theme colors", "Palette")
		general = target:AddRightGroupbox("Appearance", "Sliders")
		custom = target:AddRightGroupbox("Custom themes", "Save")
	end
	self.Controls = {}
	ensure(self)

	local presetItems = {}
	for _, name in ipairs(self.PresetOrder) do
		table.insert(presetItems, name)
	end
	local presetDD = general:AddDropdown("ThemeManager_Preset", {
		Text = "Preset", Values = presetItems, Default = "Spectra",
		Callback = function(value)
			if value then
				self:ApplyTheme(value)
			end
		end,
	})
	general:AddButton({ Text = "Apply preset", Icon = "Palette", Func = function()
		if presetDD.Value then
			self:ApplyTheme(presetDD.Value)
		end
	end })

	for _, key in ipairs(COLOR_KEYS) do
		local picker = colors:AddColorPicker("ThemeManager_" .. key, {
			Text = key, Default = lib.Theme[key], Title = "Theme: " .. key,
			Callback = function(color)
				lib:SetTheme(key, color)
			end,
		})
		self.Controls[key] = picker
	end
	colors:AddDivider("Status colors")
	for _, key in ipairs(STATUS_KEYS) do
		self.Controls[key] = colors:AddColorPicker("ThemeManager_" .. key, {
			Text = key, Default = lib.Theme[key], Title = "Theme: " .. key,
			Callback = function(color)
				lib:SetTheme(key, color)
			end,
		})
	end

	self.Controls.Transparency = general:AddSlider("ThemeManager_Transparency", {
		Text = "Window transparency", Min = 0, Max = 0.6, Default = lib.Theme.Transparency, Rounding = 2,
		Callback = function(v) lib:SetTheme("Transparency", v) end,
	})
	self.Controls.Scale = general:AddSlider("ThemeManager_Scale", {
		Text = "UI scale", Min = 0.6, Max = 1.6, Default = lib.Theme.Scale, Rounding = 2,
		Callback = function(v) lib:SetTheme("Scale", v) end,
	})
	self.Controls.Rounding = general:AddSlider("ThemeManager_Rounding", {
		Text = "Corner rounding", Min = 0, Max = 16, Default = lib.Theme.Rounding, Rounding = 0,
		Callback = function(v) lib:SetTheme("Rounding", v) end,
	})
	self.Controls.AnimSpeed = general:AddSlider("ThemeManager_AnimSpeed", {
		Text = "Animation speed", Min = 0.25, Max = 3, Default = lib.Theme.AnimSpeed, Rounding = 2,
		Callback = function(v) lib:SetTheme("AnimSpeed", v) end,
	})
	self.Controls.Animations = general:AddToggle("ThemeManager_Animations", {
		Text = "Animations", Default = lib.Theme.Animations,
		Callback = function(v) lib:SetTheme("Animations", v) end,
	})
	self.Controls.FontFamily = general:AddDropdown("ThemeManager_Font", {
		Text = "Font", Values = lib.FontFamilies, Default = lib.Theme.FontFamily,
		Callback = function(v)
			if v then
				lib:SetTheme("FontFamily", v)
			end
		end,
	})

	-- temas personalizados
	local nameInput = custom:AddInput("ThemeManager_Name", { Text = "Theme name", Placeholder = "my-theme" })
	local list = custom:AddDropdown("ThemeManager_List", { Text = "Saved themes", Values = self:ListCustom(), AllowNull = true, Searchable = true })
	local defaultLabel = custom:AddLabel({ Text = "Default: none", Muted = true })
	local function refresh()
		list:SetValues(self:ListCustom(), true)
		defaultLabel:SetText("Default: " .. (self:GetDefault() or "none"))
	end
	self.RefreshUI = refresh
	refresh()
	custom:AddLabel({
		Text = hasFS and "Storage: files (persistent)" or "Storage: memory only (this session)", DoesWrap = true, Muted = true,
	})

	local function report(ok, err, text)
		self:_Notify(ok and text or tostring(err), ok and "Success" or "Error")
		refresh()
	end
	local save = custom:AddButton({ Text = "Save current", Icon = "Save", Func = function()
		local ok, err = self:SaveCustom(nameInput.Value)
		report(ok, err, "Tema salvo")
	end })
	save:AddButton({ Text = "Load", Icon = "Download", Func = function()
		if not list.Value then
			return self:_Notify("Selecione um tema", "Warning")
		end
		local ok, err = self:LoadCustom(list.Value)
		report(ok, err, "Tema carregado: " .. list.Value)
	end })
	local del = custom:AddButton({ Text = "Delete", Icon = "Trash", DoubleClick = true, ConfirmText = "Confirm delete", Func = function()
		if not list.Value then
			return self:_Notify("Selecione um tema", "Warning")
		end
		local ok, err = self:DeleteCustom(list.Value)
		report(ok, err, "Tema excluído")
		if ok then
			list:SetValue(nil, true)
		end
	end })
	del:AddButton({ Text = "Set default", Icon = "Star", Func = function()
		local name = list.Value or presetDD.Value
		local ok, err = self:SetDefault(name)
		report(ok, err, "Padrão: " .. tostring(name))
	end })
	local io = custom:AddButton({ Text = "Export JSON", Icon = "Upload", Func = function()
		local json = self:Export()
		local copied = type(setclipboard) == "function" and pcall(setclipboard, json)
		self.JsonBox.Box.Text = json
		self:_Notify(copied and "JSON copiado" or "JSON colocado na caixa", "Success")
	end })
	io:AddButton({ Text = "Import JSON", Icon = "Download", Func = function()
		local ok, err = self:Import(self.JsonBox.Box.Text)
		report(ok, err, "Tema importado")
	end })
	self.JsonBox = custom:AddInput("ThemeManager_JSON", { Placeholder = "theme JSON", Finished = true })
	return colors
end

return ThemeManager
