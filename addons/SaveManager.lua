--!nonstrict
--[[
	Spectra.wtf — SaveManager  (v2.0.0)
	Gerencia configurações: criar, salvar, carregar, renomear, excluir, listar, importar/exportar JSON.

	Persistência:
	  • Usa writefile/readfile/isfile/isfolder/makefolder/listfiles/delfile SOMENTE se existirem e funcionarem.
	  • Caso contrário usa fallback em memória (vale apenas enquanto o jogo/executor estiver aberto).
	  • Arquivos são lidos apenas como JSON (JSONDecode). Nenhum código importado é executado.

	Uso:
	  local SaveManager = loadstring(game:HttpGet("URL/addons/SaveManager.lua"))()
	  SaveManager:SetLibrary(UI)
	  SaveManager:SetFolder("MeuHub/MeuJogo")
	  SaveManager:BuildConfigSection(Tab)          -- Tab ou Groupbox
	  SaveManager:LoadAutoloadConfig()
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

local SaveManager = {
	Folder = "SpectraWTF",
	SubFolder = "",
	Library = nil,
	Ignore = {},
	IgnorePrefixes = { "SaveManager_", "ThemeManager_" },
	Version = "2.0.0",
}

-- memória compartilhada durante a sessão (sobrevive a re-execuções quando getgenv existe)
local sessionEnv = getEnv()
local Memory
if sessionEnv then
	sessionEnv.__SpectraSaveMemory = sessionEnv.__SpectraSaveMemory or {}
	Memory = sessionEnv.__SpectraSaveMemory
else
	Memory = {}
end

----------------------------------------------------------------------------------------
-- Backend de armazenamento
----------------------------------------------------------------------------------------
local hasFS = false
do
	-- detecção simples e segura, sem executar texto de terceiros
	hasFS = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
		and type(isfolder) == "function" and type(makefolder) == "function"
		and type(listfiles) == "function" and type(delfile) == "function"
	if hasFS then
		hasFS = pcall(function()
			if not isfolder("SpectraWTF") then
				makefolder("SpectraWTF")
			end
		end)
	end
end
SaveManager.PersistentStorage = hasFS

function SaveManager:GetStorageMode()
	return hasFS and "file" or "memory"
end

local function ensureFolders(self)
	if not hasFS then
		return
	end
	local parts = {}
	for segment in (self.Folder .. (self.SubFolder ~= "" and ("/" .. self.SubFolder) or "")):gmatch("[^/\\]+") do
		table.insert(parts, segment)
		local path = table.concat(parts, "/")
		if not isfolder(path) then
			pcall(makefolder, path)
		end
	end
	local settings = self:_Dir()
	if not isfolder(settings) then
		pcall(makefolder, settings)
	end
end

function SaveManager:_Base()
	return self.Folder .. (self.SubFolder ~= "" and ("/" .. self.SubFolder) or "")
end

function SaveManager:_Dir()
	return self:_Base() .. "/settings"
end

function SaveManager:_Key(name)
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
SaveManager.SanitizeName = sanitize

function SaveManager:_Write(name, content)
	if hasFS then
		ensureFolders(self)
		local ok, err = pcall(writefile, self:_Key(name), content)
		return ok, err
	end
	Memory[self:_Key(name)] = content
	return true
end

function SaveManager:_Read(name)
	if hasFS then
		local path = self:_Key(name)
		local okExists, exists = pcall(isfile, path)
		if not okExists or not exists then
			return nil
		end
		local ok, content = pcall(readfile, path)
		return ok and content or nil
	end
	return Memory[self:_Key(name)]
end

function SaveManager:_Exists(name)
	return self:_Read(name) ~= nil
end

function SaveManager:_Delete(name)
	if hasFS then
		local ok = pcall(delfile, self:_Key(name))
		return ok
	end
	Memory[self:_Key(name)] = nil
	return true
end

function SaveManager:_Notify(title, text, kind)
	local lib = self.Library
	if lib and lib.Notify then
		lib:Notify({ Title = title, Description = text, Type = kind or "Information", Duration = 3 })
	end
end

----------------------------------------------------------------------------------------
-- Serialização por tipo (somente dados, nunca código)
----------------------------------------------------------------------------------------
local function setToList(set)
	local list = {}
	for key, v in pairs(set) do
		if v then
			table.insert(list, key)
		end
	end
	table.sort(list, function(a, b) return tostring(a) < tostring(b) end)
	return list
end

local Parsers = {
	Toggle = {
		Save = function(o) return { type = "Toggle", value = o.Value == true } end,
		Load = function(o, d) if type(d.value) == "boolean" then o:SetValue(d.value) end end,
	},
	Checkbox = {
		Save = function(o) return { type = "Checkbox", value = o.Value == true } end,
		Load = function(o, d) if type(d.value) == "boolean" then o:SetValue(d.value) end end,
	},
	CheckboxGroup = {
		Save = function(o)
			return { type = "CheckboxGroup", value = o.Multi and setToList(o.Value or {}) or o.Value }
		end,
		Load = function(o, d) o:SetValue(d.value) end,
	},
	Slider = {
		Save = function(o) return { type = "Slider", value = o.Value } end,
		Load = function(o, d) if type(d.value) == "number" then o:SetValue(d.value) end end,
	},
	Input = {
		Save = function(o) return { type = "Input", value = o.Value } end,
		Load = function(o, d) if d.value ~= nil then o:SetValue(d.value) end end,
	},
	Dropdown = {
		Save = function(o)
			return { type = "Dropdown", multi = o.Multi == true, value = o.Multi and setToList(o.Value or {}) or o.Value }
		end,
		Load = function(o, d)
			if o.Multi and type(d.value) == "table" then
				o:SetValue(d.value)
			elseif not o.Multi then
				o:SetValue(d.value)
			end
		end,
	},
	ColorPicker = {
		Save = function(o)
			local c = o.Value
			return {
				type = "ColorPicker",
				value = string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)),
				transparency = o.HasAlpha and o.Transparency or nil,
			}
		end,
		Load = function(o, d)
			if type(d.value) == "string" then
				o:SetValue(d.value, d.transparency)
			end
		end,
	},
	KeyPicker = {
		Save = function(o) return { type = "KeyPicker", key = o.Key, mode = o.Mode } end,
		Load = function(o, d)
			if type(d.key) == "string" then
				o:SetValue({ Key = d.key, Mode = d.mode })
			end
		end,
	},
}
SaveManager.Parsers = Parsers

