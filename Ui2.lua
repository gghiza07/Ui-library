local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local config = {
    Name = "Liv",
    Width = 0.36,
    Height = 0.62,
    Theme = {
        Primary = Color3.fromRGB(14, 16, 20),
        Accent = Color3.fromRGB(84, 240, 255),
        Accent2 = Color3.fromRGB(150, 80, 255),
        Text = Color3.fromRGB(230,230,230),
        Sub = Color3.fromRGB(26,28,32)
    },
    Notification = {
        Duration = 4,
        SlideTime = 0.22,
        MaxActive = 6,
        NewOnTop = true
    }
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = config.Name or "Liv"
screenGui.Parent = game:GetService("CoreGui")
screenGui.DisplayOrder = 1000
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(config.Width, 0, config.Height, 0)
frame.Position = UDim2.new((1 - config.Width)/2, 0, (1 - config.Height)/2, 0)
frame.BackgroundColor3 = config.Theme.Primary
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ClipsDescendants = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

local frame2 = Instance.new("Frame")
frame2.Name = "Noting"
frame2.Size = UDim2.new(1, -12, 1, -12)
frame2.Position = UDim2.new(0, 6, 0, 6)
frame2.BackgroundTransparency = 0.9
frame2.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame2.BorderSizePixel = 0
frame2.Parent = frame
local frame2Corner = Instance.new("UICorner")
frame2Corner.CornerRadius = UDim.new(0, 12)
frame2Corner.Parent = frame2

local background = Instance.new("ImageLabel")
background.Name = "Background"
background.Size = UDim2.new(1,0,1,0)
background.Position = UDim2.new(0,0,0,0)
background.BackgroundTransparency = 1
background.Image = ""
background.ScaleType = Enum.ScaleType.Crop
background.Parent = frame2

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, config.Theme.Primary),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,14))
}
bgGradient.Rotation = 90
bgGradient.Parent = frame2

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1,0,0,44)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(0,0,0)
header.BackgroundTransparency = 0.94
header.BorderSizePixel = 0
header.Parent = frame2

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerAccent = Instance.new("Frame")
headerAccent.Size = UDim2.new(1,0,0,4)
headerAccent.Position = UDim2.new(0,0,1,-4)
headerAccent.BackgroundColor3 = config.Theme.Accent
headerAccent.BorderSizePixel = 0
headerAccent.Parent = header

local headerAccent2 = Instance.new("UIGradient")
headerAccent2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, config.Theme.Accent2), ColorSequenceKeypoint.new(1, config.Theme.Accent)}
headerAccent2.Parent = headerAccent

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -12, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = config.Name
title.TextColor3 = config.Theme.Text
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 92, 1, 0)
logo.Position = UDim2.new(1, -108, 0, 0)
logo.BackgroundTransparency = 1
logo.Text = "Liv • PGR"
logo.Font = Enum.Font.GothamSemibold
logo.TextSize = 12
logo.TextColor3 = config.Theme.Accent
logo.TextXAlignment = Enum.TextXAlignment.Right
logo.Parent = header

local TAB_WIDTH = 120
local tabsList = Instance.new("ScrollingFrame")
tabsList.Name = "TabsList"
tabsList.Size = UDim2.new(0, TAB_WIDTH, 1, -44)
tabsList.Position = UDim2.new(0,0,0,44)
tabsList.BackgroundTransparency = 1
tabsList.ScrollBarThickness = 6
tabsList.Parent = frame2

local tabsUIList = Instance.new("UIListLayout")
tabsUIList.Parent = tabsList
tabsUIList.SortOrder = Enum.SortOrder.LayoutOrder
tabsUIList.Padding = UDim.new(0,8)

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
local contentOffset = TAB_WIDTH + 20
contentArea.Size = UDim2.new(1, -contentOffset, 1, -44)
contentArea.Position = UDim2.new(0, contentOffset, 0, 44)
contentArea.BackgroundTransparency = 1
contentArea.Parent = frame2

local pages = Instance.new("Folder")
pages.Name = "Pages"
pages.Parent = contentArea

local notifications = Instance.new("Frame")
notifications.Name = "Notifications"
notifications.AnchorPoint = Vector2.new(0, 0)
notifications.Position = UDim2.new(0, 12, 0, 12)
notifications.Size = UDim2.new(0, 340, 0, 0)
notifications.BackgroundTransparency = 1
notifications.Parent = frame2

local notifList = Instance.new("UIListLayout")
notifList.Parent = notifications
notifList.SortOrder = Enum.SortOrder.LayoutOrder
notifList.Padding = UDim.new(0,8)
notifList.HorizontalAlignment = Enum.HorizontalAlignment.Left

local notificationCounter = 0
local activeNotifications = {}

local function safe(p, ...)
    local ok, res = pcall(p, ...)
    return ok, res
end

local function tweenObject(obj, props, style, dir, time)
    style = style or "Quad"
    dir = dir or "Out"
    time = time or 0.25
    local okStyle = Enum.EasingStyle[style] and Enum.EasingStyle[style] or Enum.EasingStyle.Quad
    local okDir = Enum.EasingDirection[dir] and Enum.EasingDirection[dir] or Enum.EasingDirection.Out
    local info = TweenInfo.new(time, okStyle, okDir)
    local tw = TweenService:Create(obj, info, props)
    safe(function() tw:Play() end)
    return tw
end

local currentPage, Tabs = nil, {}
local tabCounter = 0

local ElementAPI = {}

