local function getService(name)
	local ok, svc = pcall(function()
		return game:GetService(name)
	end)
	if ok and svc then
		if type(cloneref) == "function" then
			local ok2, ref = pcall(cloneref, svc)
			if ok2 and ref then
				return ref
			end
		end
		return svc
	end
	return nil
end

local Players = getService("Players")
local TweenService = getService("TweenService")
local UserInputService = getService("UserInputService")
local RunService = getService("RunService")
local TextService = getService("TextService")
local CoreGui = getService("CoreGui")

local Spectra = {}
Spectra.__index = Spectra
Spectra.Version = "2.0.0"
Spectra.Name = "Spectra.wtf"
Spectra.DefaultLogo = "rbxassetid://96535159972301"

local Element = {}
Element.__index = Element
local Container = {}
Container.__index = Container
local TabClass = {}
TabClass.__index = TabClass
local Obj = {}
Obj.__index = Obj

local DefaultTheme = {
	Background = Color3.fromRGB(10, 10, 10),
	Sidebar = Color3.fromRGB(13, 13, 13),
	Surface = Color3.fromRGB(18, 18, 18),
	Element = Color3.fromRGB(25, 25, 25),
	Hover = Color3.fromRGB(34, 34, 34),
	Border = Color3.fromRGB(39, 39, 39),
	Text = Color3.fromRGB(245, 245, 245),
	Muted = Color3.fromRGB(125, 125, 125),
	Accent = Color3.fromRGB(255, 255, 255),
	Success = Color3.fromRGB(94, 203, 134),
	Error = Color3.fromRGB(235, 87, 87),
	Warning = Color3.fromRGB(242, 178, 70),
	Info = Color3.fromRGB(110, 168, 254),

	Transparency = 0,
	Scale = 1,
	Rounding = 8,
	AnimSpeed = 1,
	Animations = true,
	FontFamily = "Gotham",
}

local ColorKeys = {
	"Background", "Sidebar", "Surface", "Element", "Hover", "Border",
	"Text", "Muted", "Accent", "Success", "Error", "Warning", "Info",
}

local FontSets = {
	Gotham = { Enum.Font.Gotham, Enum.Font.GothamMedium, Enum.Font.GothamBold },
	Builder = { Enum.Font.BuilderSans, Enum.Font.BuilderSansMedium, Enum.Font.BuilderSansBold },
	Source = { Enum.Font.SourceSans, Enum.Font.SourceSansSemibold, Enum.Font.SourceSansBold },
	Code = { Enum.Font.Code, Enum.Font.RobotoMono, Enum.Font.RobotoMono },
	Ubuntu = { Enum.Font.Ubuntu, Enum.Font.Ubuntu, Enum.Font.Ubuntu },
	Arial = { Enum.Font.Arial, Enum.Font.ArialBold, Enum.Font.ArialBold },
}

Spectra.FontFamilies = {}
for name in pairs(FontSets) do
	table.insert(Spectra.FontFamilies, name)
end
table.sort(Spectra.FontFamilies)
Spectra.ColorKeys = ColorKeys
Spectra.DefaultTheme = DefaultTheme

local function toAsset(name)
	if type(name) == "number" then
		return "rbxassetid://" .. tostring(math.floor(name))
	end
	if type(name) == "string" then
		if name:match("^%d+$") then
			return "rbxassetid://" .. name
		end
		if name:find("^rbxassetid://") or name:find("^rbxasset://") or name:find("^https?://") then
			return name
		end
	end
	return nil
end

local IconManager = {
	Asset = "rbxassetid://139871994703359",
	Cell = 25,
	Size = 24,
	Catalog = {},
	Aliases = {},
	Fallback = nil,
	Warned = {},
}
Spectra.IconManager = IconManager

local CatalogData = [=[a-arrow-down,2,0;a-arrow-up,0,2;a-large-small,3,0;accessibility,2,1;activity,0,3;air-vent,4,0;airplay,3,1;alarm-clock,3,2;alarm-clock-check,2,2;alarm-clock-minus,0,4;alarm-clock-off,5,0;alarm-clock-plus,4,1;alarm-smoke,2,3;album,0,5;align-center,4,2;align-center-horizontal,6,0;align-center-vertical,5,1;align-end-horizontal,3,3;align-end-vertical,2,4;align-horizontal-distribute-center,0,6;align-horizontal-distribute-end,7,0;align-horizontal-distribute-start,6,1;align-horizontal-justify-center,5,2;align-horizontal-justify-end,4,3;align-horizontal-justify-start,3,4;align-horizontal-space-around,2,5;align-horizontal-space-between,0,7;align-justify,8,0;align-left,7,1;align-right,6,2;align-start-horizontal,5,3;align-start-vertical,4,4;align-vertical-distribute-center,3,5;align-vertical-distribute-end,2,6;align-vertical-distribute-start,0,8;align-vertical-justify-center,9,0;align-vertical-justify-end,8,1;align-vertical-justify-start,7,2;align-vertical-space-around,6,3;align-vertical-space-between,5,4;ambulance,4,5;ampersand,3,6;ampersands,2,7;amphora,0,9;anchor,10,0;angry,9,1;annoyed,8,2;antenna,7,3;anvil,6,4;aperture,5,5;app-window,3,7;app-window-mac,4,6;apple,2,8;archive,10,1;archive-restore,0,10;archive-x,11,0;armchair,9,2;arrow-big-down,7,4;arrow-big-down-dash,8,3;arrow-big-left,5,6;arrow-big-left-dash,6,5;arrow-big-right,3,8;arrow-big-right-dash,4,7;arrow-big-up,0,11;arrow-big-up-dash,2,9;arrow-down,13,0;arrow-down-0-1,12,0;arrow-down-1-0,11,1;arrow-down-a-z,10,2;arrow-down-from-line,9,3;arrow-down-left,8,4;arrow-down-narrow-wide,7,5;arrow-down-right,6,6;arrow-down-to-dot,5,7;arrow-down-to-line,4,8;arrow-down-up,3,9;arrow-down-wide-narrow,2,10;arrow-down-z-a,0,12;arrow-left,9,4;arrow-left-from-line,12,1;arrow-left-right,11,2;arrow-left-to-line,10,3;arrow-right,5,8;arrow-right-from-line,8,5;arrow-right-left,7,6;arrow-right-to-line,6,7;arrow-up,6,8;arrow-up-0-1,4,9;arrow-up-1-0,3,10;arrow-up-a-z,2,11;arrow-up-down,0,13;arrow-up-from-dot,14,0;arrow-up-from-line,13,1;arrow-up-left,12,2;arrow-up-narrow-wide,11,3;arrow-up-right,10,4;arrow-up-to-line,9,5;arrow-up-wide-narrow,8,6;arrow-up-z-a,7,7;arrows-up-from-line,5,9;asterisk,4,10;at-sign,3,11;atom,2,12;audio-lines,0,14;audio-waveform,15,0;award,14,1;axe,13,2;axis-3d,12,3;baby,11,4;backpack,10,5;badge,9,7;badge-alert,9,6;badge-cent,8,7;badge-check,7,8;badge-dollar-sign,6,9;badge-euro,5,10;badge-help,4,11;badge-indian-rupee,3,12;badge-info,2,13;badge-japanese-yen,0,15;badge-minus,16,0;badge-percent,15,1;badge-plus,14,2;badge-pound-sterling,13,3;badge-russian-ruble,12,4;badge-swiss-franc,11,5;badge-x,10,6;baggage-claim,8,8;ban,7,9;banana,6,10;bandage,5,11;banknote,4,12;barcode,3,13;baseline,2,14;bath,0,16;battery,12,5;battery-charging,17,0;battery-full,16,1;battery-low,15,2;battery-medium,14,3;battery-warning,13,4;beaker,11,6;bean,9,8;bean-off,10,7;bed,6,11;bed-double,8,9;bed-single,7,10;beef,5,12;beer,3,14;beer-off,4,13;bell,14,4;bell-dot,2,15;bell-electric,0,17;bell-minus,18,0;bell-off,17,1;bell-plus,16,2;bell-ring,15,3;between-horizontal-end,13,5;between-horizontal-start,12,6;between-vertical-end,11,7;between-vertical-start,10,8;biceps-flexed,9,9;bike,8,10;binary,7,11;binoculars,6,12;biohazard,5,13;bird,4,14;bitcoin,3,15;blend,2,16;blinds,0,18;blocks,19,0;bluetooth,15,4;bluetooth-connected,18,1;bluetooth-off,17,2;bluetooth-searching,16,3;bold,14,5;bolt,13,6;bomb,12,7;bone,11,8;book,7,13;book-a,10,9;book-audio,9,10;book-check,8,11;book-copy,7,12;book-dashed,6,13;book-down,5,14;book-headphones,4,15;book-heart,3,16;book-image,2,17;book-key,0,19;book-lock,20,0;book-marked,19,1;book-minus,18,2;book-open,15,5;book-open-check,17,3;book-open-text,16,4;book-plus,14,6;book-text,13,7;book-type,12,8;book-up,10,10;book-up-2,11,9;book-user,9,11;book-x,8,12;bookmark,2,18;bookmark-check,6,14;bookmark-minus,5,15;bookmark-plus,4,16;bookmark-x,3,17;boom-box,0,20;bot,19,2;bot-message-square,21,0;bot-off,20,1;box,18,3;boxes,17,4;braces,16,5;brackets,15,6;brain,12,9;brain-circuit,14,7;brain-cog,13,8;brick-wall,11,10;briefcase,7,14;briefcase-business,10,11;briefcase-conveyor-belt,9,12;briefcase-medical,8,13;bring-to-front,6,15;brush,5,16;bug,2,19;bug-off,4,17;bug-play,3,18;building,22,0;building-2,0,21;bus,20,2;bus-front,21,1;cable,18,4;cable-car,19,3;cake,16,6;cake-slice,17,5;calculator,15,7;calendar,17,6;calendar-1,14,8;calendar-arrow-down,13,9;calendar-arrow-up,12,10;calendar-check,10,12;calendar-check-2,11,11;calendar-clock,9,13;calendar-cog,8,14;calendar-days,7,15;calendar-fold,6,16;calendar-heart,5,17;calendar-minus,3,19;calendar-minus-2,4,18;calendar-off,2,20;calendar-plus,23,0;calendar-plus-2,0,22;calendar-range,22,1;calendar-search,21,2;calendar-sync,20,3;calendar-x,18,5;calendar-x-2,19,4;camera,15,8;camera-off,16,7;candy,12,11;candy-cane,14,9;candy-off,13,10;cannabis,11,12;captions,9,14;captions-off,10,13;car,6,17;car-front,8,15;car-taxi-front,7,16;caravan,5,18;carrot,4,19;case-lower,3,20;case-sensitive,2,21;case-upper,0,23;cassette-tape,24,0;cast,23,1;castle,22,2;cctv,20,4;chart-area,19,5;chart-bar,14,10;chart-bar-big,18,6;chart-bar-decreasing,17,7;chart-bar-increasing,16,8;chart-bar-stacked,15,9;chart-candlestick,13,11;chart-column,8,16;chart-column-big,12,12;chart-column-decreasing,11,13;chart-column-increasing,10,14;chart-column-stacked,9,15;chart-gantt,7,17;chart-line,6,18;chart-network,5,19;chart-no-axes-column,2,22;chart-no-axes-column-decreasing,4,20;chart-no-axes-column-increasing,3,21;chart-no-axes-combined,0,24;chart-no-axes-gantt,25,0;chart-pie,24,1;chart-scatter,23,2;chart-spline,22,3;check,20,5;check-check,21,4;chef-hat,19,6;cherry,18,7;chevron-down,17,8;chevron-first,16,9;chevron-last,15,10;chevron-left,14,11;chevron-right,13,12;chevron-up,12,13;chevrons-down,10,15;chevrons-down-up,11,14;chevrons-left,7,18;chevrons-left-right,8,17;chevrons-left-right-ellipsis,9,16;chevrons-right,5,20;chevrons-right-left,6,19;chevrons-up,3,22;chevrons-up-down,4,21;chrome,2,23;church,0,25;cigarette,25,1;cigarette-off,26,0;circle,10,17;circle-alert,24,2;circle-arrow-down,23,3;circle-arrow-left,22,4;circle-arrow-out-down-left,21,5;circle-arrow-out-down-right,20,6;circle-arrow-out-up-left,19,7;circle-arrow-out-up-right,18,8;circle-arrow-right,17,9;circle-arrow-up,16,10;circle-check,14,12;circle-check-big,15,11;circle-chevron-down,13,13;circle-chevron-left,12,14;circle-chevron-right,11,15;circle-chevron-up,10,16;circle-dashed,9,17;circle-divide,8,18;circle-dollar-sign,7,19;circle-dot,5,21;circle-dot-dashed,6,20;circle-ellipsis,4,22;circle-equal,3,23;circle-fading-arrow-up,2,24;circle-fading-plus,0,26;circle-gauge,27,0;circle-help,26,1;circle-minus,25,2;circle-off,24,3;circle-parking,22,5;circle-parking-off,23,4;circle-pause,21,6;circle-percent,20,7;circle-play,19,8;circle-plus,18,9;circle-power,17,10;circle-slash,15,12;circle-slash-2,16,11;circle-stop,14,13;circle-user,12,15;circle-user-round,13,14;circle-x,11,16;circuit-board,9,18;citrus,8,19;clapperboard,7,20;clipboard,24,4;clipboard-check,6,21;clipboard-copy,5,22;clipboard-list,4,23;clipboard-minus,3,24;clipboard-paste,2,25;clipboard-pen,28,0;clipboard-pen-line,0,27;clipboard-plus,27,1;clipboard-type,26,2;clipboard-x,25,3;clock,17,11;clock-1,23,5;clock-10,22,6;clock-11,21,7;clock-12,20,8;clock-2,19,9;clock-3,18,10;clock-4,17,11;clock-5,16,12;clock-6,15,13;clock-7,14,14;clock-8,13,15;clock-9,12,16;clock-alert,11,17;clock-arrow-down,10,18;clock-arrow-up,9,19;cloud,20,9;cloud-alert,7,21;cloud-cog,6,22;cloud-download,5,23;cloud-drizzle,4,24;cloud-fog,3,25;cloud-hail,2,26;cloud-lightning,0,28;cloud-moon,28,1;cloud-moon-rain,29,0;cloud-off,27,2;cloud-rain,25,4;cloud-rain-wind,26,3;cloud-snow,24,5;cloud-sun,22,7;cloud-sun-rain,23,6;cloud-upload,21,8;cloudy,19,10;clover,18,11;club,17,12;code,15,14;code-xml,16,13;codepen,14,15;codesandbox,13,16;coffee,12,17;cog,11,18;coins,10,19;columns-2,9,20;columns-3,8,21;columns-4,7,22;combine,6,23;command,5,24;compass,4,25;component,3,26;computer,2,27;concierge-bell,0,29;cone,30,0;construction,29,1;contact,27,3;contact-round,28,2;container,26,4;contrast,25,5;cookie,24,6;cooking-pot,23,7;copy,17,13;copy-check,22,8;copy-minus,21,9;copy-plus,20,10;copy-slash,19,11;copy-x,18,12;copyleft,16,14;copyright,15,15;corner-down-left,14,16;corner-down-right,13,17;corner-left-down,12,18;corner-left-up,11,19;corner-right-down,10,20;corner-right-up,9,21;corner-up-left,8,22;corner-up-right,7,23;cpu,6,24;creative-commons,5,25;credit-card,4,26;croissant,3,27;crop,2,28;cross,0,30;crosshair,31,0;crown,30,1;cuboid,29,2;cup-soda,28,3;currency,27,4;cylinder,26,5;dam,25,6;database,22,9;database-backup,24,7;database-zap,23,8;delete,21,10;dessert,20,11;diameter,19,12;diamond,15,16;diamond-minus,18,13;diamond-percent,17,14;diamond-plus,16,15;dice-1,14,17;dice-2,13,18;dice-3,12,19;dice-4,11,20;dice-5,10,21;dice-6,9,22;dices,8,23;diff,7,24;disc,3,28;disc-2,6,25;disc-3,5,26;disc-album,4,27;divide,2,29;dna,32,0;dna-off,0,31;dock,31,1;dog,30,2;dollar-sign,29,3;donut,28,4;door-closed,27,5;door-open,26,6;dot,25,7;download,24,8;drafting-compass,23,9;drama,22,10;dribbble,21,11;drill,20,12;droplet,18,14;droplet-off,19,13;droplets,17,15;drum,16,16;drumstick,15,17;dumbbell,14,18;ear,12,20;ear-off,13,19;earth,10,22;earth-lock,11,21;eclipse,9,23;egg,6,26;egg-fried,8,24;egg-off,7,25;ellipsis,4,28;ellipsis-vertical,5,27;equal,0,32;equal-approximately,3,29;equal-not,2,30;eraser,33,0;ethernet-port,32,1;euro,31,2;expand,30,3;external-link,29,4;eye,26,7;eye-closed,28,5;eye-off,27,6;facebook,25,8;factory,24,9;fan,23,10;fast-forward,22,11;feather,21,12;fence,20,13;ferris-wheel,19,14;figma,18,15;file,28,7;file-archive,17,16;file-audio,15,18;file-audio-2,16,17;file-axis-3d,14,19;file-badge,12,21;file-badge-2,13,20;file-box,11,22;file-chart-column,9,24;file-chart-column-increasing,10,23;file-chart-line,8,25;file-chart-pie,7,26;file-check,5,28;file-check-2,6,27;file-clock,4,29;file-code,2,31;file-code-2,3,30;file-cog,0,33;file-diff,34,0;file-digit,33,1;file-down,32,2;file-heart,31,3;file-image,30,4;file-input,29,5;file-json,27,7;file-json-2,28,6;file-key,25,9;file-key-2,26,8;file-lock,23,11;file-lock-2,24,10;file-minus,21,13;file-minus-2,22,12;file-music,20,14;file-output,19,15;file-pen,17,17;file-pen-line,18,16;file-plus,15,19;file-plus-2,16,18;file-question,14,20;file-scan,13,21;file-search,11,23;file-search-2,12,22;file-sliders,10,24;file-spreadsheet,9,25;file-stack,8,26;file-symlink,7,27;file-terminal,6,28;file-text,5,29;file-type,3,31;file-type-2,4,30;file-up,2,32;file-user,0,34;file-video,34,1;file-video-2,35,0;file-volume,32,3;file-volume-2,33,2;file-warning,31,4;file-x,29,6;file-x-2,30,5;files,27,8;film,26,9;filter,24,11;filter-x,25,10;fingerprint,23,12;fire-extinguisher,22,13;fish,19,16;fish-off,21,14;fish-symbol,20,15;flag,15,20;flag-off,18,17;flag-triangle-left,17,18;flag-triangle-right,16,19;flame,13,22;flame-kindling,14,21;flashlight,11,24;flashlight-off,12,23;flask-conical,9,26;flask-conical-off,10,25;flask-round,8,27;flip-horizontal,6,29;flip-horizontal-2,7,28;flip-vertical,4,31;flip-vertical-2,5,30;flower,2,33;flower-2,3,32;focus,0,35;fold-horizontal,36,0;fold-vertical,35,1;folder,5,31;folder-archive,34,2;folder-check,33,3;folder-clock,32,4;folder-closed,31,5;folder-code,30,6;folder-cog,29,7;folder-dot,28,8;folder-down,27,9;folder-git,25,11;folder-git-2,26,10;folder-heart,24,12;folder-input,23,13;folder-kanban,22,14;folder-key,21,15;folder-lock,20,16;folder-minus,19,17;folder-open,17,19;folder-open-dot,18,18;folder-output,16,20;folder-pen,15,21;folder-plus,14,22;folder-root,13,23;folder-search,11,25;folder-search-2,12,24;folder-symlink,10,26;folder-sync,9,27;folder-tree,8,28;folder-up,7,29;folder-x,6,30;folders,4,32;footprints,3,33;forklift,2,34;forward,0,36;frame,37,0;framer,36,1;frown,35,2;fuel,34,3;fullscreen,33,4;gallery-horizontal,31,6;gallery-horizontal-end,32,5;gallery-thumbnails,30,7;gallery-vertical,28,9;gallery-vertical-end,29,8;gamepad,26,11;gamepad-2,27,10;gauge,25,12;gavel,24,13;gem,23,14;ghost,22,15;gift,21,16;git-branch,19,18;git-branch-plus,20,17;git-commit-horizontal,18,19;git-commit-vertical,17,20;git-compare,15,22;git-compare-arrows,16,21;git-fork,14,23;git-graph,13,24;git-merge,12,25;git-pull-request,6,31;git-pull-request-arrow,11,26;git-pull-request-closed,10,27;git-pull-request-create,8,29;git-pull-request-create-arrow,9,28;git-pull-request-draft,7,30;github,5,32;gitlab,4,33;glass-water,3,34;glasses,2,35;globe,38,0;globe-lock,0,37;goal,37,1;grab,36,2;graduation-cap,35,3;grape,34,4;grid-2x2,30,8;grid-2x2-check,33,5;grid-2x2-plus,32,6;grid-2x2-x,31,7;grid-3x3,29,9;grip,26,12;grip-horizontal,28,10;grip-vertical,27,11;group,25,13;guitar,24,14;ham,23,15;hammer,22,16;hand,16,22;hand-coins,21,17;hand-heart,20,18;hand-helping,19,19;hand-metal,18,20;hand-platter,17,21;handshake,15,23;hard-drive,12,26;hard-drive-download,14,24;hard-drive-upload,13,25;hard-hat,11,27;hash,10,28;haze,9,29;hdmi-port,8,30;heading,0,38;heading-1,7,31;heading-2,6,32;heading-3,5,33;heading-4,4,34;heading-5,3,35;heading-6,2,36;headphone-off,39,0;headphones,38,1;headset,37,2;heart,32,7;heart-crack,36,3;heart-handshake,35,4;heart-off,34,5;heart-pulse,33,6;heater,31,8;hexagon,30,9;highlighter,29,10;history,28,11;hop,26,13;hop-off,27,12;hospital,25,14;hotel,24,15;hourglass,23,16;house,20,19;house-plug,22,17;house-plus,21,18;ice-cream-bowl,19,20;ice-cream-cone,18,21;id-card,17,22;image,9,30;image-down,16,23;image-minus,15,24;image-off,14,25;image-play,13,26;image-plus,12,27;image-up,11,28;image-upscale,10,29;images,8,31;import,7,32;inbox,6,33;indent-decrease,5,34;indent-increase,4,35;indian-rupee,3,36;infinity,2,37;info,0,39;inspection-panel,39,1;instagram,38,2;italic,37,3;iteration-ccw,36,4;iteration-cw,35,5;japanese-yen,34,6;joystick,33,7;kanban,32,8;key,29,11;key-round,31,9;key-square,30,10;keyboard,26,14;keyboard-music,28,12;keyboard-off,27,13;lamp,20,20;lamp-ceiling,25,15;lamp-desk,24,16;lamp-floor,23,17;lamp-wall-down,22,18;lamp-wall-up,21,19;land-plot,19,21;landmark,18,22;languages,17,23;laptop,14,26;laptop-minimal,15,25;laptop-minimal-check,16,24;lasso,12,28;lasso-select,13,27;laugh,11,29;layers,9,31;layers-2,10,30;layout-dashboard,8,32;layout-grid,7,33;layout-list,6,34;layout-panel-left,5,35;layout-panel-top,4,36;layout-template,3,37;leaf,2,38;leafy-green,39,2;lectern,38,3;letter-text,37,4;library,35,6;library-big,36,5;life-buoy,34,7;ligature,33,8;lightbulb,31,10;lightbulb-off,32,9;link,28,13;link-2,29,12;link-2-off,30,11;linkedin,27,14;list,10,31;list-check,26,15;list-checks,25,16;list-collapse,24,17;list-end,23,18;list-filter,21,20;list-filter-plus,22,19;list-minus,20,21;list-music,19,22;list-ordered,18,23;list-plus,17,24;list-restart,16,25;list-start,15,26;list-todo,14,27;list-tree,13,28;list-video,12,29;list-x,11,30;loader,7,34;loader-circle,9,32;loader-pinwheel,8,33;locate,4,37;locate-fixed,6,35;locate-off,5,36;lock,38,4;lock-keyhole,2,39;lock-keyhole-open,3,38;lock-open,39,3;log-in,37,5;log-out,36,6;logs,35,7;lollipop,34,8;luggage,33,9;magnet,32,10;mail,23,19;mail-check,31,11;mail-minus,30,12;mail-open,29,13;mail-plus,28,14;mail-question,27,15;mail-search,26,16;mail-warning,25,17;mail-x,24,18;mailbox,22,20;mails,21,21;map,8,34;map-pin,10,32;map-pin-check,19,23;map-pin-check-inside,20,22;map-pin-house,18,24;map-pin-minus,16,26;map-pin-minus-inside,17,25;map-pin-off,15,27;map-pin-plus,13,29;map-pin-plus-inside,14,28;map-pin-x,11,31;map-pin-x-inside,12,30;map-pinned,9,33;martini,7,35;maximize,5,37;maximize-2,6,36;medal,4,38;megaphone,39,4;megaphone-off,3,39;meh,38,5;memory-stick,37,6;menu,36,7;merge,35,8;message-circle,24,19;message-circle-code,34,9;message-circle-dashed,33,10;message-circle-heart,32,11;message-circle-more,31,12;message-circle-off,30,13;message-circle-plus,29,14;message-circle-question,28,15;message-circle-reply,27,16;message-circle-warning,26,17;message-circle-x,25,18;message-square,8,35;message-square-code,23,20;message-square-dashed,22,21;message-square-diff,21,22;message-square-dot,20,23;message-square-heart,19,24;message-square-lock,18,25;message-square-more,17,26;message-square-off,16,27;message-square-plus,15,28;message-square-quote,14,29;message-square-reply,13,30;message-square-share,12,31;message-square-text,11,32;message-square-warning,10,33;message-square-x,9,34;messages-square,7,36;mic,4,39;mic-off,6,37;microchip,39,5;microscope,38,6;microwave,37,7;milestone,36,8;milk,34,10;milk-off,35,9;minimize,32,12;minimize-2,33,11;minus,31,13;monitor,18,26;monitor-check,30,14;monitor-cog,29,15;monitor-dot,28,16;monitor-down,27,17;monitor-off,26,18;monitor-pause,25,19;monitor-play,24,20;monitor-smartphone,23,21;monitor-speaker,22,22;monitor-stop,21,23;monitor-up,20,24;monitor-x,19,25;moon,16,28;moon-star,17,27;mountain,14,30;mountain-snow,15,29;mouse,8,36;mouse-off,13,31;mouse-pointer,9,35;mouse-pointer-2,12,32;mouse-pointer-ban,11,33;mouse-pointer-click,10,34;move,29,16;move-3d,7,37;move-diagonal,5,39;move-diagonal-2,6,38;move-down,37,8;move-down-left,39,6;move-down-right,38,7;move-horizontal,36,9;move-left,35,10;move-right,34,11;move-up,31,14;move-up-left,33,12;move-up-right,32,13;move-vertical,30,15;music,25,20;music-2,28,17;music-3,27,18;music-4,26,19;navigation,21,24;navigation-2,23,22;navigation-2-off,24,21;navigation-off,22,23;network,20,25;newspaper,19,26;nfc,18,27;notebook,14,31;notebook-pen,17,28;notebook-tabs,16,29;notebook-text,15,30;notepad-text,12,33;notepad-text-dashed,13,32;nut,10,35;nut-off,11,34;octagon,39,7;octagon-alert,9,36;octagon-minus,8,37;octagon-pause,7,38;octagon-x,6,39;omega,38,8;option,37,9;orbit,36,10;origami,35,11;package,27,19;package-2,34,12;package-check,33,13;package-minus,32,14;package-open,31,15;package-plus,30,16;package-search,29,17;package-x,28,18;paint-bucket,26,20;paint-roller,25,21;paintbrush,23,23;paintbrush-vertical,24,22;palette,22,24;panel-bottom,18,28;panel-bottom-close,21,25;panel-bottom-dashed,20,26;panel-bottom-open,19,27;panel-left,14,32;panel-left-close,17,29;panel-left-dashed,16,30;panel-left-open,15,31;panel-right,10,36;panel-right-close,13,33;panel-right-dashed,12,34;panel-right-open,11,35;panel-top,39,8;panel-top-close,9,37;panel-top-dashed,8,38;panel-top-open,7,39;panels-left-bottom,38,9;panels-right-bottom,37,10;panels-top-left,36,11;paperclip,35,12;parentheses,34,13;parking-meter,33,14;party-popper,32,15;pause,31,16;paw-print,30,17;pc-case,29,18;pen,25,22;pen-line,28,19;pen-off,27,20;pen-tool,26,21;pencil,21,26;pencil-line,24,23;pencil-off,23,24;pencil-ruler,22,25;pentagon,20,27;percent,19,28;person-standing,18,29;philippine-peso,17,30;phone,10,37;phone-call,16,31;phone-forwarded,15,32;phone-incoming,14,33;phone-missed,13,34;phone-off,12,35;phone-outgoing,11,36;pi,9,38;piano,8,39;pickaxe,39,9;picture-in-picture,37,11;picture-in-picture-2,38,10;piggy-bank,36,12;pilcrow,33,15;pilcrow-left,35,13;pilcrow-right,34,14;pill,31,17;pill-bottle,32,16;pin,29,19;pin-off,30,18;pipette,28,20;pizza,27,21;plane,24,24;plane-landing,26,22;plane-takeoff,25,23;play,23,25;plug,20,28;plug-2,22,26;plug-zap,21,27;plus,19,29;pocket,17,31;pocket-knife,18,30;podcast,16,32;pointer,14,34;pointer-off,15,33;popcorn,13,35;popsicle,12,36;pound-sterling,11,37;power,9,39;power-off,10,38;presentation,39,10;printer,37,12;printer-check,38,11;projector,36,13;proportions,35,14;puzzle,34,15;pyramid,33,16;qr-code,32,17;quote,31,18;rabbit,30,19;radar,29,20;radiation,28,21;radical,27,22;radio,24,25;radio-receiver,26,23;radio-tower,25,24;radius,23,26;rail-symbol,22,27;rainbow,21,28;rat,20,29;ratio,19,30;receipt,10,39;receipt-cent,18,31;receipt-euro,17,32;receipt-indian-rupee,16,33;receipt-japanese-yen,15,34;receipt-pound-sterling,14,35;receipt-russian-ruble,13,36;receipt-swiss-franc,12,37;receipt-text,11,38;rectangle-ellipsis,39,11;rectangle-horizontal,38,12;rectangle-vertical,37,13;recycle,36,14;redo,33,17;redo-2,35,15;redo-dot,34,16;refresh-ccw,31,19;refresh-ccw-dot,32,18;refresh-cw,29,21;refresh-cw-off,30,20;refrigerator,28,22;regex,27,23;remove-formatting,26,24;repeat,23,27;repeat-1,25,25;repeat-2,24,26;replace,21,29;replace-all,22,28;reply,19,31;reply-all,20,30;rewind,18,32;ribbon,17,33;rocket,16,34;rocking-chair,15,35;roller-coaster,14,36;rotate-3d,13,37;rotate-ccw,11,39;rotate-ccw-square,12,38;rotate-cw,38,13;rotate-cw-square,39,12;route,36,15;route-off,37,14;router,35,16;rows-2,34,17;rows-3,33,18;rows-4,32,19;rss,31,20;ruler,30,21;russian-ruble,29,22;sailboat,28,23;salad,27,24;sandwich,26,25;satellite,24,27;satellite-dish,25,26;save,21,30;save-all,23,28;save-off,22,29;scale,19,32;scale-3d,20,31;scaling,18,33;scan,37,15;scan-barcode,17,34;scan-eye,16,35;scan-face,15,36;scan-heart,14,37;scan-line,13,38;scan-qr-code,12,39;scan-search,39,13;scan-text,38,14;school,36,16;scissors,34,18;scissors-line-dashed,35,17;screen-share,32,20;screen-share-off,33,19;scroll,30,22;scroll-text,31,21;search,25,27;search-check,29,23;search-code,28,24;search-slash,27,25;search-x,26,26;section,24,28;send,21,31;send-horizontal,23,29;send-to-back,22,30;separator-horizontal,20,32;separator-vertical,19,33;server,15,37;server-cog,18,34;server-crash,17,35;server-off,16,36;settings,13,39;settings-2,14,38;shapes,39,14;share,37,16;share-2,38,15;sheet,36,17;shell,35,18;shield,24,29;shield-alert,34,19;shield-ban,33,20;shield-check,32,21;shield-ellipsis,31,22;shield-half,30,23;shield-minus,29,24;shield-off,28,25;shield-plus,27,26;shield-question,26,27;shield-x,25,28;ship,22,31;ship-wheel,23,30;shirt,21,32;shopping-bag,20,33;shopping-basket,19,34;shopping-cart,18,35;shovel,17,36;shower-head,16,37;shrink,15,38;shrub,14,39;shuffle,39,15;sigma,38,16;signal,33,21;signal-high,37,17;signal-low,36,18;signal-medium,35,19;signal-zero,34,20;signature,32,22;signpost,30,24;signpost-big,31,23;siren,29,25;skip-back,28,26;skip-forward,27,27;skull,26,28;slack,25,29;slash,24,30;slice,23,31;sliders-horizontal,22,32;sliders-vertical,21,33;smartphone,18,36;smartphone-charging,20,34;smartphone-nfc,19,35;smile,16,38;smile-plus,17,37;snail,15,39;snowflake,39,16;sofa,38,17;soup,37,18;space,36,19;spade,35,20;sparkle,34,21;sparkles,33,22;speaker,32,23;speech,31,24;spell-check,29,26;spell-check-2,30,25;spline,28,27;split,27,28;spray-can,26,29;sprout,25,30;square,35,23;square-activity,24,31;square-arrow-down,21,34;square-arrow-down-left,23,32;square-arrow-down-right,22,33;square-arrow-left,20,35;square-arrow-out-down-left,19,36;square-arrow-out-down-right,18,37;square-arrow-out-up-left,17,38;square-arrow-out-up-right,16,39;square-arrow-right,39,17;square-arrow-up,36,20;square-arrow-up-left,38,18;square-arrow-up-right,37,19;square-asterisk,35,21;square-bottom-dashed-scissors,34,22;square-chart-gantt,33,23;square-check,31,25;square-check-big,32,24;square-chevron-down,30,26;square-chevron-left,29,27;square-chevron-right,28,28;square-chevron-up,27,29;square-code,26,30;square-dashed,21,35;square-dashed-bottom,24,32;square-dashed-bottom-code,25,31;square-dashed-kanban,23,33;square-dashed-mouse-pointer,22,34;square-divide,20,36;square-dot,19,37;square-equal,18,38;square-function,17,39;square-kanban,39,18;square-library,38,19;square-m,37,20;square-menu,36,21;square-minus,35,22;square-mouse-pointer,34,23;square-parking,32,25;square-parking-off,33,24;square-pen,31,26;square-percent,30,27;square-pi,29,28;square-pilcrow,28,29;square-play,27,30;square-plus,26,31;square-power,25,32;square-radical,24,33;square-sigma,23,34;square-slash,22,35;square-split-horizontal,21,36;square-split-vertical,20,37;square-square,19,38;square-stack,18,39;square-terminal,39,19;square-user,37,21;square-user-round,38,20;square-x,36,22;squircle,34,24;squirrel,33,25;stamp,32,26;star,29,29;star-half,31,27;star-off,30,28;step-back,28,30;step-forward,27,31;stethoscope,26,32;sticker,25,33;sticky-note,24,34;store,23,35;stretch-horizontal,22,36;stretch-vertical,21,37;strikethrough,20,38;subscript,19,39;sun,35,24;sun-dim,39,20;sun-medium,38,21;sun-moon,37,22;sun-snow,36,23;sunrise,34,25;sunset,33,26;superscript,32,27;swatch-book,31,28;swiss-franc,30,29;switch-camera,29,30;sword,28,31;swords,27,32;syringe,26,33;table,38,22;table-2,25,34;table-cells-merge,24,35;table-cells-split,23,36;table-columns-split,22,37;table-of-contents,21,38;table-properties,20,39;table-rows-split,39,21;tablet,36,24;tablet-smartphone,37,23;tablets,35,25;tag,34,26;tags,33,27;tally-1,32,28;tally-2,31,29;tally-3,30,30;tally-4,29,31;tally-5,28,32;tangent,27,33;target,26,34;telescope,25,35;tent,23,37;tent-tree,24,36;terminal,22,38;test-tube,39,22;test-tube-diagonal,21,39;test-tubes,38,23;text,32,29;text-cursor,36,25;text-cursor-input,37,24;text-quote,35,26;text-search,34,27;text-select,33,28;theater,31,30;thermometer,28,33;thermometer-snowflake,30,31;thermometer-sun,29,32;thumbs-down,27,34;thumbs-up,26,35;ticket,37,25;ticket-check,25,36;ticket-minus,24,37;ticket-percent,23,38;ticket-plus,22,39;ticket-slash,39,23;ticket-x,38,24;tickets,35,27;tickets-plane,36,26;timer,32,30;timer-off,34,28;timer-reset,33,29;toggle-left,31,31;toggle-right,30,32;toilet,29,33;tornado,28,34;torus,27,35;touchpad,25,37;touchpad-off,26,36;tower-control,24,38;toy-brick,23,39;tractor,39,24;traffic-cone,38,25;train-front,36,27;train-front-tunnel,37,26;train-track,35,28;tram-front,34,29;trash,32,31;trash-2,33,30;tree-deciduous,31,32;tree-palm,30,33;tree-pine,29,34;trees,28,35;trello,27,36;trending-down,26,37;trending-up,24,39;trending-up-down,25,38;triangle,37,27;triangle-alert,39,25;triangle-right,38,26;trophy,36,28;truck,35,29;turtle,34,30;tv,31,33;tv-minimal,32,32;tv-minimal-play,33,31;twitch,30,34;twitter,29,35;type,27,37;type-outline,28,36;umbrella,25,39;umbrella-off,26,38;underline,39,26;undo,36,29;undo-2,38,27;undo-dot,37,28;unfold-horizontal,35,30;unfold-vertical,34,31;ungroup,33,32;university,32,33;unlink,30,35;unlink-2,31,34;unplug,29,36;upload,28,37;usb,27,38;user,38,29;user-check,26,39;user-cog,39,27;user-minus,38,28;user-pen,37,29;user-plus,36,30;user-round,28,38;user-round-check,35,31;user-round-cog,34,32;user-round-minus,33,33;user-round-pen,32,34;user-round-plus,31,35;user-round-search,30,36;user-round-x,29,37;user-search,27,39;user-x,39,28;users,36,31;users-round,37,30;utensils,34,33;utensils-crossed,35,32;utility-pole,33,34;variable,32,35;vault,31,36;vegan,30,37;venetian-mask,29,38;vibrate,39,29;vibrate-off,28,39;video,37,31;video-off,38,30;videotape,36,32;view,35,33;voicemail,34,34;volleyball,33,35;volume,39,30;volume-1,32,36;volume-2,31,37;volume-off,30,38;volume-x,29,39;vote,38,31;wallet,35,34;wallet-cards,37,32;wallet-minimal,36,33;wallpaper,34,35;wand,32,37;wand-sparkles,33,36;warehouse,31,38;washing-machine,30,39;watch,39,31;waves,37,33;waves-ladder,38,32;waypoints,36,34;webcam,35,35;webhook,33,37;webhook-off,34,36;weight,32,38;wheat,39,32;wheat-off,31,39;whole-word,38,33;wifi,33,38;wifi-high,37,34;wifi-low,36,35;wifi-off,35,36;wifi-zero,34,20;wind,39,33;wind-arrow-down,32,39;wine,37,35;wine-off,38,34;workflow,36,36;worm,35,37;wrap-text,34,38;wrench,33,39;x,39,34;youtube,38,35;zap,36,37;zap-off,37,36;zoom-in,35,38;zoom-out,34,39]=]

