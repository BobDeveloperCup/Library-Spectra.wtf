# Spectra.wtf — UI Library para Roblox (Luau)

Biblioteca de UI escura, compacta e modular, com Groupboxes, Tabboxes, ColorPicker completo, Keybinds, Viewport 3D,
Keybind Menu, Overlays, notificações, Save Manager, Theme Manager e suporte a PC e mobile.
Arquivo único, **sem `require()` e sem dependências externas**. Compatível com a API 1.x.

```
Spectra-wtf/
├─ Spectra.lua              # biblioteca (core + componentes + janela)
├─ addons/
│  ├─ SaveManager.lua       # configurações (JSON)
│  └─ ThemeManager.lua      # temas (JSON)
├─ Example.lua              # demonstração completa
├─ IconCatalog.md           # todos os ícones (nome → coluna/linha) + pendentes
├─ Presets/
│  └─ TestPreset.lua        # preset de testes com os componentes reais
├─ CHANGELOG.md             # alterações da versão 2.1.0
└─ README.md
```

## Instalação

Publique a pasta no GitHub e carregue pelos links *raw*:

```lua
local Spectra = loadstring(game:HttpGet("https://raw.githubusercontent.com/BobDeveloperCup/Library-Spectra.wtf/main/Spectra.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/BobDeveloperCup/Library-Spectra.wtf/main/addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/BobDeveloperCup/Library-Spectra.wtf/main/addons/ThemeManager.lua"))()

local UI = Spectra:CreateWindow({ Title = "Spectra.wtf", Subtitle = game.Name, ToggleKey = Enum.KeyCode.RightControl })
local Home = UI:CreateTab("Home", "Home")
local Welcome = UI:CreateSection(Home, "Welcome to Spectra.wtf", "Your interface. Your experience.")
Welcome:CreateLabel("Welcome to your workspace.")
```

Veja `Example.lua` para o uso completo.

## Versão 2.1.0

Detalhes completos em `CHANGELOG.md`. Resumo das APIs novas:

```lua
UI:SetStyle("Liquid Glass")
UI:SetDensity("Compact")
UI:SetTheme({ BackgroundImage = "rbxassetid://ID", BackgroundImageAlpha = 0.7, BackgroundBlur = 12 })
UI:SetTheme("TitleColor", Color3.fromRGB(255, 200, 80))
UI:CloseOverlays()
Spectra.IconManager:Info()
Spectra.IconManager:SetGrid({ Cell = 25, Size = 24, OffsetX = -1, OffsetY = 0, Width = 1000, Height = 1000 })
```

- **Estilos**: `Spectra`, `Liquid Glass`, `Glassmorphism`, `Minimalist`, `Neon`, `Obsidian` (`Spectra.StyleOrder`). Cada um define paleta, arredondamento, transparência por camada, traço, brilho (gradiente) e desfoque de fundo.
- **Densidade**: `Compact` e `Comfortable` (`Spectra.Densities`), aplicadas em tempo real a todos os componentes. Opção de janela `Density`.
- **Personalização**: `TitleColor`, `BackgroundImage` (asset id, número ou caminho de arquivo do executor), `BackgroundImageAlpha`, `BackgroundImageFit` (`Crop`, `Fit`, `Stretch`) e `BackgroundBlur`, todos salvos pelo ThemeManager.
- **Responsividade**: janelas com menos de 520 px de largura usam abas compactas automaticamente (`Responsive = false` desativa).
- **Preset de testes**: `Presets/TestPreset.lua` (ver `Example.lua`).

## Novidades da versão 2.0

- **Toggle / ColorPicker / KeyPicker**: o botão de clique do Toggle ficava *acima* dos addons e roubava o clique do seletor de cor e da tecla; agora fica abaixo (`ZIndex`) e só o próprio Toggle (ou a tecla configurada) altera o estado. Os controles de arrasto (SV, Hue, Alpha, sliders) usam uma camada de captura própria.
- **KeyPicker**: `Default = nil` não atribui tecla. Clique no botão → modo de captura (`...`); tecla válida → configura; **Backspace remove**; **Esc cancela**; Backspace nunca vira tecla. Atalhos globais e tecla do menu são suspensos durante a captura.
- **Mobile**: tamanho inicial menor (`MobileSize` opcional) e métricas proporcionais à resolução (alturas, espaçamentos e fontes calculados pelo lado menor da tela — não é um `Scale` global).
- **Botão flutuante**: opção `Spectra_ShowToggleButton` (em `BuildSettings`); desativado = o botão **não é criado** (e é destruído se existia). A preferência é salva pelo SaveManager.
- **Compact Tabs**: `CompactLayout = "Side" | "Top"` (janela, `UI:SetCompactLayout`, ou dropdown em `BuildSettings`). No topo as abas ficam em barra horizontal: só ícones, e a aba selecionada mostra o nome. O modo lateral continua disponível.
- **Icon Manager** (spritesheet única, `rbxassetid://139871994703359`) — ver abaixo.
- Código sem comentários, conexões de painéis/overlays/botão flutuante/janela de cor são desconectadas ao destruir.