local function createTab(tabName)
    tabCounter = tabCounter + 1
    local myIndex = tabCounter

    local btn = Instance.new("TextButton")
    btn.Name = tabName.."_Tab"
    btn.Size = UDim2.new(1, -18, 0, 36)
    btn.BackgroundColor3 = config.Theme.Sub
    btn.TextColor3 = config.Theme.Text
    btn.Text = "   "..tabName
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = tabsList
    btn.LayoutOrder = myIndex

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 6, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
    accentBar.BorderSizePixel = 0
    accentBar.Parent = btn
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 8)
    accentCorner.Parent = accentBar

    local page = Instance.new("Frame")
    page.Name = tabName.."_Page"
    page.Size = UDim2.new(1,0,1,0)
    page.Position = UDim2.new(0,0,0,0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pages
    page.LayoutOrder = myIndex

    local list = Instance.new("UIListLayout")
    list.Parent = page
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0,10)

    local tabObj = {
        Button = btn,
        Page = page,
        Accent = accentBar
    }
    Tabs[tabName] = tabObj

    local function activate()
        if currentPage then
            Tabs[currentPage].Page.Visible = false
            Tabs[currentPage].Button.BackgroundColor3 = config.Theme.Sub
            Tabs[currentPage].Accent.BackgroundColor3 = Color3.fromRGB(40,40,40)
            Tabs[currentPage].Button.TextColor3 = config.Theme.Text
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(16,18,20)
        accentBar.BackgroundColor3 = config.Theme.Accent
        btn.TextColor3 = config.Theme.Accent
        currentPage = tabName
    end

    btn.MouseButton1Click:Connect(activate)

    if not currentPage then
        activate()
    end

    function tabObj:Button(name, callback)
        return ElementAPI.AddButton(self.Page, tostring(name or "Button"), callback or function() end)
    end

    function tabObj:Toggle(name, default, flag, callback)
        local t = ElementAPI.AddToggle(self.Page, tostring(name or "Toggle"), default == true, callback or function() end)
        t.Flag = flag
        return t
    end

    function tabObj:Input(name, removeMessage, flag, callback)
        local placeholder = (removeMessage == true) and "" or tostring(name or "")
        local box = ElementAPI.AddInput(self.Page, placeholder, callback or function() end)
        box.Flag = flag
        return box
    end

    function tabObj:Slider(name, upValue, rangeTable, flag, callback)
        local minv, maxv = 0, 100
        if type(rangeTable) == "table" then
            minv = tonumber(rangeTable[1]) or 0
            maxv = tonumber(rangeTable[2]) or math.max(1, minv)
        end
        local default = tonumber(upValue) or minv
        local s = ElementAPI.AddSlider(self.Page, tostring(name or "Slider"), minv, maxv, default, callback or function() end)
        s.Flag = flag
        return s
    end

    function tabObj:Dropdown(name, multi, options, current, flag, callback)
        options = options or {}
        if multi then
            local defaults = {}
            if type(current) == "table" then defaults = current
            elseif current then defaults = { current } end
            local ddm = ElementAPI.AddDropdownMulti(self.Page, tostring(name or "Multi"), options, defaults, callback or function() end)
            ddm.Flag = flag
            return ddm
        else
            local default = current or options[1]
            local dd = ElementAPI.AddDropdown(self.Page, tostring(name or "Dropdown"), options, default, callback or function() end)
            dd.Flag = flag
            return dd
        end
    end

    function tabObj:CreateToggle(opts)
        if type(opts) == "string" then
            return ElementAPI.AddToggle(self.Page, opts, false, function() end)
        end
        opts = opts or {}
        return ElementAPI.AddToggle(self.Page, opts.Name or "Toggle", opts.State or false, opts.Callback or function() end)
    end
    function tabObj:CreateButton(opts)
        if type(opts) == "string" then
            return ElementAPI.AddButton(self.Page, opts, function() end)
        end
        opts = opts or {}
        return ElementAPI.AddButton(self.Page, opts.Name or "Button", opts.Callback or function() end)
    end
    function tabObj:CreateSlider(opts)
        opts = opts or {}
        return ElementAPI.AddSlider(self.Page, opts.Name or "Slider", opts.Min or 0, opts.Max or 100, opts.Default or (opts.Min or 0), opts.Callback or function() end)
    end
    function tabObj:CreateDropdown(opts)
        opts = opts or {}
        return ElementAPI.AddDropdown(self.Page, opts.Name or "Dropdown", opts.Options or {}, opts.Default or (opts.Options and opts.Options[1]) or "Select", opts.Callback or function() end)
    end
    function tabObj:CreateDropdownMulti(opts)
        opts = opts or {}
        return ElementAPI.AddDropdownMulti(self.Page, opts.Name or "Multi", opts.Options or {}, opts.Defaults or {}, opts.Callback or function() end)
    end

    return tabObj
end

function ElementAPI.AddButton(parentPage, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(24,24,26)
    btn.TextColor3 = config.Theme.Text
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = parentPage
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn

    local debounce = false
    btn.MouseButton1Click:Connect(function()
        if debounce then return end
        debounce = true
        safe(function()
            callback()
        end)
        tweenObject(btn, {BackgroundTransparency = 0.6}, "Quad", "Out", 0.08)
        delay(0.06, function() tweenObject(btn, {BackgroundTransparency = 0}, "Quad", "Out", 0.08) end)
        delay(0.2, function() debounce = false end)
    end)
    return btn
end

function ElementAPI.AddInput(parentPage, placeholder, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -12, 0, 36)
    holder.BackgroundTransparency = 1
    holder.Parent = parentPage

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -12, 1, 0)
    box.Position = UDim2.new(0,6,0,0)
    box.BackgroundColor3 = Color3.fromRGB(24,24,26)
    box.TextColor3 = config.Theme.Text
    box.PlaceholderText = placeholder or "Type here..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = holder
    local corner = Instance.new("UICorner")
    corner.Parent = box

    box.FocusLost:Connect(function(enter)
        if enter then
            local txt = box.Text or ""
            txt = tostring(txt)
            txt = txt:gsub("%s+$", "")
            safe(function() callback(txt) end)
        end
    end)

    return box
end