local LegacyAliases = {
	["bell"] = "bell",
	["bolt"] = "zap",
	["check"] = "check",
	["chevron"] = "chevron-right",
	["close"] = "x",
	["code"] = "code",
	["copy"] = "copy",
	["cube"] = "box",
	["dot"] = "circle",
	["down"] = "chevron-down",
	["download"] = "download",
	["error"] = "circle-x",
	["eye"] = "eye",
	["flag"] = "flag",
	["folder"] = "folder",
	["globe"] = "globe",
	["grip"] = "grip",
	["home"] = "house",
	["image"] = "image",
	["info"] = "info",
	["keyboard"] = "keyboard",
	["left"] = "chevron-left",
	["link"] = "link",
	["list"] = "list",
	["lock"] = "lock",
	["menu"] = "menu",
	["minus"] = "minus",
	["move"] = "move",
	["palette"] = "palette",
	["pause"] = "pause",
	["pencil"] = "pencil",
	["play"] = "play",
	["plus"] = "plus",
	["refresh"] = "refresh-cw",
	["resize"] = "arrow-down-right",
	["right"] = "chevron-right",
	["save"] = "save",
	["search"] = "search",
	["settings"] = "settings",
	["shield"] = "shield",
	["sliders"] = "sliders-horizontal",
	["sparkles"] = "sparkles",
	["star"] = "star",
	["success"] = "circle-check",
	["target"] = "target",
	["trash"] = "trash-2",
	["up"] = "chevron-up",
	["upload"] = "upload",
	["user"] = "user",
	["warning"] = "triangle-alert",
	["alert-circle"] = "circle-alert",
	["alert-triangle"] = "triangle-alert",
	["check-circle"] = "circle-check",
	["help-circle"] = "circle-help",
	["home"] = "house",
	["wand-2"] = "wand-sparkles",
	["x-circle"] = "circle-x",
}

function IconManager:Normalize(name)
	local text = tostring(name)
	text = text:gsub("(%l)(%u)", "%1-%2")
	text = text:gsub("[%s_]+", "-")
	return text:lower()
end

function IconManager:Register(name, col, row)
	self.Catalog[self:Normalize(name)] = { col, row }
end

function IconManager:Alias(alias, target)
	self.Aliases[self:Normalize(alias)] = self:Normalize(target)
end

function IconManager:Load(data)
	for name, col, row in tostring(data):gmatch("([%w%-]+),(%d+),(%d+)") do
		self.Catalog[name] = { tonumber(col), tonumber(row) }
	end
end

function IconManager:Resolve(name)
	if name == nil then
		return nil
	end
	local key = self:Normalize(name)
	if self.Catalog[key] then
		return key
	end
	local alias = self.Aliases[key]
	if alias and self.Catalog[alias] then
		return alias
	end
	local spaced = key:gsub("(%a)(%d+)$", "%1-%2")
	if self.Catalog[spaced] then
		return spaced
	end
	return nil
end

function IconManager:Has(name)
	return self:Resolve(name) ~= nil
end

function IconManager:Get(name)
	local key = self:Resolve(name)
	local missing = false
	if not key then
		missing = true
		key = self.Fallback
		local label = tostring(name)
		if not self.Warned[label] then
			self.Warned[label] = true
			warn(("[Spectra] ícone '%s' não existe no catálogo; usando fallback"):format(label))
		end
	end
	local cell = key and self.Catalog[key]
	if not cell then
		return nil
	end
	return {
		Name = key,
		Image = self.Asset,
		Offset = Vector2.new(math.max(0, cell[1] * self.Cell - 1), cell[2] * self.Cell),
		Size = Vector2.new(self.Size, self.Size),
		Missing = missing,
	}
end

function IconManager:Apply(image, name)
	local data = self:Get(name)
	if not data then
		image.Visible = false
		return false
	end
	image.Image = data.Image
	image.ImageRectOffset = data.Offset
	image.ImageRectSize = data.Size
	image.Visible = true
	return not data.Missing
end

function IconManager:List()
	local list = {}
	for name in pairs(self.Catalog) do
		table.insert(list, name)
	end
	table.sort(list)
	return list
end

function IconManager:SetAsset(asset)
	local id = toAsset(asset)
	if id then
		self.Asset = id
	end
end

IconManager:Load(CatalogData)
for alias, target in pairs(LegacyAliases) do
	IconManager.Aliases[alias] = target
end
for _, candidate in ipairs({ "circle-help", "circle-dashed", "square", "circle" }) do
	if IconManager.Catalog[candidate] then
		IconManager.Fallback = candidate
		break
	end
end
Spectra.Icons = IconManager.Catalog

local FontScale = 1

local function fs(size)
	return math.max(8, math.floor(size * FontScale + 0.5))
end

local function new(class, props, parent)
	local obj = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			if k == "TextSize" then
				v = fs(v)
			end
			obj[k] = v
		end
	end
	if parent then
		obj.Parent = parent
	end
	return obj
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

local function enumItem(enum, name)
	local ok, value = pcall(function()
		return enum[name]
	end)
	if ok then
		return value
	end
	return nil
end

local function toHex(c)
	return string.format("%02X%02X%02X",
		math.clamp(math.floor(c.R * 255 + 0.5), 0, 255),
		math.clamp(math.floor(c.G * 255 + 0.5), 0, 255),
		math.clamp(math.floor(c.B * 255 + 0.5), 0, 255))
end

local function fromHex(hex)
	hex = tostring(hex or ""):gsub("#", ""):gsub("%s", "")
	if #hex == 3 then
		hex = hex:gsub(".", function(ch) return ch .. ch end)
	end
	if #hex ~= 6 or hex:find("%X") then
		return nil
	end
	local n = tonumber(hex, 16)
	if not n then
		return nil
	end
	return Color3.fromRGB(math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256)
end

local function copyTable(t)
	local out = {}
	for k, v in pairs(t) do
		out[k] = (type(v) == "table" and getmetatable(v) == nil) and copyTable(v) or v
	end
	return out
end

local function round(n, decimals)
	local m = 10 ^ (decimals or 0)
	return math.floor(n * m + 0.5) / m
end

local KeyShort = {
	LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift",
	LeftAlt = "LAlt", RightAlt = "RAlt", Backspace = "Bksp", Return = "Enter", Escape = "Esc",
	MB1 = "M1", MB2 = "M2", MB3 = "M3", Insert = "Ins", Delete = "Del", PageUp = "PgUp",
	PageDown = "PgDn", CapsLock = "Caps", Space = "Space",
}

local function keyDisplay(name)
	if not name or name == "None" or name == "" then
		return "None"
	end
	return KeyShort[name] or name
end

