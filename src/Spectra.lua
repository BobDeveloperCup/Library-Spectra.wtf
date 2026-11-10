local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Spectra = {}
Spectra.__index = Spectra
Spectra.Version = "2.0.0"

local DEFAULT_THEME = {
    Background = Color3.fromRGB(10, 10, 10), Sidebar = Color3.fromRGB(13, 13, 13),
    Surface = Color3.fromRGB(18, 18, 18), Element = Color3.fromRGB(25, 25, 25),
    Hover = Color3.fromRGB(34, 34, 34), Border = Color3.fromRGB(39, 39, 39),
    Text = Color3.fromRGB(245, 245, 245), Muted = Color3.fromRGB(125, 125, 125),
    Accent = Color3.fromRGB(225, 225, 225), Success = Color3.fromRGB(105, 190, 125),
    Error = Color3.fromRGB(220, 95, 95), Warning = Color3.fromRGB(220, 175, 85),
}

local Icons = {
    Home="⌂", User="◉", Eye="◎", Palette="◈", Settings="⚙", Search="⌕", Refresh="↻",
    Close="×", Check="✓", Chevron="›", Menu="☰", Plus="+", Minus="−", Info="ⓘ",
    Shield="◇", Sparkles="✧", Folder="▣", Save="▤", Trash="⌫", Copy="▢",
}

local function copyTable(source)
    local result = {}
    for key, value in pairs(source or {}) do
        if type(value) == "table" then result[key] = copyTable(value) else result[key] = value end
    end
    return result
end

local function create(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        local ok, err = pcall(function() object[key] = value end)
        if not ok then warn("[Spectra] Property " .. tostring(key) .. ": " .. tostring(err)) end
    end
    object.Parent = parent
    return object
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 7)}, parent)
end

local function stroke(parent, color, transparency)
    return create("UIStroke", {Color = color or DEFAULT_THEME.Border, Thickness = 1, Transparency = transparency or 0}, parent)
end

local function tween(object, properties, duration)
    if not object or not object.Parent then return end
    local ok, animation = pcall(function()
        return TweenService:Create(object, TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
    end)
    if ok then animation:Play(); return animation end
end

local function textLabel(parent, text, size, color, font)
    return create("TextLabel", {
        BackgroundTransparency = 1, Text = tostring(text or ""), TextSize = size or 11,
        TextColor3 = color or DEFAULT_THEME.Text, Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
end

local function makeIcon(parent, icon, size, position, color)
    local value = Icons[icon] or icon or "•"
    if type(value) == "string" and (value:match("^rbxassetid://") or value:match("^https?://")) then
        return create("ImageLabel", {BackgroundTransparency=1, Image=value, Size=UDim2.fromOffset(size or 16,size or 16), Position=position or UDim2.new(), ScaleType=Enum.ScaleType.Fit}, parent)
    end
    return create("TextLabel", {BackgroundTransparency=1, Text=tostring(value), TextColor3=color or DEFAULT_THEME.Muted,
        TextSize=size or 16, Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Center,
        TextYAlignment=Enum.TextYAlignment.Center, Size=UDim2.fromOffset(size or 16,size or 16), Position=position or UDim2.new()}, parent)
end

local function safeCallback(callback, ...)
    if type(callback) ~= "function" then return end
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(function() callback(table.unpack(args, 1, args.n)) end)
        if not ok then warn("[Spectra callback] " .. tostring(err)) end
    end)
end

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function bindDrag(library, handle, target)
    local dragging, dragInput, dragStart, startPosition = false, nil, nil, nil
    local began = handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPosition = true, input.Position, target.Position
            local ended
            ended = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false; ended:Disconnect() end
            end)
            library:_track(ended)
        end
    end)
    local changed = handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    local global = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
    library:_track(began); library:_track(changed); library:_track(global)
end

function Spectra:_track(connection)
    if connection then table.insert(self.Connections, connection) end
    return connection
end

function Spectra:_register(id, kind, object)
    if not id then return end
    self.Registry[id] = {Type = kind, Object = object}
end

function Spectra:_applyTheme()
    for object, role in pairs(self.ThemeObjects) do
        if object and object.Parent and self.Theme[role] then
            pcall(function() object.BackgroundColor3 = self.Theme[role] end)
        end
    end
    for object, role in pairs(self.TextObjects) do
        if object and object.Parent and self.Theme[role] then
            pcall(function() object.TextColor3 = self.Theme[role] end)
        end
    end
end

function Spectra:SetTheme(key, color)
    if self.Theme[key] and typeof(color) == "Color3" then self.Theme[key] = color; self:_applyTheme() end
    return self
end

function Spectra:SetThemeTable(values)
    for key, value in pairs(values or {}) do
        if self.Theme[key] ~= nil and typeof(value) == "Color3" then self.Theme[key] = value end
    end
    self:_applyTheme()
    return self
end

function Spectra:ToggleUI(force)
    if self.Destroyed then return end
    self.Open = force == nil and not self.Open or force == true
    if self.Open then
        self.Window.Visible = true
        self.Window.BackgroundTransparency = 1
        tween(self.Window, {BackgroundTransparency = 0, Size = self.WindowSize}, 0.2)
    else
        tween(self.Window, {BackgroundTransparency = 1}, 0.16)
        task.delay(0.18, function() if not self.Open and self.Window and self.Window.Parent then self.Window.Visible = false; self.Window.BackgroundTransparency = 0 end end)
    end
    if self.ActivationIcon then tween(self.ActivationIcon, {Rotation = self.Open and 45 or 0}, 0.16) end
end

function Spectra:SelectTab(name)
    local selected = self.Tabs[name]
    if not selected then return false end
    self.ActiveTab = name
    for tabName, tab in pairs(self.Tabs) do
        local active = tabName == name
        tab.Page.Visible = active
        tween(tab.Button, {BackgroundColor3 = active and self.Theme.Element or self.Theme.Sidebar})
        tab.Button.TabText.TextColor3 = active and self.Theme.Text or self.Theme.Muted
        tab.Button.TabIcon.TextColor3 = active and self.Theme.Text or self.Theme.Muted
    end
    return true
end

