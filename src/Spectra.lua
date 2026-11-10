
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Spectra = {}
Spectra.__index = Spectra

Spectra.Version = "1.0"

local Theme = {
    Background = Color3.fromRGB(10, 10, 10),
    Sidebar = Color3.fromRGB(13, 13, 13),
    Surface = Color3.fromRGB(18, 18, 18),
    Element = Color3.fromRGB(25, 25, 25),
    Hover = Color3.fromRGB(34, 34, 34),
    Border = Color3.fromRGB(39, 39, 39),
    Text = Color3.fromRGB(245, 245, 245),
    Muted = Color3.fromRGB(125, 125, 125),
    Accent = Color3.fromRGB(255, 255, 255)
}

local Icons = {
    Home = "⌂",
    User = "◉",
    Eye = "◎",
    Palette = "◈",
    Settings = "⚙",
    Search = "⌕",
    Refresh = "↻",
    Close = "×",
    Check = "✓",
    Chevron = "›",
    Menu = "☰",
    Plus = "+",
    Minus = "−",
    Info = "ⓘ",
    Shield = "◇",
    Sparkles = "✧"
}

local function Create(class, properties, parent)
    local object = Instance.new(class)

    for key, value in pairs(properties) do
        object[key] = value
    end

    object.Parent = parent
    return object
end

local function Corner(parent, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

local function Stroke(parent, color, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = 1,
        Transparency = transparency or 0
    }, parent)
end

local function Animate(object, properties, duration)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.18,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()
    return tween
end

local function Label(parent, text, size, color, font)
    return Create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextSize = size or 12,
        TextColor3 = color or Theme.Text,
        Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
end

local function Icon(parent, name, size, position)
    return Create("TextLabel", {
        Size = UDim2.fromOffset(size or 18, size or 18),
        Position = position or UDim2.new(),
        BackgroundTransparency = 1,
        Text = Icons[name] or name or "•",
        TextColor3 = Theme.Muted,
        TextSize = size or 18,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
end

function Spectra:Notify(title, message, duration)
    local notification = Create("Frame", {
        Size = UDim2.fromOffset(270, 76),
        Position = UDim2.new(1, 290, 1, -100),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ZIndex = 20
    }, self.Gui)

    Corner(notification, 9)
    Stroke(notification)

    local heading = Label(
        notification,
        title,
        12,
        Theme.Text,
        Enum.Font.GothamBold
    )

    heading.Position = UDim2.fromOffset(13, 11)
    heading.Size = UDim2.new(1, -26, 0, 19)
    heading.ZIndex = 21

    local description = Label(
        notification,
        message,
        10,
        Theme.Muted
    )

    description.Position = UDim2.fromOffset(13, 34)
    description.Size = UDim2.new(1, -26, 0, 23)
    description.TextWrapped = true
    description.ZIndex = 21

    Animate(notification, {
        Position = UDim2.new(1, -16, 1, -20)
    })

    task.delay(duration or 3, function()
        if notification.Parent then
            Animate(notification, {
                Position = UDim2.new(1, 290, 1, -20)
            }, 0.2)

            task.wait(0.22)
            notification:Destroy()
        end
    end)

    return notification
end

function Spectra:ToggleUI()
    if self.Destroyed then
        return
    end

    self.Open = not self.Open

    if self.Open then
        self.Window.Visible = true
        self.Window.Size = UDim2.fromOffset(820, 490)
        self.Window.BackgroundTransparency = 1

        Animate(self.Window, {
            Size = self.WindowSize,
            BackgroundTransparency = 0
        }, 0.22)

        Animate(self.ActivationIcon, {
            Rotation = 45
        })
    else
        Animate(self.Window, {
            Size = UDim2.fromOffset(780, 450),
            BackgroundTransparency = 1
        }, 0.18)

        Animate(self.ActivationIcon, {
            Rotation = 0
        })

        task.delay(0.2, function()
            if not self.Open and self.Window.Parent then
                self.Window.Visible = false
                self.Window.Size = self.WindowSize
                self.Window.BackgroundTransparency = 0
            end
        end)
    end
end

function Spectra:Destroy()
    if self.Destroyed then
        return
    end

    self.Destroyed = true

    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end

    self.Gui:Destroy()
end

function Spectra:SetTheme(key, color)
    if Theme[key] then
        Theme[key] = color
    end
end

function Spectra:CreateTab(name, iconName)
    local tab = {
        Library = self,
        Name = name
    }

    local button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 37),
        BackgroundColor3 = Theme.Sidebar,
        Text = "",
        AutoButtonColor = false
    }, self.Navigation)

    Corner(button, 7)

    local icon = Icon(
        button,
        iconName,
        16,
        UDim2.fromOffset(11, 10)
    )

    icon.Name = "TabIcon"

    local text = Label(
        button,
        name,
        11,
        Theme.Muted,
        Enum.Font.GothamMedium
    )

    text.Name = "TabText"
    text.Position = UDim2.fromOffset(38, 0)
    text.Size = UDim2.new(1, -45, 1, 0)

    local page = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Muted,
        CanvasSize = UDim2.new(),
        Visible = false
    }, self.Content)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 21),
        PaddingBottom = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 21),
        PaddingRight = UDim.new(0, 21)
    }, page)

    local layout = Create("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(
            0,
            layout.AbsoluteContentSize.Y + 45
        )
    end)

    button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)

    button.MouseEnter:Connect(function()
        if self.ActiveTab ~= name then
            Animate(button, {
                BackgroundColor3 = Theme.Surface
            })
        end
    end)

    button.MouseLeave:Connect(function()
        if self.ActiveTab ~= name then
            Animate(button, {
                BackgroundColor3 = Theme.Sidebar
            })
        end
    end)

    tab.Page = page
    tab.Button = button
    tab.Layout = layout

    self.Tabs[name] = tab

    if not self.ActiveTab then
        self:SelectTab(name)
    end

    return tab