local function inputKeyName(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		return input.KeyCode.Name
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		return "MB1"
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		return "MB2"
	elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
		return "MB3"
	end
	return nil
end

local function inputMatches(input, keyName)
	if not keyName or keyName == "None" then
		return false
	end
	if keyName:sub(1, 2) == "MB" then
		return input.UserInputType == enumItem(Enum.UserInputType, "MouseButton" .. keyName:sub(3))
	end
	return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == keyName
end

local function resolveGuiParent()
	if type(gethui) == "function" then
		local ok, result = pcall(gethui)
		if ok and typeof(result) == "Instance" then
			return result
		end
	end
	if CoreGui then
		local ok = pcall(function()
			local probe = Instance.new("Folder")
			probe.Parent = CoreGui
			probe:Destroy()
		end)
		if ok then
			return CoreGui
		end
	end
	local lp = Players.LocalPlayer
	return lp and lp:WaitForChild("PlayerGui") or nil
end

local FallbackEnv = {}
local function getEnv()
	if type(getgenv) == "function" then
		local ok, env = pcall(getgenv)
		if ok and type(env) == "table" then
			return env
		end
	end
	local ok = pcall(function()
		_G.__SpectraProbe = nil
	end)
	if ok then
		return _G
	end
	return FallbackEnv
end

Spectra.Util = {
	New = new, FontSize = fs, EnumItem = enumItem, ToHex = toHex, FromHex = fromHex, CopyTable = copyTable, Round = round,
	KeyDisplay = keyDisplay, GetEnv = getEnv,
}

function Spectra:Connect(signal, fn)
	local connection = signal:Connect(fn)
	table.insert(self.Connections, connection)
	return connection
end

function Spectra:Safe(fn, ...)
	if type(fn) ~= "function" then
		return false
	end
	local ok, err = pcall(fn, ...)
	if not ok then
		warn(("[Spectra] erro em callback: %s"):format(tostring(err)))
	end
	return ok
end

function Spectra:Defer(fn, ...)
	task.spawn(self.Safe, self, fn, ...)
end

function Spectra:GetFont(weight)
	local set = FontSets[self.Theme.FontFamily] or FontSets.Gotham
	return set[weight or 1] or set[1]
end

function Spectra:Tween(obj, props, duration, style, direction)
	local speed = self.Theme.Animations and self.Theme.AnimSpeed or 0
	if speed <= 0 or not obj then
		if obj then
			for k, v in pairs(props) do
				pcall(function()
					obj[k] = v
				end)
			end
		end
		return nil
	end
	local tween = TweenService:Create(obj, TweenInfo.new(
		(duration or 0.18) / speed,
		style or Enum.EasingStyle.Quart,
		direction or Enum.EasingDirection.Out
	), props)
	tween:Play()
	return tween
end

function Spectra:Bind(fn, owner)
	self.HookId += 1
	local id = self.HookId
	self.Hooks[id] = fn
	self:Safe(fn)
	local handle = {}
	function handle.Remove()
		self.Hooks[id] = nil
	end
	if owner then
		owner.Destroying:Connect(handle.Remove)
	end
	return handle
end

function Spectra:Themed(inst, prop, key)
	return self:Bind(function()
		inst[prop] = self.Theme[key]
	end, inst)
end

function Spectra:UpdateTheme()
	for _, fn in pairs(self.Hooks) do
		self:Safe(fn)
	end
	if self.OnThemeChanged then
		self:Safe(self.OnThemeChanged, self.Theme)
	end
end

local function validateThemeValue(current, key, value)
	if current == nil or value == nil or type(current) ~= type(value) then
		return nil
	end
	if typeof(current) == "Color3" and typeof(value) ~= "Color3" then
		return nil
	end
	if key == "Scale" then
		return math.clamp(value, 0.6, 1.6)
	elseif key == "Rounding" then
		return math.clamp(value, 0, 16)
	elseif key == "Transparency" then
		return math.clamp(value, 0, 0.6)
	elseif key == "AnimSpeed" then
		return math.clamp(value, 0, 4)
	elseif key == "FontFamily" and not FontSets[value] then
		return nil
	end
	return value
end

function Spectra:SetTheme(key, value)
	if type(key) == "table" then
		for k, v in pairs(key) do
			local checked = validateThemeValue(self.Theme[k], k, v)
			if checked ~= nil then
				self.Theme[k] = checked
			end
		end
		self:UpdateTheme()
		return
	end
	local checked = validateThemeValue(self.Theme[key], key, value)
	if checked == nil then
		return
	end
	self.Theme[key] = checked
	self:UpdateTheme()
end

function Spectra:GetTheme()
	return copyTable(self.Theme)
end

function Spectra:Corner(inst, radius)
	local corner = new("UICorner", nil, inst)
	local base = radius or 8
	self:Bind(function()
		corner.CornerRadius = UDim.new(0, math.floor(base * self.Theme.Rounding / 8 + 0.5))
	end, corner)
	return corner
end

function Spectra:Stroke(inst, colorKey, transparency)
	local stroke = new("UIStroke", {
		Thickness = 1,
		Transparency = transparency or 0.25,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, inst)
	self:Themed(stroke, "Color", colorKey or "Border")
	return stroke
end

function Spectra:Text(parent, text, size, colorKey, weight)
	local label = new("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = text == nil and "" or tostring(text),
		TextSize = size or 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}, parent)
	self:Bind(function()
		if colorKey ~= false then
			label.TextColor3 = self.Theme[colorKey or "Text"]
		end
		label.Font = self:GetFont(weight or 1)
	end, label)
	return label
end

function Spectra:Scaled(frame)
	local scale = new("UIScale", nil, frame)
	self:Bind(function()
		scale.Scale = self.Theme.Scale
	end, scale)
	return scale
end

function Spectra:SetFontScale(value)
	FontScale = math.clamp(tonumber(value) or 1, 0.7, 1.4)
end

function Spectra:SetScale(value)
	self:SetTheme("Scale", value)
end

local function applyIcon(self, holder)
	local img = holder:FindFirstChild("Img")
	if not img then
		return
	end
	local custom = holder:GetAttribute("Custom")
	local color
	if typeof(custom) == "Color3" then
		color = custom
	else
		color = self.Theme[holder:GetAttribute("ColorKey") or "Muted"]
	end
	if holder:GetAttribute("NoTint") then
		img.ImageColor3 = Color3.new(1, 1, 1)
	else
		img.ImageColor3 = color
	end
	img.ImageTransparency = holder:GetAttribute("Alpha") or 0
end

function Spectra:SetIcon(holder, name)
	local img = holder:FindFirstChild("Img")
	if not img then
		return
	end
	if name == nil or name == "" then
		img.Visible = false
		return
	end
	local asset = toAsset(name)
	if asset then
		img.Image = asset
		img.ImageRectOffset = Vector2.new(0, 0)
		img.ImageRectSize = Vector2.new(0, 0)
		img.Visible = true
	else
		IconManager:Apply(img, name)
	end
end

function Spectra:SetIconColor(holder, key)
	if typeof(key) == "Color3" then
		holder:SetAttribute("Custom", key)
	else
		holder:SetAttribute("Custom", nil)
		holder:SetAttribute("ColorKey", key)
	end
	applyIcon(self, holder)
end

function Spectra:SetIconTransparency(holder, alpha)
	holder:SetAttribute("Alpha", math.clamp(tonumber(alpha) or 0, 0, 1))
	applyIcon(self, holder)
end

function Spectra:Icon(parent, name, size, colorKey, noTint)
	size = size or 16
	local holder = new("Frame", {
		Name = "Icon",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size, size),
	}, parent)
	holder:SetAttribute("ColorKey", colorKey or "Muted")
	if noTint then
		holder:SetAttribute("NoTint", true)
	end
	new("ImageLabel", {
		Name = "Img", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Fit, Image = "", Visible = false,
	}, holder)
	self:SetIcon(holder, name)
	self:Bind(function()
		applyIcon(self, holder)
	end, holder)
	return holder
end

function Spectra:IconButton(parent, name, size, colorKey, callback)
	local button = new("TextButton", {
		BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(size + 8, size + 8),
	}, parent)
	local icon = self:Icon(button, name, size, colorKey or "Muted")
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Position = UDim2.fromScale(0.5, 0.5)
	button.MouseEnter:Connect(function()
		self:SetIconColor(icon, "Text")
	end)
	button.MouseLeave:Connect(function()
		self:SetIconColor(icon, colorKey or "Muted")
	end)
	if callback then
		button.Activated:Connect(callback)
	end
	return button, icon
end

function Spectra:LockScroll(state)
	self.ScrollLocks = math.max(0, self.ScrollLocks + (state and 1 or -1))
	local locked = self.ScrollLocks > 0
	for scroller in pairs(self.Scrollers) do
		if scroller.Parent then
			scroller.ScrollingEnabled = not locked
		end
	end
end

function Spectra:RegisterScroller(scroller)
	self.Scrollers[scroller] = true
	scroller.Destroying:Connect(function()
		self.Scrollers[scroller] = nil
	end)
end

function Spectra:ClampToScreen(frame)
	if not self.Gui or not frame.Parent then
		return
	end
	local screen = self.Gui.AbsoluteSize
	local pos, size = frame.AbsolutePosition, frame.AbsoluteSize
	local keep = 48
	local dx, dy = 0, 0
	if pos.X > screen.X - keep then
		dx = (screen.X - keep) - pos.X
	elseif pos.X + size.X < keep then
		dx = keep - (pos.X + size.X)
	end
	if pos.Y > screen.Y - keep then
		dy = (screen.Y - keep) - pos.Y
	elseif pos.Y < 0 then
		dy = -pos.Y
	end
	if dx ~= 0 or dy ~= 0 then
		local p = frame.Position
		frame.Position = UDim2.new(p.X.Scale, p.X.Offset + dx, p.Y.Scale, p.Y.Offset + dy)
	end
end

function Spectra:Disconnect(list)
	if not list then
		return
	end
	for _, connection in ipairs(list) do
		pcall(function()
			connection:Disconnect()
		end)
		local index = table.find(self.Connections, connection)
		if index then
			table.remove(self.Connections, index)
		end
	end
	table.clear(list)
end

function Spectra:MakeDraggable(handle, target, onFinish)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	local list = {}
	local function add(connection)
		table.insert(list, connection)
		table.insert(self.Connections, connection)
	end
	add(handle.InputBegan:Connect(function(input)
		if isPress(input) then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			local conn
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if conn then
						conn:Disconnect()
					end
					self:ClampToScreen(target)
					if onFinish then
						self:Safe(onFinish)
					end
				end
			end)
		end
	end))
	add(handle.InputChanged:Connect(function(input)
		if isMove(input) then
			dragInput = input
		end
	end))
	add(UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end))
	return list
end

function Spectra:MakeResizable(handle, target, minSize, maxSize, onResize)
	local resizing, dragInput, startInput, startSize = false, nil, nil, nil
	local list = {}
	local function add(connection)
		table.insert(list, connection)
		table.insert(self.Connections, connection)
	end
	add(handle.InputBegan:Connect(function(input)
		if isPress(input) then
			resizing = true
			startInput = input.Position
			startSize = Vector2.new(target.Size.X.Offset, target.Size.Y.Offset)
			self:LockScroll(true)
			local conn
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
					self:LockScroll(false)
					if conn then
						conn:Disconnect()
					end
				end
			end)
		end
	end))
	add(handle.InputChanged:Connect(function(input)
		if isMove(input) then
			dragInput = input
		end
	end))
	add(UserInputService.InputChanged:Connect(function(input)
		if resizing and input == dragInput then
			local delta = (input.Position - startInput) / self.Theme.Scale
			local w = math.clamp(startSize.X + delta.X, minSize.X, maxSize.X)
			local h = math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
			target.Size = UDim2.fromOffset(w, h)
			if onResize then
				self:Safe(onResize, Vector2.new(w, h))
			end
		end
	end))
	return list
end

function Spectra:TrackDrag(frame, callback, onEnd)
	local active = false
	local hit = new("TextButton", {
		Name = "Hit", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1), ZIndex = 10,
	}, frame)
	local function update(position)
		local ap, size = frame.AbsolutePosition, frame.AbsoluteSize
		callback(
			math.clamp((position.X - ap.X) / math.max(size.X, 1), 0, 1),
			math.clamp((position.Y - ap.Y) / math.max(size.Y, 1), 0, 1)
		)
	end
	local list = {}
	table.insert(list, hit.InputBegan:Connect(function(input)
		if isPress(input) then
			active = true
			self:LockScroll(true)
			update(input.Position)
		end
	end))
	table.insert(list, UserInputService.InputChanged:Connect(function(input)
		if active and isMove(input) then
			update(input.Position)
		end
	end))
	table.insert(list, UserInputService.InputEnded:Connect(function(input)
		if active and isPress(input) then
			active = false
			self:LockScroll(false)
			if onEnd then
				self:Safe(onEnd)
			end
		end
	end))
	return list
end

function Spectra:BringToFront(frame)
	self.ZCounter += 1
	frame.ZIndex = self.ZCounter
end

function Spectra:ClosePopup()
	local popup = self.ActivePopup
	if not popup then
		return
	end
	self.ActivePopup = nil
	if self.PopupLayer then
		self.PopupLayer.Visible = false
	end
	if popup.OnClose then
		self:Safe(popup.OnClose)
	end
	if popup.Frame then
		popup.Frame:Destroy()
	end
end

function Spectra:OpenPopup(frame, anchor, size, onClose)
	self:ClosePopup()
	frame.Size = UDim2.fromOffset(size.X, size.Y)
	frame.Parent = self.PopupLayer
	self:Scaled(frame)
	local scale = self.Theme.Scale
	local ap, as = anchor.AbsolutePosition, anchor.AbsoluteSize
	local screen = self.Gui.AbsoluteSize
	local w, h = size.X * scale, size.Y * scale
	local x = math.clamp(ap.X, 8, math.max(8, screen.X - w - 8))
	local y = ap.Y + as.Y + 4
	if y + h > screen.Y - 8 then
		y = ap.Y - h - 4
	end
	y = math.clamp(y, 8, math.max(8, screen.Y - h - 8))
	frame.Position = UDim2.fromOffset(x, y)
	self.PopupLayer.Visible = true
	self.ActivePopup = { Frame = frame, OnClose = onClose }
end

function Spectra:ShowList(anchor, items, opts)
	opts = opts or {}
	local itemH = self.M.ListItem
	local maxVisible = opts.MaxVisible or 6
	local searchH = opts.Searchable and (self.M.Input + 6) or 0
	local visibleCount = math.min(#items, maxVisible)
	local listH = math.max(itemH, visibleCount * (itemH + 2) + 6)
	local width = math.max(anchor.AbsoluteSize.X / self.Theme.Scale, opts.MinWidth or 140)
	local frame = new("Frame", { BackgroundColor3 = self.Theme.Surface, BorderSizePixel = 0, ClipsDescendants = true })
	self:Themed(frame, "BackgroundColor3", "Surface")
	self:Corner(frame, 7)
	self:Stroke(frame)

	local search
	if opts.Searchable then
		search = new("TextBox", {
			Position = UDim2.fromOffset(5, 5), Size = UDim2.new(1, -10, 0, self.M.Input - 4),
			BackgroundColor3 = self.Theme.Element, PlaceholderText = "Search...",
			Text = "", TextSize = 11, ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
		}, frame)
		self:Corner(search, 5)
		new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, search)
		self:Bind(function()
			search.BackgroundColor3 = self.Theme.Element
			search.TextColor3 = self.Theme.Text
			search.PlaceholderColor3 = self.Theme.Muted
			search.Font = self:GetFont(1)
		end, search)
	end

	local scroll = new("ScrollingFrame", {
		Position = UDim2.fromOffset(0, searchH), Size = UDim2.new(1, 0, 1, -searchH),
		BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, frame)
	self:Themed(scroll, "ScrollBarImageColor3", "Muted")
	new("UIPadding", {
		PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3),
		PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3),
	}, scroll)
	new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, scroll)

	local buttons = {}
	local function refreshSelection()
		for _, entry in ipairs(buttons) do
			local selected = opts.IsSelected and opts.IsSelected(entry.Item) or false
			entry.Button.BackgroundColor3 = selected and self.Theme.Element or self.Theme.Surface
			entry.Label.TextColor3 = selected and self.Theme.Text or self.Theme.Muted
			entry.Check.Visible = selected
		end
	end

	for i, item in ipairs(items) do
		local button = new("TextButton", {
			Size = UDim2.new(1, 0, 0, itemH), BackgroundColor3 = self.Theme.Surface,
			Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i,
		}, scroll)
		self:Corner(button, 5)
		local textX = 8
		if item.Icon or item.Image then
			local icon = self:Icon(button, item.Image or item.Icon, 14, "Muted", item.Image ~= nil)
			icon.Position = UDim2.new(0, 8, 0.5, -7)
			textX = 28
		end
		local label = self:Text(button, item.Text or tostring(item.Name), 11, false, 2)
		label.Position = UDim2.fromOffset(textX, 0)
		label.Size = UDim2.new(1, -(textX + 24), 1, 0)
		label.TextTruncate = Enum.TextTruncate.AtEnd
		local check = self:Icon(button, "check", 14, "Text")
		check.AnchorPoint = Vector2.new(1, 0.5)
		check.Position = UDim2.new(1, -8, 0.5, 0)
		check.Visible = false
		table.insert(buttons, { Button = button, Label = label, Check = check, Item = item })
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = self.Theme.Hover
		end)
		button.MouseLeave:Connect(function()
			refreshSelection()
		end)
		button.Activated:Connect(function()
			if opts.OnSelect then
				self:Safe(opts.OnSelect, item)
			end
			if opts.Multi then
				refreshSelection()
			else
				self:ClosePopup()
			end
		end)
	end
	refreshSelection()

	if search then
		search:GetPropertyChangedSignal("Text"):Connect(function()
			local query = search.Text:lower()
			for _, entry in ipairs(buttons) do
				local hay = (entry.Item.Text or tostring(entry.Item.Name)):lower()
				entry.Button.Visible = query == "" or hay:find(query, 1, true) ~= nil
			end
		end)
	end

	self:OpenPopup(frame, anchor, Vector2.new(width, listH + searchH), opts.OnClose)
	if search and not self.IsMobile then
		task.defer(function()
			if search.Parent then
				search:CaptureFocus()
			end
		end)
	end
	return frame
end

local NotifyTypes = {
	Success = { Key = "Success", Icon = "Success" },
	Error = { Key = "Error", Icon = "Error" },
	Warning = { Key = "Warning", Icon = "Warning" },
	Information = { Key = "Info", Icon = "Info" },
}

function Spectra:Notify(a, b, c, d)
	if self.Destroyed or not self.NotifyLayer then
		return nil
	end
	local info
	if type(a) == "table" then
		info = a
	else
		info = { Title = a, Description = b, Duration = c, Type = d }
	end
	local ntype = info.Type
	if ntype == "Info" or ntype == "info" then
		ntype = "Information"
	end
	if type(ntype) == "string" then
		ntype = ntype:sub(1, 1):upper() .. ntype:sub(2):lower()
	end
	local style = NotifyTypes[ntype] or NotifyTypes.Information
	local duration = info.Duration
	if duration == nil then
		duration = 3
	end
	local title = tostring(info.Title or self.Name)
	local desc = info.Description or info.Content or info.Text
	local closable = info.Closable == true

	local width = self.IsMobile and 248 or 288
	local textWidth = width - 46 - (closable and 26 or 12)
	local descHeight = 0
	if desc and tostring(desc) ~= "" then
		descHeight = TextService:GetTextSize(tostring(desc), fs(11), self:GetFont(1), Vector2.new(textWidth, 1000)).Y
	end
	local height = math.max(54, 12 + 18 + (descHeight > 0 and descHeight + 4 or 0) + 16)

	local wrapper = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.fromOffset(width, height),
		LayoutOrder = self.NotifyOrder,
	}, self.NotifyLayer)
	self.NotifyOrder += 1

	local card = new("Frame", {
		Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(width + 40, 0),
		BackgroundColor3 = self.Theme.Surface, BorderSizePixel = 0,
	}, wrapper)
	self:Themed(card, "BackgroundColor3", "Surface")
	self:Corner(card, 9)
	self:Stroke(card)

	local accent = new("Frame", {
		Position = UDim2.fromOffset(0, 10), Size = UDim2.new(0, 3, 1, -20), BorderSizePixel = 0,
	}, card)
	self:Corner(accent, 3)
	self:Bind(function()
		accent.BackgroundColor3 = self.Theme[style.Key]
	end, accent)

	local icon = self:Icon(card, info.Icon or style.Icon, 16, style.Key)
	icon.Position = UDim2.fromOffset(15, 12)

	local heading = self:Text(card, title, 12, "Text", 3)
	heading.Position = UDim2.fromOffset(38, 10)
	heading.Size = UDim2.new(1, -(38 + (closable and 30 or 12)), 0, 18)
	heading.TextTruncate = Enum.TextTruncate.AtEnd

	if descHeight > 0 then
		local body = self:Text(card, desc, 11, "Muted", 1)
		body.Position = UDim2.fromOffset(38, 30)
		body.Size = UDim2.new(1, -(38 + 12), 0, descHeight)
		body.TextWrapped = true
		body.TextYAlignment = Enum.TextYAlignment.Top
	end

	local bar
	if duration and duration > 0 then
		local track = new("Frame", {
			Position = UDim2.new(0, 12, 1, -6), Size = UDim2.new(1, -24, 0, 2), BorderSizePixel = 0,
		}, card)
		self:Themed(track, "BackgroundColor3", "Element")
		self:Corner(track, 2)
		bar = new("Frame", { Size = UDim2.fromScale(1, 1), BorderSizePixel = 0 }, track)
		self:Corner(bar, 2)
		self:Bind(function()
			bar.BackgroundColor3 = self.Theme[style.Key]
		end, bar)
	end

	local object = { Closed = false, Frame = wrapper }
	table.insert(self.Notifications, object)

	function object:Close()
		if self.Closed then
			return
		end
		self.Closed = true
		for i, n in ipairs(self.Lib.Notifications) do
			if n == self then
				table.remove(self.Lib.Notifications, i)
				break
			end
		end
		local lib = self.Lib
		lib:Tween(card, { Position = UDim2.fromOffset(width + 40, 0) }, 0.22)
		task.delay(0.24, function()
			if wrapper.Parent then
				lib:Tween(wrapper, { Size = UDim2.fromOffset(width, 0) }, 0.14)
				task.delay(0.16, function()
					wrapper:Destroy()
				end)
			end
		end)
	end
	object.Lib = self

	if closable then
		local close = self:IconButton(card, "x", 14, "Muted", function()
			object:Close()
		end)
		close.AnchorPoint = Vector2.new(1, 0)
		close.Position = UDim2.new(1, -6, 0, 6)
	end

	self:Tween(card, { Position = UDim2.fromOffset(0, 0) }, 0.28)
	if bar then
		self:Tween(bar, { Size = UDim2.fromScale(0, 1) }, duration, Enum.EasingStyle.Linear)
	end
	if duration and duration > 0 then
		task.delay(duration, function()
			object:Close()
		end)
	end
	while #self.Notifications > 6 do
		self.Notifications[1]:Close()
	end
	return object
end

function Spectra:ClearNotifications()
	for i = #self.Notifications, 1, -1 do
		local n = self.Notifications[i]
		if n then
			n:Close()
		end
	end
end

function Element:Connect(signal, fn)
	local connection = signal:Connect(fn)
	table.insert(self.Connections, connection)
	return connection
end

function Element:OnChanged(fn)
	if type(fn) == "function" then
		table.insert(self.Listeners, fn)
	end
	return self
end

function Element:Fire(...)
	if self.Destroyed or self.Lib.Destroyed then
		return
	end
	local lib = self.Lib
	local callback = self.Info.Callback
	if callback then
		task.spawn(lib.Safe, lib, callback, ...)
	end
	for _, fn in ipairs(self.Listeners) do
		task.spawn(lib.Safe, lib, fn, ...)
	end
end

function Element:SetVisible(state)
	if self.Row then
		self.Row.Visible = state ~= false
	end
	return self
end

function Element:GetVisible()
	return self.Row ~= nil and self.Row.Visible
end

function Element:SetText(text)
	self.Info.Text = text
	if self.Label then
		self.Label.Text = tostring(text)
	end
	return self
end

function Element:SetDescription(text)
	self.Info.Description = text
	if not self.Row then
		return self
	end
	if not text or text == "" then
		if self.DescLabel then
			self.DescLabel.Visible = false
		end
		return self
	end
	if not self.DescLabel then
		local desc = self.Lib:Text(self.Row, text, 10, "Muted", 1)
		desc.LayoutOrder = 10
		desc.Size = UDim2.new(1, 0, 0, 0)
		desc.AutomaticSize = Enum.AutomaticSize.Y
		desc.TextWrapped = true
		desc.TextYAlignment = Enum.TextYAlignment.Top
		self.DescLabel = desc
	end
	self.DescLabel.Text = text
	self.DescLabel.Visible = true
	return self
end

function Element:SetIcon(name)
	if self.IconHolder then
		self.Lib:SetIcon(self.IconHolder, name)
	end
	return self
end

function Element:SetDisabled(state)
	self.Disabled = state == true
	if self.Label then
		self.Label.TextTransparency = self.Disabled and 0.55 or 0
	end
	if self.OnDisabled then
		self:OnDisabled(self.Disabled)
	end
	return self
end

function Element:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true
	for _, cleanup in ipairs(self.Cleanups) do
		pcall(cleanup)
	end
	for _, c in ipairs(self.Connections) do
		c:Disconnect()
	end
	for _, addon in ipairs(self.Addons) do
		if addon.Destroy and not addon.Destroyed then
			pcall(addon.Destroy, addon)
		end
	end
	local lib = self.Lib
	if self.Idx then
		if lib.Options[self.Idx] == self then
			lib.Options[self.Idx] = nil
		end
		if lib.Toggles[self.Idx] == self then
			lib.Toggles[self.Idx] = nil
		end
	end
	if self.Row and self.Row.Parent then
		self.Row:Destroy()
	end
end