function Spectra:CreateTab(name, iconName)
    assert(type(name) == "string", "CreateTab expects a name")
    if self.Tabs[name] then return self.Tabs[name] end
    local button = create("TextButton", {Size=UDim2.new(1,0,0,38), BackgroundColor3=self.Theme.Sidebar, Text="", AutoButtonColor=false}, self.Navigation)
    corner(button, 7)
    local icon = makeIcon(button, iconName or "Home", 16, UDim2.fromOffset(11,10), self.Theme.Muted); icon.Name="TabIcon"
    local label = textLabel(button, name, 11, self.Theme.Muted, Enum.Font.GothamMedium)
    label.Name="TabText"; label.Position=UDim2.fromOffset(38,0); label.Size=UDim2.new(1,-44,1,0)
    local page = create("ScrollingFrame", {Name=name, Size=UDim2.fromScale(1,1), BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=2, ScrollBarImageColor3=self.Theme.Muted, CanvasSize=UDim2.new(), Visible=false}, self.Content)
    create("UIPadding", {PaddingTop=UDim.new(0,18),PaddingBottom=UDim.new(0,18),PaddingLeft=UDim.new(0,18),PaddingRight=UDim.new(0,18)}, page)
    local layout = create("UIListLayout", {Padding=UDim.new(0,11),SortOrder=Enum.SortOrder.LayoutOrder}, page)
    self:_track(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() page.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+38) end))
    self:_track(button.Activated:Connect(function() self:SelectTab(name) end))
    self:_track(button.MouseEnter:Connect(function() if self.ActiveTab~=name then tween(button,{BackgroundColor3=self.Theme.Surface}) end end))
    self:_track(button.MouseLeave:Connect(function() if self.ActiveTab~=name then tween(button,{BackgroundColor3=self.Theme.Sidebar}) end end))
    local tab = {Library=self,Name=name,Page=page,Button=button,Layout=layout}
    self.Tabs[name]=tab
    if not self.ActiveTab then self:SelectTab(name) end
    return tab
end

local function makeContainer(library, parent, title, description, options)
    options = options or {}
    local frame = create("Frame", {Size=UDim2.new(options.Width or 1, options.WidthOffset or 0, 0, 65), BackgroundColor3=library.Theme.Surface, BorderSizePixel=0}, parent)
    corner(frame, 9); stroke(frame, library.Theme.Border)
    local heading = textLabel(frame,title or "Group",12,library.Theme.Text,Enum.Font.GothamBold)
    heading.Position=UDim2.fromOffset(12,8); heading.Size=UDim2.new(1,-24,0,20)
    local top=34
    if description and description~="" then
        local desc=textLabel(frame,description,10,library.Theme.Muted); desc.Position=UDim2.fromOffset(12,27); desc.Size=UDim2.new(1,-24,0,16); top=48
    end
    local holder=create("Frame",{Position=UDim2.fromOffset(10,top),Size=UDim2.new(1,-20,0,0),BackgroundTransparency=1},frame)
    local layout=create("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},holder)
    local function update()
        holder.Size=UDim2.new(1,-20,0,layout.AbsoluteContentSize.Y)
        frame.Size=UDim2.new(options.Width or 1,options.WidthOffset or 0,0,top+layout.AbsoluteContentSize.Y+11)
    end
    library:_track(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update))
    local group={Library=library,Container=frame,Holder=holder,Layout=layout,Title=heading}
    function group:SetTitle(value) heading.Text=tostring(value) end
    function group:Destroy() frame:Destroy() end
    return group
end

function Spectra:CreateSection(parent, title, description)
    assert(parent and parent.Page, "CreateSection expects a tab")
    local section=makeContainer(self,parent.Page,title,description)
    section.Page=parent.Page
    return section
end
function Spectra:CreateSectionForTab(tab,title,description) return self:CreateSection(tab,title,description) end
function Spectra:CreateGroupbox(parent,title,description,options)
    local target=parent and (parent.Page or parent.Holder or parent)
    return makeContainer(self,target,title,description,options)
end
function Spectra:CreateTabbox(parent)
    local frame=create("Frame",{Size=UDim2.new(1,0,0,190),BackgroundColor3=self.Theme.Surface,BorderSizePixel=0},parent.Page or parent.Holder or parent)
    corner(frame,8); stroke(frame,self.Theme.Border)
    local nav=create("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=self.Theme.Sidebar,BorderSizePixel=0},frame)
    local content=create("Frame",{Position=UDim2.fromOffset(0,34),Size=UDim2.new(1,0,1,-34),BackgroundTransparency=1},frame)
    local tabs={Library=self,Frame=frame,Navigation=nav,Content=content,Items={}}
    function tabs:AddTab(name)
        local button=create("TextButton",{Size=UDim2.fromOffset(100,30),BackgroundTransparency=1,Text=name,TextColor3=self.Library.Theme.Muted,TextSize=10,Font=Enum.Font.GothamMedium},self.Navigation)
        local page=create("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,Visible=false,CanvasSize=UDim2.new()},self.Content)
        local holder=create("Frame",{Size=UDim2.new(1,-16,0,0),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1},page)
        local layout=create("UIListLayout",{Padding=UDim.new(0,6)},holder)
        self.Library:_track(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() holder.Size=UDim2.new(1,-16,0,layout.AbsoluteContentSize.Y); page.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+16) end))
        local item={Name=name,Page=page,Holder=holder,Layout=layout}
        function item:CreateGroupbox(title,desc,opts) return makeContainer(self.Library,self.Holder,title,desc,opts) end
        table.insert(self.Items,item)
        self.Library:_track(button.Activated:Connect(function()
            for _,entry in ipairs(self.Items) do entry.Page.Visible=entry==item end
            for _,child in ipairs(self.Navigation:GetChildren()) do if child:IsA("TextButton") then child.TextColor3=child==button and self.Library.Theme.Text or self.Library.Theme.Muted end end
        end))
        if #self.Items==1 then button:Activate() end
        return item
    end
    return tabs
end

local function resolveHolder(owner)
    return owner.Holder or owner.Container or owner
end

function Spectra:_newRow(owner,height)
    local holder=resolveHolder(owner)
    local row=create("Frame",{Size=UDim2.new(1,0,0,height or 32),BackgroundTransparency=1},holder)
    return row
end

function Spectra:_makeControl(owner,id,kind,default,callback)
    local control={Library=self,Id=id,Type=kind,Value=default,Callback=callback,Connections={}}
    function control:Get() return self.Value end
    function control:Set(value,quiet)
        self.Value=value
        if self._render then self._render() end
        if not quiet then safeCallback(self.Callback,self.Value) end
        return self
    end
    function control:OnChanged(callback) self.Callback=callback; return self end
    function control:Destroy() for _,c in ipairs(self.Connections) do c:Disconnect() end; if self.Frame then self.Frame:Destroy() end; self.Library.Registry[self.Id]=nil end
    if id then self.RegistryId=id; self:_register(id,kind,control) end
    return control
end

function Spectra:CreateLabel(text,description,iconName,owner)
    local row=self:_newRow(owner or self,description and 39 or 24)
    if iconName then makeIcon(row,iconName,14,UDim2.fromOffset(0,4),self.Theme.Muted) end
    local label=textLabel(row,text,10,self.Theme.Muted); label.Position=UDim2.fromOffset(iconName and 22 or 0,0); label.Size=UDim2.new(1,-22,0,description and 20 or 24)
    local desc
    if description then desc=textLabel(row,description,9,self.Theme.Muted); desc.Position=UDim2.fromOffset(iconName and 22 or 0,19); desc.Size=UDim2.new(1,-22,0,17) end
    local control={Frame=row,Label=label,Description=desc}
    function control:Set(value) label.Text=tostring(value); return self end
    function control:SetDescription(value) if desc then desc.Text=tostring(value) end; return self end
    function control:Destroy() row:Destroy() end
    return control
end