function ElementAPI.AddToggle(parentPage, text, default, callback)
  local holder = Instance.new("Frame")
  holder.Size = UDim2.new(1, -12, 0, 36)
  holder.BackgroundTransparency = 1
  holder.Parent = parentPage

  local label = Instance.new("TextLabel")
  label.Size = UDim2.new(0.7, 0, 1, 0)
  label.Position = UDim2.new(0, 6, 0, 0)
  label.BackgroundTransparency = 1
  label.Text = text or "Toggle"
  label.TextColor3 = config.Theme.Text
  label.Font = Enum.Font.Gotham
  label.TextSize = 14
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Parent = holder

  local switch = Instance.new("TextButton")
  switch.Size = UDim2.new(0, 46, 0, 24)
  switch.Position = UDim2.new(1, -52, 0.5, -12)
  switch.BackgroundColor3 = Color3.fromRGB(36,36,38)
  switch.BorderSizePixel = 0
  switch.Parent = holder
  local switchCorner = Instance.new("UICorner")
  switchCorner.CornerRadius = UDim.new(0,12)
  switchCorner.Parent = switch

  local dot = Instance.new("Frame")
  dot.Size = UDim2.new(0, 18, 0, 18)
  dot.Position = UDim2.new(0, 4, 0.5, -9)
  dot.BackgroundColor3 = Color3.fromRGB(200,200,200)
  dot.BorderSizePixel = 0
  dot.Parent = switch
  local dotCorner = Instance.new("UICorner")
  dotCorner.CornerRadius = UDim.new(0,9)
  dotCorner.Parent = dot

  local state = (default == true)

  local function updateUI()
    if state then
      tweenObject(switch, {BackgroundColor3 = config.Theme.Accent}, "Quad", "Out", 0.12)
      tweenObject(dot, {Position = UDim2.new(1, -22, 0.5, -9)}, "Quad", "Out", 0.12)
      dot.BackgroundColor3 = Color3.fromRGB(30,30,32)
    else
      tweenObject(switch, {BackgroundColor3 = Color3.fromRGB(36,36,38)}, "Quad", "Out", 0.12)
      tweenObject(dot, {Position = UDim2.new(0, 4, 0.5, -9)}, "Quad", "Out", 0.12)
      dot.BackgroundColor3 = Color3.fromRGB(200,200,200)
    end
  end

  switch.MouseButton1Click:Connect(function()
    state = not state
    safe(function() callback(state) end)
    updateUI()
  end)

  updateUI()

  local ret = {}
  function ret.Set(v) state = not not v; updateUI(); safe(function() callback(state) end) end
  function ret.Get() return state end
    ret.UI = holder
    return ret
end