local autoId = 0
local function newElement(container, kind, idx, info, row, top)
	local lib = container.Lib
	if idx == nil then
		autoId += 1
		idx = "_" .. kind .. autoId
	end
	local el = setmetatable({
		Lib = lib, Container = container, Type = kind, Idx = idx, Info = info or {},
		Row = row, Top = top, Listeners = {}, Connections = {}, Cleanups = {}, Addons = {},
		Destroyed = false, Disabled = false,
	}, Element)
	if kind == "Toggle" or kind == "Checkbox" then
		lib.Toggles[idx] = el
	end
	if kind ~= "Button" and kind ~= "Divider" and kind ~= "Label" or (kind == "Label" and not tostring(idx):find("^_")) then
		lib.Options[idx] = el
	end
	return el
end

local function buildRow(self, info, height)
	local lib = self.Lib
	self.Order = (self.Order or 0) + 1
	local row = new("Frame", {
		Name = "Row", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self.Order,
	}, self.Holder)
	new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, row)
	local top = new("Frame", {
		Name = "Top", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, height), LayoutOrder = 1,
	}, row)
	local desc
	if info.Description and info.Description ~= "" then
		desc = lib:Text(row, info.Description, 10, "Muted", 1)
		desc.LayoutOrder = 10
		desc.Size = UDim2.new(1, 0, 0, 0)
		desc.AutomaticSize = Enum.AutomaticSize.Y
		desc.TextWrapped = true
		desc.TextYAlignment = Enum.TextYAlignment.Top
	end
	return row, top, desc
end

local function buildAddons(el)
	local holder = new("Frame", {
		Name = "Addons", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X, ZIndex = 3,
	}, el.Top)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
	}, holder)
	el.AddonHolder = holder
	local function resize()
		if el.Label then
			el.Label.Size = UDim2.new(1, -(holder.AbsoluteSize.X + 10 + (el.LabelInset or 0)), 1, 0)
		end
	end
	el:Connect(holder:GetPropertyChangedSignal("AbsoluteSize"), resize)
	el.ResizeLabel = resize
	return holder
end

local function labelFor(el, text, inset)
	local lib = el.Lib
	inset = inset or 0
	local iconName = el.Info and (el.Info.Image or el.Info.Icon)
	if iconName and el.Type ~= "Label" then
		local icon = lib:Icon(el.Top, iconName, 14, "Muted", el.Info.Image ~= nil)
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, inset, 0.5, 0)
		el.IconHolder = icon
		inset += 20
	end
	local label = lib:Text(el.Top, text, 11, "Text", 2)
	label.Position = UDim2.fromOffset(inset, 0)
	label.Size = UDim2.new(1, -inset, 1, 0)
	label.TextTruncate = Enum.TextTruncate.AtEnd
	el.Label = label
	el.LabelInset = inset
	return label
end

local function onRowHover(lib, hit, tweenTarget, fromKey, toKey)
	hit.MouseEnter:Connect(function()
		lib:Tween(tweenTarget, { BackgroundColor3 = lib.Theme[toKey] }, 0.12)
	end)
	hit.MouseLeave:Connect(function()
		lib:Tween(tweenTarget, { BackgroundColor3 = lib.Theme[fromKey] }, 0.12)
	end)
end

function Container:AddLabel(a, b)
	local idx, info
	if type(a) == "table" then
		info = a
	elseif type(b) == "table" then
		idx, info = a, b
	else
		info = { Text = a, DoesWrap = b == true }
	end
	local lib = self.Lib
	local row, top, desc = buildRow(self, info, lib.M.Row - 6)
	local el = newElement(self, "Label", idx, info, row, top)
	el.DescLabel = desc
	local inset = 0
	if info.Icon or info.Image then
		local icon = lib:Icon(top, info.Image or info.Icon, 14, "Muted", info.Image ~= nil)
		icon.Position = UDim2.new(0, 0, 0.5, -7)
		el.IconHolder = icon
		inset = 22
	end
	local label = labelFor(el, info.Text or "", inset)
	lib:Bind(function()
		label.Font = lib:GetFont(info.Bold and 3 or 1)
		label.TextColor3 = lib.Theme[info.Muted == false and "Text" or (info.Color or "Muted")]
	end, label)
	if info.DoesWrap then
		label.TextWrapped = true
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.TextTruncate = Enum.TextTruncate.None
		top.AutomaticSize = Enum.AutomaticSize.Y
	end
	buildAddons(el)
	function el:SetText(text)
		self.Info.Text = text
		self.Label.Text = tostring(text)
		return self
	end
	function el:SetIcon(name)
		if self.IconHolder then
			lib:SetIcon(self.IconHolder, name)
		end
		return self
	end
	function el:GetText()
		return self.Label.Text
	end
	el.Value = info.Text
	return el
end

local function layoutButtons(group)
	local visible = {}
	for _, b in ipairs(group.Buttons) do
		if b.Button.Visible then
			table.insert(visible, b)
		end
	end
	local n = #visible
	local gap = 6
	for _, b in ipairs(visible) do
		b.Button.Size = UDim2.new(1 / n, -(gap * (n - 1)) / n, 1, 0)
	end
end

local function makeButton(group, info, parentEl)
	local lib = group.Lib
	local btn = setmetatable({
		Lib = lib, Container = group.Container, Type = "Button", Info = info, Listeners = {},
		Connections = {}, Cleanups = {}, Addons = {}, Destroyed = false, Disabled = false,
		Row = group.Row, Group = group,
	}, Element)
	local button = new("TextButton", {
		Name = "Button", BackgroundColor3 = lib.Theme.Element, Text = "", AutoButtonColor = false,
		BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), LayoutOrder = #group.Buttons + 1,
	}, group.Row)
	btn.Button = button
	lib:Corner(button, 6)
	lib:Stroke(button)
	lib:Bind(function()
		button.BackgroundColor3 = lib.Theme.Element
	end, button)

	local content = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, button)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 7),
		HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, content)
	local iconName = info.Image or info.Icon
	local icon
	if iconName then
		icon = lib:Icon(content, iconName, 14, "Muted", info.Image ~= nil)
		icon.LayoutOrder = 1
		btn.IconHolder = icon
	end
	local label = lib:Text(content, info.Text or "Button", 11, "Text", 2)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.Size = UDim2.new(0, 0, 1, 0)
	label.LayoutOrder = 2
	btn.Label = label

	onRowHover(lib, button, button, "Element", "Hover")
	button.MouseButton1Down:Connect(function()
		if not btn.Disabled then
			lib:Tween(button, { BackgroundColor3 = lib.Theme.Border }, 0.08)
		end
	end)

	local armed = false
	function btn:Click()
		if self.Disabled then
			return
		end
		local fn = self.Info.Func or self.Info.Callback
		if fn then
			lib:Defer(fn, self)
		end
		for _, l in ipairs(self.Listeners) do
			lib:Defer(l, self)
		end
	end
	function btn:SetText(text)
		self.Info.Text = text
		self.Label.Text = tostring(text)
		return self
	end
	function btn:SetIcon(name)
		if self.IconHolder then
			lib:SetIcon(self.IconHolder, name)
		end
		return self
	end
	function btn:SetVisible(state)
		self.Button.Visible = state ~= false
		layoutButtons(self.Group)
		return self
	end
	function btn:SetDisabled(state)
		self.Disabled = state == true
		self.Button.BackgroundTransparency = self.Disabled and 0.5 or 0
		self.Label.TextTransparency = self.Disabled and 0.55 or 0
		return self
	end
	function btn:AddButton(a, b)
		local sub = type(a) == "table" and a or { Text = a, Func = b }
		return makeButton(self.Group, sub)
	end
	function btn:Destroy()
		if self.Destroyed then
			return
		end
		self.Destroyed = true
		for i, v in ipairs(self.Group.Buttons) do
			if v == self then
				table.remove(self.Group.Buttons, i)
				break
			end
		end
		self.Button:Destroy()
		if #self.Group.Buttons == 0 then
			self.Group.Row:Destroy()
		else
			layoutButtons(self.Group)
		end
	end
	button.Activated:Connect(function()
		if btn.Disabled then
			return
		end
		if btn.Info.DoubleClick then
			if not armed then
				armed = true
				label.Text = tostring(btn.Info.ConfirmText or "Click again to confirm")
				task.delay(2, function()
					armed = false
					if label.Parent then
						label.Text = tostring(btn.Info.Text or "Button")
					end
				end)
				return
			end
			armed = false
			label.Text = tostring(btn.Info.Text or "Button")
		end
		btn:Click()
	end)
	if info.Disabled then
		btn:SetDisabled(true)
	end
	table.insert(group.Buttons, btn)
	layoutButtons(group)
	return btn
end

function Container:AddButton(a, b, c)
	local info
	if type(a) == "table" then
		info = a
	else
		info = { Text = a, Func = b, Icon = c }
	end
	local lib = self.Lib
	self.Order = (self.Order or 0) + 1
	local row = new("Frame", {
		Name = "ButtonRow", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, lib.M.Button),
		LayoutOrder = self.Order,
	}, self.Holder)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, row)
	local group = { Lib = lib, Container = self, Row = row, Buttons = {} }
	local btn = makeButton(group, info)
	btn.Row = row
	return btn
end

function Container:AddToggle(idx, info)
	info = info or {}
	local lib = self.Lib
	local row, top, desc = buildRow(self, info, lib.M.Row)
	local el = newElement(self, "Toggle", idx, info, row, top)
	el.DescLabel = desc
	el.Value = info.Default == true
	local hit = new("TextButton", {
		Name = "Hit", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1), ZIndex = 1,
	}, top)
	labelFor(el, info.Text or tostring(idx or "Toggle"))
	local addons = buildAddons(el)
	local switch = new("Frame", {
		Name = "Switch", Size = UDim2.fromOffset(30, 16), BorderSizePixel = 0, LayoutOrder = 100,
	}, addons)
	lib:Corner(switch, 20)
	local dot = new("Frame", { Size = UDim2.fromOffset(10, 10), BorderSizePixel = 0 }, switch)
	lib:Corner(dot, 20)

	local function apply(animate)
		local t = lib.Theme
		local on = el.Value
		local dotProps = {
			Position = on and UDim2.new(1, -13, 0, 3) or UDim2.fromOffset(3, 3),
			BackgroundColor3 = on and t.Text or t.Muted,
		}
		local switchProps = { BackgroundColor3 = on and t.Element:Lerp(t.Accent, 0.22) or t.Element }
		if animate then
			lib:Tween(dot, dotProps, 0.16)
			lib:Tween(switch, switchProps, 0.16)
		else
			for k, v in pairs(dotProps) do dot[k] = v end
			for k, v in pairs(switchProps) do switch[k] = v end
		end
	end
	lib:Bind(function()
		apply(false)
	end, switch)

	function el:SetValue(value, silent)
		value = value == true
		if self.Value == value then
			return self
		end
		self.Value = value
		apply(true)
		if self.OnValueChanged then
			self:OnValueChanged(value)
		end
		if not silent then
			self:Fire(value)
		end
		return self
	end
	function el:Set(value)
		return self:SetValue(value)
	end
	function el:Get()
		return self.Value
	end
	function el:Toggle()
		return self:SetValue(not self.Value)
	end
	hit.Activated:Connect(function()
		if not el.Disabled then
			el:SetValue(not el.Value)
		end
	end)
	if info.Disabled then
		el:SetDisabled(true)
	end
	if info.FireOnInit then
		el:Fire(el.Value)
	end
	return el
end

local function buildBox(lib, parent)
	local box = new("Frame", { Size = UDim2.fromOffset(16, 16), BorderSizePixel = 0 }, parent)
	lib:Corner(box, 4)
	local stroke = lib:Stroke(box, "Border", 0)
	local check = lib:Icon(box, "check", 12, "Text")
	check.AnchorPoint = Vector2.new(0.5, 0.5)
	check.Position = UDim2.fromScale(0.5, 0.5)
	local function apply(on)
		local t = lib.Theme
		box.BackgroundColor3 = on and t.Element:Lerp(t.Accent, 0.22) or t.Element
		stroke.Color = on and t.Muted or t.Border
		check.Visible = on
	end
	return box, apply
end

function Container:AddCheckbox(idx, info)
	info = info or {}
	local lib = self.Lib
	if type(info.Values) == "table" then

		local multi = info.Multi ~= false
		local row = new("Frame", {
			Name = "Row", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = (self.Order or 0) + 1,
		}, self.Holder)
		self.Order = (self.Order or 0) + 1
		new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, row)
		local el = newElement(self, "CheckboxGroup", idx, info, row, row)
		el.Multi = multi
		el.Value = multi and {} or nil
		if info.Text then
			local head = lib:Text(row, info.Text, 11, "Text", 2)
			head.Size = UDim2.new(1, 0, 0, lib.M.Row - 8)
			head.LayoutOrder = 0
			el.Label = head
		end
		local boxes = {}
		local function applyAll()
			for name, b in pairs(boxes) do
				local on
				if multi then
					on = el.Value[name] == true
				else
					on = el.Value == name
				end
				b.Apply(on)
			end
		end
		for i, name in ipairs(info.Values) do
			local item = new("TextButton", {
				BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, lib.M.Row - 4), LayoutOrder = i,
			}, row)
			local box, apply = buildBox(lib, item)
			box.AnchorPoint = Vector2.new(0, 0.5)
			box.Position = UDim2.new(0, 0, 0.5, 0)
			local text = lib:Text(item, tostring(name), 11, "Text", 1)
			text.Position = UDim2.fromOffset(28, 0)
			text.Size = UDim2.new(1, -28, 1, 0)
			boxes[name] = { Apply = apply, Item = item }
			item.Activated:Connect(function()
				if el.Disabled then
					return
				end
				if multi then
					local nv = copyTable(el.Value)
					nv[name] = (not nv[name]) or nil
					el:SetValue(nv)
				else
					if el.Value == name and info.AllowNull then
						el:SetValue(nil)
					else
						el:SetValue(name)
					end
				end
			end)
		end
		function el:SetValue(value, silent)
			if multi then
				local nv = {}
				if type(value) == "table" then
					for k, v in pairs(value) do
						if type(k) == "number" then
							nv[v] = true
						elseif v then
							nv[k] = true
						end
					end
				end
				self.Value = nv
			else
				self.Value = value
			end
			applyAll()
			if not silent then
				self:Fire(self.Value)
			end
			return self
		end
		function el:Get()
			return self.Value
		end
		lib:Bind(applyAll, row)
		if info.Default ~= nil then
			el:SetValue(info.Default, true)
		end
		return el
	end

	local row, top, desc = buildRow(self, info, lib.M.Row)
	local el = newElement(self, "Checkbox", idx, info, row, top)
	el.DescLabel = desc
	el.Value = info.Default == true
	local box, apply = buildBox(lib, top)
	box.AnchorPoint = Vector2.new(0, 0.5)
	box.Position = UDim2.new(0, 0, 0.5, 0)
	local hit = new("TextButton", {
		BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1), ZIndex = 1,
	}, top)
	box.ZIndex = 2
	labelFor(el, info.Text or tostring(idx or "Checkbox"), 24)
	buildAddons(el)
	lib:Bind(function()
		apply(el.Value)
	end, box)
	function el:SetValue(value, silent)
		value = value == true
		if self.Value == value then
			return self
		end
		self.Value = value
		apply(value)
		if self.OnValueChanged then
			self:OnValueChanged(value)
		end
		if not silent then
			self:Fire(value)
		end
		return self
	end
	function el:Get()
		return self.Value
	end
	hit.Activated:Connect(function()
		if not el.Disabled then
			el:SetValue(not el.Value)
		end
	end)
	if info.FireOnInit then
		el:Fire(el.Value)
	end
	return el
end

function Container:AddDivider(a, b)
	local info
	if type(a) == "table" then
		info = a
	else
		info = { Title = a, Description = b }
	end
	local lib = self.Lib
	self.Order = (self.Order or 0) + 1
	local row = new("Frame", {
		Name = "Divider", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self.Order,
	}, self.Holder)
	new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, row)
	local el = newElement(self, "Divider", nil, info, row, row)
	local hasTitle = info.Title and info.Title ~= ""
	local top = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, hasTitle and 18 or 9), LayoutOrder = 1,
	}, row)
	local line = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0,
	}, top)
	lib:Themed(line, "BackgroundColor3", "Border")
	if hasTitle then
		local title = lib:Text(top, string.upper(tostring(info.Title)), 9, "Muted", 3)
		title.Size = UDim2.new(1, 0, 1, 0)
		el.Label = title
		local function relayout()
			local w = TextService:GetTextSize(title.Text, fs(9), lib:GetFont(3), Vector2.new(1000, 20)).X
			title.Size = UDim2.new(0, w + 2, 1, 0)
			line.Position = UDim2.new(0, w + 12, 0.5, 0)
			line.Size = UDim2.new(1, -(w + 12), 0, 1)
		end
		relayout()
		function el:SetText(text)
			title.Text = string.upper(tostring(text))
			relayout()
			return self
		end
		if info.Description and info.Description ~= "" then
			local d = lib:Text(row, info.Description, 10, "Muted", 1)
			d.LayoutOrder = 2
			d.Size = UDim2.new(1, 0, 0, 0)
			d.AutomaticSize = Enum.AutomaticSize.Y
			d.TextWrapped = true
			d.TextYAlignment = Enum.TextYAlignment.Top
			el.DescLabel = d
		end
	end
	return el
end

function Container:AddSlider(idx, info)
	info = info or {}
	local lib = self.Lib
	local min = info.Min or 0
	local max = info.Max or 100
	if max <= min then
		max = min + 1
	end
	local inc = info.Increment
	local decimals = info.Rounding or 0
	if inc and inc % 1 ~= 0 and not info.Rounding then
		decimals = #(tostring(inc):match("%.(%d+)") or "")
	end
	local row, top, desc = buildRow(self, info, 18)
	local el = newElement(self, "Slider", idx, info, row, top)
	el.DescLabel = desc
	el.Min, el.Max = min, max
	local label = labelFor(el, info.Text or tostring(idx or "Slider"))
	label.Size = UDim2.new(0.62, 0, 1, 0)
	local valueLabel = lib:Text(top, "", 11, "Muted", 2)
	valueLabel.AnchorPoint = Vector2.new(1, 0)
	valueLabel.Position = UDim2.new(1, 0, 0, 0)
	valueLabel.Size = UDim2.new(0.38, 0, 1, 0)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right

	local track = new("Frame", {
		Name = "Track", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, lib.M.SliderHit), LayoutOrder = 2,
	}, row)
	local bar = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 6), BorderSizePixel = 0,
	}, track)
	lib:Themed(bar, "BackgroundColor3", "Element")
	lib:Corner(bar, 6)
	lib:Stroke(bar)
	local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, bar)
	lib:Themed(fill, "BackgroundColor3", "Accent")
	lib:Corner(fill, 6)
	local thumb = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(12, 12), BorderSizePixel = 0,
	}, track)
	lib:Themed(thumb, "BackgroundColor3", "Text")
	lib:Corner(thumb, 12)

	local function snap(v)
		v = math.clamp(v, el.Min, el.Max)
		if inc and inc > 0 then
			v = el.Min + math.floor((v - el.Min) / inc + 0.5) * inc
		end
		v = round(v, decimals)
		return math.clamp(v, el.Min, el.Max)
	end
	local function display()
		local text = decimals > 0 and string.format("%." .. decimals .. "f", el.Value) or tostring(math.floor(el.Value + 0.5))
		valueLabel.Text = (info.Prefix or "") .. text .. (info.Suffix or "")
	end
	local function visual(animate)
		local a = (el.Value - el.Min) / (el.Max - el.Min)
		if animate then
			lib:Tween(fill, { Size = UDim2.fromScale(a, 1) }, 0.08)
			lib:Tween(thumb, { Position = UDim2.new(a, 0, 0.5, 0) }, 0.08)
		else
			fill.Size = UDim2.fromScale(a, 1)
			thumb.Position = UDim2.new(a, 0, 0.5, 0)
		end
		display()
	end
	el.Value = snap(info.Default or min)
	visual(false)

	function el:SetValue(value, silent)
		value = tonumber(value)
		if not value then
			return self
		end
		value = snap(value)
		if value == self.Value then
			return self
		end
		self.Value = value
		visual(true)
		if not silent then
			self:Fire(value)
		end
		return self
	end
	function el:Set(value)
		return self:SetValue(value)
	end
	function el:Get()
		return self.Value
	end
	function el:SetMin(v)
		self.Min = v
		self.Value = snap(self.Value)
		visual(false)
		return self
	end
	function el:SetMax(v)
		self.Max = v
		self.Value = snap(self.Value)
		visual(false)
		return self
	end
	for _, c in ipairs(lib:TrackDrag(track, function(ax)
		if not el.Disabled then
			el:SetValue(el.Min + (el.Max - el.Min) * ax)
		end
	end)) do
		table.insert(el.Connections, c)
	end
	if info.FireOnInit then
		el:Fire(el.Value)
	end
	return el
end

function Container:AddInput(idx, info)
	info = info or {}
	local lib = self.Lib
	local row, top, desc = buildRow(self, info, info.Text and 18 or 0)
	local el = newElement(self, "Input", idx, info, row, top)
	el.DescLabel = desc
	if info.Text then
		labelFor(el, info.Text)
	else
		top.Visible = false
	end
	local box = new("TextBox", {
		Name = "Box", BackgroundColor3 = lib.Theme.Element, BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, lib.M.Input), LayoutOrder = 2, ClearTextOnFocus = false,
		Text = "", PlaceholderText = info.Placeholder or "", TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true,
	}, row)
	new("UIPadding", { PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9) }, box)
	lib:Corner(box, 6)
	local stroke = lib:Stroke(box)
	lib:Bind(function()
		box.BackgroundColor3 = lib.Theme.Element
		box.TextColor3 = lib.Theme.Text
		box.PlaceholderColor3 = lib.Theme.Muted
		box.Font = lib:GetFont(1)
	end, box)
	el.Box = box
	local numeric = info.Numeric == true

	local function clean(text)
		if not numeric then
			return text
		end
		local n = tonumber(text)
		if not n then
			return nil
		end
		if info.Min then n = math.max(info.Min, n) end
		if info.Max then n = math.min(info.Max, n) end
		return n
	end
	local initial = info.Default
	if numeric then
		initial = tonumber(initial) or (info.Min or 0)
	else
		initial = initial and tostring(initial) or ""
	end
	el.Value = initial
	box.Text = tostring(initial)

	function el:SetValue(value, silent)
		local v = clean(value == nil and "" or tostring(value))
		if v == nil then
			return self
		end
		local changed = v ~= self.Value
		self.Value = v
		if box.Text ~= tostring(v) then
			box.Text = tostring(v)
		end
		if changed and not silent then
			self:Fire(v)
		end
		return self
	end
	function el:Get()
		return self.Value
	end
	function el:SetPlaceholder(text)
		box.PlaceholderText = tostring(text)
		return self
	end
	if info.Finished or numeric then
		el:Connect(box.FocusLost, function()
			local v = clean(box.Text)
			if v == nil then
				box.Text = tostring(el.Value)
			else
				el:SetValue(v)
				box.Text = tostring(v)
			end
		end)
	else
		el:Connect(box:GetPropertyChangedSignal("Text"), function()
			if box.Text ~= el.Value then
				el.Value = box.Text
				el:Fire(box.Text)
			end
		end)
	end
	el:Connect(box.Focused, function()
		lib:Tween(stroke, { Color = lib.Theme.Muted }, 0.12)
	end)
	el:Connect(box.FocusLost, function()
		lib:Tween(stroke, { Color = lib.Theme.Border }, 0.12)
	end)
	function el:OnDisabled(state)
		box.TextEditable = not state
	end
	return el
end

local function normalizeValues(values)
	local items = {}
	for _, v in ipairs(values or {}) do
		if type(v) == "table" then
			table.insert(items, { Name = v.Name or v.Value or v.Text, Text = v.Text or tostring(v.Name or v.Value), Icon = v.Icon, Image = v.Image })
		else
			table.insert(items, { Name = v, Text = tostring(v) })
		end
	end
	return items
end