## Icon Manager

```lua
Icon = "Settings"
Spectra.IconManager:Has("settings")
Spectra.IconManager:Get("check")
Spectra.IconManager:Register("meu-icone", 12, 7)
Spectra.IconManager:Alias("engrenagem", "settings")
Spectra.IconManager:SetAsset("rbxassetid://ID")
Spectra.IconManager:List()
```

- Catálogo com **1541 nomes** do Lucide 0.470.0, localizados na spritesheet por correlação de imagem (ver `IconCatalog.md`). `ImageRectOffset = (col*25 + OffsetX, row*25 + OffsetY)` (inteiro e limitado ao tamanho da folha), `ImageRectSize = (24, 24)`. O cálculo é feito em Luau (`IconManager:Rect`) e não depende de Python em nenhum momento.
- Nomes aceitam `kebab-case`, `PascalCase`, espaços e os nomes antigos (`Home`, `alert-triangle`...). Nome inexistente → ícone de fallback (`circle-help`) e um aviso único no console. `Icon = "rbxassetid://ID"` (ou número) continua usando um asset avulso.
- Cor/transparência: `UI:SetIconColor(holder, "Accent" | Color3)`, `UI:SetIconTransparency(holder, 0.5)`; `UI:Icon(parent, nome, tamanho, corTema)` cria um ícone em qualquer lugar.
- Integrado a Tabs, Compact Tabs, Groupboxes, Tabbox, Buttons, Toggles, Checkboxes, Sliders, Inputs, Dropdowns/Multidropdowns (por opção e no dropdown), Labels, Notifications, ColorPicker (`Icon` no título), KeyPicker (`Icon` no botão), Panels e Overlays.
- **Pendentes** (não incluídos, por não casarem com segurança): células (21, 3) e (5, 38) e o bloco 2×2 do canto superior esquerdo; registre-os manualmente se precisar.

## Bugs encontrados no `Spectra.lua` original (e correções)

| # | Problema | Correção |
|---|----------|----------|
| 1 | `CreateSection` devolvia uma tabela sem metatable: `section:CreateLabel(...)` (usado no exemplo da API) dava erro. | Seções agora são *containers* com todos os métodos (`Create*` e `Add*`). |
| 2 | Conexões de `InputChanged`/`InputEnded` do arrasto e dos tabs nunca eram guardadas; vazavam após `Destroy()`. | Todas passam por `Connect()` e são desconectadas no `Destroy()`. |
| 3 | `layout:GetPropertyChangedSignal` era conectado duas vezes por seção. | Substituído por `AutomaticSize`. |
| 4 | `ToggleUI` usava tamanhos fixos (820×490 / 780×450): ignorava `Size` e quebrava em telas pequenas. | Animação por `UIScale` e `FitWindow()` ajusta ao viewport. |
| 5 | Arrasto só funcionava com mouse (sem toque). | Mouse e toque, com limite de tela. |
| 6 | `Theme` era global e `SetTheme` não atualizava nada na tela. | Tema por instância com *hooks* reativos (tempo real). |
| 7 | Toggle disparava o callback na criação; `ColorPicker:Set` chamava callback fora de `task.spawn`. | Callbacks protegidos (`pcall` + `task.spawn`); disparo inicial só com `FireOnInit` (usado nos wrappers legados). |
| 8 | ColorPicker era só 6 cores fixas. | Seletor completo (ver abaixo). |
| 9 | Navegação com altura fixa (250) e sem rolagem. | `ScrollingFrame` com canvas automático. |
| 10 | Duplicação: só removia `PlayerGui.SpectraUI`. | Remove GUIs antigas por nome em `gethui`/CoreGui/PlayerGui e destrói a instância anterior (`getgenv().__SpectraWTF`). |
| 11 | Notificações empilhavam no mesmo ponto. | `UIListLayout` com empilhamento, tipos e fechamento manual. |