function ElementAPI.AddSlider(parentPage, text, min, max, default, callback)
  min = tonumber(min) or 0; max = tonumber(max) or 100; default = tonumber(default) or min
  if max < min then max, min = min, max end
  local holder = Instance.new("Frame")
  holder.Size = UDim2.new(1, -12, 0, 44)
  holder.BackgroundTransparency = 1
  holder.Parent = parentPage

  local label = Instance.new("TextLabel")
  label.Size = UDim2.new(0.45, 0, 0, 18)
  label.Position = UDim2.new(0, 6, 0, 4)
  label.BackgroundTransparency = 1
  label.Text = text or "Slider"
  label.TextColor3 = config.Theme.Text
  label.Font = Enum.Font.Gotham
  label.TextSize = 13
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Parent = holder

  local valueLabel = Instance.new("TextLabel")
  valueLabel.Size = UDim2.new(0.5, -12, 0, 18)
  valueLabel.Position = UDim2.new(0.5, 6, 0, 4)
  valueLabel.BackgroundTransparency = 1
  valueLabel.Text = tostring(default)
  valueLabel.TextColor3 = config.Theme.Text
  valueLabel.Font = Enum.Font.Gotham
  valueLabel.TextSize = 13
  valueLabel.TextXAlignment = Enum.TextXAlignment.Right
  valueLabel.Parent = holder

  local barHolder = Instance.new("Frame")
  barHolder.Size = UDim2.new(1, -12, 0, 12)
  barHolder.Position = UDim2.new(0, 6, 0, 24)
  barHolder.BackgroundColor3 = Color3.fromRGB(36,36,38)
  barHolder.BorderSizePixel = 0
  barHolder.Parent = holder
  local barCorner = Instance.new("UICorner")
  barCorner.CornerRadius = UDim.new(0,6)
  barCorner.Parent = barHolder

  local fill = Instance.new("Frame")
  fill.Size = UDim2.new(0, 0, 1, 0)
  fill.Position = UDim2.new(0,0,0,0)
  fill.BackgroundColor3 = config.Theme.Accent
  fill.BorderSizePixel = 0
  fill.Parent = barHolder
  local fillCorner = Instance.new("UICorner")
  fillCorner.CornerRadius = UDim.new(0,6)
  fillCorner.Parent = fill

  local knob = Instance.new("TextButton")
  knob.Size = UDim2.new(0, 16, 0, 16)
  knob.AnchorPoint = Vector2.new(0.5, 0.5)
  knob.Position = UDim2.new(0, 0, 0.5, 0)
  knob.BackgroundColor3 = Color3.fromRGB(230,230,230)
  knob.BorderSizePixel = 0
  knob.Parent = barHolder
  local knobCorner = Instance.new("UICorner")
  knobCorner.CornerRadius = UDim.new(0,8)
  knobCorner.Parent = knob

  local dragging = false
  local function setValueFromX(x)
    if not barHolder or not barHolder.AbsoluteSize or barHolder.AbsoluteSize.X == 0 then return end
    local abs = barHolder.AbsoluteSize.X
    local rel = math.clamp((x - barHolder.AbsolutePosition.X) / abs, 0, 1)
    local value = min + (max - min) * rel
    local rounded = math.floor(value + 0.5)
    local pct = rel
    fill.Size = UDim2.new(pct, 0, 1, 0)
    knob.Position = UDim2.new(pct, 0, 0.5, 0)
    valueLabel.Text = tostring(rounded)
    safe(function() callback(rounded) end)
  end

  knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
    end
  end)

  knob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
  end)
  UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      setValueFromX(input.Position.X)
    end
  end)
  barHolder.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      setValueFromX(input.Position.X)
    end
  end)

  do
    local range = math.max(1, (max - min))
    local pct = (default - min) / range
    pct = math.clamp(pct, 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    knob.Position = UDim2.new(pct, 0, 0.5, 0)
    valueLabel.Text = tostring(default)
  end

  local ret = {}
  function ret.Set(v)
      v = tonumber(v) or min
      local range = math.max(1, (max - min))
      local pct = (v - min) / range; pct = math.clamp(pct, 0, 1)
      fill.Size = UDim2.new(pct,0,1,0)
      knob.Position = UDim2.new(pct,0,0.5,0)
      valueLabel.Text = tostring(v)
      safe(function() callback(v) end)
  end
  function ret.Get() return tonumber(valueLabel.Text) end
    ret.UI = holder
    return ret
end

local function clampDropdownPosition(x, y, width, height)
    local viewport = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local vx, vy = viewport.X, viewport.Y
    local finalX = math.clamp(x, 0, math.max(0, vx - width))
    local finalY = math.clamp(y, 0, math.max(0, vy - height))
    return finalX, finalY
end

function ElementAPI.AddDropdown(parentPage, text, options, default, callback)
  options = options or {}
  local holder = Instance.new("Frame")
  holder.Size = UDim2.new(1, -12, 0, 36)
  holder.BackgroundTransparency = 1
  holder.Parent = parentPage

  local label = Instance.new("TextLabel")
  label.Size = UDim2.new(0.65, 0, 1, 0)
  label.Position = UDim2.new(0, 6, 0, 0)
  label.BackgroundTransparency = 1
  label.Text = text or "Dropdown"
  label.TextColor3 = config.Theme.Text
  label.Font = Enum.Font.Gotham
  label.TextSize = 14
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Parent = holder

  local box = Instance.new("TextButton")
  box.Size = UDim2.new(0.35, -6, 1, 0)
  box.Position = UDim2.new(1, - (0.35 * 400) - 6, 0, 0)
  box.AnchorPoint = Vector2.new(1, 0)
  box.BackgroundColor3 = Color3.fromRGB(36,36,38)
  box.BorderSizePixel = 0
  box.Text = tostring(default or (options[1] or "Select"))
  box.TextColor3 = config.Theme.Text
  box.Font = Enum.Font.Gotham
  box.TextSize = 13
  box.Parent = holder
  local boxCorner = Instance.new("UICorner")
  boxCorner.CornerRadius = UDim.new(0,8)
  boxCorner.Parent = box

  local open = false
  local listFrame

  local function openList()
    if open then return end
      open = true
      listFrame = Instance.new("Frame")
      listFrame.Name = "DropdownList"
      listFrame.BackgroundColor3 = Color3.fromRGB(26,26,28)
      listFrame.BorderSizePixel = 0
      listFrame.ZIndex = 2000
      listFrame.Parent = screenGui

      local itemHeight = 28
      local maxHeight = math.clamp(#options * itemHeight, itemHeight, 200)
      local width = math.max(160, box.AbsoluteSize.X)
      listFrame.Size = UDim2.new(0, width, 0, maxHeight)

      local screenX = math.clamp(box.AbsolutePosition.X, 0, Workspace.CurrentCamera.ViewportSize.X - width)
      local screenY = box.AbsolutePosition.Y + holder.AbsoluteSize.Y + 4
      local fx, fy = clampDropdownPosition(screenX, screenY, width, maxHeight)
      listFrame.Position = UDim2.new(0, fx - screenGui.AbsolutePosition.X, 0, fy - screenGui.AbsolutePosition.Y)

      local listLayout = Instance.new("UIListLayout")
      listLayout.Parent = listFrame
      listLayout.SortOrder = Enum.SortOrder.LayoutOrder
      listLayout.Padding = UDim.new(0,4)

      for i,opt in ipairs(options) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -8, 0, itemHeight)
        b.Position = UDim2.new(0,4,0, (i-1)*itemHeight)
        b.BackgroundTransparency = 0
        b.BackgroundColor3 = Color3.fromRGB(34,34,36)
        b.BorderSizePixel = 0
        b.Text = tostring(opt)
        b.TextColor3 = config.Theme.Text
        b.Font = Enum.Font.Gotham
        b.TextSize = 13
        b.Parent = listFrame
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0,6)
        bCorner.Parent = b

        b.MouseButton1Click:Connect(function()
          box.Text = tostring(opt)
          safe(function() callback(opt) end)
          if listFrame and listFrame.Parent then listFrame:Destroy() end
          open = false
        end)
      end

      local conn
      conn = UserInputService.InputBegan:Connect(function(inp)
          if inp.UserInputType == Enum.UserInputType.MouseButton1 then
              local mousePos = UserInputService:GetMouseLocation()
              local px, py = mousePos.X, mousePos.Y
              local absPos = listFrame.AbsolutePosition
              if not (px >= absPos.X and px <= absPos.X + listFrame.AbsoluteSize.X and py >= absPos.Y and py <= absPos.Y + listFrame.AbsoluteSize.Y) then
                  if listFrame and listFrame.Parent then listFrame:Destroy() end
                  open = false
                  conn:Disconnect()
              end
          end
      end)
  end

  box.MouseButton1Click:Connect(function()
    if open then
      if listFrame and listFrame.Parent then listFrame:Destroy() end
        open = false
      else
        openList()
    end
  end)

    local ret = {}
    function ret.Get() return box.Text end
    function ret.Set(v) box.Text = tostring(v); safe(function() callback(v) end) end
    ret.UI = holder
    return ret
end