function Spectra:CreateDivider(parent,title,description)
    local target=parent or self
    local row=self:_newRow(target, title and 30 or 12)
    create("Frame",{Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(1,0,0,1),BackgroundColor3=self.Theme.Border,BorderSizePixel=0},row)
    if title then
        local label=textLabel(row,title,9,self.Theme.Muted,Enum.Font.GothamBold); label.BackgroundColor3=self.Theme.Surface; label.BackgroundTransparency=0; label.Size=UDim2.fromOffset(150,16); label.Position=UDim2.fromOffset(7,0)
        if description then label.Text=title.."  ·  "..description end
    end
    return {Frame=row,Destroy=function() row:Destroy() end}
end

function Spectra:CreateButton(text,callback,iconName,owner)
    if type(callback)=="table" then local options=callback; callback=options.Callback; iconName=options.Icon; owner=options.Parent or owner end
    local row=self:_newRow(owner or self,33)
    local button=create("TextButton",{Size=UDim2.fromScale(1,1),BackgroundColor3=self.Theme.Element,Text="",AutoButtonColor=false},row)
    corner(button,6); stroke(button,self.Theme.Border)
    makeIcon(button,iconName or "Chevron",14,UDim2.fromOffset(10,9),self.Theme.Muted)
    local label=textLabel(button,text,10,self.Theme.Text,Enum.Font.GothamMedium); label.Position=UDim2.fromOffset(32,0); label.Size=UDim2.new(1,-42,1,0)
    self:_track(button.MouseEnter:Connect(function() tween(button,{BackgroundColor3=self.Theme.Hover}) end))
    self:_track(button.MouseLeave:Connect(function() tween(button,{BackgroundColor3=self.Theme.Element}) end))
    self:_track(button.Activated:Connect(function() safeCallback(callback) end))
    return {Frame=row,Button=button,SetText=function(_,v) label.Text=tostring(v) end,Destroy=function() row:Destroy() end}
end

function Spectra:CreateButtonRow(items,owner)
    local row=self:_newRow(owner or self,33)
    local grid=create("UIGridLayout",{CellSize=UDim2.new(1/math.max(#items,1),-5,1,0),CellPadding=UDim2.fromOffset(7,0),SortOrder=Enum.SortOrder.LayoutOrder},row)
    local controls={}
    for _,item in ipairs(items) do
        local button=create("TextButton",{BackgroundColor3=self.Theme.Element,Text=tostring(item.Name or "Button"),TextColor3=self.Theme.Text,TextSize=10,Font=Enum.Font.GothamMedium,AutoButtonColor=false},row)
        corner(button,6); stroke(button,self.Theme.Border)
        self:_track(button.Activated:Connect(function() safeCallback(item.Callback) end))
        table.insert(controls,button)
    end
    return controls
end

function Spectra:CreateToggle(text,default,callback,id,owner)
    if type(default)=="table" then local o=default; default=o.Default; callback=o.Callback; id=o.Id or o.Flag; owner=o.Parent or owner end
    local row=self:_newRow(owner or self,31)
    local label=textLabel(row,text,10,self.Theme.Text,Enum.Font.GothamMedium); label.Size=UDim2.new(1,-55,1,0)
    local switch=create("TextButton",{Size=UDim2.fromOffset(34,18),Position=UDim2.new(1,-34,0.5,-9),BackgroundColor3=self.Theme.Element,Text="",AutoButtonColor=false},row); corner(switch,20)
    local dot=create("Frame",{Size=UDim2.fromOffset(12,12),Position=UDim2.fromOffset(3,3),BackgroundColor3=self.Theme.Muted,BorderSizePixel=0},switch); corner(dot,20)
    local control=self:_makeControl(owner or self,id,"Toggle",default==true,callback); control.Frame=row; control.Button=switch
    control._render=function()
        tween(dot,{Position=control.Value and UDim2.new(1,-15,0,3) or UDim2.fromOffset(3,3),BackgroundColor3=control.Value and self.Theme.Text or self.Theme.Muted})
        tween(switch,{BackgroundColor3=control.Value and Color3.fromRGB(65,65,65) or self.Theme.Element})
    end
    self:_track(switch.Activated:Connect(function() control:Set(not control.Value) end))
    control._render()
    function control:AddColorPicker(colorId,options) options=options or {}; return self.Library:CreateColorPicker(options.Title or colorId,options.Default,colorId,options.Callback,owner,options) end
    function control:AddKeyPicker(keyId,options) options=options or {}; return self.Library:CreateKeybind(options.Title or keyId,options.Default,options.Mode,options.Callback,keyId,owner) end
    return control
end

function Spectra:CreateCheckbox(text,default,callback,id,owner)
    local control=self:CreateToggle(text,default,callback,id,owner)
    control.Type="Checkbox"
    control.Button.Size=UDim2.fromOffset(17,17); control.Button.Position=UDim2.new(1,-19,0.5,-8)
    control.Dot=control.Button:FindFirstChildOfClass("Frame")
    control._render=function() control.Button.BackgroundColor3=control.Value and self.Theme.Accent or self.Theme.Element; control.Dot.BackgroundColor3=control.Value and self.Theme.Background or self.Theme.Muted; control.Dot.Size=control.Value and UDim2.fromOffset(9,9) or UDim2.fromOffset(5,5); control.Dot.Position=UDim2.fromScale(0.5,0.5); control.Dot.AnchorPoint=Vector2.new(0.5,0.5) end
    control._render(); return control
end

function Spectra:CreateInput(text,options,callback,id,owner)
    if type(options)~="table" then options={Default=options,Callback=callback,Id=id,Parent=owner} end
    local row=self:_newRow(options.Parent or owner or self,49)
    local label=textLabel(row,text,10,self.Theme.Text); label.Size=UDim2.new(1,0,0,17)
    local box=create("TextBox",{Position=UDim2.fromOffset(0,19),Size=UDim2.new(1,0,0,29),BackgroundColor3=self.Theme.Element,Text=tostring(options.Default or ""),PlaceholderText=options.Placeholder or "Enter value...",PlaceholderColor3=self.Theme.Muted,TextColor3=self.Theme.Text,TextSize=10,Font=Enum.Font.Gotham,ClearTextOnFocus=false},row)
    corner(box,6); stroke(box,self.Theme.Border); box.TextXAlignment=Enum.TextXAlignment.Left
    create("UIPadding",{PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,8)},box)
    local control=self:_makeControl(options.Parent or owner or self,options.Id or options.Flag,"Input",box.Text,options.Callback or callback); control.Frame=row; control.TextBox=box
    control._render=function() box.Text=tostring(control.Value or "") end
    self:_track(box.FocusLost:Connect(function() local value=box.Text; if options.NumbersOnly then value=tonumber(value) or control.Value end; control:Set(value) end))
    function control:Focus() box:CaptureFocus() end
    return control
end

function Spectra:CreateSlider(text,options,callback,id,owner)
    if type(options)~="table" then options={Min=0,Max=100,Default=options,Callback=callback,Id=id,Parent=owner} end
    local min,max=tonumber(options.Min or options.MinValue) or 0,tonumber(options.Max or options.MaxValue) or 100
    if max<min then min,max=max,min end
    local step=tonumber(options.Increment or options.Step) or 1
    local initial=math.clamp(tonumber(options.Default) or min,min,max)
    local row=self:_newRow(options.Parent or owner or self,48)
    local label=textLabel(row,text,10,self.Theme.Text); label.Size=UDim2.new(1,-55,0,18)
    local valueLabel=textLabel(row,tostring(initial),10,self.Theme.Muted); valueLabel.TextXAlignment=Enum.TextXAlignment.Right; valueLabel.Position=UDim2.new(1,-50,0,0); valueLabel.Size=UDim2.fromOffset(50,18)
    local bar=create("TextButton",{Position=UDim2.fromOffset(0,27),Size=UDim2.new(1,0,0,7),BackgroundColor3=self.Theme.Element,Text="",AutoButtonColor=false},row); corner(bar,8)
    local fill=create("Frame",{Size=UDim2.new((initial-min)/math.max(max-min,0.0001),0,1,0),BackgroundColor3=self.Theme.Accent,BorderSizePixel=0},bar); corner(fill,8)
    local control=self:_makeControl(options.Parent or owner or self,options.Id or options.Flag,"Slider",initial,options.Callback or callback); control.Frame=row; control.Bar=bar
    control._render=function()
        local value=math.clamp(tonumber(control.Value) or min,min,max); local snapped=min+math.floor(((value-min)/step)+0.5)*step; snapped=math.clamp(snapped,min,max); control.Value=snapped
        fill.Size=UDim2.new((snapped-min)/math.max(max-min,0.0001),0,1,0); valueLabel.Text=tostring(snapped)
    end
    local dragging=false
    local function setFromX(x) local alpha=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1); control:Set(min+(max-min)*alpha) end
    self:_track(bar.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; setFromX(input.Position.X) end end))
    self:_track(UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then setFromX(input.Position.X) end end))
    self:_track(UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end))
    control._render(); return control