## Compatibilidade com a API 1.x

Continuam funcionando: `CreateWindow`, `CreateTab(name, icon)`, `CreateSection(tab, title, desc)`,
`CreateSectionForTab`, `CreateLabel`, `CreateButton(text, cb, icon)`, `CreateButtonRow({{Name, Icon, Callback}})`,
`CreateToggle(text, default, cb)` (`:Set`/`:Get`), `CreateColorPicker(text, default, cb)` (`:Set`/`:Get`),
`Notify(title, message, duration)`, `ToggleUI()`, `SetTheme(key, color)`, `Destroy()`.
Diferença: `CreateLabel/CreateButton` retornam objetos de componente (com `:SetText`, `:SetVisible`…), não a `Instance` crua.

## Arquitetura

- **Core**: tema reativo (`Bind`/`Themed`), animações (`Tween` respeita `AnimSpeed`/`Animations`), eventos rastreados, `Safe()` para callbacks.
- **Container**: base de Groupbox, Tabbox-tab, Section, Subsection e Panel. Todos expõem os mesmos `Add*`; podem ser aninhados (`AddSubsection`).
- **Element**: base dos componentes (`OnChanged`, `SetValue`, `SetVisible`, `SetText`, `SetDescription`, `SetDisabled`, `Destroy`).
  Registrados em `UI.Options` (todos) e `UI.Toggles` (Toggle/Checkbox).
- **Camadas** (ScreenGui): Overlays < Janela < Botão flutuante < Painéis flutuantes (ColorPicker, Keybind Menu) < Popups < Notificações.
- **Addons** independentes: `SaveManager`, `ThemeManager`.

## Janela

```lua
local UI = Spectra:CreateWindow({
  Title, Subtitle, Logo, Size = UDim2.fromOffset(820, 490), Position,
  ToggleKey = Enum.KeyCode.RightControl,   -- false desativa
  TabPosition = "Left" | "Right" | "Top" | "Bottom",
  CompactTabs = true|false,                -- só ícones (padrão: true no mobile)
  CompactLayout = "Side" | "Top",          -- Compact Tabs na lateral (padrão) ou em barra horizontal no topo
  MobileSize = UDim2.fromOffset(w, h),     -- tamanho inicial no mobile (padrão: proporcional à tela)
  Columns = 2,                             -- colunas padrão das abas (1–3)
  Mobile = true|false,                     -- força o modo (padrão: autodetecção)
  ToggleButton = true | false | { Size, Position, Image, Visible, Draggable, Transparency },
  KeybindMenu = true, Resizable = true, AutoShow = true, SilentStart = false, Theme = { Accent = Color3... },
})
```
Métodos: `CreateTab`, `SelectTab`, `GetTab`, `ToggleUI([estado])`, `SetToggleKey`, `SetTabPosition`, `SetCompactTabs`,
`SetCompactLayout`, `SetToggleButtonEnabled`, `SetTitle`, `SetSubtitle`, `SetLogo`, `SetTheme(chave, valor | tabela)`, `GetTheme`, `Notify`, `ClearNotifications`,
`CreatePanel`, `CreateOverlay`, `CreateKeybindMenu`, `SetKeybindMenuVisible`, `CreateToggleButton`, `BuildSettings`, `OnUnload`, `Destroy` (`Unload`).
`UI.OnToggle = function(aberto) end` é chamado ao abrir/fechar.

## Abas, Groupboxes, Tabboxes

```lua
local Tab = UI:CreateTab("Main", "Settings", { Columns = 2 })
local L = Tab:AddLeftGroupbox("Título", "Icon")        -- coluna 1
local R = Tab:AddRightGroupbox("Título")               -- coluna 2
local G = Tab:AddGroupbox("Título", { Column = 3, Height = 200, Collapsible = true, Description = "..." })
local S = Tab:AddSection("Título", "descrição")        -- largura total
local TB = Tab:AddRightTabbox(); local T1 = TB:AddTab("A"); local T2 = TB:AddTab("B", "Star")
local Sub = G:AddSubsection("Sub", "descrição")        -- aninhado
```
`Height` torna o corpo uma área com rolagem. Em largura estreita as colunas empilham automaticamente.
Containers: `SetTitle`, `SetDescription`, `SetVisible`, `SetCollapsed`, `Destroy`.

## Componentes (todos aceitam `Callback`, `Default`, `Text`, `Description`)