function ElementAPI.AddDropdownMulti(parentPage, text, options, defaults, callback)
    options = options or {}
    defaults = defaults or {}
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -12, 0, 36)
    holder.BackgroundTransparency = 1
    holder.Parent = parentPage

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "MultiDropdown"
    label.TextColor3 = config.Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0.35, -6, 1, 0)
    box.AnchorPoint = Vector2.new(1, 0)
    box.Position = UDim2.new(1, -6, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(36,36,38)
    box.BorderSizePixel = 0
    box.Text = #defaults > 0 and table.concat(defaults, ", ") or "Select..."
    box.TextColor3 = config.Theme.Text
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.Parent = holder
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0,8)
    boxCorner.Parent = box

    local open = false
    local listFrame
    local selected = {}
    for _,v in ipairs(defaults) do selected[v] = true end

    local function updateBoxText()
        local t = {}
        for k,_ in pairs(selected) do table.insert(t, k) end
        box.Text = #t > 0 and table.concat(t, ", ") or "Select..."
    end

    local function openList()
        if open then return end
        open = true
        listFrame = Instance.new("Frame")
        listFrame.Name = "MultiDropdownList"
        listFrame.BackgroundColor3 = Color3.fromRGB(26,26,28)
        listFrame.BorderSizePixel = 0
        listFrame.ZIndex = 2000
        listFrame.Parent = screenGui

        local itemHeight = 28
        local maxHeight = math.clamp(#options * itemHeight, itemHeight, 240)
        local width = math.max(160, box.AbsoluteSize.X)
        listFrame.Size = UDim2.new(0, width, 0, maxHeight)
        local screenX = math.clamp(box.AbsolutePosition.X, 0, Workspace.CurrentCamera.ViewportSize.X - width)
        local screenY = box.AbsolutePosition.Y + holder.AbsoluteSize.Y + 4
        local fx, fy = clampDropdownPosition(screenX, screenY, width, maxHeight)
        listFrame.Position = UDim2.new(0, fx - screenGui.AbsolutePosition.X, 0, fy - screenGui.AbsolutePosition.Y)

        for i,opt in ipairs(options) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 0, itemHeight)
            b.Position = UDim2.new(0,4,0, (i-1)*itemHeight)
            b.BackgroundTransparency = 0
            b.BackgroundColor3 = Color3.fromRGB(34,34,36)
            b.BorderSizePixel = 0
            b.Text = tostring(opt)
            b.TextColor3 = config.Theme.Text
            b.Font = Enum.Font.Gotham
            b.TextSize = 13
            b.Parent = listFrame
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0,6)
            bCorner.Parent = b

            local tick = Instance.new("TextLabel")
            tick.Size = UDim2.new(0, 18, 1, 0)
            tick.Position = UDim2.new(1, -22, 0, 0)
            tick.BackgroundTransparency = 1
            tick.Text = selected[opt] and "✓" or ""
            tick.TextColor3 = config.Theme.Accent
            tick.Font = Enum.Font.GothamBold
            tick.TextSize = 14
            tick.Parent = b

            b.MouseButton1Click:Connect(function()
                if selected[opt] then selected[opt] = nil else selected[opt] = true end
                tick.Text = selected[opt] and "✓" or ""
                updateBoxText()
                local out = {}
                for k,_ in pairs(selected) do table.insert(out, k) end
                safe(function() callback(out) end)
            end)
        end

        local conn
        conn = UserInputService.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = UserInputService:GetMouseLocation()
                local px, py = mousePos.X, mousePos.Y
                local absPos = listFrame.AbsolutePosition
                if not (px >= absPos.X and px <= absPos.X + listFrame.AbsoluteSize.X and py >= absPos.Y and py <= absPos.Y + listFrame.AbsoluteSize.Y) then
                    if listFrame and listFrame.Parent then listFrame:Destroy() end
                    open = false
                    conn:Disconnect()
                end
            end
        end)
    end

    box.MouseButton1Click:Connect(function()
        if open then if listFrame and listFrame.Parent then listFrame:Destroy() end; open = false
        else openList() end
    end)

    local ret = {}
    function ret.Get()
        local out = {}
        for k,_ in pairs(selected) do table.insert(out, k) end
        return out
    end
    function ret.Set(t)
        selected = {}
        for _,v in ipairs(t or {}) do selected[v] = true end
        updateBoxText()
        safe(function() callback(ret.Get()) end)
    end
    ret.UI = holder
    return ret
end

btn = function(tab, text, callback)
    return ElementAPI.AddButton(tab.Page or tab, text, callback)
end
tog = function(tab, text, default, callback)
    return ElementAPI.AddToggle(tab.Page or tab, text, default, callback)
end
sld = function(tab, text, min, max, default, callback)
    return ElementAPI.AddSlider(tab.Page or tab, text, min, max, default, callback)
end
dd = function(tab, text, options, default, callback)
    return ElementAPI.AddDropdown(tab.Page or tab, text, options, default, callback)
end
ddm = function(tab, text, options, defaults, callback)
    return ElementAPI.AddDropdownMulti(tab.Page or tab, text, options, defaults, callback)
end

local function safePlaySound(parent, soundAssetId, volume, pitch)
    if not soundAssetId then return end
    safe(function()
        local s = Instance.new("Sound")
        local sid = tostring(soundAssetId)
        s.SoundId = (sid:match("^rbxassetid://") and sid) or ("rbxassetid://"..sid)
        s.Volume = volume or 1
        s.PlaybackSpeed = pitch or 1
        s.Parent = parent
        s.Looped = false
        s:Play()
        s.Ended:Connect(function()
            safe(function() s:Destroy() end)
        end)
    end)
end