end

function Spectra:CreateDropdown(text,options,callback,id,owner)
    options=options or {}; local choices=options.Options or options.Values or {}
    local row=self:_newRow(options.Parent or owner or self,options.Multi and 62 or 56)
    local label=textLabel(row,text,10,self.Theme.Text); label.Size=UDim2.new(1,0,0,17)
    local button=create("TextButton",{Position=UDim2.fromOffset(0,20),Size=UDim2.new(1,0,0,32),BackgroundColor3=self.Theme.Element,Text="",AutoButtonColor=false},row); corner(button,6); stroke(button,self.Theme.Border)
    local display=textLabel(button,"Select...",10,self.Theme.Muted); display.Position=UDim2.fromOffset(9,0); display.Size=UDim2.new(1,-28,1,0)
    makeIcon(button,"Chevron",14,UDim2.new(1,-21,0.5,-7),self.Theme.Muted)
    local popup=create("Frame",{Position=UDim2.new(0,0,1,4),Size=UDim2.new(1,0,0,0),BackgroundColor3=self.Theme.Surface,Visible=false,ZIndex=30,ClipsDescendants=true},button); corner(popup,6); stroke(popup,self.Theme.Border)
    local search
    if options.Searchable then search=create("TextBox",{Position=UDim2.fromOffset(6,6),Size=UDim2.new(1,-12,0,25),BackgroundColor3=self.Theme.Element,Text="",PlaceholderText="Search...",TextColor3=self.Theme.Text,PlaceholderColor3=self.Theme.Muted,TextSize=9,Font=Enum.Font.Gotham,ClearTextOnFocus=false,ZIndex=31},popup); corner(search,5) end
    local list=create("ScrollingFrame",{Position=UDim2.fromOffset(5,options.Searchable and 36 or 5),Size=UDim2.new(1,-10,1,-(options.Searchable and 41 or 10)),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(),ZIndex=31},popup)
    local layout=create("UIListLayout",{Padding=UDim.new(0,3)},list)
    local selected=options.Multi and (type(options.Default)=="table" and copyTable(options.Default) or {}) or options.Default
    local control=self:_makeControl(options.Parent or owner or self,options.Id or options.Flag,"Dropdown",selected,options.Callback or callback); control.Frame=row; control.Popup=popup
    local function updateDisplay()
        if options.Multi then local names={}; for _,v in ipairs(control.Value) do table.insert(names,tostring(v)) end; display.Text=#names>0 and table.concat(names,", ") or "Select..."
        else display.Text=control.Value~=nil and tostring(control.Value) or "Select..." end
        display.TextColor3=(control.Value~=nil and (not options.Multi or #control.Value>0)) and self.Theme.Text or self.Theme.Muted
    end
    local function choose(value)
        if options.Multi then
            local found=false; for i,v in ipairs(control.Value) do if v==value then table.remove(control.Value,i); found=true; break end end
            if not found then table.insert(control.Value,value) end
            safeCallback(control.Callback,copyTable(control.Value))
        else control.Value=value; safeCallback(control.Callback,value); popup.Visible=false end
        updateDisplay()
    end
    local optionButtons={}
    local function rebuild(filter)
        for _,child in ipairs(list:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        local count=0
        for _,entry in ipairs(choices) do
            local name=type(entry)=="table" and (entry.Name or entry.Text or entry.Value) or entry
            if not filter or tostring(name):lower():find(filter:lower(),1,true) then
                count=count+1
                local b=create("TextButton",{Size=UDim2.new(1,-2,0,27),BackgroundColor3=self.Theme.Element,Text=tostring(name),TextColor3=self.Theme.Text,TextSize=9,Font=Enum.Font.Gotham,AutoButtonColor=false,LayoutOrder=count,ZIndex=32},list); corner(b,4)
                self:_track(b.Activated:Connect(function() choose(type(entry)=="table" and (entry.Value or entry.Name) or entry) end))
            end
        end
        list.CanvasSize=UDim2.fromOffset(0,count*30)
        popup.Size=UDim2.new(1,0,0,math.min(count*30+(options.Searchable and 42 or 10),150))
    end
    rebuild()
    if search then self:_track(search:GetPropertyChangedSignal("Text"):Connect(function() rebuild(search.Text) end)) end
    self:_track(button.Activated:Connect(function() popup.Visible=not popup.Visible; if popup.Visible then rebuild(search and search.Text or nil) end end))
    control._render=updateDisplay
    function control:SetOptions(values) choices=values or {}; rebuild(search and search.Text or nil); return self end
    control:Set(selected,true); updateDisplay()
    return control
end

function Spectra:CreateColorPicker(text,default,id,callback,owner,options)
    if type(default)=="table" then options=default; default=options.Default; id=options.Id or options.Flag; callback=options.Callback; owner=options.Parent or owner end
    options=options or {}
    local row=self:_newRow(owner or self,34)
    local label=textLabel(row,text or "Color",10,self.Theme.Text); label.Size=UDim2.new(1,-48,1,0)
    local preview=create("TextButton",{Size=UDim2.fromOffset(36,22),Position=UDim2.new(1,-36,0.5,-11),BackgroundColor3=typeof(default)=="Color3" and default or Color3.new(1,1,1),Text="",AutoButtonColor=false},row); corner(preview,5); stroke(preview,self.Theme.Border)
    local popup=create("Frame",{Size=UDim2.fromOffset(230,208),Position=UDim2.new(1,-230,1,5),BackgroundColor3=self.Theme.Surface,Visible=false,ZIndex=40},row); corner(popup,8); stroke(popup,self.Theme.Border)
    local sv=create("TextButton",{Position=UDim2.fromOffset(10,10),Size=UDim2.fromOffset(150,115),BackgroundColor3=Color3.fromHSV(0,1,1),Text="",AutoButtonColor=false,ZIndex=41},popup); corner(sv,4)
    create("UIGradient",{Color=ColorSequence.new(Color3.new(1,1,1),Color3.new(1,1,1)),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})},sv)
    local black=create("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,ZIndex=42},sv); corner(black,4)
    create("UIGradient",{Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})},black)
    local cursor=create("Frame",{Size=UDim2.fromOffset(8,8),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=44},sv); corner(cursor,8); stroke(cursor,Color3.new(1,1,1))
    local hue=create("TextButton",{Position=UDim2.fromOffset(170,10),Size=UDim2.fromOffset(18,115),BackgroundColor3=Color3.new(1,1,1),Text="",AutoButtonColor=false,ZIndex=41},popup); corner(hue,4)
    create("UIGradient",{Rotation=90,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(.17,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(.34,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(.51,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(.68,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(.85,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))})},hue)
    local hex=create("TextBox",{Position=UDim2.fromOffset(10,137),Size=UDim2.fromOffset(88,25),BackgroundColor3=self.Theme.Element,Text="#FFFFFF",TextColor3=self.Theme.Text,TextSize=9,Font=Enum.Font.Gotham,ClearTextOnFocus=false,ZIndex=41},popup); corner(hex,4)
    local rgb=create("TextLabel",{Position=UDim2.fromOffset(105,137),Size=UDim2.fromOffset(115,25),BackgroundTransparency=1,Text="255, 255, 255",TextColor3=self.Theme.Muted,TextSize=9,Font=Enum.Font.Gotham,ZIndex=41},popup)
    local reset=create("TextButton",{Position=UDim2.fromOffset(10,172),Size=UDim2.fromOffset(65,25),BackgroundColor3=self.Theme.Element,Text="Reset",TextColor3=self.Theme.Text,TextSize=9,Font=Enum.Font.Gotham,ZIndex=41},popup); corner(reset,4)
    local close=create("TextButton",{Position=UDim2.fromOffset(82,172),Size=UDim2.fromOffset(138,25),BackgroundColor3=self.Theme.Element,Text="Close",TextColor3=self.Theme.Text,TextSize=9,Font=Enum.Font.Gotham,ZIndex=41},popup); corner(close,4)
    local initial=typeof(default)=="Color3" and default or Color3.new(1,1,1)
    local h,s,v=initial:ToHSV()
    local control=self:_makeControl(owner or self,id,"ColorPicker",initial,callback); control.Frame=row; control.Preview=preview
    local function render(notify)
        local color=Color3.fromHSV(h,s,v); control.Value=color; preview.BackgroundColor3=color; sv.BackgroundColor3=Color3.fromHSV(h,1,1); cursor.Position=UDim2.fromScale(s,1-v)
        local r,g,b=math.floor(color.R*255+.5),math.floor(color.G*255+.5),math.floor(color.B*255+.5)
        hex.Text=string.format("#%02X%02X%02X",r,g,b); rgb.Text=string.format("%d, %d, %d",r,g,b)
        if notify then safeCallback(control.Callback,color) end
    end
    local function setSV(input) local p=Vector2.new(math.clamp((input.Position.X-sv.AbsolutePosition.X)/sv.AbsoluteSize.X,0,1),math.clamp((input.Position.Y-sv.AbsolutePosition.Y)/sv.AbsoluteSize.Y,0,1)); s=p.X; v=1-p.Y; render(true) end
    local function setHue(input) h=math.clamp((input.Position.Y-hue.AbsolutePosition.Y)/hue.AbsoluteSize.Y,0,1); render(true) end
    local active
    self:_track(sv.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then active="sv"; setSV(i) end end))
    self:_track(hue.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then active="hue"; setHue(i) end end))
    self:_track(UserInputService.InputChanged:Connect(function(i) if active and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then if active=="sv" then setSV(i) else setHue(i) end end end))
    self:_track(UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then active=nil end end))
    self:_track(hex.FocusLost:Connect(function() local value=hex.Text:gsub("#",""); if #value==6 and value:match("^%x+$") then local n=tonumber(value,16); local color=Color3.fromRGB(math.floor(n/65536),math.floor(n/256)%256,n%256); h,s,v=color:ToHSV(); render(true) else render(false) end end))
    self:_track(reset.Activated:Connect(function() h,s,v=initial:ToHSV(); render(true) end))
    self:_track(close.Activated:Connect(function() popup.Visible=false end))
    self:_track(preview.Activated:Connect(function() popup.Visible=not popup.Visible end))
    control._render=function() h,s,v=control.Value:ToHSV(); render(false) end
    function control:Set(color,quiet) assert(typeof(color)=="Color3","ColorPicker:Set expects Color3"); h,s,v=color:ToHSV(); render(not quiet); return self end
    render(false)
    return control
end

function Spectra:CreateKeybind(text,default,mode,callback,id,owner)
    if type(default)=="table" then local o=default; default=o.Default; mode=o.Mode; callback=o.Callback; id=o.Id or o.Flag; owner=o.Parent or owner end
    local row=self:_newRow(owner or self,31)
    local label=textLabel(row,text or "Keybind",10,self.Theme.Text); label.Size=UDim2.new(1,-90,1,0)
    local button=create("TextButton",{Size=UDim2.fromOffset(82,23),Position=UDim2.new(1,-82,.5,-11),BackgroundColor3=self.Theme.Element,Text=typeof(default)=="EnumItem" and default.Name or tostring(default or "Unbound"),TextColor3=self.Theme.Muted,TextSize=9,Font=Enum.Font.Gotham},row); corner(button,5); stroke(button,self.Theme.Border)
    local control=self:_makeControl(owner or self,id,"Keybind",default,callback); control.Frame=row; control.Mode=mode or "Toggle"; control.Active=false; control.Listening=false
    self:_track(button.Activated:Connect(function() control.Listening=true; button.Text="Press key..." end))
    self:_track(UserInputService.InputBegan:Connect(function(input,processed)
        if control.Listening then
            if input.UserInputType==Enum.UserInputType.Keyboard then control.Value=input.KeyCode; button.Text=input.KeyCode.Name; control.Listening=false; safeCallback(control.Callback,input.KeyCode) end
            return
        end
        if processed or input.UserInputType~=Enum.UserInputType.Keyboard or input.KeyCode~=control.Value then return end
        if control.Mode=="Hold" then control.Active=true; safeCallback(control.Callback,true) else control.Active=not control.Active; safeCallback(control.Callback,control.Active) end
    end))
    self:_track(UserInputService.InputEnded:Connect(function(input)
        if control.Mode=="Hold" and input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==control.Value and control.Active then control.Active=false; safeCallback(control.Callback,false) end
    end))
    function control:Set(value,quiet) self.Value=value; button.Text=typeof(value)=="EnumItem" and value.Name or tostring(value or "Unbound"); if not quiet then safeCallback(self.Callback,value) end; return self end
    return control
end

function Spectra:CreateImage(parent,asset,size)
    local image=create("ImageLabel",{Size=size or UDim2.new(1,0,0,100),BackgroundTransparency=1,Image=tostring(asset),ScaleType=Enum.ScaleType.Fit},parent.Page or parent.Holder or parent)
    return {Object=image,Set=function(_,value) image.Image=tostring(value) end,Destroy=function() image:Destroy() end}
end

function Spectra:CreateViewport(parent,model,options)
    options=options or {}
    local viewport=create("ViewportFrame",{Size=options.Size or UDim2.new(1,0,0,180),BackgroundColor3=self.Theme.Element,BorderSizePixel=0},parent.Page or parent.Holder or parent)
    corner(viewport,7); stroke(viewport,self.Theme.Border)
    local world=create("WorldModel",{},viewport)
    local camera=create("Camera",{FieldOfView=options.FieldOfView or 45},viewport); viewport.CurrentCamera=camera
    local current
    local function setModel(value)
        if current then current:Destroy() end
        current=nil
        if not value then return end
        current=value:Clone(); current.Parent=world
        local cf,size=current:GetBoundingBox(); local radius=math.max(size.X,size.Y,size.Z)
        camera.CFrame=CFrame.new(cf.Position+Vector3.new(0,0,radius*2.2),cf.Position)
    end
    setModel(model)
    local dragging,lastX=false,0
    self:_track(viewport.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; lastX=input.Position.X end end))
    self:_track(viewport.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end))
    self:_track(viewport.InputChanged:Connect(function(input) if dragging and input.UserInputType==Enum.UserInputType.MouseMovement and current then local delta=input.Position.X-lastX; lastX=input.Position.X; current:PivotTo(current:GetPivot()*CFrame.Angles(0,math.rad(delta*.6),0)) end end))
    return {Frame=viewport,Camera=camera,SetModel=setModel,SetZoom=function(_,distance) if current then local cf=current:GetBoundingBox(); camera.CFrame=CFrame.new(cf.Position+Vector3.new(0,0,math.max(1,distance)),cf.Position) end end,Destroy=function() viewport:Destroy() end}