function Container:AddDropdown(idx, info)
	info = info or {}
	local lib = self.Lib
	local row, top, desc = buildRow(self, info, info.Text and 18 or 0)
	local el = newElement(self, "Dropdown", idx, info, row, top)
	el.DescLabel = desc
	if info.Text then
		labelFor(el, info.Text)
	else
		top.Visible = false
	end
	el.Multi = info.Multi == true
	el.Items = normalizeValues(info.Values)
	el.Values = {}
	for _, item in ipairs(el.Items) do
		table.insert(el.Values, item.Name)
	end

	local button = new("TextButton", {
		Name = "Dropdown", BackgroundColor3 = lib.Theme.Element, BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, lib.M.Input), LayoutOrder = 2, Text = "", AutoButtonColor = false,
	}, row)
	lib:Corner(button, 6)
	lib:Stroke(button)
	lib:Bind(function()
		button.BackgroundColor3 = lib.Theme.Element
	end, button)
	onRowHover(lib, button, button, "Element", "Hover")
	local valueX = 9
	if info.Icon and not info.Text then
		local icon = lib:Icon(button, info.Icon, 14, "Muted")
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 9, 0.5, 0)
		el.IconHolder = icon
		valueX = 30
	end
	local valueLabel = lib:Text(button, "", 11, "Text", 1)
	valueLabel.Position = UDim2.fromOffset(valueX, 0)
	valueLabel.Size = UDim2.new(1, -(valueX + 26), 1, 0)
	valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local arrow = lib:Icon(button, "chevron-down", 14, "Muted")
	arrow.AnchorPoint = Vector2.new(0.5, 0.5)
	arrow.Position = UDim2.new(1, -16, 0.5, 0)

	local function exists(name)
		for _, item in ipairs(el.Items) do
			if item.Name == name then
				return true
			end
		end
		return false
	end
	local function display()
		if el.Multi then
			local names = {}
			for _, item in ipairs(el.Items) do
				if el.Value[item.Name] then
					table.insert(names, item.Text)
				end
			end
			valueLabel.Text = #names > 0 and table.concat(names, ", ") or (info.Placeholder or "None")
		else
			local text
			for _, item in ipairs(el.Items) do
				if item.Name == el.Value then
					text = item.Text
				end
			end
			valueLabel.Text = text or (info.Placeholder or "None")
		end
		valueLabel.TextColor3 = (el.Multi and next(el.Value) == nil or (not el.Multi and el.Value == nil)) and lib.Theme.Muted or lib.Theme.Text
	end
	el.Value = el.Multi and {} or nil
	lib:Bind(display, button)

	if el.Multi then
		el.Value = {}
		local def = info.Default
		if type(def) == "table" then
			for k, v in pairs(def) do
				if type(k) == "number" then
					if type(v) == "number" and el.Items[v] and info.Values[v] == nil then
						el.Value[el.Items[v].Name] = true
					else
						el.Value[v] = true
					end
				elseif v then
					el.Value[k] = true
				end
			end
		end
	else
		local def = info.Default
		if type(def) == "number" and el.Items[def] and not exists(def) then
			el.Value = el.Items[def].Name
		elseif def ~= nil and exists(def) then
			el.Value = def
		end
	end
	display()

	function el:SetValue(value, silent)
		if self.Multi then
			local nv = {}
			if type(value) == "table" then
				for k, v in pairs(value) do
					if type(k) == "number" then
						if exists(v) then nv[v] = true end
					elseif v and exists(k) then
						nv[k] = true
					end
				end
			end
			self.Value = nv
		else
			if value ~= nil and not exists(value) then
				return self
			end
			self.Value = value
		end
		display()
		if not silent then
			self:Fire(self.Value)
		end
		return self
	end
	function el:Get()
		return self.Value
	end
	function el:SetValues(values, keep)
		self.Items = normalizeValues(values)
		self.Values = {}
		for _, item in ipairs(self.Items) do
			table.insert(self.Values, item.Name)
		end
		if keep then
			if self.Multi then
				self:SetValue(self.Value, true)
			elseif self.Value ~= nil and not exists(self.Value) then
				self.Value = nil
			end
		else
			self.Value = self.Multi and {} or nil
		end
		display()
		return self
	end
	function el:Refresh(values)
		return self:SetValues(values, true)
	end
	function el:GetActive()
		if self.Multi then
			local list = {}
			for _, item in ipairs(self.Items) do
				if self.Value[item.Name] then
					table.insert(list, item.Name)
				end
			end
			return list
		end
		return self.Value
	end

	button.Activated:Connect(function()
		if el.Disabled then
			return
		end
		if lib.ActivePopup then
			lib:ClosePopup()
			return
		end
		lib:ShowList(button, el.Items, {
			Multi = el.Multi, Searchable = info.Searchable, MaxVisible = info.MaxVisible,
			IsSelected = function(item)
				if el.Multi then
					return el.Value[item.Name] == true
				end
				return el.Value == item.Name
			end,
			OnSelect = function(item)
				if el.Multi then
					local nv = copyTable(el.Value)
					nv[item.Name] = (not nv[item.Name]) or nil
					el:SetValue(nv)
				else
					if el.Value == item.Name and info.AllowNull then
						el:SetValue(nil)
					else
						el:SetValue(item.Name)
					end
				end
			end,
			OnClose = function()
				lib:Tween(arrow, { Rotation = 0 }, 0.12)
			end,
		})
		lib:Tween(arrow, { Rotation = 180 }, 0.12)
	end)
	return el
end

function Container:AddImage(a, b)
	local idx, info
	if type(a) == "table" then
		info = a
	else
		idx, info = a, b or {}
	end
	local lib = self.Lib
	local row, top = buildRow(self, info, info.Height or 90)
	local el = newElement(self, "Image", idx, info, row, top)
	local frame = new("Frame", { Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ClipsDescendants = true }, top)
	lib:Themed(frame, "BackgroundColor3", "Element")
	lib:Corner(frame, info.Rounding or 7)
	lib:Stroke(frame)
	local image = new("ImageLabel", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Fit,
		Image = toAsset(info.Image) or "", ImageTransparency = info.Transparency or 0,
	}, frame)
	local scaleName = info.ScaleType
	if scaleName and enumItem(Enum.ScaleType, scaleName) then
		image.ScaleType = enumItem(Enum.ScaleType, scaleName)
	end
	el.Value = info.Image
	el.ImageLabel = image
	function el:SetImage(asset)
		self.Value = asset
		image.Image = toAsset(asset) or ""
		return self
	end
	function el:SetValue(asset)
		return self:SetImage(asset)
	end
	function el:SetHeight(h)
		top.Size = UDim2.new(1, 0, 0, h)
		return self
	end
	function el:SetScaleType(name)
		if enumItem(Enum.ScaleType, name) then
			image.ScaleType = enumItem(Enum.ScaleType, name)
		end
		return self
	end
	if info.Callback then
		local click = new("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1) }, frame)
		click.Activated:Connect(function()
			lib:Defer(info.Callback, el)
		end)
	end
	return el
end

function Spectra:CreateBox(parent, opts)
	opts = opts or {}
	local style = opts.Style or "Surface"
	local frame = new("Frame", {
		Name = opts.Name or "Box", BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = opts.Order or 0,
	}, parent)
	self:Themed(frame, "BackgroundColor3", style)
	self:Corner(frame, style == "Surface" and 9 or 7)
	self:Stroke(frame, style == "Surface" and "Border" or "Border")
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, frame)

	local hasHeader = opts.Title ~= nil and opts.Title ~= ""
	local box = { Frame = frame }
	if hasHeader then
		local headerH = opts.Description and 40 or 30
		local header = new("TextButton", {
			Name = "Header", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
			Size = UDim2.new(1, 0, 0, headerH), LayoutOrder = 1, Active = opts.Collapsible == true,
		}, frame)
		local x = 12
		if opts.Icon then
			local icon = self:Icon(header, opts.Icon, 14, "Muted")
			icon.Position = UDim2.new(0, 12, 0, opts.Description and 8 or 8)
			x = 32
			box.IconHolder = icon
		end
		local title = self:Text(header, opts.Title, 12, "Text", 3)
		title.Position = UDim2.fromOffset(x, opts.Description and 5 or 0)
		title.Size = UDim2.new(1, -(x + 30), 0, opts.Description and 18 or headerH)
		box.Title = title
		if opts.Description then
			local d = self:Text(header, opts.Description, 10, "Muted", 1)
			d.Position = UDim2.fromOffset(x, 22)
			d.Size = UDim2.new(1, -(x + 12), 0, 14)
			d.TextTruncate = Enum.TextTruncate.AtEnd
			box.Description = d
		end
		local chevron
		if opts.Collapsible then
			chevron = self:Icon(header, "chevron-down", 14, "Muted")
			chevron.AnchorPoint = Vector2.new(0.5, 0.5)
			chevron.Position = UDim2.new(1, -18, 0, headerH / 2)
		end
		local lineHolder = new("Frame", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 2,
		}, frame)
		local line = new("Frame", {
			Position = UDim2.fromOffset(self.M.Pad, 0), Size = UDim2.new(1, -2 * self.M.Pad, 0, 1), BorderSizePixel = 0,
		}, lineHolder)
		self:Themed(line, "BackgroundColor3", "Border")
		box.Header = header
		box.HeaderLine = lineHolder
		box.Chevron = chevron
	end

	local body
	if opts.Height then
		body = new("ScrollingFrame", {
			Name = "Body", BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
			Size = UDim2.new(1, 0, 0, opts.Height), LayoutOrder = 3, CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
		}, frame)
		self:Themed(body, "ScrollBarImageColor3", "Muted")
		self:RegisterScroller(body)
	else
		body = new("Frame", {
			Name = "Body", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 3,
		}, frame)
	end
	local pad = self.M.Pad
	new("UIPadding", {
		PaddingTop = UDim.new(0, hasHeader and 8 or pad), PaddingBottom = UDim.new(0, pad),
		PaddingLeft = UDim.new(0, pad), PaddingRight = UDim.new(0, pad),
	}, body)
	new("UIListLayout", { Padding = UDim.new(0, math.max(6, self.M.Gap - 1)), SortOrder = Enum.SortOrder.LayoutOrder }, body)
	box.Body = body

	local collapsed = false
	function box.SetCollapsed(state)
		collapsed = state == true
		body.Visible = not collapsed
		if box.HeaderLine then
			box.HeaderLine.Visible = not collapsed
		end
		if box.Chevron then
			self:Tween(box.Chevron, { Rotation = collapsed and -90 or 0 }, 0.15)
		end
	end
	if opts.Collapsible and box.Header then
		box.Header.Activated:Connect(function()
			box.SetCollapsed(not collapsed)
		end)
	end
	if opts.Collapsed then
		box.SetCollapsed(true)
	end
	return box
end

local function containerFromBox(lib, box, extra)
	local c = setmetatable({
		Lib = lib, Holder = box.Body, Frame = box.Frame, Box = box, Order = 0, Children = {},
	}, Container)
	if extra then
		for k, v in pairs(extra) do
			c[k] = v
		end
	end
	return c
end
Spectra._ContainerFromBox = containerFromBox

function Container:SetTitle(text)
	if self.Box and self.Box.Title then
		self.Box.Title.Text = tostring(text)
	end
	return self
end

function Container:SetDescription(text)
	if self.Box and self.Box.Description then
		self.Box.Description.Text = tostring(text)
	end
	return self
end

function Container:SetVisible(state)
	if self.Frame then
		self.Frame.Visible = state ~= false
	end
	return self
end

function Container:SetCollapsed(state)
	if self.Box and self.Box.SetCollapsed then
		self.Box.SetCollapsed(state)
	end
	return self
end

function Container:Destroy()
	if self.Frame and self.Frame.Parent then
		self.Frame:Destroy()
	end
end

function Container:AddSubsection(title, description, opts)
	opts = opts or {}
	self.Order = (self.Order or 0) + 1
	local box = self.Lib:CreateBox(self.Holder, {
		Title = title, Description = description, Style = "Element", Order = self.Order,
		Icon = opts.Icon, Collapsible = opts.Collapsible, Collapsed = opts.Collapsed, Height = opts.Height,
		Name = "Subsection",
	})
	return containerFromBox(self.Lib, box)
end

function Container:CreateLabel(text)
	return self:AddLabel(text)
end

function Container:CreateButton(text, callback, iconName)
	return self:AddButton({ Text = text, Func = callback, Icon = iconName or "Chevron" })
end

function Container:CreateButtonRow(items)
	local first
	local buttons = {}
	for _, item in ipairs(items or {}) do
		local info = { Text = item.Name or item.Text, Func = item.Callback or item.Func, Icon = item.Icon or "Chevron" }
		if not first then
			first = self:AddButton(info)
			table.insert(buttons, first)
		else
			table.insert(buttons, first:AddButton(info))
		end
	end
	return buttons
end

function Container:CreateToggle(text, default, callback)
	return self:AddToggle(nil, { Text = text, Default = default == true, Callback = callback, FireOnInit = callback ~= nil })
end

function Container:CreateColorPicker(text, default, callback)
	return self:AddColorPicker(nil, { Text = text, Default = default, Callback = callback })
end

function Container:CreateCheckbox(...) return self:AddCheckbox(...) end
function Container:CreateDropdown(...) return self:AddDropdown(...) end
function Container:CreateSlider(...) return self:AddSlider(...) end
function Container:CreateInput(...) return self:AddInput(...) end
function Container:CreateKeybind(...) return self:AddKeyPicker(...) end
function Container:CreateDivider(...) return self:AddDivider(...) end
function Container:CreateImage(...) return self:AddImage(...) end
function Container:CreateViewport(...) return self:AddViewport(...) end
function Container:AddKeybind(...) return self:AddKeyPicker(...) end

local function parseColor(value)
	if typeof(value) == "Color3" then
		return value
	elseif type(value) == "string" then
		return fromHex(value)
	elseif type(value) == "table" then
		if value.Color then
			return parseColor(value.Color)
		end
		if value.R and value.G and value.B then
			return Color3.new(value.R, value.G, value.B)
		end
	end
	return nil
end

local function rainbow()
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
		ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
		ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
		ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
		ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
		ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1)),
	})
end

local function makeAddon(parentEl, kind, idx, info)
	local lib = parentEl.Lib
	if idx == nil then
		autoId += 1
		idx = "_" .. kind .. autoId
	end
	local addon = setmetatable({
		Lib = lib, Container = parentEl.Container, Parent = parentEl, Type = kind, Idx = idx, Info = info or {},
		Listeners = {}, Connections = {}, Cleanups = {}, Addons = {}, Destroyed = false, Disabled = false,
	}, Element)
	lib.Options[idx] = addon
	table.insert(parentEl.Addons, addon)
	return addon
end

function Element:AddColorPicker(idx, info)
	info = info or {}
	local lib = self.Lib
	if not self.AddonHolder then
		error("[Spectra] AddColorPicker precisa de um Toggle ou Label como pai")
	end
	local picker = makeAddon(self, "ColorPicker", idx, info)
	local default = parseColor(info.Default) or Color3.new(1, 1, 1)
	picker.Hue, picker.Sat, picker.Vib = default:ToHSV()
	picker.Value = default
	picker.HasAlpha = info.Transparency ~= nil
	picker.Transparency = info.Transparency or 0
	picker.Title = info.Title or info.Text or "Color"
	picker.Open = false
	picker.DragLists = {}

	local swatch = new("TextButton", {
		Name = "ColorSwatch", Size = UDim2.fromOffset(26, 14), BorderSizePixel = 0, Text = "",
		AutoButtonColor = false, LayoutOrder = #self.Addons,
	}, self.AddonHolder)
	lib:Corner(swatch, 5)
	lib:Stroke(swatch)
	picker.Swatch = swatch
	table.insert(picker.Cleanups, function()
		swatch:Destroy()
	end)

	local win, svFrame, svCursor, hueCursor, alphaCursor, alphaFill, preview, previewOld, hexBox, rgbBoxes
	local original, originalAlpha = picker.Value, picker.Transparency

	local function refreshWindow()
		if not win then
			return
		end
		svFrame.BackgroundColor3 = Color3.fromHSV(picker.Hue, 1, 1)
		svCursor.Position = UDim2.fromScale(picker.Sat, 1 - picker.Vib)
		hueCursor.Position = UDim2.fromScale(picker.Hue, 0.5)
		if alphaCursor then
			alphaCursor.Position = UDim2.fromScale(picker.Transparency, 0.5)
			alphaFill.BackgroundColor3 = picker.Value
		end
		preview.BackgroundColor3 = picker.Value
		previewOld.BackgroundColor3 = original
		if not hexBox:IsFocused() then
			hexBox.Text = toHex(picker.Value)
		end
		local comps = { picker.Value.R, picker.Value.G, picker.Value.B }
		for i, box in ipairs(rgbBoxes) do
			if not box:IsFocused() then
				box.Text = tostring(math.floor(comps[i] * 255 + 0.5))
			end
		end
	end

	local function apply(silent)
		picker.Value = Color3.fromHSV(picker.Hue, picker.Sat, picker.Vib)
		swatch.BackgroundColor3 = picker.Value
		swatch.BackgroundTransparency = picker.Transparency
		refreshWindow()
		if not silent then
			picker:Fire(picker.Value, picker.Transparency)
		end
	end
	swatch.BackgroundColor3 = picker.Value
	swatch.BackgroundTransparency = picker.Transparency

	function picker:SetValue(value, transparency, silent)
		if type(transparency) == "boolean" then
			silent, transparency = transparency, nil
		end
		local color = parseColor(value)
		if type(value) == "table" and value.Transparency and transparency == nil then
			transparency = value.Transparency
		end
		if not color then
			return self
		end
		local h, s, v = color:ToHSV()
		if v == 0 then
			h, s = self.Hue, self.Sat
		elseif s == 0 then
			h = self.Hue
		end
		self.Hue, self.Sat, self.Vib = h, s, v
		if transparency ~= nil then
			self.Transparency = math.clamp(transparency, 0, 1)
		end
		apply(silent)
		return self
	end
	function picker:SetValueRGB(color, transparency)
		return self:SetValue(color, transparency)
	end
	function picker:SetHSV(h, s, v)
		self.Hue, self.Sat, self.Vib = math.clamp(h, 0, 1), math.clamp(s, 0, 1), math.clamp(v, 0, 1)
		apply()
		return self
	end
	function picker:SetTransparency(t)
		self.Transparency = math.clamp(t, 0, 1)
		apply()
		return self
	end
	function picker:Get()
		return self.Value
	end
	function picker:GetHex()
		return toHex(self.Value)
	end

	local function build()
		local bottomH = picker.HasAlpha and 132 or 112
		local defaultSize = Vector2.new(244, picker.HasAlpha and 318 or 298)
		win = new("Frame", {
			Name = "ColorWindow", Size = UDim2.fromOffset(defaultSize.X, defaultSize.Y), BorderSizePixel = 0,
			Visible = false, Active = true, ClipsDescendants = true,
		}, lib.FloatLayer)
		lib:Themed(win, "BackgroundColor3", "Surface")
		lib:Corner(win, 10)
		lib:Stroke(win)
		lib:Scaled(win)
		table.insert(picker.Cleanups, function()
			win:Destroy()
		end)

		local titleBar = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30) }, win)
		local titleX = 12
		if info.Icon then
			local titleIcon = lib:Icon(titleBar, info.Icon, 14, "Muted")
			titleIcon.AnchorPoint = Vector2.new(0, 0.5)
			titleIcon.Position = UDim2.new(0, 12, 0.5, 0)
			titleX = 32
		end
		local title = lib:Text(titleBar, picker.Title, 11, "Text", 3)
		title.Position = UDim2.fromOffset(titleX, 0)
		title.Size = UDim2.new(1, -(titleX + 32), 1, 0)
		title.TextTruncate = Enum.TextTruncate.AtEnd
		local close = lib:IconButton(titleBar, "x", 14, "Muted", function()
			picker:Close()
		end)
		close.AnchorPoint = Vector2.new(1, 0.5)
		close.Position = UDim2.new(1, -4, 0.5, 0)
		table.insert(picker.DragLists, lib:MakeDraggable(titleBar, win))
		win.InputBegan:Connect(function(input)
			if isPress(input) then
				lib:BringToFront(win)
			end
		end)

		svFrame = new("Frame", {
			Name = "SV", Position = UDim2.fromOffset(8, 34), Size = UDim2.new(1, -16, 1, -(34 + bottomH + 14)),
			BorderSizePixel = 0,
		}, win)
		new("UICorner", { CornerRadius = UDim.new(0, 6) }, svFrame)
		local white = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Active = false }, svFrame)
		new("UICorner", { CornerRadius = UDim.new(0, 6) }, white)
		new("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) }, white)
		local black = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Active = false }, svFrame)
		new("UICorner", { CornerRadius = UDim.new(0, 6) }, black)
		new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }) }, black)
		svCursor = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1,
		}, svFrame)
		new("UICorner", { CornerRadius = UDim.new(1, 0) }, svCursor)
		new("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2 }, svCursor)

		local bottom = new("Frame", {
			BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, -8),
			Size = UDim2.new(1, -16, 0, bottomH),
		}, win)
		new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, bottom)

		local hueBar = new("Frame", { Size = UDim2.new(1, 0, 0, 14), BorderSizePixel = 0, LayoutOrder = 1 }, bottom)
		new("UICorner", { CornerRadius = UDim.new(0, 7) }, hueBar)
		new("UIGradient", { Color = rainbow() }, hueBar)
		hueCursor = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 18), BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
		}, hueBar)
		new("UICorner", { CornerRadius = UDim.new(0, 3) }, hueCursor)
		new("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1, Transparency = 0.4 }, hueCursor)

		if picker.HasAlpha then
			local alphaBase = new("Frame", { Size = UDim2.new(1, 0, 0, 14), BorderSizePixel = 0, LayoutOrder = 2 }, bottom)
			lib:Themed(alphaBase, "BackgroundColor3", "Element")
			new("UICorner", { CornerRadius = UDim.new(0, 7) }, alphaBase)
			lib:Stroke(alphaBase)
			alphaFill = new("Frame", { Size = UDim2.fromScale(1, 1), BorderSizePixel = 0 }, alphaBase)
			new("UICorner", { CornerRadius = UDim.new(0, 7) }, alphaFill)
			new("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) }, alphaFill)
			alphaCursor = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 18), BorderSizePixel = 0,
				BackgroundColor3 = Color3.new(1, 1, 1),
			}, alphaBase)
			new("UICorner", { CornerRadius = UDim.new(0, 3) }, alphaCursor)
			new("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1, Transparency = 0.4 }, alphaCursor)
			for _, c in ipairs(lib:TrackDrag(alphaBase, function(ax)
				picker.Transparency = round(ax, 2)
				apply()
			end)) do
				table.insert(picker.Connections, c)
			end
		end

		local hexRow = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 3 }, bottom)
		local previewFrame = new("Frame", { Size = UDim2.fromOffset(46, 26), BorderSizePixel = 0, ClipsDescendants = true }, hexRow)
		lib:Corner(previewFrame, 6)
		lib:Stroke(previewFrame)
		previewOld = new("Frame", { Size = UDim2.fromScale(0.5, 1), BorderSizePixel = 0 }, previewFrame)
		preview = new("Frame", { Position = UDim2.fromScale(0.5, 0), Size = UDim2.fromScale(0.5, 1), BorderSizePixel = 0 }, previewFrame)
		local function styledBox(parent, placeholder)
			local box = new("TextBox", {
				BackgroundColor3 = lib.Theme.Element, BorderSizePixel = 0, ClearTextOnFocus = false, Text = "",
				PlaceholderText = placeholder or "", TextSize = 11,
			}, parent)
			lib:Corner(box, 6)
			lib:Stroke(box)
			lib:Bind(function()
				box.BackgroundColor3 = lib.Theme.Element
				box.TextColor3 = lib.Theme.Text
				box.PlaceholderColor3 = lib.Theme.Muted
				box.Font = lib:GetFont(1)
			end, box)
			return box
		end
		hexBox = styledBox(hexRow, "RRGGBB")
		hexBox.Position = UDim2.fromOffset(52, 0)
		hexBox.Size = UDim2.new(1, -52, 1, 0)
		hexBox.FocusLost:Connect(function()
			local c = fromHex(hexBox.Text)
			if c then
				picker:SetValue(c)
			else
				refreshWindow()
			end
		end)

		local rgbRow = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 4 }, bottom)
		new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, rgbRow)
		rgbBoxes = {}
		for i, name in ipairs({ "R", "G", "B" }) do
			local box = styledBox(rgbRow, name)
			box.LayoutOrder = i
			box.Size = UDim2.new(1 / 3, -4, 1, 0)
			box.FocusLost:Connect(function()
				local n = tonumber(box.Text)
				if n then
					local r, g, b = picker.Value.R * 255, picker.Value.G * 255, picker.Value.B * 255
					local v = math.clamp(math.floor(n + 0.5), 0, 255)
					if i == 1 then r = v elseif i == 2 then g = v else b = v end
					picker:SetValue(Color3.fromRGB(r, g, b))
				end
				refreshWindow()
			end)
			rgbBoxes[i] = box
		end

		local btnRow = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), LayoutOrder = 5 }, bottom)
		new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, btnRow)
		local function actionButton(text, order, callback)
			local b = new("TextButton", {
				BackgroundColor3 = lib.Theme.Element, BorderSizePixel = 0, Text = text, TextSize = 11,
				AutoButtonColor = false, Size = UDim2.new(0.5, -3, 1, 0), LayoutOrder = order,
			}, btnRow)
			lib:Corner(b, 6)
			lib:Stroke(b)
			lib:Bind(function()
				b.BackgroundColor3 = lib.Theme.Element
				b.TextColor3 = lib.Theme.Text
				b.Font = lib:GetFont(2)
			end, b)
			onRowHover(lib, b, b, "Element", "Hover")
			b.Activated:Connect(callback)
			return b
		end
		actionButton("Restore", 1, function()
			picker:SetValue(original, originalAlpha)
		end)
		actionButton("Confirm", 2, function()
			picker:Close()
		end)

		for _, c in ipairs(lib:TrackDrag(svFrame, function(ax, ay)
			picker.Sat = ax
			picker.Vib = 1 - ay
			apply()
		end)) do
			table.insert(picker.Connections, c)
		end
		for _, c in ipairs(lib:TrackDrag(hueBar, function(ax)
			picker.Hue = math.clamp(ax, 0, 0.9999)
			apply()
		end)) do
			table.insert(picker.Connections, c)
		end

		if info.Resizable ~= false then
			local grip = new("TextButton", {
				AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -2, 1, -2), Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5,
			}, win)
			local gripIcon = lib:Icon(grip, "arrow-down-right", 12, "Muted")
			gripIcon.AnchorPoint = Vector2.new(0.5, 0.5)
			gripIcon.Position = UDim2.fromScale(0.5, 0.5)
			table.insert(picker.DragLists, lib:MakeResizable(grip, win, Vector2.new(210, picker.HasAlpha and 290 or 270), Vector2.new(480, 560)))
		end
		refreshWindow()
	end

	function picker:Open()
		if self.Destroyed then
			return
		end
		lib:ClosePopup()
		if not win then
			build()
			local ap = swatch.AbsolutePosition
			win.Position = UDim2.fromOffset(ap.X - 200, ap.Y + 26)
		end
		original, originalAlpha = self.Value, self.Transparency
		refreshWindow()
		win.Visible = true
		lib:BringToFront(win)
		lib:ClampToScreen(win)
		lib.OpenColorPickers[self] = true
		self.IsOpen = true
	end
	function picker:Close()
		if win then
			win.Visible = false
		end
		lib.OpenColorPickers[self] = nil
		self.IsOpen = false
	end
	table.insert(picker.Cleanups, function()
		lib.OpenColorPickers[picker] = nil
		for _, list in ipairs(picker.DragLists) do
			lib:Disconnect(list)
		end
	end)

	swatch.Activated:Connect(function()
		if picker.IsOpen then
			picker:Close()
		else
			picker:Open()
		end
	end)
	return picker