local function CreateNotification(title, text, duration, soundAssetId)
    duration = tonumber(duration) or config.Notification.Duration
    notificationCounter = notificationCounter + 1
    local id = notificationCounter

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 320, 0, 72)
    notif.BackgroundColor3 = Color3.fromRGB(18,18,20)
    notif.BorderSizePixel = 0
    notif.BackgroundTransparency = 1
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = notif

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -12, 0, 20)
    ttl.Position = UDim2.new(0, 8, 0, 6)
    ttl.BackgroundTransparency = 1
    ttl.Text = title or "Notification"
    ttl.Font = Enum.Font.GothamBold
    ttl.TextSize = 14
    ttl.TextColor3 = config.Theme.Text
    ttl.Parent = notif

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -12, 0, 40)
    body.Position = UDim2.new(0, 8, 0, 26)
    body.BackgroundTransparency = 1
    body.Text = text or ""
    body.Font = Enum.Font.Gotham
    body.TextSize = 13
    body.TextColor3 = Color3.fromRGB(200,200,200)
    body.TextWrapped = true
    body.Parent = notif

    if soundAssetId then safePlaySound(notif, soundAssetId, 1, 1) end

    if notifications and notifications.Parent ~= screenGui then
        notifications.Parent = screenGui
    end
    notifications.AnchorPoint = Vector2.new(1, 0)
    notifications.Position = UDim2.new(1, -12, 0, 12)
    notifList.HorizontalAlignment = Enum.HorizontalAlignment.Right

    if config.Notification.NewOnTop then
        notif.LayoutOrder = -id
    else
        notif.LayoutOrder = id
    end

    table.insert(activeNotifications, notif)
    if #activeNotifications > config.Notification.MaxActive then
        local toRemove = table.remove(activeNotifications, 1)
        if toRemove and toRemove.Parent then
            pcall(function()
                tweenObject(toRemove, {BackgroundTransparency = 1}, "Quad", "In", config.Notification.SlideTime)
                wait(config.Notification.SlideTime + 0.02)
                if toRemove and toRemove.Parent then toRemove:Destroy() end
            end)
        end
    end

    notif.Parent = notifications

    tweenObject(notif, {BackgroundTransparency = 0}, "Quad", "Out", config.Notification.SlideTime)

    local removed = false
    delay(duration, function()
        if removed then return end
        if notif and notif.Parent then
            pcall(function()
                tweenObject(notif, {BackgroundTransparency = 1}, "Quad", "In", config.Notification.SlideTime)
                wait(config.Notification.SlideTime + 0.06)
                if notif and notif.Parent then notif:Destroy() end
            end)
        end
        removed = true
    end)

    notif.Active = true
    notif.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if removed then return end
            removed = true
            safe(function()
                tweenObject(notif, {BackgroundTransparency = 1}, "Quad", "In", config.Notification.SlideTime)
                delay(config.Notification.SlideTime + 0.02, function()
                    if notif and notif.Parent then notif:Destroy() end
                end)
            end)
        end
    end)

    return notif
end

local function PlaySound(assetId, volume, pitch)
    if not assetId then return nil end
    local sid = tostring(assetId)
    local ok
    ok = pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = (sid:match("^rbxassetid://") and sid) or ("rbxassetid://"..sid)
        s.Volume = tonumber(volume) or 1
        s.PlaybackSpeed = tonumber(pitch) or 1
        s.Parent = SoundService
        s:Play()
        s.Ended:Connect(function()
            pcall(function() s:Destroy() end)
        end)
        return s
    end)
    return ok
end

local function canWriteFile()
    return type(writefile) == "function" and type(readfile) == "function"
end

local function saveToFile(filename, data)
    if not canWriteFile() then
        return false, "writefile not available"
    end
    local ok, err = pcall(function()
        writefile(filename, data)
    end)
    if not ok then return false, err end
    return true
end

local function loadFromFile(filename)
    if not canWriteFile() then return nil, "readfile not available" end
    local ok, content = pcall(function() return readfile(filename) end)
    if not ok then return nil, content end
    return content, nil
end

local WindowSettings = {}

local function SaveSettingsToDisk(winName, t)
    local filename = (winName or config.Name) .. "_livui_settings.json"
    local ok, encoded = pcall(function() return HttpService:JSONEncode(t) end)
    if not ok then return false, "encode error" end
    return saveToFile(filename, encoded)
end

local function LoadSettingsFromDisk(winName)
    local filename = (winName or config.Name) .. "_livui_settings.json"
    local content, err = loadFromFile(filename)
    if not content then return nil, err end
    local ok, decoded = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok then return nil, decoded end
    return decoded, nil
end

local Window = {}
Window.CreateTab = createTab
Window.Elements = ElementAPI
Window.SetBackground = nil
Window.Notify = CreateNotification
Window.PlaySound = PlaySound

local warperFramerate = 24
local lastFrameDefault = 1
local framesDefault = 25
local rowsDefault = 5
local columnsDefault = 5

local gifAnimator = {}

local function makeRbxThumb(id, w, h)
    w = tonumber(w) or 420
    h = tonumber(h) or w
    return ("rbxthumb://type=Asset&id=%s&w=%d&h=%d"):format(tostring(id), w, h)
end

local function stopGif()
    if gifAnimator.conn then
        pcall(function() gifAnimator.conn:Disconnect() end)
        gifAnimator.conn = nil
    end
    if gifAnimator.wrapper and gifAnimator.wrapper.Parent then
        pcall(function() gifAnimator.wrapper:Destroy() end)
        gifAnimator.wrapper = nil
    end
    gifAnimator = {}
end