| Método | Opções principais | Métodos do objeto |
|---|---|---|
| `AddLabel(texto, wrap)` / `AddLabel(idx, {Text, Description, Icon, Image, DoesWrap, Bold})` | | `SetText`, `SetIcon`, `SetDescription`, `AddColorPicker`, `AddKeyPicker` |
| `AddButton({Text, Func, Icon, Image, DoubleClick, ConfirmText, Disabled})` | `:AddButton(...)` agrupa na mesma linha | `Click`, `SetText`, `SetIcon`, `SetDisabled`, `SetVisible`, `Destroy` |
| `AddToggle(idx, {Default, Disabled})` | | `SetValue`, `Toggle`, `Get`, `AddColorPicker`, `AddKeyPicker`, `OnChanged` |
| `AddCheckbox(idx, …)` | `Values = {...}`, `Multi`, `AllowNull` (grupo) | `SetValue`, `Get` |
| `AddDropdown(idx, {Values, Multi, Searchable, AllowNull, MaxVisible, Placeholder})` | valores `"x"` ou `{Name, Text, Icon, Image}` | `SetValue`, `SetValues`, `Refresh`, `GetActive` |
| `AddInput(idx, {Placeholder, Numeric, Min, Max, Finished})` | | `SetValue`, `SetPlaceholder`, `.Box` |
| `AddSlider(idx, {Min, Max, Increment, Rounding, Prefix, Suffix})` | | `SetValue`, `SetMin`, `SetMax` |
| `AddColorPicker(idx, {Default, Title, Transparency, Resizable})` ou `Toggle:AddColorPicker(...)` | `Transparency = 0` habilita alfa | `SetValue(cor\|hex, transp)`, `SetHSV`, `SetTransparency`, `GetHex`, `Open`, `Close` |
| `AddKeyPicker(idx, {Default, Mode, Text, SyncToggleState, NoUI, Clicked, ChangedCallback})` | Modos `Toggle`, `Hold`, `Always`, `Press` | `GetState`, `SetState`, `SetKey`, `SetMode`, `Activate`, `OnClick`, `SetHiddenInMenu` |
| `AddDivider(titulo, descrição)` | | `SetText` |
| `AddImage(idx, {Image, Height, ScaleType, Callback})` | | `SetImage`, `SetHeight`, `SetScaleType` |
| `AddViewport(idx, {Model, Height, Zoom, AutoRotate, Interactive})` | | `SetModel`, `GetModel`, `SetZoom`, `SetRotation`, `SetAutoRotate`, `SetFieldOfView` |

Todos os objetos também têm `OnChanged(fn)`, `SetVisible`, `SetText`, `SetDescription`, `SetDisabled` e `Destroy`.
Aliases `Create*` existem para cada `Add*`.

**ColorPicker**: área de saturação/brilho, barra Hue, barra de transparência opcional, pré-visualização (anterior/novo),
campo hexadecimal, campos RGB, atualização em tempo real, **Confirm** (fecha) e **Restore** (volta à cor de quando abriu),
janela arrastável e redimensionável (`Resizable = true` por padrão).

**KeyPicker**: clique para gravar (**Backspace** remove a tecla, **Esc** cancela; botões M2/M3 do mouse também; `Default = nil` = sem tecla); **botão direito** abre o menu de modo
(no mobile, tocar já abre esse menu). `SyncToggleState` sincroniza com o Toggle pai.

## Keybind Menu e Overlays

- `UI.KeybindMenu` (painel arrastável/recolhível) lista nome, tecla/modo e estado (ponto verde = ativo). Tocar/clicar numa entrada ativa o atalho.
  `picker:SetHiddenInMenu(true)` ou `NoUI = true` oculta a entrada.
- `UI:CreateOverlay("Label" | "Button" | "Indicator" | "Panel", opts)` → `Show`, `Hide`, `Toggle`, `SetVisible`, `Update{Text, Icon, Color, State, Position, Callback, Visible}`, `SetText`, `SetColor`, `SetState`, `Destroy`.
  `Draggable = false` fixa o overlay. `UI:CreatePanel{Title, Icon, Size, Position, Closable, Collapsible, Resizable, AutoHeight}` é um container completo.

## Notificações

```lua
UI:Notify({ Title = "Título", Description = "Texto", Type = "Success" --[[Error|Warning|Information]],
            Duration = 4 --[[0 = permanece]], Icon = "Star", Closable = true })
UI:Notify("Título", "Texto", 3, "Warning")   -- forma antiga
```
Empilham automaticamente (máx. 6 visíveis), animam entrada/saída e não bloqueiam cliques.