end

function Container:AddColorPicker(idx, info)
	info = info or {}
	local label = self:AddLabel({ Text = info.Text or info.Title or tostring(idx or "Color"), Description = info.Description })
	local picker = label:AddColorPicker(idx, info)
	picker.Label = label
	return picker
end

local function normalizeKey(value)
	if typeof(value) == "EnumItem" then
		if value.EnumType == Enum.KeyCode then
			return value == Enum.KeyCode.Unknown and "None" or value.Name
		elseif value == Enum.UserInputType.MouseButton1 then
			return "MB1"
		elseif value == Enum.UserInputType.MouseButton2 then
			return "MB2"
		elseif value == Enum.UserInputType.MouseButton3 then
			return "MB3"
		end
		return "None"
	elseif type(value) == "string" and value ~= "" then
		if value:match("^MB[123]$") then
			return value
		end
		if enumItem(Enum.KeyCode, value) then
			return value
		end
	end
	return "None"
end
Spectra.Util.NormalizeKey = normalizeKey

local KeyModes = { "Toggle", "Hold", "Always", "Press" }

function Element:AddKeyPicker(idx, info)
	info = info or {}
	local lib = self.Lib
	if not self.AddonHolder then
		error("[Spectra] AddKeyPicker precisa de um Toggle ou Label como pai")
	end
	local picker = makeAddon(self, "KeyPicker", idx, info)
	picker.Key = normalizeKey(info.Default)
	picker.Mode = table.find(KeyModes, info.Mode) and info.Mode or "Toggle"
	picker.Toggled = false
	picker.Holding = false
	picker.Binding = false
	picker.NoUI = info.NoUI == true
	picker.HiddenInMenu = info.HiddenInMenu == true
	picker.ClickListeners = {}
	picker.KeyListeners = {}
	local syncing = false

	local button = new("TextButton", {
		Name = "KeyButton", Size = UDim2.new(0, 0, 0, lib.IsMobile and 22 or 18), AutomaticSize = Enum.AutomaticSize.X,
		BorderSizePixel = 0, Text = "", AutoButtonColor = false, LayoutOrder = #self.Addons,
	}, self.AddonHolder)
	lib:Corner(button, 5)
	lib:Stroke(button)
	new("UIPadding", { PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7) }, button)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
	}, button)
	if info.Icon then
		local keyIcon = lib:Icon(button, info.Icon, 12, "Muted")
		keyIcon.LayoutOrder = 1
	end
	local text = lib:Text(button, "", 10, false, 2)
	text.Size = UDim2.new(0, 0, 1, 0)
	text.AutomaticSize = Enum.AutomaticSize.X
	text.LayoutOrder = 2
	picker.Button = button
	table.insert(picker.Cleanups, function()
		if picker.Binding then
			picker.Binding = false
			lib.CapturingKey = false
			if lib.CapturingPicker == picker then
				lib.CapturingPicker = nil
			end
		end
		button:Destroy()
		lib:_KeybindRemove(picker)
		lib.KeyPickers[picker] = nil
	end)
	lib.KeyPickers[picker] = true

	function picker:GetState()
		if self.Mode == "Always" then
			return true
		elseif self.Mode == "Toggle" then
			return self.Toggled
		elseif self.Mode == "Hold" then
			return self.Holding
		end
		return false
	end

	local function visual()
		local t = lib.Theme
		local active = picker:GetState()
		if picker.Binding then
			text.Text = "..."
		elseif picker.Key == "None" then
			text.Text = "None"
		else
			text.Text = "[" .. keyDisplay(picker.Key) .. "]"
		end
		text.TextColor3 = (active or picker.Binding) and t.Text or t.Muted
		button.BackgroundColor3 = active and t.Element:Lerp(t.Accent, 0.18) or t.Element
	end
	lib:Bind(visual, button)

	local function stateChanged(silent)
		visual()
		lib:_KeybindRefresh(picker)
		if self.Type == "Toggle" and info.SyncToggleState and not syncing then
			syncing = true
			self:SetValue(picker:GetState(), silent)
			syncing = false
		end
		if not silent then
			picker:Fire(picker:GetState())
		end
	end

	function picker:SetState(value, silent)
		local old = self:GetState()
		if self.Mode == "Toggle" then
			self.Toggled = value == true
		elseif self.Mode == "Hold" then
			self.Holding = value == true
		end
		if old ~= self:GetState() then
			stateChanged(silent)
		end
		return self
	end

	function picker:Activate()
		if self.Mode == "Always" then
			return
		end
		if self.Mode == "Press" then
			for _, fn in ipairs(self.ClickListeners) do
				lib:Defer(fn)
			end
			if info.Clicked then
				lib:Defer(info.Clicked)
			end
			return
		end
		self:SetState(not self:GetState())
		for _, fn in ipairs(self.ClickListeners) do
			lib:Defer(fn)
		end
		if info.Clicked then
			lib:Defer(info.Clicked)
		end
	end
	function picker:OnClick(fn)
		table.insert(self.ClickListeners, fn)
		return self
	end
	function picker:OnKeyChanged(fn)
		table.insert(self.KeyListeners, fn)
		return self
	end
	function picker:SetKey(key, silent)
		self.Key = normalizeKey(key)
		if self.Key == "None" and self.Holding then
			self:SetState(false, silent)
		end
		visual()
		lib:_KeybindRefresh(self)
		if not silent then
			if info.ChangedCallback then
				lib:Defer(info.ChangedCallback, self.Key, self.Mode)
			end
			for _, fn in ipairs(self.KeyListeners) do
				lib:Defer(fn, self.Key, self.Mode)
			end
		end
		return self
	end
	function picker:SetMode(mode, silent)
		if not table.find(KeyModes, mode) then
			return self
		end
		local old = self:GetState()
		self.Mode = mode
		if mode ~= "Toggle" then self.Toggled = false end
		if mode ~= "Hold" then self.Holding = false end
		visual()
		lib:_KeybindRefresh(self)
		if old ~= self:GetState() then
			stateChanged(silent)
		end
		if not silent then
			if info.ChangedCallback then
				lib:Defer(info.ChangedCallback, self.Key, self.Mode)
			end
			for _, fn in ipairs(self.KeyListeners) do
				lib:Defer(fn, self.Key, self.Mode)
			end
		end
		return self
	end
	function picker:SetValue(value, silent)
		if type(value) == "table" then
			local key = value.Key or value[1]
			local mode = value.Mode or value[2]
			if key ~= nil then
				self:SetKey(key, true)
			end
			if mode then
				self:SetMode(mode, true)
			end
			if not silent then
				if info.ChangedCallback then
					lib:Defer(info.ChangedCallback, self.Key, self.Mode)
				end
				for _, fn in ipairs(self.KeyListeners) do
					lib:Defer(fn, self.Key, self.Mode)
				end
			end
		end
		return self
	end
	function picker:GetValue()
		return { Key = self.Key, Mode = self.Mode }
	end
	function picker:SetHiddenInMenu(state)
		self.HiddenInMenu = state == true
		lib:_KeybindRefresh(self)
		return self
	end
	function picker:GetText()
		return info.Text or (self.Parent and self.Parent.Info and self.Parent.Info.Text) or tostring(self.Idx)
	end

	if self.Type == "Toggle" and info.SyncToggleState then
		local previous = self.OnValueChanged
		self.OnValueChanged = function(toggle, value)
			if previous then
				previous(toggle, value)
			end
			if not syncing then
				syncing = true
				if picker.Mode == "Toggle" then
					picker.Toggled = value
				elseif picker.Mode == "Hold" then
					picker.Holding = value
				end
				visual()
				lib:_KeybindRefresh(picker)
				syncing = false
			end
		end
		if self.Value then
			picker.Toggled = true
			picker.Holding = true
		end
	end

	local function finishCapture()
		picker.Binding = false
		lib.CapturingKey = false
		lib.LastCapture = tick()
		if lib.CapturingPicker == picker then
			lib.CapturingPicker = nil
		end
		visual()
	end

	function picker:CancelBinding()
		if self.Binding then
			finishCapture()
		end
	end

	picker:Connect(UserInputService.InputBegan, function(input, processed)
		if picker.Destroyed then
			return
		end
		if picker.Binding then
			if tick() - picker.BindStart < 0.05 or UserInputService:GetFocusedTextBox() then
				return
			end
			local name = inputKeyName(input)
			if not name or name == "MB1" then
				return
			end
			if name == "Escape" then
				finishCapture()
				return
			end
			finishCapture()
			if name == "Backspace" then
				name = "None"
			end
			picker:SetKey(name)
			return
		end
		if lib.CapturingKey or tick() - lib.LastCapture < 0.2 then
			return
		end
		if processed or picker.Key == "None" then
			return
		end
		if inputMatches(input, picker.Key) then
			if picker.Mode == "Hold" then
				picker:SetState(true)
				for _, fn in ipairs(picker.ClickListeners) do
					lib:Defer(fn)
				end
				if info.Clicked then
					lib:Defer(info.Clicked)
				end
			else
				picker:Activate()
			end
		end
	end)
	picker:Connect(UserInputService.InputEnded, function(input)
		if picker.Mode == "Hold" and picker.Holding and inputMatches(input, picker.Key) then
			picker:SetState(false)
		end
	end)

	button.Activated:Connect(function()
		if picker.Disabled then
			return
		end
		if lib.IsMobile or not UserInputService.KeyboardEnabled then
			picker:ShowModes()
			return
		end
		if picker.Binding then
			finishCapture()
			return
		end
		if lib.CapturingPicker and lib.CapturingPicker ~= picker then
			lib.CapturingPicker:CancelBinding()
		end
		lib:ClosePopup()
		picker.Binding = true
		picker.BindStart = tick()
		lib.CapturingKey = true
		lib.CapturingPicker = picker
		visual()
	end)
	button.MouseButton2Click:Connect(function()
		if picker.Binding then
			finishCapture()
		end
		picker:ShowModes()
	end)
	function picker:ShowModes()
		local items = {}
		for _, m in ipairs(KeyModes) do
			table.insert(items, { Name = m, Text = m })
		end
		lib:ShowList(button, items, {
			MinWidth = 120,
			IsSelected = function(item)
				return item.Name == picker.Mode
			end,
			OnSelect = function(item)
				picker:SetMode(item.Name)
			end,
		})
	end

	visual()
	lib:_KeybindAdd(picker)
	if picker.Mode == "Always" then
		task.defer(function()
			picker:Fire(true)
		end)
	end
	return picker
end

function Container:AddKeyPicker(idx, info)
	info = info or {}
	local label = self:AddLabel({ Text = info.Text or tostring(idx or "Keybind"), Description = info.Description })
	local picker = label:AddKeyPicker(idx, info)
	picker.Label = label
	return picker
end

function Container:AddViewport(idx, info)
	info = info or {}
	local lib = self.Lib
	local row, top = buildRow(self, info, info.Height or 160)
	local el = newElement(self, "Viewport", idx, info, row, top)
	local frame = new("ViewportFrame", {
		Name = "Viewport", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0,
		Ambient = Color3.fromRGB(170, 170, 170), LightColor = Color3.fromRGB(255, 255, 255),
		LightDirection = Vector3.new(-1, -1.5, -0.8),
	}, top)
	lib:Themed(frame, "BackgroundColor3", "Element")
	lib:Corner(frame, 7)
	lib:Stroke(frame)
	local camera = new("Camera", { FieldOfView = info.FieldOfView or 50 }, frame)
	frame.CurrentCamera = camera
	local world = new("WorldModel", nil, frame)

	local yaw, pitch = math.rad(info.Yaw or 25), math.rad(info.Pitch or -12)
	local zoom = math.clamp(info.Zoom or 1, 0.25, 8)
	local center, radius = Vector3.zero, 4
	el.Model = nil
	el.AutoRotate = info.AutoRotate == true
	el.RotateSpeed = info.RotateSpeed or 25

	local function updateCamera()
		local fov = math.rad(camera.FieldOfView)
		local base = (radius / math.tan(fov / 2)) * 1.15
		local rot = CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
		camera.CFrame = CFrame.new(center) * rot * CFrame.new(0, 0, base / zoom)
	end
	updateCamera()

	function el:SetModel(model)
		world:ClearAllChildren()
		self.Model = nil
		if model == nil then
			return self
		end
		if typeof(model) ~= "Instance" or not (model:IsA("Model") or model:IsA("BasePart")) then
			warn("[Spectra] Viewport:SetModel espera um Model ou BasePart")
			return self
		end
		local ok, clone = pcall(function()
			return model:Clone()
		end)
		if not ok or not clone then
			warn("[Spectra] Viewport: não foi possível clonar o modelo (Archivable = false?)")
			return self
		end
		clone.Parent = world
		self.Model = clone
		local cf, size
		if clone:IsA("Model") then
			cf, size = clone:GetBoundingBox()
		else
			cf, size = clone.CFrame, clone.Size
		end
		center = cf.Position
		radius = math.max(size.Magnitude / 2, 0.5)
		updateCamera()
		return self
	end
	function el:GetModel()
		return self.Model
	end
	function el:Refresh(model)
		return self:SetModel(model or self.Source)
	end
	function el:SetZoom(value)
		zoom = math.clamp(tonumber(value) or 1, 0.25, 8)
		updateCamera()
		return self
	end
	function el:GetZoom()
		return zoom
	end
	function el:SetRotation(yawDeg, pitchDeg)
		yaw = math.rad(yawDeg or 0)
		pitch = math.clamp(math.rad(pitchDeg or 0), -1.3, 1.3)
		updateCamera()
		return self
	end
	function el:SetFieldOfView(value)
		camera.FieldOfView = math.clamp(value, 20, 100)
		updateCamera()
		return self
	end
	local spinConn
	function el:SetAutoRotate(state, speed)
		self.AutoRotate = state == true
		self.RotateSpeed = speed or self.RotateSpeed
		if spinConn then
			spinConn:Disconnect()
			spinConn = nil
		end
		if self.AutoRotate then
			spinConn = RunService.RenderStepped:Connect(function(dt)
				if frame:IsDescendantOf(game) and row.Visible then
					yaw += math.rad(self.RotateSpeed) * dt
					updateCamera()
				end
			end)
		end
		return self
	end
	table.insert(el.Cleanups, function()
		if spinConn then
			spinConn:Disconnect()
		end
	end)

	if info.Interactive ~= false then
		local dragging, lastPos = false, nil
		el:Connect(frame.InputBegan, function(input)
			if isPress(input) then
				dragging = true
				lastPos = input.Position
				lib:LockScroll(true)
			end
		end)
		el:Connect(UserInputService.InputChanged, function(input)
			if dragging and isMove(input) and lastPos then
				local delta = input.Position - lastPos
				lastPos = input.Position
				yaw -= delta.X * 0.012
				pitch = math.clamp(pitch - delta.Y * 0.012, -1.3, 1.3)
				updateCamera()
			end
		end)
		el:Connect(UserInputService.InputEnded, function(input)
			if dragging and isPress(input) then
				dragging = false
				lib:LockScroll(false)
			end
		end)
		el:Connect(frame.InputChanged, function(input)
			if input.UserInputType == Enum.UserInputType.MouseWheel then
				zoom = math.clamp(zoom * (1.1 ^ input.Position.Z), 0.25, 8)
				updateCamera()
			end
		end)
		el:Connect(UserInputService.TouchPinch, function(positions, scale, _, state)
			if #positions < 2 then
				return
			end
			local mid = (positions[1] + positions[2]) / 2
			local ap, size = frame.AbsolutePosition, frame.AbsoluteSize
			if mid.X >= ap.X and mid.X <= ap.X + size.X and mid.Y >= ap.Y and mid.Y <= ap.Y + size.Y then
				if state == Enum.UserInputState.Begin then
					el._pinchBase = zoom
				elseif el._pinchBase then
					zoom = math.clamp(el._pinchBase * scale, 0.25, 8)
					updateCamera()
				end
			end
		end)
	end

	el.Source = info.Model
	if info.Model then
		el:SetModel(info.Model)
	end
	if el.AutoRotate then
		el:SetAutoRotate(true)
	end
	return el
end

local PanelClass = setmetatable({}, { __index = Container })
PanelClass.__index = PanelClass

function Spectra:CreatePanel(opts)
	opts = opts or {}
	local size = opts.Size or Vector2.new(240, 200)
	if typeof(size) == "UDim2" then
		size = Vector2.new(size.X.Offset, size.Y.Offset)
	end
	local headerH = 30
	local frame = new("Frame", {
		Name = "Panel", Size = UDim2.fromOffset(size.X, size.Y), BorderSizePixel = 0,
		Position = opts.Position or UDim2.fromOffset(40, 120), ClipsDescendants = true, Active = true,
	}, self.FloatLayer)
	self:Themed(frame, "BackgroundColor3", "Surface")
	self:Corner(frame, 9)
	self:Stroke(frame)
	self:Scaled(frame)
	self:BringToFront(frame)

	local header = new("Frame", { Name = "Header", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, headerH) }, frame)
	local x = 12
	if opts.Icon then
		local icon = self:Icon(header, opts.Icon, 14, "Muted")
		icon.Position = UDim2.new(0, 12, 0.5, -7)
		x = 32
	end
	local title = self:Text(header, opts.Title or "Panel", 11, "Text", 3)
	title.Position = UDim2.fromOffset(x, 0)
	title.Size = UDim2.new(1, -(x + 60), 1, 0)
	title.TextTruncate = Enum.TextTruncate.AtEnd
	local line = new("Frame", { Position = UDim2.fromOffset(0, headerH), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0 }, frame)
	self:Themed(line, "BackgroundColor3", "Border")

	local body = new("ScrollingFrame", {
		Name = "Body", BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
		Position = UDim2.fromOffset(0, headerH + 1), Size = UDim2.new(1, 0, 1, -(headerH + 1)),
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, frame)
	self:Themed(body, "ScrollBarImageColor3", "Muted")
	self:RegisterScroller(body)
	new("UIPadding", {
		PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
	}, body)
	local list = new("UIListLayout", { Padding = UDim.new(0, opts.EntryPadding or 6), SortOrder = Enum.SortOrder.LayoutOrder }, body)

	local panel = setmetatable({
		Lib = self, Holder = body, Frame = frame, Order = 0, Kind = "Panel", Body = body, Layout = list,
		Collapsed = false, Destroyed = false, ExpandedSize = size, HeaderHeight = headerH, TitleLabel = title,
	}, PanelClass)
	panel.Box = { Title = title }

	local function autoHeight()
		if opts.AutoHeight and not panel.Collapsed then
			local content = list.AbsoluteContentSize.Y + 16
			local h = headerH + 1 + math.clamp(content, 18, opts.MaxHeight or 260)
			frame.Size = UDim2.fromOffset(panel.ExpandedSize.X, h)
		end
	end
	if opts.AutoHeight then
		self:Connect(list:GetPropertyChangedSignal("AbsoluteContentSize"), autoHeight)
		autoHeight()
	end
	panel._AutoHeight = autoHeight

	if opts.Collapsible ~= false then
		local collapse, collapseIcon = self:IconButton(header, "chevron-down", 14, "Muted", function()
			panel:SetCollapsed(not panel.Collapsed)
		end)
		collapse.AnchorPoint = Vector2.new(1, 0.5)
		collapse.Position = UDim2.new(1, opts.Closable and -30 or -6, 0.5, 0)
		panel.CollapseButton = collapseIcon
	end
	if opts.Closable then
		local close = self:IconButton(header, "x", 14, "Muted", function()
			panel:Hide()
			if opts.OnClose then
				self:Defer(opts.OnClose, panel)
			end
		end)
		close.AnchorPoint = Vector2.new(1, 0.5)
		close.Position = UDim2.new(1, -4, 0.5, 0)
	end

	panel.DragLists = {}
	if opts.Draggable ~= false then
		table.insert(panel.DragLists, self:MakeDraggable(header, frame))
	end
	frame.InputBegan:Connect(function(input)
		if isPress(input) then
			self:BringToFront(frame)
		end
	end)
	if opts.Resizable then
		local grip = new("TextButton", {
			AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -2, 1, -2), Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5,
		}, frame)
		local gripIcon = self:Icon(grip, "arrow-down-right", 12, "Muted")
		gripIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		gripIcon.Position = UDim2.fromScale(0.5, 0.5)
		table.insert(panel.DragLists, self:MakeResizable(grip, frame, opts.MinSize or Vector2.new(160, 80), opts.MaxSize or Vector2.new(700, 700), function(v)
			panel.ExpandedSize = v
		end))
	end
	frame.Visible = opts.Visible ~= false
	table.insert(self.Panels, panel)
	return panel
end

function PanelClass:Show()
	self.Frame.Visible = true
	self.Lib:BringToFront(self.Frame)
	return self
end
function PanelClass:Hide()
	self.Frame.Visible = false
	return self
end
function PanelClass:Toggle()
	self.Frame.Visible = not self.Frame.Visible
	return self
end
function PanelClass:SetVisible(state)
	self.Frame.Visible = state ~= false
	return self
end
function PanelClass:SetTitle(text)
	self.TitleLabel.Text = tostring(text)
	return self
end
function PanelClass:SetPosition(pos)
	self.Frame.Position = pos
	return self
end
function PanelClass:SetSize(size)
	if typeof(size) == "UDim2" then
		size = Vector2.new(size.X.Offset, size.Y.Offset)
	end
	self.ExpandedSize = size
	if not self.Collapsed then
		self.Frame.Size = UDim2.fromOffset(size.X, size.Y)
	end
	self._AutoHeight()
	return self