local function startGif(assetString, opts)
    stopGif()
    opts = opts or {}
    local framerate = tonumber(opts.framerate) or warperFramerate
    local frames = tonumber(opts.frames) or framesDefault
    local rows = tonumber(opts.rows) or rowsDefault
    local columns = tonumber(opts.columns) or columnsDefault
    local asset = tostring(assetString)
    local w,h = 420,420
    pcall(function()
        if frame and frame.AbsoluteSize and frame.AbsoluteSize.X and frame.AbsoluteSize.Y then
            w = math.max(64, math.floor(frame.AbsoluteSize.X))
            h = math.max(64, math.floor(frame.AbsoluteSize.Y))
        end
    end)
    local imageUrl = asset
    local aid = asset:match("^%d+$")
    if aid then
        imageUrl = makeRbxThumb(aid, w, h)
    else
        local m = asset:match("^rbxassetid://(%d+)$")
        if m then imageUrl = makeRbxThumb(m, w, h) end
        if asset:match("^rbxthumb://") then imageUrl = asset end
    end
    local wrapper = Instance.new("Frame")
    wrapper.Name = "GifWrapper"
    wrapper.Size = UDim2.new(1,0,1,0)
    wrapper.Position = UDim2.new(0,0,0,0)
    wrapper.BackgroundTransparency = 1
    wrapper.ClipsDescendants = true
    wrapper.Parent = frame2
    local sprite = Instance.new("ImageLabel")
    sprite.Name = "Animated"
    sprite.Size = UDim2.new(columns,0,rows,0)
    sprite.Position = UDim2.new(0,0,0,0)
    sprite.BackgroundTransparency = 1
    sprite.ScaleType = Enum.ScaleType.Crop
    sprite.Image = imageUrl
    sprite.Parent = wrapper
    gifAnimator.wrapper = wrapper
    gifAnimator.sprite = sprite
    gifAnimator.t = tick()
    gifAnimator.lastFrame = tonumber(opts.startFrame) or lastFrameDefault
    gifAnimator.conn = RunService.RenderStepped:Connect(function()
        if tick() - gifAnimator.t >= 1 / framerate then
            gifAnimator.lastFrame = gifAnimator.lastFrame + 1
            if gifAnimator.lastFrame > frames then gifAnimator.lastFrame = 1 end
            local CurrentColumn = gifAnimator.lastFrame
            local CurrentRow = 1
            repeat
                if CurrentColumn > columns then
                    CurrentColumn = CurrentColumn - columns
                    CurrentRow = CurrentRow + 1
                end
            until not (CurrentColumn > columns)
            sprite.Position = UDim2.new(-(CurrentColumn - 1), 0, -(CurrentRow - 1), 0)
            gifAnimator.t = tick()
        end
    end)
end

local function SetBackgroundImage(input)
    stopGif()
    if not input or tostring(input) == "" then
        background.Image = ""
        background.Visible = true
        return
    end
    local s = tostring(input):gsub("^%s*(.-)%s*$", "%1")
    local gifPayload = s:match("^gif:(.+)$")
    if gifPayload then
        startGif(gifPayload)
        return
    end
    local w,h = 420,420
    pcall(function()
        if frame and frame.AbsoluteSize and frame.AbsoluteSize.X and frame.AbsoluteSize.Y then
            w = math.max(64, math.floor(frame.AbsoluteSize.X))
            h = math.max(64, math.floor(frame.AbsoluteSize.Y))
        end
    end)
    if tonumber(s) then
        background.Image = makeRbxThumb(s, w, h)
        background.Visible = true
        safe(function() pcall(function() ContentProvider:PreloadAsync({background.Image}) end) end)
        return
    end
    local assetIdMatch = s:match("^rbxassetid://(%d+)$")
    if assetIdMatch then
        background.Image = makeRbxThumb(assetIdMatch, w, h)
        background.Visible = true
        safe(function() pcall(function() ContentProvider:PreloadAsync({background.Image}) end) end)
        return
    end
    if s:match("^rbxthumb://") then
        background.Image = s
        background.Visible = true
        safe(function() pcall(function() ContentProvider:PreloadAsync({background.Image}) end) end)
        return
    end
    background.Image = s
    background.Visible = true
    safe(function() pcall(function() ContentProvider:PreloadAsync({background.Image}) end) end)
end

Window.SetBackground = SetBackgroundImage

