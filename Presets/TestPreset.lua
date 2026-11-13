return function(UI, options)
	options = options or {}
	local report = { Pass = 0, Fail = 0, Lines = {} }

	local Controls = UI:CreateTab("Controls", "Sliders-Horizontal")
	local Lists = UI:CreateTab("Lists", "List-Checks")
	local Mobile = UI:CreateTab("Mobile", "Smartphone")
	local Looks = UI:CreateTab("Looks", "Palette")
	local Tests = UI:CreateTab("Self-test", "Flask-Conical")

	local counters = { Taps = 0, Slides = 0, Toggles = 0, Colors = 0 }
	local status

	local function refreshStatus()
		if status then
			status:SetText(("Taps %d  |  Slider changes %d  |  Toggles %d  |  Colors %d"):format(
				counters.Taps, counters.Slides, counters.Toggles, counters.Colors))
		end
	end

	local left = Controls:AddLeftGroupbox("Basic controls", "Sliders-Horizontal")
	local right = Controls:AddRightGroupbox("Colors and keys", "Palette")

	status = left:AddLabel({ Text = "Taps 0", Description = "Live counters updated by the real components." })
	left:AddToggle("Test_Toggle", {
		Text = "Toggle", Icon = "Zap", Default = true, Description = "Tap or click to flip.",
		Callback = function()
			counters.Toggles += 1
			refreshStatus()
		end,
	})
	left:AddCheckbox("Test_Check", { Text = "Checkbox", Default = false })
	left:AddSlider("Test_Slider", {
		Text = "Slider 0-100", Min = 0, Max = 100, Default = 40, Suffix = "%",
		Callback = function()
			counters.Slides += 1
			refreshStatus()
		end,
	})
	left:AddSlider("Test_SliderDecimal", { Text = "Slider 0-1", Min = 0, Max = 1, Default = 0.5, Rounding = 2 })
	left:AddInput("Test_Input", { Text = "Text input", Placeholder = "Type here..." })
	left:AddInput("Test_Number", { Text = "Number input", Numeric = true, Default = 7, Min = 0, Max = 99 })
	local row = left:AddButton({
		Text = "Count tap", Icon = "Check",
		Func = function()
			counters.Taps += 1
			refreshStatus()
		end,
	})
	row:AddButton({ Text = "Reset counters", Func = function()
		counters.Taps, counters.Slides, counters.Toggles, counters.Colors = 0, 0, 0, 0
		refreshStatus()
	end })
	left:AddButton({ Text = "Danger (double tap)", DoubleClick = true, Icon = "Triangle-Alert", Func = function()
		UI:Notify("Confirmed", "Double tap registered.", 2, "Success")
	end })

	local toggleA = right:AddToggle("Test_ToggleA", { Text = "Toggle with color A", Default = false })
	local pickerA = toggleA:AddColorPicker("Test_ColorA", {
		Default = Color3.fromRGB(255, 80, 80), Title = "Color A", Transparency = 0,
		Callback = function()
			counters.Colors += 1
			refreshStatus()
		end,
	})
	local toggleB = right:AddToggle("Test_ToggleB", { Text = "Toggle with color B", Default = false })
	local pickerB = toggleB:AddColorPicker("Test_ColorB", { Default = Color3.fromRGB(80, 200, 255), Title = "Color B" })
	local pickerC = right:AddColorPicker("Test_ColorC", { Text = "Standalone color", Default = Color3.fromRGB(120, 255, 160), Title = "Color C" })
	local toggleK = right:AddToggle("Test_ToggleK", { Text = "Toggle with keybind" })
	toggleK:AddKeyPicker("Test_Key", { Default = nil, Mode = "Toggle", Text = "Test key", SyncToggleState = true })

	local listLeft = Lists:AddLeftGroupbox("Multi-select lists", "List-Checks")
	local listRight = Lists:AddRightGroupbox("Result", "Layers")
	local result = listRight:AddLabel({ Text = "Nothing selected", DoesWrap = true })
	local selection = { Group = {}, Drop = {}, Search = {} }
	local function join(map)
		local names = {}
		for name, on in pairs(map) do
			if on then
				table.insert(names, name)
			end
		end
		table.sort(names)
		return #names > 0 and table.concat(names, ", ") or "-"
	end
	local function refreshResult()
		result:SetText(("Checkbox list: %s\nDropdown: %s\nSearchable: %s"):format(join(selection.Group), join(selection.Drop), join(selection.Search)))
	end
	listLeft:AddCheckbox("Test_CheckGroup", {
		Text = "Checkbox list (multi)", Multi = true, Values = { "Alpha", "Beta", "Gamma", "Delta" }, Default = { Alpha = true },
		Callback = function(value)
			selection.Group = value or {}
			refreshResult()
		end,
	})
	listLeft:AddDropdown("Test_MultiDrop", {
		Text = "Dropdown (multi)", Icon = "Layers", Multi = true, Values = { "One", "Two", "Three", "Four", "Five" }, Default = { "Two" },
		Callback = function(value)
			selection.Drop = value or {}
			refreshResult()
		end,
	})
	local names = {}
	for i = 1, 24 do
		table.insert(names, "Item " .. i)
	end
	listLeft:AddDropdown("Test_SearchDrop", {
		Text = "Searchable long list (multi)", Multi = true, Searchable = true, Values = names, MaxVisible = 6,
		Callback = function(value)
			selection.Search = value or {}
			refreshResult()
		end,
	})
	listLeft:AddDropdown("Test_SingleDrop", { Text = "Single choice", Values = { "Red", "Green", "Blue" }, Default = "Green" })
	refreshResult()

	local pad = Mobile:AddLeftGroupbox("Scroll and gesture test", "Smartphone")
	pad:AddLabel({
		Text = "Scroll this page with a vertical swipe starting on a slider: the value must not change. A horizontal drag moves the slider. A tap sets it.",
		DoesWrap = true,
	})
	local gestureLabel = pad:AddLabel({ Text = "Last slider: none" })
	for i = 1, 8 do
		pad:AddSlider("Test_Scroll" .. i, {
			Text = "Scroll slider " .. i, Min = 0, Max = 100, Default = i * 10,
			Callback = function(value)
				gestureLabel:SetText(("Last slider: %d = %d"):format(i, value))
			end,
		})
		pad:AddButton({ Text = "Button " .. i, Func = function()
			gestureLabel:SetText("Last button: " .. i)
		end })
	end
	local scrollInfo = Mobile:AddRightGroupbox("Scroll position", "Move-Vertical")
	local positionLabel = scrollInfo:AddLabel({ Text = "CanvasPosition.Y = 0" })
	Mobile.Page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		positionLabel:SetText(("CanvasPosition.Y = %d"):format(math.floor(Mobile.Page.CanvasPosition.Y)))
	end)
	scrollInfo:AddToggle("Test_ToggleScroll", { Text = "Toggle inside scroll" })
	scrollInfo:AddDropdown("Test_DropScroll", { Text = "Dropdown inside scroll", Values = { "A", "B", "C" }, Default = "A" })

	local looks = Looks:AddLeftGroupbox("Styles and density", "Palette")
	local buttons = Looks:AddRightGroupbox("Quick switch", "Sparkles")
	looks:AddDropdown("Test_Style", {
		Text = "Style", Values = UI.StyleOrder, Default = UI.Theme.Style,
		Callback = function(value)
			if value then
				UI:SetStyle(value)
			end
		end,
	})
	looks:AddDropdown("Test_Density", {
		Text = "Density", Values = UI.Densities, Default = UI.Theme.Density,
		Callback = function(value)
			if value then
				UI:SetDensity(value)
			end
		end,
	})
	looks:AddSlider("Test_Blur", {
		Text = "Background blur", Min = 0, Max = 24, Default = UI.Theme.BackgroundBlur,
		Callback = function(value) UI:SetTheme("BackgroundBlur", value) end,
	})
	local titlePicker = looks:AddColorPicker("Test_Title", {
		Text = "Title color", Default = UI.Theme.TitleColor, Title = "Title color",
		Callback = function(color) UI:SetTheme("TitleColor", color) end,
	})
	local styleIndex = 1
	buttons:AddButton({ Text = "Next style", Icon = "Swatch-Book", Func = function()
		styleIndex = styleIndex % #UI.StyleOrder + 1
		UI:SetStyle(UI.StyleOrder[styleIndex])
		UI.Options.Test_Style:SetValue(UI.StyleOrder[styleIndex], true)
		titlePicker:SetValue(UI.Theme.TitleColor, true)
	end })
	buttons:AddButton({ Text = "Toggle density", Icon = "Rows-3", Func = function()
		local nextDensity = UI.Theme.Density == "Compact" and "Comfortable" or "Compact"
		UI:SetDensity(nextDensity)
		UI.Options.Test_Density:SetValue(nextDensity, true)
	end })
	buttons:AddButton({ Text = "Toggle compact tabs", Icon = "Minimize-2", Func = function()
		UI:SetCompactTabs(not UI.Compact)
	end })
	buttons:AddButton({ Text = "Tabs on top / left", Icon = "Panel-Top", Func = function()
		UI:SetTabPosition(UI.TabPosition == "Top" and "Left" or "Top")
	end })

	local function record(name, ok, detail)
		if ok then
			report.Pass += 1
		else
			report.Fail += 1
		end
		table.insert(report.Lines, ("%s  %s%s"):format(ok and "PASS" or "FAIL", name, detail and (" (" .. tostring(detail) .. ")") or ""))
	end

	local suite = Tests:AddLeftGroupbox("Library self-test", "Flask-Conical")
	local out = Tests:AddRightGroupbox("Report", "Scroll-Text")
	local reportLabel = out:AddLabel({ Text = "Press Run tests.", DoesWrap = true })

	local function runTests()
		report.Pass, report.Fail, report.Lines = 0, 0, {}
		local manager = UI.IconManager
		local startStyle, startDensity = UI.Theme.Style, UI.Theme.Density

		local sample = { "Home", "Settings", "check", "x", "chevron-down", "Palette" }
		for _, name in ipairs(sample) do
			record("icon resolves: " .. name, manager:Has(name))
		end
		local offset, size = manager:Rect(39, 39)
		record("icon rect inside sheet", offset.X + size.X <= manager.Sheet.Width * manager.Scale and offset.Y + size.Y <= manager.Sheet.Height * manager.Scale)
		local info = manager:Info()
		record("icon sheet status", info.Status ~= "Failed", info.Status .. "/" .. info.Mode)

		for _, density in ipairs(UI.Densities) do
			UI:SetDensity(density)
			record("density " .. density .. " applies", UI.M.Mode == density and UI.Options.Test_Toggle.Top.Size.Y.Offset == UI.M.Row, UI.M.Row)
		end
		local compactRow, roomyRow
		UI:SetDensity("Compact")
		compactRow = UI.M.Row
		UI:SetDensity("Comfortable")
		roomyRow = UI.M.Row
		record("comfortable larger than compact", roomyRow > compactRow, compactRow .. " < " .. roomyRow)

		local alphas = {}
		for _, style in ipairs(UI.StyleOrder) do
			record("style " .. style .. " applies", UI:SetStyle(style) and UI.Theme.Style == style)
			alphas[style] = UI.Group.BackgroundTransparency
		end
		record("glass styles are translucent", alphas["Liquid Glass"] > alphas["Spectra"] and alphas["Glassmorphism"] > alphas["Minimalist"])
		UI:SetStyle(startStyle)
		UI:SetDensity(startDensity)

		pickerA:Open()
		pickerB:Open()
		record("one color picker open at a time", pickerB.IsOpen and not pickerA.IsOpen)
		record("picker rejects outside point", not pickerB:ContainsPoint(Vector2.new(-50, -50)))
		local anchor = UI.Options.Test_SingleDrop.Row
		UI:ShowList(anchor, { { Name = "x", Text = "x" } }, {})
		record("list popup closes pickers", not pickerB.IsOpen and UI.ActivePopup ~= nil)
		pickerA:Open()
		record("picker closes list popup", UI.ActivePopup == nil and pickerA.IsOpen)
		UI:CloseOverlays()
		record("overlays close together", not pickerA.IsOpen and UI.ActivePopup == nil)

		local before = UI.ScrollLocks
		record("no scroll lock left over", before == 0, before)

		reportLabel:SetText(table.concat(report.Lines, "\n"))
		UI:Notify({
			Title = report.Fail == 0 and "All tests passed" or "Some tests failed",
			Description = ("%d passed, %d failed"):format(report.Pass, report.Fail),
			Type = report.Fail == 0 and "Success" or "Error", Duration = 4,
		})
		return report
	end

	suite:AddLabel({ Text = "Runs real library checks: icons, density, styles and popup exclusivity.", DoesWrap = true })
	suite:AddButton({ Text = "Run tests", Icon = "Play", Func = runTests })
	suite:AddButton({ Text = "Open color A", Func = function() pickerA:Open() end })

	return { Run = runTests, Report = report, Pickers = { pickerA, pickerB, pickerC } }
end