end

function Spectra:SelectTab(name)
    local selected = self.Tabs[name]

    if not selected then
        return
    end

    self.ActiveTab = name

    for tabName, tab in pairs(self.Tabs) do
        local active = tabName == name

        tab.Page.Visible = active

        Animate(tab.Button, {
            BackgroundColor3 = active and Theme.Element or Theme.Sidebar
        })

        tab.Button.TabText.TextColor3 = active and Theme.Text or Theme.Muted
        tab.Button.TabIcon.TextColor3 = active and Theme.Text or Theme.Muted
    end
end

function Spectra:CreateSection(parent, title, description)
    local section = {
        Library = self
    }

    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0
    }, parent.Page)

    Corner(container, 9)
    Stroke(container)

    local heading = Label(
        container,
        title,
        12,
        Theme.Text,
        Enum.Font.GothamBold
    )

    heading.Position = UDim2.fromOffset(13, 10)
    heading.Size = UDim2.new(1, -26, 0, 19)

    local top = 37

    if description then
        local desc = Label(
            container,
            description,
            10,
            Theme.Muted
        )

        desc.Position = UDim2.fromOffset(13, 29)
        desc.Size = UDim2.new(1, -26, 0, 17)

        top = 54
    end

    local holder = Create("Frame", {
        Position = UDim2.fromOffset(11, top),
        Size = UDim2.new(1, -22, 0, 0),
        BackgroundTransparency = 1
    }, container)

    local layout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, holder)

    local function update()
        holder.Size = UDim2.new(
            1,
            -22,
            0,
            layout.AbsoluteContentSize.Y
        )

        container.Size = UDim2.new(
            1,
            0,
            0,
            top + layout.AbsoluteContentSize.Y + 12
        )
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)

    section.Container = container
    section.Holder = holder
    section.Layout = layout

    section.Library.Connections[#section.Library.Connections + 1] =
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)

    return section
end

function Spectra:CreateSectionForTab(tab, title, description)
    return self:CreateSection(tab, title, description)
end

function Spectra:CreateLabel(text)
    local object = Label(
        self.Holder,
        text,
        10,
        Theme.Muted
    )

    object.Size = UDim2.new(1, 0, 0, 25)

    return object
end

function Spectra:CreateButton(text, callback, iconName)
    local button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 33),
        BackgroundColor3 = Theme.Element,
        Text = "",
        AutoButtonColor = false
    }, self.Holder)

    Corner(button, 6)
    Stroke(button)

    Icon(
        button,
        iconName or "Chevron",
        14,
        UDim2.fromOffset(10, 9)
    )

    local label = Label(
        button,
        text,
        10,
        Theme.Text,
        Enum.Font.GothamMedium
    )

    label.Position = UDim2.fromOffset(32, 0)
    label.Size = UDim2.new(1, -40, 1, 0)

    button.MouseEnter:Connect(function()
        Animate(button, {
            BackgroundColor3 = Theme.Hover
        })
    end)

    button.MouseLeave:Connect(function()
        Animate(button, {
            BackgroundColor3 = Theme.Element
        })
    end)

    button.MouseButton1Click:Connect(function()
        if callback then
            task.spawn(callback)
        end
    end)

    return button