function Window:Window(opts)
    opts = opts or {}
    local winName = opts.Name or config.Name or "Liv"
    local rawSave = opts.Save or opts.save
    local saveCfg = { Save = false, Saveload = false }
    if type(rawSave) == "table" then
        saveCfg.Save = rawSave.Save and true or false
        saveCfg.Saveload = rawSave.Saveload and true or false
    elseif rawSave == true then
        saveCfg.Save = true
    end

    local window = {}
    window.Name = winName
    window.save = saveCfg

    pcall(function()
        if notifications and notifications.Parent ~= screenGui then
            notifications.Parent = screenGui
        end
        if notifications then
            notifications.AnchorPoint = Vector2.new(1, 0)
            notifications.Position = UDim2.new(1, -12, 0, 12)
            notifList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        end
    end)

    local function UpdateRootSettings()
        WindowSettings[winName] = WindowSettings[winName] or {}
        local pos = frame.Position
        local size = frame.Size
        WindowSettings[winName].Root = { pos.X.Offset, pos.Y.Offset, size.X.Offset, size.Y.Offset }
    end

    local function SaveNow()
        WindowSettings[winName] = WindowSettings[winName] or {}
        UpdateRootSettings()
        local ok, err = SaveSettingsToDisk(winName, WindowSettings[winName])
        if ok then
            CreateNotification("Liv", "Settings saved", 2)
        else
            CreateNotification("Liv", "Save failed: "..tostring(err), 4)
        end
        return ok, err
    end

    local function LoadNow()
        local loaded, err = LoadSettingsFromDisk(winName)
        if loaded then
            WindowSettings[winName] = loaded
            if loaded.Background then
                SetBackgroundImage(loaded.Background)
            end
            if loaded.Root and loaded.Root[3] and loaded.Root[4] then
                pcall(function()
                    frame.Size = UDim2.new(0, loaded.Root[3], 0, loaded.Root[4])
                    frame.Position = UDim2.new(0, loaded.Root[1], 0, loaded.Root[2])
                end)
            end
            CreateNotification("Liv", "Settings loaded", 2)
            return true
        else
            CreateNotification("Liv", "No saved settings found", 2)
            return false, err
        end
    end

    if window.save.Saveload then
        pcall(LoadNow)
    end

    if window.save.Save then
        frame:GetPropertyChangedSignal("Position"):Connect(function() pcall(SaveNow) end)
        frame:GetPropertyChangedSignal("Size"):Connect(function() pcall(SaveNow) end)
    end

    local settingsTab = createTab("Settings UI")
    local settingsPage = settingsTab.Page

    if Tabs["Settings UI"] then
        local t = Tabs["Settings UI"]
        if typeof(t.Button) == "Instance" then
            pcall(function() t.Button.LayoutOrder = 9999 end)
        end
        if typeof(t.Page) == "Instance" then
            pcall(function() t.Page.LayoutOrder = 9999 end)
        end
    end

    local bgLabel = Instance.new("TextLabel")
    bgLabel.Size = UDim2.new(1, -12, 0, 16)
    bgLabel.BackgroundTransparency = 1
    bgLabel.Text = "Background (id, rbxthumb://..., or gif:<id>)"
    bgLabel.TextColor3 = config.Theme.Text
    bgLabel.Font = Enum.Font.Gotham
    bgLabel.TextSize = 12
    bgLabel.TextXAlignment = Enum.TextXAlignment.Left
    bgLabel.Parent = settingsPage

    local bgInput = ElementAPI.AddInput(settingsPage, "e.g. 12345678 or rbxthumb://... or gif:12345678", function(txt) end)
    bgInput.PlaceholderText = "Asset id (numbers) or rbxthumb URL or gif:<id>"

    if opts.ShowSaveToggle then
        ElementAPI.AddToggle(settingsPage, "Auto Save Settings", window.save.Save or false, function(state)
            window.save.Save = state
            WindowSettings[winName] = WindowSettings[winName] or {}
            WindowSettings[winName].AutoSave = state
            if state then
                CreateNotification("Liv", "Auto Save enabled", 2)
                frame:GetPropertyChangedSignal("Position"):Connect(function() pcall(SaveNow) end)
                frame:GetPropertyChangedSignal("Size"):Connect(function() pcall(SaveNow) end)
            else
                CreateNotification("Liv", "Auto Save disabled", 2)
            end
        end)
    end

    window.SaveNow = SaveNow
    window.LoadNow = LoadNow

    bgInput.FocusLost:Connect(function(enter)
        if enter and bgInput.Text ~= "" then
            SetBackgroundImage(bgInput.Text)
            WindowSettings[winName] = WindowSettings[winName] or {}
            WindowSettings[winName].Background = bgInput.Text
            if window.save and window.save.Save then
                SaveNow()
            else
                CreateNotification("Liv", "Background applied (not saved)", 2)
            end
        end
    end)

    function window.CreateTab(name)
        return createTab(name)
    end
    function window.GetSettings()
        return WindowSettings[winName]
    end
    function window.SetBackground(v)
        SetBackgroundImage(v)
        WindowSettings[winName] = WindowSettings[winName] or {}
        WindowSettings[winName].Background = v
        if window.save and window.save.Save then
            SaveNow()
        end
    end
    return window
end

Window.CreateWindow = Window.Window

local ui = Window

do
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = frame.Position
        end
    end

    local function onInputChanged(input)
        if not dragging then return end
        if input ~= dragInput then return end
        local delta = input.Position - dragStart
        local newX = startPos.X.Scale
        local newXOffset = startPos.X.Offset + delta.X
        local newY = startPos.Y.Scale
        local newYOffset = startPos.Y.Offset + delta.Y
        frame.Position = UDim2.new(newX, newXOffset, newY, newYOffset)
    end

    local function onInputEnded(input)
        if input == dragInput then
            dragging = false
            dragInput = nil
            dragStart = nil
            startPos = nil
        end
    end

    header.InputBegan:Connect(onInputBegan)
    header.InputChanged:Connect(onInputChanged)
    header.InputEnded:Connect(onInputEnded)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            onInputChanged(input)
        end
    end)
    UserInputService.InputEnded:Connect(onInputEnded)

    local grip = Instance.new("Frame")
    grip.Name = "ResizeGrip"
    grip.Size = UDim2.new(0, 18, 0, 18)
    grip.AnchorPoint = Vector2.new(1, 1)
    grip.Position = UDim2.new(1, -6, 1, -6)
    grip.BackgroundTransparency = 0
    grip.BackgroundColor3 = Color3.fromRGB(30,30,32)
    grip.BorderSizePixel = 0
    grip.Parent = frame
    local gripCorner = Instance.new("UICorner")
    gripCorner.CornerRadius = UDim.new(0,6)
    gripCorner.Parent = grip

    local resizing = false
    local resizeInput = nil
    local resizeStart = nil
    local startSize = nil
    local MIN_SIZE = Vector2.new(300, 180)
    local MAX_SIZE = Vector2.new(math.max(300, Workspace.CurrentCamera.ViewportSize.X - 40), math.max(180, Workspace.CurrentCamera.ViewportSize.Y - 40))

    grip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeInput = input
            resizeStart = input.Position
            local absSize = frame.AbsoluteSize
            startSize = Vector2.new(absSize.X, absSize.Y)
            frame.Size = UDim2.new(0, startSize.X, 0, startSize.Y)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not resizing then return end
        if input ~= resizeInput then return end
        local delta = input.Position - resizeStart
        local newW = math.clamp(startSize.X + delta.X, MIN_SIZE.X, MAX_SIZE.X)
        local newH = math.clamp(startSize.Y + delta.Y, MIN_SIZE.Y, MAX_SIZE.Y)
        frame.Size = UDim2.new(0, math.floor(newW), 0, math.floor(newH))
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == resizeInput then
            resizing = false
            resizeInput = nil
            startSize = nil
        end
    end)
end

print("load success")

return ui
