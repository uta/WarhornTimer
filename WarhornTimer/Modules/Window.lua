function WarhornTimer:WindowApplySettings()
  self.window:SetWidth(self.settings.width)
  self.window:SetHeight(self.settings.height)
  self.window:ClearAnchors()
  self.window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.settings.offset.x, self.settings.offset.y)
  self.window:SetMouseEnabled(not self.settings.locked)
  self.window:SetMovable(not self.settings.locked)
  self.window.container:SetHidden(not self.settings.alwaysShow)
  self.window.background:SetEdgeColor(unpack(self.settings.colorEdge))
  self.window.background:SetCenterColor(unpack(self.settings.colorBackground))
  self.window.bar:SetGradientColors(unpack(self.settings.colorBar))
  self.window.label:SetFont('$(BOLD_FONT)|'..tostring(self.settings.textSize)..'|soft-shadow-thin')
  self.window.icon:SetHidden(not self.settings.showIcon)
  self.window.icon:SetWidth(self.settings.iconSize)
  self.window.icon:SetHeight(self.settings.iconSize)
  self.window.icon:SetTexture(self.settings.iconTexture)
end

function WarhornTimer:WindowCreate()
  self.window = WINDOW_MANAGER:CreateTopLevelWindow('WarhornTimerWindow')
  self.window:SetHandler('OnMoveStop', function() self:WindowMoved() end)
  self.window:SetClampedToScreen(true)

  self.window.container = WINDOW_MANAGER:CreateControl('$(parent)Container', self.window, CT_CONTROL)
  self.window.container:SetAnchorFill()

  self.window.background = WINDOW_MANAGER:CreateControl('$(parent)Background', self.window.container, CT_BACKDROP)
  self.window.background:SetAnchorFill()
  self.window.background:SetDrawLayer(1)
  self.window.background:SetEdgeTexture(nil, 1, 1, 1, 1)

  self.window.bar = WINDOW_MANAGER:CreateControl('$(parent)Bar', self.window.container, CT_STATUSBAR)
  self.window.bar:SetAnchorFill()
  self.window.bar:SetMinMax(0, 1)

  self.window.label = WINDOW_MANAGER:CreateControl('$(parent)Label', self.window.container, CT_LABEL)
  self.window.label:SetAnchorFill()
  self.window.label:SetVerticalAlignment(1)
  self.window.label:SetHorizontalAlignment(1)
  self.window.label:SetColor(1, 1, 1, 1)

  self.window.icon = WINDOW_MANAGER:CreateControl('$(parent)Icon', self.window.container, CT_TEXTURE)
  self.window.icon:SetAnchor(RIGHT, self.window.container, LEFT, -1,0)

  self:WindowSetValue(0)

  local fragment = ZO_SimpleSceneFragment:New(self.window)
  HUD_SCENE:AddFragment(fragment)
  HUD_UI_SCENE:AddFragment(fragment)
end

function WarhornTimer:WindowInitialize()
  self:WindowCreate()
  self:WindowApplySettings()
end

function WarhornTimer:WindowMoved()
  self.settings.offset.x = self.window:GetLeft()
  self.settings.offset.y = self.window:GetTop()
end

function WarhornTimer:WindowRefresh()
  if self.endTime ~= nil then
    local remainTime = self.endTime - GetFrameTimeSeconds()
    if remainTime < 0 then
      self:WindowStop()
    else
      self:WindowSetValue(remainTime)
    end
  end
end

function WarhornTimer:WindowSetValue(remainTime)
  self.window.bar:SetValue(remainTime)
  if self.settings.updateSpeed < 500 then
    self.window.label:SetText(('%02.01f'):format(remainTime))
  else
    self.window.label:SetText(('%d'):format(remainTime))
  end
end

function WarhornTimer:WindowStart(beginTime, endTime, iconName)
  local remainTime = endTime - beginTime
  if (remainTime > 0) and (self.endTime == nil or self.endTime < endTime) then
    local update = (self.endTime == nil)
    self.endTime = endTime
    self.window.bar:SetMinMax(0, remainTime)
    self:WindowSetValue(remainTime)
    self.window.icon:SetTexture(iconName)
    self.window.container:SetHidden(false)
    if update then
      EVENT_MANAGER:RegisterForUpdate(self.name, self.settings.updateSpeed, self.EventUpdate)
    end
  end
end

function WarhornTimer:WindowStop()
  EVENT_MANAGER:UnregisterForUpdate(self.name)
  self.endTime = nil
  self:WindowSetValue(0)
  self.window.container:SetHidden(not self.settings.alwaysShow)
end