end

function Spectra:CreateButtonRow(items)
    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 33),
        BackgroundTransparency = 1
    }, self.Holder)

    Create("UIGridLayout", {
        CellSize = UDim2.new(0.5, -4, 1, 0),
        CellPadding = UDim2.fromOffset(8, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, row)

    local buttons = {}

    for _, item in ipairs(items) do
        local button = Create("TextButton", {
            BackgroundColor3 = Theme.Element,
            Text = "",
            AutoButtonColor = false
        }, row)

        Corner(button, 6)
        Stroke(button)

        Icon(
            button,
            item.Icon or "Chevron",
            13,
            UDim2.fromOffset(8, 10)
        )

        local label = Label(
            button,
            item.Name,
            9,
            Theme.Text,
            Enum.Font.GothamMedium
        )

        label.Position = UDim2.fromOffset(26, 0)
        label.Size = UDim2.new(1, -30, 1, 0)

        button.MouseEnter:Connect(function()
            Animate(button, {
                BackgroundColor3 = Theme.Hover
            })
        end)

        button.MouseLeave:Connect(function()
            Animate(button, {
                BackgroundColor3 = Theme.Element
            })
        end)

        button.MouseButton1Click:Connect(function()
            if item.Callback then
                task.spawn(item.Callback)
            end
        end)

        table.insert(buttons, button)
    end

    return buttons
end

function Spectra:CreateToggle(text, default, callback)
    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1
    }, self.Holder)

    local label = Label(
        row,
        text,
        10,
        Theme.Text,
        Enum.Font.GothamMedium
    )

    label.Size = UDim2.new(1, -60, 1, 0)

    local switch = Create("TextButton", {
        Size = UDim2.fromOffset(32, 17),
        Position = UDim2.new(1, -33, 0.5, -8),
        BackgroundColor3 = Theme.Element,
        Text = "",
        AutoButtonColor = false
    }, row)

    Corner(switch, 20)

    local dot = Create("Frame", {
        Size = UDim2.fromOffset(11, 11),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.Muted,
        BorderSizePixel = 0
    }, switch)

    Corner(dot, 20)

    local toggle = {
        Value = default == true
    }

    local function update()
        Animate(dot, {
            Position = toggle.Value
                and UDim2.new(1, -14, 0, 3)
                or UDim2.fromOffset(3, 3),
            BackgroundColor3 = toggle.Value and Theme.Text or Theme.Muted
        })

        Animate(switch, {
            BackgroundColor3 = toggle.Value
                and Color3.fromRGB(65, 65, 65)
                or Theme.Element
        })

        if callback then
            task.spawn(callback, toggle.Value)
        end
    end

    function toggle:Set(value)
        self.Value = value == true
        update()
    end

    function toggle:Get()
        return self.Value
    end

    switch.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        update()
    end)

    update()

    return toggle
end

function Spectra:CreateColorPicker(text, default, callback)
    local section = self:CreateLabel(text)

    local holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1
    }, self.Holder)

    local colors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(180, 180, 180),
        Color3.fromRGB(120, 120, 120),
        Color3.fromRGB(75, 75, 75),
        Color3.fromRGB(45, 45, 45),
        Color3.fromRGB(220, 220, 220)
    }

    local grid = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1
    }, holder)

    Create("UIGridLayout", {
        CellSize = UDim2.fromOffset(25, 25),
        CellPadding = UDim2.fromOffset(8, 0)
    }, grid)

    local picker = {
        Value = default or Theme.Accent
    }

    for _, color in ipairs(colors) do
        local button = Create("TextButton", {
            BackgroundColor3 = color,
            Text = "",
            AutoButtonColor = false
        }, grid)

        Corner(button, 6)
        Stroke(button)

        button.MouseButton1Click:Connect(function()
            picker.Value = color

            if callback then
                task.spawn(callback, color)
            end
        end)
    end

    function picker:Get()
        return self.Value
    end

    function picker:Set(color)
        self.Value = color

        if callback then
            callback(color)
        end
    end

    return picker
end