## Mobile

Detecção automática (`TouchEnabled` sem teclado) ou `Mobile = true`. Ajusta alturas/áreas de toque, abas compactas só com ícones,
tamanho da janela limitado ao viewport (reajusta ao girar a tela), notificações no topo, rolagem travada durante arrasto de sliders/cor/viewport,
arrasto por toque (janela, painéis, overlays, botão flutuante) e pinça para zoom no Viewport.
O **botão flutuante** com a logo abre/fecha a UI, é arrastável (toque simples ≠ arrasto) e tem `SetSize`, `SetImage`, `SetTransparency`, `Hide/Show`, `SetPosition`.
No PC, a tecla é configurável (`ToggleKey`, `UI:SetToggleKey`, ou `UI:BuildSettings(tab)` que adiciona um seletor).

## Save Manager

```lua
SaveManager:SetLibrary(UI)
SaveManager:SetFolder("MeuHub/MeuJogo")
SaveManager:SetIgnoreIndexes({ "MyToggle" })          -- opcional; índices "ThemeManager_*", "SaveManager_*" e "_*" já são ignorados
SaveManager:BuildConfigSection(Tab)                   -- criar, carregar, sobrescrever, renomear, excluir, atualizar, autoload, exportar/importar JSON
SaveManager:LoadAutoloadConfig()
-- API: Save, Load, Delete, Rename, List, Export, Import, Serialize, Deserialize, SetAutoload, GetAutoload, ResetAutoload, GetStorageMode()
```
Registra automaticamente Toggle, Checkbox, Dropdown, Slider, Input, ColorPicker e KeyPicker (tudo que está em `UI.Options`).
Ao carregar, os componentes são atualizados na tela e disparam seus callbacks.

## Theme Manager

`ThemeManager:SetLibrary(UI)`, `:SetFolder(...)`, `:ApplyToTab(Tab)`, `:LoadDefault()`, `:ApplyTheme("Midnight" | tabela)`,
`:SaveCustom/LoadCustom/DeleteCustom/ListCustom`, `:SetDefault`, `:Export/Import`. Presets: Spectra, Carbon, Midnight, Graphite, Ash, Paper.
Editável em tempo real: 13 cores, transparência da janela, escala, arredondamento, velocidade/liga-desliga de animações e fonte
(Gotham, Builder, Source, Code, Ubuntu, Arial). Também via código: `UI:SetTheme("Accent", Color3.fromRGB(...))`.

## Persistência e segurança

- Arquivos são usados **somente** se `writefile/readfile/isfile/isfolder/makefolder/listfiles/delfile` existirem e funcionarem.
  Caso contrário há **fallback em memória** (vale enquanto a sessão durar; sobrevive a re-execuções se `getgenv` existir).
  O README e a UI informam o modo (`Storage: files` / `memory only`). No Roblox Studio/cliente normal não há acesso a arquivos.
- Configurações e temas são lidos apenas com `JSONDecode` e validados por tipo; **nenhum código importado é executado**.

## Limitações e avisos (leia)

- **Teste realizado**: análise de sintaxe com `luau-analyze` e *smoke tests* automatizados contra um mock do ambiente Roblox
  (criação de janela/abas/todos os componentes, callbacks, ColorPicker, KeyPicker, Save/Load/Rename/Delete/Import/Export, temas, modo mobile).
  **Não foi possível executar dentro do Roblox**: valide visualmente no seu jogo/executor antes de publicar. O mock não verifica layout/aparência.
- **Ícones**: dependem do carregamento do asset `rbxassetid://139871994703359` (precisa estar acessível ao seu jogo/executor).
- **Viewport**: precisa de `Model`/`BasePart` com `Archivable = true` (clonado). Personagens podem exigir `Character.Archivable = true`.
- **KeyPicker no mobile**: sem teclado não há como gravar teclas; o toque abre o menu de modo e o Keybind Menu ativa por toque.
- **Escala**: `UIScale` por componente de topo (janela, painéis, popups, overlays); a posição dos painéis é em pixels de tela.
- `gethui`/`CoreGui` só são usados quando disponíveis; caso contrário a GUI vai para o `PlayerGui`.
- Mudar `Mobile` após criar a janela não é suportado (as métricas são fixadas na criação).
- A fonte `Code` usa `RobotoMono` para peso médio/negrito.