function SaveManager:SetLibrary(library)
	self.Library = library
end

function SaveManager:SetFolder(folder, sub)
	self.Folder = tostring(folder or "SpectraWTF"):gsub("\\", "/")
	self.SubFolder = tostring(sub or ""):gsub("\\", "/")
	ensureFolders(self)
	if self.RefreshUI then
		self.RefreshUI()
	end
end

function SaveManager:SetSubFolder(sub)
	self:SetFolder(self.Folder, sub)
end

function SaveManager:SetIgnoreIndexes(list)
	for _, idx in ipairs(list or {}) do
		self.Ignore[idx] = true
	end
end

function SaveManager:IsIgnored(idx)
	if self.Ignore[idx] or tostring(idx):sub(1, 1) == "_" then
		return true
	end
	for _, prefix in ipairs(self.IgnorePrefixes) do
		if tostring(idx):sub(1, #prefix) == prefix then
			return true
		end
	end
	return false
end

----------------------------------------------------------------------------------------
-- Operações
----------------------------------------------------------------------------------------
function SaveManager:Serialize()
	local lib = assert(self.Library, "SaveManager: chame SetLibrary(UI) antes")
	local objects = {}
	for idx, option in pairs(lib.Options) do
		local parser = Parsers[option.Type]
		if parser and not self:IsIgnored(idx) and not option.Destroyed then
			local ok, data = pcall(parser.Save, option)
			if ok and data then
				objects[idx] = data
			end
		end
	end
	return HttpService:JSONEncode({ version = 2, objects = objects })
end

function SaveManager:Deserialize(json)
	local lib = assert(self.Library, "SaveManager: chame SetLibrary(UI) antes")
	local ok, decoded = pcall(HttpService.JSONDecode, HttpService, json)
	if not ok or type(decoded) ~= "table" or type(decoded.objects) ~= "table" then
		return false, "JSON inválido"
	end
	local applied, failed = 0, 0
	for idx, data in pairs(decoded.objects) do
		local option = lib.Options[idx]
		if option and type(data) == "table" and data.type == option.Type and not self:IsIgnored(idx) then
			local parser = Parsers[option.Type]
			if parser and pcall(parser.Load, option, data) then
				applied += 1
			else
				failed += 1
			end
		end
	end
	return true, applied, failed
end

function SaveManager:Save(name)
	name = sanitize(name)
	if not name then
		return false, "Nome de configuração inválido"
	end
	local ok, err = self:_Write(name, self:Serialize())
	if not ok then
		return false, tostring(err)
	end
	return true
end

function SaveManager:Load(name)
	name = sanitize(name)
	if not name then
		return false, "Nome de configuração inválido"
	end
	local content = self:_Read(name)
	if not content then
		return false, "Configuração não encontrada"
	end
	return self:Deserialize(content)
end

function SaveManager:Delete(name)
	name = sanitize(name)
	if not name or not self:_Exists(name) then
		return false, "Configuração não encontrada"
	end
	if self:GetAutoload() == name then
		self:ResetAutoload()
	end
	return self:_Delete(name)
end

function SaveManager:Rename(old, new)
	old, new = sanitize(old), sanitize(new)
	if not old or not new then
		return false, "Nome inválido"
	end
	if old == new then
		return false, "Os nomes são iguais"
	end
	local content = self:_Read(old)
	if not content then
		return false, "Configuração não encontrada"
	end
	if self:_Exists(new) then
		return false, "Já existe uma configuração com esse nome"
	end
	local ok, err = self:_Write(new, content)
	if not ok then
		return false, tostring(err)
	end
	self:_Delete(old)
	if self:GetAutoload() == old then
		self:SetAutoload(new)
	end
	return true
end

function SaveManager:List()
	local names = {}
	if hasFS then
		ensureFolders(self)
		local ok, files = pcall(listfiles, self:_Dir())
		if ok and type(files) == "table" then
			for _, path in ipairs(files) do
				local file = tostring(path):gsub("\\", "/")
				local name = file:match("([^/]+)%.json$")
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

function SaveManager:Export(name)
	if name then
		name = sanitize(name)
		return name and self:_Read(name) or nil
	end
	return self:Serialize()
end

function SaveManager:Import(name, json)
	name = sanitize(name)
	if not name then
		return false, "Nome inválido"
	end
	local ok, decoded = pcall(HttpService.JSONDecode, HttpService, tostring(json))
	if not ok or type(decoded) ~= "table" or type(decoded.objects) ~= "table" then
		return false, "JSON inválido"
	end
	return self:_Write(name, HttpService:JSONEncode(decoded))
end

-- autoload ----------------------------------------------------------------------------
function SaveManager:_AutoKey()
	return self:_Base() .. "/autoload.txt"
end

function SaveManager:GetAutoload()
	local content
	if hasFS then
		local ok, exists = pcall(isfile, self:_AutoKey())
		if ok and exists then
			local ok2, data = pcall(readfile, self:_AutoKey())
			content = ok2 and data or nil
		end
	else
		content = Memory[self:_AutoKey()]
	end
	content = content and sanitize(content)
	if content and self:_Exists(content) then
		return content
	end
	return nil
end

function SaveManager:SetAutoload(name)
	name = sanitize(name)
	if not name or not self:_Exists(name) then
		return false, "Configuração não encontrada"
	end
	if hasFS then
		ensureFolders(self)
		return pcall(writefile, self:_AutoKey(), name)
	end
	Memory[self:_AutoKey()] = name
	return true
end

function SaveManager:ResetAutoload()
	if hasFS then
		pcall(function()
			if isfile(self:_AutoKey()) then
				delfile(self:_AutoKey())
			end
		end)
	else
		Memory[self:_AutoKey()] = nil
	end
	return true
end

function SaveManager:LoadAutoloadConfig()
	local name = self:GetAutoload()
	if not name then
		return false
	end
	local ok, a, b = self:Load(name)
	if ok then
		self:_Notify("Config", ("Autoload: %s (%d valores)"):format(name, a or 0), "Success")
	else
		self:_Notify("Config", "Falha no autoload: " .. tostring(a), "Error")
	end
	return ok
end

----------------------------------------------------------------------------------------
-- Interface pronta (Groupbox "Configuration")
----------------------------------------------------------------------------------------
function SaveManager:BuildConfigSection(target)
	local lib = assert(self.Library, "SaveManager: chame SetLibrary(UI) antes")
	local gb = target
	if target.AddLeftGroupbox then
		gb = target:AddRightGroupbox("Configuration", "Save")
	end
	ensureFolders(self)

	gb:AddLabel({
		Text = hasFS and "Storage: files (persistent)" or "Storage: memory only (this session)",
		DoesWrap = true, Muted = true,
	})
	local nameInput = gb:AddInput("SaveManager_ConfigName", { Text = "Config name", Placeholder = "my-config" })
	local list = gb:AddDropdown("SaveManager_ConfigList", {
		Text = "Config list", Values = self:List(), Searchable = true, AllowNull = true,
	})
	local autoLabel = gb:AddLabel({ Text = "Autoload: none", Muted = true })

	local function refresh()
		local names = self:List()
		list:SetValues(names, true)
		local auto = self:GetAutoload()
		autoLabel:SetText("Autoload: " .. (auto or "none"))
	end
	self.RefreshUI = refresh
	refresh()

	local function report(ok, a, successText)
		if ok then
			self:_Notify("Config", successText, "Success")
		else
			self:_Notify("Config", tostring(a), "Error")
		end
		refresh()
		return ok
	end

	local create = gb:AddButton({
		Text = "Create config", Icon = "Plus",
		Func = function()
			local name = sanitize(nameInput.Value)
			if not name then
				return self:_Notify("Config", "Nome inválido", "Warning")
			end
			if self:_Exists(name) then
				return self:_Notify("Config", "Já existe uma configuração com esse nome", "Warning")
			end
			local ok, err = self:Save(name)
			report(ok, err, "Criada: " .. name)
			if ok then
				list:SetValue(name, true)
			end
		end,
	})
	create:AddButton({
		Text = "Refresh", Icon = "Refresh",
		Func = refresh,
	})

	local load = gb:AddButton({
		Text = "Load", Icon = "Download",
		Func = function()
			local name = list.Value
			if not name then
				return self:_Notify("Config", "Selecione uma configuração", "Warning")
			end
			local ok, a, b = self:Load(name)
			if ok then
				self:_Notify("Config", ("Carregada: %s (%d valores%s)"):format(name, a or 0, (b and b > 0) and (", " .. b .. " falhas") or ""), "Success")
			else
				self:_Notify("Config", tostring(a), "Error")
			end
		end,
	})
	load:AddButton({
		Text = "Overwrite", Icon = "Save", DoubleClick = true, ConfirmText = "Confirm overwrite",
		Func = function()
			local name = list.Value
			if not name then
				return self:_Notify("Config", "Selecione uma configuração", "Warning")
			end
			local ok, err = self:Save(name)
			report(ok, err, "Salva: " .. name)
		end,
	})

	local rename = gb:AddButton({
		Text = "Rename → name above", Icon = "Pencil",
		Func = function()
			local old = list.Value
			if not old then
				return self:_Notify("Config", "Selecione uma configuração", "Warning")
			end
			local ok, err = self:Rename(old, nameInput.Value)
			report(ok, err, "Renomeada para " .. tostring(sanitize(nameInput.Value)))
			if ok then
				list:SetValue(sanitize(nameInput.Value), true)
			end
		end,
	})
	rename:AddButton({
		Text = "Delete", Icon = "Trash", DoubleClick = true, ConfirmText = "Confirm delete",
		Func = function()
			local name = list.Value
			if not name then
				return self:_Notify("Config", "Selecione uma configuração", "Warning")
			end
			local ok, err = self:Delete(name)
			report(ok, err, "Excluída: " .. name)
			if ok then
				list:SetValue(nil, true)
			end
		end,
	})

	local auto = gb:AddButton({
		Text = "Set autoload", Icon = "Star",
		Func = function()
			local name = list.Value
			if not name then
				return self:_Notify("Config", "Selecione uma configuração", "Warning")
			end
			local ok, err = self:SetAutoload(name)
			report(ok, err, "Autoload: " .. name)
		end,
	})
	auto:AddButton({
		Text = "Reset autoload",
		Func = function()
			self:ResetAutoload()
			report(true, nil, "Autoload removido")
		end,
	})

	gb:AddDivider("JSON", "Exporte/importe configurações como texto.")
	local jsonBox = gb:AddInput("SaveManager_JSON", { Text = "JSON", Placeholder = "paste JSON here", Finished = true })
	local io = gb:AddButton({
		Text = "Export selected", Icon = "Upload",
		Func = function()
			local name = list.Value
			local json = name and self:Export(name) or self:Serialize()
			local copied = false
			if type(setclipboard) == "function" then
				copied = pcall(setclipboard, json)
			end
			jsonBox:SetValue(json, true)
			jsonBox.Box.Text = json
			self:_Notify("Config", copied and "JSON copiado para a área de transferência" or "JSON colocado na caixa acima", "Success")
		end,
	})
	io:AddButton({
		Text = "Import → name above", Icon = "Download",
		Func = function()
			local name = sanitize(nameInput.Value)
			if not name then
				return self:_Notify("Config", "Informe um nome válido em 'Config name'", "Warning")
			end
			local ok, err = self:Import(name, jsonBox.Box.Text)
			report(ok, err, "Importada: " .. name)
		end,
	})
	return gb
end

return SaveManager