end

function Spectra:Notify(title,message,duration,kind)
    kind=kind or "Information"
    local colors={Success=self.Theme.Success,Error=self.Theme.Error,Warning=self.Theme.Warning,Information=self.Theme.Accent}
    local frame=create("Frame",{Size=UDim2.fromOffset(isMobile() and 245 or 280,76),Position=UDim2.new(1,310,1,-20-((#self.Notifications)*84)),AnchorPoint=Vector2.new(1,1),BackgroundColor3=self.Theme.Surface,BorderSizePixel=0,ZIndex=100},self.Gui)
    corner(frame,8); stroke(frame,self.Theme.Border)
    create("Frame",{Size=UDim2.new(0,3,1,-16),Position=UDim2.fromOffset(0,8),BackgroundColor3=colors[kind] or colors.Information,BorderSizePixel=0,ZIndex=101},frame)
    local heading=textLabel(frame,title,11,self.Theme.Text,Enum.Font.GothamBold); heading.Position=UDim2.fromOffset(13,9); heading.Size=UDim2.new(1,-25,0,19); heading.ZIndex=101
    local desc=textLabel(frame,message,9,self.Theme.Muted); desc.Position=UDim2.fromOffset(13,31); desc.Size=UDim2.new(1,-25,0,34); desc.TextWrapped=true; desc.ZIndex=101
    table.insert(self.Notifications,frame)
    tween(frame,{Position=UDim2.new(1,-16,1,-20-((#self.Notifications-1)*84))},.2)
    task.delay(duration or 3,function()
        if frame.Parent then tween(frame,{Position=frame.Position+UDim2.fromOffset(300,0)},.18); task.delay(.2,function() if frame.Parent then frame:Destroy() end end) end
        for i,v in ipairs(self.Notifications) do if v==frame then table.remove(self.Notifications,i); break end end
    end)
    return frame
end

function Spectra:CreateOverlay(options)
    options=options or {}
    local frame=create("Frame",{Size=options.Size or UDim2.fromOffset(180,70),Position=options.Position or UDim2.fromOffset(30,100),BackgroundColor3=self.Theme.Surface,BorderSizePixel=0},self.Gui)
    corner(frame,8); stroke(frame,self.Theme.Border)
    local label=textLabel(frame,options.Title or "Overlay",11,self.Theme.Text,Enum.Font.GothamBold); label.Position=UDim2.fromOffset(10,6); label.Size=UDim2.new(1,-20,0,20)
    local desc=textLabel(frame,options.Text or "",10,self.Theme.Muted); desc.Position=UDim2.fromOffset(10,27); desc.Size=UDim2.new(1,-20,0,32); desc.TextWrapped=true
    bindDrag(self,frame,frame)
    return {Frame=frame,SetText=function(_,v) desc.Text=tostring(v) end,SetTitle=function(_,v) label.Text=tostring(v) end,Show=function() frame.Visible=true end,Hide=function() frame.Visible=false end,Destroy=function() frame:Destroy() end}
end

function Spectra:CreateKeybindList()
    local overlay=self:CreateOverlay({Title="Keybinds",Text="No active keybinds",Size=UDim2.fromOffset(190,120),Position=UDim2.fromOffset(25,150)})
    local body=overlay.Frame:FindFirstChildWhichIsA("TextLabel")
    local function update()
        local lines={}
        for id,entry in pairs(self.Registry) do local o=entry.Object; if entry.Type=="Keybind" and o.Value and o.Value~=Enum.KeyCode.Unknown then table.insert(lines,tostring(id).."  ·  "..(typeof(o.Value)=="EnumItem" and o.Value.Name or tostring(o.Value))..(o.Active and "  [ACTIVE]" or "")) end end
        body.Text=#lines>0 and table.concat(lines,"\n") or "No registered keybinds"
    end
    update()
    return overlay
end

local SaveManager={}
SaveManager.__index=SaveManager
function SaveManager.new(library,folder)
    return setmetatable({Library=library,Folder=folder or "Spectra",CurrentConfig=nil,Memory={},FileSupport=type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function"},SaveManager)
end
function SaveManager:_path(name) return self.Folder.."/"..name..".json" end
function SaveManager:_encode()
    local data={Version=Spectra.Version,Values={}}
    for id,entry in pairs(self.Library.Registry) do
        local value=entry.Object.Value
        if typeof(value)=="Color3" then value={__type="Color3",R=value.R,G=value.G,B=value.B}
        elseif typeof(value)=="EnumItem" then value={__type="EnumItem",Enum=(tostring(value.Enum):match("Enum%.(.+)") or tostring(value.Enum)),Name=value.Name}
        elseif type(value)=="table" then value=copyTable(value) end
        if type(value)=="string" or type(value)=="number" or type(value)=="boolean" or type(value)=="table" then data.Values[id]=value end
    end
    return HttpService:JSONEncode(data)
end
function SaveManager:Save(name)
    assert(type(name)=="string" and name~="","Config name is required")
    local encoded=self:_encode(); self.Memory[name]=encoded
    if self.FileSupport then
        pcall(function() if type(makefolder)=="function" and type(isfolder)=="function" and not isfolder(self.Folder) then makefolder(self.Folder) end; writefile(self:_path(name),encoded) end)
    end
    self.CurrentConfig=name; return true
end
function SaveManager:Load(name)
    local raw=self.Memory[name]
    if self.FileSupport then pcall(function() local path=self:_path(name); if isfile(path) then raw=readfile(path) end end) end
    if not raw then return false,"Configuration not found" end
    local ok,data=pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(data)~="table" or type(data.Values)~="table" then return false,"Invalid configuration JSON" end
    for id,value in pairs(data.Values) do
        local entry=self.Library.Registry[id]
        if entry then
            if type(value)=="table" and value.__type=="Color3" then value=Color3.new(value.R,value.G,value.B)
            elseif type(value)=="table" and value.__type=="EnumItem" and Enum[value.Enum] then local success,result=pcall(function() return Enum[value.Enum][value.Name] end); if success then value=result end end
            pcall(function() entry.Object:Set(value) end)
        end
    end
    self.CurrentConfig=name; return true
end
function SaveManager:Delete(name)
    self.Memory[name]=nil
    if self.FileSupport and type(delfile)=="function" then pcall(function() local path=self:_path(name); if isfile(path) then delfile(path) end end) end
    if self.CurrentConfig==name then self.CurrentConfig=nil end
    return true
end
function SaveManager:Rename(oldName,newName)
    local raw=self.Memory[oldName]
    if self.FileSupport then pcall(function() if isfile(self:_path(oldName)) then raw=readfile(self:_path(oldName)) end end) end
    if not raw then return false,"Configuration not found" end
    self.Memory[newName]=raw; self:SaveRaw(newName,raw); self:Delete(oldName); return true
end
function SaveManager:SaveRaw(name,raw)
    self.Memory[name]=raw
    if self.FileSupport then pcall(function() if type(makefolder)=="function" and type(isfolder)=="function" and not isfolder(self.Folder) then makefolder(self.Folder) end; writefile(self:_path(name),raw) end) end
end
function SaveManager:Export(name) return self.Memory[name] or self:_encode() end
function SaveManager:Import(name,json)
    local ok,data=pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data)~="table" or type(data.Values)~="table" then return false,"Invalid JSON configuration" end
    self:SaveRaw(name,json); return true
end
function SaveManager:List()
    local names={}; for name in pairs(self.Memory) do names[name]=true end
    if self.FileSupport and type(listfiles)=="function" then pcall(function() for _,path in ipairs(listfiles(self.Folder)) do local name=path:match("([^/\\]+)%.json$"); if name then names[name]=true end end end) end
    local result={}; for name in pairs(names) do table.insert(result,name) end; table.sort(result); return result
end
function SaveManager:CreateUI(parent)
    local group=self.Library:CreateGroupbox(parent,"Configuration Manager","Save and load local settings")
    local nameBox=self.Library:CreateInput("Configuration name",{Default="default",Placeholder="config name"},nil,"__config_name",group)
    self.Library:CreateButton("Save configuration",function() local ok,err=pcall(function() self:Save(nameBox:Get()) end); self.Library:Notify("Save Manager",ok and "Configuration saved." or tostring(err),3,ok and "Success" or "Error") end,"Save",group)
    self.Library:CreateButton("Load configuration",function() local ok,err=self:Load(nameBox:Get()); self.Library:Notify("Save Manager",ok and "Configuration loaded." or tostring(err),3,ok and "Success" or "Error") end,"Folder",group)
    self.Library:CreateButton("Delete configuration",function() self:Delete(nameBox:Get()); self.Library:Notify("Save Manager","Configuration deleted.",3,"Information") end,"Trash",group)
    self.Library:CreateButton("Refresh config list",function() self.Library:Notify("Configurations",table.concat(self:List(),", "),4) end,"Refresh",group)
    return group
end

function Spectra:CreateThemeManager(parent)
    local manager={Library=self,Saved={}}
    function manager:Save(name) self.Saved[name]=copyTable(self.Library.Theme); return true end
    function manager:Load(name) local theme=self.Saved[name]; if not theme then return false end; self.Library:SetThemeTable(theme); return true end
    function manager:Delete(name) self.Saved[name]=nil end
    function manager:Set(key,value) self.Library:SetTheme(key,value) end
    if parent then
        local group=self:CreateGroupbox(parent,"Theme Manager","Customize the Spectra appearance")
        for key,value in pairs(self.Theme) do if typeof(value)=="Color3" then self:CreateColorPicker(key,value,"__theme_"..key,function(color) manager:Set(key,color) end,group) end end
    end
    return manager
end

function Spectra:CreateWindow(options)
    options=options or {}
    local player=Players.LocalPlayer
    assert(player,"Spectra must run on the client")
    local playerGui=player:WaitForChild("PlayerGui")
    local old=playerGui:FindFirstChild(options.GuiName or "SpectraUI")
    if old then old:Destroy() end
    local library=setmetatable({},Spectra)
    library.Theme=copyTable(DEFAULT_THEME); library.Tabs={}; library.Connections={}; library.Registry={}; library.ThemeObjects={}; library.TextObjects={}; library.Notifications={}
    library.Open=true; library.Destroyed=false; library.ActiveTab=nil; library.WindowSize=options.Size or UDim2.fromOffset(820,490)
    library.Gui=create("ScreenGui",{Name=options.GuiName or "SpectraUI",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},playerGui)
    local window=create("Frame",{Size=library.WindowSize,Position=UDim2.fromScale(.5,.5),AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=library.Theme.Background,BorderSizePixel=0,ClipsDescendants=false},library.Gui)
    corner(window,11); stroke(window,library.Theme.Border); library.Window=window
    local topbar=create("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=library.Theme.Sidebar,BorderSizePixel=0},window); library.Topbar=topbar
    create("ImageLabel",{Size=UDim2.fromOffset(35,35),Position=UDim2.fromOffset(15,12),BackgroundTransparency=1,Image=options.Logo or "rbxassetid://96535159972301",ScaleType=Enum.ScaleType.Fit},topbar)
    local title=textLabel(topbar,options.Title or "Spectra.wtf",14,library.Theme.Text,Enum.Font.GothamBold); title.Position=UDim2.fromOffset(59,8); title.Size=UDim2.fromOffset(260,22)
    local subtitle=textLabel(topbar,options.Subtitle or game.Name,9,library.Theme.Muted); subtitle.Position=UDim2.fromOffset(60,30); subtitle.Size=UDim2.fromOffset(300,17)
    local close=create("TextButton",{Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-42,0,15),BackgroundColor3=library.Theme.Surface,Text="×",TextColor3=library.Theme.Muted,TextSize=20,Font=Enum.Font.Gotham,AutoButtonColor=false},topbar); corner(close,6)
    library:_track(close.Activated:Connect(function() library:ToggleUI() end))
    local sidebar=create("Frame",{Position=UDim2.fromOffset(0,60),Size=UDim2.new(0,178,1,-60),BackgroundColor3=library.Theme.Sidebar,BorderSizePixel=0},window); library.Sidebar=sidebar
    create("Frame",{Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=library.Theme.Border,BorderSizePixel=0},sidebar)
    local navTitle=textLabel(sidebar,"WORKSPACE",9,library.Theme.Muted,Enum.Font.GothamBold); navTitle.Position=UDim2.fromOffset(16,16); navTitle.Size=UDim2.fromOffset(140,20)
    library.Navigation=create("ScrollingFrame",{Position=UDim2.fromOffset(9,43),Size=UDim2.new(1,-18,1,-85),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new()},sidebar)
    local navLayout=create("UIListLayout",{Padding=UDim.new(0,5)},library.Navigation)
    library:_track(navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() library.Navigation.CanvasSize=UDim2.fromOffset(0,navLayout.AbsoluteContentSize.Y+5) end))
    local footer=textLabel(sidebar,"SPECTRA.WTF  ·  "..Spectra.Version,8,library.Theme.Muted); footer.Position=UDim2.new(0,16,1,-29); footer.Size=UDim2.new(1,-24,0,16)
    library.Content=create("Frame",{Position=UDim2.fromOffset(178,60),Size=UDim2.new(1,-178,1,-60),BackgroundTransparency=1,ClipsDescendants=true},window)
    library.ActivationButton=create("ImageButton",{Size=UDim2.fromOffset(isMobile() and 52 or 46,isMobile() and 52 or 46),Position=UDim2.new(0,22,.5,0),AnchorPoint=Vector2.new(0,.5),BackgroundColor3=library.Theme.Surface,Image=options.Logo or "rbxassetid://96535159972301",ScaleType=Enum.ScaleType.Fit,AutoButtonColor=false,ZIndex=10},library.Gui)
    corner(library.ActivationButton,13); stroke(library.ActivationButton,library.Theme.Border)
    library.ActivationIcon=create("Frame",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1)},library.ActivationButton)
    library:_track(library.ActivationButton.Activated:Connect(function() library:ToggleUI() end))
    bindDrag(library,topbar,window); bindDrag(library,library.ActivationButton,library.ActivationButton)
    library:_track(UserInputService.InputBegan:Connect(function(input,processed)
        if processed or UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode==(options.ToggleKey or Enum.KeyCode.RightControl) then library:ToggleUI() end
    end))
    if isMobile() then
        local camera=workspace.CurrentCamera
        local function fit()
            if not camera or not window.Parent then return end
            local viewport=camera.ViewportSize
            if viewport.X<700 then window.Size=UDim2.new(1,-24,1,-100); window.Position=UDim2.fromScale(.5,.5); library.Sidebar.Size=UDim2.new(0,125,1,-60); library.Content.Position=UDim2.fromOffset(125,60); library.Content.Size=UDim2.new(1,-125,1,-60) end
        end
        fit(); library:_track(camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit))
    end
    library.SaveManager=SaveManager.new(library,options.ConfigFolder)
    library:Notify("Spectra.wtf","Interface initialized successfully.",2.5,"Success")
    function library:CreateWindow() return self end
    function library:Destroy()
        if self.Destroyed then return end; self.Destroyed=true
        for _,connection in ipairs(self.Connections) do pcall(function() connection:Disconnect() end) end
        self.Connections={}
        if self.Gui then self.Gui:Destroy() end
        self.Registry={}; self.Tabs={}
    end
    return library
end

-- Legacy API aliases and section-scoped helpers.
function Spectra:CreateSectionMethods(section)
    local library=self
    local methods={
        CreateLabel=function(_,...) return library:CreateLabel(...,section) end,
        CreateButton=function(_,...) return library:CreateButton(...,section) end,
        CreateButtonRow=function(_,...) return library:CreateButtonRow(...,section) end,
        CreateToggle=function(_,...) return library:CreateToggle(...,section) end,
        CreateCheckbox=function(_,...) return library:CreateCheckbox(...,section) end,
        CreateInput=function(_,...) return library:CreateInput(...,section) end,
        CreateSlider=function(_,...) return library:CreateSlider(...,section) end,
        CreateDropdown=function(_,...) return library:CreateDropdown(...,section) end,
        CreateColorPicker=function(_,...) return library:CreateColorPicker(...,section) end,
        CreateKeybind=function(_,...) return library:CreateKeybind(...,section) end,
        CreateDivider=function(_,title,description) return library:CreateDivider(section,title,description) end,
        CreateGroupbox=function(_,title,description,options) return library:CreateGroupbox(section,title,description,options) end,
        CreateTabbox=function(_) return library:CreateTabbox(section) end,
        CreateImage=function(_,asset,size) return library:CreateImage(section,asset,size) end,
        CreateViewport=function(_,model,options) return library:CreateViewport(section,model,options) end,
    }
    for name,method in pairs(methods) do section[name]=method end
    -- Obsidian-style names are aliases, not separate implementations.
    section.AddLabel=section.CreateLabel; section.AddButton=section.CreateButton
    section.AddToggle=section.CreateToggle; section.AddCheckbox=section.CreateCheckbox
    section.AddInput=section.CreateInput; section.AddSlider=section.CreateSlider
    section.AddDropdown=section.CreateDropdown; section.AddColorPicker=section.CreateColorPicker
    section.AddKeyPicker=section.CreateKeybind; section.AddDivider=section.CreateDivider
    section.AddGroupbox=section.CreateGroupbox; section.AddTabbox=section.CreateTabbox
    section.AddImage=section.CreateImage; section.AddViewport=section.CreateViewport
    return section
end

local originalCreateSection=Spectra.CreateSection
Spectra.CreateSection=function(self,...)
    local section=originalCreateSection(self,...)
    return self:CreateSectionMethods(section)
end
local originalCreateGroupbox=Spectra.CreateGroupbox
Spectra.CreateGroupbox=function(self,...)
    local group=originalCreateGroupbox(self,...)
    return self:CreateSectionMethods(group)
end

function Spectra:CreateSaveManager(parent) return self.SaveManager:CreateUI(parent) end
function Spectra:CreateKeybindMenu() return self:CreateKeybindList() end
function Spectra:CreateWindowToggle() return self.ActivationButton end
function Spectra:CreateTabboxForTab(tab) return self:CreateTabbox(tab) end

return Spectra