end
function PanelClass:SetCollapsed(state)
	state = state == true
	if state == self.Collapsed then
		return self
	end
	self.Collapsed = state
	self.Body.Visible = not state
	if self.CollapseButton then
		self.Lib:Tween(self.CollapseButton, { Rotation = state and -90 or 0 }, 0.15)
	end
	if state then
		self.Frame.Size = UDim2.fromOffset(self.ExpandedSize.X, self.HeaderHeight + 1)
	else
		self.Frame.Size = UDim2.fromOffset(self.ExpandedSize.X, self.ExpandedSize.Y)
		self._AutoHeight()
	end
	return self
end
function PanelClass:Update(props)
	props = props or {}
	if props.Title then self:SetTitle(props.Title) end
	if props.Position then self:SetPosition(props.Position) end
	if props.Size then self:SetSize(props.Size) end
	if props.Visible ~= nil then self:SetVisible(props.Visible) end
	if props.Collapsed ~= nil then self:SetCollapsed(props.Collapsed) end
	return self
end
function PanelClass:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true
	for _, list in ipairs(self.DragLists or {}) do
		self.Lib:Disconnect(list)
	end
	for i, p in ipairs(self.Lib.Panels) do
		if p == self then
			table.remove(self.Lib.Panels, i)
			break
		end
	end
	self.Frame:Destroy()
end

function Spectra:CreateKeybindMenu(opts)
	opts = opts or {}
	if self.KeybindMenu and not self.KeybindMenu.Destroyed then
		return self.KeybindMenu
	end
	local panel = self:CreatePanel({
		Title = opts.Title or "Keybinds", Icon = "Keyboard", Size = Vector2.new(opts.Width or 210, 70),
		Position = opts.Position or UDim2.new(0, 20, 0.4, 0), AutoHeight = true, MaxHeight = opts.MaxHeight or 240,
		Collapsible = true, Visible = opts.Visible == true, EntryPadding = 3,
	})
	panel.Entries = {}
	self.KeybindMenu = panel
	for picker in pairs(self.KeyPickers) do
		self:_KeybindAdd(picker)
	end
	return panel
end

function Spectra:SetKeybindMenuVisible(state)
	local menu = self.KeybindMenu or self:CreateKeybindMenu()
	menu:SetVisible(state)
end

function Spectra:_KeybindAdd(picker)
	local menu = self.KeybindMenu
	if not menu or menu.Destroyed or menu.Entries[picker] then
		return
	end
	menu.Order += 1
	local entry = new("TextButton", {
		Name = "Entry", Size = UDim2.new(1, 0, 0, self.M.ListItem), BorderSizePixel = 0, Text = "",
		AutoButtonColor = false, LayoutOrder = menu.Order,
	}, menu.Holder)
	self:Themed(entry, "BackgroundColor3", "Element")
	self:Corner(entry, 6)
	local dot = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(7, 7), BorderSizePixel = 0 }, entry)
	self:Corner(dot, 8)
	local name = self:Text(entry, "", 10, "Text", 2)
	name.Position = UDim2.fromOffset(24, 0)
	name.Size = UDim2.new(1, -90, 1, 0)
	name.TextTruncate = Enum.TextTruncate.AtEnd
	local key = self:Text(entry, "", 10, "Muted", 2)
	key.AnchorPoint = Vector2.new(1, 0)
	key.Position = UDim2.new(1, -8, 0, 0)
	key.Size = UDim2.new(0, 70, 1, 0)
	key.TextXAlignment = Enum.TextXAlignment.Right
	entry.Activated:Connect(function()
		picker:Activate()
	end)
	menu.Entries[picker] = { Frame = entry, Dot = dot, Name = name, Key = key }
	self:_KeybindRefresh(picker)
end

function Spectra:_KeybindRefresh(picker)
	local menu = self.KeybindMenu
	if not menu or menu.Destroyed then
		return
	end
	local entry = menu.Entries[picker]
	if not entry then
		return
	end
	entry.Frame.Visible = not (picker.NoUI or picker.HiddenInMenu)
	entry.Name.Text = picker:GetText()
	entry.Key.Text = string.format("[%s] %s", keyDisplay(picker.Key), picker.Mode)
	local active = picker:GetState()
	entry.Dot.BackgroundColor3 = active and self.Theme.Success or self.Theme.Muted
end

function Spectra:_KeybindRemove(picker)
	local menu = self.KeybindMenu
	if not menu or not menu.Entries then
		return
	end
	local entry = menu.Entries[picker]
	if entry then
		entry.Frame:Destroy()
		menu.Entries[picker] = nil
	end
end

local function resolveColor(lib, value)
	if typeof(value) == "Color3" then
		return value
	end
	return lib.Theme[value or "Text"] or lib.Theme.Text
end

function Obj:Show()
	self.Frame.Visible = true
	return self
end
function Obj:Hide()
	self.Frame.Visible = false
	return self
end
function Obj:Toggle()
	self.Frame.Visible = not self.Frame.Visible
	return self
end
function Obj:SetVisible(state)
	self.Frame.Visible = state ~= false
	return self
end
function Obj:SetPosition(pos)
	self.Frame.Position = pos
	return self
end
function Obj:SetText(text)
	self.Info.Text = text
	if self.TextLabel then
		self.TextLabel.Text = tostring(text)
	end
	return self
end
function Obj:SetIcon(icon)
	if self.IconHolder then
		self.Lib:SetIcon(self.IconHolder, icon)
	end
	return self
end
function Obj:SetColor(color)
	self.Info.Color = color
	if self.Dot then
		self.Dot.BackgroundColor3 = resolveColor(self.Lib, color)
	elseif self.TextLabel then
		self.TextLabel.TextColor3 = resolveColor(self.Lib, color)
	end
	return self
end
function Obj:SetState(state)
	self.State = state == true
	if self.Dot then
		self.Dot.BackgroundColor3 = self.State and self.Lib.Theme.Success or self.Lib.Theme.Muted
	end
	return self
end
function Obj:Update(props)
	props = props or {}
	if props.Text ~= nil then self:SetText(props.Text) end
	if props.Icon ~= nil then self:SetIcon(props.Icon) end
	if props.Color ~= nil then self:SetColor(props.Color) end
	if props.State ~= nil then self:SetState(props.State) end
	if props.Position ~= nil then self:SetPosition(props.Position) end
	if props.Callback ~= nil then self.Info.Callback = props.Callback end
	if props.Visible ~= nil then self:SetVisible(props.Visible) end
	return self
end
function Obj:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true
	for _, list in ipairs(self.DragLists or {}) do
		self.Lib:Disconnect(list)
	end
	for i, o in ipairs(self.Lib.Overlays) do
		if o == self then
			table.remove(self.Lib.Overlays, i)
			break
		end
	end
	self.Frame:Destroy()
end

function Spectra:CreateOverlay(kind, opts)
	opts = opts or {}
	kind = tostring(kind or "Label")
	if kind == "Panel" then
		return self:CreatePanel(opts)
	end
	local isButton = kind == "Button"
	local frame = new(isButton and "TextButton" or "Frame", {
		Name = "Overlay" .. kind, BorderSizePixel = 0, Size = UDim2.new(0, 0, 0, self.M.ListItem + 2),
		AutomaticSize = Enum.AutomaticSize.X, Position = opts.Position or UDim2.fromOffset(20, 20),
		Visible = opts.Visible ~= false,
	}, self.OverlayLayer)
	if isButton then
		frame.Text = ""
		frame.AutoButtonColor = false
	else
		frame.Active = false
	end
	self:Themed(frame, "BackgroundColor3", "Surface")
	self:Corner(frame, 8)
	self:Stroke(frame)
	self:Scaled(frame)
	new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, frame)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	}, frame)
	local o = setmetatable({ Lib = self, Frame = frame, Kind = kind, Info = opts, Destroyed = false, State = false }, Obj)
	if kind == "Indicator" then
		local dot = new("Frame", { Size = UDim2.fromOffset(8, 8), BorderSizePixel = 0, LayoutOrder = 1 }, frame)
		self:Corner(dot, 8)
		o.Dot = dot
	elseif opts.Icon or opts.Image then
		local icon = self:Icon(frame, opts.Image or opts.Icon, 14, "Muted", opts.Image ~= nil)
		icon.LayoutOrder = 1
		o.IconHolder = icon
	end
	local label = self:Text(frame, opts.Text or "", 11, false, 2)
	label.Size = UDim2.new(0, 0, 1, 0)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.LayoutOrder = 2
	o.TextLabel = label
	self:Bind(function()
		if o.Dot then
			o.Dot.BackgroundColor3 = opts.Color and resolveColor(self, opts.Color)
				or (o.State and self.Theme.Success or self.Theme.Muted)
			label.TextColor3 = self.Theme.Text
		else
			label.TextColor3 = resolveColor(self, opts.Color or "Text")
		end
	end, frame)
	if opts.State ~= nil then
		o:SetState(opts.State)
	end
	if opts.Draggable ~= false then
		local startPos
		frame.InputBegan:Connect(function(input)
			if isPress(input) then
				startPos = frame.Position
			end
		end)
		o.DragLists = { self:MakeDraggable(frame, frame) }
		if isButton then
			frame.Activated:Connect(function()
				if frame.Position == startPos and o.Info.Callback then
					self:Defer(o.Info.Callback, o)
				end
			end)
		end
	elseif isButton then
		frame.Activated:Connect(function()
			if o.Info.Callback then
				self:Defer(o.Info.Callback, o)
			end
		end)
	end
	table.insert(self.Overlays, o)
	return o
end

function Spectra:AddOverlayLabel(opts) return self:CreateOverlay("Label", opts) end
function Spectra:AddOverlayButton(opts) return self:CreateOverlay("Button", opts) end
function Spectra:AddOverlayIndicator(opts) return self:CreateOverlay("Indicator", opts) end
function Spectra:AddOverlayPanel(opts) return self:CreateOverlay("Panel", opts) end

function Spectra:CreateToggleButton(opts)
	opts = opts or {}
	if self.ToggleButton and not self.ToggleButton.Destroyed then
		return self.ToggleButton
	end
	local size = opts.Size or (self.IsMobile and 50 or 44)
	local btn = new("TextButton", {
		Name = "ToggleButton", AnchorPoint = Vector2.new(0, 0.5), Position = opts.Position or UDim2.new(0, 24, 0.5, 0),
		Size = UDim2.fromOffset(size, size), BorderSizePixel = 0, Text = "", AutoButtonColor = false,
		Visible = opts.Visible ~= false,
	}, self.ToggleLayer)
	self:Themed(btn, "BackgroundColor3", "Surface")
	self:Corner(btn, 13)
	local stroke = self:Stroke(btn)
	self:Scaled(btn)
	local logo = new("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0.64, 0.64),
		BackgroundTransparency = 1, Image = toAsset(opts.Image) or self.Logo, ScaleType = Enum.ScaleType.Fit,
	}, btn)
	local tb = { Frame = btn, Logo = logo, Destroyed = false, Lib = self }
	local startPos
	btn.InputBegan:Connect(function(input)
		if isPress(input) then
			startPos = btn.Position
		end
	end)
	if opts.Draggable ~= false then
		tb.DragLists = { self:MakeDraggable(btn, btn) }
	end
	btn.Activated:Connect(function()
		if btn.Position == startPos or startPos == nil then
			self:ToggleUI()
		end
	end)
	btn.MouseEnter:Connect(function()
		self:Tween(btn, { BackgroundColor3 = self.Theme.Hover }, 0.12)
	end)
	btn.MouseLeave:Connect(function()
		self:Tween(btn, { BackgroundColor3 = self.Theme.Surface }, 0.12)
	end)
	function tb:SetVisible(state)
		btn.Visible = state ~= false
		return self
	end
	function tb:Show() return self:SetVisible(true) end
	function tb:Hide() return self:SetVisible(false) end
	function tb:SetSize(n)
		n = math.clamp(tonumber(n) or 44, 28, 96)
		btn.Size = UDim2.fromOffset(n, n)
		return self
	end
	function tb:SetImage(asset)
		logo.Image = toAsset(asset) or logo.Image
		return self
	end
	function tb:SetTransparency(t)
		t = math.clamp(tonumber(t) or 0, 0, 0.9)
		btn.BackgroundTransparency = t
		logo.ImageTransparency = t
		stroke.Transparency = t
		return self
	end
	function tb:SetPosition(pos)
		btn.Position = pos
		return self
	end
	function tb:Destroy()
		if self.Destroyed then
			return
		end
		self.Destroyed = true
		for _, list in ipairs(self.DragLists or {}) do
			self.Lib:Disconnect(list)
		end
		if self.Lib.ToggleButton == self then
			self.Lib.ToggleButton = nil
		end
		btn:Destroy()
	end
	if opts.Transparency then
		tb:SetTransparency(opts.Transparency)
	end
	self.ToggleButton = tb
	return tb
end

function TabClass:_GetColumns()
	if self.ColumnFrames then
		return self.ColumnFrames
	end
	local lib = self.Library
	self.StackOrder += 1
	local row = new("Frame", {
		Name = "Columns", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self.StackOrder,
	}, self.Page)
	local layout = new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, lib.M.Gap), SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
	}, row)
	self.ColumnsRow = row
	self.ColumnsLayout = layout
	self.ColumnFrames = {}
	local n = self.ColumnCount
	for i = 1, n do
		local col = new("Frame", {
			Name = "Column" .. i, BackgroundTransparency = 1, Size = UDim2.new(1 / n, -lib.M.Gap * (n - 1) / n, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = i,
		}, row)
		new("UIListLayout", { Padding = UDim.new(0, lib.M.Gap), SortOrder = Enum.SortOrder.LayoutOrder }, col)
		self.ColumnFrames[i] = col
	end
	local function responsive()
		local narrow = self.Page.AbsoluteSize.X / lib.Theme.Scale < (lib.IsMobile and 420 or 470)
		layout.FillDirection = narrow and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
		for i, col in ipairs(self.ColumnFrames) do
			if narrow then
				col.Size = UDim2.new(1, 0, 0, 0)
			else
				col.Size = UDim2.new(1 / n, -lib.M.Gap * (n - 1) / n, 0, 0)
			end
		end
	end
	lib:Connect(self.Page:GetPropertyChangedSignal("AbsoluteSize"), responsive)
	responsive()
	return self.ColumnFrames
end

function TabClass:_PickColumn(side)
	local cols = self:_GetColumns()
	if type(side) == "number" then
		return cols[math.clamp(side, 1, #cols)]
	end
	if side == "Left" then
		return cols[1]
	elseif side == "Right" then
		return cols[math.min(2, #cols)]
	end
	local best = cols[1]
	for _, col in ipairs(cols) do
		if col.AbsoluteSize.Y < best.AbsoluteSize.Y then
			best = col
		end
	end
	return best
end

function TabClass:AddGroupbox(name, opts)
	opts = opts or {}
	local lib = self.Library
	local parent = self:_PickColumn(opts.Column or opts.Side)
	self.ColumnOrder += 1
	local box = lib:CreateBox(parent, {
		Title = name, Description = opts.Description, Icon = opts.Icon, Order = self.ColumnOrder,
		Collapsible = opts.Collapsible, Collapsed = opts.Collapsed, Height = opts.Height, Name = "Groupbox",
	})
	local c = Spectra._ContainerFromBox(lib, box)
	self.Groupboxes[name] = c
	return c
end

function TabClass:AddLeftGroupbox(name, icon, opts)
	opts = opts or {}
	opts.Column = 1
	opts.Icon = opts.Icon or icon
	return self:AddGroupbox(name, opts)
end

function TabClass:AddRightGroupbox(name, icon, opts)
	opts = opts or {}
	opts.Column = "Right"
	opts.Icon = opts.Icon or icon
	return self:AddGroupbox(name, opts)
end

function TabClass:AddSection(title, description, opts)
	opts = opts or {}
	local lib = self.Library
	self.StackOrder += 1
	local box = lib:CreateBox(self.Page, {
		Title = title, Description = description, Icon = opts.Icon, Order = self.StackOrder,
		Collapsible = opts.Collapsible, Collapsed = opts.Collapsed, Height = opts.Height, Name = "Section",
	})
	return Spectra._ContainerFromBox(lib, box)
end

function TabClass:AddTabbox(opts)
	opts = opts or {}
	local lib = self.Library
	local parent = self:_PickColumn(opts.Column or opts.Side)
	self.ColumnOrder += 1
	local frame = new("Frame", {
		Name = "Tabbox", BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = self.ColumnOrder, ClipsDescendants = false,
	}, parent)
	lib:Themed(frame, "BackgroundColor3", "Surface")
	lib:Corner(frame, 9)
	lib:Stroke(frame)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, frame)
	local header = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 1 }, frame)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder }, header)
	local lineHolder = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 2 }, frame)
	local line = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0 }, lineHolder)
	lib:Themed(line, "BackgroundColor3", "Border")
	local bodies = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 3,
	}, frame)

	local tabbox = { Frame = frame, Tabs = {}, Lib = lib, Order = {} }
	local function refreshHeader()
		local n = #tabbox.Order
		for _, name in ipairs(tabbox.Order) do
			tabbox.Tabs[name].Button.Size = UDim2.new(1 / n, 0, 1, 0)
		end
	end
	function tabbox:Select(name)
		local selected = self.Tabs[name]
		if not selected then
			return self
		end
		self.Active = name
		for n, t in pairs(self.Tabs) do
			local active = n == name
			t.Body.Visible = active
			t.Label.TextColor3 = active and lib.Theme.Text or lib.Theme.Muted
			t.Underline.Visible = active
			lib:Tween(t.Button, { BackgroundTransparency = active and 0 or 1 }, 0.12)
		end
		return self
	end
	function tabbox:AddTab(name, icon)
		local button = new("TextButton", {
			Name = name, BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false,
			LayoutOrder = #self.Order + 1,
		}, header)
		lib:Themed(button, "BackgroundColor3", "Element")
		lib:Corner(button, 7)
		local label = lib:Text(button, name, 11, false, 2)
		label.Size = UDim2.fromScale(1, 1)
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.TextTruncate = Enum.TextTruncate.AtEnd
		if icon then
			local tabIcon = lib:Icon(button, icon, 14, "Muted")
			tabIcon.AnchorPoint = Vector2.new(0, 0.5)
			tabIcon.Position = UDim2.new(0, 10, 0.5, 0)
			label.Position = UDim2.fromOffset(18, 0)
			label.Size = UDim2.new(1, -18, 1, 0)
		end
		local underline = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(0.5, 0, 0, 2),
			BorderSizePixel = 0, Visible = false,
		}, button)
		lib:Themed(underline, "BackgroundColor3", "Accent")
		local body = new("Frame", {
			Name = name, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y, Visible = false,
		}, bodies)
		new("UIPadding", {
			PaddingTop = UDim.new(0, 9), PaddingBottom = UDim.new(0, lib.M.Pad),
			PaddingLeft = UDim.new(0, lib.M.Pad), PaddingRight = UDim.new(0, lib.M.Pad),
		}, body)
		new("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, body)
		local c = setmetatable({ Lib = lib, Holder = body, Frame = body, Order = 0, Tabbox = self, TabName = name }, Container)
		c.Select = function()
			self:Select(name)
		end
		self.Tabs[name] = { Button = button, Label = label, Body = body, Underline = underline, Container = c }
		table.insert(self.Order, name)
		refreshHeader()
		button.Activated:Connect(function()
			self:Select(name)
		end)
		if not self.Active then
			self:Select(name)
		end
		return c
	end
	function tabbox:SetVisible(state)
		frame.Visible = state ~= false
		return self
	end
	function tabbox:Destroy()
		frame:Destroy()
	end
	return tabbox
end

function TabClass:AddLeftTabbox(opts)
	opts = opts or {}
	opts.Column = 1
	return self:AddTabbox(opts)
end

function TabClass:AddRightTabbox(opts)
	opts = opts or {}
	opts.Column = "Right"
	return self:AddTabbox(opts)
end

function TabClass:Select()
	self.Library:SelectTab(self)
	return self
end

function TabClass:SetVisible(state)
	self.Button.Visible = state ~= false
	return self
end

function TabClass:Destroy()
	local lib = self.Library
	for i, t in ipairs(lib.TabList) do
		if t == self then
			table.remove(lib.TabList, i)
			break
		end
	end
	if lib.Tabs[self.Name] == self then
		lib.Tabs[self.Name] = nil
	end
	self.Button:Destroy()
	self.Page:Destroy()
	if lib.ActiveTab == self.Name then
		lib.ActiveTab = nil
		if lib.TabList[1] then
			lib:SelectTab(lib.TabList[1])
		end
	end
end

function Spectra:GetLayoutMode()
	local position = self.TabPosition
	if self.Compact and self.CompactLayout == "Top" then
		position = "Top"
	end
	return position, position == "Left" or position == "Right", self.Compact
end

function TabClass:_Style(animate)
	local lib = self.Library
	local _, vertical, compact = lib:GetLayoutMode()
	local button = self.Button
	local icon, text, marker = self.IconHolder, self.TextLabel, self.Marker
	local hasIcon = self.Icon ~= nil and self.Icon ~= ""
	local active = lib.ActiveTab == self.Name
	local size
	if vertical then
		size = UDim2.new(1, 0, 0, lib.M.Tab)
		if compact and hasIcon then
			icon.AnchorPoint = Vector2.new(0.5, 0.5)
			icon.Position = UDim2.fromScale(0.5, 0.5)
			text.Visible = false
		else
			icon.AnchorPoint = Vector2.new(0, 0.5)
			icon.Position = UDim2.new(0, 12, 0.5, 0)
			text.Visible = true
			text.Position = UDim2.fromOffset(hasIcon and 36 or 14, 0)
			text.Size = UDim2.new(1, -(hasIcon and 42 or 20), 1, 0)
			text.TextXAlignment = Enum.TextXAlignment.Left
		end
		marker.AnchorPoint = Vector2.new(0, 0.5)
		marker.Position = UDim2.new(0, 0, 0.5, 0)
		marker.Size = UDim2.fromOffset(3, 14)
	else
		local textW = TextService:GetTextSize(self.Name, fs(11), lib:GetFont(2), Vector2.new(400, 30)).X
		local showText = (not compact) or active or not hasIcon
		local width = 24 + (hasIcon and 20 or 0) + (showText and (textW + (hasIcon and 4 or 0)) or 0)
		size = UDim2.new(0, math.max(width, lib.M.Tab), 1, 0)
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 12, 0.5, 0)
		text.Visible = showText
		text.Position = UDim2.fromOffset(hasIcon and 36 or 12, 0)
		text.Size = UDim2.new(1, -(hasIcon and 40 or 20), 1, 0)
		text.TextXAlignment = Enum.TextXAlignment.Left
		marker.AnchorPoint = Vector2.new(0.5, 1)
		marker.Position = UDim2.new(0.5, 0, 1, 0)
		marker.Size = UDim2.fromOffset(14, 3)
	end
	icon.Visible = hasIcon
	if animate then
		lib:Tween(button, { Size = size }, 0.16)
	else
		button.Size = size
	end
end