function Spectra:CreateWindow(options)
    options = options or {}

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local old = playerGui:FindFirstChild("SpectraUI")

    if old then
        old:Destroy()
    end

    local library = setmetatable({}, Spectra)

    library.Tabs = {}
    library.Connections = {}
    library.Open = true
    library.Destroyed = false
    library.ActiveTab = nil
    library.WindowSize = options.Size or UDim2.fromOffset(820, 490)

    library.Gui = Create("ScreenGui", {
        Name = "SpectraUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, playerGui)

    local window = Create("Frame", {
        Size = library.WindowSize,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, library.Gui)

    Corner(window, 11)
    Stroke(window)

    library.Window = window

    local topbar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0
    }, window)

    library.Topbar = topbar

    local logo = Create("ImageLabel", {
        Size = UDim2.fromOffset(35, 35),
        Position = UDim2.fromOffset(17, 13),
        BackgroundTransparency = 1,
        Image = options.Logo or "rbxassetid://96535159972301",
        ScaleType = Enum.ScaleType.Fit
    }, topbar)

    local brand = Label(
        topbar,
        options.Title or "Spectra.wtf",
        15,
        Theme.Text,
        Enum.Font.GothamBold
    )

    brand.Position = UDim2.fromOffset(61, 10)
    brand.Size = UDim2.fromOffset(200, 22)

    local subtitle = Label(
        topbar,
        options.Subtitle or game.Name,
        10,
        Theme.Muted
    )

    subtitle.Position = UDim2.fromOffset(62, 32)
    subtitle.Size = UDim2.fromOffset(300, 17)

    local close = Create("TextButton", {
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -43, 0, 15),
        BackgroundColor3 = Theme.Surface,
        Text = "×",
        TextColor3 = Theme.Muted,
        TextSize = 20,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false
    }, topbar)

    Corner(close, 7)

    close.MouseButton1Click:Connect(function()
        library:ToggleUI()
    end)

    local sidebar = Create("Frame", {
        Position = UDim2.fromOffset(0, 62),
        Size = UDim2.new(0, 178, 1, -62),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0
    }, window)

    library.Sidebar = sidebar

    Create("Frame", {
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0
    }, sidebar)

    local navigationTitle = Label(
        sidebar,
        "WORKSPACE",
        9,
        Theme.Muted,
        Enum.Font.GothamBold
    )

    navigationTitle.Position = UDim2.fromOffset(17, 19)
    navigationTitle.Size = UDim2.fromOffset(140, 20)

    library.Navigation = Create("Frame", {
        Position = UDim2.fromOffset(9, 48),
        Size = UDim2.new(1, -18, 0, 250),
        BackgroundTransparency = 1
    }, sidebar)

    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, library.Navigation)

    local footer = Label(
        sidebar,
        "SPECTRA.WTF",
        9,
        Theme.Muted,
        Enum.Font.GothamMedium
    )

    footer.Position = UDim2.new(0, 17, 1, -30)
    footer.Size = UDim2.new(1, -25, 0, 18)

    library.Content = Create("Frame", {
        Position = UDim2.fromOffset(178, 62),
        Size = UDim2.new(1, -178, 1, -62),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    }, window)

    local activation = Create("TextButton", {
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(0, 24, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.Surface,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10
    }, library.Gui)

    Corner(activation, 13)
    Stroke(activation)

    local activationIcon = Icon(
        activation,
        "Menu",
        23,
        UDim2.fromOffset(11, 11)
    )

    activationIcon.TextColor3 = Theme.Text
    activationIcon.ZIndex = 11

    library.ActivationButton = activation
    library.ActivationIcon = activationIcon

    activation.MouseButton1Click:Connect(function()
        library:ToggleUI()
    end)

    activation.MouseEnter:Connect(function()
        Animate(activation, {
            BackgroundColor3 = Theme.Hover
        })
    end)

    activation.MouseLeave:Connect(function()
        Animate(activation, {
            BackgroundColor3 = Theme.Surface
        })
    end)

    local dragging = false
    local dragStart
    local startPosition

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = window.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart

            window.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local key = options.ToggleKey or Enum.KeyCode.RightControl

    local keyConnection = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end

        if input.KeyCode == key then
            library:ToggleUI()
        end
    end)

    table.insert(library.Connections, keyConnection)

    library:Notify(
        "Spectra.wtf",
        "Interface initialized successfully.",
        2.5
    )

    return library
end

return Spectra