function Spectra:CreateTab(name, iconName, opts)
	opts = opts or {}
	local tab = setmetatable({
		Library = self, Name = name, Icon = iconName, StackOrder = 0, ColumnOrder = 0, Groupboxes = {},
		ColumnCount = math.clamp(opts.Columns or self.Columns or 2, 1, 3),
	}, TabClass)
	local button = new("TextButton", {
		Name = name, Size = UDim2.new(1, 0, 0, self.M.Tab), BorderSizePixel = 0, Text = "", AutoButtonColor = false,
		LayoutOrder = #self.TabList + 1,
	}, self.Navigation)
	self:Corner(button, 7)
	local icon = self:Icon(button, iconName, 16, "Muted")
	icon.Name = "TabIcon"
	local text = self:Text(button, name, 11, false, 2)
	text.Name = "TabText"
	text.TextTruncate = Enum.TextTruncate.AtEnd
	local marker = new("Frame", { Name = "Marker", BorderSizePixel = 0, Visible = false }, button)
	self:Themed(marker, "BackgroundColor3", "Accent")
	self:Corner(marker, 3)
	tab.Button, tab.IconHolder, tab.TextLabel, tab.Marker = button, icon, text, marker

	local page = new("ScrollingFrame", {
		Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = self.IsMobile and 3 or 2, CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false,
	}, self.Content)
	self:Themed(page, "ScrollBarImageColor3", "Muted")
	self:RegisterScroller(page)
	local pad = self.IsMobile and 10 or 16
	new("UIPadding", {
		PaddingTop = UDim.new(0, pad), PaddingBottom = UDim.new(0, pad + 4),
		PaddingLeft = UDim.new(0, pad), PaddingRight = UDim.new(0, pad + 2),
	}, page)
	new("UIListLayout", { Padding = UDim.new(0, self.M.Gap), SortOrder = Enum.SortOrder.LayoutOrder }, page)
	tab.Page = page

	local function paint(active, instant)
		local t = self.Theme
		local bg = active and t.Element or t.Sidebar
		button.BackgroundTransparency = (active or self.HoverTab == tab) and 0 or 1
		if instant then
			button.BackgroundColor3 = bg
		else
			self:Tween(button, { BackgroundColor3 = bg })
		end
		text.TextColor3 = active and t.Text or t.Muted
		self:SetIconColor(icon, active and "Text" or "Muted")
		marker.Visible = active
	end
	tab.Paint = paint
	button.Activated:Connect(function()
		self:SelectTab(tab)
	end)
	button.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab.Name then
			self.HoverTab = tab
			button.BackgroundTransparency = 0
			self:Tween(button, { BackgroundColor3 = self.Theme.Surface })
		end
	end)
	button.MouseLeave:Connect(function()
		if self.HoverTab == tab then
			self.HoverTab = nil
		end
		if self.ActiveTab ~= tab.Name then
			button.BackgroundTransparency = 1
		end
	end)
	self:Bind(function()
		paint(self.ActiveTab == name, true)
	end, button)

	self.Tabs[name] = tab
	table.insert(self.TabList, tab)
	tab:_Style()
	if not self.ActiveTab then
		self:SelectTab(tab)
	else
		paint(false, true)
	end
	return tab
end

function Spectra:SelectTab(target)
	local selected = type(target) == "string" and self.Tabs[target] or target
	if type(selected) ~= "table" or not selected.Page then
		return
	end
	self.ActiveTab = selected.Name
	self:ClosePopup()
	local _, vertical, compact = self:GetLayoutMode()
	for _, tab in ipairs(self.TabList) do
		local active = tab == selected
		tab.Page.Visible = active
		tab.Paint(active, false)
		if not vertical and compact then
			tab:_Style(true)
		end
	end
end

function Spectra:GetTab(name)
	return self.Tabs[name]
end

function Spectra:CreateSection(parent, title, description)
	if getmetatable(parent) == TabClass then
		return parent:AddSection(title, description)
	elseif type(parent) == "table" and parent.AddSubsection then
		return parent:AddSubsection(title, description)
	end
	error("[Spectra] CreateSection: informe uma aba (retorno de CreateTab)")
end

function Spectra:CreateSectionForTab(tab, title, description)
	return self:CreateSection(tab, title, description)
end

local TabPositions = { Left = true, Right = true, Top = true, Bottom = true }

local function toKeyCode(value)
	if typeof(value) == "EnumItem" and value.EnumType == Enum.KeyCode then
		return value
	end
	if type(value) == "string" then
		local item = enumItem(Enum.KeyCode, value)
		if item then
			return item
		end
	end
	return nil
end

function Spectra.ComputeMetrics(mobile, viewport)
	local m = {}
	if mobile then
		local short = math.min(viewport.X, viewport.Y)
		local d = math.clamp(short / 430, 0.82, 1.12)
		m.Density = d
		m.Row = math.max(30, math.floor(34 * d + 0.5))
		m.Button = math.max(32, math.floor(36 * d + 0.5))
		m.Input = math.max(30, math.floor(32 * d + 0.5))
		m.ListItem = math.max(30, math.floor(32 * d + 0.5))
		m.SliderHit = math.max(24, math.floor(26 * d + 0.5))
		m.Pad = math.max(8, math.floor(10 * d + 0.5))
		m.Gap = math.max(6, math.floor(8 * d + 0.5))
		m.Tab = math.max(36, math.floor(42 * d + 0.5))
		m.TopBar = math.max(42, math.floor(48 * d + 0.5))
		m.Bar = math.max(38, math.floor(42 * d + 0.5))
		m.Side = math.floor(150 * d + 0.5)
		m.SideCompact = math.max(44, math.floor(50 * d + 0.5))
		m.Font = math.clamp(0.95 * d + 0.1, 0.92, 1.12)
	else
		m.Density = 1
		m.Row, m.Button, m.Input, m.ListItem = 26, 28, 26, 24
		m.SliderHit = 16
		m.Pad, m.Gap = 10, 8
		m.Tab, m.TopBar, m.Bar = 34, 52, 38
		m.Side, m.SideCompact = 164, 50
		m.Font = 1
	end
	return m
end

function Spectra:FitWindow()
	if not self.Gui or not self.Window then
		return
	end
	local vp = self.Gui.AbsoluteSize
	local s = self.Theme.Scale
	local margin = self.IsMobile and 12 or 28
	local maxW = math.max(260, vp.X / s - margin)
	local maxH = math.max(200, vp.Y / s - margin)
	local w = math.clamp(self.WindowSize.X, math.min(self.MinWindowSize.X, maxW), maxW)
	local h = math.clamp(self.WindowSize.Y, math.min(self.MinWindowSize.Y, maxH), maxH)
	self.Window.Size = UDim2.fromOffset(w, h)
	self:ClampToScreen(self.Window)
end

function Spectra:LayoutShell()
	local position, vertical, compact = self:GetLayoutMode()
	local TB = self.M.TopBar
	local SW = compact and self.M.SideCompact or self.M.Side
	local H = self.M.Bar
	local m = self.M.Gap
	local sidebar, content, nav = self.Sidebar, self.Content, self.Navigation

	if position == "Left" then
		sidebar.Position, sidebar.Size = UDim2.fromOffset(0, TB), UDim2.new(0, SW, 1, -TB)
		content.Position, content.Size = UDim2.fromOffset(SW, TB), UDim2.new(1, -(SW + m), 1, -(TB + m))
	elseif position == "Right" then
		sidebar.Position, sidebar.Size = UDim2.new(1, -SW, 0, TB), UDim2.new(0, SW, 1, -TB)
		content.Position, content.Size = UDim2.fromOffset(m, TB), UDim2.new(1, -(SW + m), 1, -(TB + m))
	elseif position == "Top" then
		sidebar.Position, sidebar.Size = UDim2.fromOffset(0, TB), UDim2.new(1, 0, 0, H)
		content.Position, content.Size = UDim2.fromOffset(m, TB + H), UDim2.new(1, -2 * m, 1, -(TB + H + m))
	else
		sidebar.Position, sidebar.Size = UDim2.new(0, 0, 1, -H), UDim2.new(1, 0, 0, H)
		content.Position, content.Size = UDim2.fromOffset(m, TB), UDim2.new(1, -2 * m, 1, -(TB + H + m))
	end

	local list = self.NavLayout
	if vertical then
		list.FillDirection = Enum.FillDirection.Vertical
		nav.ScrollingDirection = Enum.ScrollingDirection.Y
		nav.AutomaticCanvasSize = Enum.AutomaticSize.Y
		nav.CanvasSize = UDim2.new()
		nav.Position = UDim2.fromOffset(6, 4)
		nav.Size = UDim2.new(1, -12, 1, -8)
	else
		list.FillDirection = Enum.FillDirection.Horizontal
		nav.ScrollingDirection = Enum.ScrollingDirection.X
		nav.AutomaticCanvasSize = Enum.AutomaticSize.X
		nav.CanvasSize = UDim2.new()
		nav.Position = UDim2.fromOffset(m, 4)
		nav.Size = UDim2.new(1, -2 * m, 1, -8)
	end
	for _, tab in ipairs(self.TabList) do
		tab:_Style()
	end
end

function Spectra:SetTabPosition(pos)
	if TabPositions[pos] then
		self.TabPosition = pos
		self:LayoutShell()
	end
end

function Spectra:SetCompactTabs(state)
	self.Compact = state == true
	self:LayoutShell()
end

function Spectra:SetCompactLayout(layout)
	if layout == "Top" or layout == "Side" then
		self.CompactLayout = layout
		self:LayoutShell()
	end
end

function Spectra:SetToggleButtonEnabled(state)
	state = state == true
	self.ToggleButtonEnabled = state
	if state then
		self:CreateToggleButton(self.ToggleButtonOptions)
	elseif self.ToggleButton then
		self.ToggleButtonOptions = self.ToggleButtonOptions or {}
		self.ToggleButtonOptions.Position = self.ToggleButton.Frame.Position
		self.ToggleButton:Destroy()
		self.ToggleButton = nil
	end
end

function Spectra:SetToggleKey(key)
	local code = toKeyCode(key)
	self.ToggleKey = code
	if code == Enum.KeyCode.Unknown then
		self.ToggleKey = nil
	end
end

function Spectra:SetTitle(text)
	self.TitleLabel.Text = tostring(text)
end

function Spectra:SetSubtitle(text)
	self.SubtitleLabel.Text = tostring(text)
end

function Spectra:SetLogo(asset)
	local id = toAsset(asset)
	if id then
		self.Logo = id
		self.LogoImage.Image = id
		if self.ToggleButton then
			self.ToggleButton:SetImage(id)
		end
	end
end

function Spectra:OnUnload(fn)
	table.insert(self.UnloadCallbacks, fn)
end

function Spectra:ToggleUI(state)
	if self.Destroyed then
		return
	end
	if state == nil then
		state = not self.Open
	end
	if state == self.Open then
		return
	end
	self.Open = state
	self:ClosePopup()
	local window, scale = self.Window, self.WindowScale
	if state then
		window.Visible = true
		scale.Scale = self.Theme.Scale * 0.94
		self:Tween(scale, { Scale = self.Theme.Scale }, 0.22)
	else
		for picker in pairs(self.OpenColorPickers) do
			picker:Close()
		end
		self:Tween(scale, { Scale = self.Theme.Scale * 0.94 }, 0.16)
		task.delay(0.18, function()
			if not self.Open and window.Parent then
				window.Visible = false
				scale.Scale = self.Theme.Scale
			end
		end)
	end
	if self.OnToggle then
		self:Defer(self.OnToggle, state)
	end
end

function Spectra:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true
	for _, fn in ipairs(self.UnloadCallbacks) do
		pcall(fn)
	end
	local list = {}
	for _, el in pairs(self.Options) do
		table.insert(list, el)
	end
	for _, el in pairs(self.Toggles) do
		table.insert(list, el)
	end
	for _, el in ipairs(list) do
		pcall(el.Destroy, el)
	end
	for _, c in ipairs(self.Connections) do
		pcall(function()
			c:Disconnect()
		end)
	end
	table.clear(self.Connections)
	table.clear(self.Hooks)
	self.Notifications = {}
	if self.Gui then
		self.Gui:Destroy()
	end
	local env = getEnv()
	if env.__SpectraWTF == self then
		env.__SpectraWTF = nil
	end
end
Spectra.Unload = Spectra.Destroy

function Spectra:CreateWindow(options)
	options = options or {}
	local env = getEnv()
	local previous = env.__SpectraWTF
	if type(previous) == "table" and type(previous.Destroy) == "function" then
		pcall(previous.Destroy, previous)
	end
	local parent = resolveGuiParent()
	if not parent then
		error("[Spectra] nenhum container de GUI disponível")
	end
	for _, name in ipairs({ "SpectraWTF", "SpectraUI" }) do
		local old = parent:FindFirstChild(name)
		if old then
			old:Destroy()
		end
	end

	local lib = setmetatable({}, Spectra)
	lib.Theme = copyTable(DefaultTheme)
	if type(options.Theme) == "table" then
		for k, v in pairs(options.Theme) do
			if lib.Theme[k] ~= nil and type(lib.Theme[k]) == type(v) then
				lib.Theme[k] = v
			end
		end
	end
	lib.Connections, lib.Hooks, lib.HookId = {}, {}, 0
	lib.Options, lib.Toggles, lib.KeyPickers = {}, {}, {}
	lib.Tabs, lib.TabList = {}, {}
	lib.Notifications, lib.NotifyOrder = {}, 0
	lib.Scrollers, lib.ScrollLocks = {}, 0
	lib.ZCounter = 10
	lib.OpenColorPickers, lib.Overlays, lib.Panels = {}, {}, {}
	lib.UnloadCallbacks = {}
	lib.Destroyed, lib.Open = false, true
	lib.Logo = toAsset(options.Logo) or Spectra.DefaultLogo
	lib.Name = options.Title or Spectra.Name
	lib.Columns = options.Columns
	if options.Mobile ~= nil then
		lib.IsMobile = options.Mobile == true
	else
		lib.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	end
	lib.TabPosition = TabPositions[options.TabPosition] and options.TabPosition or "Left"
	if options.CompactTabs ~= nil then
		lib.Compact = options.CompactTabs == true
	else
		lib.Compact = lib.IsMobile
	end
	lib.ToggleKey = toKeyCode(options.ToggleKey) or Enum.KeyCode.RightControl
	if options.ToggleKey == false then
		lib.ToggleKey = nil
	end
	lib.CompactLayout = options.CompactLayout == "Top" and "Top" or "Side"
	lib.CapturingKey = false
	lib.LastCapture = 0
	lib.ToggleButtonEnabled = options.ToggleButton ~= false
	lib.ToggleButtonOptions = type(options.ToggleButton) == "table" and options.ToggleButton or nil

	local gui = new("ScreenGui", {
		Name = "SpectraWTF", ResetOnSpawn = false, IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = options.DisplayOrder or 999,
	})
	if type(syn) == "table" and syn.protect_gui then
		pcall(syn.protect_gui, gui)
	end
	gui.Parent = parent
	lib.Gui = gui
	env.__SpectraWTF = lib

	local viewport = gui.AbsoluteSize
	if viewport.X < 2 or viewport.Y < 2 then
		local camera = workspace and workspace.CurrentCamera
		viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
	end
	lib.M = Spectra.ComputeMetrics(lib.IsMobile, viewport)
	Spectra:SetFontScale(lib.M.Font)

	local requested = options.Size or UDim2.fromOffset(780, 470)
	if lib.IsMobile then
		requested = options.MobileSize or UDim2.fromOffset(
			math.clamp(math.floor(viewport.X * 0.62), 340, 600),
			math.clamp(math.floor(viewport.Y * 0.74), 220, 400)
		)
	end
	lib.WindowSize = Vector2.new(requested.X.Offset, requested.Y.Offset)
	lib.MinWindowSize = lib.IsMobile and Vector2.new(300, 200) or Vector2.new(460, 300)

	local function layer(name, z)
		return new("Frame", {
			Name = name, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = z,
		}, gui)
	end
	lib.OverlayLayer = layer("Overlays", 5)
	local window = new("Frame", {
		Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = options.Position or UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(lib.WindowSize.X, lib.WindowSize.Y), BorderSizePixel = 0, Active = true,
		ZIndex = 10, ClipsDescendants = false, Visible = options.AutoShow ~= false,
	}, gui)
	lib.Window = window
	lib:Bind(function()
		window.BackgroundColor3 = lib.Theme.Sidebar
		window.BackgroundTransparency = lib.Theme.Transparency
	end, window)
	lib:Corner(window, 10)
	lib:Stroke(window, "Border", 0.1)
	lib.WindowScale = lib:Scaled(window)
	lib.Open = options.AutoShow ~= false

	lib.ToggleLayer = layer("ToggleButton", 30)
	lib.FloatLayer = layer("Floating", 50)
	local popupLayer = layer("Popups", 100)
	popupLayer.Visible = false
	local backdrop = new("TextButton", {
		Name = "Backdrop", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1),
	}, popupLayer)
	backdrop.Activated:Connect(function()
		lib:ClosePopup()
	end)
	lib.PopupLayer = popupLayer
	local mobile = lib.IsMobile
	lib.NotifyLayer = new("Frame", {
		Name = "Notifications", BackgroundTransparency = 1, ZIndex = 200,
		AnchorPoint = Vector2.new(1, mobile and 0 or 1), Position = UDim2.new(1, -14, mobile and 0 or 1, mobile and 14 or -14),
		Size = UDim2.new(0, 300, 1, -28),
	}, gui)
	new("UIListLayout", {
		Padding = UDim.new(0, lib.M.Gap), SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = mobile and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom,
	}, lib.NotifyLayer)

	local TB = lib.M.TopBar
	local topbar = new("Frame", { Name = "Topbar", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, TB) }, window)
	lib.Topbar = topbar
	local logoSize = math.clamp(TB - 22, 24, 34)
	local logo = new("ImageLabel", {
		Position = UDim2.fromOffset(lib.M.Pad + 4, (TB - logoSize) / 2), Size = UDim2.fromOffset(logoSize, logoSize),
		BackgroundTransparency = 1, Image = lib.Logo, ScaleType = Enum.ScaleType.Fit,
	}, topbar)
	lib.LogoImage = logo
	local tx = lib.M.Pad + 4 + logoSize + 10
	local ty = (TB - 34) / 2
	local title = lib:Text(topbar, lib.Name, 14, "Text", 3)
	title.Position = UDim2.fromOffset(tx, ty)
	title.Size = UDim2.new(1, -(tx + 52), 0, 18)
	title.TextTruncate = Enum.TextTruncate.AtEnd
	lib.TitleLabel = title
	local subtitle = lib:Text(topbar, options.Subtitle or game.Name, 10, "Muted", 1)
	subtitle.Position = UDim2.fromOffset(tx, ty + 18)
	subtitle.Size = UDim2.new(1, -(tx + 52), 0, 14)
	subtitle.TextTruncate = Enum.TextTruncate.AtEnd
	lib.SubtitleLabel = subtitle
	local closeSize = math.clamp(math.floor(TB * 0.56), 26, 34)
	local close = new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -(lib.M.Pad + 2), 0, TB / 2),
		Size = UDim2.fromOffset(closeSize, closeSize), BorderSizePixel = 0, Text = "", AutoButtonColor = false,
	}, topbar)
	lib:Corner(close, 7)
	local closeIcon = lib:Icon(close, "x", 14, "Muted")
	closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	closeIcon.Position = UDim2.fromScale(0.5, 0.5)
	lib:Bind(function()
		close.BackgroundColor3 = lib.Theme.Surface
	end, close)
	close.MouseEnter:Connect(function()
		lib:Tween(close, { BackgroundColor3 = lib.Theme.Hover }, 0.12)
		lib:SetIconColor(closeIcon, "Text")
	end)
	close.MouseLeave:Connect(function()
		lib:Tween(close, { BackgroundColor3 = lib.Theme.Surface }, 0.12)
		lib:SetIconColor(closeIcon, "Muted")
	end)
	close.Activated:Connect(function()
		lib:ToggleUI(false)
	end)
	lib:MakeDraggable(topbar, window)

	local sidebar = new("Frame", { Name = "Sidebar", BackgroundTransparency = 1 }, window)
	lib.Sidebar = sidebar
	local nav = new("ScrollingFrame", {
		Name = "Navigation", BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
	}, sidebar)
	lib.Navigation = nav
	lib:RegisterScroller(nav)
	lib.NavLayout = new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, nav)

	local content = new("Frame", { Name = "Content", BorderSizePixel = 0, ClipsDescendants = true }, window)
	lib.Content = content
	lib:Corner(content, 8)
	lib:Bind(function()
		content.BackgroundColor3 = lib.Theme.Background
		content.BackgroundTransparency = lib.Theme.Transparency
	end, content)

	if options.Resizable ~= false then
		local grip = new("TextButton", {
			AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -2, 1, -2), Size = UDim2.fromOffset(18, 18),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 20,
		}, window)
		local gripIcon = lib:Icon(grip, "arrow-down-right", 12, "Muted")
		gripIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		gripIcon.Position = UDim2.fromScale(0.5, 0.5)
		lib:MakeResizable(grip, window, lib.MinWindowSize, Vector2.new(2000, 1400), function(v)
			lib.WindowSize = v
		end)
	end

	lib:LayoutShell()
	lib:FitWindow()
	lib:Connect(gui:GetPropertyChangedSignal("AbsoluteSize"), function()
		lib:FitWindow()
		for _, panel in ipairs(lib.Panels) do
			lib:ClampToScreen(panel.Frame)
		end
	end)
	lib:Bind(function()
		lib:FitWindow()
	end, window)

	lib:Connect(UserInputService.InputBegan, function(input, processed)
		if processed or not lib.ToggleKey or lib.CapturingKey or tick() - lib.LastCapture < 0.2 then
			return
		end
		if input.KeyCode == lib.ToggleKey then
			lib:ToggleUI()
		end
	end)

	if lib.ToggleButtonEnabled then
		lib:CreateToggleButton(lib.ToggleButtonOptions)
	end
	lib:CreateKeybindMenu({ Visible = options.KeybindMenu == true })
	if options.SilentStart ~= true then
		lib:Notify(lib.Name, "Interface initialized successfully.", 2.5)
	end
	return lib
end

function Spectra:BuildSettings(target, opts)
	opts = opts or {}
	local gb = target
	if getmetatable(target) == TabClass then
		gb = target:AddLeftGroupbox(opts.Title or "Interface", "Settings")
	end
	local lib = self
	local function buttonOptions()
		lib.ToggleButtonOptions = lib.ToggleButtonOptions or {}
		return lib.ToggleButtonOptions
	end
	gb:AddToggle("Spectra_ShowToggleButton", {
		Text = "Floating button", Icon = "mouse-pointer-click",
		Description = "Round button that opens and closes the interface.",
		Default = lib.ToggleButtonEnabled,
		Callback = function(value)
			lib:SetToggleButtonEnabled(value)
			if not value and lib.IsMobile then
				lib:Notify({
					Title = "Floating button disabled",
					Description = "Re-enable it from Settings or call ToggleUI() to reopen the interface.",
					Type = "Warning", Duration = 4,
				})
			end
		end,
	})
	gb:AddSlider("Spectra_ToggleButtonSize", {
		Text = "Button size", Min = 30, Max = 80, Default = lib.IsMobile and 50 or 44, Suffix = " px",
		Callback = function(value)
			buttonOptions().Size = value
			if lib.ToggleButton then
				lib.ToggleButton:SetSize(value)
			end
		end,
	})
	gb:AddSlider("Spectra_ToggleButtonAlpha", {
		Text = "Button transparency", Min = 0, Max = 0.9, Default = 0, Rounding = 2,
		Callback = function(value)
			buttonOptions().Transparency = value
			if lib.ToggleButton then
				lib.ToggleButton:SetTransparency(value)
			end
		end,
	})
	gb:AddToggle("Spectra_ShowKeybinds", {
		Text = "Keybind menu", Icon = "keyboard", Default = lib.KeybindMenu ~= nil and lib.KeybindMenu.Frame.Visible,
		Callback = function(value)
			lib:SetKeybindMenuVisible(value)
		end,
	})
	local keyLabel = gb:AddLabel({ Text = "Menu key", Icon = "command" })
	keyLabel:AddKeyPicker("Spectra_MenuKey", {
		Default = lib.ToggleKey or nil, Mode = "Press", NoUI = true, Text = "Menu key",
		ChangedCallback = function(key)
			lib:SetToggleKey(key)
		end,
	})
	gb:AddDropdown("Spectra_TabPosition", {
		Text = "Tab position", Icon = "panel-left", Values = { "Left", "Right", "Top", "Bottom" }, Default = lib.TabPosition,
		Callback = function(value)
			if value then
				lib:SetTabPosition(value)
			end
		end,
	})
	gb:AddToggle("Spectra_CompactTabs", {
		Text = "Compact tabs", Icon = "layout-list", Description = "Icons only; the selected tab keeps its name.",
		Default = lib.Compact,
		Callback = function(value)
			lib:SetCompactTabs(value)
		end,
	})
	gb:AddDropdown("Spectra_CompactLayout", {
		Text = "Compact tabs layout", Icon = "panel-top", Values = { "Side", "Top" }, Default = lib.CompactLayout,
		Callback = function(value)
			if value then
				lib:SetCompactLayout(value)
			end
		end,
	})
	gb:AddButton({
		Text = "Unload interface", Icon = "power", DoubleClick = true, ConfirmText = "Click again to unload",
		Func = function()
			lib:Destroy()
		end,
	})
	return gb
end

Spectra.Container = Container
Spectra.Element = Element

return Spectra
